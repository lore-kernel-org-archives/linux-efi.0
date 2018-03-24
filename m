From: Yazen Ghannam <Yazen.Ghannam@amd.com>
Subject: [PATCH v3 6/8] efi: Decode additional IA32/X64 Bus Check fields
Date: Sat, 24 Mar 2018 13:49:38 -0500
Message-ID: <20180324184940.19762-7-Yazen.Ghannam@amd.com>
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

The "Participation Type", "Time Out", and "Address Space" fields are
unique to the IA32/X64 Bus Check structure. Print these fields.

Based on UEFI 2.7 Table 256. IA32/X64 Bus Check Structure

Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
---
Link:
https://lkml.kernel.org/r/20180226193904.20532-7-Yazen.Ghannam@amd.com

v2->v3:
* Fix table number in commit message.

v1->v2:
* Add parantheses around "check" expression in macro.
* Fix indentation on multi-line statements.

 drivers/firmware/efi/cper-x86.c | 44 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/firmware/efi/cper-x86.c b/drivers/firmware/efi/cper-x86.c
index 260e4bf7773c..54bd32d241b7 100644
--- a/drivers/firmware/efi/cper-x86.c
+++ b/drivers/firmware/efi/cper-x86.c
@@ -41,6 +41,10 @@
 #define CHECK_VALID_RESTARTABLE_IP	BIT_ULL(6)
 #define CHECK_VALID_OVERFLOW		BIT_ULL(7)
 
+#define CHECK_VALID_BUS_PART_TYPE	BIT_ULL(8)
+#define CHECK_VALID_BUS_TIME_OUT	BIT_ULL(9)
+#define CHECK_VALID_BUS_ADDR_SPACE	BIT_ULL(10)
+
 #define CHECK_VALID_BITS(check)		(((check) & GENMASK_ULL(15, 0)))
 #define CHECK_TRANS_TYPE(check)		(((check) & GENMASK_ULL(17, 16)) >> 16)
 #define CHECK_OPERATION(check)		(((check) & GENMASK_ULL(21, 18)) >> 18)
@@ -51,6 +55,10 @@
 #define CHECK_RESTARTABLE_IP		BIT_ULL(28)
 #define CHECK_OVERFLOW			BIT_ULL(29)
 
+#define CHECK_BUS_PART_TYPE(check)	(((check) & GENMASK_ULL(31, 30)) >> 30)
+#define CHECK_BUS_TIME_OUT		BIT_ULL(32)
+#define CHECK_BUS_ADDR_SPACE(check)	(((check) & GENMASK_ULL(34, 33)) >> 33)
+
 enum err_types {
 	ERR_TYPE_CACHE = 0,
 	ERR_TYPE_TLB,
@@ -91,6 +99,20 @@ static const char * const ia_check_op_strs[] = {
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
@@ -141,6 +163,28 @@ static void print_err_info(const char *pfx, u8 err_type, u64 check)
 
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
2.14.1
