// In your routes/auth.js login route, update the response format:
res.json({
  token,
  user: {
    id: user._id.toString(),
    _id: user._id.toString(), 
    name: user.name || 'Test Admin',
    email: user.email,
    phone: user.phone || '',
    role: user.role || 'customer'
  },
  message: 'Login successful'
});
