From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/3] efi: don't call the system table version the runtime services version
Date: Wed,  7 Sep 2016 10:56:24 -0400
Message-ID: <1473260186-4500-1-git-send-email-pjones@redhat.com>
References: <20160907122339.GB28333@wunner.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160907122339.GB28333-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The system table's hdr.revision is not the runtime services revision,
it's the EFI Spec revision.  The runtime services revision is the one on
systab->runtime->hdr.revision.

So we shouldn't call it runtime_version throughout the code, as that's
misleading if you're *actually* looking for the runtime services
revision.

We also move some of the assignments around just a bit, in support of
making a future patch more readable.

This also fixes a minor bug where the version field was not set in the
efi structure on ia64.

Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
---
 arch/ia64/kernel/efi.c                  | 3 +++
 arch/x86/platform/efi/efi.c             | 7 ++++---
 arch/x86/platform/efi/efi_64.c          | 2 +-
 arch/x86/xen/efi.c                      | 4 ++--
 drivers/firmware/efi/arm-init.c         | 5 +++--
 drivers/firmware/efi/runtime-wrappers.c | 8 ++++----
 drivers/xen/efi.c                       | 6 +++---
 include/linux/efi.h                     | 2 +-
 8 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/arch/ia64/kernel/efi.c b/arch/ia64/kernel/efi.c
index 1212956..2af99a8 100644
--- a/arch/ia64/kernel/efi.c
+++ b/arch/ia64/kernel/efi.c
@@ -513,6 +513,9 @@ efi_init (void)
 		panic("Whoa! Can't find EFI system table.\n");
 	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
 		panic("Whoa! EFI system table signature incorrect\n");
+
+	efi.spec_version = efi.systab->hdr.version;
+
 	if ((efi.systab->hdr.revision >> 16) == 0)
 		printk(KERN_WARNING "Warning: EFI system table version "
 		       "%d.%02d, expected 1.00 or greater\n",
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 1fbb408..51c091e 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -325,6 +325,9 @@ static int __init efi_systab_init(void *phys)
 		pr_err("System table signature incorrect!\n");
 		return -EINVAL;
 	}
+
+	efi.spec_version = efi.systab->hdr.revision;
+
 	if ((efi.systab->hdr.revision >> 16) == 0)
 		pr_err("Warning: System table version %d.%02d, expected 1.00 or greater!\n",
 		       efi.systab->hdr.revision >> 16,
@@ -843,7 +846,7 @@ static void __init kexec_enter_virtual_mode(void)
 	 *
 	 * Call EFI services through wrapper functions.
 	 */
-	efi.runtime_version = efi_systab.hdr.revision;
+	efi.spec_version = efi_systab.hdr.revision;
 
 	efi_native_runtime_setup();
 
@@ -939,8 +942,6 @@ static void __init __efi_enter_virtual_mode(void)
 	 *
 	 * Call EFI services through wrapper functions.
 	 */
-	efi.runtime_version = efi_systab.hdr.revision;
-
 	if (efi_is_native())
 		efi_native_runtime_setup();
 	else
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 677e29e..2366cf2 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -677,7 +677,7 @@ efi_thunk_query_variable_info(u32 attr, u64 *storage_space,
 	efi_status_t status;
 	u32 phys_storage, phys_remaining, phys_max;
 
-	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
+	if (efi.spec_version < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
 	phys_storage = virt_to_phys(storage_space);
diff --git a/arch/x86/xen/efi.c b/arch/x86/xen/efi.c
index 3be0121..e7c8357 100644
--- a/arch/x86/xen/efi.c
+++ b/arch/x86/xen/efi.c
@@ -56,7 +56,7 @@ static efi_system_table_t efi_systab_xen __initdata = {
 
 static const struct efi efi_xen __initconst = {
 	.systab                   = NULL, /* Initialized later. */
-	.runtime_version	  = 0,    /* Initialized later. */
+	.spec_version		  = 0,    /* Initialized_later. */
 	.mps                      = EFI_INVALID_TABLE_ADDR,
 	.acpi                     = EFI_INVALID_TABLE_ADDR,
 	.acpi20                   = EFI_INVALID_TABLE_ADDR,
@@ -131,7 +131,7 @@ static efi_system_table_t __init *xen_efi_probe(void)
 	op.u.firmware_info.index = XEN_FW_EFI_RT_VERSION;
 
 	if (HYPERVISOR_platform_op(&op) == 0)
-		efi.runtime_version = info->version;
+		efi.spec_version = info->version;
 
 	return &efi_systab_xen;
 }
diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
index c49d50e..8f4aeba 100644
--- a/drivers/firmware/efi/arm-init.c
+++ b/drivers/firmware/efi/arm-init.c
@@ -112,13 +112,14 @@ static int __init uefi_init(void)
 		retval = -EINVAL;
 		goto out;
 	}
+
+	efi.spec_version = efi.systab->hdr.revision;
+
 	if ((efi.systab->hdr.revision >> 16) < 2)
 		pr_warn("Warning: EFI system table version %d.%02d, expected 2.00 or greater\n",
 			efi.systab->hdr.revision >> 16,
 			efi.systab->hdr.revision & 0xffff);
 
-	efi.runtime_version = efi.systab->hdr.revision;
-
 	/* Show what we know for posterity */
 	c16 = early_memremap_ro(efi_to_phys(efi.systab->fw_vendor),
 				sizeof(vendor) * sizeof(efi_char16_t));
diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index 4195877..753df73 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -196,7 +196,7 @@ static efi_status_t virt_efi_query_variable_info(u32 attr,
 {
 	efi_status_t status;
 
-	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
+	if (efi.spec_version < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
 	spin_lock(&efi_runtime_lock);
@@ -214,7 +214,7 @@ virt_efi_query_variable_info_nonblocking(u32 attr,
 {
 	efi_status_t status;
 
-	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
+	if (efi.spec_version < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
 	if (!spin_trylock(&efi_runtime_lock))
@@ -252,7 +252,7 @@ static efi_status_t virt_efi_update_capsule(efi_capsule_header_t **capsules,
 {
 	efi_status_t status;
 
-	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
+	if (efi.spec_version < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
 	spin_lock(&efi_runtime_lock);
@@ -268,7 +268,7 @@ static efi_status_t virt_efi_query_capsule_caps(efi_capsule_header_t **capsules,
 {
 	efi_status_t status;
 
-	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
+	if (efi.spec_version < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
 	spin_lock(&efi_runtime_lock);
diff --git a/drivers/xen/efi.c b/drivers/xen/efi.c
index 22f71ff..44294b6 100644
--- a/drivers/xen/efi.c
+++ b/drivers/xen/efi.c
@@ -192,7 +192,7 @@ efi_status_t xen_efi_query_variable_info(u32 attr, u64 *storage_space,
 {
 	struct xen_platform_op op = INIT_EFI_OP(query_variable_info);
 
-	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
+	if (efi.spec_version < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
 	efi_data(op).u.query_variable_info.attr = attr;
@@ -226,7 +226,7 @@ efi_status_t xen_efi_update_capsule(efi_capsule_header_t **capsules,
 {
 	struct xen_platform_op op = INIT_EFI_OP(update_capsule);
 
-	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
+	if (efi.spec_version < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
 	set_xen_guest_handle(efi_data(op).u.update_capsule.capsule_header_array,
@@ -247,7 +247,7 @@ efi_status_t xen_efi_query_capsule_caps(efi_capsule_header_t **capsules,
 {
 	struct xen_platform_op op = INIT_EFI_OP(query_capsule_capabilities);
 
-	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
+	if (efi.spec_version < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
 	set_xen_guest_handle(efi_data(op).u.query_capsule_capabilities.capsule_header_array,
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 7f5a582..c6a3126 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -826,7 +826,7 @@ typedef struct {
  */
 extern struct efi {
 	efi_system_table_t *systab;	/* EFI system table */
-	unsigned int runtime_version;	/* Runtime services version */
+	u32 spec_version;		/* EFI Spec revision of our firmware */
 	unsigned long mps;		/* MPS table */
 	unsigned long acpi;		/* ACPI table  (IA64 ext 0.71) */
 	unsigned long acpi20;		/* ACPI table  (ACPI 2.0) */
-- 
2.7.4
