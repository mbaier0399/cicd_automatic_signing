name: CI/CD mit Cosign Signing

on:
  push:
    branches: [ "main" ]

permissions:
  id-token: write   # Für Cosign keyless signing nötig
  contents: read

jobs:
  build-sign:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Log in to GitHub Container Registry
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Install Cosign
        uses: sigstore/cosign-installer@v3

      - name: Build intermediate artifact
        run: |
          mkdir artifacts
          echo "Stage 1 artifact from CI" > artifacts/intermediate.txt
          zip artifacts/intermediate.zip artifacts/intermediate.txt

      - name: Sign intermediate blob
        run: |
          cosign sign-blob --keyless \
            --output-signature artifacts/intermediate.zip.sig \
            artifacts/intermediate.zip

      - name: Verify intermediate signature
        run: |
          cosign verify-blob --keyless \
            --signature artifacts/intermediate.zip.sig \
            artifacts/intermediate.zip

      - name: Build Docker image
        run: |
          docker build -t ghcr.io/${{ github.repository }}:latest .

      - name: Push Docker image
        run: |
          docker push ghcr.io/${{ github.repository }}:latest

      - name: Sign Docker image with Cosign
        run: |
          cosign sign --keyless ghcr.io/${{ github.repository }}:latest

      - name: Upload artifacts
        uses: actions/upload-artifact@v4
        with:
          name: signed-artifacts
          path: artifacts/
