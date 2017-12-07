From: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH V2 2/2] efi: parse ARM error information value
Date: Thu,  7 Dec 2017 14:25:27 -0500
Message-ID: <1512674727-25770-3-git-send-email-tbaicar@codeaurora.org>
References: <1512674727-25770-1-git-send-email-tbaicar@codeaurora.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1512674727-25770-1-git-send-email-tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, james.morse-5wv7dgnIgG8@public.gmane.org, andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

ARM errors just print out the error information value, then the
value needs to be manually decoded as per the UEFI spec. Add
decoding of the ARM error information value so that the kernel
logs capture all of the valid information at first glance.

ARM error information value decoding is captured in UEFI 2.7
spec tables 263-265.

Signed-off-by: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
---
 drivers/firmware/efi/cper-arm.c | 213 +++++++++++++++++++++++++++++++++++++++-
 include/linux/cper.h            |  44 +++++++++
 2 files changed, 255 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/cper-arm.c b/drivers/firmware/efi/cper-arm.c
index 1b56014..25cc553 100644
--- a/drivers/firmware/efi/cper-arm.c
+++ b/drivers/firmware/efi/cper-arm.c
@@ -44,13 +44,218 @@
 	"Misc. system register structure",
 };
 
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
 void cper_print_proc_arm(const char *pfx,
 			 const struct cper_sec_proc_arm *proc)
 {
 	int i, len, max_ctx_type;
 	struct cper_arm_err_info *err_info;
 	struct cper_arm_ctx_info *ctx_info;
-	char newpfx[64];
+	char newpfx[64], infopfx[64];
 
 	printk("%sMIDR: 0x%016llx\n", pfx, proc->midr);
 
@@ -102,9 +307,13 @@ void cper_print_proc_arm(const char *pfx,
 		printk("%serror_type: %d, %s\n", newpfx, err_info->type,
 			err_info->type < ARRAY_SIZE(proc_error_type_strs) ?
 			proc_error_type_strs[err_info->type] : "unknown");
-		if (err_info->validation_bits & CPER_ARM_INFO_VALID_ERR_INFO)
+		if (err_info->validation_bits & CPER_ARM_INFO_VALID_ERR_INFO) {
 			printk("%serror_info: 0x%016llx\n", newpfx,
 			       err_info->error_info);
+			snprintf(infopfx, sizeof(infopfx), "%s%s", newpfx, INDENT_SP);
+			cper_print_arm_err_info(infopfx, err_info->type,
+						err_info->error_info);
+		}
 		if (err_info->validation_bits & CPER_ARM_INFO_VALID_VIRT_ADDR)
 			printk("%svirtual fault address: 0x%016llx\n",
 				newpfx, err_info->virt_fault_addr);
diff --git a/include/linux/cper.h b/include/linux/cper.h
index 0a2d5c5..a8fee95 100644
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
-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
