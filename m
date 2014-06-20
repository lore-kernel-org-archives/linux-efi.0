From: Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v6 3/9] efi: Introduce EFI_PARAVIRT flag
Date: Fri, 20 Jun 2014 23:29:22 +0200
Message-ID: <1403299768-9955-4-git-send-email-daniel.kiper@oracle.com>
References: <1403299768-9955-1-git-send-email-daniel.kiper@oracle.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1403299768-9955-1-git-send-email-daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org
Cc: andrew.cooper3-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, eshelton-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, jbeulich-IBi9RG/b67k@public.gmane.org, jeremy-TSDbQ3PG+2Y@public.gmane.org, konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Introduce EFI_PARAVIRT flag. If it is set then kernel runs
on EFI platform but it has not direct control on EFI stuff
like EFI runtime, tables, structures, etc. If not this means
that Linux Kernel has direct access to EFI infrastructure
and everything runs as usual.

This functionality is used in Xen dom0 because hypervisor
has full control on EFI stuff and all calls from dom0 to
EFI must be requested via special hypercall which in turn
executes relevant EFI code in behalf of dom0.

Signed-off-by: Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
v6 - suggestions/fixes:
   - rename EFI_NO_DIRECT to EFI_PARAVIRT
     (suggested by David Vrabel),
   - improve code comments
     (suggested by Matt Fleming).

v5 - suggestions/fixes:
   - rename EFI_DIRECT to EFI_NO_DIRECT
     (suggested by David Vrabel),
   - limit EFI_NO_DIRECT usage
     (suggested by Jan Beulich and Matt Fleming),
   - improve commit message
     (suggested by David Vrabel).
---
 arch/x86/platform/efi/efi.c |   31 +++++++++++++++++++++++++------
 drivers/firmware/efi/efi.c  |   21 ++++++++++++---------
 include/linux/efi.h         |    3 ++-
 3 files changed, 39 insertions(+), 16 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index d2d3c41..b9c23d7 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -350,6 +350,9 @@ int __init efi_memblock_x86_reserve_range(void)
 	struct efi_info *e = &boot_params.efi_info;
 	unsigned long pmap;
 
+	if (efi_enabled(EFI_PARAVIRT))
+		return 0;
+
 #ifdef CONFIG_X86_32
 	/* Can't handle data above 4GB at this time */
 	if (e->efi_memmap_hi) {
@@ -616,14 +619,24 @@ static int __init efi_runtime_init(void)
 	 * the runtime services table so that we can grab the physical
 	 * address of several of the EFI runtime functions, needed to
 	 * set the firmware into virtual mode.
+	 *
+	 * When EFI_PARAVIRT is in force then we could not map runtime
+	 * service memory region because we do not have direct access to it.
+	 * However, runtime services are available through proxy functions
+	 * (e.g. in case of Xen dom0 EFI implementation they call special
+	 * hypercall which executes relevant EFI functions) and that is why
+	 * they are always enabled.
 	 */
-	if (efi_enabled(EFI_64BIT))
-		rv = efi_runtime_init64();
-	else
-		rv = efi_runtime_init32();
 
-	if (rv)
-		return rv;
+	if (!efi_enabled(EFI_PARAVIRT)) {
+		if (efi_enabled(EFI_64BIT))
+			rv = efi_runtime_init64();
+		else
+			rv = efi_runtime_init32();
+
+		if (rv)
+			return rv;
+	}
 
 	set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 
@@ -632,6 +645,9 @@ static int __init efi_runtime_init(void)
 
 static int __init efi_memmap_init(void)
 {
+	if (efi_enabled(EFI_PARAVIRT))
+		return 0;
+
 	/* Map the EFI memory map */
 	memmap.map = early_memremap((unsigned long)memmap.phys_map,
 				   memmap.nr_map * memmap.desc_size);
@@ -1188,6 +1204,9 @@ static void __init __efi_enter_virtual_mode(void)
 
 void __init efi_enter_virtual_mode(void)
 {
+	if (efi_enabled(EFI_PARAVIRT))
+		return;
+
 	if (efi_setup)
 		kexec_enter_virtual_mode();
 	else
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 023937a..ac88ec0 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -104,16 +104,19 @@ static struct attribute *efi_subsys_attrs[] = {
 static umode_t efi_attr_is_visible(struct kobject *kobj,
 				   struct attribute *attr, int n)
 {
-	umode_t mode = attr->mode;
-
-	if (attr == &efi_attr_fw_vendor.attr)
-		return (efi.fw_vendor == EFI_INVALID_TABLE_ADDR) ? 0 : mode;
-	else if (attr == &efi_attr_runtime.attr)
-		return (efi.runtime == EFI_INVALID_TABLE_ADDR) ? 0 : mode;
-	else if (attr == &efi_attr_config_table.attr)
-		return (efi.config_table == EFI_INVALID_TABLE_ADDR) ? 0 : mode;
+	if (attr == &efi_attr_fw_vendor.attr) {
+		if (efi_enabled(EFI_PARAVIRT) ||
+				efi.fw_vendor == EFI_INVALID_TABLE_ADDR)
+			return 0;
+	} else if (attr == &efi_attr_runtime.attr) {
+		if (efi.runtime == EFI_INVALID_TABLE_ADDR)
+			return 0;
+	} else if (attr == &efi_attr_config_table.attr) {
+		if (efi.config_table == EFI_INVALID_TABLE_ADDR)
+			return 0;
+	}
 
-	return mode;
+	return attr->mode;
 }
 
 static struct attribute_group efi_subsys_attr_group = {
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 41bbf8b..713a4f1 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -916,7 +916,8 @@ extern int __init efi_setup_pcdp_console(char *);
 #define EFI_RUNTIME_SERVICES	3	/* Can we use runtime services? */
 #define EFI_MEMMAP		4	/* Can we use EFI memory map? */
 #define EFI_64BIT		5	/* Is the firmware 64-bit? */
-#define EFI_ARCH_1		6	/* First arch-specific bit */
+#define EFI_PARAVIRT		6	/* Access is via a paravirt interface */
+#define EFI_ARCH_1		7	/* First arch-specific bit */
 
 #ifdef CONFIG_EFI
 /*
-- 
1.7.10.4
