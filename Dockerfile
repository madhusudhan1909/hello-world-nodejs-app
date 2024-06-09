# Use the official Node.js image
FROM node:14

# Create and change to the app directory
WORKDIR /usr/src/app

# Copy the application code
COPY package*.json ./
COPY app.js ./

# Install dependencies
RUN npm install

# Expose the port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]

