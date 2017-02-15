From: Tyler Baicar <tbaicar@codeaurora.org>
Subject: [PATCH V10 03/10] efi: parse ARM processor error
Date: Wed, 15 Feb 2017 12:51:15 -0700
Message-ID: <1487188282-2568-4-git-send-email-tbaicar@codeaurora.org>
References: <1487188282-2568-1-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <1487188282-2568-1-git-send-email-tbaicar@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, devel@acpica.org, Suzuki.Poulose@arm.com, punit.agrawal@arm.com, astone@redhat.com, harba@codeaur
Cc: Tyler Baicar <tbaicar@codeaurora.org>
List-Id: linux-efi@vger.kernel.org

Add support for ARM Common Platform Error Record (CPER).
UEFI 2.6 specification adds support for ARM specific
processor error information to be reported as part of the
CPER records. This provides more detail on for processor error logs.

Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
Signed-off-by: Naveen Kaje <nkaje@codeaurora.org>
Reviewed-by: James Morse <james.morse@arm.com>
---
 drivers/firmware/efi/cper.c | 133 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/cper.h        |  54 ++++++++++++++++++
 2 files changed, 187 insertions(+)

diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index 8fa4e23..c2b0a12 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -110,12 +110,15 @@ void cper_print_bits(const char *pfx, unsigned int bits,
 static const char * const proc_type_strs[] = {
 	"IA32/X64",
 	"IA64",
+	"ARM",
 };
 
 static const char * const proc_isa_strs[] = {
 	"IA32",
 	"IA64",
 	"X64",
+	"ARM A32/T32",
+	"ARM A64",
 };
 
 static const char * const proc_error_type_strs[] = {
@@ -139,6 +142,18 @@ void cper_print_bits(const char *pfx, unsigned int bits,
 	"corrected",
 };
 
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
 static void cper_print_proc_generic(const char *pfx,
 				    const struct cper_sec_proc_generic *proc)
 {
@@ -184,6 +199,114 @@ static void cper_print_proc_generic(const char *pfx,
 		printk("%s""IP: 0x%016llx\n", pfx, proc->ip);
 }
 
+static void cper_print_proc_arm(const char *pfx,
+				const struct cper_sec_proc_arm *proc)
+{
+	int i, len, max_ctx_type;
+	struct cper_arm_err_info *err_info;
+	struct cper_arm_ctx_info *ctx_info;
+	char newpfx[64];
+
+	printk("%s""section length: %d\n", pfx, proc->section_length);
+	printk("%s""MIDR: 0x%016llx\n", pfx, proc->midr);
+
+	len = proc->section_length - (sizeof(*proc) +
+		proc->err_info_num * (sizeof(*err_info)));
+	if (len < 0) {
+		printk("%s""section length is too small\n", pfx);
+		printk("%s""firmware-generated error record is incorrect\n", pfx);
+		printk("%s""ERR_INFO_NUM is %d\n", pfx, proc->err_info_num);
+		return;
+	}
+
+	if (proc->validation_bits & CPER_ARM_VALID_MPIDR)
+		printk("%s""MPIDR: 0x%016llx\n", pfx, proc->mpidr);
+	if (proc->validation_bits & CPER_ARM_VALID_AFFINITY_LEVEL)
+		printk("%s""error affinity level: %d\n", pfx,
+			proc->affinity_level);
+	if (proc->validation_bits & CPER_ARM_VALID_RUNNING_STATE) {
+		printk("%s""running state: 0x%x\n", pfx, proc->running_state);
+		printk("%s""PSCI state: %d\n", pfx, proc->psci_state);
+	}
+
+	snprintf(newpfx, sizeof(newpfx), "%s%s", pfx, INDENT_SP);
+
+	err_info = (struct cper_arm_err_info *)(proc + 1);
+	for (i = 0; i < proc->err_info_num; i++) {
+		printk("%s""Error info structure %d:\n", pfx, i);
+		printk("%s""version:%d\n", newpfx, err_info->version);
+		printk("%s""length:%d\n", newpfx, err_info->length);
+		if (err_info->validation_bits &
+		    CPER_ARM_INFO_VALID_MULTI_ERR) {
+			if (err_info->multiple_error == 0)
+				printk("%s""single error\n", newpfx);
+			else if (err_info->multiple_error == 1)
+				printk("%s""multiple errors\n", newpfx);
+			else
+				printk("%s""multiple errors count:%u\n",
+				newpfx, err_info->multiple_error);
+		}
+		if (err_info->validation_bits & CPER_ARM_INFO_VALID_FLAGS) {
+			if (err_info->flags & CPER_ARM_INFO_FLAGS_FIRST)
+				printk("%s""first error captured\n", newpfx);
+			if (err_info->flags & CPER_ARM_INFO_FLAGS_LAST)
+				printk("%s""last error captured\n", newpfx);
+			if (err_info->flags & CPER_ARM_INFO_FLAGS_PROPAGATED)
+				printk("%s""propagated error captured\n",
+				       newpfx);
+			if (err_info->flags & CPER_ARM_INFO_FLAGS_OVERFLOW)
+				printk("%s""overflow occurred, error info is incomplete\n",
+				       newpfx);
+		}
+		printk("%s""error_type: %d, %s\n", newpfx, err_info->type,
+			err_info->type < ARRAY_SIZE(proc_error_type_strs) ?
+			proc_error_type_strs[err_info->type] : "unknown");
+		if (err_info->validation_bits & CPER_ARM_INFO_VALID_ERR_INFO)
+			printk("%s""error_info: 0x%016llx\n", newpfx,
+			       err_info->error_info);
+		if (err_info->validation_bits & CPER_ARM_INFO_VALID_VIRT_ADDR)
+			printk("%s""virtual fault address: 0x%016llx\n",
+				newpfx, err_info->virt_fault_addr);
+		if (err_info->validation_bits &
+		    CPER_ARM_INFO_VALID_PHYSICAL_ADDR)
+			printk("%s""physical fault address: 0x%016llx\n",
+				newpfx, err_info->physical_fault_addr);
+		err_info += 1;
+	}
+	ctx_info = (struct cper_arm_ctx_info *)err_info;
+	max_ctx_type = ARRAY_SIZE(arm_reg_ctx_strs) - 1;
+	for (i = 0; i < proc->context_info_num; i++) {
+		int size = sizeof(*ctx_info) + ctx_info->size;
+
+		printk("%s""Context info structure %d:\n", pfx, i);
+		if (len < size) {
+			printk("%s""section length is too small\n", newpfx);
+			printk("%s""firmware-generated error record is incorrect\n", pfx);
+			return;
+		}
+		if (ctx_info->type > max_ctx_type) {
+			printk("%s""Invalid context type: %d\n", newpfx,
+							ctx_info->type);
+			printk("%s""Max context type: %d\n", newpfx,
+							max_ctx_type);
+			return;
+		}
+		printk("%s""register context type %d: %s\n", newpfx,
+			ctx_info->type, arm_reg_ctx_strs[ctx_info->type]);
+		print_hex_dump(newpfx, "", DUMP_PREFIX_OFFSET, 16, 4,
+				(ctx_info + 1), ctx_info->size, 0);
+		len -= size;
+		ctx_info = (struct cper_arm_ctx_info *)((long)ctx_info + size);
+	}
+
+	if (len > 0) {
+		printk("%s""Vendor specific error info has %u bytes:\n", pfx,
+		       len);
+		print_hex_dump(newpfx, "", DUMP_PREFIX_OFFSET, 16, 4, ctx_info,
+				len, 0);
+	}
+}
+
 static const char * const mem_err_type_strs[] = {
 	"unknown",
 	"no error",
@@ -458,6 +581,16 @@ static void cper_estatus_print_section(
 			cper_print_pcie(newpfx, pcie, gdata);
 		else
 			goto err_section_too_small;
+	} else if ((IS_ENABLED(CONFIG_ARM64) || IS_ENABLED(CONFIG_ARM)) &&
+		   !uuid_le_cmp(*sec_type, CPER_SEC_PROC_ARM)) {
+		struct cper_sec_proc_arm *arm_err;
+
+		arm_err = acpi_hest_generic_data_payload(gdata);
+		printk("%ssection_type: ARM processor error\n", newpfx);
+		if (gdata->error_data_length >= sizeof(*arm_err))
+			cper_print_proc_arm(newpfx, arm_err);
+		else
+			goto err_section_too_small;
 	} else
 		printk("%s""section type: unknown, %pUl\n", newpfx, sec_type);
 
diff --git a/include/linux/cper.h b/include/linux/cper.h
index dcacb1a..85450f3 100644
--- a/include/linux/cper.h
+++ b/include/linux/cper.h
@@ -180,6 +180,10 @@ enum {
 #define CPER_SEC_PROC_IPF						\
 	UUID_LE(0xE429FAF1, 0x3CB7, 0x11D4, 0x0B, 0xCA, 0x07, 0x00,	\
 		0x80, 0xC7, 0x3C, 0x88, 0x81)
+/* Processor Specific: ARM */
+#define CPER_SEC_PROC_ARM						\
+	UUID_LE(0xE19E3D16, 0xBC11, 0x11E4, 0x9C, 0xAA, 0xC2, 0x05,	\
+		0x1D, 0x5D, 0x46, 0xB0)
 /* Platform Memory */
 #define CPER_SEC_PLATFORM_MEM						\
 	UUID_LE(0xA5BC1114, 0x6F64, 0x4EDE, 0xB8, 0x63, 0x3E, 0x83,	\
@@ -255,6 +259,22 @@ enum {
 
 #define CPER_PCIE_SLOT_SHIFT			3
 
+#define CPER_ARM_VALID_MPIDR			0x00000001
+#define CPER_ARM_VALID_AFFINITY_LEVEL		0x00000002
+#define CPER_ARM_VALID_RUNNING_STATE		0x00000004
+#define CPER_ARM_VALID_VENDOR_INFO		0x00000008
+
+#define CPER_ARM_INFO_VALID_MULTI_ERR		0x0001
+#define CPER_ARM_INFO_VALID_FLAGS		0x0002
+#define CPER_ARM_INFO_VALID_ERR_INFO		0x0004
+#define CPER_ARM_INFO_VALID_VIRT_ADDR		0x0008
+#define CPER_ARM_INFO_VALID_PHYSICAL_ADDR	0x0010
+
+#define CPER_ARM_INFO_FLAGS_FIRST		0x0001
+#define CPER_ARM_INFO_FLAGS_LAST		0x0002
+#define CPER_ARM_INFO_FLAGS_PROPAGATED		0x0004
+#define CPER_ARM_INFO_FLAGS_OVERFLOW		0x0008
+
 /*
  * All tables and structs must be byte-packed to match CPER
  * specification, since the tables are provided by the system BIOS
@@ -340,6 +360,40 @@ struct cper_ia_proc_ctx {
 	__u64	mm_reg_addr;
 };
 
+/* ARM Processor Error Section */
+struct cper_sec_proc_arm {
+	__u32	validation_bits;
+	__u16	err_info_num; /* Number of Processor Error Info */
+	__u16	context_info_num; /* Number of Processor Context Info Records*/
+	__u32	section_length;
+	__u8	affinity_level;
+	__u8	reserved[3];	/* must be zero */
+	__u64	mpidr;
+	__u64	midr;
+	__u32	running_state; /* Bit 0 set - Processor running. PSCI = 0 */
+	__u32	psci_state;
+};
+
+/* ARM Processor Error Information Structure */
+struct cper_arm_err_info {
+	__u8	version;
+	__u8	length;
+	__u16	validation_bits;
+	__u8	type;
+	__u16	multiple_error;
+	__u8	flags;
+	__u64	error_info;
+	__u64	virt_fault_addr;
+	__u64	physical_fault_addr;
+};
+
+/* ARM Processor Context Information Structure */
+struct cper_arm_ctx_info {
+	__u16	version;
+	__u16	type;
+	__u32	size;
+};
+
 /* Old Memory Error Section UEFI 2.1, 2.2 */
 struct cper_sec_mem_err_old {
 	__u64	validation_bits;
-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
