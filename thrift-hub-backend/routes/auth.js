const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/User');

const router = express.Router();

// Register endpoint
router.post('/register', async (req, res) => {
  try {
    console.log('📝 Registration request received');
    console.log('📦 Registration data:', req.body);
    
    const { fname, lname, email, phone, password, role } = req.body;
    
    // Validate required fields
    if (!fname || !lname || !email || !password) {
      console.log('❌ Missing required fields');
      return res.status(400).json({ 
        message: 'First name, last name, email, and password are required' 
      });
    }
    
    // Clean email
    const cleanEmail = email.toLowerCase().trim();
    console.log('🧹 Clean email:', cleanEmail);
    
    // Check if user already exists
    const existingUser = await User.findOne({ email: cleanEmail });
    
    if (existingUser) {
      console.log('❌ User already exists:', cleanEmail);
      return res.status(400).json({ 
        message: 'User already exists with this email' 
      });
    }
    
    console.log('✅ Email is available, proceeding with registration');
    
    // Hash password
    const saltRounds = 12;
    const hashedPassword = await bcrypt.hash(password, saltRounds);
    console.log('🔐 Password hashed successfully');
    
    // Create new user
    const newUser = new User({
      fname: fname.trim(),
      lname: lname.trim(),
      name: `${fname.trim()} ${lname.trim()}`,
      email: cleanEmail,
      phone: phone ? phone.trim() : '',
      password: hashedPassword,
      role: role || 'customer'
    });
    
    const savedUser = await newUser.save();
    console.log('✅ User created successfully:', savedUser.email);
    console.log('👤 User ID:', savedUser._id);
    
    // Generate JWT token
    const token = jwt.sign(
      { userId: savedUser._id },
      process.env.JWT_SECRET || 'vapor_vista_secret_key_2024',
      { expiresIn: '7d' }
    );
    
    console.log('🔑 JWT token generated');
    
    // Send response
    const responseData = {
      message: 'User registered successfully',
      token,
      data: {
        id: savedUser._id,
        name: savedUser.name,
        email: savedUser.email,
        phone: savedUser.phone,
        role: savedUser.role
      }
    };
    
    console.log('📤 Registration success response sent');
    res.status(201).json(responseData);
    
  } catch (error) {
    console.error('❌ Registration error:', error);
    
    // Handle MongoDB duplicate key error
    if (error.code === 11000 && error.keyPattern && error.keyPattern.email) {
      return res.status(400).json({ 
        message: 'User already exists with this email' 
      });
    }
    
    res.status(500).json({ 
      message: 'Server error during registration',
      error: process.env.NODE_ENV === 'development' ? error.message : 'Internal server error'
    });
  }
});

// Login endpoint
router.post('/login', async (req, res) => {
  try {
    console.log('🎉 LOGIN ATTEMPT');
    const { email, password } = req.body;
    
    console.log('📧 Login email:', email);
    console.log('🔐 Password provided:', !!password);
    
    if (!email || !password) {
      console.log('❌ Missing email or password');
      return res.status(400).json({ message: 'Email and password are required' });
    }
    
    // Clean email
    const cleanEmail = email.toLowerCase().trim();
    console.log('🧹 Clean email for lookup:', cleanEmail);
    
    // Find user
    const user = await User.findOne({ email: cleanEmail });
    
    if (!user) {
      console.log('❌ User not found for email:', cleanEmail);
      
      // Check if any users exist in database
      const userCount = await User.countDocuments();
      console.log('📊 Total users in database:', userCount);
      
      return res.status(401).json({ message: 'Invalid email or password' });
    }
    
    console.log('✅ User found:', user.email);
    console.log('👤 User name:', user.name);
    console.log('🔑 User role:', user.role);
    console.log('🆔 User ID:', user._id);
    
    // Verify password
    const isValidPassword = await bcrypt.compare(password, user.password);
    console.log('🔐 Password validation result:', isValidPassword);
    
    if (!isValidPassword) {
      console.log('❌ Invalid password for user:', user.email);
      return res.status(401).json({ message: 'Invalid email or password' });
    }
    
    // Generate JWT token
    const token = jwt.sign(
      { userId: user._id },
      process.env.JWT_SECRET || 'vapor_vista_secret_key_2024',
      { expiresIn: '7d' }
    );
    
    const responseData = {
      token,
      userId: user._id,
      role: user.role
    };
    
    console.log('🎉 LOGIN SUCCESS! Sending response');
    console.log('📤 Response data:', responseData);
    
    res.json(responseData);
    
  } catch (error) {
    console.error('❌ Login error:', error);
    res.status(500).json({ message: 'Server error during login' });
  }
});

module.exports = router;
