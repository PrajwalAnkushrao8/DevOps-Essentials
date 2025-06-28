# Linux File System Basics

This document covers essential Linux commands for managing and inspecting file systems: `df`, `du`, `lsblk`, `fdisk`, and `mkfs`. Each command includes a description, common options, and practical examples to help you understand and manage file systems effectively.

## 1. df (Disk Free)
- **Description**: Reports disk space usage for mounted file systems.
- **Common Options**:
  - `-h`: Human-readable sizes (e.g., GB, MB).
  - `-T`: Show file system type.
  - `-i`: Show inode usage.
  - `--exclude-type=[type]`: Exclude specific file system types (e.g., `tmpfs`).
- **Examples**:
  ```bash
  # Show disk usage in human-readable format
  df -h
  # Example output: Filesystem  Size  Used Avail Use% Mounted on
  # /dev/sda1        100G   50G   50G  50% /

  # Show file system types
  df -T
  # Example output: Includes type like ext4, xfs

  # Show inode usage
  df -i
  # Example output: Shows inodes instead of bytes

  # Exclude tmpfs file systems
  df -h --exclude-type=tmpfs
  ```
- **Note**: Output includes mounted file systems in `/etc/fstab` or temporary mounts.

## 2. du (Disk Usage)
- **Description**: Estimates disk space used by files and directories.
- **Common Options**:
  - `-h`: Human-readable sizes.
  - `-s`: Summarize total size for a directory.
  - `-c`: Show grand total.
  - `--max-depth=[N]`: Limit directory depth.
- **Examples**:
  ```bash
  # Show disk usage for a directory
  du -h /home/user
  # Example output: 4.0K /home/user/docs, 8.0M /home/user/videos

  # Summarize total size
  du -sh /home/user
  # Example output: 10M /home/user

  # Show total with subdirectories
  du -ch /home/user/*
  # Example output: Lists each subdirectory and total

  # Limit depth to 1
  du -h --max-depth=1 /home/user
  ```
- **Note**: Use with `sudo` for restricted directories. Combine with `sort` for readability (e.g., `du -sh * | sort -h`).

## 3. lsblk (List Block Devices)
- **Description**: Lists block devices (e.g., disks, partitions) and their mount points.
- **Common Options**:
  - `-f`: Show file system type and mount points.
  - `-a`: Include empty devices.
  - `-o [columns]`: Specify output columns (e.g., `NAME,SIZE,FSTYPE,MOUNTPOINT`).
- **Examples**:
  ```bash
  # List all block devices
  lsblk
  # Example output: NAME   MAJ:MIN RM  SIZE TYPE MOUNTPOINT
  # sda      8:0    0  100G disk
  # └─sda1   8:1    0  100G part /

  # Show file system types and mount points
  lsblk -f
  # Example output: Includes FSTYPE (e.g., ext4) and MOUNTPOINT

  # Custom output columns
  lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT
  ```
- **Note**: Useful for identifying disks and partitions before formatting or mounting.

## 4. fdisk (Partition Table Manipulator)
- **Description**: Manages disk partitions (create, delete, modify) on block devices.
- **Common Options**:
  - `-l`: List partition tables for all or specified devices.
  - `[device]`: Specify the disk to manage (e.g., `/dev/sdb`).
- **Interactive Commands**:
  - `n`: Create new partition.
  - `d`: Delete partition.
  - `p`: Print partition table.
  - `w`: Write changes and exit.
  - `q`: Quit without saving.
- **Examples**:
  ```bash
  # List all partition tables
  sudo fdisk -l
  # Example output: Shows partitions for all disks

  # Manage partitions on /dev/sdb
  sudo fdisk /dev/sdb
  # Enter interactive mode:
  # n (new partition), p (primary), 1 (partition number), accept defaults
  # w (write changes)

  # List partitions for a specific disk
  sudo fdisk -l /dev/sda
  ```
- **Note**: Requires `sudo`. Be cautious, as changes are destructive. Use `parted` for GPT disks or advanced partitioning.

## 5. mkfs (Make File System)
- **Description**: Creates a file system on a partition (e.g., ext4, xfs, vfat).
- **Common Commands**:
  - `mkfs.ext4 [device]`: Create an ext4 file system.
  - `mkfs.vfat [device]`: Create a FAT32 file system (e.g., for USB drives).
  - `-L [label]`: Set a volume label.
- **Examples**:
  ```bash
  # Create an ext4 file system on a partition
  sudo mkfs.ext4 /dev/sdb1
  # Warning: Erases data on /dev/sdb1

  # Create a FAT32 file system with a label
  sudo mkfs.vfat -L USBDRIVE /dev/sdc1

  # Verify file system
  lsblk -f
  # Example output: Shows new file system type
  ```
- **Note**: Requires `sudo`. Ensure the partition is not mounted before formatting. Use `lsblk` to identify partitions.

## Practical Tips
- **Check disk usage**: Use `df -h` for a quick overview of free space.
- **Analyze large directories**: Combine `du -sh * | sort -h` to find space hogs.
- **Identify devices**: Use `lsblk -f` before partitioning or formatting.
- **Backup before partitioning**: Save data before using `fdisk` or `mkfs`, as they are destructive.
- **Use specific file systems**: Choose `ext4` for Linux, `vfat` for USB drives, or `xfs` for large storage.
- **Combine with `mount`**: After creating a file system, mount it with `mount /dev/sdb1 /mnt`.

## Practice Tasks
1. Check disk usage in human-readable format.
2. Summarize the disk usage of `/home` directory.
3. List all block devices and their file system types.
4. List the partition table for `/dev/sda`.
5. Create an ext4 file system on `/dev/sdb1` (if available, use with caution).
6. Verify the new file system with `lsblk`.

**Solution**:
```bash
df -h
du -sh /home
lsblk -f
sudo fdisk -l /dev/sda
sudo mkfs.ext4 /dev/sdb1
lsblk -f
```