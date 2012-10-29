From: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] efi: fix always unregister kset of efivars in register_efivars
Date: Mon, 29 Oct 2012 14:52:56 +0800
Message-ID: <1351493576-3094-1-git-send-email-jlee@suse.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The cc9c97b76aa7235d5a1de0f74f990097f77008b4 patch introduced a
issue that always unregister kset of efivars in register_efivars.

This patch moved the kset_unregister function call to the kobject create check
block for fix issue.

Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
---
 drivers/firmware/efivars.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 03e0df2..8870907 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -1595,7 +1595,8 @@ int register_efivars(struct efivars *efivars,
 	if (!efivars->kobject) {
 		pr_err("efivars: Subsystem registration failed.\n");
 		error = -ENOMEM;
-		goto err_unreg_vars;
+		kset_unregister(efivars->kset);
+		goto out;
 	}
 
 	/*
@@ -1642,9 +1643,6 @@ int register_efivars(struct efivars *efivars,
 
 	register_filesystem(&efivarfs_type);
 
-err_unreg_vars:
-	kset_unregister(efivars->kset);
-
 out:
 	kfree(variable_name);
 
-- 
1.6.0.2
