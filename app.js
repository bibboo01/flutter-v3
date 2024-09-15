const express = require('express');
const mongoose = require('mongoose');
const dotenv = require('dotenv');
const app = express();
dotenv.config();
app.use(express.json());


mongoose.connect(process.env.MongoDB_URI)
    .then(() => console.log("MONGO_DB connected"))
    .catch(err => console.log(err));

const productRoutes = require('./routes/product');
const authRoute = require('./routes/auth');
app.use("/api", productRoutes);
app.use("/api/auth", authRoute);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on localhost:` + PORT));