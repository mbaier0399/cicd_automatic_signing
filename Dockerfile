FROM python:3.10-slim
COPY app/main.py /app/
WORKDIR /app
CMD ["python", "main.py"]
