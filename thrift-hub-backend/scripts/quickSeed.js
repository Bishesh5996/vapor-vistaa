const mongoose = require('mongoose');
require('dotenv').config();

const productSchema = new mongoose.Schema({
  name: String,
  description: String,
  price: Number,
  compareAtPrice: Number,
  category: String,
  brand: String,
  imageUrl: String,
  inStock: Boolean,
  stockQuantity: Number,
  rating: Number,
  reviewCount: Number,
  sku: String,
  tags: [String],
  isActive: Boolean,
  isFeatured: Boolean
}, { timestamps: true });

const Product = mongoose.model('Product', productSchema);

const sampleProducts = [
  {
    name: "SMOK Nord 4 Pod Kit",
    description: "Advanced pod system with RPM 2 coils and 2000mAh battery.",
    price: 34.99,
    category: "starter-kits",
    brand: "SMOK",
    imageUrl: "https://images.unsplash.com/photo-1579952363873-27d3bfad9c0d?w=300",
    inStock: true,
    stockQuantity: 105,
    rating: 4.8,
    reviewCount: 234,
    sku: "SMOK-NORD4-001",
    tags: ["pod", "starter", "beginner"],
    isActive: true,
    isFeatured: true
  },
  {
    name: "Naked 100 Hawaiian POG 60ml",
    description: "Tropical blend of passion fruit, orange, and guava.",
    price: 24.99,
    category: "e-liquids",
    brand: "Naked 100",
    imageUrl: "https://images.unsplash.com/photo-1544531586-fbd96ceaff1c?w=300",
    inStock: true,
    stockQuantity: 240,
    rating: 4.6,
    reviewCount: 156,
    sku: "NAKED-HPOG-60ML",
    tags: ["tropical", "fruit", "premium"],
    isActive: true,
    isFeatured: true
  },
  {
    name: "GeekVape Aegis Legend 2",
    description: "Waterproof mod with dual 18650 batteries.",
    price: 59.99,
    category: "devices",
    brand: "GeekVape",
    imageUrl: "https://images.unsplash.com/photo-1606984950584-c66b5a7a0cd5?w=300",
    inStock: true,
    stockQuantity: 45,
    rating: 4.9,
    reviewCount: 89,
    sku: "GEEK-AEGIS-L2",
    tags: ["mod", "waterproof", "durable"],
    isActive: true,
    isFeatured: true
  }
];

async function seedProducts() {
  try {
    await mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/vapor_vista');
    console.log('✅ Connected to MongoDB');

    await Product.deleteMany({});
    console.log('🗑️ Cleared existing products');

    const inserted = await Product.insertMany(sampleProducts);
    console.log(`✅ Added ${inserted.length} products`);

    process.exit(0);
  } catch (error) {
    console.error('❌ Error:', error);
    process.exit(1);
  }
}

seedProducts();
