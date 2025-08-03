
// Package endpoint for Trek app compatibility - FIXED
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
