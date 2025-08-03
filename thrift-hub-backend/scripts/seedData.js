const mongoose = require('mongoose');
const Product = require('../models/Product');
const User = require('../models/User');
require('dotenv').config();

const seedProducts = [
  {
    name: "SMOK Nord 4 Pod Kit",
    description: "Advanced pod system with RPM 2 coils and 2000mAh battery. Perfect for beginners and experienced vapers.",
    price: 34.99,
    compareAtPrice: 44.99,
    category: "starter-kits",
    brand: "SMOK",
    imageUrl: "https://images.unsplash.com/photo-1579952363873-27d3bfad9c0d?w=300&h=300&fit=crop",
    stockQuantity: 105,
    sku: "SMOK-NORD4-001",
    tags: ["pod", "starter", "beginner", "portable"],
    isFeatured: true,
    rating: 4.8,
    reviewCount: 234
  },
  {
    name: "Naked 100 Hawaiian POG 60ml",
    description: "Tropical blend of passion fruit, orange, and guava. Premium e-liquid with 70/30 VG/PG ratio.",
    price: 24.99,
    category: "e-liquids",
    brand: "Naked 100",
    imageUrl: "https://images.unsplash.com/photo-1544531586-fbd96ceaff1c?w=300&h=300&fit=crop",
    stockQuantity: 240,
    sku: "NAKED-HPOG-60ML",
    tags: ["tropical", "fruit", "sweet", "premium"],
    isFeatured: true,
    rating: 4.6,
    reviewCount: 156
  },
  {
    name: "GeekVape Aegis Legend 2 Mod",
    description: "IP68 rated waterproof mod with dual 18650 batteries. Military-grade durability meets advanced technology.",
    price: 59.99,
    compareAtPrice: 74.99,
    category: "devices",
    brand: "GeekVape",
    imageUrl: "https://images.unsplash.com/photo-1606984950584-c66b5a7a0cd5?w=300&h=300&fit=crop",
    stockQuantity: 45,
    sku: "GEEK-AEGIS-L2",
    tags: ["mod", "waterproof", "durable", "advanced"],
    isFeatured: true,
    rating: 4.9,
    reviewCount: 89
  },
  {
    name: "Freemax Mesh Pro Tank",
    description: "Sub-ohm tank with mesh coil technology for exceptional flavor and vapor production.",
    price: 29.99,
    category: "accessories",
    brand: "Freemax",
    imageUrl: "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=300&h=300&fit=crop",
    stockQuantity: 78,
    sku: "FREE-MESH-PRO",
    tags: ["tank", "mesh", "flavor", "clouds"],
    rating: 4.7,
    reviewCount: 67
  },
  {
    name: "Aspire Cleito Replacement Coils",
    description: "Pack of 5 replacement coils for Aspire Cleito tank. Available in 0.2ohm and 0.4ohm.",
    price: 15.99,
    category: "coils-parts",
    brand: "Aspire",
    imageUrl: "https://images.unsplash.com/photo-1574375927938-d5a98e8ffe85?w=300&h=300&fit=crop",
    stockQuantity: 200,
    sku: "ASP-CLEITO-COIL",
    tags: ["coils", "replacement", "aspire"],
    rating: 4.4,
    reviewCount: 234
  },
  {
    name: "Puff Bar Plus Disposable",
    description: "Disposable vape pen with 800+ puffs. No charging or refilling required.",
    price: 12.99,
    category: "disposables",
    brand: "Puff Bar",
    imageUrl: "https://images.unsplash.com/photo-1565701876971-b8d5ee5f4c79?w=300&h=300&fit=crop",
    stockQuantity: 500,
    sku: "PUFF-PLUS-DISP",
    tags: ["disposable", "convenience", "portable"],
    rating: 4.2,
    reviewCount: 445
  }
];

const seedUsers = [
  {
    name: "Admin User",
    email: "admin@vaporvista.com",
    password: "admin123",
    dateOfBirth: new Date("1990-01-01"),
    role: "admin",
    isVerified: true
  },
  {
    name: "Test User",
    email: "test@example.com", 
    password: "test123",
    dateOfBirth: new Date("1995-05-15"),
    role: "user",
    isVerified: true
  }
];

async function seedDatabase() {
  try {
    await mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/vapor_vista');
    console.log('Connected to MongoDB');

    // Clear existing data
    await Product.deleteMany({});
    await User.deleteMany({});
    console.log('Cleared existing data');

    // Seed products
    await Product.insertMany(seedProducts);
    console.log(`Seeded ${seedProducts.length} products`);

    // Seed users
    await User.insertMany(seedUsers);
    console.log(`Seeded ${seedUsers.length} users`);

    console.log('✅ Database seeded successfully!');
    console.log('\n📧 Test Accounts:');
    console.log('Admin: admin@vaporvista.com / admin123');
    console.log('User: test@example.com / test123');
    
    process.exit(0);
  } catch (error) {
    console.error('❌ Seeding failed:', error);
    process.exit(1);
  }
}

seedDatabase();
