# motionEye for Docker

A container that runs motionEye for use on your home network. Runs on port `8765`, the default username is `admin` and the password is blank.

Build:

```bash
docker build -t motioneye:latest .
```

Run:

```bash
docker run -d -p 8765:8765 -p 7999:7999 motioneye:latest
```

In order to mount the media directory to your local filesystem (in order to save videos), mount the volume `/var/lib/motioneye` as follows:

```bash
docker run -it -p 8765:8765 -p 7999:7999 -v ~/motioneye:/var/lib/motioneye motioneye:latest
```
