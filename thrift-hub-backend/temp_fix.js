// Update the /api/package endpoint in server.js
app.get('/api/package', async (req, res) => {
  try {
    console.log('📦 GET /api/package - Trek app requesting packages...');
    
    const Product = require('./models/Product');
    const products = await Product.find({ status: 'active' });
    
    const packages = products.map(product => ({
      id: product._id.toString(),
      name: product.name,
      description: product.description,
      price: product.price.toString(),
      image: product.imageUrl,
      category: product.category,
      rating: product.rating || 4.5,
      duration: "1-2 days",
      difficulty: "Easy",
      location: "Vapor Store"
    }));

    console.log(`📦 Returning ${packages.length} packages to Trek app`);
    
    // FIXED: Return as array, not object with packages property
    res.json(packages);

  } catch (error) {
    console.error('❌ Package endpoint error:', error);
    res.status(500).json([]);
  }
});
