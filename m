From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] efi: don't call the system table version the runtime services version
Date: Tue, 23 Aug 2016 12:13:51 -0400
Message-ID: <1471968832-19847-1-git-send-email-pjones@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The system table's hdr.revision is not the runtime services revision,
it's the EFI Spec revision.  The runtime services revision is the one on
systab->runtime->hdr.revision.

So we shouldn't call it runtime_version throughtout the code, as that's
misleading if you're *actually* looking for the runtime services
revision.

Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/platform/efi/efi.c             | 6 ++++--
 arch/x86/platform/efi/efi_64.c          | 2 +-
 arch/x86/xen/efi.c                      | 4 ++--
 drivers/firmware/efi/arm-init.c         | 4 ++--
 drivers/firmware/efi/runtime-wrappers.c | 8 ++++----
 drivers/xen/efi.c                       | 6 +++---
 include/linux/efi.h                     | 2 +-
 7 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 1fbb408..e36290e 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -468,6 +468,8 @@ void __init efi_init(void)
 	efi.fw_vendor	 = (unsigned long)efi.systab->fw_vendor;
 	efi.runtime	 = (unsigned long)efi.systab->runtime;
 
+	efi.spec_version = efi.systab->hdr.revision;
+
 	/*
 	 * Show what we know for posterity
 	 */
@@ -843,7 +845,7 @@ static void __init kexec_enter_virtual_mode(void)
 	 *
 	 * Call EFI services through wrapper functions.
 	 */
-	efi.runtime_version = efi_systab.hdr.revision;
+	efi.spec_version = efi_systab.hdr.revision;
 
 	efi_native_runtime_setup();
 
@@ -939,7 +941,7 @@ static void __init __efi_enter_virtual_mode(void)
 	 *
 	 * Call EFI services through wrapper functions.
 	 */
-	efi.runtime_version = efi_systab.hdr.revision;
+	efi.spec_version = efi_systab.hdr.revision;
 
 	if (efi_is_native())
 		efi_native_runtime_setup();
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
index c49d50e..b89fc23 100644
--- a/drivers/firmware/efi/arm-init.c
+++ b/drivers/firmware/efi/arm-init.c
@@ -117,8 +117,6 @@ static int __init uefi_init(void)
 			efi.systab->hdr.revision >> 16,
 			efi.systab->hdr.revision & 0xffff);
 
-	efi.runtime_version = efi.systab->hdr.revision;
-
 	/* Show what we know for posterity */
 	c16 = early_memremap_ro(efi_to_phys(efi.systab->fw_vendor),
 				sizeof(vendor) * sizeof(efi_char16_t));
@@ -133,6 +131,8 @@ static int __init uefi_init(void)
 		efi.systab->hdr.revision >> 16,
 		efi.systab->hdr.revision & 0xffff, vendor);
 
+	efi.spec_version = (u32)efi.systab->hdr.revision;
+
 	table_size = sizeof(efi_config_table_64_t) * efi.systab->nr_tables;
 	config_tables = early_memremap_ro(efi_to_phys(efi.systab->tables),
 					  table_size);
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
