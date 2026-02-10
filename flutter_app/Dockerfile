# Build stage - Flutter Web
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# Copy pubspec files
COPY pubspec.yaml pubspec.lock ./

# Get dependencies
RUN flutter pub get

# Copy the rest of the app
COPY . .

# Build for web
RUN flutter build web --release --pwa-strategy none

# Add cache-busting: inject build timestamp into index.html
RUN BUILD_TS=$(date +%s) && \
    sed -i "s|flutter_bootstrap.js|flutter_bootstrap.js?v=${BUILD_TS}|g" build/web/index.html && \
    echo "{\"build_time\":\"${BUILD_TS}\"}" > build/web/build_info.json

# Production stage - Nginx
FROM nginx:alpine

# Copy built web files
COPY --from=build /app/build/web /usr/share/nginx/html

# Copy nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
