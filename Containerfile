# ---- Build Phase ----
FROM registry.access.redhat.com/ubi9/nodejs-18 as builder

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build

# ---- Serve Phase ----
FROM registry.access.redhat.com/ubi9/nginx-120

COPY --from=builder /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]