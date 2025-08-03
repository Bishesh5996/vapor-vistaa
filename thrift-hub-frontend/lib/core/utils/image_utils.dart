class ImageUtils {
  static String getImageUrl(String? imageUrl) {
    // Default fallback image
    const String defaultImage = 'https://images.unsplash.com/photo-1579952363873-27d3bfad9c0d?w=300&h=300&fit=crop&auto=format';
    
    if (imageUrl == null || imageUrl.isEmpty) {
      return defaultImage;
    }
    
    // If it's already a full URL, return as is
    if (imageUrl.startsWith('https://')) {
      return imageUrl;
    }
    
    // If it starts with photo-, construct Unsplash URL
    if (imageUrl.startsWith('photo-')) {
      return 'https://images.unsplash.com/$imageUrl';
    }
    
    // For any other case, assume it's an Unsplash photo ID
    return defaultImage;
  }
}
