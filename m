From: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] efivarfs: fix abnormal GUID in variable name by using strcpy to replace null with dash
Date: Fri,  1 Mar 2013 11:20:18 +0800
Message-ID: <1362108018-13117-1-git-send-email-jlee@suse.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Schroeder <mls-IBi9RG/b67k@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Michael Schroeder <mls-IBi9RG/b67k@public.gmane.org>

On HP z220 system (firmware version 1.54), some EFI variables are incorrectly
named :

ls -d /sys/firmware/efi/vars/*8be4d* | grep -v -- -8be returns
/sys/firmware/efi/vars/dbxDefault-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
/sys/firmware/efi/vars/KEKDefault-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
/sys/firmware/efi/vars/SecureBoot-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
/sys/firmware/efi/vars/SetupMode-Information8be4df61-93ca-11d2-aa0d-00e098032b8c

That causes by the following statement in efivar_create_sysfs_entry function:

 *(short_name + strlen(short_name)) = '-';
efi_guid_unparse(vendor_guid, short_name + strlen(short_name));

The trailing \0 is overwritten with '-', but the next char doesn't seem to be a \0
as well for HP. So, the second strlen return the point of next '\0', causes there
have garbage string attached before GUID.

Tested on On HP z220.

Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Michael Schroeder <mls-IBi9RG/b67k@public.gmane.org>
Reported-by: Frederic Crozat <fcrozat-IBi9RG/b67k@public.gmane.org>
Tested-by: Frederic Crozat <fcrozat-IBi9RG/b67k@public.gmane.org>
Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
---
 drivers/firmware/efivars.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 8bcb595..fbf18ff 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -1708,7 +1708,7 @@ efivar_create_sysfs_entry(struct efivars *efivars,
 	/* This is ugly, but necessary to separate one vendor's
 	   private variables from another's.         */
 
-	*(short_name + strlen(short_name)) = '-';
+	strcpy(short_name + strlen(short_name), "-");
 	efi_guid_unparse(vendor_guid, short_name + strlen(short_name));
 
 	new_efivar->kobj.kset = efivars->kset;
-- 
1.6.0.2
