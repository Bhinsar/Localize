const haversineDistance = require("haversine-distance");
const { supabase } = require("../utils/supabase");
const { translateJsonData } = require("../utils/translateJsonData");

exports.registerProvider = async (req, res) => {
  try {
    const { language } = req.headers;
    const { id } = req.user;
    const {
      service_id,
      bio,
      availability_schedule,
      price,
      price_unit,
      location,
    } = req.body;

    // Validate input
    if (
      !service_id ||
      !bio ||
      !availability_schedule ||
      !location ||
      !price ||
      !price_unit
    ) {
      return res.status(400).json({ error: "All fields are required." });
    }

    let bioToStore = bio;
    const languageCode = language ? language.toLowerCase() : "en";

    if (languageCode !== "en") {
      try {
        const dataToTranslate = { bio: bio };
        const translatedData = await translateJsonData(dataToTranslate, "en");

        if (translatedData && translatedData.bio) {
          bioToStore = translatedData.bio;
        }
      } catch (e) {
        console.error("Error translating bio:", e);
        return res.status(500).json({ error: "Failed to translate bio" });
      }
    }

    const { data: provider, error } = await supabase
      .from("provider_details")
      .insert([
        {
          user_id: id,
          service_id,
          bio: bioToStore,
          availability_schedule,
          location,
          price,
          price_unit,
        },
      ]);

    if (error) {
      throw error;
    }

    return res.status(201).json({ provider });
  } catch (error) {
    console.error("Error registering provider:", error);
    return res.status(500).json({ error: "Internal server error." });
  }
};

exports.getProviderToUser = async (req, res) => {
  try {
    const { language } = req.headers;
    const {
      search,
      category,
      serviceId,
      minPrice,
      maxPrice,
      page = 1,
      limit = 10,
      latitude,
      longitude,
    } = req.query;

    let searchTerm = search ? search.trim() : null;

    // Handle translation if needed
    if (
      search &&
      language &&
      language.toLowerCase() !== "en" &&
      language.toLowerCase() !== "english"
    ) {
      const translateSearch = await translateJsonData({ search }, "en");
      searchTerm = translateSearch.search.trim();
    }

    const pageNum = parseInt(page, 10);
    const limitNum = parseInt(limit, 10);

    // Prepare parameters for the RPC call. Names must match the SQL function.
    const rpcParams = {
      search_term: searchTerm,
      service_cat: category || null,
      service_id_filter: serviceId ? parseInt(serviceId) : null,
      min_p: minPrice ? parseFloat(minPrice) : null,
      max_p: maxPrice ? parseFloat(maxPrice) : null,
      user_lat: latitude ? parseFloat(latitude) : null,
      user_lon: longitude ? parseFloat(longitude) : null,
      page_limit: limitNum,
      page_offset: (pageNum - 1) * limitNum,
    };

    // Make the single RPC call
    const { data, error } = await supabase.rpc("get_providers", rpcParams);

    if (error) {
      console.error("Supabase RPC error:", error);
      return res.status(500).json({
        message: "Failed to fetch providers.",
        details: error.message,
      });
    }

    const totalCount = data.length > 0 ? data[0].total_count : 0;

    let storesData = data;
    if(language && language.toLowerCase() !== "en" && language.toLowerCase !== "english"){
      const transleteData = {
        bio: storesData.bio,
        name
      }
    }

    res.status(200).json({
      data,
      pagination: {
        total: totalCount,
        page: pageNum,
        limit: limitNum,
        totalPages: Math.ceil(totalCount / limitNum),
      },
    });
  } catch (error) {
    res.status(500).json({
      message: "An unexpected server error occurred.",
      details: error.message,
    });
  }
};
