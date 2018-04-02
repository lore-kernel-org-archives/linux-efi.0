From: Yazen Ghannam <Yazen.Ghannam@amd.com>
Subject: [PATCH v4 5/8] efi: Decode IA32/X64 Cache, TLB, and Bus Check structures
Date: Mon,  2 Apr 2018 10:06:53 -0500
Message-ID: <20180402150656.101022-6-Yazen.Ghannam@amd.com>
References: <20180402150656.101022-1-Yazen.Ghannam@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180402150656.101022-1-Yazen.Ghannam@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org
Cc: Yazen Ghannam <Yazen.Ghannam@amd.com>, linux-kernel@vger.kernel.org, ard.biesheuvel@linaro.org, bp@suse.de, x86@kernel.org, tony.luck@intel.com
List-Id: linux-efi@vger.kernel.org

From: Yazen Ghannam <yazen.ghannam@amd.com>

Print the common fields of the Cache, TLB, and Bus check structures.The
fields of these three check types are the same except for a few more
fields in the Bus check structure. The remaining Bus check structure
fields will be decoded in a following patch.

Based on UEFI 2.7,
Table 254. IA32/X64 Cache Check Structure
Table 255. IA32/X64 TLB Check Structure
Table 256. IA32/X64 Bus Check Structure

Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
---
Link:
https://lkml.kernel.org/r/20180324184940.19762-6-Yazen.Ghannam@amd.com

v3->v4:
* Drop INDENT_SP use.

v2->v3:
* Fix table numbers in commit message.
* Don't print raw validation bits.

v1->v2:
* Add parantheses around "check" expression in macro.
* Change use of enum type to u8.
* Fix indentation on multi-line statements.

 drivers/firmware/efi/cper-x86.c | 99 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 98 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/cper-x86.c b/drivers/firmware/efi/cper-x86.c
index 5438097b93ac..f70c46f7a4db 100644
--- a/drivers/firmware/efi/cper-x86.c
+++ b/drivers/firmware/efi/cper-x86.c
@@ -30,6 +30,25 @@
 #define INFO_VALID_RESPONDER_ID		BIT_ULL(3)
 #define INFO_VALID_IP			BIT_ULL(4)
 
+#define CHECK_VALID_TRANS_TYPE		BIT_ULL(0)
+#define CHECK_VALID_OPERATION		BIT_ULL(1)
+#define CHECK_VALID_LEVEL		BIT_ULL(2)
+#define CHECK_VALID_PCC			BIT_ULL(3)
+#define CHECK_VALID_UNCORRECTED		BIT_ULL(4)
+#define CHECK_VALID_PRECISE_IP		BIT_ULL(5)
+#define CHECK_VALID_RESTARTABLE_IP	BIT_ULL(6)
+#define CHECK_VALID_OVERFLOW		BIT_ULL(7)
+
+#define CHECK_VALID_BITS(check)		(((check) & GENMASK_ULL(15, 0)))
+#define CHECK_TRANS_TYPE(check)		(((check) & GENMASK_ULL(17, 16)) >> 16)
+#define CHECK_OPERATION(check)		(((check) & GENMASK_ULL(21, 18)) >> 18)
+#define CHECK_LEVEL(check)		(((check) & GENMASK_ULL(24, 22)) >> 22)
+#define CHECK_PCC			BIT_ULL(25)
+#define CHECK_UNCORRECTED		BIT_ULL(26)
+#define CHECK_PRECISE_IP		BIT_ULL(27)
+#define CHECK_RESTARTABLE_IP		BIT_ULL(28)
+#define CHECK_OVERFLOW			BIT_ULL(29)
+
 enum err_types {
 	ERR_TYPE_CACHE = 0,
 	ERR_TYPE_TLB,
@@ -52,11 +71,81 @@ static enum err_types cper_get_err_type(const guid_t *err_type)
 		return N_ERR_TYPES;
 }
 
+static const char * const ia_check_trans_type_strs[] = {
+	"Instruction",
+	"Data Access",
+	"Generic",
+};
+
+static const char * const ia_check_op_strs[] = {
+	"generic error",
+	"generic read",
+	"generic write",
+	"data read",
+	"data write",
+	"instruction fetch",
+	"prefetch",
+	"eviction",
+	"snoop",
+};
+
+static inline void print_bool(char *str, const char *pfx, u64 check, u64 bit)
+{
+	printk("%s%s: %s\n", pfx, str, (check & bit) ? "true" : "false");
+}
+
+static void print_err_info(const char *pfx, u8 err_type, u64 check)
+{
+	u16 validation_bits = CHECK_VALID_BITS(check);
+
+	if (err_type == ERR_TYPE_MS)
+		return;
+
+	if (validation_bits & CHECK_VALID_TRANS_TYPE) {
+		u8 trans_type = CHECK_TRANS_TYPE(check);
+
+		printk("%sTransaction Type: %u, %s\n", pfx, trans_type,
+		       trans_type < ARRAY_SIZE(ia_check_trans_type_strs) ?
+		       ia_check_trans_type_strs[trans_type] : "unknown");
+	}
+
+	if (validation_bits & CHECK_VALID_OPERATION) {
+		u8 op = CHECK_OPERATION(check);
+
+		/*
+		 * CACHE has more operation types than TLB or BUS, though the
+		 * name and the order are the same.
+		 */
+		u8 max_ops = (err_type == ERR_TYPE_CACHE) ? 9 : 7;
+
+		printk("%sOperation: %u, %s\n", pfx, op,
+		       op < max_ops ? ia_check_op_strs[op] : "unknown");
+	}
+
+	if (validation_bits & CHECK_VALID_LEVEL)
+		printk("%sLevel: %llu\n", pfx, CHECK_LEVEL(check));
+
+	if (validation_bits & CHECK_VALID_PCC)
+		print_bool("Processor Context Corrupt", pfx, check, CHECK_PCC);
+
+	if (validation_bits & CHECK_VALID_UNCORRECTED)
+		print_bool("Uncorrected", pfx, check, CHECK_UNCORRECTED);
+
+	if (validation_bits & CHECK_VALID_PRECISE_IP)
+		print_bool("Precise IP", pfx, check, CHECK_PRECISE_IP);
+
+	if (validation_bits & CHECK_VALID_RESTARTABLE_IP)
+		print_bool("Restartable IP", pfx, check, CHECK_RESTARTABLE_IP);
+
+	if (validation_bits & CHECK_VALID_OVERFLOW)
+		print_bool("Overflow", pfx, check, CHECK_OVERFLOW);
+}
+
 void cper_print_proc_ia(const char *pfx, const struct cper_sec_proc_ia *proc)
 {
 	int i;
 	struct cper_ia_err_info *err_info;
-	char newpfx[64];
+	char newpfx[64], infopfx[64];
 	u8 err_type;
 
 	if (proc->validation_bits & VALID_LAPIC_ID)
@@ -87,6 +176,14 @@ void cper_print_proc_ia(const char *pfx, const struct cper_sec_proc_ia *proc)
 		if (err_info->validation_bits & INFO_VALID_CHECK_INFO) {
 			printk("%sCheck Information: 0x%016llx\n", newpfx,
 			       err_info->check_info);
+
+			if (err_type < N_ERR_TYPES) {
+				snprintf(infopfx, sizeof(infopfx), "%s ",
+					 newpfx);
+
+				print_err_info(infopfx, err_type,
+					       err_info->check_info);
+			}
 		}
 
 		if (err_info->validation_bits & INFO_VALID_TARGET_ID) {
-- 
2.14.1
