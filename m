From: Ingo Molnar <mingo@kernel.org>
Subject: [GIT PULL] EFI changes for v5.2
Date: Mon, 6 May 2019 10:17:59 +0200
Message-ID: <20190506081759.GA30024@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, James Morse <james.morse@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
List-Id: linux-efi@vger.kernel.org

Linus,

Please pull the latest efi-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git efi-core-for-linus

   # HEAD: 02562d0ca1084a688ac5c92e0e92947f62f13093 efi/libstub/arm: Omit unneeded stripping of ksymtab/kcrctab sections

The changes in this cycle were:

 - Squash a spurious warning when using the EFI framebuffer on a non-EFI boot
 - Use DMI data to annotate RAS memory errors on ARM just like we do on Intel
 - Followup cleanups for DMI
 - libstub Makefile cleanups

 Thanks,

	Ingo

------------------>
Ard Biesheuvel (2):
      efifb: Omit memory map check on legacy boot
      efi/libstub/arm: Omit unneeded stripping of ksymtab/kcrctab sections

Marcin Benka (1):
      efi/arm: Show SMBIOS bank/device location in CPER and GHES error logs

Masahiro Yamada (1):
      efi/libstub: Refactor the cmd_stubcopy Makefile command

Robert Richter (1):
      efi: Unify DMI setup code over the arm/arm64, ia64 and x86 architectures


 arch/ia64/kernel/setup.c              |  4 +---
 arch/x86/kernel/setup.c               |  6 ++----
 drivers/firmware/dmi_scan.c           | 28 +++++++++++++++-------------
 drivers/firmware/efi/arm-runtime.c    |  6 ++----
 drivers/firmware/efi/libstub/Makefile | 14 +++++++-------
 drivers/video/fbdev/efifb.c           |  3 ++-
 include/linux/dmi.h                   |  8 ++------
 7 files changed, 31 insertions(+), 38 deletions(-)

diff --git a/arch/ia64/kernel/setup.c b/arch/ia64/kernel/setup.c
index 583a3746d70b..c9cfa760cd57 100644
--- a/arch/ia64/kernel/setup.c
+++ b/arch/ia64/kernel/setup.c
@@ -1058,9 +1058,7 @@ check_bugs (void)
 
 static int __init run_dmi_scan(void)
 {
-	dmi_scan_machine();
-	dmi_memdev_walk();
-	dmi_set_dump_stack_arch_desc();
+	dmi_setup();
 	return 0;
 }
 core_initcall(run_dmi_scan);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 3d872a527cd9..3773905cd2c1 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1005,13 +1005,11 @@ void __init setup_arch(char **cmdline_p)
 	if (efi_enabled(EFI_BOOT))
 		efi_init();
 
-	dmi_scan_machine();
-	dmi_memdev_walk();
-	dmi_set_dump_stack_arch_desc();
+	dmi_setup();
 
 	/*
 	 * VMware detection requires dmi to be available, so this
-	 * needs to be done after dmi_scan_machine(), for the boot CPU.
+	 * needs to be done after dmi_setup(), for the boot CPU.
 	 */
 	init_hypervisor_platform();
 
diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 099d83e4e910..fae2d5c43314 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -416,11 +416,8 @@ static void __init save_mem_devices(const struct dmi_header *dm, void *v)
 	nr++;
 }
 
-void __init dmi_memdev_walk(void)
+static void __init dmi_memdev_walk(void)
 {
-	if (!dmi_available)
-		return;
-
 	if (dmi_walk_early(count_mem_devices) == 0 && dmi_memdev_nr) {
 		dmi_memdev = dmi_alloc(sizeof(*dmi_memdev) * dmi_memdev_nr);
 		if (dmi_memdev)
@@ -614,7 +611,7 @@ static int __init dmi_smbios3_present(const u8 *buf)
 	return 1;
 }
 
-void __init dmi_scan_machine(void)
+static void __init dmi_scan_machine(void)
 {
 	char __iomem *p, *q;
 	char buf[32];
@@ -769,15 +766,20 @@ static int __init dmi_init(void)
 subsys_initcall(dmi_init);
 
 /**
- * dmi_set_dump_stack_arch_desc - set arch description for dump_stack()
+ *	dmi_setup - scan and setup DMI system information
  *
- * Invoke dump_stack_set_arch_desc() with DMI system information so that
- * DMI identifiers are printed out on task dumps.  Arch boot code should
- * call this function after dmi_scan_machine() if it wants to print out DMI
- * identifiers on task dumps.
+ *	Scan the DMI system information. This setups DMI identifiers
+ *	(dmi_system_id) for printing it out on task dumps and prepares
+ *	DIMM entry information (dmi_memdev_info) from the SMBIOS table
+ *	for using this when reporting memory errors.
  */
-void __init dmi_set_dump_stack_arch_desc(void)
+void __init dmi_setup(void)
 {
+	dmi_scan_machine();
+	if (!dmi_available)
+		return;
+
+	dmi_memdev_walk();
 	dump_stack_set_arch_desc("%s", dmi_ids_string);
 }
 
@@ -841,7 +843,7 @@ static bool dmi_is_end_of_table(const struct dmi_system_id *dmi)
  *	returns non zero or we hit the end. Callback function is called for
  *	each successful match. Returns the number of matches.
  *
- *	dmi_scan_machine must be called before this function is called.
+ *	dmi_setup must be called before this function is called.
  */
 int dmi_check_system(const struct dmi_system_id *list)
 {
@@ -871,7 +873,7 @@ EXPORT_SYMBOL(dmi_check_system);
  *	Walk the blacklist table until the first match is found.  Return the
  *	pointer to the matching entry or NULL if there's no match.
  *
- *	dmi_scan_machine must be called before this function is called.
+ *	dmi_setup must be called before this function is called.
  */
 const struct dmi_system_id *dmi_first_match(const struct dmi_system_id *list)
 {
diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
index 0c1af675c338..e2ac5fa5531b 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -162,13 +162,11 @@ void efi_virtmap_unload(void)
 static int __init arm_dmi_init(void)
 {
 	/*
-	 * On arm64/ARM, DMI depends on UEFI, and dmi_scan_machine() needs to
+	 * On arm64/ARM, DMI depends on UEFI, and dmi_setup() needs to
 	 * be called early because dmi_id_init(), which is an arch_initcall
 	 * itself, depends on dmi_scan_machine() having been called already.
 	 */
-	dmi_scan_machine();
-	if (dmi_available)
-		dmi_set_dump_stack_arch_desc();
+	dmi_setup();
 	return 0;
 }
 core_initcall(arm_dmi_init);
diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index b0103e16fc1b..b1f7b64652db 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -71,7 +71,6 @@ CFLAGS_arm64-stub.o		:= -DTEXT_OFFSET=$(TEXT_OFFSET)
 extra-$(CONFIG_EFI_ARMSTUB)	:= $(lib-y)
 lib-$(CONFIG_EFI_ARMSTUB)	:= $(patsubst %.o,%.stub.o,$(lib-y))
 
-STUBCOPY_RM-y			:= -R *ksymtab* -R *kcrctab*
 STUBCOPY_FLAGS-$(CONFIG_ARM64)	+= --prefix-alloc-sections=.init \
 				   --prefix-symbols=__efistub_
 STUBCOPY_RELOC-$(CONFIG_ARM64)	:= R_AARCH64_ABS
@@ -86,12 +85,13 @@ $(obj)/%.stub.o: $(obj)/%.o FORCE
 # this time, use objcopy and leave all sections in place.
 #
 quiet_cmd_stubcopy = STUBCPY $@
-      cmd_stubcopy = if $(STRIP) --strip-debug $(STUBCOPY_RM-y) -o $@ $<; \
-		     then if $(OBJDUMP) -r $@ | grep $(STUBCOPY_RELOC-y); \
-		     then (echo >&2 "$@: absolute symbol references not allowed in the EFI stub"; \
-			   rm -f $@; /bin/false);			  \
-		     else $(OBJCOPY) $(STUBCOPY_FLAGS-y) $< $@; fi	  \
-		     else /bin/false; fi
+      cmd_stubcopy =							\
+	$(STRIP) --strip-debug -o $@ $<;				\
+	if $(OBJDUMP) -r $@ | grep $(STUBCOPY_RELOC-y); then		\
+		echo "$@: absolute symbol references not allowed in the EFI stub" >&2; \
+		/bin/false;						\
+	fi;								\
+	$(OBJCOPY) $(STUBCOPY_FLAGS-y) $< $@
 
 #
 # ARM discards the .data section because it disallows r/w data in the
diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
index ba906876cc45..9e529cc2b4ff 100644
--- a/drivers/video/fbdev/efifb.c
+++ b/drivers/video/fbdev/efifb.c
@@ -464,7 +464,8 @@ static int efifb_probe(struct platform_device *dev)
 	info->apertures->ranges[0].base = efifb_fix.smem_start;
 	info->apertures->ranges[0].size = size_remap;
 
-	if (!efi_mem_desc_lookup(efifb_fix.smem_start, &md)) {
+	if (efi_enabled(EFI_BOOT) &&
+	    !efi_mem_desc_lookup(efifb_fix.smem_start, &md)) {
 		if ((efifb_fix.smem_start + efifb_fix.smem_len) >
 		    (md.phys_addr + (md.num_pages << EFI_PAGE_SHIFT))) {
 			pr_err("efifb: video memory @ 0x%lx spans multiple EFI memory regions\n",
diff --git a/include/linux/dmi.h b/include/linux/dmi.h
index c46fdb36700b..8de8c4f15163 100644
--- a/include/linux/dmi.h
+++ b/include/linux/dmi.h
@@ -102,9 +102,7 @@ const struct dmi_system_id *dmi_first_match(const struct dmi_system_id *list);
 extern const char * dmi_get_system_info(int field);
 extern const struct dmi_device * dmi_find_device(int type, const char *name,
 	const struct dmi_device *from);
-extern void dmi_scan_machine(void);
-extern void dmi_memdev_walk(void);
-extern void dmi_set_dump_stack_arch_desc(void);
+extern void dmi_setup(void);
 extern bool dmi_get_date(int field, int *yearp, int *monthp, int *dayp);
 extern int dmi_get_bios_year(void);
 extern int dmi_name_in_vendors(const char *str);
@@ -122,9 +120,7 @@ static inline int dmi_check_system(const struct dmi_system_id *list) { return 0;
 static inline const char * dmi_get_system_info(int field) { return NULL; }
 static inline const struct dmi_device * dmi_find_device(int type, const char *name,
 	const struct dmi_device *from) { return NULL; }
-static inline void dmi_scan_machine(void) { return; }
-static inline void dmi_memdev_walk(void) { }
-static inline void dmi_set_dump_stack_arch_desc(void) { }
+static inline void dmi_setup(void) { }
 static inline bool dmi_get_date(int field, int *yearp, int *monthp, int *dayp)
 {
 	if (yearp)
