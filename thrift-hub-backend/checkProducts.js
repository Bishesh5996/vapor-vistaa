const mongoose = require('mongoose');
const Product = require('./models/Product');

mongoose.connect('mongodb://localhost:27017/vapor_vista')
.then(async () => {
  console.log('✅ Connected to MongoDB');
  
  const products = await Product.find({});
  console.log(`📦 Products in database: ${products.length}`);
  
  if (products.length > 0) {
    products.forEach(product => {
      console.log(`- ${product.name} - $${product.price} (Active: ${product.isActive}, Featured: ${product.isFeatured})`);
    });
  } else {
    console.log('❌ No products found in database');
  }
  
  process.exit(0);
})
.catch(err => {
  console.error('❌ Database connection error:', err.message);
  process.exit(1);
});
