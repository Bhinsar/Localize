const {supabase} = require("../utils/supabase");
const { translateJsonData } = require("../utils/translateJsonData");

exports.addServices = async (req, res) => {
    try{
        const { name, category } = req.body;

        // Validate input
        if (!name || !category) {
            return res.status(400).json({ error: "Name and category are required." });
        }

        // Insert service into the database
        const { data, error } = await supabase
            .from("services")
            .insert([{ name, category }])
            .select();

        if (error) {
            console.error("Error adding service:", error);
            return res.status(500).json({ error: "Failed to add service." });
        }

        return res.status(201).json({ service: data });
    }catch(error){
        console.error("Error adding service:", error);
        return res.status(500).json({ error: "Internal server error." });
    }
}

exports.getServices = async (req, res) => {
    try {
        const {language} = req.headers;0
        const { data, error } = await supabase
            .from("services")
            .select("*");
         if (language && language.toLowerCase() !== 'en' && language.toLowerCase() !== 'english') {
            try {
                // Await the translation
                const translatedData = await translateJsonData(data, language);
                return res.status(200).json({ services: translatedData });
            } catch (translationError) {
                console.error("Translation failed, returning original data.", translationError);
                return res.status(200).json({ services: data });
            }
        }
        if (error) {
            return res.status(500).json({ error: "Failed to retrieve services." });
        }

        return res.status(200).json({ services: data });
    } catch (error) {
        console.error("Error retrieving services:", error);
        return res.status(500).json({ error: "Internal server error." });
    }
}