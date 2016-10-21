From: Tyler Baicar <tbaicar@codeaurora.org>
Subject: [PATCH V4 03/10] efi: parse ARMv8 processor error
Date: Fri, 21 Oct 2016 11:30:06 -0600
Message-ID: <1477071013-29563-4-git-send-email-tbaicar@codeaurora.org>
References: <1477071013-29563-1-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <1477071013-29563-1-git-send-email-tbaicar@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tomasz.nowicki@linaro.org, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, Suzuki.Poulose@arm.com, punit.agrawal@arm.com, astone@redhat.com, harba@codeaurora.org, hanjun.guo@linaro.org
Cc: Tyler Baicar <tbaicar@codeaurora.org>
List-Id: linux-efi@vger.kernel.org

Add support for ARMv8 Common Platform Error Record (CPER).
UEFI 2.6 specification adds support for ARMv8 specific
processor error information to be reported as part of the
CPER records. This provides more detail on for processor error logs.

Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
Signed-off-by: Naveen Kaje <nkaje@codeaurora.org>
---
 drivers/firmware/efi/cper.c | 135 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/cper.h        |  72 +++++++++++++++++++++++
 2 files changed, 207 insertions(+)

diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index af7e1e9..8264eed 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -110,12 +110,15 @@ void cper_print_bits(const char *pfx, unsigned int bits,
 static const char * const proc_type_strs[] = {
 	"IA32/X64",
 	"IA64",
+	"ARMv8",
 };
 
 static const char * const proc_isa_strs[] = {
 	"IA32",
 	"IA64",
 	"X64",
+	"ARM A32/T32",
+	"ARM A64",
 };
 
 static const char * const proc_error_type_strs[] = {
@@ -184,6 +187,129 @@ static void cper_print_proc_generic(const char *pfx,
 		printk("%s""IP: 0x%016llx\n", pfx, proc->ip);
 }
 
+static void cper_print_proc_armv8(const char *pfx,
+				  const struct cper_sec_proc_armv8 *proc)
+{
+	int i, len;
+	struct cper_armv8_err_info *err_info;
+	__u64 *qword = NULL;
+	char newpfx[64];
+
+	printk("%ssection length: %d\n", pfx, proc->section_length);
+	printk("%sMIDR: 0x%016llx\n", pfx, proc->midr);
+
+	len = proc->section_length - (sizeof(*proc) +
+		proc->err_info_num * (sizeof(*err_info)));
+	if (len < 0) {
+		printk("%ssection length is too small.\n", pfx);
+		printk("%sERR_INFO_NUM is %d.\n", pfx, proc->err_info_num);
+		return;
+	}
+
+	if (proc->validation_bits & CPER_ARMV8_VALID_MPIDR)
+		printk("%sMPIDR: 0x%016llx\n", pfx, proc->mpidr);
+	if (proc->validation_bits & CPER_ARMV8_VALID_AFFINITY_LEVEL)
+		printk("%serror affinity level: %d\n", pfx,
+			proc->affinity_level);
+	if (proc->validation_bits & CPER_ARMV8_VALID_RUNNING_STATE) {
+		printk("%srunning state: %d\n", pfx, proc->running_state);
+		printk("%sPSCI state: %d\n", pfx, proc->psci_state);
+	}
+
+	snprintf(newpfx, sizeof(newpfx), "%s%s", pfx, INDENT_SP);
+
+	err_info = (struct cper_armv8_err_info *)(proc + 1);
+	for (i = 0; i < proc->err_info_num; i++) {
+		printk("%sError info structure %d:\n", pfx, i);
+		printk("%sversion:%d\n", newpfx, err_info->version);
+		printk("%slength:%d\n", newpfx, err_info->length);
+		if (err_info->validation_bits &
+		    CPER_ARMV8_INFO_VALID_MULTI_ERR) {
+			if (err_info->multiple_error == 0)
+				printk("%ssingle error.\n", newpfx);
+			else if (err_info->multiple_error == 1)
+				printk("%smultiple errors.\n", newpfx);
+			else
+				printk("%smultiple errors count:%d.\n",
+				newpfx, err_info->multiple_error);
+		}
+		if (err_info->validation_bits & CPER_ARMV8_INFO_VALID_FLAGS) {
+			if (err_info->flags & CPER_ARMV8_INFO_FLAGS_FIRST)
+				printk("%sfirst error captured.\n", newpfx);
+			if (err_info->flags & CPER_ARMV8_INFO_FLAGS_LAST)
+				printk("%slast error captured.\n", newpfx);
+			if (err_info->flags & CPER_ARMV8_INFO_FLAGS_PROPAGATED)
+				printk("%spropagated error captured.\n",
+				       newpfx);
+		}
+		printk("%serror_type: %d, %s\n", newpfx, err_info->type,
+			err_info->type < ARRAY_SIZE(proc_error_type_strs) ?
+			proc_error_type_strs[err_info->type] : "unknown");
+		printk("%serror_info: 0x%016llx\n", newpfx,
+		       err_info->error_info);
+		if (err_info->validation_bits & CPER_ARMV8_INFO_VALID_VIRT_ADDR)
+			printk("%svirtual fault address: 0x%016llx\n",
+				newpfx, err_info->virt_fault_addr);
+		if (err_info->validation_bits &
+		    CPER_ARMV8_INFO_VALID_PHYSICAL_ADDR)
+			printk("%sphysical fault address: 0x%016llx\n",
+				newpfx, err_info->physical_fault_addr);
+		err_info += 1;
+	}
+
+	if (len < sizeof(*qword) && proc->context_info_num > 0) {
+		printk("%ssection length is too small.\n", pfx);
+		printk("%sCTX_INFO_NUM is %d.\n", pfx, proc->context_info_num);
+		return;
+	}
+	for (i = 0; i < proc->context_info_num; i++) {
+		qword = (__u64 *)err_info;
+		printk("%sProcessor context info structure %d:\n", pfx, i);
+		printk("%sException level %d.\n", newpfx,
+		       (int)((*qword & CPER_ARMV8_CTX_EL_MASK)
+				>> CPER_ARMV8_CTX_EL_SHIFT));
+		printk("%sSecure bit: %d.\n", newpfx,
+		       (int)((*qword & CPER_ARMV8_CTX_NS_MASK)
+				>> CPER_ARMV8_CTX_NS_SHIFT));
+		if ((*qword & CPER_ARMV8_CTX_TYPE_MASK) == 0) {
+			if (len < CPER_AARCH32_CTX_LEN) {
+				printk("%ssection length is too small.\n", pfx);
+				printk("%sremaining length is %d.\n", pfx, len);
+				return;
+			}
+			printk("%sAArch32 execution context.\n", newpfx);
+			qword++;
+			print_hex_dump(newpfx, "", DUMP_PREFIX_OFFSET, 16, 4,
+				qword, CPER_AARCH32_CTX_LEN - sizeof(*qword),
+				0);
+			len -= CPER_AARCH32_CTX_LEN;
+		} else if ((*qword & CPER_ARMV8_CTX_TYPE_MASK) == 1) {
+			if (len < CPER_AARCH64_CTX_LEN) {
+				printk("%ssection length is too small.\n", pfx);
+				printk("%sremaining length is %d.\n", pfx, len);
+				return;
+			}
+			printk("%sAArch64 execution context.\n", newpfx);
+			qword++;
+			print_hex_dump(newpfx, "", DUMP_PREFIX_OFFSET, 16, 4,
+				qword, CPER_AARCH64_CTX_LEN - sizeof(*qword),
+				0);
+			len -= CPER_AARCH64_CTX_LEN;
+		} else {
+			printk("%scontext type is incorrect 0x%016llx.\n",
+			pfx, *qword);
+			return;
+		}
+	}
+
+	if (len > 0) {
+		printk("%sVendor specific error info has %d bytes.\n", pfx,
+		       len);
+		print_hex_dump(pfx, "", DUMP_PREFIX_OFFSET, 16, 4, qword, len,
+			0);
+	}
+}
+
 static const char * const mem_err_type_strs[] = {
 	"unknown",
 	"no error",
@@ -458,6 +584,15 @@ static void cper_estatus_print_section(
 			cper_print_pcie(newpfx, pcie, gdata);
 		else
 			goto err_section_too_small;
+	} else if (!uuid_le_cmp(*sec_type, CPER_SEC_PROC_ARMV8)) {
+		struct cper_sec_proc_armv8 *armv8_err;
+
+		armv8_err = acpi_hest_generic_data_payload(gdata);
+		printk("%ssection_type: ARMv8 processor error\n", newpfx);
+		if (gdata->error_data_length >= sizeof(*armv8_err))
+			cper_print_proc_armv8(newpfx, armv8_err);
+		else
+			goto err_section_too_small;
 	} else
 		printk("%s""section type: unknown, %pUl\n", newpfx, sec_type);
 
diff --git a/include/linux/cper.h b/include/linux/cper.h
index 13ea41c..2a9d553 100644
--- a/include/linux/cper.h
+++ b/include/linux/cper.h
@@ -162,6 +162,11 @@ enum {
  * corrective action before the data is consumed
  */
 #define CPER_SEC_LATENT_ERROR			0x0020
+/*
+ * If set, the section contains an error that is propagated. The error
+ * did not originate from the hardware associated with this section.
+ */
+#define CPER_SEC_PROPAGATED			0x0040
 
 /*
  * Section type definitions, used in section_type field in struct
@@ -180,6 +185,10 @@ enum {
 #define CPER_SEC_PROC_IPF						\
 	UUID_LE(0xE429FAF1, 0x3CB7, 0x11D4, 0x0B, 0xCA, 0x07, 0x00,	\
 		0x80, 0xC7, 0x3C, 0x88, 0x81)
+/* Processor Specific: ARMv8 */
+#define CPER_SEC_PROC_ARMV8						\
+	UUID_LE(0xE19E3D16, 0xBC11, 0x11E4, 0x9C, 0xAA, 0xC2, 0x05,	\
+		0x1D, 0x5D, 0x46, 0xB0)
 /* Platform Memory */
 #define CPER_SEC_PLATFORM_MEM						\
 	UUID_LE(0xA5BC1114, 0x6F64, 0x4EDE, 0xB8, 0x63, 0x3E, 0x83,	\
@@ -255,6 +264,34 @@ enum {
 
 #define CPER_PCIE_SLOT_SHIFT			3
 
+#define CPER_ARMV8_ERR_INFO_NUM_MASK		0x00000000000000FF
+#define CPER_ARMV8_CTX_INFO_NUM_MASK		0x0000000000FFFF00
+#define CPER_ARMV8_CTX_INFO_NUM_SHIFT		8
+
+#define CPER_ARMV8_VALID_MPIDR			0x00000001
+#define CPER_ARMV8_VALID_AFFINITY_LEVEL		0x00000002
+#define CPER_ARMV8_VALID_RUNNING_STATE		0x00000004
+#define CPER_ARMV8_VALID_VENDOR_INFO		0x00000008
+
+#define CPER_ARMV8_INFO_VALID_MULTI_ERR		0x0001
+#define CPER_ARMV8_INFO_VALID_FLAGS		0x0002
+#define CPER_ARMV8_INFO_VALID_ERR_INFO		0x0004
+#define CPER_ARMV8_INFO_VALID_VIRT_ADDR		0x0008
+#define CPER_ARMV8_INFO_VALID_PHYSICAL_ADDR	0x0010
+
+#define CPER_ARMV8_INFO_FLAGS_FIRST		0x0001
+#define CPER_ARMV8_INFO_FLAGS_LAST		0x0002
+#define CPER_ARMV8_INFO_FLAGS_PROPAGATED	0x0004
+
+#define CPER_AARCH64_CTX_LEN			368
+#define CPER_AARCH32_CTX_LEN			256
+
+#define CPER_ARMV8_CTX_TYPE_MASK		0x000000000000000F
+#define CPER_ARMV8_CTX_EL_MASK			0x0000000000000070
+#define CPER_ARMV8_CTX_NS_MASK			0x0000000000000080
+#define CPER_ARMV8_CTX_EL_SHIFT			4
+#define CPER_ARMV8_CTX_NS_SHIFT			7
+
 #define acpi_hest_generic_data_error_length(gdata)	\
 	(((struct acpi_hest_generic_data *)(gdata))->error_data_length)
 #define acpi_hest_generic_data_size(gdata)		\
@@ -352,6 +389,41 @@ struct cper_ia_proc_ctx {
 	__u64	mm_reg_addr;
 };
 
+/* ARMv8 Processor Error Section */
+struct cper_sec_proc_armv8 {
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
+/* ARMv8 Processor Error Information Structure */
+struct cper_armv8_err_info {
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
+/* ARMv8 AARCH64 Processor Context Information Structure */
+struct cper_armv8_aarch64_ctx {
+	__u8	type_el_ns;
+	__u8	reserved[7];	/* must be zero */
+	__u8	gpr[288];
+	__u8	spr[68];
+};
+
 /* Old Memory Error Section UEFI 2.1, 2.2 */
 struct cper_sec_mem_err_old {
 	__u64	validation_bits;
-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
