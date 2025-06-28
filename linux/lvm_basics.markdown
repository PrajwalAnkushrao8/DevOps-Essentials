# Linux Basic LVM Concepts

This document provides an in-depth explanation of Logical Volume Management (LVM) in Linux, focusing on the commands `pvcreate`, `vgcreate`, and `lvcreate`. It includes detailed descriptions, how LVM works, common options, practical examples, use cases, and troubleshooting tips to help you manage flexible storage effectively.

## Overview of LVM
- **Purpose**: Logical Volume Management (LVM) provides a flexible way to manage disk storage by abstracting physical disks into logical volumes. It allows resizing, snapshotting, and combining multiple disks into a single logical storage pool.
- **Components**:
  - **Physical Volumes (PVs)**: Physical disks or partitions initialized for LVM (created with `pvcreate`).
  - **Volume Groups (VGs)**: A pool of storage combining one or more PVs (created with `vgcreate`).
  - **Logical Volumes (LVs)**: Virtual partitions carved out of a VG, which can be formatted and mounted (created with `lvcreate`).
- **Use Cases**:
  - Resizing file systems without reformatting.
  - Combining multiple disks into a single logical volume.
  - Creating snapshots for backups.
- **Advantages**:
  - Dynamic resizing of volumes.
  - Spanning storage across multiple disks.
  - Simplified storage management.
- **Mechanics**: LVM uses a layered approach where PVs are grouped into VGs, and LVs are allocated from VGs. LVs can be formatted with file systems (e.g., `ext4`) and mounted.

## 1. pvcreate (Create Physical Volume)
### Overview
- **Purpose**: Initializes a disk or partition as a Physical Volume (PV) for use in LVM.
- **Mechanics**: Marks the device with LVM metadata, making it available to add to a Volume Group.
- **Use Cases**:
  - Preparing a new disk for LVM.
  - Adding an existing partition to an LVM setup.

### Common Options
- `--force`: Force creation, overwriting existing data (use with caution).
- `--setphysicalvolumesize [size]`: Set the usable size of the PV.

### Detailed Examples
1. **Initialize a Disk as a PV**:
   - Identify the disk (ensure it’s unmounted and has no critical data):
     ```bash
     lsblk
     # Output: NAME   MAJ:MIN RM  SIZE TYPE MOUNTPOINT
     # sdb      8:16   0  200G disk
     ```
   - Create the PV:
     ```bash
     sudo pvcreate /dev/sdb
     # Output: Physical volume "/dev/sdb" successfully created.
     ```
   - Verify:
     ```bash
     pvdisplay
     # Output: Shows PV details like size and status
     ```

2. **Initialize a Partition**:
   - Create a partition (e.g., using `fdisk`):
     ```bash
     sudo fdisk /dev/sdb
     # Create new partition (n), set type to LVM (t, 8e), write (w)
     ```
   - Initialize the partition:
     ```bash
     sudo pvcreate /dev/sdb1
     ```

### Troubleshooting
- **Device in use**: Ensure the disk/partition is not mounted (`umount /dev/sdb1`) or used by another process (`lsof /dev/sdb`).
- **Invalid device**: Verify the device exists (`lsblk`).
- **Data loss warning**: `pvcreate` wipes data; back up before use.

## 2. vgcreate (Create Volume Group)
### Overview
- **Purpose**: Combines one or more Physical Volumes into a Volume Group (VG), creating a storage pool for Logical Volumes.
- **Mechanics**: Aggregates PVs into a single manageable unit, allowing allocation of Logical Volumes.
- **Use Cases**:
  - Grouping multiple disks for unified storage.
  - Preparing for Logical Volume creation.

### Common Options
- `-s [size]`: Set physical extent size (default is 4MiB).
- `--name [vgname]`: Specify the Volume Group name.

### Detailed Examples
1. **Create a Volume Group**:
   - Assume `/dev/sdb` is a PV:
     ```bash
     sudo vgcreate myvg /dev/sdb
     # Output: Volume group "myvg" successfully created
     ```
   - Verify:
     ```bash
     vgdisplay
     # Output: Shows VG name, size, and available space
     ```

2. **Add Multiple PVs**:
   - Initialize additional PVs:
     ```bash
     sudo pvcreate /dev/sdc
     ```
   - Create VG with multiple PVs:
     ```bash
     sudo vgcreate myvg /dev/sdb /dev/sdc
     ```

### Troubleshooting
- **PV not found**: Ensure PVs are initialized (`pvdisplay`).
- **VG name exists**: Use a unique name or remove the existing VG (`vgremove`).
- **Insufficient space**: Check PV sizes (`pvdisplay`).

## 3. lvcreate (Create Logical Volume)
### Overview
- **Purpose**: Allocates a Logical Volume (LV) from a Volume Group, which can be formatted and mounted like a regular partition.
- **Mechanics**: Carves out a portion of the VG’s storage for the LV, which can then be formatted with a file system (e.g., `ext4`).
- **Use Cases**:
  - Creating resizable storage for data.
  - Setting up volumes for specific applications.

### Common Options
- `-L [size]`: Specify the size of the LV (e.g., `10G` for 10GB).
- `-n [name]`: Name the Logical Volume.
- `-l [extents]`: Specify size in extents (e.g., `50%FREE` for 50% of available VG space).

### Detailed Examples
1. **Create a Logical Volume**:
   - Create an LV of 10GB in `myvg`:
     ```bash
     sudo lvcreate -L 10G -n mylv myvg
     # Output: Logical volume "mylv" created
     ```
   - Verify:
     ```bash
     lvdisplay
     # Output: Shows LV path (e.g., /dev/myvg/mylv)
     ```

2. **Format and Mount the LV**:
   - Format the LV as `ext4`:
     ```bash
     sudo mkfs.ext4 /dev/myvg/mylv
     ```
   - Create a mount point and mount:
     ```bash
     sudo mkdir /mnt/mylv
     sudo mount /dev/myvg/mylv /mnt/mylv
     ```
   - Verify:
     ```bash
     df -h /mnt/mylv
     # Output: Filesystem          Size  Used Avail Use% Mounted on
     # /dev/myvg/mylv       10G   0G   10G   0% /mnt/mylv
     ```

3. **Create an LV Using All Free Space**:
   - Use all available VG space:
     ```bash
     sudo lvcreate -l 100%FREE -n datalv myvg
     ```

### Troubleshooting
- **Insufficient VG space**: Check available space (`vgdisplay`).
- **LV path issues**: Use `lvdisplay` to confirm the LV path (e.g., `/dev/vgname/lvname`).
- **Mount failures**: Ensure the LV is formatted (`mkfs`) and the mount point exists.

## Practical Example: Setting Up an LVM Volume
### Scenario
You have a new 200GB disk (`/dev/sdb`) and want to create a 50GB `ext4` logical volume for data storage.

### Steps
1. **Initialize the Disk as a PV**:
   ```bash
   sudo pvcreate /dev/sdb
   pvdisplay
   ```

2. **Create a Volume Group**:
   ```bash
   sudo vgcreate datavg /dev/sdb
   vgdisplay
   ```

3. **Create a Logical Volume**:
   ```bash
   sudo lvcreate -L 50G -n datalv datavg
   lvdisplay
   ```

4. **Format and Mount the LV**:
   ```bash
   sudo mkfs.ext4 /dev/datavg/datalv
   sudo mkdir /mnt/data
   sudo mount /dev/datavg/datalv /mnt/data
   df -h /mnt/data
   ```

5. **Add to /etc/fstab for Persistence**:
   - Find the LV’s UUID:
     ```bash
     lsblk -f
     # Output: NAME            FSTYPE LABEL UUID         MOUNTPOINT
     # datavg-datalv   ext4        abcd-1234    /mnt/data
     ```
   - Edit `/etc/fstab`:
     ```bash
     sudo nano /etc/fstab
     # Add: UUID=abcd-1234 /mnt/data ext4 defaults 0 2
     # Save and exit
     ```
   - Test:
     ```bash
     sudo mount -a
     ```

## Practical Tips
- **Backup data**: LVM operations like `pvcreate` and `mkfs` are destructive; back up critical data.
- **Use UUIDs in fstab**: LVs have stable UUIDs (`lsblk -f` or `blkid`).
- **Check LVM status**: Use `pvs`, `vgs`, and `lvs` for quick summaries of PVs, VGs, and LVs.
- **Extend LVs**: Use `lvextend` to resize LVs (e.g., `sudo lvextend -L +10G /dev/myvg/mylv`).
- **Monitor space**: Use `vgdisplay` to check free space in a VG before creating LVs.
- **Install LVM**: Ensure `lvm2` is installed (`sudo apt install lvm2`).

## Practice Tasks
1. Initialize a disk (`/dev/sdc`) as a Physical Volume.
2. Create a Volume Group named `testvg` using `/dev/sdc`.
3. Create a 20GB Logical Volume named `testlv` in `testvg`.
4. Format `testlv` as `ext4` and mount it to `/mnt/test`.
5. Add `testlv` to `/etc/fstab` for automatic mounting.
6. Verify the mount and check disk usage.

**Solution**:
```bash
sudo pvcreate /dev/sdc
sudo vgcreate testvg /dev/sdc
sudo lvcreate -L 20G -n testlv testvg
sudo mkfs.ext4 /dev/testvg/testlv
sudo mkdir /mnt/test
sudo mount /dev/testvg/testlv /mnt/test
lsblk -f
# Note UUID, e.g., 5678-abcd
sudo nano /etc/fstab
# Add: UUID=5678-abcd /mnt/test ext4 defaults 0 2
# Save and exit
sudo mount -a
df -h /mnt/test
```