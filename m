From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: [RFC PATCH 05/16] x86/efi: Get entropy through EFI random number generator protocol
Date: Thu, 16 Jul 2015 22:25:19 +0800
Message-ID: <1437056730-15247-6-git-send-email-jlee@suse.com>
References: <1437056730-15247-1-git-send-email-jlee@suse.com>
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1437056730-15247-1-git-send-email-jlee@suse.com>
Sender: linux-pm-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Matt Fleming <matt.fleming@intel.com>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>, "Lee, Chun-Yi" <jlee@suse.com>
List-Id: linux-efi@vger.kernel.org

To grab random numbers through EFI protocol as one of the entropies
source of swsusp key, this patch adds the logic for accessing EFI RNG
(random number generator) protocol that's introduced since UEFI 2.4.

Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 arch/x86/boot/compressed/efi_random.c | 193 ++++++++++++++++++++++++++++++++++
 include/linux/efi.h                   |  46 ++++++++
 2 files changed, 239 insertions(+)

diff --git a/arch/x86/boot/compressed/efi_random.c b/arch/x86/boot/compressed/efi_random.c
index bdb2d46..1f5c63d 100644
--- a/arch/x86/boot/compressed/efi_random.c
+++ b/arch/x86/boot/compressed/efi_random.c
@@ -2,6 +2,191 @@
 
 #include <linux/efi.h>
 #include <asm/archrandom.h>
+#include <asm/efi.h>
+
+static efi_status_t efi_locate_rng(efi_system_table_t *sys_table,
+				   void ***rng_handle)
+{
+	efi_guid_t rng_proto = EFI_RNG_PROTOCOL_GUID;
+	unsigned long size = 0;
+	efi_status_t status;
+
+	status = efi_call_early(locate_handle,
+				EFI_LOCATE_BY_PROTOCOL,
+				&rng_proto, NULL, &size, *rng_handle);
+
+	if (status == EFI_BUFFER_TOO_SMALL) {
+		status = efi_call_early(allocate_pool,
+					EFI_LOADER_DATA,
+					size, (void **)rng_handle);
+
+		if (status != EFI_SUCCESS) {
+			efi_printk(sys_table, " Failed to alloc mem for rng_handle");
+			return status;
+		}
+
+		status = efi_call_early(locate_handle,
+					EFI_LOCATE_BY_PROTOCOL, &rng_proto,
+					NULL, &size, *rng_handle);
+	}
+
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table, " Failed to locate EFI_RNG_PROTOCOL");
+		goto free_handle;
+	}
+
+	return EFI_SUCCESS;
+
+free_handle:
+	efi_call_early(free_pool, *rng_handle);
+
+	return status;
+}
+
+static bool efi_rng_supported32(efi_system_table_t *sys_table, void **rng_handle)
+{
+	const struct efi_config *efi_early = __efi_early();
+	efi_rng_protocol_32 *rng = NULL;
+	efi_guid_t rng_proto = EFI_RNG_PROTOCOL_GUID;
+	u32 *handles = (u32 *)(unsigned long)rng_handle;
+	unsigned long size = 0;
+	void **algorithmlist = NULL;
+	efi_status_t status;
+
+	status = efi_call_early(handle_protocol, handles[0],
+				&rng_proto, (void **)&rng);
+	if (status != EFI_SUCCESS)
+		efi_printk(sys_table, " Failed to get EFI_RNG_PROTOCOL handles");
+
+	if (status == EFI_SUCCESS && rng) {
+		status = efi_early->call((unsigned long)rng->get_info, rng,
+					&size, algorithmlist);
+		return (status == EFI_BUFFER_TOO_SMALL);
+	}
+
+	return false;
+}
+
+static bool efi_rng_supported64(efi_system_table_t *sys_table, void **rng_handle)
+{
+	const struct efi_config *efi_early = __efi_early();
+	efi_rng_protocol_64 *rng = NULL;
+	efi_guid_t rng_proto = EFI_RNG_PROTOCOL_GUID;
+	u64 *handles = (u64 *)(unsigned long)rng_handle;
+	unsigned long size = 0;
+	void **algorithmlist = NULL;
+	efi_status_t status;
+
+	status = efi_call_early(handle_protocol, handles[0],
+				&rng_proto, (void **)&rng);
+	if (status != EFI_SUCCESS)
+		efi_printk(sys_table, " Failed to get EFI_RNG_PROTOCOL handles");
+
+	if (status == EFI_SUCCESS && rng) {
+		status = efi_early->call((unsigned long)rng->get_info, rng,
+					&size, algorithmlist);
+		return (status == EFI_BUFFER_TOO_SMALL);
+	}
+
+	return false;
+}
+
+static bool efi_rng_supported(efi_system_table_t *sys_table)
+{
+	const struct efi_config *efi_early = __efi_early();
+	u32 random = 0;
+	efi_status_t status;
+	void **rng_handle = NULL;
+
+	status = efi_locate_rng(sys_table, &rng_handle);
+	if (status != EFI_SUCCESS)
+		return false;
+
+	if (efi_early->is64)
+		random = efi_rng_supported64(sys_table, rng_handle);
+	else
+		random = efi_rng_supported32(sys_table, rng_handle);
+
+	efi_call_early(free_pool, rng_handle);
+
+	return random;
+
+}
+
+static unsigned long efi_get_rng32(efi_system_table_t *sys_table,
+				   void **rng_handle)
+{
+	const struct efi_config *efi_early = __efi_early();
+	efi_rng_protocol_32 *rng = NULL;
+	efi_guid_t rng_proto = EFI_RNG_PROTOCOL_GUID;
+	u32 *handles = (u32 *)(unsigned long)rng_handle;
+	efi_status_t status;
+	unsigned long rng_number = 0;
+
+	status = efi_call_early(handle_protocol, handles[0],
+				&rng_proto, (void **)&rng);
+	if (status != EFI_SUCCESS)
+		efi_printk(sys_table, " Failed to get EFI_RNG_PROTOCOL handles");
+
+	if (status == EFI_SUCCESS && rng) {
+		status = efi_early->call((unsigned long)rng->get_rng, rng, NULL,
+					sizeof(rng_number), &rng_number);
+		if (status != EFI_SUCCESS) {
+			efi_printk(sys_table, " Failed to get RNG value ");
+			efi_printk(sys_table, efi_status_to_str(status));
+		}
+	}
+
+	return rng_number;
+}
+
+static unsigned long efi_get_rng64(efi_system_table_t *sys_table,
+				   void **rng_handle)
+{
+	const struct efi_config *efi_early = __efi_early();
+	efi_rng_protocol_64 *rng = NULL;
+	efi_guid_t rng_proto = EFI_RNG_PROTOCOL_GUID;
+	u64 *handles = (u64 *)(unsigned long)rng_handle;
+	efi_status_t status;
+	unsigned long rng_number;
+
+	status = efi_call_early(handle_protocol, handles[0],
+				&rng_proto, (void **)&rng);
+	if (status != EFI_SUCCESS)
+		efi_printk(sys_table, " Failed to get EFI_RNG_PROTOCOL handles");
+
+	if (status == EFI_SUCCESS && rng) {
+		status = efi_early->call((unsigned long)rng->get_rng, rng, NULL,
+					sizeof(rng_number), &rng_number);
+		if (status != EFI_SUCCESS) {
+			efi_printk(sys_table, " Failed to get RNG value ");
+			efi_printk(sys_table, efi_status_to_str(status));
+		}
+	}
+
+	return rng_number;
+}
+
+static unsigned long efi_get_rng(efi_system_table_t *sys_table)
+{
+	const struct efi_config *efi_early = __efi_early();
+	unsigned long random = 0;
+	efi_status_t status;
+	void **rng_handle = NULL;
+
+	status = efi_locate_rng(sys_table, &rng_handle);
+	if (status != EFI_SUCCESS)
+		return 0;
+
+	if (efi_early->is64)
+		random = efi_get_rng64(sys_table, rng_handle);
+	else
+		random = efi_get_rng32(sys_table, rng_handle);
+
+	efi_call_early(free_pool, rng_handle);
+
+	return random;
+}
 
 #define X86_FEATURE_EDX_TSC	(1 << 4)
 #define X86_FEATURE_ECX_RDRAND	(1 << 30)
@@ -51,6 +236,14 @@ static unsigned long get_random_long(unsigned long entropy,
 		use_i8254 = false;
 	}
 
+	if (efi_rng_supported(sys_table)) {
+		efi_printk(sys_table, " EFI_RNG");
+		raw = efi_get_rng(sys_table);
+		if (raw)
+			random ^= raw;
+		use_i8254 = false;
+	}
+
 	if (use_i8254) {
 		efi_printk(sys_table, " i8254");
 		random ^= i8254();
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 85ef051..a628f83 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -427,6 +427,16 @@ typedef struct {
 #define EFI_PCI_IO_ATTRIBUTE_VGA_PALETTE_IO_16 0x20000
 #define EFI_PCI_IO_ATTRIBUTE_VGA_IO_16 0x40000
 
+typedef struct {
+	u32 get_info;
+	u32 get_rng;
+} efi_rng_protocol_32;
+
+typedef struct {
+	u64 get_info;
+	u64 get_rng;
+} efi_rng_protocol_64;
+
 /*
  * Types and defines for EFI ResetSystem
  */
@@ -595,6 +605,9 @@ void efi_native_runtime_setup(void);
 #define DEVICE_TREE_GUID \
     EFI_GUID(  0xb1b621d5, 0xf19c, 0x41a5, 0x83, 0x0b, 0xd9, 0x15, 0x2c, 0x69, 0xaa, 0xe0 )
 
+#define EFI_RNG_PROTOCOL_GUID \
+    EFI_GUID(  0x3152bca5, 0xeade, 0x433d, 0x86, 0x2e, 0xc0, 0x1c, 0xdc, 0x29, 0x1f, 0x44 )
+
 typedef struct {
 	efi_guid_t guid;
 	u64 table;
@@ -861,6 +874,39 @@ efi_guid_to_str(efi_guid_t *guid, char *out)
         return out;
 }
 
+static inline char *efi_status_to_str(efi_status_t status)
+{
+	char *str;
+
+	switch (status) {
+	case EFI_SUCCESS:
+		str = "EFI_SUCCESS";
+		break;
+	case EFI_INVALID_PARAMETER:
+		str = "EFI_INVALID_PARAMETER";
+		break;
+	case EFI_OUT_OF_RESOURCES:
+		str = "EFI_OUT_OF_RESOURCES";
+		break;
+	case EFI_DEVICE_ERROR:
+		str = "EFI_DEVICE_ERROR";
+		break;
+	case EFI_WRITE_PROTECTED:
+		str = "EFI_WRITE_PROTECTED";
+		break;
+	case EFI_SECURITY_VIOLATION:
+		str = "EFI_SECURITY_VIOLATION";
+		break;
+	case EFI_NOT_FOUND:
+		str = "EFI_NOT_FOUND";
+		break;
+	default:
+		str = "";
+	}
+
+	return str;
+}
+
 extern void efi_init (void);
 extern void *efi_get_pal_addr (void);
 extern void efi_map_pal_code (void);
-- 
1.8.4.5

