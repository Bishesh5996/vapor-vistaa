const express = require('express');
const Product = require('../models/Product');

const router = express.Router();

// Debug route to check database connection
router.get('/debug', async (req, res) => {
  try {
    const total = await Product.countDocuments();
    const active = await Product.countDocuments({ isActive: true });
    const featured = await Product.countDocuments({ isFeatured: true });
    
    res.json({
      message: 'Debug info',
      database: {
        totalProducts: total,
        activeProducts: active,
        featuredProducts: featured
      }
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get all products
router.get('/', async (req, res) => {
  try {
    console.log('📦 API: Getting products...');
    
    const products = await Product.find({});
    console.log(`📊 Found ${products.length} total products`);
    
    const activeProducts = products.filter(p => p.isActive !== false);
    console.log(`✅ Active products: ${activeProducts.length}`);
    
    res.json({
      products: activeProducts,
      pagination: {
        current: 1,
        pages: 1,
        total: activeProducts.length,
        hasNext: false,
        hasPrev: false
      }
    });
  } catch (error) {
    console.error('❌ Products error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
});

// Package endpoint for Trek app compatibility - FIXED POSITION
router.get('/package', async (req, res) => {
  try {
    console.log('📦 GET /api/products/package - Trek app requesting packages...');
    
    const products = await Product.find({ isActive: true });
    
    const packages = products.map(product => ({
      _id: product._id,
      id: product._id,
      name: product.name,
      description: product.description,
      price: product.price,
      image: product.imageUrl,
      category: product.category,
      rating: product.rating || 4.5,
      duration: "1-2 days",
      difficulty: "Easy",
      location: "Vapor Store"
    }));
    
    console.log(`📦 Returning ${packages.length} packages to Trek app`);
    res.json({ packages });
    
  } catch (error) {
    console.error('❌ Package endpoint error:', error);
    res.status(500).json({ message: 'Server error', packages: [] });
  }
});

// Get featured products
router.get('/featured/list', async (req, res) => {
  try {
    console.log('⭐ API: Getting featured products...');
    
    const featuredProducts = await Product.find({ isFeatured: true });
    console.log(`⭐ Found ${featuredProducts.length} featured products`);
    
    res.json({ products: featuredProducts });
  } catch (error) {
    console.error('❌ Featured error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
});

// Get single product
router.get('/:id', async (req, res) => {
  try {
    const product = await Product.findById(req.params.id);
    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }
    res.json({ product });
  } catch (error) {
    console.error('❌ Single product error:', error);
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;
