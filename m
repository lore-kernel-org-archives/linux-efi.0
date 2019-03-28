From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4/5] efi: Unify dmi setup code over architectures arm/arm64, ia64 and x86
Date: Thu, 28 Mar 2019 20:34:28 +0100
Message-ID: <20190328193429.21373-5-ard.biesheuvel@linaro.org>
References: <20190328193429.21373-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190328193429.21373-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Robert Richter <rrichter@marvell.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Jean Delvare <jdelvare@suse.de>
List-Id: linux-efi@vger.kernel.org

From: Robert Richter <rrichter@marvell.com>

All architectures (arm/arm64, ia64 and x86) do the same here, so unify
the code.

Note: We do not need to call dump_stack_set_arch_desc() in case of
!dmi_available. Both strings, dmi_ids_string and dump_stack_arch_
desc_str are initialized zero and thus nothing would change.

Signed-off-by: Robert Richter <rrichter@marvell.com>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/ia64/kernel/setup.c           |  4 +---
 arch/x86/kernel/setup.c            |  6 ++----
 drivers/firmware/dmi_scan.c        | 28 +++++++++++++++-------------
 drivers/firmware/efi/arm-runtime.c |  7 ++-----
 include/linux/dmi.h                |  8 ++------
 5 files changed, 22 insertions(+), 31 deletions(-)

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
index 4a0dfe4ab829..e2ac5fa5531b 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -162,14 +162,11 @@ void efi_virtmap_unload(void)
 static int __init arm_dmi_init(void)
 {
 	/*
-	 * On arm64/ARM, DMI depends on UEFI, and dmi_scan_machine() needs to
+	 * On arm64/ARM, DMI depends on UEFI, and dmi_setup() needs to
 	 * be called early because dmi_id_init(), which is an arch_initcall
 	 * itself, depends on dmi_scan_machine() having been called already.
 	 */
-	dmi_scan_machine();
-	dmi_memdev_walk();
-	if (dmi_available)
-		dmi_set_dump_stack_arch_desc();
+	dmi_setup();
 	return 0;
 }
 core_initcall(arm_dmi_init);
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
-- 
2.20.1
