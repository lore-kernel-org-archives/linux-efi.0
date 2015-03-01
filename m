From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 2/8] x86: Kill E820_RESERVED_KERN
Date: Sat, 28 Feb 2015 18:17:33 -0800
Message-ID: <1425176259-30087-3-git-send-email-yinghai@kernel.org>
References: <1425176259-30087-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425176259-30087-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pci@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>, "Lee, Chun-Yi" <jlee@suse.com>, stable@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Now we are using memblock to do early resource reserver/allocation
instead of using e820 map directly, and setup_data is reserved in
memblock early already.
Also kexec will generate setup_data and pass pointer to second kernel,
so second kernel will reserve setup_data by their own.

We can kill E820_RESERVED_KERN and not touch e820 map at all.

That will fix bug in mark_nonsave_region that can not handle that
case: E820_RAM and E820_RESERVED_KERN ranges are continuous and
boundary is not page aligned.

Bugzilla: https://bugzilla.opensuse.org/show_bug.cgi?id=913885
Reported-by: "Lee, Chun-Yi" <jlee@suse.com>
Tested-by: "Lee, Chun-Yi" <jlee@suse.com>
Cc: "Lee, Chun-Yi" <jlee@suse.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: stable@vger.kernel.org
---
 arch/x86/include/uapi/asm/e820.h |  9 ---------
 arch/x86/kernel/e820.c           |  6 ++----
 arch/x86/kernel/setup.c          | 26 --------------------------
 arch/x86/kernel/tboot.c          |  3 +--
 arch/x86/mm/init_64.c            | 11 ++++-------
 5 files changed, 7 insertions(+), 48 deletions(-)

diff --git a/arch/x86/include/uapi/asm/e820.h b/arch/x86/include/uapi/asm/e820.h
index d993e33..edc8a71 100644
--- a/arch/x86/include/uapi/asm/e820.h
+++ b/arch/x86/include/uapi/asm/e820.h
@@ -33,15 +33,6 @@
 #define E820_NVS	4
 #define E820_UNUSABLE	5
 
-
-/*
- * reserved RAM used by kernel itself
- * if CONFIG_INTEL_TXT is enabled, memory of this type will be
- * included in the S3 integrity calculation and so should not include
- * any memory that BIOS might alter over the S3 transition
- */
-#define E820_RESERVED_KERN        128
-
 #ifndef __ASSEMBLY__
 #include <linux/types.h>
 struct e820entry {
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 46201de..2a6bed9 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -134,7 +134,6 @@ static void __init e820_print_type(u32 type)
 {
 	switch (type) {
 	case E820_RAM:
-	case E820_RESERVED_KERN:
 		printk(KERN_CONT "usable");
 		break;
 	case E820_RESERVED:
@@ -688,7 +687,7 @@ void __init e820_mark_nosave_regions(unsigned long limit_pfn)
 			register_nosave_region(pfn, PFN_UP(ei->addr));
 
 		pfn = PFN_DOWN(ei->addr + ei->size);
-		if (ei->type != E820_RAM && ei->type != E820_RESERVED_KERN)
+		if (ei->type != E820_RAM)
 			register_nosave_region(PFN_UP(ei->addr), pfn);
 
 		if (pfn >= limit_pfn)
@@ -902,7 +901,6 @@ void __init finish_e820_parsing(void)
 static inline const char *e820_type_to_string(int e820_type)
 {
 	switch (e820_type) {
-	case E820_RESERVED_KERN:
 	case E820_RAM:	return "System RAM";
 	case E820_ACPI:	return "ACPI Tables";
 	case E820_NVS:	return "ACPI Non-volatile Storage";
@@ -1077,7 +1075,7 @@ void __init memblock_x86_fill(void)
 		if (end != (resource_size_t)end)
 			continue;
 
-		if (ei->type != E820_RAM && ei->type != E820_RESERVED_KERN)
+		if (ei->type != E820_RAM)
 			continue;
 
 		memblock_add(ei->addr, ei->size);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 05d444f..c9b3e2f 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -473,30 +473,6 @@ static void __init parse_setup_data(void)
 	}
 }
 
-static void __init e820_reserve_setup_data(void)
-{
-	struct setup_data *data;
-	u64 pa_data;
-	int found = 0;
-
-	pa_data = boot_params.hdr.setup_data;
-	while (pa_data) {
-		data = early_memremap(pa_data, sizeof(*data));
-		e820_update_range(pa_data, sizeof(*data)+data->len,
-			 E820_RAM, E820_RESERVED_KERN);
-		found = 1;
-		pa_data = data->next;
-		early_iounmap(data, sizeof(*data));
-	}
-	if (!found)
-		return;
-
-	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
-	memcpy(&e820_saved, &e820, sizeof(struct e820map));
-	printk(KERN_INFO "extended physical RAM map:\n");
-	e820_print_map("reserve setup_data");
-}
-
 static void __init memblock_x86_reserve_range_setup_data(void)
 {
 	struct setup_data *data;
@@ -1032,8 +1008,6 @@ void __init setup_arch(char **cmdline_p)
 		early_dump_pci_devices();
 #endif
 
-	/* update the e820_saved too */
-	e820_reserve_setup_data();
 	finish_e820_parsing();
 
 	if (efi_enabled(EFI_BOOT))
diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
index 91a4496..3c2752a 100644
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -195,8 +195,7 @@ static int tboot_setup_sleep(void)
 	tboot->num_mac_regions = 0;
 
 	for (i = 0; i < e820.nr_map; i++) {
-		if ((e820.map[i].type != E820_RAM)
-		 && (e820.map[i].type != E820_RESERVED_KERN))
+		if (e820.map[i].type != E820_RAM)
 			continue;
 
 		add_mac_region(e820.map[i].addr, e820.map[i].size);
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 30eb05a..19430d5 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -426,8 +426,7 @@ phys_pte_init(pte_t *pte_page, unsigned long addr, unsigned long end,
 		next = (addr & PAGE_MASK) + PAGE_SIZE;
 		if (addr >= end) {
 			if (!after_bootmem &&
-			    !e820_any_mapped(addr & PAGE_MASK, next, E820_RAM) &&
-			    !e820_any_mapped(addr & PAGE_MASK, next, E820_RESERVED_KERN))
+			    !e820_any_mapped(addr & PAGE_MASK, next, E820_RAM))
 				set_pte(pte, __pte(0));
 			continue;
 		}
@@ -473,9 +472,8 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 
 		next = (address & PMD_MASK) + PMD_SIZE;
 		if (address >= end) {
-			if (!after_bootmem &&
-			    !e820_any_mapped(address & PMD_MASK, next, E820_RAM) &&
-			    !e820_any_mapped(address & PMD_MASK, next, E820_RESERVED_KERN))
+			if (!after_bootmem && !e820_any_mapped(
+					address & PMD_MASK, next, E820_RAM))
 				set_pmd(pmd, __pmd(0));
 			continue;
 		}
@@ -548,8 +546,7 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 		next = (addr & PUD_MASK) + PUD_SIZE;
 		if (addr >= end) {
 			if (!after_bootmem &&
-			    !e820_any_mapped(addr & PUD_MASK, next, E820_RAM) &&
-			    !e820_any_mapped(addr & PUD_MASK, next, E820_RESERVED_KERN))
+			    !e820_any_mapped(addr & PUD_MASK, next, E820_RAM))
 				set_pud(pud, __pud(0));
 			continue;
 		}
-- 
1.8.4.5
