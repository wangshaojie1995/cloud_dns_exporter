FROM docker.cnb.cool/znb/images/golang:1.25.0-alpine3.22  AS builder

WORKDIR /app
ENV GOPROXY="https://goproxy.io"

ADD . .

RUN apk add upx make && make build-linux && upx -9 cloud_dns_exporter

FROM docker.cnb.cool/znb/images/alpine:3.22

WORKDIR /app

LABEL maintainer="eryajf"

COPY --from=builder /app/config.example.yaml config.yaml
COPY --from=builder /app/cloud_dns_exporter .

EXPOSE 21798

RUN chmod +x /app/cloud_dns_exporter

CMD [ "/app/cloud_dns_exporter" ]