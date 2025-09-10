const haversineDistance = require("haversine-distance");
const { supabase } = require("../utils/supabase");
const { translateJsonData } = require("../utils/translateJsonData");

exports.registerProvider = async (req, res) => {
  try {
    const { language } = req.headers || "en";
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
    const { language } = req.headers || "en";
    const {
      search,
      category,
      serviceId,
      minPrice,
      maxPrice,
      minRating,
      page = 1,
      limit = 10,
      latitude,
      longitude,
    } = req.query;

    let searchTerm = search ? search.trim() : null;
    if (
      search &&
      language &&
      language.toLowerCase() !== "en" &&
      language.toLowerCase() !== "english"
    ) {
      try{

        const translateSearch = await translateJsonData({ search }, "en");
        searchTerm = translateSearch.search.trim();
      }catch(e){
        throw e;
      }
    }

    const pageNum = parseInt(page, 10);
    const limitNum = parseInt(limit, 10);

    const rpcParams = {
      search_term: searchTerm,
      service_cat: category || null,
      service_id_filter: serviceId ? parseInt(serviceId) : null,
      min_p: minPrice ? parseFloat(minPrice) : null,
      max_p: maxPrice ? parseFloat(maxPrice) : null,
      user_lat: latitude ? parseFloat(latitude) : null,
      user_lon: longitude ? parseFloat(longitude) : null,
      min_avg_rating: minRating ? parseFloat(minRating) : null, // New: pass minRating to the SQL function
      page_limit: limitNum,
      page_offset: (pageNum - 1) * limitNum,
    };

    const { data, error } = await supabase.rpc("get_providers", rpcParams);

    if (error) {
      console.error("Supabase RPC error:", error);
      return res.status(500).json({
        message: "Failed to fetch providers.",
        details: error.message,
      });
    }

    const totalCount = data.length > 0 ? data[0].total_count : 0;
    const storesData = data;

    if (
      language &&
      language.toLowerCase() !== "en" &&
      language.toLowerCase() !== "english"
    ) {
      for (const item of storesData) {
        const transleteData = {
          name: item.full_name,
        };

        try {
          const translatedResult = await translateJsonData(
            transleteData,
            language
          );

          if (translatedResult) {
            item.full_name = translatedResult.name;
          }
        } catch (error) {
          console.error(`Failed to translate item with id: ${item.id}`, error);
        }
      }
    }

    res.status(200).json({
      data: storesData,
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

//get provider by id
exports.getProviderByID = async (req, res) => {
  try {
    const { id } = req.params; 
    const { language } = req.headers || 'en';

    if (!id) {
      return res.status(404).json({ error: "User ID is required" });
    }

    const { data: provider, error: providerError } = await supabase
      .from("provider_details")
      .select("*, profiles(*), services(*)")
      .eq("id", id)
      .single();

    if (providerError || !provider) {
      throw providerError || new Error("Provider not found");
    }

    const { data: reviews, error: reviewError } = await supabase
      .from("reviews")
      .select("rating, bookings!inner(provider_id)")
      .eq("bookings.provider_id", provider.id);     

    if (reviewError) {
      throw reviewError;
    }

    const totalReviews = reviews.length;
    const averageRating = totalReviews > 0
        ? reviews.reduce((sum, review) => sum + review.rating, 0) / totalReviews
        : 0;


    const storedProviders = provider;

    if (language && !["en", "english"].includes(language.toLowerCase())) {
      const translatedData = {
        name: storedProviders.profiles.full_name,
        bio: storedProviders.bio,
        serviceName: storedProviders.services.name
      };
      try {
        const translate = await translateJsonData(translatedData, language);
        if (translate) {
          storedProviders.profiles.full_name = translate.name;
          storedProviders.bio = translate.bio;
          storedProviders.services.name = translate.serviceName;
        }
      } catch (translateError) {
        console.error("Translation failed:", translateError);
      }
    }

    return res.status(200).json({
      provider: storedProviders,
      rating_summary: {
        average: parseFloat(averageRating.toFixed(1)),
        total_reviews: totalReviews,
      },
    });

  } catch (error) {
    console.error("Error in getting provider:", error.message);
    if (error.message === "Provider not found") {
      return res.status(404).json({ error: error.message });
    }
    return res.status(500).json({ error: "Internal server error" });
  }
};
