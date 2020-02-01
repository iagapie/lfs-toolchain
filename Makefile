TMP=${HOME}/lfs-toolchain-build/build
LOG=${HOME}/lfs-toolchain-build/log

check:
	sh ./version-check

install:
	sh ./install -t ${TMP} -l ${LOG}

.PHONY: check install