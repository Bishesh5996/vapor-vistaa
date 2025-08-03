const mongoose = require('mongoose');
const User = require('./models/User');
const bcrypt = require('bcryptjs');

mongoose.connect('mongodb://localhost:27017/vapor_vista')
.then(async () => {
  console.log('✅ Connected to MongoDB');
  
  // Find and fix admin user
  const adminUser = await User.findOne({ email: 'admin@vaporvista.com' });
  if (adminUser && adminUser.password === 'admin123') {
    console.log('🔧 Fixing admin password...');
    adminUser.password = 'admin123'; // This will trigger the pre-save hook
    await adminUser.save();
    console.log('✅ Admin password fixed');
  }
  
  // Find and fix test user
  const testUser = await User.findOne({ email: 'test@example.com' });
  if (testUser && testUser.password === 'test123') {
    console.log('🔧 Fixing test user password...');
    testUser.password = 'test123'; // This will trigger the pre-save hook
    await testUser.save();
    console.log('✅ Test user password fixed');
  }
  
  console.log('🎉 Password fixing complete!');
  process.exit(0);
})
.catch(err => {
  console.error('❌ Error:', err);
  process.exit(1);
});
