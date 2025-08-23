const e = require("cors");
const {supabase} = require("../utils/supabase");
const fs = require('fs').promises;
const path = require('path');

exports.registerUser = async (req, res) => {
    try {
        const { email, password, full_name } = req.body;

        // Step 1: Sign up the user in Supabase Auth
        const { data: authData, error: authError } = await supabase.auth.signUp({
            email,
            password,
        });

        if (authError){
            return res.status(400).json({ error: authError.message });
        }
        if (!authData.user) throw new Error("Registration failed: No user returned");
        const { error: profileError } = await supabase
            .from("profiles")
            .insert({ 
                id: authData.user.id,
                full_name,
            });

        if (profileError) throw profileError;

        res.status(201).json({ 
            message: "User registered successfully.",
            user: authData.user,
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

        const existNumber = !!data.user.phone_number;

        res.status(200).json({ data, token, refreshToken, existNumber });
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

        res.status(200).json({ token: data.session.access_token, refreshToken: data.session.refresh_token });
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

        const numberExists = !!existingProfile.phone_number;

        res.status(200).json({ 
            message: "User signed in successfully.",
            user: authData.user,
            numberExists
        });
    } catch (error) {
        console.error("Error signing in with Google:", error);
        res.status(500).json({ error: "Internal Server Error" });
    }
}

exports.addNumberAndRole = async (req, res) => {
    try{
        const { userId, phone_number, role } = req.body;

        // Validate input
        if (!userId || !number || !role) {
            return res.status(400).json({ error: "All fields are required" });
        }

        // Add number and role to the user's profile
        const { data, error } = await supabase
            .from("profiles")
            .update({ phone_number, role })
            .eq("id", userId);

        if (error) throw error;

        res.status(200).json({ message: "Number and role added successfully.", data });
    }catch(error){
        console.error("Error adding number and role:", error);
        res.status(500).json({ error: "Internal Server Error" });
    }
}
