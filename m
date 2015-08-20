From: Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH 1/2] efi: Add EFI_MEMORY_MORE_RELIABLE support to efi_md_typeattr_format()
Date: Fri, 21 Aug 2015 02:15:52 +0900
Message-ID: <1440090952-15211-1-git-send-email-izumi.taku@jp.fujitsu.com>
References: <1440090902-15157-1-git-send-email-izumi.taku@jp.fujitsu.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1440090902-15157-1-git-send-email-izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
Cc: tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, qiuxishi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

UEFI spec 2.5 introduces new Memory Attribute Definition named
EFI_MEMORY_MORE_RELIABLE. This patch adds this new attribute
support to efi_md_typeattr_format().

Signed-off-by: Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
---
 drivers/firmware/efi/efi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index d6144e3..aadc1c4 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -589,12 +589,14 @@ char * __init efi_md_typeattr_format(char *buf, size_t size,
 	attr = md->attribute;
 	if (attr & ~(EFI_MEMORY_UC | EFI_MEMORY_WC | EFI_MEMORY_WT |
 		     EFI_MEMORY_WB | EFI_MEMORY_UCE | EFI_MEMORY_WP |
-		     EFI_MEMORY_RP | EFI_MEMORY_XP | EFI_MEMORY_RUNTIME))
+		     EFI_MEMORY_RP | EFI_MEMORY_XP | EFI_MEMORY_RUNTIME |
+		     EFI_MEMORY_MORE_RELIABLE))
 		snprintf(pos, size, "|attr=0x%016llx]",
 			 (unsigned long long)attr);
 	else
-		snprintf(pos, size, "|%3s|%2s|%2s|%2s|%3s|%2s|%2s|%2s|%2s]",
+		snprintf(pos, size, "|%3s|%4s|%2s|%2s|%2s|%3s|%2s|%2s|%2s|%2s]",
 			 attr & EFI_MEMORY_RUNTIME ? "RUN" : "",
+			 attr & EFI_MEMORY_MORE_RELIABLE ? "RELY" : "",
 			 attr & EFI_MEMORY_XP      ? "XP"  : "",
 			 attr & EFI_MEMORY_RP      ? "RP"  : "",
 			 attr & EFI_MEMORY_WP      ? "WP"  : "",
-- 
1.8.3.1
