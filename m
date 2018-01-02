From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 4/5] efi: move ARM CPER code to new file
Date: Tue,  2 Jan 2018 18:10:41 +0000
Message-ID: <20180102181042.19074-5-ard.biesheuvel@linaro.org>
References: <20180102181042.19074-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180102181042.19074-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arvind Yadav <arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Vasyl Gomonovych <gomonovych-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

The ARM CPER code is currently mixed in with the other CPER code. Move it
to a new file to separate it from the rest of the CPER code.

Signed-off-by: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/Kconfig    |   5 ++
 drivers/firmware/efi/Makefile   |   1 +
 drivers/firmware/efi/cper-arm.c | 147 ++++++++++++++++++++++++++++++++++++++++
 drivers/firmware/efi/cper.c     | 122 +--------------------------------
 include/linux/cper.h            |   4 ++
 5 files changed, 160 insertions(+), 119 deletions(-)
 create mode 100644 drivers/firmware/efi/cper-arm.c

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 2b4c39fdfa91..aab108e82f78 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -166,6 +166,11 @@ endmenu
 config UEFI_CPER
 	bool
 
+config UEFI_CPER_ARM
+	bool
+	depends on UEFI_CPER && ( ARM || ARM64 )
+	default y
+
 config EFI_DEV_PATH_PARSER
 	bool
 	depends on ACPI
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index 269501dfba53..a3e73d6e8a43 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -30,3 +30,4 @@ arm-obj-$(CONFIG_EFI)			:= arm-init.o arm-runtime.o
 obj-$(CONFIG_ARM)			+= $(arm-obj-y)
 obj-$(CONFIG_ARM64)			+= $(arm-obj-y)
 obj-$(CONFIG_EFI_CAPSULE_LOADER)	+= capsule-loader.o
+obj-$(CONFIG_UEFI_CPER_ARM)		+= cper-arm.o
diff --git a/drivers/firmware/efi/cper-arm.c b/drivers/firmware/efi/cper-arm.c
new file mode 100644
index 000000000000..4afbfed52163
--- /dev/null
+++ b/drivers/firmware/efi/cper-arm.c
@@ -0,0 +1,147 @@
+/*
+ * UEFI Common Platform Error Record (CPER) support
+ *
+ * Copyright (C) 2017, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/time.h>
+#include <linux/cper.h>
+#include <linux/dmi.h>
+#include <linux/acpi.h>
+#include <linux/pci.h>
+#include <linux/aer.h>
+#include <linux/printk.h>
+#include <linux/bcd.h>
+#include <acpi/ghes.h>
+#include <ras/ras_event.h>
+
+#define INDENT_SP	" "
+
+static const char * const arm_reg_ctx_strs[] = {
+	"AArch32 general purpose registers",
+	"AArch32 EL1 context registers",
+	"AArch32 EL2 context registers",
+	"AArch32 secure context registers",
+	"AArch64 general purpose registers",
+	"AArch64 EL1 context registers",
+	"AArch64 EL2 context registers",
+	"AArch64 EL3 context registers",
+	"Misc. system register structure",
+};
+
+void cper_print_proc_arm(const char *pfx,
+			 const struct cper_sec_proc_arm *proc)
+{
+	int i, len, max_ctx_type;
+	struct cper_arm_err_info *err_info;
+	struct cper_arm_ctx_info *ctx_info;
+	char newpfx[64];
+
+	printk("%sMIDR: 0x%016llx\n", pfx, proc->midr);
+
+	len = proc->section_length - (sizeof(*proc) +
+		proc->err_info_num * (sizeof(*err_info)));
+	if (len < 0) {
+		printk("%ssection length: %d\n", pfx, proc->section_length);
+		printk("%ssection length is too small\n", pfx);
+		printk("%sfirmware-generated error record is incorrect\n", pfx);
+		printk("%sERR_INFO_NUM is %d\n", pfx, proc->err_info_num);
+		return;
+	}
+
+	if (proc->validation_bits & CPER_ARM_VALID_MPIDR)
+		printk("%sMultiprocessor Affinity Register (MPIDR): 0x%016llx\n",
+			pfx, proc->mpidr);
+
+	if (proc->validation_bits & CPER_ARM_VALID_AFFINITY_LEVEL)
+		printk("%serror affinity level: %d\n", pfx,
+			proc->affinity_level);
+
+	if (proc->validation_bits & CPER_ARM_VALID_RUNNING_STATE) {
+		printk("%srunning state: 0x%x\n", pfx, proc->running_state);
+		printk("%sPower State Coordination Interface state: %d\n",
+			pfx, proc->psci_state);
+	}
+
+	snprintf(newpfx, sizeof(newpfx), "%s%s", pfx, INDENT_SP);
+
+	err_info = (struct cper_arm_err_info *)(proc + 1);
+	for (i = 0; i < proc->err_info_num; i++) {
+		printk("%sError info structure %d:\n", pfx, i);
+
+		printk("%snum errors: %d\n", pfx, err_info->multiple_error + 1);
+
+		if (err_info->validation_bits & CPER_ARM_INFO_VALID_FLAGS) {
+			if (err_info->flags & CPER_ARM_INFO_FLAGS_FIRST)
+				printk("%sfirst error captured\n", newpfx);
+			if (err_info->flags & CPER_ARM_INFO_FLAGS_LAST)
+				printk("%slast error captured\n", newpfx);
+			if (err_info->flags & CPER_ARM_INFO_FLAGS_PROPAGATED)
+				printk("%spropagated error captured\n",
+				       newpfx);
+			if (err_info->flags & CPER_ARM_INFO_FLAGS_OVERFLOW)
+				printk("%soverflow occurred, error info is incomplete\n",
+				       newpfx);
+		}
+
+		printk("%serror_type: %d, %s\n", newpfx, err_info->type,
+			err_info->type < ARRAY_SIZE(cper_proc_error_type_strs) ?
+			cper_proc_error_type_strs[err_info->type] : "unknown");
+		if (err_info->validation_bits & CPER_ARM_INFO_VALID_ERR_INFO)
+			printk("%serror_info: 0x%016llx\n", newpfx,
+			       err_info->error_info);
+		if (err_info->validation_bits & CPER_ARM_INFO_VALID_VIRT_ADDR)
+			printk("%svirtual fault address: 0x%016llx\n",
+				newpfx, err_info->virt_fault_addr);
+		if (err_info->validation_bits & CPER_ARM_INFO_VALID_PHYSICAL_ADDR)
+			printk("%sphysical fault address: 0x%016llx\n",
+				newpfx, err_info->physical_fault_addr);
+		err_info += 1;
+	}
+
+	ctx_info = (struct cper_arm_ctx_info *)err_info;
+	max_ctx_type = ARRAY_SIZE(arm_reg_ctx_strs) - 1;
+	for (i = 0; i < proc->context_info_num; i++) {
+		int size = sizeof(*ctx_info) + ctx_info->size;
+
+		printk("%sContext info structure %d:\n", pfx, i);
+		if (len < size) {
+			printk("%ssection length is too small\n", newpfx);
+			printk("%sfirmware-generated error record is incorrect\n", pfx);
+			return;
+		}
+		if (ctx_info->type > max_ctx_type) {
+			printk("%sInvalid context type: %d (max: %d)\n",
+				newpfx, ctx_info->type, max_ctx_type);
+			return;
+		}
+		printk("%sregister context type: %s\n", newpfx,
+			arm_reg_ctx_strs[ctx_info->type]);
+		print_hex_dump(newpfx, "", DUMP_PREFIX_OFFSET, 16, 4,
+				(ctx_info + 1), ctx_info->size, 0);
+		len -= size;
+		ctx_info = (struct cper_arm_ctx_info *)((long)ctx_info + size);
+	}
+
+	if (len > 0) {
+		printk("%sVendor specific error info has %u bytes:\n", pfx,
+		       len);
+		print_hex_dump(newpfx, "", DUMP_PREFIX_OFFSET, 16, 4, ctx_info,
+				len, true);
+	}
+}
diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index d2fcafcea07e..c165933ebf38 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -122,7 +122,7 @@ static const char * const proc_isa_strs[] = {
 	"ARM A64",
 };
 
-static const char * const proc_error_type_strs[] = {
+const char * const cper_proc_error_type_strs[] = {
 	"cache error",
 	"TLB error",
 	"bus error",
@@ -157,8 +157,8 @@ static void cper_print_proc_generic(const char *pfx,
 	if (proc->validation_bits & CPER_PROC_VALID_ERROR_TYPE) {
 		printk("%s""error_type: 0x%02x\n", pfx, proc->proc_error_type);
 		cper_print_bits(pfx, proc->proc_error_type,
-				proc_error_type_strs,
-				ARRAY_SIZE(proc_error_type_strs));
+				cper_proc_error_type_strs,
+				ARRAY_SIZE(cper_proc_error_type_strs));
 	}
 	if (proc->validation_bits & CPER_PROC_VALID_OPERATION)
 		printk("%s""operation: %d, %s\n", pfx, proc->operation,
@@ -188,122 +188,6 @@ static void cper_print_proc_generic(const char *pfx,
 		printk("%s""IP: 0x%016llx\n", pfx, proc->ip);
 }
 
-#if defined(CONFIG_ARM64) || defined(CONFIG_ARM)
-static const char * const arm_reg_ctx_strs[] = {
-	"AArch32 general purpose registers",
-	"AArch32 EL1 context registers",
-	"AArch32 EL2 context registers",
-	"AArch32 secure context registers",
-	"AArch64 general purpose registers",
-	"AArch64 EL1 context registers",
-	"AArch64 EL2 context registers",
-	"AArch64 EL3 context registers",
-	"Misc. system register structure",
-};
-
-static void cper_print_proc_arm(const char *pfx,
-				const struct cper_sec_proc_arm *proc)
-{
-	int i, len, max_ctx_type;
-	struct cper_arm_err_info *err_info;
-	struct cper_arm_ctx_info *ctx_info;
-	char newpfx[64];
-
-	printk("%sMIDR: 0x%016llx\n", pfx, proc->midr);
-
-	len = proc->section_length - (sizeof(*proc) +
-		proc->err_info_num * (sizeof(*err_info)));
-	if (len < 0) {
-		printk("%ssection length: %d\n", pfx, proc->section_length);
-		printk("%ssection length is too small\n", pfx);
-		printk("%sfirmware-generated error record is incorrect\n", pfx);
-		printk("%sERR_INFO_NUM is %d\n", pfx, proc->err_info_num);
-		return;
-	}
-
-	if (proc->validation_bits & CPER_ARM_VALID_MPIDR)
-		printk("%sMultiprocessor Affinity Register (MPIDR): 0x%016llx\n",
-			pfx, proc->mpidr);
-
-	if (proc->validation_bits & CPER_ARM_VALID_AFFINITY_LEVEL)
-		printk("%serror affinity level: %d\n", pfx,
-			proc->affinity_level);
-
-	if (proc->validation_bits & CPER_ARM_VALID_RUNNING_STATE) {
-		printk("%srunning state: 0x%x\n", pfx, proc->running_state);
-		printk("%sPower State Coordination Interface state: %d\n",
-			pfx, proc->psci_state);
-	}
-
-	snprintf(newpfx, sizeof(newpfx), "%s%s", pfx, INDENT_SP);
-
-	err_info = (struct cper_arm_err_info *)(proc + 1);
-	for (i = 0; i < proc->err_info_num; i++) {
-		printk("%sError info structure %d:\n", pfx, i);
-
-		printk("%snum errors: %d\n", pfx, err_info->multiple_error + 1);
-
-		if (err_info->validation_bits & CPER_ARM_INFO_VALID_FLAGS) {
-			if (err_info->flags & CPER_ARM_INFO_FLAGS_FIRST)
-				printk("%sfirst error captured\n", newpfx);
-			if (err_info->flags & CPER_ARM_INFO_FLAGS_LAST)
-				printk("%slast error captured\n", newpfx);
-			if (err_info->flags & CPER_ARM_INFO_FLAGS_PROPAGATED)
-				printk("%spropagated error captured\n",
-				       newpfx);
-			if (err_info->flags & CPER_ARM_INFO_FLAGS_OVERFLOW)
-				printk("%soverflow occurred, error info is incomplete\n",
-				       newpfx);
-		}
-
-		printk("%serror_type: %d, %s\n", newpfx, err_info->type,
-			err_info->type < ARRAY_SIZE(proc_error_type_strs) ?
-			proc_error_type_strs[err_info->type] : "unknown");
-		if (err_info->validation_bits & CPER_ARM_INFO_VALID_ERR_INFO)
-			printk("%serror_info: 0x%016llx\n", newpfx,
-			       err_info->error_info);
-		if (err_info->validation_bits & CPER_ARM_INFO_VALID_VIRT_ADDR)
-			printk("%svirtual fault address: 0x%016llx\n",
-				newpfx, err_info->virt_fault_addr);
-		if (err_info->validation_bits & CPER_ARM_INFO_VALID_PHYSICAL_ADDR)
-			printk("%sphysical fault address: 0x%016llx\n",
-				newpfx, err_info->physical_fault_addr);
-		err_info += 1;
-	}
-
-	ctx_info = (struct cper_arm_ctx_info *)err_info;
-	max_ctx_type = ARRAY_SIZE(arm_reg_ctx_strs) - 1;
-	for (i = 0; i < proc->context_info_num; i++) {
-		int size = sizeof(*ctx_info) + ctx_info->size;
-
-		printk("%sContext info structure %d:\n", pfx, i);
-		if (len < size) {
-			printk("%ssection length is too small\n", newpfx);
-			printk("%sfirmware-generated error record is incorrect\n", pfx);
-			return;
-		}
-		if (ctx_info->type > max_ctx_type) {
-			printk("%sInvalid context type: %d (max: %d)\n",
-				newpfx, ctx_info->type, max_ctx_type);
-			return;
-		}
-		printk("%sregister context type: %s\n", newpfx,
-			arm_reg_ctx_strs[ctx_info->type]);
-		print_hex_dump(newpfx, "", DUMP_PREFIX_OFFSET, 16, 4,
-				(ctx_info + 1), ctx_info->size, 0);
-		len -= size;
-		ctx_info = (struct cper_arm_ctx_info *)((long)ctx_info + size);
-	}
-
-	if (len > 0) {
-		printk("%sVendor specific error info has %u bytes:\n", pfx,
-		       len);
-		print_hex_dump(newpfx, "", DUMP_PREFIX_OFFSET, 16, 4, ctx_info,
-				len, true);
-	}
-}
-#endif
-
 static const char * const mem_err_type_strs[] = {
 	"unknown",
 	"no error",
diff --git a/include/linux/cper.h b/include/linux/cper.h
index 723e952fde0d..3299e43c76eb 100644
--- a/include/linux/cper.h
+++ b/include/linux/cper.h
@@ -494,6 +494,8 @@ struct cper_sec_pcie {
 /* Reset to default packing */
 #pragma pack()
 
+extern const char * const cper_proc_error_type_strs[4];
+
 u64 cper_next_record_id(void);
 const char *cper_severity_str(unsigned int);
 const char *cper_mem_err_type_str(unsigned int);
@@ -503,5 +505,7 @@ void cper_mem_err_pack(const struct cper_sec_mem_err *,
 		       struct cper_mem_err_compact *);
 const char *cper_mem_err_unpack(struct trace_seq *,
 				struct cper_mem_err_compact *);
+void cper_print_proc_arm(const char *pfx,
+			 const struct cper_sec_proc_arm *proc);
 
 #endif
-- 
2.11.0
