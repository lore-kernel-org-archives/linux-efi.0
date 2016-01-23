From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v3 14/17] XEN: EFI: Move x86 specific codes to
	architecture directory
Date: Sat, 23 Jan 2016 11:19:41 +0800
Message-ID: <1453519184-11908-15-git-send-email-zhaoshenglong@huawei.com>
References: <1453519184-11908-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xen.org>
In-Reply-To: <1453519184-11908-1-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <http://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <http://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Sender: xen-devel-bounces@lists.xen.org
Errors-To: xen-devel-bounces@lists.xen.org
To: linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, mark.rutland@arm.com, stefano.stabellini@citrix.com, david.vrabel@citrix.com
Cc: devicetree@vger.kernel.org, linux-efi@vger.kernel.org, ian.campbell@citrix.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, xen-devel@lists.xen.org, julien.grall@citrix.com, shannon.zhao@linaro.org, peter.huangpeng@huawei.com
List-Id: linux-efi@vger.kernel.org

From: Shannon Zhao <shannon.zhao@linaro.org>

Move x86 specific codes to architecture directory and export those EFI
runtime service functions. This will be useful for initializing runtime
service on ARM later.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/x86/xen/efi.c    | 112 ++++++++++++++++++++++++++++++++
 drivers/xen/efi.c     | 174 ++++++++++----------------------------------------
 include/xen/xen-ops.h |  30 ++++++---
 3 files changed, 168 insertions(+), 148 deletions(-)

diff --git a/arch/x86/xen/efi.c b/arch/x86/xen/efi.c
index be14cc3..86527f1 100644
--- a/arch/x86/xen/efi.c
+++ b/arch/x86/xen/efi.c
@@ -20,10 +20,122 @@
 #include <linux/init.h>
 #include <linux/string.h>
 
+#include <xen/xen.h>
 #include <xen/xen-ops.h>
+#include <xen/interface/platform.h>
 
 #include <asm/page.h>
 #include <asm/setup.h>
+#include <asm/xen/hypercall.h>
+
+static efi_char16_t vendor[100] __initdata;
+
+static efi_system_table_t efi_systab_xen __initdata = {
+	.hdr = {
+		.signature	= EFI_SYSTEM_TABLE_SIGNATURE,
+		.revision	= 0, /* Initialized later. */
+		.headersize	= 0, /* Ignored by Linux Kernel. */
+		.crc32		= 0, /* Ignored by Linux Kernel. */
+		.reserved	= 0
+	},
+	.fw_vendor	= EFI_INVALID_TABLE_ADDR, /* Initialized later. */
+	.fw_revision	= 0,			  /* Initialized later. */
+	.con_in_handle	= EFI_INVALID_TABLE_ADDR, /* Not used under Xen. */
+	.con_in		= EFI_INVALID_TABLE_ADDR, /* Not used under Xen. */
+	.con_out_handle	= EFI_INVALID_TABLE_ADDR, /* Not used under Xen. */
+	.con_out	= EFI_INVALID_TABLE_ADDR, /* Not used under Xen. */
+	.stderr_handle	= EFI_INVALID_TABLE_ADDR, /* Not used under Xen. */
+	.stderr		= EFI_INVALID_TABLE_ADDR, /* Not used under Xen. */
+	.runtime	= (efi_runtime_services_t *)EFI_INVALID_TABLE_ADDR,
+						  /* Not used under Xen. */
+	.boottime	= (efi_boot_services_t *)EFI_INVALID_TABLE_ADDR,
+						  /* Not used under Xen. */
+	.nr_tables	= 0,			  /* Initialized later. */
+	.tables		= EFI_INVALID_TABLE_ADDR  /* Initialized later. */
+};
+
+static const struct efi efi_xen __initconst = {
+	.systab                   = NULL, /* Initialized later. */
+	.runtime_version	  = 0,    /* Initialized later. */
+	.mps                      = EFI_INVALID_TABLE_ADDR,
+	.acpi                     = EFI_INVALID_TABLE_ADDR,
+	.acpi20                   = EFI_INVALID_TABLE_ADDR,
+	.smbios                   = EFI_INVALID_TABLE_ADDR,
+	.smbios3                  = EFI_INVALID_TABLE_ADDR,
+	.sal_systab               = EFI_INVALID_TABLE_ADDR,
+	.boot_info                = EFI_INVALID_TABLE_ADDR,
+	.hcdp                     = EFI_INVALID_TABLE_ADDR,
+	.uga                      = EFI_INVALID_TABLE_ADDR,
+	.uv_systab                = EFI_INVALID_TABLE_ADDR,
+	.fw_vendor                = EFI_INVALID_TABLE_ADDR,
+	.runtime                  = EFI_INVALID_TABLE_ADDR,
+	.config_table             = EFI_INVALID_TABLE_ADDR,
+	.get_time                 = xen_efi_get_time,
+	.set_time                 = xen_efi_set_time,
+	.get_wakeup_time          = xen_efi_get_wakeup_time,
+	.set_wakeup_time          = xen_efi_set_wakeup_time,
+	.get_variable             = xen_efi_get_variable,
+	.get_next_variable        = xen_efi_get_next_variable,
+	.set_variable             = xen_efi_set_variable,
+	.query_variable_info      = xen_efi_query_variable_info,
+	.update_capsule           = xen_efi_update_capsule,
+	.query_capsule_caps       = xen_efi_query_capsule_caps,
+	.get_next_high_mono_count = xen_efi_get_next_high_mono_count,
+	.reset_system             = NULL, /* Functionality provided by Xen. */
+	.set_virtual_address_map  = NULL, /* Not used under Xen. */
+	.memmap                   = NULL, /* Not used under Xen. */
+	.flags			  = 0     /* Initialized later. */
+};
+
+static efi_system_table_t __init *xen_efi_probe(void)
+{
+	struct xen_platform_op op = {
+		.cmd = XENPF_firmware_info,
+		.u.firmware_info = {
+			.type = XEN_FW_EFI_INFO,
+			.index = XEN_FW_EFI_CONFIG_TABLE
+		}
+	};
+	union xenpf_efi_info *info = &op.u.firmware_info.u.efi_info;
+
+	if (!xen_initial_domain() || HYPERVISOR_platform_op(&op) < 0)
+		return NULL;
+
+	/* Here we know that Xen runs on EFI platform. */
+
+	efi = efi_xen;
+
+	efi_systab_xen.tables = info->cfg.addr;
+	efi_systab_xen.nr_tables = info->cfg.nent;
+
+	op.cmd = XENPF_firmware_info;
+	op.u.firmware_info.type = XEN_FW_EFI_INFO;
+	op.u.firmware_info.index = XEN_FW_EFI_VENDOR;
+	info->vendor.bufsz = sizeof(vendor);
+	set_xen_guest_handle(info->vendor.name, vendor);
+
+	if (HYPERVISOR_platform_op(&op) == 0) {
+		efi_systab_xen.fw_vendor = __pa_symbol(vendor);
+		efi_systab_xen.fw_revision = info->vendor.revision;
+	} else
+		efi_systab_xen.fw_vendor = __pa_symbol(L"UNKNOWN");
+
+	op.cmd = XENPF_firmware_info;
+	op.u.firmware_info.type = XEN_FW_EFI_INFO;
+	op.u.firmware_info.index = XEN_FW_EFI_VERSION;
+
+	if (HYPERVISOR_platform_op(&op) == 0)
+		efi_systab_xen.hdr.revision = info->version;
+
+	op.cmd = XENPF_firmware_info;
+	op.u.firmware_info.type = XEN_FW_EFI_INFO;
+	op.u.firmware_info.index = XEN_FW_EFI_RT_VERSION;
+
+	if (HYPERVISOR_platform_op(&op) == 0)
+		efi.runtime_version = info->version;
+
+	return &efi_systab_xen;
+}
 
 void __init xen_efi_init(void)
 {
diff --git a/drivers/xen/efi.c b/drivers/xen/efi.c
index be7e56a..22f71ff 100644
--- a/drivers/xen/efi.c
+++ b/drivers/xen/efi.c
@@ -38,7 +38,7 @@
 
 #define efi_data(op)	(op.u.efi_runtime_call)
 
-static efi_status_t xen_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
+efi_status_t xen_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
 {
 	struct xen_platform_op op = INIT_EFI_OP(get_time);
 
@@ -59,8 +59,9 @@ static efi_status_t xen_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
 
 	return efi_data(op).status;
 }
+EXPORT_SYMBOL_GPL(xen_efi_get_time);
 
-static efi_status_t xen_efi_set_time(efi_time_t *tm)
+efi_status_t xen_efi_set_time(efi_time_t *tm)
 {
 	struct xen_platform_op op = INIT_EFI_OP(set_time);
 
@@ -72,10 +73,10 @@ static efi_status_t xen_efi_set_time(efi_time_t *tm)
 
 	return efi_data(op).status;
 }
+EXPORT_SYMBOL_GPL(xen_efi_set_time);
 
-static efi_status_t xen_efi_get_wakeup_time(efi_bool_t *enabled,
-					    efi_bool_t *pending,
-					    efi_time_t *tm)
+efi_status_t xen_efi_get_wakeup_time(efi_bool_t *enabled, efi_bool_t *pending,
+				     efi_time_t *tm)
 {
 	struct xen_platform_op op = INIT_EFI_OP(get_wakeup_time);
 
@@ -95,8 +96,9 @@ static efi_status_t xen_efi_get_wakeup_time(efi_bool_t *enabled,
 
 	return efi_data(op).status;
 }
+EXPORT_SYMBOL_GPL(xen_efi_get_wakeup_time);
 
-static efi_status_t xen_efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
+efi_status_t xen_efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
 {
 	struct xen_platform_op op = INIT_EFI_OP(set_wakeup_time);
 
@@ -113,12 +115,11 @@ static efi_status_t xen_efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
 
 	return efi_data(op).status;
 }
+EXPORT_SYMBOL_GPL(xen_efi_set_wakeup_time);
 
-static efi_status_t xen_efi_get_variable(efi_char16_t *name,
-					 efi_guid_t *vendor,
-					 u32 *attr,
-					 unsigned long *data_size,
-					 void *data)
+efi_status_t xen_efi_get_variable(efi_char16_t *name, efi_guid_t *vendor,
+				  u32 *attr, unsigned long *data_size,
+				  void *data)
 {
 	struct xen_platform_op op = INIT_EFI_OP(get_variable);
 
@@ -138,10 +139,11 @@ static efi_status_t xen_efi_get_variable(efi_char16_t *name,
 
 	return efi_data(op).status;
 }
+EXPORT_SYMBOL_GPL(xen_efi_get_variable);
 
-static efi_status_t xen_efi_get_next_variable(unsigned long *name_size,
-					      efi_char16_t *name,
-					      efi_guid_t *vendor)
+efi_status_t xen_efi_get_next_variable(unsigned long *name_size,
+				       efi_char16_t *name,
+				       efi_guid_t *vendor)
 {
 	struct xen_platform_op op = INIT_EFI_OP(get_next_variable_name);
 
@@ -161,12 +163,11 @@ static efi_status_t xen_efi_get_next_variable(unsigned long *name_size,
 
 	return efi_data(op).status;
 }
+EXPORT_SYMBOL_GPL(xen_efi_get_next_variable);
 
-static efi_status_t xen_efi_set_variable(efi_char16_t *name,
-					 efi_guid_t *vendor,
-					 u32 attr,
-					 unsigned long data_size,
-					 void *data)
+efi_status_t xen_efi_set_variable(efi_char16_t *name, efi_guid_t *vendor,
+				 u32 attr, unsigned long data_size,
+				 void *data)
 {
 	struct xen_platform_op op = INIT_EFI_OP(set_variable);
 
@@ -183,11 +184,11 @@ static efi_status_t xen_efi_set_variable(efi_char16_t *name,
 
 	return efi_data(op).status;
 }
+EXPORT_SYMBOL_GPL(xen_efi_set_variable);
 
-static efi_status_t xen_efi_query_variable_info(u32 attr,
-						u64 *storage_space,
-						u64 *remaining_space,
-						u64 *max_variable_size)
+efi_status_t xen_efi_query_variable_info(u32 attr, u64 *storage_space,
+					 u64 *remaining_space,
+					 u64 *max_variable_size)
 {
 	struct xen_platform_op op = INIT_EFI_OP(query_variable_info);
 
@@ -205,8 +206,9 @@ static efi_status_t xen_efi_query_variable_info(u32 attr,
 
 	return efi_data(op).status;
 }
+EXPORT_SYMBOL_GPL(xen_efi_query_variable_info);
 
-static efi_status_t xen_efi_get_next_high_mono_count(u32 *count)
+efi_status_t xen_efi_get_next_high_mono_count(u32 *count)
 {
 	struct xen_platform_op op = INIT_EFI_OP(get_next_high_monotonic_count);
 
@@ -217,10 +219,10 @@ static efi_status_t xen_efi_get_next_high_mono_count(u32 *count)
 
 	return efi_data(op).status;
 }
+EXPORT_SYMBOL_GPL(xen_efi_get_next_high_mono_count);
 
-static efi_status_t xen_efi_update_capsule(efi_capsule_header_t **capsules,
-					   unsigned long count,
-					   unsigned long sg_list)
+efi_status_t xen_efi_update_capsule(efi_capsule_header_t **capsules,
+				    unsigned long count, unsigned long sg_list)
 {
 	struct xen_platform_op op = INIT_EFI_OP(update_capsule);
 
@@ -237,11 +239,11 @@ static efi_status_t xen_efi_update_capsule(efi_capsule_header_t **capsules,
 
 	return efi_data(op).status;
 }
+EXPORT_SYMBOL_GPL(xen_efi_update_capsule);
 
-static efi_status_t xen_efi_query_capsule_caps(efi_capsule_header_t **capsules,
-					       unsigned long count,
-					       u64 *max_size,
-					       int *reset_type)
+efi_status_t xen_efi_query_capsule_caps(efi_capsule_header_t **capsules,
+					unsigned long count, u64 *max_size,
+					int *reset_type)
 {
 	struct xen_platform_op op = INIT_EFI_OP(query_capsule_capabilities);
 
@@ -260,112 +262,4 @@ static efi_status_t xen_efi_query_capsule_caps(efi_capsule_header_t **capsules,
 
 	return efi_data(op).status;
 }
-
-static efi_char16_t vendor[100] __initdata;
-
-static efi_system_table_t efi_systab_xen __initdata = {
-	.hdr = {
-		.signature	= EFI_SYSTEM_TABLE_SIGNATURE,
-		.revision	= 0, /* Initialized later. */
-		.headersize	= 0, /* Ignored by Linux Kernel. */
-		.crc32		= 0, /* Ignored by Linux Kernel. */
-		.reserved	= 0
-	},
-	.fw_vendor	= EFI_INVALID_TABLE_ADDR, /* Initialized later. */
-	.fw_revision	= 0,			  /* Initialized later. */
-	.con_in_handle	= EFI_INVALID_TABLE_ADDR, /* Not used under Xen. */
-	.con_in		= EFI_INVALID_TABLE_ADDR, /* Not used under Xen. */
-	.con_out_handle	= EFI_INVALID_TABLE_ADDR, /* Not used under Xen. */
-	.con_out	= EFI_INVALID_TABLE_ADDR, /* Not used under Xen. */
-	.stderr_handle	= EFI_INVALID_TABLE_ADDR, /* Not used under Xen. */
-	.stderr		= EFI_INVALID_TABLE_ADDR, /* Not used under Xen. */
-	.runtime	= (efi_runtime_services_t *)EFI_INVALID_TABLE_ADDR,
-						  /* Not used under Xen. */
-	.boottime	= (efi_boot_services_t *)EFI_INVALID_TABLE_ADDR,
-						  /* Not used under Xen. */
-	.nr_tables	= 0,			  /* Initialized later. */
-	.tables		= EFI_INVALID_TABLE_ADDR  /* Initialized later. */
-};
-
-static const struct efi efi_xen __initconst = {
-	.systab                   = NULL, /* Initialized later. */
-	.runtime_version	  = 0,    /* Initialized later. */
-	.mps                      = EFI_INVALID_TABLE_ADDR,
-	.acpi                     = EFI_INVALID_TABLE_ADDR,
-	.acpi20                   = EFI_INVALID_TABLE_ADDR,
-	.smbios                   = EFI_INVALID_TABLE_ADDR,
-	.smbios3                  = EFI_INVALID_TABLE_ADDR,
-	.sal_systab               = EFI_INVALID_TABLE_ADDR,
-	.boot_info                = EFI_INVALID_TABLE_ADDR,
-	.hcdp                     = EFI_INVALID_TABLE_ADDR,
-	.uga                      = EFI_INVALID_TABLE_ADDR,
-	.uv_systab                = EFI_INVALID_TABLE_ADDR,
-	.fw_vendor                = EFI_INVALID_TABLE_ADDR,
-	.runtime                  = EFI_INVALID_TABLE_ADDR,
-	.config_table             = EFI_INVALID_TABLE_ADDR,
-	.get_time                 = xen_efi_get_time,
-	.set_time                 = xen_efi_set_time,
-	.get_wakeup_time          = xen_efi_get_wakeup_time,
-	.set_wakeup_time          = xen_efi_set_wakeup_time,
-	.get_variable             = xen_efi_get_variable,
-	.get_next_variable        = xen_efi_get_next_variable,
-	.set_variable             = xen_efi_set_variable,
-	.query_variable_info      = xen_efi_query_variable_info,
-	.update_capsule           = xen_efi_update_capsule,
-	.query_capsule_caps       = xen_efi_query_capsule_caps,
-	.get_next_high_mono_count = xen_efi_get_next_high_mono_count,
-	.reset_system             = NULL, /* Functionality provided by Xen. */
-	.set_virtual_address_map  = NULL, /* Not used under Xen. */
-	.memmap                   = NULL, /* Not used under Xen. */
-	.flags			  = 0     /* Initialized later. */
-};
-
-efi_system_table_t __init *xen_efi_probe(void)
-{
-	struct xen_platform_op op = {
-		.cmd = XENPF_firmware_info,
-		.u.firmware_info = {
-			.type = XEN_FW_EFI_INFO,
-			.index = XEN_FW_EFI_CONFIG_TABLE
-		}
-	};
-	union xenpf_efi_info *info = &op.u.firmware_info.u.efi_info;
-
-	if (!xen_initial_domain() || HYPERVISOR_platform_op(&op) < 0)
-		return NULL;
-
-	/* Here we know that Xen runs on EFI platform. */
-
-	efi = efi_xen;
-
-	efi_systab_xen.tables = info->cfg.addr;
-	efi_systab_xen.nr_tables = info->cfg.nent;
-
-	op.cmd = XENPF_firmware_info;
-	op.u.firmware_info.type = XEN_FW_EFI_INFO;
-	op.u.firmware_info.index = XEN_FW_EFI_VENDOR;
-	info->vendor.bufsz = sizeof(vendor);
-	set_xen_guest_handle(info->vendor.name, vendor);
-
-	if (HYPERVISOR_platform_op(&op) == 0) {
-		efi_systab_xen.fw_vendor = __pa_symbol(vendor);
-		efi_systab_xen.fw_revision = info->vendor.revision;
-	} else
-		efi_systab_xen.fw_vendor = __pa_symbol(L"UNKNOWN");
-
-	op.cmd = XENPF_firmware_info;
-	op.u.firmware_info.type = XEN_FW_EFI_INFO;
-	op.u.firmware_info.index = XEN_FW_EFI_VERSION;
-
-	if (HYPERVISOR_platform_op(&op) == 0)
-		efi_systab_xen.hdr.revision = info->version;
-
-	op.cmd = XENPF_firmware_info;
-	op.u.firmware_info.type = XEN_FW_EFI_INFO;
-	op.u.firmware_info.index = XEN_FW_EFI_RT_VERSION;
-
-	if (HYPERVISOR_platform_op(&op) == 0)
-		efi.runtime_version = info->version;
-
-	return &efi_systab_xen;
-}
+EXPORT_SYMBOL_GPL(xen_efi_query_capsule_caps);
diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
index 42be31a..c83a338 100644
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -85,14 +85,28 @@ int xen_xlate_map_ballooned_pages(xen_pfn_t **pfns, void **vaddr,
 
 bool xen_running_on_version_or_later(unsigned int major, unsigned int minor);
 
-#ifdef CONFIG_XEN_EFI
-extern efi_system_table_t *xen_efi_probe(void);
-#else
-static inline efi_system_table_t __init *xen_efi_probe(void)
-{
-	return NULL;
-}
-#endif
+efi_status_t xen_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc);
+efi_status_t xen_efi_set_time(efi_time_t *tm);
+efi_status_t xen_efi_get_wakeup_time(efi_bool_t *enabled, efi_bool_t *pending,
+				     efi_time_t *tm);
+efi_status_t xen_efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm);
+efi_status_t xen_efi_get_variable(efi_char16_t *name, efi_guid_t *vendor,
+				  u32 *attr, unsigned long *data_size,
+				  void *data);
+efi_status_t xen_efi_get_next_variable(unsigned long *name_size,
+				       efi_char16_t *name, efi_guid_t *vendor);
+efi_status_t xen_efi_set_variable(efi_char16_t *name, efi_guid_t *vendor,
+				  u32 attr, unsigned long data_size,
+				  void *data);
+efi_status_t xen_efi_query_variable_info(u32 attr, u64 *storage_space,
+					 u64 *remaining_space,
+					 u64 *max_variable_size);
+efi_status_t xen_efi_get_next_high_mono_count(u32 *count);
+efi_status_t xen_efi_update_capsule(efi_capsule_header_t **capsules,
+				    unsigned long count, unsigned long sg_list);
+efi_status_t xen_efi_query_capsule_caps(efi_capsule_header_t **capsules,
+					unsigned long count, u64 *max_size,
+					int *reset_type);
 
 #ifdef CONFIG_PREEMPT
 
-- 
2.0.4
