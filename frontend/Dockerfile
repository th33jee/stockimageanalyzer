# Use Node base image for building
FROM node:18-alpine as builder

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

# Build React app
RUN npm run build

# Production image
FROM node:18-alpine

WORKDIR /app

# Install serve to run the app
RUN npm install -g serve

COPY --from=builder /app/build ./build

EXPOSE 3000

CMD ["serve", "-s", "build", "-l", "3000"]
