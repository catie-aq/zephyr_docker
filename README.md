# Docker image with Zephyr OS and 6TRON tools

The image is based on [zephyrprojectrtos/ci](https://hub.docker.com/r/zephyrprojectrtos/ci) image and contains additional tools to develop with 6TRON.

## Image Hierarchy

The Docker images are organized in a hierarchical structure:
- `zephyr_docker:main-ci`: Base image with Zephyr build tools
- `zephyr_docker:main-dev`: Inherits from -ci, adds JLink and Ozone
- `zephyr_docker:main-workspace`: Inherits from -dev, adds 6TRON workspace

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

### v4.2.0+202508

- v4.2.0+202508-ci
  - [Zephyr SDK](https://github.com/zephyrproject-rtos/sdk-ng/releases): v0.17.2
- v4.2.0+202508-dev
  - [JLink](https://www.segger.com/downloads/jlink/): V8.54
  - [Ozone](https://www.segger.com/downloads/jlink/): V3.38g
- v4.2.0+202508-workspace
  - [6TRON manifest](https://github.com/catie-aq/zephyr_6tron-manifest): v4.2.0+202508

### v4.1.0+202505

- v4.1.0+202505-ci
  - [Zephyr SDK](https://github.com/zephyrproject-rtos/sdk-ng/releases): v0.17.0
- v4.1.0+202505-dev
  - [JLink](https://www.segger.com/downloads/jlink/): V7.96c
  - [Ozone](https://www.segger.com/downloads/jlink/): V3.38c
- v4.1.0+202505-workspace
  - [6TRON manifest](https://github.com/catie-aq/zephyr_6tron-manifest): v4.1.0+202505

### v4.0.0+202502

- v4.0.0+202502-ci
  - [Zephyr SDK](https://github.com/zephyrproject-rtos/sdk-ng/releases): v0.17.0
- v4.0.0+202502-dev
  - [JLink](https://www.segger.com/downloads/jlink/): V7.96c
  - [Ozone](https://www.segger.com/downloads/jlink/): V3.38c
- v4.0.0+202502-workspace
  - [6TRON manifest](https://github.com/catie-aq/zephyr_6tron-manifest): v4.0.0+202502

### v0.27.4 | v0.27.4-workspace

- [Zephyr Image](https://hub.docker.com/r/zephyrprojectrtos/ci): v0.27.4
- [6TRON manifest](https://github.com/catie-aq/zephyr_6tron-manifest): v3.7.0+202408
- [JLink](https://www.segger.com/downloads/jlink/): V7.96c

### v0.26.18 | v0.26.18-workspace

- [Zephyr Image](https://hub.docker.com/r/zephyrprojectrtos/ci): v0.26.18
- [6TRON manifest](https://github.com/catie-aq/zephyr_6tron-manifest): v3.7.0+202408
- [JLink](https://www.segger.com/downloads/jlink/): V7.96c
