From: Yasuaki Ishimatsu <isimatu.yasuaki-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH] x86, efi: add efi_whitelist_table to use all efi variable
 storage
Date: Fri, 22 Nov 2013 15:29:34 +0900
Message-ID: <528EF9CE.2070305@jp.fujitsu.com>
References: <528C740A.6010407@jp.fujitsu.com>  <1384963376.20536.3.camel@x230> <528DD3E0.3050606@jp.fujitsu.com>  <1385064722.12107.1.camel@x230> <528E9EB2.3060808@jp.fujitsu.com> <1385078632.12107.3.camel@x230> <528EF87D.4050300@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <528EF87D.4050300-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "jlee-IBi9RG/b67k@public.gmane.org" <jlee-IBi9RG/b67k@public.gmane.org>, "matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org" <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, "richard-/L3Ra7n9ekc@public.gmane.org" <richard-/L3Ra7n9ekc@public.gmane.org>, "cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

By following works, my system very often fails set_variable() to set new
variable to efi variable storage and shows "efivars: set_variable() failed:
status=-28" message.

- commit 68d929862e29a8b52a7f2f2f86a0600423b093cd
     efi: be more paranoid about available space when creating variables
- commit 31ff2f20d9003e74991d135f56e503fe776c127c
     efi: Distinguish between "remaining space" and actually used space
- commit 8c58bf3eec3b8fc8162fe557e9361891c20758f2
     x86,efi: Implement efi_no_storage_paranoia parameter
- commit f8b8404337de4e2466e2e1139ea68b1f8295974f
     Modify UEFI anti-bricking code

When booting my system, remaining space of efi variable storage is about
5KB. So there is no room that sets a new variable to the storage. On my
system, trigger of gc is when EFI_OUT_OF_RESOURCES occurs on pre OS
environment with UEFI. So if EFI_OUT_OF_RESOURCES occurs by the 5Kbyte
threshold, nvram storage cannot be used until EFI_OUT_OF_RESOURCES occurs
on pre OS environment with UEFI.

This patch adds whitelist. If a server is in the whitelist,
efi_no_storage_paranoia is set to true. And the system can use all efi
variable storage.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
CC: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
CC: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
CC: Lee, Chun-Y <jlee-IBi9RG/b67k@public.gmane.org>
CC: Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
  arch/x86/platform/efi/efi.c | 19 +++++++++++++++++++
  1 file changed, 19 insertions(+)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index c7e22ab..f9fad62 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -42,6 +42,7 @@
  #include <linux/io.h>
  #include <linux/reboot.h>
  #include <linux/bcd.h>
+#include <linux/dmi.h>

  #include <asm/setup.h>
  #include <asm/efi.h>
@@ -116,6 +117,24 @@ static int __init setup_storage_paranoia(char *arg)
  }
  early_param("efi_no_storage_paranoia", setup_storage_paranoia);

+static struct dmi_system_id efi_whitelist_table[] __initdata = {
+	{
+		/* FUJITSU PRIMEQUEST */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "PRIMEQUEST"),
+		},
+	},
+	{}
+};
+
+static int __init init_efi_no_storage_paranoia(void)
+{
+	if (dmi_check_system(efi_whitelist_table))
+		efi_no_storage_paranoia = true;
+	return 0;
+}
+late_initcall(init_efi_no_storage_paranoia);

  static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
  {
