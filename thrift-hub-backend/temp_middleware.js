// Add this RIGHT AFTER: const app = express();

// Log ALL incoming requests
app.use((req, res, next) => {
  console.log(`🌐 ${new Date().toISOString()} - ${req.method} ${req.path}`);
  console.log('📦 Body:', req.body);
  console.log('🔗 Headers:', req.headers['content-type']);
  next();
});
