To build this you should run
```bash
docker build -t ghcr.io/games-on-whales/kde:custom --build-arg BASE_APP_IMAGE=ghcr.io/games-on-whales/base-app:edge .
```

Note
There is a bug with mouse in fullscreen x11 apps. Press right ctrl to fix it. And again if you return to desktop


# Wolf config toml

```toml
[[apps]]
title = 'Desktop (kde)'

[apps.runner]
type = 'docker'
name = 'WolfKDE'
image = 'ghcr.io/games-on-whales/kde:custom'
env = ['GOW_REQUIRED_DEVICES=/dev/input/* /dev/dri/* /dev/nvidia*']
devices = []
mounts = []
ports = []
base_create_json = """
{
  "HostConfig": {
    "IpcMode": "host",
    "Privileged": false,
    "CapAdd": ["SYS_ADMIN", "SYS_NICE", "SYS_PTRACE", "NET_RAW", "MKNOD", "NET_ADMIN"],
    "SecurityOpt": ["seccomp=unconfined", "apparmor=unconfined"],
    "DeviceCgroupRules": ["c 13:* rmw", "c 244:* rmw"]
  }
}
\
"""
```
