# Linux Mounting Drives

This document covers Linux commands and configurations for mounting drives: `mount`, `umount`, and `/etc/fstab`. Each section includes a description, common options, and practical examples to help you manage file system mounts effectively.

## 1. mount (Mount a File System)
- **Description**: Attaches a file system (e.g., on a disk partition, USB drive, or network share) to a directory (mount point).
- **Common Options**:
  - `-t [fstype]`: Specify file system type (e.g., `ext4`, `vfat`, `ntfs`).
  - `-o [options]`: Set mount options (e.g., `ro` for read-only, `rw` for read-write).
  - `-L [label]`: Mount by volume label.
  - `-U [uuid]`: Mount by UUID.
- **Examples**:
  ```bash
  # Mount a partition to a directory
  sudo mkdir /mnt/mydrive
  sudo mount /dev/sdb1 /mnt/mydrive

  # Mount with specific file system type
  sudo mount -t ext4 /dev/sdb1 /mnt/mydrive

  # Mount read-only
  sudo mount -o ro /dev/sdb1 /mnt/mydrive

  # Mount by UUID (find UUID with lsblk -f)
  sudo mount -U 1234-5678 /mnt/mydrive

  # List all mounted file systems
  mount
  # Example output: /dev/sdb1 on /mnt/mydrive type ext4 (rw,relatime)
  ```
- **Note**: Requires `sudo`. Mount points must exist (create with `mkdir`). Use `lsblk -f` to find device names and UUIDs.

## 2. umount (Unmount a File System)
- **Description**: Detaches a file system from its mount point.
- **Common Options**:
  - `-l`: Lazy unmount (detaches when no longer in use).
  - `-f`: Force unmount (use with caution).
- **Examples**:
  ```bash
  # Unmount a file system
  sudo umount /mnt/mydrive

  # Unmount by device
  sudo umount /dev/sdb1

  # Lazy unmount (if busy)
  sudo umount -l /mnt/mydrive

  # Verify unmount
  mount | grep mydrive
  # Should return no output if unmounted
  ```
- **Note**: Requires `sudo`. Ensure no processes are using the mount point (check with `lsof /mnt/mydrive`).

## 3. /etc/fstab (File System Table)
- **Description**: Configures file systems to mount automatically at boot or manually with `mount -a`. Located at `/etc/fstab`.
- **Format**:
  ```
  # <device> <mount point> <fstype> <options> <dump> <pass>
  UUID=1234-5678 /mnt/mydrive ext4 defaults 0 2
  ```
  - **Device**: Device path, UUID, or label (use `lsblk -f` to find).
  - **Mount Point**: Directory where the file system is mounted.
  - **Fstype**: File system type (e.g., `ext4`, `vfat`, `nfs`).
  - **Options**: Mount options (e.g., `defaults`, `ro`, `rw`, `noauto`).
  - **Dump**: Backup flag (0 = disable, 1 = enable).
  - **Pass**: Filesystem check order (0 = none, 1 = root, 2 = others).
- **Examples**:
  ```bash
  # View fstab
  cat /etc/fstab
  # Example output:
  # UUID=1234-5678 / ext4 defaults 0 1
  # UUID=abcd-efgh /mnt/data ext4 defaults 0 2

  # Add an entry to fstab
  sudo nano /etc/fstab
  # Add: UUID=1234-5678 /mnt/mydrive ext4 defaults 0 2
  # Save and exit

  # Test fstab configuration
  sudo mount -a
  # Check for errors

  # Verify mount
  df -h /mnt/mydrive
  ```
- **Note**: Requires `sudo` to edit. Backup `/etc/fstab` before changes (`sudo cp /etc/fstab /etc/fstab.bak`). Use `blkid` to find UUIDs.

## Practical Tips
- **Find device details**: Use `lsblk -f` or `blkid` to identify devices, UUIDs, and file system types.
- **Create mount points**: Use `mkdir /mnt/something` before mounting.
- **Test mounts**: Run `mount -a` after editing `/etc/fstab` to catch errors.
- **Handle busy mounts**: Use `lsof` or `fuser` to find processes using a mount point before `umount`.
- **Use UUIDs in fstab**: UUIDs are more reliable than device names (e.g., `/dev/sdb1`) as device names can change.
- **Common options**: Use `defaults` for typical settings, `noauto` to prevent auto-mounting at boot.

## Practice Tasks
1. Create a mount point `/mnt/usb` and mount a USB drive (`/dev/sdc1`) as ext4.
2. Unmount the USB drive.
3. Add an entry to `/etc/fstab` to mount `/dev/sdc1` at `/mnt/usb` with ext4 and default options.
4. Test the `/etc/fstab` configuration.
5. Verify the mount with `df`.
6. Unmount `/mnt/usb` and check that it’s unmounted.

**Solution**:
```bash
sudo mkdir /mnt/usb
sudo mount -t ext4 /dev/sdc1 /mnt/usb
sudo umount /mnt/usb
sudo nano /etc/fstab
# Add: UUID=1234-5678 /mnt/usb ext4 defaults 0 2
# Save and exit
sudo mount -a
df -h /mnt/usb
sudo umount /mnt/usb
mount | grep /mnt/usb
```