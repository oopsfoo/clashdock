FROM node as node_builder
RUN apt-get update && apt-get install -y libgl1-mesa-glx
WORKDIR /clash-dashboard-src
RUN git clone https://github.com/Dreamacro/clash-dashboard.git --depth=1 /clash-dashboard-src
RUN npm install
RUN npm run build
RUN mv ./dist /clash_ui

FROM golang:alpine as clash
WORKDIR /clash
COPY ./res/clash /clash/
COPY --from=node_builder /clash_ui /clash/clash_ui
ENTRYPOINT ["/clash/clash","-d","/clash/conf"]
