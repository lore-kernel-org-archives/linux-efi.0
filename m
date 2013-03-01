From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] efivarfs: fix abnormal GUID in variable name by using
 strcpy to replace null with dash
Date: Fri, 01 Mar 2013 15:17:48 +0000
Message-ID: <1362151068.2842.440.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1362108018-13117-1-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1362108018-13117-1-git-send-email-jlee-IBi9RG/b67k@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Schroeder <mls-IBi9RG/b67k@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 2013-03-01 at 11:20 +0800, Lee, Chun-Yi wrote:
> From: Michael Schroeder <mls-IBi9RG/b67k@public.gmane.org>
> 
> On HP z220 system (firmware version 1.54), some EFI variables are incorrectly
> named :
> 
> ls -d /sys/firmware/efi/vars/*8be4d* | grep -v -- -8be returns
> /sys/firmware/efi/vars/dbxDefault-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
> /sys/firmware/efi/vars/KEKDefault-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
> /sys/firmware/efi/vars/SecureBoot-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
> /sys/firmware/efi/vars/SetupMode-Information8be4df61-93ca-11d2-aa0d-00e098032b8c
> 
> That causes by the following statement in efivar_create_sysfs_entry function:
> 
>  *(short_name + strlen(short_name)) = '-';
> efi_guid_unparse(vendor_guid, short_name + strlen(short_name));
> 
> The trailing \0 is overwritten with '-', but the next char doesn't seem to be a \0
> as well for HP. So, the second strlen return the point of next '\0', causes there
> have garbage string attached before GUID.
> 
> Tested on On HP z220.

What's more likely happening here is that GetNextVariable() is broken on
this HP firmware and variable_name_size is too big for the given
variable in variable_name. We've seen other reports of similar bugs,

	https://bugzilla.kernel.org/show_bug.cgi?id=47631


Could someone try this patch against Linus' tree?

---

>From fe38d6f69c889b0f95c5548c724633aa58c2c99f Mon Sep 17 00:00:00 2001
From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date: Fri, 1 Mar 2013 14:49:12 +0000
Subject: [PATCH] efivars: Sanitise string length returned by
 GetNextVariableName()

Some buggy firmware implementations return a string length from
GetNextVariableName() that is actually larger than the string in
'variable_name', as Michael Schroeder writes,

  > On HP z220 system (firmware version 1.54), some EFI variables are
  > incorrectly named :
  >
  > ls -d /sys/firmware/efi/vars/*8be4d* | grep -v -- -8be returns
  > /sys/firmware/efi/vars/dbxDefault-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
  > /sys/firmware/efi/vars/KEKDefault-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
  > /sys/firmware/efi/vars/SecureBoot-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
  > /sys/firmware/efi/vars/SetupMode-Information8be4df61-93ca-11d2-aa0d-00e098032b8c

Since 'variable_name' is a string, we can validate its size by
searching for the terminating NULL character.

Reported-by: Frederic Crozat <fcrozat-IBi9RG/b67k@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Michael Schroeder <mls-IBi9RG/b67k@public.gmane.org>
Cc: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
Cc: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efivars.c | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 7320bf8..b5af292 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -1653,6 +1653,33 @@ static bool variable_is_present(efi_char16_t *variable_name, efi_guid_t *vendor)
 	return found;
 }
 
+/*
+ * Sanity check string length of a variable name.
+ */
+static unsigned long sanity_check_strlen(efi_char16_t *variable_name,
+					 unsigned long variable_name_size)
+{
+	efi_char16_t c;
+	unsigned long len;
+
+	/*
+	 * The variable name is, by definition, a NULL-terminated
+	 * string, so make absolutely sure that variable_name_size is
+	 * the value we expect it to be. If not, use whichever size is
+	 * smaller.
+	 */
+	for (len = 1; len <= variable_name_size; len++) {
+		c = variable_name[len - 1];
+		if (!c)
+			break;
+	}
+
+	if (len != variable_name_size)
+		printk(KERN_WARNING "efivars: bogus variable_name_size\n");
+
+	return min(len, variable_name_size);
+}
+
 static void efivar_update_sysfs_entries(struct work_struct *work)
 {
 	struct efivars *efivars = &__efivars;
@@ -1693,10 +1720,13 @@ static void efivar_update_sysfs_entries(struct work_struct *work)
 		if (!found) {
 			kfree(variable_name);
 			break;
-		} else
+		} else {
+			variable_name_size = sanity_check_strlen(variable_name,
+								 variable_name_size);
 			efivar_create_sysfs_entry(efivars,
 						  variable_name_size,
 						  variable_name, &vendor);
+		}
 	}
 }
 
@@ -1941,8 +1971,11 @@ int register_efivars(struct efivars *efivars,
 		status = ops->get_next_variable(&variable_name_size,
 						variable_name,
 						&vendor_guid);
+
 		switch (status) {
 		case EFI_SUCCESS:
+			variable_name_size = sanity_check_strlen(variable_name,
+								 variable_name_size);
 			efivar_create_sysfs_entry(efivars,
 						  variable_name_size,
 						  variable_name,
-- 
1.7.11.7
