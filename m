From: Linn Crosetto <linn-VXdhtT5mjnY@public.gmane.org>
Subject: [RFC PATCH 1/4] efi: Decouple efi_memmap_init() and do_add_efi_memmap()
Date: Mon, 19 Aug 2013 14:00:16 -0600
Message-ID: <1376942419-5684-2-git-send-email-linn@hp.com>
References: <1376942419-5684-1-git-send-email-linn@hp.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1376942419-5684-1-git-send-email-linn-VXdhtT5mjnY@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jacob.shin-5C7GfCeVMHo@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linn Crosetto <linn-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

In order to enable the EFI memory map to be initialized outside of
efi_init(), decouple the two functions efi_memmap_init() and
do_add_efi_memmap() and set the x86_facility EFI_MEMMAP in
efi_memmap_init(). Additionally, check EFI_MEMMAP to determine whether
efi_memmap_init() has been previously called to avoid doing the
initialization more than once.

Signed-off-by: Linn Crosetto <linn-VXdhtT5mjnY@public.gmane.org>
---
 arch/x86/platform/efi/efi.c | 44 ++++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 90f6ed1..32da922 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -326,6 +326,24 @@ void efi_get_time(struct timespec *now)
 	now->tv_nsec = 0;
 }
 
+static int __init efi_memmap_init(void)
+{
+	if (efi_enabled(EFI_MEMMAP))
+		return 0; /* already initialized */
+
+	/* Map the EFI memory map */
+	memmap.map = early_ioremap((unsigned long)memmap.phys_map,
+				   memmap.nr_map * memmap.desc_size);
+	if (memmap.map == NULL) {
+		pr_err("Could not map the memory map!\n");
+		return -ENOMEM;
+	}
+	memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);
+
+	set_bit(EFI_MEMMAP, &x86_efi_facility);
+	return 0;
+}
+
 /*
  * Tell the kernel about the EFI memory map.  This might include
  * more than the max 128 entries that can fit in the e820 legacy
@@ -336,6 +354,9 @@ static void __init do_add_efi_memmap(void)
 {
 	void *p;
 
+	if (!efi_enabled(EFI_MEMMAP) && efi_memmap_init())
+		return;
+
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		efi_memory_desc_t *md = p;
 		unsigned long long start = md->phys_addr;
@@ -409,6 +430,9 @@ static void __init print_efi_memmap(void)
 	void *p;
 	int i;
 
+	if (!efi_enabled(EFI_MEMMAP))
+		return;
+
 	for (p = memmap.map, i = 0;
 	     p < memmap.map_end;
 	     p += memmap.desc_size, i++) {
@@ -687,23 +711,6 @@ static int __init efi_runtime_init(void)
 	return 0;
 }
 
-static int __init efi_memmap_init(void)
-{
-	/* Map the EFI memory map */
-	memmap.map = early_ioremap((unsigned long)memmap.phys_map,
-				   memmap.nr_map * memmap.desc_size);
-	if (memmap.map == NULL) {
-		pr_err("Could not map the memory map!\n");
-		return -ENOMEM;
-	}
-	memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);
-
-	if (add_efi_memmap)
-		do_add_efi_memmap();
-
-	return 0;
-}
-
 void __init efi_init(void)
 {
 	efi_char16_t *c16;
@@ -766,7 +773,8 @@ void __init efi_init(void)
 	if (efi_memmap_init())
 		return;
 
-	set_bit(EFI_MEMMAP, &x86_efi_facility);
+	if (add_efi_memmap)
+		do_add_efi_memmap();
 
 #ifdef CONFIG_X86_32
 	if (efi_is_native()) {
-- 
1.7.11.3
