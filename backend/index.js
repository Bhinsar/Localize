const express = require('express');
require('dotenv').config();
const { supabase } = require('./src/utils/supabase');
const path =  require('path');
const {readdirSync} = require('fs');

const app = express();
app.use(express.json());

const PORT = process.env.PORT || 8080;

if(supabase){
  console.log('Supabase client is initialized');
}else{
  console.log('Supabase client is not initialized');
}

const routesPath = path.join(__dirname, 'src', 'routes');

readdirSync(routesPath).map((r)=>
  app.use('/api', require(`${routesPath}/${r}`))
)

app.get("/", (req, res) => {
  res.send("Server is running");
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

module.exports = app;