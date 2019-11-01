# rclone

[![GitHub](https://img.shields.io/badge/source-github-lightgrey?style=flat-square)](https://github.com/hotio/docker-rclone)
[![Docker Pulls](https://img.shields.io/docker/pulls/hotio/rclone?style=flat-square)](https://hub.docker.com/r/hotio/rclone)
[![Drone (cloud)](https://img.shields.io/drone/build/hotio/docker-rclone?style=flat-square)](https://cloud.drone.io/hotio/docker-rclone)

## Starting the container

Just the basics to get the container running:

```shell
docker run --rm --name rclone -v /tmp/config:/config -v /tmp/mountpoint:/mountpoint:shared -e REMOTE="remote:path/to/files" -e TZ=Etc/UTC hotio/rclone
```

The environment variables below are all optional, the values you see are the defaults.

```shell
-e PUID=1000
-e PGID=1000
-e UMASK=022
-e MOUNTPOINT=/mountpoint
```

## Configuring rclone

Use `docker exec -it --user hotio rclone rclone config` to configure your remote when the container is running. Configuration files for `rclone` are stored in `/config/.config/rclone`.

## Using the rclone mount on the host or in another container

By using the option `:shared` on your volume, you'll be able to access the rclone mount by going to the folder `/tmp/mountpoint` on the host. If you add `--volumes-from rclone` to another container's run command, you can go to the rclone mount from within that container.

## Extra docker privileges

In most cases you will need some or all of the following flags added to your command to get the required docker privileges when using a rclone mount.

```shell
--security-opt apparmor:unconfined --cap-add SYS_ADMIN --device /dev/fuse
```

## Executing your own scripts

If you have a need to do additional stuff when the container starts or stops, you can mount your script with `-v /docker/host/my-script.sh:/etc/cont-init.d/99-my-script` to execute your script on container start or `-v /docker/host/my-script.sh:/etc/cont-finish.d/99-my-script` to execute it when the container stops. An example script can be seen below.

```shell
#!/usr/bin/with-contenv bash

echo "Hello, this is me, your script."
```
