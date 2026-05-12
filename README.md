# OverlayFS Sandbox.

## Overview

This Sandbox is an interactive CLI to play around and understand overlayFS which is a core part of the Docker ecosystem.


## Requirements

- Docker([Docker Install Guide](https://docs.docker.com/get-docker/))

## Installation

```bash
git clone https://github.com/Aditramesh/OverlayFS-sandbox
```

---

### Run with Docker
Open a terminal, cd into the project directory and run
```bash
make build-and-run
```
This gives an interactive shell inside the overlayFs docker container.
---
### Understanding Overlay File System.

OverlayFS is a union, virutal filesystem. The word Union here means that this filesystem basically unifies different levels of files and directories such that they appear as a flattened top level filesystem. It is called a virtual file system because unlike ext4, btrfs etc, it is not backed by any physical device but exists purely logically, it does not store anything physically on disk. In the case of this demo the overlayFS is stored in RAM as it as backed by tmpfs. Do not confuse this with the VFS in linux which is an interface that talks to anything like a device, network etc and treats it like a file. It can be backed by any filesystem like ext4 that stores data physically on disk.

#### OverlayFS general structure.

| Layer | Purpose |
|---|---|
| `lowerdir` | Read-only base layer |
| `upperdir` | Writable layer |
| `workdir` | Internal OverlayFS bookkeeping |
| `merged` | Final logical merged view |

---

#### Directory strcuture.
| Layer | Consists |
|---|---|
| `lowerdir` | os-release.txt, config.txt |
| `upperdir` | app.log |

os-release.txt and config.txt are added to simulate core os files that should not be edited, which is why they are part of the lower layer whereas app.log simulates the logs produced by the running application and thus is part of the upper layer.

---

### Playground

#### Experiment 1: The Unified View
OverlayFS combines multiple directories into one view. Let's look inside our `merged` directory:

```bash
ls -l merged/
```

The Result: You will see app.log, config.txt, and os-release.txt all sitting next to each other. The kernel has successfully combined the lower and upper directories.

#### Experiment 2: Modify contents of os-release.txt

The current contents of os.release.txt are:
```bash
cat  merged/os-release.txt
```
Result: I am the core OS file.

Let us edit the os.release.txt
```bash
echo "I am a MODIFIED core OS file" > merged/os-release.txt && cat merged/os-release.txt
```
The Result: It prints "I am a MODIFIED core OS file." Because the upper directory sits on top, any file with the same name in the upper directory completely obscures the file in the lower directory.

#### Experiment 3: Copy-on-Write (CoW)
Let's append data to the config.txt file (which currently only exists in the lower directory).

```bash
echo "Adding a new line to the config!" >> merged/config.txt
```

Now, let's check where that data actually went:
```bash
cat lower/config.txt  # Prints: "I am a secret config."
cat upper/config.txt  # Prints the original text and the new line.
```
This is Copy-on-Write. The moment the lower directory file is edited in merged, the kernel silently copied the original file up into the upper directory, applied your edit there, and left the base lower file completely unharmed.

#### Experiment 4: The Whiteout (Deletions)

```bash
rm merged/config.txt
```

Check the merged folder, the file no longer exists.
```bash
ls -l merged/
```

But now check the lower folder,
```bash
ls -l lower/
```

It is still there. The base layer was not modified. So how is it hidden? Look in the upper directory 
```bash
ls -l upper/
```
Config.txt starts with a special character C something like this
c--------- . This is called a Whiteout file. It tells the kernel if anyone looks for this file in the merged view, pretend it doesn't exist.

### NOTE:

This overlay filesystem in part of the RAM and all changes will disappear when the container is stopped.