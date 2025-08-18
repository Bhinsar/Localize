const {supabase} = require("../utils/supabase");

exports.authCheck = async (req, res, next) => {
    try {
        const token = req.headers.authorization?.split(" ")[1];
        if (!token) throw new Error("No token provided");

        const { data, error } = await supabase.auth.getUser(token);
        if (error) throw error;

        req.user = data.user;
        next();
    } catch (error) {
        res.status(401).json({ error: "Unauthorized" });
    }
}