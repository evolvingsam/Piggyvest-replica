# ---------- Build Stage ----------
FROM node:18 AS builder

WORKDIR /app

# Copy necessary files
COPY package*.json ./
COPY tailwind.config.js .
COPY input.css ./
COPY ./src ./src
COPY ./css ./css

# Install Tailwind and build
RUN npm install
RUN npx tailwindcss -i ./input.css -o ./dist/output.css --minify

# ---------- Final Stage ----------
FROM nginx:alpine

# Copy static files
COPY --from=builder /app/dist /usr/share/nginx/html/css
COPY ./index.html /usr/share/nginx/html/
COPY ./sign.html /usr/share/nginx/html/
COPY ./sign_in_account.html /usr/share/nginx/html/
COPY ./images /usr/share/nginx/html/images

# Expose port
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

