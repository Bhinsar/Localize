const e = require("cors");
const {supabase} = require("../utils/supabase");
const fs = require('fs').promises;
const path = require('path');
const { translateJsonData } = require("../utils/translateJsonData");
const { error } = require("console");

exports.registerUser = async (req, res) => {
    try {
        const { email, password, full_name } = req.body;
        const {language} = req.language
        const { data: authData, error: authError } = await supabase.auth.signUp({
            email,
            password,
        });

        if (authError){
            return res.status(400).json({ error: authError.message });
        }
        if (!authData.user) throw new Error("Registration failed: No user returned");

        let storeName = full_name;
        
        if(language != 'en'|| language.toLowerCase() != "english"){
            const nameToTranslate = {name: storeName};
            const translate = await translateJsonData(nameToTranslate,'en');
            if(!translate){
                throw new Error("Error translating the name");
            }else{
                storeName = translate.name;
            }
        }

        const { error: profileError } = await supabase
            .from("profiles")
            .insert({ 
                id: authData.user.id,
                full_name: storeName,
            });

        if (profileError) throw profileError;

        res.status(201).json({ 
            message: "User registered successfully.",
            user: authData.user,
            token: authData.session.access_token,
            refreshToken: authData.session.refresh_token
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

        if (error) {
            return res.status(400).json({ error: error.message });
        }

        const token = data.session.access_token;
        const refreshToken = data.session.refresh_token;

        const { data: profileData, error: profileError } = await supabase
            .from("profiles")
            .select("*")
            .eq("id", data.user.id)
            .single();

        if (profileError) {
            return res.status(400).json({ error: profileError.message });
        }

        let existNumber = false;
        let role = profileData.role || null;

        if (profileData.phone_number !== null) {
            existNumber = true;
        }
        let bios = false
        if(profileData.role == "provider") {
            const {data: providerData, error: providerError} = await supabase
                .from("provider_details")
                .select("*")
                .eq("user_id", profileData.id)
                .single();

            if (providerError) {
                console.error("Error fetching provider details:", providerError);
            } else {
                bios = providerData ? true : false;
            }
        }

        res.status(200).json({ user:data, token, refreshToken, existNumber, role, bios });
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
        console.log("Signing in with Google...");
        const { id_token } = req.body;
        if(!id_token) {
            return res.status(400).json({ error: "ID token is required" });
        }
        const{data: authData, error: authError} = await supabase.auth.signInWithIdToken({
            provider: 'google',
            token: id_token
        });        

        if (authError) {
            throw authError;
        }

        const user = authData.user;
        if (!user) {
            return res.status(400).json({ error: "Authentication failed: No user returned" });
        }

        const{ data: existingProfile, error: profileError } = await supabase
            .from("profiles")
            .select("*")
            .eq("id", user.id)
            .maybeSingle();

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
        let existNumber = false;
        let role = null;

        if (existingProfile && existingProfile.phone_number !== null) {
            existNumber = true;
            role = existingProfile.role;
        }

        let bios = false;

        if (existingProfile && existingProfile.role === "provider") {
            const { data: providerData, error: providerError } = await supabase
                .from("provider_details")
                .select("*")
                .eq("user_id", existingProfile.id)
                .single();

            if (providerError) {
                console.error("Error fetching provider details:", providerError);
            } else {
                bios = providerData ? true : false;
            }
        }

        res.status(200).json({ 
            message: "User signed in successfully.",
            user: authData.user,
            token: authData.session.access_token,
            refreshToken: authData.session.refresh_token,
            existNumber,
            role,
            bios
        });
    } catch (error) {
        console.error("Error signing in with Google:", error);
        res.status(500).json({ error: "Internal Server Error" });
    }
}

exports.addNumberAndRole = async (req, res) => {
    try{
        const userId = req.user.id;
        const { phone_number, role } = req.body;

        // Validate input
        if (!phone_number || !role) {
            return res.status(400).json({ error: "All fields are required" });
        }

        const {data: existingProfile} = await supabase
            .from("profiles")
            .select("*")
            .eq("phone_number", phone_number)
            .maybeSingle();
        
        if(existingProfile && existingProfile.id !== userId){
            return res.status(400).json({ error: "Phone number is already in use by another user" });
        }

        // Add number and role to the user's profile
        const { data, error } = await supabase
            .from("profiles")
            .update({ phone_number: "+91" + phone_number, role })
            .eq("id", userId)
            .select();
        
        if (error) {
            console.error("Error updating profile:", error);
            throw error;
        }        

        res.status(200).json({ message: "Number and role added successfully.", data });
    }catch(error){
        console.error("Error adding number and role:", error);
        res.status(500).json({ error: "Internal Server Error" });
    }
}

exports.getUserProfile = async (req, res) => {
    try {
        const { id } = req.user;
        const {language} = req.headers;

        let { data: profiles, error: profileError } = await supabase
            .from("profiles")
            .select("*")
            .eq("id", id)
            .single();

        if (profileError) {
            throw profileError;
        }

        let providerDetails = null;

        if (profiles.role === "provider") {
            const { data: provider, error: providerError } = await supabase
                .from("provider_details")
                .select("*, profiles(*), services(*)")
                .eq("user_id", id)
                .single();

            if (providerError) {
                throw providerError;
            }
            providerDetails = provider;
        }

        const dataToTranslate = {};
        if (profiles.full_name) {
            dataToTranslate.full_name = profiles.full_name;
        }
        if (providerDetails?.bio) { 
            dataToTranslate.bio = providerDetails.bio;
            dataToTranslate.service_name =providerDetails.services.name;
        }

        if (language.toLowerCase() !== 'en' && Object.keys(dataToTranslate).length > 0) {
            const translatedData = await translateJsonData(dataToTranslate, language);

            if (translatedData) {                
                if (providerDetails) {
                    providerDetails.bio = translatedData.bio || providerDetails.bio;
                    providerDetails.profiles.full_name = translatedData.full_name || providerDetails.profiles.full_name;
                    providerDetails.services.name = translatedData.service_name || providerDetails.services.name;
                }else{
                    profiles.full_name = translatedData.full_name || profiles.full_name;
                }
            }
        }

        let responseData = {};
        if (providerDetails) {
            responseData = providerDetails;
        }else{
            responseData = profiles;
        }

        return res.status(200).json(responseData);

    } catch (e) {
        console.log("error getting user profile", e);
        return res.status(500).json({ error: "Internal server error" });
    }
}