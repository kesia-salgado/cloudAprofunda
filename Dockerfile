# Stage 1: Build the TypeScript application
FROM node:20-slim AS build

# Set the working directory inside the container
WORKDIR /app

COPY --chown=node:node package*.json ./
COPY --chown=node:node src ./src

RUN npm ci

COPY --chown=node:node . .

USER node

FROM node:20-alpine3.18 AS build

WORKDIR /app

COPY --chown=node:node package*.json ./
COPY --chown=node:node src ./src

COPY --chown=node:node --from=development /app/node_modules ./node_modules

COPY --chown=node:node . .

RUN npm run build

# Stage 2: Create the final, smaller runtime image
FROM node:20-slim

# Set the working directory inside the container
WORKDIR /app

# Copy only the necessary files from the build stage
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/package*.json ./
COPY --from=build /app/dist ./dist

# Expose the port your application listens on
# Cloud Run expects your application to listen on the port specified by the PORT environment variable
ENV PORT 3000
EXPOSE ${PORT}

# Define the command to run your application
# Assuming your built JavaScript entry point is in dist/index.js (adjust as needed)
CMD ["node", "dist/index.js"]
