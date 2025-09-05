const { supabase } = require("../utils/supabase");
const { translateJsonData } = require("../utils/translateJsonData");

exports.registerProvider = async (req, res) => {
  try {
    const {language} = req.headers;
    const {id} = req.user;
    const {service_id, bio, availability_schedule,  price, price_unit, location} = req.body;

    
    // Validate input
    if (!service_id || !bio || !availability_schedule || !location || !price || !price_unit) {
        return res.status(400).json({ error: "All fields are required." });
    }

    let bioToStore = bio;
        const languageCode = language ? language.toLowerCase() : 'en';

        // Translate only if the language is not English
        if (languageCode !== 'en') {
            try {
                const dataToTranslate = { bio: bio };
                const translatedData = await translateJsonData(dataToTranslate, 'en');
                
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
            .insert([{ user_id: id, service_id, bio: bioToStore, availability_schedule, location, price, price_unit }]);

    if (error) {
        return res.status(500).json({ error: "Failed to register provider." });
    }

    return res.status(201).json({ provider });
  } catch (error) {
    console.error("Error registering provider:", error);
    return res.status(500).json({ error: "Internal server error." });
  }
};
