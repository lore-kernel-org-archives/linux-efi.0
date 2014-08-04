From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons-ud5FBsm0p/xEiooADzr8i9i2O/JbrIOy@public.gmane.org>
Subject: 3.12 to 3.13 boot regression bisected - still applies to 3.16
Date: Mon, 4 Aug 2014 11:34:35 +0200
Message-ID: <20140804113435.34ed8c76@pluto>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: P J P <ppandit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi,

Since 3.13 kernels with built-in initrd fail to boot on Fujitsu hardware
in EFI mode (efi stub) though the exact same kernel binary does boot in
BIOS mode (grub).
Interestingly EFI kernels with different config do boot under VMWare.

Your patch "initramfs: read CONFIG_RD_ variables for initramfs
compression" is the trigger.


Is something missing in EFI stub or why do things behave differently?

Looking at compiled kernel with and without this patch the resulting
bzImage is similar in size but in build directory I get:

Vanilla 3.13, CONFIG_INITRAMFS_COMPRESSION_NONE=y:
-rw-r--r-- 1 kbuild kbuild     399 Aug  4 10:26 usr/built-in.mod.c
-rw-r--r-- 1 kbuild kbuild 7062309 Aug  4 10:26 usr/built-in.o
-rwxr-xr-x 1 kbuild kbuild   22670 Aug  4 10:26 usr/gen_init_cpio
-rw-r--r-- 1 kbuild kbuild 7061260 Aug  4 10:26 usr/initramfs_data.cpio.gz
-rw-r--r-- 1 kbuild kbuild 7062240 Aug  4 10:26 usr/initramfs_data.o
-rw-r--r-- 1 kbuild kbuild       0 Aug  4 10:26 usr/modules.builtin 
-rw-r--r-- 1 kbuild kbuild       0 Aug  4 10:26 usr/modules.order

Does not boot, reboots after exiting EFI stub


Vanilla 3.13, CONFIG_INITRAMFS_COMPRESSION_GZIP=y:
-rw-r--r-- 1 kbuild kbuild     399 Aug  4 10:26 usr/built-in.mod.c
-rw-r--r-- 1 kbuild kbuild 7062309 Aug  4 10:26 usr/built-in.o
-rwxr-xr-x 1 kbuild kbuild   22670 Aug  4 10:26 usr/gen_init_cpio
-rw-r--r-- 1 kbuild kbuild 7061260 Aug  4 10:26 usr/initramfs_data.cpio.gz
-rw-r--r-- 1 kbuild kbuild 7062240 Aug  4 10:26 usr/initramfs_data.o
-rw-r--r-- 1 kbuild kbuild       0 Aug  4 10:37 usr/modules.builtin
-rw-r--r-- 1 kbuild kbuild       0 Aug  4 10:37 usr/modules.order

Does not boot, reboots after exiting EFI stub


3.13 with patch revered, CONFIG_INITRAMFS_COMPRESSION_NONE=y:
-rw-r--r-- 1 kbuild kbuild      399 Aug  4 10:16 usr/built-in.mod.c
-rw-r--r-- 1 kbuild kbuild 16931869 Aug  4 10:16 usr/built-in.o
-rwxr-xr-x 1 kbuild kbuild    22670 Aug  4 10:16 usr/gen_init_cpio
-rw-r--r-- 1 kbuild kbuild 16930816 Aug  4 10:16 usr/initramfs_data.cpio
-rw-r--r-- 1 kbuild kbuild 16931800 Aug  4 10:16 usr/initramfs_data.o
-rw-r--r-- 1 kbuild kbuild        0 Aug  4 10:16 usr/modules.builtin
-rw-r--r-- 1 kbuild kbuild        0 Aug  4 10:16 usr/modules.order

Boots successfully.



Related config options:
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y

CONFIG_INITRAMFS_SOURCE="/usr/src/initrd64-20131127.cpio"
CONFIG_INITRAMFS_ROOT_UID=0
CONFIG_INITRAMFS_ROOT_GID=0
CONFIG_INITRAMFS_COMPRESSION_NONE=y
# CONFIG_INITRAMFS_COMPRESSION_GZIP is not set
# CONFIG_INITRAMFS_COMPRESSION_BZIP2 is not set
# CONFIG_INITRAMFS_COMPRESSION_LZMA is not set
# CONFIG_INITRAMFS_COMPRESSION_XZ is not set
# CONFIG_INITRAMFS_COMPRESSION_LZO is not set



Bruno
