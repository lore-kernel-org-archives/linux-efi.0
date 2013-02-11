From: T Makphaibulchoke <tmac-VXdhtT5mjnY@public.gmane.org>
Subject: [PATCH v2] x86/platform/efi/efi_64.c: fix a possible hang in efi_ioremap when init_memory_mapping fails.
Date: Mon, 11 Feb 2013 13:01:15 -0700
Message-ID: <1360612875-16952-1-git-send-email-tmac@hp.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: T Makphaibulchoke <tmac-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

An attempt to recursively invoke efi_ioremap may cause the kernel to get stuck in an infinite recursive loop.
Calling efi_ioremap with non-page aligned size will eventually, due to
its recursive implementation, call itself with size smaller than a page.
In this case, init_memory_mapping will fail, returning a NULL.
An attempt to recursively invoke efi_ioremap, without checking for a failure,
results in a recursive mapping of an invalid physical address range, 0 to size +
physaddr, causing the kernel to get stuck in an infinite recursive loop.

Here is an example of a hang in the efi_ioremap recursive loop with
efi_ioremap(0x3ff000, 0xfff) call,

[   69.266517] init_memory_mapping: [mem 0x003ff000-0x003ffffe]
[   69.267787] init_memory_mapping: [mem 0x00000000-0x003ffffe]
[   69.268222]  [mem 0x00000000-0x001fffff] page 2M
[   69.268580]  [mem 0x00200000-0x003fefff] page 4k
[   69.268953] init_memory_mapping: [mem 0x003ff000-0x003ffffe]
[   69.270216] init_memory_mapping: [mem 0x00000000-0x003ffffe]
[   69.270651]  [mem 0x00000000-0x001fffff] page 2M
[   69.271016]  [mem 0x00200000-0x003fefff] page 4k

Signed-off-by: T Makphaibulchoke <tmac-VXdhtT5mjnY@public.gmane.org>
---
 arch/x86/platform/efi/efi_64.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 2b20038..4b3e2b0 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -102,6 +102,12 @@ void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
 		return ioremap(phys_addr, size);
 
 	last_map_pfn = init_memory_mapping(phys_addr, phys_addr + size);
+
+	if (!last_map_pfn) {
+		/* Do not try to rmmap again in case of a failure */
+		return NULL;
+	}
+
 	if ((last_map_pfn << PAGE_SHIFT) < phys_addr + size) {
 		unsigned long top = last_map_pfn << PAGE_SHIFT;
 		efi_ioremap(top, size - (top - phys_addr), type, attribute);
-- 
1.7.1
