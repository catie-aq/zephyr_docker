# Docker image with Zephyr OS and 6TRON tools

The image is based on [zephyrprojectrtos/ci](https://hub.docker.com/r/zephyrprojectrtos/ci) image and contains additional tools to develop with 6TRON.

## Tools

- [JLink](https://www.segger.com/downloads/jlink/#J-LinkSoftwareAndDocumentationPack)
- [Ozone](https://www.segger.com/downloads/jlink/#Ozone)

## Usage

Pull the image:
```bash
docker pull ghcr.io/catie-aq/zephyr_docker:main
```

Pull the image including the workspace:
```bash
docker pull ghcr.io/catie-aq/zephyr_docker:main-workspace
```

Run the image:
```bash
docker run -it --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix zephyr_docker
```

## Version

### v0.27.4 | v0.27.4-workspace

- [Zephyr Image](https://hub.docker.com/r/zephyrprojectrtos/ci): v0.27.4
- [6TRON manifest](https://github.com/catie-aq/zephyr_6tron-manifest): v3.7.0+202408
- [JLink](https://www.segger.com/downloads/jlink/): V7.96c

### v0.26.18 | v0.26.18-workspace

- [Zephyr Image](https://hub.docker.com/r/zephyrprojectrtos/ci): v0.26.18
- [6TRON manifest](https://github.com/catie-aq/zephyr_6tron-manifest): v3.7.0+202408
- [JLink](https://www.segger.com/downloads/jlink/): V7.96c
