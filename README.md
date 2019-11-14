# LFS - Constructing a Temporary System (Toolchain)

## Install

For building a temporary system, run as regular user:

```bash
make LFS=/mnt/lfs install
```

The script is resume-able, just re-run the script to continue where you left

---

## Host System Requirements

```bash
make check
```

* Bash-3.2 (/bin/sh should be a symbolic or hard link to bash)
* Binutils-2.25 (Versions greater than 2.33.1 are not recommended as they have not been tested)
* Bison-2.7 (/usr/bin/yacc should be a link to bison or small script that executes bison)
* Bzip2-1.0.4
* Coreutils-6.9
* Diffutils-2.8.1
* Findutils-4.2.31
* Gawk-4.0.1 (/usr/bin/awk should be a link to gawk)
* GCC-6.2 including the C++ compiler, g++ (Versions greater than 9.2.0 are not recommended as they have not been tested)
* Glibc-2.11 (Versions greater than 2.30 are not recommended as they have not been tested)
* Grep-2.5.1a
* Gzip-1.3.12
* Linux Kernel-3.2
* M4-1.4.10
* Make-4.0
* Patch-2.5.4
* Perl-5.8.8
* Python-3.4
* Sed-4.1.5
* Tar-1.22
* Texinfo-4.7
* Xz-5.0.0
* Wget
