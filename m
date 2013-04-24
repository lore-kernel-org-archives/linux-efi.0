From: Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] efi: Check EFI revision in setup_efi_vars
Date: Wed, 24 Apr 2013 11:16:52 -0400
Message-ID: <20130424151652.GD15272@hansolo.jdub.homelinux.org>
References: <20130424143738.GB15272@hansolo.jdub.homelinux.org>
 <5177EFCE.80104@intel.com>
 <20130424145449.GC15272@hansolo.jdub.homelinux.org>
 <5177F2C3.5080907@intel.com>
 <1366815685.9976.0.camel@x230>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1366815685.9976.0.camel@x230>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

We need to check the runtime sys_table for the EFI version the firmware
specifies instead of just checking for a NULL QueryVariableInfo.  Older
implementations of EFI don't have QueryVariableInfo but the runtime is
a smaller structure, so the pointer to it may be pointing off into garbage.

This is apparently the case with several Apple firmwares that support EFI
1.10, and the current check causes them to no longer boot.  Fix based on
a suggestion from Matthew Garrett.

Signed-off-by: Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 v2: Drop the unnecessary NULL check

 arch/x86/boot/compressed/eboot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 8615f75..4060c8d 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -258,7 +258,7 @@ static efi_status_t setup_efi_vars(struct boot_params *params)
 	u64 store_size, remaining_size, var_size;
 	efi_status_t status;
 
-	if (!sys_table->runtime->query_variable_info)
+	if (sys_table->runtime->hdr.revision < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
 	data = (struct setup_data *)(unsigned long)params->hdr.setup_data;
-- 
1.8.1.4
