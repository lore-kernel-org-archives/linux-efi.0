From: Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH 0/2] Introduce "efi_fake_mem" boot option
Date: Wed, 30 Sep 2015 19:18:12 +0900
Message-ID: <1443608292-37686-1-git-send-email-izumi.taku@jp.fujitsu.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
Cc: tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, qinxishi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

UEFI spec 2.5 introduces new Memory Attribute Definition named
EFI_MEMORY_MORE_RELIABLE which indicates which memory ranges are
mirrored. Now linux kernel can recognize which memory ranges are mirrored
by handling EFI_MEMORY_MORE_RELIABLE attributes.
However testing this feature necesitates boxes with UEFI spec 2.5 complied
firmware.

This patchset introduces new boot option named "efi_fake_mem".
By specifying this parameter, you can add arbitrary attribute to
specific memory range. This is useful for debugging of Memory 
Address Range Mirroring feature.

This is updated version one of the former patch posted at
 http://www.mail-archive.com/linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg05936.html

changelog:
 - change boot option name and spec
   efi_fake_mem_mirror=nn@ss -> efi_fake_mem=nn@ss:aa
 - rename print_efi_memmap() to efi_print_memmap()
 - introduce new config named CONFIG_EFI_MAX_FAKE_MEM
 - and some fix pointed by Matt Flemming

Taku Izumi (2):
  x86, efi: rename print_efi_memmap() to efi_print_memmap()
  x86, efi: Add "efi_fake_mem" boot option

 Documentation/kernel-parameters.txt |  15 +++
 arch/x86/include/asm/efi.h          |   1 +
 arch/x86/kernel/setup.c             |   4 +-
 arch/x86/platform/efi/efi.c         |   4 +-
 drivers/firmware/efi/Kconfig        |  22 ++++
 drivers/firmware/efi/Makefile       |   1 +
 drivers/firmware/efi/fake_mem.c     | 238 ++++++++++++++++++++++++++++++++++++
 include/linux/efi.h                 |   6 +
 8 files changed, 288 insertions(+), 3 deletions(-)
 create mode 100644 drivers/firmware/efi/fake_mem.c

-- 
1.8.3.1
