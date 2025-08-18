const {supabase} = require("../utils/supabase");

exports.registerUser = async (req, res) => {
    try {
        const { email, password, full_name, phone_number } = req.body;

        // Step 1: Sign up the user in Supabase Auth
        const { data: authData, error: authError } = await supabase.auth.signUp({
            email,
            password,
        });

        if (authError) throw authError;
        if (!authData.user) throw new Error("Registration failed: No user returned");

        // Step 2: Add the user's profile to the public.profiles table
        const { error: profileError } = await supabase
            .from('profiles')
            .insert({ 
                id: authData.user.id,
                full_name,
                phone_number,
            });

        if (profileError) throw profileError;

        const token  =  authData.session.access_token;
        const refreshToken = authData.session.refresh_token;
        res.status(201).json({ 
            message: "User registered successfully.",
            user: authData.user,
            token,
            refreshToken
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.loginUser = async (req, res) => {
    try {
        const { email, password } = req.body;
        const { data, error } = await supabase.auth.signInWithPassword({
            email: email,
            password: password,
        });

        if (error) throw error;

        const token = data.session.access_token;
        const refreshToken = data.session.refresh_token;

        res.status(200).json({ data, token, refreshToken });
    } catch (error) {
        console.error("Error logging in user:", error);
        res.status(500).json({ error: "Internal Server Error" });
    }
}