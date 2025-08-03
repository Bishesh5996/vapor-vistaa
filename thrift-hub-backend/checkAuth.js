const mongoose = require('mongoose');
const User = require('./models/User');
const bcrypt = require('bcryptjs');

mongoose.connect('mongodb://localhost:27017/vapor_vista')
.then(async () => {
  console.log('✅ Connected to MongoDB');
  
  // Find the admin user
  const adminUser = await User.findOne({ email: 'admin@vaporvista.com' });
  
  if (adminUser) {
    console.log('👤 Found admin user:', adminUser.email);
    console.log('🔐 Stored password hash:', adminUser.password.substring(0, 20) + '...');
    
    // Test password comparison
    const isMatch = await adminUser.comparePassword('admin123');
    console.log('🔍 Password "admin123" matches:', isMatch);
    
    // Also test bcrypt directly
    const directMatch = await bcrypt.compare('admin123', adminUser.password);
    console.log('🔍 Direct bcrypt compare:', directMatch);
    
  } else {
    console.log('❌ Admin user not found');
    
    // List all users
    const allUsers = await User.find({});
    console.log('👥 All users in database:');
    allUsers.forEach(user => {
      console.log(`  - ${user.email} (${user.name})`);
    });
  }
  
  process.exit(0);
})
.catch(err => {
  console.error('❌ Error:', err);
  process.exit(1);
});
