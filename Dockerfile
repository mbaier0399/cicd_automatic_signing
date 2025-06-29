# Dockerfile
FROM alpine
COPY app/hello.sh /hello.sh
ENTRYPOINT ["/hello.sh"]
