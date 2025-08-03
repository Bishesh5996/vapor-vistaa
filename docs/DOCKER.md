# Docker Setup

## Backend
```
cd thrift-hub-backend
docker build -t thrift-hub-backend .
docker run -p 3000:3000 thrift-hub-backend
```

## Frontend
```
cd thrift-hub-frontend
flutter build apk
```

