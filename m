From: Tyler Baicar <tbaicar@codeaurora.org>
Subject: [PATCH V14 07/10] efi: print unrecognized CPER section
Date: Tue, 28 Mar 2017 13:30:37 -0600
Message-ID: <1490729440-32591-8-git-send-email-tbaicar@codeaurora.org>
References: <1490729440-32591-1-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <1490729440-32591-1-git-send-email-tbaicar@codeaurora.org>
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

UEFI spec allows for non-standard section in Common Platform Error
Record. This is defined in section N.2.3 of UEFI version 2.5.

Currently if the CPER section's type (UUID) does not match with
one of the section types that the kernel knows how to parse, the
section is skipped. Therefore, user is not able to see
such CPER data, for instance, error record of non-standard section.

For above mentioned case, this change prints out the raw data in
hex in dmesg buffer. Data length is taken from Error Data length
field of Generic Error Data Entry.

The following is a sample output from dmesg:
[  140.739180] {1}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 2
[  140.739182] {1}[Hardware Error]: It has been corrected by h/w and requires no further action
[  140.739191] {1}[Hardware Error]: event severity: corrected
[  140.739196] {1}[Hardware Error]:  time: precise 2017-03-15 20:37:35
[  140.739197] {1}[Hardware Error]:  Error 0, type: corrected
[  140.739203] {1}[Hardware Error]:   section type: unknown, d2e2621c-f936-468d-0d84-15a4ed015c8b
[  140.739205] {1}[Hardware Error]:   section length: 568 (0x238)
[  140.739210] {1}[Hardware Error]:   00000000: 4d415201 4d492031 453a4d45 435f4343  .RAM1 IMEM:ECC_C
[  140.739214] {1}[Hardware Error]:   00000010: 53515f45 44525f42 00000000 00000000  E_QSB_RD........
[  140.739217] {1}[Hardware Error]:   00000020: 00000000 00000000 00000000 00000000  ................
[  140.739220] {1}[Hardware Error]:   00000030: 00000000 00000000 01010000 01010000  ................
[  140.739223] {1}[Hardware Error]:   00000040: 00000000 00000000 00000005 00000000  ................
[  140.739226] {1}[Hardware Error]:   00000050: 01010000 00000000 00000001 00dddd00  ................
...

The raw data from the error can then be decoded using vendor
specific tools.

Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
CC: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
Reviewed-by: James Morse <james.morse@arm.com>
---
 drivers/firmware/efi/cper.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index 56aa516..d263bc8 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -591,8 +591,16 @@ static void cper_estatus_print_section(
 			cper_print_proc_arm(newpfx, arm_err);
 		else
 			goto err_section_too_small;
-	} else
-		printk("%s""section type: unknown, %pUl\n", newpfx, sec_type);
+	} else {
+		const void *unknown_err;
+
+		unknown_err = acpi_hest_generic_data_payload(gdata);
+		printk("%ssection type: unknown, %pUl\n", newpfx, sec_type);
+		printk("%ssection length: %d (%#x)\n", newpfx,
+		       gdata->error_data_length, gdata->error_data_length);
+		print_hex_dump(newpfx, "", DUMP_PREFIX_OFFSET, 16, 4,
+			       unknown_err, gdata->error_data_length, true);
+	}
 
 	return;
 
-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
