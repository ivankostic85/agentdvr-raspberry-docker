# Agentdvr docker image for raspberry

## Disclaimer
- Made for a personal project
- Tested on RPI3 B (32bits)

## TL;DR;
### Run
```sh
docker run -it -p 8090:8090 -p 3478:3478/udp -p 50000-50010:50000-50010/udp --name agentdvr uwizy/agentdvr-raspberry-docker
```

### Run with local device
```sh
docker run -it -p 8090:8090 -p 3478:3478/udp -p 50000-50010:50000-50010/udp --device=/dev/video0 --name agentdvr uwizy/agentdvr-raspberry-docker
```

### Build
```sh
docker build -t uwizy/agentdvr-raspberry-docker .
```

## Summary
Since instructions at https://www.ispyconnect.com/download.aspx (ARM tab) did not work for me and resulted in runtime errors,
I created this repository used to build
