From: Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH 0/2][RFC] Introduce "efi_fake_mem_mirror" boot option
Date: Fri, 21 Aug 2015 02:15:02 +0900
Message-ID: <1440090902-15157-1-git-send-email-izumi.taku@jp.fujitsu.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
Cc: tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, qiuxishi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

UEFI spec 2.5 introduces new Memory Attribute Definition named
EFI_MEMORY_MORE_RELIABLE which indicates which memory ranges are
mirrored. Now linux kernel can recognize which memory ranges are mirrored
by handling EFI_MEMORY_MORE_RELIABLE attributes.
However testing this feature necesitates boxes with UEFI spec 2.5 complied
firmware. 

This patchset introduces new boot option named "efi_fake_mem_mirror".
By specifying this parameter, you can mark specific memory as
mirrored memory. This is useful for debugging of Memory Address Range
Mirroring feature.

Taku Izumi (2):
  efi: Add EFI_MEMORY_MORE_RELIABLE support to efi_md_typeattr_format()
  x86, efi: Add "efi_fake_mem_mirror" boot option

 Documentation/kernel-parameters.txt |   8 ++
 arch/x86/include/asm/efi.h          |   2 +
 arch/x86/kernel/setup.c             |   4 +-
 arch/x86/platform/efi/efi.c         |   2 +-
 arch/x86/platform/efi/quirks.c      | 169 ++++++++++++++++++++++++++++++++++++
 drivers/firmware/efi/efi.c          |   6 +-
 6 files changed, 187 insertions(+), 4 deletions(-)

-- 
1.8.3.1
