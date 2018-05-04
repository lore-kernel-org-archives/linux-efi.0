From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 10/17] efi: Decode IA32/X64 Context Info structure
Date: Fri,  4 May 2018 07:59:56 +0200
Message-ID: <20180504060003.19618-11-ard.biesheuvel@linaro.org>
References: <20180504060003.19618-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180504060003.19618-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Yazen Ghannam <yazen.ghannam@amd.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Yazen Ghannam <yazen.ghannam@amd.com>

Print the fields of the IA32/X64 Context Information structure.

Print the "Register Array" as raw values. Some context types are defined
in the UEFI spec, so more detailed decoded may be added in the future.

Based on UEFI 2.7 section N.2.4.2.2 IA32/X64 Processor Context
Information Structure.

Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/cper-x86.c | 48 +++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/firmware/efi/cper-x86.c b/drivers/firmware/efi/cper-x86.c
index 356b8d326219..2531de49f56c 100644
--- a/drivers/firmware/efi/cper-x86.c
+++ b/drivers/firmware/efi/cper-x86.c
@@ -10,6 +10,7 @@
 #define VALID_LAPIC_ID			BIT_ULL(0)
 #define VALID_CPUID_INFO		BIT_ULL(1)
 #define VALID_PROC_ERR_INFO_NUM(bits)	(((bits) & GENMASK_ULL(7, 2)) >> 2)
+#define VALID_PROC_CXT_INFO_NUM(bits)	(((bits) & GENMASK_ULL(13, 8)) >> 8)
 
 #define INFO_ERR_STRUCT_TYPE_CACHE					\
 	GUID_INIT(0xA55701F5, 0xE3EF, 0x43DE, 0xAC, 0x72, 0x24, 0x9B,	\
@@ -71,6 +72,9 @@
 #define CHECK_MS_RESTARTABLE_IP		BIT_ULL(22)
 #define CHECK_MS_OVERFLOW		BIT_ULL(23)
 
+#define CTX_TYPE_MSR			1
+#define CTX_TYPE_MMREG			7
+
 enum err_types {
 	ERR_TYPE_CACHE = 0,
 	ERR_TYPE_TLB,
@@ -134,6 +138,17 @@ static const char * const ia_check_ms_error_type_strs[] = {
 	"Internal Unclassified",
 };
 
+static const char * const ia_reg_ctx_strs[] = {
+	"Unclassified Data",
+	"MSR Registers (Machine Check and other MSRs)",
+	"32-bit Mode Execution Context",
+	"64-bit Mode Execution Context",
+	"FXSAVE Context",
+	"32-bit Mode Debug Registers (DR0-DR7)",
+	"64-bit Mode Debug Registers (DR0-DR7)",
+	"Memory Mapped Registers",
+};
+
 static inline void print_bool(char *str, const char *pfx, u64 check, u64 bit)
 {
 	printk("%s%s: %s\n", pfx, str, (check & bit) ? "true" : "false");
@@ -242,6 +257,7 @@ void cper_print_proc_ia(const char *pfx, const struct cper_sec_proc_ia *proc)
 {
 	int i;
 	struct cper_ia_err_info *err_info;
+	struct cper_ia_proc_ctx *ctx_info;
 	char newpfx[64], infopfx[64];
 	u8 err_type;
 
@@ -305,4 +321,36 @@ void cper_print_proc_ia(const char *pfx, const struct cper_sec_proc_ia *proc)
 
 		err_info++;
 	}
+
+	ctx_info = (struct cper_ia_proc_ctx *)err_info;
+	for (i = 0; i < VALID_PROC_CXT_INFO_NUM(proc->validation_bits); i++) {
+		int size = sizeof(*ctx_info) + ctx_info->reg_arr_size;
+		int groupsize = 4;
+
+		printk("%sContext Information Structure %d:\n", pfx, i);
+
+		printk("%sRegister Context Type: %s\n", newpfx,
+		       ctx_info->reg_ctx_type < ARRAY_SIZE(ia_reg_ctx_strs) ?
+		       ia_reg_ctx_strs[ctx_info->reg_ctx_type] : "unknown");
+
+		printk("%sRegister Array Size: 0x%04x\n", newpfx,
+		       ctx_info->reg_arr_size);
+
+		if (ctx_info->reg_ctx_type == CTX_TYPE_MSR) {
+			groupsize = 8; /* MSRs are 8 bytes wide. */
+			printk("%sMSR Address: 0x%08x\n", newpfx,
+			       ctx_info->msr_addr);
+		}
+
+		if (ctx_info->reg_ctx_type == CTX_TYPE_MMREG) {
+			printk("%sMM Register Address: 0x%016llx\n", newpfx,
+			       ctx_info->mm_reg_addr);
+		}
+
+		printk("%sRegister Array:\n", newpfx);
+		print_hex_dump(newpfx, "", DUMP_PREFIX_OFFSET, 16, groupsize,
+			       (ctx_info + 1), ctx_info->reg_arr_size, 0);
+
+		ctx_info = (struct cper_ia_proc_ctx *)((long)ctx_info + size);
+	}
 }
-- 
2.17.0
