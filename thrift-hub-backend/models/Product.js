const mongoose = require('mongoose');

const ProductSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true
  },
  brand: {
    type: String,
    required: true,
    trim: true
  },
  description: {
    type: String,
    required: true
  },
  price: {
    type: Number,
    required: true,
    min: 0
  },
  image: {
    type: String,
    default: ''
  },
  imageUrl: {
    type: String,
    default: ''
  },
  category: {
    type: String,
    required: true,
    enum: ['Pod Systems', 'Mods', 'Disposables', 'Accessories', 'E-Liquids']
  },
  rating: {
    type: Number,
    default: 4.0,
    min: 0,
    max: 5
  },
  stock: {
    type: Number,
    default: 0,
    min: 0
  },
  isFeatured: {
    type: Boolean,
    default: false
  },
  isActive: {
    type: Boolean,
    default: true
  },
  specifications: {
    type: mongoose.Schema.Types.Mixed,
    default: {}
  }
}, {
  timestamps: true
});

module.exports = mongoose.model('Product', ProductSchema);
