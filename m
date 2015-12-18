From: Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>
Subject: (unknown)
Date: Thu, 17 Dec 2015 19:28:30 -0600
Message-ID: <1450402114-3606-1-git-send-email-elliott@hpe.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Subject: 
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Date: Thu, 17 Dec 2015 17:40:55 -0600
Subject: [PATCH 0/4] x86/efi: support persistent memory in efi_print_memmap

This series adds support for persistent memory type and NV attribute 
in the efi_print_memmap function, which is only used if EFI_DEBUG is true
(which is the case for x86).

Robert Elliott (4):
  x86/efi: show actual ending addresses in efi_print_memmap
  efi: add NV memory attribute
  efi: add Persistent Memory type name
  x86/efi: print size and base in binary units in efi_print_memmap

 arch/x86/platform/efi/efi.c | 29 +++++++++++++++++++++++++----
 drivers/firmware/efi/efi.c  |  8 ++++++--
 include/linux/efi.h         |  1 +
 3 files changed, 32 insertions(+), 6 deletions(-)

-- 
2.4.3
