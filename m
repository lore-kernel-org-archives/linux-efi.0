From: Tyler Baicar <tbaicar@codeaurora.org>
Subject: [PATCH V16 03/11] cper: add timestamp print to CPER status printing
Date: Mon, 15 May 2017 15:27:52 -0600
Message-ID: <1494883680-25551-4-git-send-email-tbaicar@codeaurora.org>
References: <1494883680-25551-1-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <1494883680-25551-1-git-send-email-tbaicar@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, Suzuki.Poulose@arm.com, punit.agrawal@arm.com, astone@redhat.com, harba@codeaurora.org, hanjun.gu
Cc: Tyler Baicar <tbaicar@codeaurora.org>
List-Id: linux-efi@vger.kernel.org

The ACPI 6.1 spec added a timestamp to the generic error data
entry structure. Print the timestamp out when printing out the
error information.

Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
CC: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
---
 drivers/firmware/efi/cper.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index 9024757..229cf92 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -32,6 +32,8 @@
 #include <linux/acpi.h>
 #include <linux/pci.h>
 #include <linux/aer.h>
+#include <linux/printk.h>
+#include <linux/bcd.h>
 #include <acpi/ghes.h>
 
 #define INDENT_SP	" "
@@ -387,6 +389,27 @@ static void cper_print_pcie(const char *pfx, const struct cper_sec_pcie *pcie,
 	pfx, pcie->bridge.secondary_status, pcie->bridge.control);
 }
 
+static void cper_print_tstamp(const char *pfx,
+				   struct acpi_hest_generic_data_v300 *gdata)
+{
+	__u8 hour, min, sec, day, mon, year, century, *timestamp;
+
+	if (gdata->validation_bits & ACPI_HEST_GEN_VALID_TIMESTAMP) {
+		timestamp = (__u8 *)&(gdata->time_stamp);
+		sec       = bcd2bin(timestamp[0]);
+		min       = bcd2bin(timestamp[1]);
+		hour      = bcd2bin(timestamp[2]);
+		day       = bcd2bin(timestamp[4]);
+		mon       = bcd2bin(timestamp[5]);
+		year      = bcd2bin(timestamp[6]);
+		century   = bcd2bin(timestamp[7]);
+
+		printk("%s%ststamp: %02d%02d-%02d-%02d %02d:%02d:%02d\n", pfx,
+		       (timestamp[3] & 0x1 ? "precise " : "imprecise "),
+		       century, year, mon, day, hour, min, sec);
+	}
+}
+
 static void
 cper_estatus_print_section(const char *pfx, struct acpi_hest_generic_data *gdata,
 			   int sec_no)
@@ -395,6 +418,9 @@ static void cper_print_pcie(const char *pfx, const struct cper_sec_pcie *pcie,
 	__u16 severity;
 	char newpfx[64];
 
+	if (acpi_hest_get_version(gdata) >= 3)
+		cper_print_tstamp(pfx, (struct acpi_hest_generic_data_v300 *)gdata);
+
 	severity = gdata->error_severity;
 	printk("%s""Error %d, type: %s\n", pfx, sec_no,
 	       cper_severity_str(severity));
-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
