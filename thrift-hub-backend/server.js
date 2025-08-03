const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
require('dotenv').config();

const app = express();

// Debug middleware FIRST
app.use((req, res, next) => {
  console.log(`🚨 INCOMING REQUEST: ${req.method} ${req.url}`);
  next();
});

// Security middleware
app.use(helmet());
app.use(cors({
  origin: ['http://localhost:3000', 'http://127.0.0.1:3000', 'http://10.0.2.2:3000'],
  credentials: true
}));

// Body parsing middleware
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Debug body logging
app.use((req, res, next) => {
  if (req.body && Object.keys(req.body).length > 0) {
    console.log(`📦 BODY:`, req.body);
  }
  next();
});

// Import routes
const authRoutes = require('./routes/auth');
const productRoutes = require('./routes/products');

// MongoDB connection
mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/vapor_vista')
.then(() => console.log('✅ Connected to MongoDB'))
.catch(err => console.error('❌ MongoDB connection error:', err));

// Routes
console.log('📋 Registering routes...');
app.use('/api/auth', authRoutes);
console.log('✅ Auth routes registered at /api/auth');
app.use('/api/products', productRoutes);
console.log('✅ Product routes registered at /api/products');

// Basic routes
app.get('/', (req, res) => {
  res.json({ 
    message: 'Vapor Vista API Server',
    status: 'running',
    version: '1.0.0',
    endpoints: {
      health: '/api/health',
      auth: '/api/auth',
      products: '/api/products'
    }
  });
});

app.get('/api/health', (req, res) => {
  res.json({ 
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  });
});

app.get('/api/test', (req, res) => {
  res.json({
    message: 'Vapor Vista API is working!',
    timestamp: new Date().toISOString(),
    userAgent: req.headers['user-agent']
  });
});

// ============= PRODUCTS ENDPOINTS - MOVED BEFORE 404 HANDLER =============

// Products featured endpoint for Flutter app
app.get('/products/featured/list', async (req, res) => {
  try {
    console.log('📦 GET /products/featured/list - Flutter app requesting featured products...');
    
    const Product = require('./models/Product');
    const products = await Product.find({ 
      isActive: true,
      isFeatured: true 
    }).sort({ createdAt: -1 });
    
    console.log(`📦 Found ${products.length} featured products`);
    
    // Return products in the format Flutter app expects
    res.json(products);
    
  } catch (error) {
    console.error('❌ Featured products endpoint error:', error);
    res.status(500).json([]);
  }
});

// All products endpoint
app.get('/products/list', async (req, res) => {
  try {
    console.log('📦 GET /products/list - Getting all products...');
    
    const Product = require('./models/Product');
    const products = await Product.find({ isActive: true }).sort({ createdAt: -1 });
    
    console.log(`📦 Found ${products.length} products`);
    res.json(products);
    
  } catch (error) {
    console.error('❌ Products list endpoint error:', error);
    res.status(500).json([]);
  }
});

// Single product endpoint
app.get('/products/:id', async (req, res) => {
  try {
    console.log('📦 GET /products/' + req.params.id);
    
    const Product = require('./models/Product');
    const product = await Product.findById(req.params.id);
    
    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }
    
    console.log('✅ Product found:', product.name);
    res.json(product);
    
  } catch (error) {
    console.error('❌ Single product endpoint error:', error);
    res.status(500).json({ message: 'Server error' });
  }
});

// ============= TREK APP SPECIFIC ROUTES =============

// Package endpoint for Trek app - FIXED format
app.get('/api/package', async (req, res) => {
  try {
    console.log('📦 GET /api/package - Trek app requesting packages...');
    
    const Product = require('./models/Product');
    const products = await Product.find({ isActive: true });
    
    // Map products to Trek app format
    const packages = products.map(product => ({
      id: product._id.toString(),
      _id: product._id.toString(),
      name: product.name,
      description: product.description,
      price: parseFloat(product.price),
      image: product.imageUrl,
      images: [product.imageUrl],
      category: product.category,
      rating: product.rating || 4.5,
      duration: "1-2 days",
      difficulty: "Easy", 
      location: "Vapor Store",
      maxGroupSize: 10,
      createdAt: product.createdAt,
      updatedAt: product.updatedAt
    }));

    console.log(`📦 Returning ${packages.length} packages to Trek app`);
    
    // Return array directly (Trek app expects array format)
    res.json(packages);

  } catch (error) {
    console.error('❌ Package endpoint error:', error);
    res.status(500).json([]);
  }
});

// Customer profile endpoint for Trek app
app.get('/api/customers/:id', async (req, res) => {
  try {
    console.log('👤 GET /api/customers/' + req.params.id);
    
    const User = require('./models/User');
    const user = await User.findById(req.params.id);
    
    if (!user) {
      console.log('❌ Customer not found');
      return res.status(404).json({ message: 'User not found' });
    }
    
    console.log('✅ Customer found:', user.email);
    
    // Return in format Trek app expects
    res.json({
      data: {
        id: user._id.toString(),
        _id: user._id.toString(),
        email: user.email,
        firstName: user.fname || user.name?.split(' ')[0] || 'Test',
        lastName: user.lname || user.name?.split(' ')[1] || 'User',
        name: user.name || `${user.fname || 'Test'} ${user.lname || 'User'}`,
        phone: user.phone || '',
        role: user.role || 'customer',
        avatar: user.avatar || null
      }
    });
    
  } catch (error) {
    console.error('❌ Customer fetch error:', error);
    res.status(500).json({ message: 'Server error' });
  }
});

// Profile update endpoint for Trek app
app.put('/api/customers/update/:id', async (req, res) => {
  try {
    console.log('🔄 PUT /api/customers/update/' + req.params.id);
    console.log('📦 Update data:', req.body);
    
    const User = require('./models/User');
    const updateData = {
      fname: req.body.fname,
      lname: req.body.lname,
      email: req.body.email, 
      phone: req.body.phone
    };
    
    // Update name field as well
    if (req.body.fname || req.body.lname) {
      updateData.name = `${req.body.fname || ''} ${req.body.lname || ''}`.trim();
    }
    
    const updatedUser = await User.findByIdAndUpdate(
      req.params.id,
      updateData,
      { new: true, runValidators: true }
    );
    
    if (!updatedUser) {
      return res.status(404).json({ message: 'User not found' });
    }
    
    console.log('✅ Profile updated successfully');
    res.json({
      message: 'Profile updated successfully',
      data: updatedUser
    });
    
  } catch (error) {
    console.error('❌ Profile update error:', error);
    res.status(500).json({ 
      message: 'Profile update failed',
      error: error.message 
    });
  }
});

// Orders/Bookings endpoint for Trek app - FIXED to store in database
app.post('/api/bookings', async (req, res) => {
  try {
    console.log('📦 POST /api/bookings - Creating new order');
    console.log('📦 Order data:', req.body);
    
    const Booking = require('./models/Booking');
    
    // Create new booking in database
    const newBooking = new Booking({
      userId: req.body.userId,
      packageId: req.body.packageId,
      packageTitle: req.body.packageTitle || 'SMOK Nord 4 Pod Kit',
      fullName: req.body.fullName,
      email: req.body.email,
      phone: req.body.phone,
      tickets: req.body.tickets || 1,
      pickupLocation: req.body.pickupLocation || 'Vapor Store',
      paymentMethod: req.body.paymentMethod,
      status: 'confirmed',
      totalPrice: req.body.totalPrice || 34.99
    });
    
    const savedBooking = await newBooking.save();
    console.log('✅ Order saved to database:', savedBooking._id);
    
    res.status(201).json({
      message: 'Order placed successfully',
      data: {
        id: savedBooking._id,
        userId: savedBooking.userId,
        packageId: savedBooking.packageId,
        packageTitle: savedBooking.packageTitle,
        fullName: savedBooking.fullName,
        email: savedBooking.email,
        phone: savedBooking.phone,
        tickets: savedBooking.tickets,
        pickupLocation: savedBooking.pickupLocation,
        paymentMethod: savedBooking.paymentMethod,
        status: savedBooking.status,
        totalPrice: savedBooking.totalPrice,
        createdAt: savedBooking.createdAt,
        updatedAt: savedBooking.updatedAt
      }
    });
    
  } catch (error) {
    console.error('❌ Order creation error:', error);
    res.status(500).json({ message: 'Server error' });
  }
});

// Get user bookings/orders for Trek app - FIXED to fetch from database
app.get('/api/bookings/user/:userId', async (req, res) => {
  try {
    console.log('📦 GET /api/bookings/user/' + req.params.userId);
    
    const Booking = require('./models/Booking');
    
    // Fetch bookings from database
    const bookings = await Booking.find({ userId: req.params.userId })
      .sort({ createdAt: -1 });
    
    console.log('✅ Bookings retrieved for user:', req.params.userId, 'Count:', bookings.length);
    
    res.json({
      message: 'Bookings retrieved successfully',
      data: bookings
    });
    
  } catch (error) {
    console.error('❌ Bookings retrieval error:', error);
    res.status(500).json({ message: 'Server error' });
  }
});

// Orders endpoint for Trek app (maps to bookings)
app.get('/api/orders', async (req, res) => {
  try {
    console.log('📦 GET /api/orders - Trek app requesting orders...');
    
    const Booking = require('./models/Booking');
    const orders = await Booking.find().sort({ createdAt: -1 });
    
    console.log(`📦 Returning ${orders.length} orders to Trek app`);
    res.json({ orders });
    
  } catch (error) {
    console.error('❌ Orders endpoint error:', error);
    res.status(500).json({ message: 'Server error', orders: [] });
  }
});

// Image proxy endpoint to handle Unsplash images
app.get('/api/uploads/*', (req, res) => {
  const imageUrl = req.path.replace('/api/uploads/', '');
  console.log('🖼️ Image request for:', imageUrl);
  
  // If it's already a full URL, redirect to it
  if (imageUrl.startsWith('https://')) {
    console.log('🔄 Redirecting to full URL:', imageUrl);
    return res.redirect(imageUrl);
  }
  
  // If it's a partial URL, construct the full Unsplash URL
  if (imageUrl.startsWith('photo-')) {
    const fullUrl = `https://images.unsplash.com/${imageUrl}`;
    console.log('🔄 Redirecting to Unsplash:', fullUrl);
    return res.redirect(fullUrl);
  }
  
  // Default fallback
  const defaultUrl = 'https://images.unsplash.com/photo-1579952363873-27d3bfad9c0d?w=300&h=300&fit=crop&auto=format';
  console.log('🔄 Using default image:', defaultUrl);
  res.redirect(defaultUrl);
});

// ============= END TREK APP SPECIFIC ROUTES =============

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('💥 Server error:', err);
  res.status(500).json({ message: 'Internal server error' });
});

// 404 handler - MUST BE LAST
app.use('*', (req, res) => {
  console.log('❌ 404 - Route not found:', req.method, req.originalUrl);
  res.status(404).json({ message: 'Route not found' });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 Vapor Vista API running on port ${PORT}`);
  console.log(`📖 Health Check: http://localhost:${PORT}/api/health`);
  console.log(`🧪 Test Endpoint: http://localhost:${PORT}/api/test`);
  console.log(`🔐 Auth: http://localhost:${PORT}/api/auth`);
  console.log(`📦 Products: http://localhost:${PORT}/api/products`);
  console.log(`📦 Packages: http://localhost:${PORT}/api/package`);
  console.log(`👤 Customers: http://localhost:${PORT}/api/customers/:id`);
  console.log(`🛒 Products Featured: http://localhost:${PORT}/products/featured/list`);
});
