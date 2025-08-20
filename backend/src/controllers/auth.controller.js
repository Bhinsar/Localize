const e = require("cors");
const {supabase} = require("../utils/supabase");
const fs = require('fs').promises;
const path = require('path');

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

        let avatar_url = null;

        // Step 2: Upload avatar if provided
        if (req.file) {
            const filePath = path.join(__dirname, "../uploads", req.file.filename);
            const fileBuffer = await fs.readFile(filePath);

            const { data: uploadData, error: uploadError } = await supabase.storage
                .from("avatars")
                .upload(`uploads/${req.file.filename}`, fileBuffer, {
                    contentType: req.file.mimetype,
                    upsert: true,
                });

            if (uploadError) throw uploadError;

            avatar_url = `${process.env.SUPABASE_URL}/storage/v1/object/public/avatars/${uploadData.path}`;

            await fs.unlink(filePath);
        }

        // Step 3: Add the user's profile to the public.profiles table
        const { error: profileError } = await supabase
            .from("profiles")
            .insert({ 
                id: authData.user.id,
                full_name,
                phone_number,
                avatar_url
            });

        if (profileError) throw profileError;

        // Step 4: Return success with tokens
        const token = authData.session?.access_token;
        const refreshToken = authData.session?.refresh_token;

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

exports.refreshToken = async (req, res) => {
    try {
        const { refreshToken } = req.body;
        
        const { data, error } = await supabase.auth.refreshSession({ refresh_token: refreshToken });

        if (error) throw error;

        res.status(200).json({ data });
    } catch (error) {
        console.error("Error refreshing token:", error);
        res.status(500).json({ error: "Internal Server Error" });
    }
};

exports.signInWithGoogle = async (req, res) => {
    try{
        const{id_token} = req.body;
        if(!id_token) {
            return res.status(400).json({ error: "ID token is required" });
        }
        const{data: authData, error: authError} = await supabase.auth.signInWithOAuth({
            provider: 'google',
            id_token
        });

        if (authError) throw authError;

        const user = authData.user;
        if (!user) {
            return res.status(400).json({ error: "Authentication failed: No user returned" });
        }

        const{ data: existingProfile, error: profileError } = await supabase
            .from("profiles")
            .select("*")
            .eq("id", user.id)
            .single();

        if (profileError) throw profileError;

        if(!existingProfile){
            const { error: insertError } = await supabase
                .from("profiles")
                .insert({
                    id: user.id,
                    full_name: user.user_metadata.full_name,
                    avatar_url: user.user_metadata.avatar_url
                });

            if (insertError) throw insertError;
        }

        res.status(200).json({ 
            message: "User signed in successfully.",
            user: authData.user,
            token: authData.session.access_token,
            refreshToken: authData.session.refresh_token
        });
    } catch (error) {
        console.error("Error signing in with Google:", error);
        res.status(500).json({ error: "Internal Server Error" });
    }
}