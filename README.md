To build this you should run
```bash
docker build -t gailoks/gow-kde:latest .
```
There is no prebuilt image sorry

Current state is not working

# Wolf config toml (old)

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
