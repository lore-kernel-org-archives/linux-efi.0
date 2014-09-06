From: Jeff Kirsher <jeffrey.t.kirsher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] efi: Resolve some shadow warnings
Date: Fri,  5 Sep 2014 18:34:52 -0700
Message-ID: <1409967292-31441-1-git-send-email-jeffrey.t.kirsher@intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: Mark Rustad <mark.d.rustad-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Kirsher <jeffrey.t.kirsher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Mark Rustad <mark.d.rustad-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

It is a really bad idea to declare variables or parameters that
have the same name as common types. It is valid C, but it gets
surprising if a macro expansion attempts to declare an inner
local with that type. Change the local names to eliminate the
hazard.

Change s16 => ps16, s8 => ps8.

Signed-off-by: Mark Rustad <mark.d.rustad-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efi/vars.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 5abe943..afa3596 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -321,11 +321,11 @@ static unsigned long var_name_strnsize(efi_char16_t *variable_name,
  * Print a warning when duplicate EFI variables are encountered and
  * disable the sysfs workqueue since the firmware is buggy.
  */
-static void dup_variable_bug(efi_char16_t *s16, efi_guid_t *vendor_guid,
+static void dup_variable_bug(efi_char16_t *ps16, efi_guid_t *vendor_guid,
 			     unsigned long len16)
 {
 	size_t i, len8 = len16 / sizeof(efi_char16_t);
-	char *s8;
+	char *ps8;
 
 	/*
 	 * Disable the workqueue since the algorithm it uses for
@@ -334,16 +334,16 @@ static void dup_variable_bug(efi_char16_t *s16, efi_guid_t *vendor_guid,
 	 */
 	efivar_wq_enabled = false;
 
-	s8 = kzalloc(len8, GFP_KERNEL);
-	if (!s8)
+	ps8 = kzalloc(len8, GFP_KERNEL);
+	if (!ps8)
 		return;
 
 	for (i = 0; i < len8; i++)
-		s8[i] = s16[i];
+		ps8[i] = ps16[i];
 
 	printk(KERN_WARNING "efivars: duplicate variable: %s-%pUl\n",
-	       s8, vendor_guid);
-	kfree(s8);
+	       ps8, vendor_guid);
+	kfree(ps8);
 }
 
 /**
-- 
1.9.3
