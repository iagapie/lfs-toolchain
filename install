#!/bin/bash
set +h

if [ $(id -u) = 0 ]; then
	echo "$0 script need to run as regular user!"
	exit 1
fi

LFS="/mnt/lfs"

while [[ "$1" != "" ]]; do
    case $1 in
        -d|--directory)  shift
            LFS=$1
        ;;
    esac
    shift
done

CURDIR=$(cd "$(dirname $0)" && pwd)
SRCDIR="$LFS/sources"
INSTDIR="$LFS/tools/etc/installed"
SCRDIR="$CURDIR/scripts"
PATCHDIR="$CURDIR/patches"
WORKDIR="/tmp"

PATH=/tools/bin:/bin:/usr/bin

IDU="$(id -u)"
IDG="$(id -g)"

LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
MAKEFLAGS="-j $(nproc)"

fetch() {
	tarballname=$(echo $1 | rev | cut -d / -f 1 | rev)
	WGETCMD="wget --no-check-certificate --passive-ftp --tries=3 --waitretry=3 --output-document=$2/$tarballname.partial"
	WGETRESUME="-c"
	
	if [ -f $2/$tarballname ]; then
		echo "Source file $tarballname found."
		return 0
	else
		if [ -f $2/$tarballname.partial ]; then
			echo "Resuming $1"
			$WGETCMD $WGETRESUME $1
		else
			mkdir -p "$2"
			echo "Downloading $1"
			$WGETCMD $1
		fi
	fi
	
	if [ $? = 0 ]; then
		mv $2/$tarballname.partial $2/$tarballname
	else
		echo "Failed fetching source: $tarballname"
		exit 1
	fi	
}

fetch_src() {
	if [ "${#source[@]}" -gt 0 ]; then
		for s in ${source[@]}; do
			if [ -f $s ]; then
				cp $s $SRCDIR/
			else
				fetch $s $SRCDIR
			fi
		done
	fi
}

extract_src() {
	[ "$name" ] && rm -fr $WORKDIR/$name
	mkdir -p $WORKDIR/$name
	if [ "${#source[@]}" -gt 0 ]; then
		for s in ${source[@]}; do
			filename=$(basename $s)
			case $filename in
				*.tar|*.tar.gz|*.tar.Z|*.tgz|*.tar.bz2|*.tbz2|*.tar.xz|*.txz|*.tar.lzma|*.zip|*.rpm)
					tar xf $SRCDIR/$filename -C $WORKDIR/$name || exit 1;;
				*.pcf.gz)
					gunzip -c $SRCDIR/$filename > $WORKDIR/$name/$name.pcf || exit 1;;
				*)
					cp $SRCDIR/$filename $WORKDIR/$name || exit 1;;
			esac
		done
	fi
}

build_src() {
	cd $WORKDIR/$name
	if [ "$(type -t build)" = function ]; then
		(set -e -x; build)
	fi
	if [ $? -ne 0 ]; then
		echo "!!! build $name-$version failed !!!"
		exit 1
	else
		echo "--- build $name-$version success ---"
	fi
	[ "$name" ] && rm -fr $WORKDIR/$name
	register
}

register() {
	echo $name-$version > $INSTDIR/$(basename $script)
}

build_stage() {
	cd $LFS
	source $1 || exit 1
	fetch_src
	extract_src
	build_src
	unset source name version build
}

checkdone() {
	if [ -e $INSTDIR/$(basename $script) ]; then
		echo "*** skip $(basename $script) ***"
		return 1
	else
		echo ">>> building $(basename $script) <<<"
		return 0
	fi
}

main() {
	for script in $SCRDIR/[0-9][0-9]-*; do
		checkdone || continue
		build_stage $script
	done
}

export LC_ALL LFS LFS_TGT MAKEFLAGS PATH

if [ ! -d $LFS ]; then
	sudo mkdir -pv $LFS
fi

if [ ! -d $SRCDIR ]; then
	sudo mkdir -pv $SRCDIR
fi

if [ ! -w $SRCDIR ]; then
	sudo chown -R $IDU:$IDG $SRCDIR
	chmod -v a+wt $SRCDIR
fi

if [ ! -d $LFS/tools ]; then
	sudo mkdir -pv $LFS/tools
fi

if [ ! -w $LFS/tools ]; then
	sudo chown -R $IDU:$IDG $LFS/tools
fi

if [ ! -L /tools ] || [ $(realpath /tools) != $LFS/tools ]; then
	sudo ln -sv $LFS/tools /
fi

mkdir -pv $INSTDIR
mkdir -p $WORKDIR

main

sudo chown -R 0:0 $LFS/tools

exit 0
