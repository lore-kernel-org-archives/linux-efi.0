From: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH V3 07/10] efi: print unrecognized CPER section
Date: Fri,  7 Oct 2016 15:31:19 -0600
Message-ID: <1475875882-2604-8-git-send-email-tbaicar@codeaurora.org>
References: <1475875882-2604-1-git-send-email-tbaicar@codeaurora.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475875882-2604-1-git-send-email-tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, james.morse-5wv7dgnIgG8@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, sandeepa.s.prabhu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shijie.huang-5wv7dgnIgG8@public.gmane.org, paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, tomasz.nowicki-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, Dkvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-E0kO6a4B6psdnm+yROfE0A@public.gmane.org
Cc: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
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

Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Signed-off-by: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
---
 drivers/firmware/efi/cper.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index 2594245..f9ffba6 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -605,8 +605,16 @@ static void cper_estatus_print_section(
 			cper_print_proc_armv8(newpfx, armv8_err);
 		else
 			goto err_section_too_small;
-	} else
-		printk("%s""section type: unknown, %pUl\n", newpfx, sec_type);
+	} else {
+		const void *unknown_err;
+
+		unknown_err = acpi_hest_generic_data_payload(gdata);
+		printk("%ssection type: %pUl\n", newpfx, sec_type);
+		printk("%ssection length: %d\n", newpfx,
+		       gdata->error_data_length);
+		print_hex_dump(newpfx, "", DUMP_PREFIX_OFFSET, 16, 4,
+			       unknown_err, gdata->error_data_length, 0);
+	}
 
 	return;
 
-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
