# Database Schema

## Users Collection
- _id: ObjectId
- email: String
- password: String (hashed)
- profile: Object

## Products Collection
- _id: ObjectId
- name: String
- description: String
- price: Number
- images: Array
- seller: ObjectId (ref: Users)

