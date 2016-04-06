From: Tyler Baicar <tbaicar@codeaurora.org>
Subject: [PATCH V2 8/9] efi: print unrecognized CPER section
Date: Wed,  6 Apr 2016 09:12:57 -0600
Message-ID: <1459955578-24602-9-git-send-email-tbaicar@codeaurora.org>
References: <1459955578-24602-1-git-send-email-tbaicar@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459955578-24602-1-git-send-email-tbaicar@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: fu.wei@linaro.org, timur@codeaurora.org, harba@codeaurora.org, rruigrok@codeaurora.org, ahs3@redhat.com, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, devel@acpica.org
Cc: Tyler Baicar <tbaicar@codeaurora.org>, "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>
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

Following is a sample output from dmesg:
[  115.771702] {1}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 2
[  115.779042] {1}[Hardware Error]: It has been corrected by h/w and requires no further action
[  115.787456] {1}[Hardware Error]: event severity: corrected
[  115.792927] {1}[Hardware Error]:  Error 0, type: corrected
[  115.798415] {1}[Hardware Error]:  fru_id: 00000000-0000-0000-0000-000000000000
[  115.805596] {1}[Hardware Error]:  fru_text:
[  115.816105] {1}[Hardware Error]:  section type: d2e2621c-f936-468d-0d84-15a4ed015c8b
[  115.823880] {1}[Hardware Error]:  section length: 88
[  115.828779] {1}[Hardware Error]:   00000000: 01000001 00000002 5f434345 525f4543
[  115.836153] {1}[Hardware Error]:   00000010: 0000574d 00000000 00000000 00000000
[  115.843531] {1}[Hardware Error]:   00000020: 00000000 00000000 00000000 00000000
[  115.850908] {1}[Hardware Error]:   00000030: 00000000 00000000 00000000 00000000
[  115.858288] {1}[Hardware Error]:   00000040: fe800000 00000000 00000004 5f434345
[  115.865665] {1}[Hardware Error]:   00000050: 525f4543 0000574d

Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
---
 drivers/firmware/efi/cper.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index 40373e7..b9bf94a 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -584,8 +584,19 @@ static void cper_estatus_print_section(
 			cper_print_proc_armv8(newpfx, armv8_err);
 		else
 			goto err_section_too_small;
-	} else
-		printk("%s""section type: unknown, %pUl\n", newpfx, sec_type);
+	} else {
+		const void *raw_err;
+
+		if (gdata_v3)
+			raw_err = (void *)(gdata_v3 + 1);
+		else
+			raw_err = (void *)(gdata + 1);
+		printk("%ssection type: %pUl\n", newpfx, sec_type);
+		printk("%ssection length: %d\n", newpfx,
+		       gdata->error_data_length);
+		print_hex_dump(newpfx, "", DUMP_PREFIX_OFFSET, 16, 4, raw_err,
+			       gdata->error_data_length, 0);
+	}
 
 	return;
 
-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
