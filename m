From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [RFC][PATCH 1/3] efi: Move facility flags to struct efi
Date: Wed, 15 Jan 2014 14:28:54 +0000
Message-ID: <1389796136-23479-2-git-send-email-matt@console-pimps.org>
References: <1389796136-23479-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389796136-23479-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tony-hKmkhVXvusEnkhFzW7PF62O9nC1t1/YaHZ5vskTnxNA@public.gmane.org, "Luck <tony.luck"@intel.com, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

As we grow support for more EFI architectures they're going to want the
ability to query which EFI features are available on the running system.
Instead of storing this information in an architecture-specific place,
stick it in the global 'struct efi', which is already the central
location for EFI state.

While we're at it, let's change the return value of efi_enabled() to be
bool and replace all references to 'facility' with 'feature', which is
the usual word used to describe the attributes of the running system.

Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 arch/x86/include/asm/efi.h  |  1 -
 arch/x86/kernel/setup.c     |  6 +++---
 arch/x86/platform/efi/efi.c | 21 +++++----------------
 include/linux/efi.h         | 18 +++++++++++++-----
 4 files changed, 21 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 65c6e6e3a552..1f69875a38e0 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -94,7 +94,6 @@ extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
 #endif /* CONFIG_X86_32 */
 
 extern int add_efi_memmap;
-extern unsigned long x86_efi_facility;
 extern void efi_set_executable(efi_memory_desc_t *md, bool executable);
 extern int efi_memblock_x86_reserve_range(void);
 extern void efi_call_phys_prelog(void);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index cb233bc9dee3..ddb72923a624 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -908,11 +908,11 @@ void __init setup_arch(char **cmdline_p)
 #ifdef CONFIG_EFI
 	if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
 		     "EL32", 4)) {
-		set_bit(EFI_BOOT, &x86_efi_facility);
+		set_bit(EFI_BOOT, &efi.flags);
 	} else if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
 		     "EL64", 4)) {
-		set_bit(EFI_BOOT, &x86_efi_facility);
-		set_bit(EFI_64BIT, &x86_efi_facility);
+		set_bit(EFI_BOOT, &efi.flags);
+		set_bit(EFI_64BIT, &efi.flags);
 	}
 
 	if (efi_enabled(EFI_BOOT))
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index cceb813044ef..15cc68bc88f1 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -65,8 +65,6 @@ struct efi_memory_map memmap;
 static struct efi efi_phys __initdata;
 static efi_system_table_t efi_systab __initdata;
 
-unsigned long x86_efi_facility;
-
 static __initdata efi_config_table_type_t arch_tables[] = {
 #ifdef CONFIG_X86_UV
 	{UV_SYSTEM_TABLE_GUID, "UVsystab", &efi.uv_systab},
@@ -74,15 +72,6 @@ static __initdata efi_config_table_type_t arch_tables[] = {
 	{NULL_GUID, NULL, NULL},
 };
 
-/*
- * Returns 1 if 'facility' is enabled, 0 otherwise.
- */
-int efi_enabled(int facility)
-{
-	return test_bit(facility, &x86_efi_facility) != 0;
-}
-EXPORT_SYMBOL(efi_enabled);
-
 static bool __initdata disable_runtime = false;
 static int __init setup_noefi(char *arg)
 {
@@ -452,7 +441,7 @@ void __init efi_reserve_boot_services(void)
 
 void __init efi_unmap_memmap(void)
 {
-	clear_bit(EFI_MEMMAP, &x86_efi_facility);
+	clear_bit(EFI_MEMMAP, &efi.flags);
 	if (memmap.map) {
 		early_iounmap(memmap.map, memmap.nr_map * memmap.desc_size);
 		memmap.map = NULL;
@@ -649,7 +638,7 @@ void __init efi_init(void)
 	if (efi_systab_init(efi_phys.systab))
 		return;
 
-	set_bit(EFI_SYSTEM_TABLES, &x86_efi_facility);
+	set_bit(EFI_SYSTEM_TABLES, &efi.flags);
 
 	/*
 	 * Show what we know for posterity
@@ -670,7 +659,7 @@ void __init efi_init(void)
 	if (efi_config_init(arch_tables))
 		return;
 
-	set_bit(EFI_CONFIG_TABLES, &x86_efi_facility);
+	set_bit(EFI_CONFIG_TABLES, &efi.flags);
 
 	/*
 	 * Note: We currently don't support runtime services on an EFI
@@ -682,13 +671,13 @@ void __init efi_init(void)
 	else {
 		if (disable_runtime || efi_runtime_init())
 			return;
-		set_bit(EFI_RUNTIME_SERVICES, &x86_efi_facility);
+		set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 	}
 
 	if (efi_memmap_init())
 		return;
 
-	set_bit(EFI_MEMMAP, &x86_efi_facility);
+	set_bit(EFI_MEMMAP, &efi.flags);
 
 #if EFI_DEBUG
 	print_efi_memmap();
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 11ce6784a196..b7d4409ca32b 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -570,6 +570,7 @@ extern struct efi {
 	efi_reset_system_t *reset_system;
 	efi_set_virtual_address_map_t *set_virtual_address_map;
 	struct efi_memory_map *memmap;
+	unsigned long flags;
 } efi;
 
 static inline int
@@ -656,17 +657,24 @@ extern int __init efi_setup_pcdp_console(char *);
 
 #ifdef CONFIG_EFI
 # ifdef CONFIG_X86
-extern int efi_enabled(int facility);
+
+/*
+ * Test whether the above EFI_* bits are enabled.
+ */
+static inline bool efi_enabled(int feature)
+{
+	return test_bit(feature, &efi.flags) != 0;
+}
 # else
-static inline int efi_enabled(int facility)
+static inline bool efi_enabled(int feature)
 {
-	return 1;
+	return true;
 }
 # endif
 #else
-static inline int efi_enabled(int facility)
+static inline bool efi_enabled(int feature)
 {
-	return 0;
+	return false;
 }
 #endif
 
-- 
1.8.3.1
