From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] EFI changes for v4.16
Date: Mon, 29 Jan 2018 11:33:10 +0100
Message-ID: <20180129103310.2gwdcrjibba2msvl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Linus,

Please pull the latest efi-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git efi-core-for-linus

   # HEAD: a5c03c31af2291f13689d11760c0b59fb70c9a5a x86/efi: Clarify that reset attack mitigation needs appropriate userspace

The biggest change in this cycle was the addition of ARM CPER error decoding when 
printing EFI errors into the kernel log. There's also misc smaller updates: 
documentation update, cleanups and an EFI memory map permissions quirk.

 Thanks,

	Ingo

------------------>
Ard Biesheuvel (1):
      arm64/efi: Ignore EFI_MEMORY_XP attribute if RP and/or WP are set

Arvind Yadav (1):
      efi/capsule-loader: Fix pr_err() string to end with newline

Matthew Garrett (1):
      x86/efi: Clarify that reset attack mitigation needs appropriate userspace

Tyler Baicar (2):
      efi: Move ARM CPER code to new file
      efi: Parse ARM error information value

Vasyl Gomonovych (1):
      efi: Use PTR_ERR_OR_ZERO()


 arch/arm64/kernel/efi.c               |   4 +-
 drivers/firmware/efi/Kconfig          |  10 +-
 drivers/firmware/efi/Makefile         |   1 +
 drivers/firmware/efi/capsule-loader.c |   2 +-
 drivers/firmware/efi/cper-arm.c       | 356 ++++++++++++++++++++++++++++++++++
 drivers/firmware/efi/cper.c           | 122 +-----------
 drivers/firmware/efi/efi.c            |   2 +-
 include/linux/cper.h                  |  48 +++++
 8 files changed, 422 insertions(+), 123 deletions(-)
 create mode 100644 drivers/firmware/efi/cper-arm.c

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 82cd07592519..f85ac58d08a3 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -48,7 +48,9 @@ static __init pteval_t create_mapping_protection(efi_memory_desc_t *md)
 		return pgprot_val(PAGE_KERNEL_ROX);
 
 	/* RW- */
-	if (attr & EFI_MEMORY_XP || type != EFI_RUNTIME_SERVICES_CODE)
+	if (((attr & (EFI_MEMORY_RP | EFI_MEMORY_WP | EFI_MEMORY_XP)) ==
+	     EFI_MEMORY_XP) ||
+	    type != EFI_RUNTIME_SERVICES_CODE)
 		return pgprot_val(PAGE_KERNEL);
 
 	/* RWX */
diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 2b4c39fdfa91..6047ed4e8a3d 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -159,13 +159,21 @@ config RESET_ATTACK_MITIGATION
 	  using the TCG Platform Reset Attack Mitigation specification. This
 	  protects against an attacker forcibly rebooting the system while it
 	  still contains secrets in RAM, booting another OS and extracting the
-	  secrets.
+	  secrets. This should only be enabled when userland is configured to
+	  clear the MemoryOverwriteRequest flag on clean shutdown after secrets
+	  have been evicted, since otherwise it will trigger even on clean
+	  reboots.
 
 endmenu
 
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
diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
index 055e2e8f985a..e456f4602df1 100644
--- a/drivers/firmware/efi/capsule-loader.c
+++ b/drivers/firmware/efi/capsule-loader.c
@@ -45,7 +45,7 @@ int __efi_capsule_setup_info(struct capsule_info *cap_info)
 	pages_needed = ALIGN(cap_info->total_size, PAGE_SIZE) / PAGE_SIZE;
 
 	if (pages_needed == 0) {
-		pr_err("invalid capsule size");
+		pr_err("invalid capsule size\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/firmware/efi/cper-arm.c b/drivers/firmware/efi/cper-arm.c
new file mode 100644
index 000000000000..698e5c8e0c8d
--- /dev/null
+++ b/drivers/firmware/efi/cper-arm.c
@@ -0,0 +1,356 @@
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
+static const char * const arm_err_trans_type_strs[] = {
+	"Instruction",
+	"Data Access",
+	"Generic",
+};
+
+static const char * const arm_bus_err_op_strs[] = {
+	"Generic error (type cannot be determined)",
+	"Generic read (type of instruction or data request cannot be determined)",
+	"Generic write (type of instruction of data request cannot be determined)",
+	"Data read",
+	"Data write",
+	"Instruction fetch",
+	"Prefetch",
+};
+
+static const char * const arm_cache_err_op_strs[] = {
+	"Generic error (type cannot be determined)",
+	"Generic read (type of instruction or data request cannot be determined)",
+	"Generic write (type of instruction of data request cannot be determined)",
+	"Data read",
+	"Data write",
+	"Instruction fetch",
+	"Prefetch",
+	"Eviction",
+	"Snooping (processor initiated a cache snoop that resulted in an error)",
+	"Snooped (processor raised a cache error caused by another processor or device snooping its cache)",
+	"Management",
+};
+
+static const char * const arm_tlb_err_op_strs[] = {
+	"Generic error (type cannot be determined)",
+	"Generic read (type of instruction or data request cannot be determined)",
+	"Generic write (type of instruction of data request cannot be determined)",
+	"Data read",
+	"Data write",
+	"Instruction fetch",
+	"Prefetch",
+	"Local management operation (processor initiated a TLB management operation that resulted in an error)",
+	"External management operation (processor raised a TLB error caused by another processor or device broadcasting TLB operations)",
+};
+
+static const char * const arm_bus_err_part_type_strs[] = {
+	"Local processor originated request",
+	"Local processor responded to request",
+	"Local processor observed",
+	"Generic",
+};
+
+static const char * const arm_bus_err_addr_space_strs[] = {
+	"External Memory Access",
+	"Internal Memory Access",
+	"Unknown",
+	"Device Memory Access",
+};
+
+static void cper_print_arm_err_info(const char *pfx, u32 type,
+				    u64 error_info)
+{
+	u8 trans_type, op_type, level, participation_type, address_space;
+	u16 mem_attributes;
+	bool proc_context_corrupt, corrected, precise_pc, restartable_pc;
+	bool time_out, access_mode;
+
+	/* If the type is unknown, bail. */
+	if (type > CPER_ARM_MAX_TYPE)
+		return;
+
+	/*
+	 * Vendor type errors have error information values that are vendor
+	 * specific.
+	 */
+	if (type == CPER_ARM_VENDOR_ERROR)
+		return;
+
+	if (error_info & CPER_ARM_ERR_VALID_TRANSACTION_TYPE) {
+		trans_type = ((error_info >> CPER_ARM_ERR_TRANSACTION_SHIFT)
+			      & CPER_ARM_ERR_TRANSACTION_MASK);
+		if (trans_type < ARRAY_SIZE(arm_err_trans_type_strs)) {
+			printk("%stransaction type: %s\n", pfx,
+			       arm_err_trans_type_strs[trans_type]);
+		}
+	}
+
+	if (error_info & CPER_ARM_ERR_VALID_OPERATION_TYPE) {
+		op_type = ((error_info >> CPER_ARM_ERR_OPERATION_SHIFT)
+			   & CPER_ARM_ERR_OPERATION_MASK);
+		switch (type) {
+		case CPER_ARM_CACHE_ERROR:
+			if (op_type < ARRAY_SIZE(arm_cache_err_op_strs)) {
+				printk("%soperation type: %s\n", pfx,
+				       arm_cache_err_op_strs[op_type]);
+			}
+			break;
+		case CPER_ARM_TLB_ERROR:
+			if (op_type < ARRAY_SIZE(arm_tlb_err_op_strs)) {
+				printk("%soperation type: %s\n", pfx,
+				       arm_tlb_err_op_strs[op_type]);
+			}
+			break;
+		case CPER_ARM_BUS_ERROR:
+			if (op_type < ARRAY_SIZE(arm_bus_err_op_strs)) {
+				printk("%soperation type: %s\n", pfx,
+				       arm_bus_err_op_strs[op_type]);
+			}
+			break;
+		}
+	}
+
+	if (error_info & CPER_ARM_ERR_VALID_LEVEL) {
+		level = ((error_info >> CPER_ARM_ERR_LEVEL_SHIFT)
+			 & CPER_ARM_ERR_LEVEL_MASK);
+		switch (type) {
+		case CPER_ARM_CACHE_ERROR:
+			printk("%scache level: %d\n", pfx, level);
+			break;
+		case CPER_ARM_TLB_ERROR:
+			printk("%sTLB level: %d\n", pfx, level);
+			break;
+		case CPER_ARM_BUS_ERROR:
+			printk("%saffinity level at which the bus error occurred: %d\n",
+			       pfx, level);
+			break;
+		}
+	}
+
+	if (error_info & CPER_ARM_ERR_VALID_PROC_CONTEXT_CORRUPT) {
+		proc_context_corrupt = ((error_info >> CPER_ARM_ERR_PC_CORRUPT_SHIFT)
+					& CPER_ARM_ERR_PC_CORRUPT_MASK);
+		if (proc_context_corrupt)
+			printk("%sprocessor context corrupted\n", pfx);
+		else
+			printk("%sprocessor context not corrupted\n", pfx);
+	}
+
+	if (error_info & CPER_ARM_ERR_VALID_CORRECTED) {
+		corrected = ((error_info >> CPER_ARM_ERR_CORRECTED_SHIFT)
+			     & CPER_ARM_ERR_CORRECTED_MASK);
+		if (corrected)
+			printk("%sthe error has been corrected\n", pfx);
+		else
+			printk("%sthe error has not been corrected\n", pfx);
+	}
+
+	if (error_info & CPER_ARM_ERR_VALID_PRECISE_PC) {
+		precise_pc = ((error_info >> CPER_ARM_ERR_PRECISE_PC_SHIFT)
+			      & CPER_ARM_ERR_PRECISE_PC_MASK);
+		if (precise_pc)
+			printk("%sPC is precise\n", pfx);
+		else
+			printk("%sPC is imprecise\n", pfx);
+	}
+
+	if (error_info & CPER_ARM_ERR_VALID_RESTARTABLE_PC) {
+		restartable_pc = ((error_info >> CPER_ARM_ERR_RESTARTABLE_PC_SHIFT)
+				  & CPER_ARM_ERR_RESTARTABLE_PC_MASK);
+		if (restartable_pc)
+			printk("%sProgram execution can be restarted reliably at the PC associated with the error.\n", pfx);
+	}
+
+	/* The rest of the fields are specific to bus errors */
+	if (type != CPER_ARM_BUS_ERROR)
+		return;
+
+	if (error_info & CPER_ARM_ERR_VALID_PARTICIPATION_TYPE) {
+		participation_type = ((error_info >> CPER_ARM_ERR_PARTICIPATION_TYPE_SHIFT)
+				      & CPER_ARM_ERR_PARTICIPATION_TYPE_MASK);
+		if (participation_type < ARRAY_SIZE(arm_bus_err_part_type_strs)) {
+			printk("%sparticipation type: %s\n", pfx,
+			       arm_bus_err_part_type_strs[participation_type]);
+		}
+	}
+
+	if (error_info & CPER_ARM_ERR_VALID_TIME_OUT) {
+		time_out = ((error_info >> CPER_ARM_ERR_TIME_OUT_SHIFT)
+			    & CPER_ARM_ERR_TIME_OUT_MASK);
+		if (time_out)
+			printk("%srequest timed out\n", pfx);
+	}
+
+	if (error_info & CPER_ARM_ERR_VALID_ADDRESS_SPACE) {
+		address_space = ((error_info >> CPER_ARM_ERR_ADDRESS_SPACE_SHIFT)
+				 & CPER_ARM_ERR_ADDRESS_SPACE_MASK);
+		if (address_space < ARRAY_SIZE(arm_bus_err_addr_space_strs)) {
+			printk("%saddress space: %s\n", pfx,
+			       arm_bus_err_addr_space_strs[address_space]);
+		}
+	}
+
+	if (error_info & CPER_ARM_ERR_VALID_MEM_ATTRIBUTES) {
+		mem_attributes = ((error_info >> CPER_ARM_ERR_MEM_ATTRIBUTES_SHIFT)
+				  & CPER_ARM_ERR_MEM_ATTRIBUTES_MASK);
+		printk("%smemory access attributes:0x%x\n", pfx, mem_attributes);
+	}
+
+	if (error_info & CPER_ARM_ERR_VALID_ACCESS_MODE) {
+		access_mode = ((error_info >> CPER_ARM_ERR_ACCESS_MODE_SHIFT)
+			       & CPER_ARM_ERR_ACCESS_MODE_MASK);
+		if (access_mode)
+			printk("%saccess mode: normal\n", pfx);
+		else
+			printk("%saccess mode: secure\n", pfx);
+	}
+}
+
+void cper_print_proc_arm(const char *pfx,
+			 const struct cper_sec_proc_arm *proc)
+{
+	int i, len, max_ctx_type;
+	struct cper_arm_err_info *err_info;
+	struct cper_arm_ctx_info *ctx_info;
+	char newpfx[64], infopfx[64];
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
+		if (err_info->validation_bits & CPER_ARM_INFO_VALID_ERR_INFO) {
+			printk("%serror_info: 0x%016llx\n", newpfx,
+			       err_info->error_info);
+			snprintf(infopfx, sizeof(infopfx), "%s%s", newpfx, INDENT_SP);
+			cper_print_arm_err_info(infopfx, err_info->type,
+						err_info->error_info);
+		}
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
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 557a47829d03..8ce70c2e73d5 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -608,7 +608,7 @@ static int __init efi_load_efivars(void)
 		return 0;
 
 	pdev = platform_device_register_simple("efivars", 0, NULL, 0);
-	return IS_ERR(pdev) ? PTR_ERR(pdev) : 0;
+	return PTR_ERR_OR_ZERO(pdev);
 }
 device_initcall(efi_load_efivars);
 #endif
diff --git a/include/linux/cper.h b/include/linux/cper.h
index 723e952fde0d..d14ef4e77c8a 100644
--- a/include/linux/cper.h
+++ b/include/linux/cper.h
@@ -275,6 +275,50 @@ enum {
 #define CPER_ARM_INFO_FLAGS_PROPAGATED		BIT(2)
 #define CPER_ARM_INFO_FLAGS_OVERFLOW		BIT(3)
 
+#define CPER_ARM_CACHE_ERROR			0
+#define CPER_ARM_TLB_ERROR			1
+#define CPER_ARM_BUS_ERROR			2
+#define CPER_ARM_VENDOR_ERROR			3
+#define CPER_ARM_MAX_TYPE			CPER_ARM_VENDOR_ERROR
+
+#define CPER_ARM_ERR_VALID_TRANSACTION_TYPE	BIT(0)
+#define CPER_ARM_ERR_VALID_OPERATION_TYPE	BIT(1)
+#define CPER_ARM_ERR_VALID_LEVEL		BIT(2)
+#define CPER_ARM_ERR_VALID_PROC_CONTEXT_CORRUPT	BIT(3)
+#define CPER_ARM_ERR_VALID_CORRECTED		BIT(4)
+#define CPER_ARM_ERR_VALID_PRECISE_PC		BIT(5)
+#define CPER_ARM_ERR_VALID_RESTARTABLE_PC	BIT(6)
+#define CPER_ARM_ERR_VALID_PARTICIPATION_TYPE	BIT(7)
+#define CPER_ARM_ERR_VALID_TIME_OUT		BIT(8)
+#define CPER_ARM_ERR_VALID_ADDRESS_SPACE	BIT(9)
+#define CPER_ARM_ERR_VALID_MEM_ATTRIBUTES	BIT(10)
+#define CPER_ARM_ERR_VALID_ACCESS_MODE		BIT(11)
+
+#define CPER_ARM_ERR_TRANSACTION_SHIFT		16
+#define CPER_ARM_ERR_TRANSACTION_MASK		GENMASK(1,0)
+#define CPER_ARM_ERR_OPERATION_SHIFT		18
+#define CPER_ARM_ERR_OPERATION_MASK		GENMASK(3,0)
+#define CPER_ARM_ERR_LEVEL_SHIFT		22
+#define CPER_ARM_ERR_LEVEL_MASK			GENMASK(2,0)
+#define CPER_ARM_ERR_PC_CORRUPT_SHIFT		25
+#define CPER_ARM_ERR_PC_CORRUPT_MASK		GENMASK(0,0)
+#define CPER_ARM_ERR_CORRECTED_SHIFT		26
+#define CPER_ARM_ERR_CORRECTED_MASK		GENMASK(0,0)
+#define CPER_ARM_ERR_PRECISE_PC_SHIFT		27
+#define CPER_ARM_ERR_PRECISE_PC_MASK		GENMASK(0,0)
+#define CPER_ARM_ERR_RESTARTABLE_PC_SHIFT	28
+#define CPER_ARM_ERR_RESTARTABLE_PC_MASK	GENMASK(0,0)
+#define CPER_ARM_ERR_PARTICIPATION_TYPE_SHIFT	29
+#define CPER_ARM_ERR_PARTICIPATION_TYPE_MASK	GENMASK(1,0)
+#define CPER_ARM_ERR_TIME_OUT_SHIFT		31
+#define CPER_ARM_ERR_TIME_OUT_MASK		GENMASK(0,0)
+#define CPER_ARM_ERR_ADDRESS_SPACE_SHIFT	32
+#define CPER_ARM_ERR_ADDRESS_SPACE_MASK		GENMASK(1,0)
+#define CPER_ARM_ERR_MEM_ATTRIBUTES_SHIFT	34
+#define CPER_ARM_ERR_MEM_ATTRIBUTES_MASK	GENMASK(8,0)
+#define CPER_ARM_ERR_ACCESS_MODE_SHIFT		43
+#define CPER_ARM_ERR_ACCESS_MODE_MASK		GENMASK(0,0)
+
 /*
  * All tables and structs must be byte-packed to match CPER
  * specification, since the tables are provided by the system BIOS
@@ -494,6 +538,8 @@ struct cper_sec_pcie {
 /* Reset to default packing */
 #pragma pack()
 
+extern const char * const cper_proc_error_type_strs[4];
+
 u64 cper_next_record_id(void);
 const char *cper_severity_str(unsigned int);
 const char *cper_mem_err_type_str(unsigned int);
@@ -503,5 +549,7 @@ void cper_mem_err_pack(const struct cper_sec_mem_err *,
 		       struct cper_mem_err_compact *);
 const char *cper_mem_err_unpack(struct trace_seq *,
 				struct cper_mem_err_compact *);
+void cper_print_proc_arm(const char *pfx,
+			 const struct cper_sec_proc_arm *proc);
 
 #endif
