LFS=/mnt/lfs

check:
	sh ./version-check

install:
	sh ./install -d ${LFS}

.PHONY: check install