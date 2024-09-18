const express = require("express");
const authenticateToken = require("../middlewares/auth")

const {
    createProduct,
    getProduct,
    getProducts,
    updateProduct,
    deleteProduct
} = require("../controllers/productController");
const router = express.Router();

router.get('/products',getProducts);
router.get('/product/:id',getProduct);
router.post('/product',authenticateToken,createProduct);
router.put('/product/:id',authenticateToken,updateProduct);
router.delete('/product/:id',authenticateToken,deleteProduct);

module.exports = router;