From: Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>
Subject: [PATCH 4/4] x86/efi: print size and base in binary units in efi_print_memmap
Date: Thu, 17 Dec 2015 19:28:34 -0600
Message-ID: <1450402114-3606-5-git-send-email-elliott@hpe.com>
References: <1450402114-3606-1-git-send-email-elliott@hpe.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450402114-3606-1-git-send-email-elliott-ZPxbGqLxI0U@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Print the base address for each range in decimal alongside the size.
Use a "(size @ base)" format similar to the fake_memmap kernel parameter.

Print the range and base in the best-fit B, KiB, MiB, etc. units rather
than always MiB.  This avoids rounding, which can be misleading.

Use proper IEC binary units (KiB, MiB, etc.) rather than misuse SI
decimal units (KB, MB, etc.).

old:
    efi: mem61: [Persistent Memory  |   |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff) (16384MB)

new:
    efi: mem61: [Persistent Memory  |   |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff] (16 GiB @ 34 GiB)

Signed-off-by: Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>
---
 arch/x86/platform/efi/efi.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 635a955..030ba91 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -222,6 +222,25 @@ int __init efi_memblock_x86_reserve_range(void)
 	return 0;
 }
 
+char * __init efi_size_format(char *buf, size_t size, u64 bytes)
+{
+	if (!bytes || (bytes & 0x3ff))
+		snprintf(buf, size, "%llu B", bytes);
+	else if (bytes & 0xfffff)
+		snprintf(buf, size, "%llu KiB", bytes >> 10);
+	else if (bytes & 0x3fffffff)
+		snprintf(buf, size, "%llu MiB", bytes >> 20);
+	else if (bytes & 0xffffffffff)
+		snprintf(buf, size, "%llu GiB", bytes >> 30);
+	else if (bytes & 0x3ffffffffffff)
+		snprintf(buf, size, "%llu TiB", bytes >> 40);
+	else if (bytes & 0xfffffffffffffff)
+		snprintf(buf, size, "%llu PiB", bytes >> 50);
+	else
+		snprintf(buf, size, "%llu EiB", bytes >> 60);
+	return buf;
+}
+
 void __init efi_print_memmap(void)
 {
 #ifdef EFI_DEBUG
@@ -232,14 +251,16 @@ void __init efi_print_memmap(void)
 	for (p = memmap.map, i = 0;
 	     p < memmap.map_end;
 	     p += memmap.desc_size, i++) {
-		char buf[64];
+		char buf[64], buf2[32], buf3[32];
 
 		md = p;
-		pr_info("mem%02u: %s range=[0x%016llx-0x%016llx] (%lluMB)\n",
+		pr_info("mem%02u: %s range=[0x%016llx-0x%016llx] (%s @ %s)\n",
 			i, efi_md_typeattr_format(buf, sizeof(buf), md),
 			md->phys_addr,
 			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1,
-			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
+			efi_size_format(buf3, sizeof(buf3),
+				md->num_pages << EFI_PAGE_SHIFT),
+			efi_size_format(buf2, sizeof(buf2), md->phys_addr));
 	}
 #endif  /*  EFI_DEBUG  */
 }
-- 
2.4.3
