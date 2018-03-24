From: Yazen Ghannam <Yazen.Ghannam@amd.com>
Subject: [PATCH v3 3/8] efi: Decode IA32/X64 Processor Error Info Structure
Date: Sat, 24 Mar 2018 13:49:35 -0500
Message-ID: <20180324184940.19762-4-Yazen.Ghannam@amd.com>
References: <20180324184940.19762-1-Yazen.Ghannam@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180324184940.19762-1-Yazen.Ghannam@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org
Cc: Yazen Ghannam <Yazen.Ghannam@amd.com>, linux-kernel@vger.kernel.org, ard.biesheuvel@linaro.org, x86@kernel.org, bp@suse.de, tony.luck@intel.com
List-Id: linux-efi@vger.kernel.org

From: Yazen Ghannam <yazen.ghannam@amd.com>

Print the fields in the IA32/X64 Processor Error Info Structure.

Based on UEFI 2.7 Table 253. IA32/X64 Processor Error Information
Structure.

Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
---
Link:
https://lkml.kernel.org/r/20180226193904.20532-4-Yazen.Ghannam@amd.com

v2->v3:
* Fix table number in commit message.
* Don't print raw validation bits.

v1->v2:
* Add parantheses around "bits" expression in macro.
* Fix indentation on multi-line statements.

 drivers/firmware/efi/cper-x86.c | 50 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/firmware/efi/cper-x86.c b/drivers/firmware/efi/cper-x86.c
index 863f0cd2a0ff..a9ab3bbf7986 100644
--- a/drivers/firmware/efi/cper-x86.c
+++ b/drivers/firmware/efi/cper-x86.c
@@ -3,15 +3,28 @@
 
 #include <linux/cper.h>
 
+#define INDENT_SP	" "
+
 /*
  * We don't need a "CPER_IA" prefix since these are all locally defined.
  * This will save us a lot of line space.
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
 
@@ -20,4 +33,41 @@ void cper_print_proc_ia(const char *pfx, const struct cper_sec_proc_ia *proc)
 		print_hex_dump(pfx, "", DUMP_PREFIX_OFFSET, 16, 4, proc->cpuid,
 			       sizeof(proc->cpuid), 0);
 	}
+
+	snprintf(newpfx, sizeof(newpfx), "%s%s", pfx, INDENT_SP);
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
2.14.1
