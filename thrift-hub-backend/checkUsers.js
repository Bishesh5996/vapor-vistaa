const mongoose = require('mongoose');
const User = require('./models/User');

mongoose.connect('mongodb://localhost:27017/vapor_vista')
.then(async () => {
  console.log('✅ Connected to MongoDB');
  
  const users = await User.find({});
  console.log(`👥 Users in database: ${users.length}`);
  
  if (users.length > 0) {
    users.forEach(user => {
      console.log(`- Email: ${user.email}, Role: ${user.role}, Name: ${user.name}`);
    });
  } else {
    console.log('❌ No users found in database');
  }
  
  process.exit(0);
})
.catch(err => {
  console.error('❌ Database connection error:', err.message);
  process.exit(1);
});
