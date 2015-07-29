From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 0/2] arm64/efi: fix kernel allocation at base of DRAM
Date: Wed, 29 Jul 2015 12:04:17 +0200
Message-ID: <1438164259-14470-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This series provides an alternative to 'arm64/efi: prefer AllocatePages() over
efi_low_alloc() for vmlinux', of which a v2 was sent out on July 24th.

This series updates efi_low_alloc() to support doing allocations that start
at a fixed offset from an aligned boundary, as is required for allocating the
arm64 kernel 512 KB above a 2 MB boundary.

With these changes, the arm64 placement code can be simplified, and will deal
better with the HiKey platform, whose DRAM starts at 0x0, and APM Mustang, whose
firmware occupies some memory at the base of DRAM, which is currently preventing
the arm64 kernel from using the bottom 2 MB.

Ard Biesheuvel (2):
  efi: add 'offset' param to efi_low_alloc()
  arm64/efi: use efi_low_alloc() with offset to allocate kernel

 arch/arm64/kernel/efi-stub.c                   | 11 ++++++-----
 arch/x86/boot/compressed/eboot.c               |  4 ++--
 drivers/firmware/efi/libstub/efi-stub-helper.c | 20 +++++++++++++++-----
 include/linux/efi.h                            |  2 +-
 4 files changed, 24 insertions(+), 13 deletions(-)

-- 
1.9.1
