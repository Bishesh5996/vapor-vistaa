const mongoose = require('mongoose');
require('dotenv').config();

// Import models
const Product = require('../models/Product');
const User = require('../models/User');

const sampleProducts = [
  {
    name: "SMOK Nord 4 Pod Kit",
    description: "Advanced pod system with RPM 2 coils and 2000mAh battery. Perfect for beginners and experienced vapers with dual air intake system.",
    price: 34.99,
    compareAtPrice: 44.99,
    category: "starter-kits",
    brand: "SMOK",
    imageUrl: "https://images.unsplash.com/photo-1579952363873-27d3bfad9c0d?w=300&h=300&fit=crop&auto=format",
    inStock: true,
    stockQuantity: 105,
    rating: 4.8,
    reviewCount: 234,
    sku: "SMOK-NORD4-001",
    tags: ["pod", "starter", "beginner", "portable", "dual-coil"],
    isActive: true,
    isFeatured: true
  },
  {
    name: "Naked 100 Hawaiian POG 60ml",
    description: "Tropical blend of passion fruit, orange, and guava. Premium e-liquid with 70/30 VG/PG ratio for smooth vapor production.",
    price: 24.99,
    category: "e-liquids",
    brand: "Naked 100",
    imageUrl: "https://images.unsplash.com/photo-1544531586-fbd96ceaff1c?w=300&h=300&fit=crop&auto=format",
    inStock: true,
    stockQuantity: 240,
    rating: 4.6,
    reviewCount: 156,
    sku: "NAKED-HPOG-60ML",
    tags: ["tropical", "fruit", "sweet", "premium", "70vg"],
    isActive: true,
    isFeatured: true
  },
  {
    name: "GeekVape Aegis Legend 2 Mod",
    description: "IP68 rated waterproof mod with dual 18650 batteries. Military-grade durability meets advanced technology with AS Chipset 3.0.",
    price: 59.99,
    compareAtPrice: 74.99,
    category: "devices",
    brand: "GeekVape",
    imageUrl: "https://images.unsplash.com/photo-1606984950584-c66b5a7a0cd5?w=300&h=300&fit=crop&auto=format",
    inStock: true,
    stockQuantity: 45,
    rating: 4.9,
    reviewCount: 89,
    sku: "GEEK-AEGIS-L2",
    tags: ["mod", "waterproof", "durable", "advanced", "dual-battery"],
    isActive: true,
    isFeatured: true
  },
  {
    name: "Freemax Mesh Pro Tank",
    description: "Sub-ohm tank with innovative mesh coil technology for exceptional flavor and massive vapor production. 6ml capacity.",
    price: 29.99,
    category: "accessories",
    brand: "Freemax",
    imageUrl: "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=300&h=300&fit=crop&auto=format",
    inStock: true,
    stockQuantity: 78,
    rating: 4.7,
    reviewCount: 67,
    sku: "FREE-MESH-PRO",
    tags: ["tank", "mesh", "flavor", "clouds", "6ml"],
    isActive: true,
    isFeatured: false
  },
  {
    name: "Aspire Cleito Replacement Coils",
    description: "Pack of 5 replacement coils for Aspire Cleito tank. Available in 0.2ohm and 0.4ohm resistance for different vaping styles.",
    price: 15.99,
    category: "coils-parts",
    brand: "Aspire",
    imageUrl: "https://images.unsplash.com/photo-1574375927938-d5a98e8ffe85?w=300&h=300&fit=crop&auto=format",
    inStock: true,
    stockQuantity: 200,
    rating: 4.4,
    reviewCount: 234,
    sku: "ASP-CLEITO-COIL",
    tags: ["coils", "replacement", "aspire", "5-pack"],
    isActive: true,
    isFeatured: false
  },
  {
    name: "Puff Bar Plus Disposable",
    description: "Disposable vape pen with 800+ puffs. No charging or refilling required. Perfect for on-the-go vaping.",
    price: 12.99,
    category: "disposables",
    brand: "Puff Bar",
    imageUrl: "https://images.unsplash.com/photo-1565701876971-b8d5ee5f4c79?w=300&h=300&fit=crop&auto=format",
    inStock: true,
    stockQuantity: 500,
    rating: 4.2,
    reviewCount: 445,
    sku: "PUFF-PLUS-DISP",
    tags: ["disposable", "convenience", "portable", "800-puffs"],
    isActive: true,
    isFeatured: false
  },
  {
    name: "JUUL Device Starter Kit",
    description: "Sleek and simple vape device with magnetic pod system. Includes USB charger and starter pods.",
    price: 19.99,
    compareAtPrice: 34.99,
    category: "starter-kits",
    brand: "JUUL",
    imageUrl: "https://images.unsplash.com/photo-1578320339911-9db62d9e6a04?w=300&h=300&fit=crop&auto=format",
    inStock: true,
    stockQuantity: 150,
    rating: 4.1,
    reviewCount: 567,
    sku: "JUUL-STARTER-KIT",
    tags: ["pod", "starter", "sleek", "portable", "magnetic"],
    isActive: true,
    isFeatured: false
  },
  {
    name: "Vaporesso XROS 3 Pod Kit",
    description: "Compact pod system with adjustable airflow and long-lasting 1000mAh battery. Perfect balance of flavor and convenience.",
    price: 27.99,
    category: "starter-kits",
    brand: "Vaporesso",
    imageUrl: "https://images.unsplash.com/photo-1609205776897-ee0a1c6e8c52?w=300&h=300&fit=crop&auto=format",
    inStock: true,
    stockQuantity: 85,
    rating: 4.7,
    reviewCount: 123,
    sku: "VAPO-XROS3-POD",
    tags: ["pod", "compact", "adjustable", "1000mah"],
    isActive: true,
    isFeatured: true
  }
];

const sampleUsers = [
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
    // Connect to MongoDB
    console.log('🔌 Connecting to MongoDB...');
    await mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/vapor_vista');
    console.log('✅ Connected to MongoDB');

    // Clear existing data
    console.log('🗑️ Clearing existing data...');
    await Product.deleteMany({});
    await User.deleteMany({});
    console.log('✅ Cleared existing data');

    // Seed products
    console.log('📦 Seeding products...');
    const insertedProducts = await Product.insertMany(sampleProducts);
    console.log(`✅ Added ${insertedProducts.length} products`);

    // Seed users
    console.log('👥 Seeding users...');
    const insertedUsers = await User.insertMany(sampleUsers);
    console.log(`✅ Added ${insertedUsers.length} users`);

    // Display summary
    console.log('\n📊 Database Summary:');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    
    const totalProducts = await Product.countDocuments();
    const featuredProducts = await Product.countDocuments({ isFeatured: true });
    const totalUsers = await User.countDocuments();
    
    console.log(`📦 Total Products: ${totalProducts}`);
    console.log(`⭐ Featured Products: ${featuredProducts}`);
    console.log(`👥 Total Users: ${totalUsers}`);
    
    console.log('\n📂 Products by Category:');
    const categories = await Product.aggregate([
      { $group: { _id: '$category', count: { $sum: 1 } } },
      { $sort: { count: -1 } }
    ]);
    
    categories.forEach(cat => {
      console.log(`   ${cat._id}: ${cat.count} products`);
    });

    console.log('\n⭐ Featured Products:');
    const featured = await Product.find({ isFeatured: true }).select('name price brand');
    featured.forEach(product => {
      console.log(`   ${product.name} by ${product.brand} - $${product.price}`);
    });

    console.log('\n🔐 Test Accounts:');
    console.log('   Admin: admin@vaporvista.com / admin123');
    console.log('   User:  test@example.com / test123');
    
    console.log('\n✅ Database seeded successfully!');
    console.log('🚀 You can now start your Flutter app');
    
    process.exit(0);
  } catch (error) {
    console.error('❌ Seeding failed:', error);
    process.exit(1);
  }
}

// Run the seeding
seedDatabase();
