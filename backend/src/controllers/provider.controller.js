const { supabase } = require("../utils/supabase");

exports.registerProvider = async (req, res) => {
  try {
    const {id} = req.user;
    const {service_id, bio, availability_schedule,  price, price_unit, location} = req.body;

    // Validate input
    if (!service_id || !bio || !availability_schedule || !location || !price || !price_unit) {
        return res.status(400).json({ error: "All fields are required." });
    }

    if (updatedUserError) {
        return res.status(500).json({ error: "Failed to update user profile." });
    }

    // Insert provider into the database
    const { data, error } = await supabase
        .from("provider_details")
        .insert([{ user_id: id, service_id, bio, availability_schedule, location, price, price_unit }]);

    if (error) {
        return res.status(500).json({ error: "Failed to register provider." });
    }

    return res.status(201).json({ provider });
  } catch (error) {
    console.error("Error registering provider:", error);
    return res.status(500).json({ error: "Internal server error." });
  }
};
