From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 08/17] efi: Decode additional IA32/X64 Bus Check fields
Date: Fri,  4 May 2018 07:59:54 +0200
Message-ID: <20180504060003.19618-9-ard.biesheuvel@linaro.org>
References: <20180504060003.19618-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180504060003.19618-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Yazen Ghannam <yazen.ghannam@amd.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Yazen Ghannam <yazen.ghannam@amd.com>

The "Participation Type", "Time Out", and "Address Space" fields are
unique to the IA32/X64 Bus Check structure. Print these fields.

Based on UEFI 2.7 Table 256. IA32/X64 Bus Check Structure

Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/cper-x86.c | 44 +++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/firmware/efi/cper-x86.c b/drivers/firmware/efi/cper-x86.c
index f70c46f7a4db..5e6716564dba 100644
--- a/drivers/firmware/efi/cper-x86.c
+++ b/drivers/firmware/efi/cper-x86.c
@@ -39,6 +39,10 @@
 #define CHECK_VALID_RESTARTABLE_IP	BIT_ULL(6)
 #define CHECK_VALID_OVERFLOW		BIT_ULL(7)
 
+#define CHECK_VALID_BUS_PART_TYPE	BIT_ULL(8)
+#define CHECK_VALID_BUS_TIME_OUT	BIT_ULL(9)
+#define CHECK_VALID_BUS_ADDR_SPACE	BIT_ULL(10)
+
 #define CHECK_VALID_BITS(check)		(((check) & GENMASK_ULL(15, 0)))
 #define CHECK_TRANS_TYPE(check)		(((check) & GENMASK_ULL(17, 16)) >> 16)
 #define CHECK_OPERATION(check)		(((check) & GENMASK_ULL(21, 18)) >> 18)
@@ -49,6 +53,10 @@
 #define CHECK_RESTARTABLE_IP		BIT_ULL(28)
 #define CHECK_OVERFLOW			BIT_ULL(29)
 
+#define CHECK_BUS_PART_TYPE(check)	(((check) & GENMASK_ULL(31, 30)) >> 30)
+#define CHECK_BUS_TIME_OUT		BIT_ULL(32)
+#define CHECK_BUS_ADDR_SPACE(check)	(((check) & GENMASK_ULL(34, 33)) >> 33)
+
 enum err_types {
 	ERR_TYPE_CACHE = 0,
 	ERR_TYPE_TLB,
@@ -89,6 +97,20 @@ static const char * const ia_check_op_strs[] = {
 	"snoop",
 };
 
+static const char * const ia_check_bus_part_type_strs[] = {
+	"Local Processor originated request",
+	"Local Processor responded to request",
+	"Local Processor observed",
+	"Generic",
+};
+
+static const char * const ia_check_bus_addr_space_strs[] = {
+	"Memory Access",
+	"Reserved",
+	"I/O",
+	"Other Transaction",
+};
+
 static inline void print_bool(char *str, const char *pfx, u64 check, u64 bit)
 {
 	printk("%s%s: %s\n", pfx, str, (check & bit) ? "true" : "false");
@@ -139,6 +161,28 @@ static void print_err_info(const char *pfx, u8 err_type, u64 check)
 
 	if (validation_bits & CHECK_VALID_OVERFLOW)
 		print_bool("Overflow", pfx, check, CHECK_OVERFLOW);
+
+	if (err_type != ERR_TYPE_BUS)
+		return;
+
+	if (validation_bits & CHECK_VALID_BUS_PART_TYPE) {
+		u8 part_type = CHECK_BUS_PART_TYPE(check);
+
+		printk("%sParticipation Type: %u, %s\n", pfx, part_type,
+		       part_type < ARRAY_SIZE(ia_check_bus_part_type_strs) ?
+		       ia_check_bus_part_type_strs[part_type] : "unknown");
+	}
+
+	if (validation_bits & CHECK_VALID_BUS_TIME_OUT)
+		print_bool("Time Out", pfx, check, CHECK_BUS_TIME_OUT);
+
+	if (validation_bits & CHECK_VALID_BUS_ADDR_SPACE) {
+		u8 addr_space = CHECK_BUS_ADDR_SPACE(check);
+
+		printk("%sAddress Space: %u, %s\n", pfx, addr_space,
+		       addr_space < ARRAY_SIZE(ia_check_bus_addr_space_strs) ?
+		       ia_check_bus_addr_space_strs[addr_space] : "unknown");
+	}
 }
 
 void cper_print_proc_ia(const char *pfx, const struct cper_sec_proc_ia *proc)
-- 
2.17.0
