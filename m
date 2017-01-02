From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH 02/10] efi: Constify GetVariable() / SetVariable() signatures
Date: Mon, 2 Jan 2017 11:24:33 +0100
Message-ID: <bd030e11cd114fb1d568b21eddfc1fa75cd42e5e.1483318593.git.lukas@wunner.de>
References: <cover.1483318593.git.lukas@wunner.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1483318593.git.lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

GetVariable() / SetVariable() is typically called with immutable
VendorGuid and VariableName arguments.  SetVariable() is also often
called with an immutable Data argument.  However declaring these const
in the caller results in a compiler warning since they're not marked
const in the function signatures.  Rectify that, in keeping with the EFI
spec which marks these arguments "IN".

Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Cc: Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>
Signed-off-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
---
 arch/ia64/kernel/efi.c                  |  9 ++++-----
 arch/x86/include/asm/xen/interface.h    |  1 +
 arch/x86/platform/efi/efi_64.c          | 18 +++++++++---------
 drivers/firmware/efi/runtime-wrappers.c | 15 ++++++++-------
 drivers/firmware/google/gsmi.c          | 10 +++++-----
 drivers/xen/efi.c                       | 12 ++++++------
 include/linux/efi.h                     | 10 ++++++----
 include/xen/arm/interface.h             |  1 +
 include/xen/interface/platform.h        | 11 +++++++++--
 include/xen/xen-ops.h                   | 12 ++++++------
 10 files changed, 55 insertions(+), 44 deletions(-)

diff --git a/arch/ia64/kernel/efi.c b/arch/ia64/kernel/efi.c
index 1212956..f57d089 100644
--- a/arch/ia64/kernel/efi.c
+++ b/arch/ia64/kernel/efi.c
@@ -125,8 +125,8 @@
 
 #define STUB_GET_VARIABLE(prefix, adjust_arg)				       \
 static efi_status_t							       \
-prefix##_get_variable (efi_char16_t *name, efi_guid_t *vendor, u32 *attr,      \
-		       unsigned long *data_size, void *data)		       \
+prefix##_get_variable (const efi_char16_t *name, const efi_guid_t *vendor,     \
+		       u32 *attr, unsigned long *data_size, void *data)        \
 {									       \
 	struct ia64_fpreg fr[6];					       \
 	u32 *aattr = NULL;						       \
@@ -161,9 +161,8 @@
 
 #define STUB_SET_VARIABLE(prefix, adjust_arg)				       \
 static efi_status_t							       \
-prefix##_set_variable (efi_char16_t *name, efi_guid_t *vendor,		       \
-		       u32 attr, unsigned long data_size,		       \
-		       void *data)					       \
+prefix##_set_variable (const efi_char16_t *name, const efi_guid_t *vendor,     \
+		       u32 attr, unsigned long data_size, const void *data)    \
 {									       \
 	struct ia64_fpreg fr[6];					       \
 	efi_status_t ret;						       \
diff --git a/arch/x86/include/asm/xen/interface.h b/arch/x86/include/asm/xen/interface.h
index 62ca03e..543716c 100644
--- a/arch/x86/include/asm/xen/interface.h
+++ b/arch/x86/include/asm/xen/interface.h
@@ -86,6 +86,7 @@
 /* Guest handles for primitive C types. */
 __DEFINE_GUEST_HANDLE(uchar, unsigned char);
 __DEFINE_GUEST_HANDLE(uint,  unsigned int);
+__DEFINE_GUEST_HANDLE(cvoid, const void);
 DEFINE_GUEST_HANDLE(char);
 DEFINE_GUEST_HANDLE(int);
 DEFINE_GUEST_HANDLE(void);
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index ee966aa..2a7d423 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -632,13 +632,13 @@ static efi_status_t efi_thunk_set_time(efi_time_t *tm)
 	return status;
 }
 
-static unsigned long efi_name_size(efi_char16_t *name)
+static unsigned long efi_name_size(const efi_char16_t *name)
 {
 	return ucs2_strsize(name, EFI_VAR_NAME_LEN) + 1;
 }
 
 static efi_status_t
-efi_thunk_get_variable(efi_char16_t *name, efi_guid_t *vendor,
+efi_thunk_get_variable(const efi_char16_t *name, const efi_guid_t *vendor,
 		       u32 *attr, unsigned long *data_size, void *data)
 {
 	efi_status_t status;
@@ -646,8 +646,8 @@ static unsigned long efi_name_size(efi_char16_t *name)
 	u32 phys_data_size, phys_data;
 
 	phys_data_size = virt_to_phys_or_null(data_size);
-	phys_vendor = virt_to_phys_or_null(vendor);
-	phys_name = virt_to_phys_or_null_size(name, efi_name_size(name));
+	phys_vendor = virt_to_phys_or_null((void *)vendor);
+	phys_name = virt_to_phys_or_null_size((void *)name, efi_name_size(name));
 	phys_attr = virt_to_phys_or_null(attr);
 	phys_data = virt_to_phys_or_null_size(data, *data_size);
 
@@ -658,15 +658,15 @@ static unsigned long efi_name_size(efi_char16_t *name)
 }
 
 static efi_status_t
-efi_thunk_set_variable(efi_char16_t *name, efi_guid_t *vendor,
-		       u32 attr, unsigned long data_size, void *data)
+efi_thunk_set_variable(const efi_char16_t *name, const efi_guid_t *vendor,
+		       u32 attr, unsigned long data_size, const void *data)
 {
 	u32 phys_name, phys_vendor, phys_data;
 	efi_status_t status;
 
-	phys_name = virt_to_phys_or_null_size(name, efi_name_size(name));
-	phys_vendor = virt_to_phys_or_null(vendor);
-	phys_data = virt_to_phys_or_null_size(data, data_size);
+	phys_name = virt_to_phys_or_null_size((void *)name, efi_name_size(name));
+	phys_vendor = virt_to_phys_or_null((void *)vendor);
+	phys_data = virt_to_phys_or_null_size((void *)data, data_size);
 
 	/* If data_size is > sizeof(u32) we've got problems */
 	status = efi_thunk(set_variable, phys_name, phys_vendor,
diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index ae54870b..a98de14 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -136,8 +136,8 @@ static efi_status_t virt_efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
 	return status;
 }
 
-static efi_status_t virt_efi_get_variable(efi_char16_t *name,
-					  efi_guid_t *vendor,
+static efi_status_t virt_efi_get_variable(const efi_char16_t *name,
+					  const efi_guid_t *vendor,
 					  u32 *attr,
 					  unsigned long *data_size,
 					  void *data)
@@ -165,11 +165,11 @@ static efi_status_t virt_efi_get_next_variable(unsigned long *name_size,
 	return status;
 }
 
-static efi_status_t virt_efi_set_variable(efi_char16_t *name,
-					  efi_guid_t *vendor,
+static efi_status_t virt_efi_set_variable(const efi_char16_t *name,
+					  const efi_guid_t *vendor,
 					  u32 attr,
 					  unsigned long data_size,
-					  void *data)
+					  const void *data)
 {
 	efi_status_t status;
 
@@ -182,9 +182,10 @@ static efi_status_t virt_efi_set_variable(efi_char16_t *name,
 }
 
 static efi_status_t
-virt_efi_set_variable_nonblocking(efi_char16_t *name, efi_guid_t *vendor,
+virt_efi_set_variable_nonblocking(const efi_char16_t *name,
+				  const efi_guid_t *vendor,
 				  u32 attr, unsigned long data_size,
-				  void *data)
+				  const void *data)
 {
 	efi_status_t status;
 
diff --git a/drivers/firmware/google/gsmi.c b/drivers/firmware/google/gsmi.c
index c463871..a1b3cd9 100644
--- a/drivers/firmware/google/gsmi.c
+++ b/drivers/firmware/google/gsmi.c
@@ -289,8 +289,8 @@ static int gsmi_exec(u8 func, u8 sub)
 	return rc;
 }
 
-static efi_status_t gsmi_get_variable(efi_char16_t *name,
-				      efi_guid_t *vendor, u32 *attr,
+static efi_status_t gsmi_get_variable(const efi_char16_t *name,
+				      const efi_guid_t *vendor, u32 *attr,
 				      unsigned long *data_size,
 				      void *data)
 {
@@ -410,11 +410,11 @@ static efi_status_t gsmi_get_next_variable(unsigned long *name_size,
 	return ret;
 }
 
-static efi_status_t gsmi_set_variable(efi_char16_t *name,
-				      efi_guid_t *vendor,
+static efi_status_t gsmi_set_variable(const efi_char16_t *name,
+				      const efi_guid_t *vendor,
 				      u32 attr,
 				      unsigned long data_size,
-				      void *data)
+				      const void *data)
 {
 	struct gsmi_nvram_var_param param = {
 		.name_ptr = gsmi_dev.name_buf->address,
diff --git a/drivers/xen/efi.c b/drivers/xen/efi.c
index 22f71ff..248740a 100644
--- a/drivers/xen/efi.c
+++ b/drivers/xen/efi.c
@@ -117,9 +117,9 @@ efi_status_t xen_efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
 }
 EXPORT_SYMBOL_GPL(xen_efi_set_wakeup_time);
 
-efi_status_t xen_efi_get_variable(efi_char16_t *name, efi_guid_t *vendor,
-				  u32 *attr, unsigned long *data_size,
-				  void *data)
+efi_status_t xen_efi_get_variable(const efi_char16_t *name,
+				  const efi_guid_t *vendor, u32 *attr,
+				  unsigned long *data_size, void *data)
 {
 	struct xen_platform_op op = INIT_EFI_OP(get_variable);
 
@@ -165,9 +165,9 @@ efi_status_t xen_efi_get_next_variable(unsigned long *name_size,
 }
 EXPORT_SYMBOL_GPL(xen_efi_get_next_variable);
 
-efi_status_t xen_efi_set_variable(efi_char16_t *name, efi_guid_t *vendor,
-				 u32 attr, unsigned long data_size,
-				 void *data)
+efi_status_t xen_efi_set_variable(const efi_char16_t *name,
+				  const efi_guid_t *vendor, u32 attr,
+				  unsigned long data_size, const void *data)
 {
 	struct xen_platform_op op = INIT_EFI_OP(set_variable);
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 889d40d..6ade102 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -514,13 +514,15 @@ struct efi_boot_memmap {
 typedef efi_status_t efi_get_wakeup_time_t (efi_bool_t *enabled, efi_bool_t *pending,
 					    efi_time_t *tm);
 typedef efi_status_t efi_set_wakeup_time_t (efi_bool_t enabled, efi_time_t *tm);
-typedef efi_status_t efi_get_variable_t (efi_char16_t *name, efi_guid_t *vendor, u32 *attr,
+typedef efi_status_t efi_get_variable_t (const efi_char16_t *name,
+					 const efi_guid_t *vendor, u32 *attr,
 					 unsigned long *data_size, void *data);
 typedef efi_status_t efi_get_next_variable_t (unsigned long *name_size, efi_char16_t *name,
 					      efi_guid_t *vendor);
-typedef efi_status_t efi_set_variable_t (efi_char16_t *name, efi_guid_t *vendor, 
-					 u32 attr, unsigned long data_size,
-					 void *data);
+typedef efi_status_t efi_set_variable_t (const efi_char16_t *name,
+					 const efi_guid_t *vendor, u32 attr,
+					 unsigned long data_size,
+					 const void *data);
 typedef efi_status_t efi_get_next_high_mono_count_t (u32 *count);
 typedef void efi_reset_system_t (int reset_type, efi_status_t status,
 				 unsigned long data_size, efi_char16_t *data);
diff --git a/include/xen/arm/interface.h b/include/xen/arm/interface.h
index 75d5968..daa2956 100644
--- a/include/xen/arm/interface.h
+++ b/include/xen/arm/interface.h
@@ -47,6 +47,7 @@
 /* Guest handles for primitive C types. */
 __DEFINE_GUEST_HANDLE(uchar, unsigned char);
 __DEFINE_GUEST_HANDLE(uint,  unsigned int);
+__DEFINE_GUEST_HANDLE(cvoid, const void);
 DEFINE_GUEST_HANDLE(char);
 DEFINE_GUEST_HANDLE(int);
 DEFINE_GUEST_HANDLE(void);
diff --git a/include/xen/interface/platform.h b/include/xen/interface/platform.h
index 732efb0..b7e249c 100644
--- a/include/xen/interface/platform.h
+++ b/include/xen/interface/platform.h
@@ -171,7 +171,7 @@ struct xenpf_efi_runtime_call {
 #define XEN_EFI_VARIABLE_BOOTSERVICE_ACCESS 0x00000002
 #define XEN_EFI_VARIABLE_RUNTIME_ACCESS     0x00000004
 		struct {
-			GUEST_HANDLE(void) name;  /* UCS-2/UTF-16 string */
+			GUEST_HANDLE(cvoid) name;  /* UCS-2/UTF-16 string */
 			xen_ulong_t size;
 			GUEST_HANDLE(void) data;
 			struct xenpf_efi_guid {
@@ -180,7 +180,14 @@ struct xenpf_efi_runtime_call {
 				uint16_t data3;
 				uint8_t data4[8];
 			} vendor_guid;
-		} get_variable, set_variable;
+		} get_variable;
+
+		struct {
+			GUEST_HANDLE(cvoid) name;  /* UCS-2/UTF-16 string */
+			xen_ulong_t size;
+			GUEST_HANDLE(cvoid) data;
+			struct xenpf_efi_guid vendor_guid;
+		} set_variable;
 
 		struct {
 			xen_ulong_t size;
diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
index b5486e6..b118f56 100644
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -103,14 +103,14 @@ int xen_xlate_map_ballooned_pages(xen_pfn_t **pfns, void **vaddr,
 efi_status_t xen_efi_get_wakeup_time(efi_bool_t *enabled, efi_bool_t *pending,
 				     efi_time_t *tm);
 efi_status_t xen_efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm);
-efi_status_t xen_efi_get_variable(efi_char16_t *name, efi_guid_t *vendor,
-				  u32 *attr, unsigned long *data_size,
-				  void *data);
+efi_status_t xen_efi_get_variable(const efi_char16_t *name,
+				  const efi_guid_t *vendor, u32 *attr,
+				  unsigned long *data_size, void *data);
 efi_status_t xen_efi_get_next_variable(unsigned long *name_size,
 				       efi_char16_t *name, efi_guid_t *vendor);
-efi_status_t xen_efi_set_variable(efi_char16_t *name, efi_guid_t *vendor,
-				  u32 attr, unsigned long data_size,
-				  void *data);
+efi_status_t xen_efi_set_variable(const efi_char16_t *name,
+				  const efi_guid_t *vendor, u32 attr,
+				  unsigned long data_size, const void *data);
 efi_status_t xen_efi_query_variable_info(u32 attr, u64 *storage_space,
 					 u64 *remaining_space,
 					 u64 *max_variable_size);
-- 
2.11.0
