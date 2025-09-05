const { GoogleGenerativeAI } = require("@google/generative-ai");

// Initialize the Google AI Client
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

/**
 * A helper function to translate JSON data using the Gemini Pro API.
 * @param {object | object[]} data The JSON data to translate.
 * @param {string} targetLanguage The language to translate the data into.
 * @returns {Promise<object | object[]>} The translated JSON data.
 */
exports.translateJsonData = async function (data, targetLanguage) {
    try {
        const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash-latest" });
        const dataString = JSON.stringify(data, null, 2);
        const prompt = `
            You are a JSON translation expert.
            Your task is to translate the string values within the following JSON object from English into ${targetLanguage}.
            IMPORTANT RULES:
            1. Only translate the text values.
            2. Do NOT translate the JSON keys (e.g., "name", "description").
            3. Maintain the exact original JSON structure.
            4. The output must be a valid JSON object only, without any surrounding text or explanations.
            Here is the JSON data to translate:
            \`\`\`json
            ${dataString}
            \`\`\`
        `;

        const result = await model.generateContent(prompt);
        const response = await result.response;
        let translatedText = response.text();

        const match = translatedText.match(/```json\s*([\s\S]*?)\s*```/);

        const jsonToParse = match ? match[1] : translatedText;

        return JSON.parse(jsonToParse);


    } catch (error) {
        console.error("Error during translation:", error);
        throw new Error("Failed to translate data.");
    }
}