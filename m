From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 05/17] efi: Decode IA32/X64 Processor Error Info Structure
Date: Fri,  4 May 2018 07:59:51 +0200
Message-ID: <20180504060003.19618-6-ard.biesheuvel@linaro.org>
References: <20180504060003.19618-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180504060003.19618-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Yazen Ghannam <yazen.ghannam@amd.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Yazen Ghannam <yazen.ghannam@amd.com>

Print the fields in the IA32/X64 Processor Error Info Structure.

Based on UEFI 2.7 Table 253. IA32/X64 Processor Error Information
Structure.

Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/cper-x86.c | 48 +++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/firmware/efi/cper-x86.c b/drivers/firmware/efi/cper-x86.c
index 863f0cd2a0ff..e0633a103fcf 100644
--- a/drivers/firmware/efi/cper-x86.c
+++ b/drivers/firmware/efi/cper-x86.c
@@ -9,9 +9,20 @@
  */
 #define VALID_LAPIC_ID			BIT_ULL(0)
 #define VALID_CPUID_INFO		BIT_ULL(1)
+#define VALID_PROC_ERR_INFO_NUM(bits)	(((bits) & GENMASK_ULL(7, 2)) >> 2)
+
+#define INFO_VALID_CHECK_INFO		BIT_ULL(0)
+#define INFO_VALID_TARGET_ID		BIT_ULL(1)
+#define INFO_VALID_REQUESTOR_ID		BIT_ULL(2)
+#define INFO_VALID_RESPONDER_ID		BIT_ULL(3)
+#define INFO_VALID_IP			BIT_ULL(4)
 
 void cper_print_proc_ia(const char *pfx, const struct cper_sec_proc_ia *proc)
 {
+	int i;
+	struct cper_ia_err_info *err_info;
+	char newpfx[64];
+
 	if (proc->validation_bits & VALID_LAPIC_ID)
 		printk("%sLocal APIC_ID: 0x%llx\n", pfx, proc->lapic_id);
 
@@ -20,4 +31,41 @@ void cper_print_proc_ia(const char *pfx, const struct cper_sec_proc_ia *proc)
 		print_hex_dump(pfx, "", DUMP_PREFIX_OFFSET, 16, 4, proc->cpuid,
 			       sizeof(proc->cpuid), 0);
 	}
+
+	snprintf(newpfx, sizeof(newpfx), "%s ", pfx);
+
+	err_info = (struct cper_ia_err_info *)(proc + 1);
+	for (i = 0; i < VALID_PROC_ERR_INFO_NUM(proc->validation_bits); i++) {
+		printk("%sError Information Structure %d:\n", pfx, i);
+
+		printk("%sError Structure Type: %pUl\n", newpfx,
+		       &err_info->err_type);
+
+		if (err_info->validation_bits & INFO_VALID_CHECK_INFO) {
+			printk("%sCheck Information: 0x%016llx\n", newpfx,
+			       err_info->check_info);
+		}
+
+		if (err_info->validation_bits & INFO_VALID_TARGET_ID) {
+			printk("%sTarget Identifier: 0x%016llx\n",
+			       newpfx, err_info->target_id);
+		}
+
+		if (err_info->validation_bits & INFO_VALID_REQUESTOR_ID) {
+			printk("%sRequestor Identifier: 0x%016llx\n",
+			       newpfx, err_info->requestor_id);
+		}
+
+		if (err_info->validation_bits & INFO_VALID_RESPONDER_ID) {
+			printk("%sResponder Identifier: 0x%016llx\n",
+			       newpfx, err_info->responder_id);
+		}
+
+		if (err_info->validation_bits & INFO_VALID_IP) {
+			printk("%sInstruction Pointer: 0x%016llx\n",
+			       newpfx, err_info->ip);
+		}
+
+		err_info++;
+	}
 }
-- 
2.17.0
