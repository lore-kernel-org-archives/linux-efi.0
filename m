From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH v2 03/20] efi: add efivars kobject to efi sysfs folder
Date: Fri, 02 Nov 2012 08:53:47 +0000
Message-ID: <1351846427.14888.156.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org>
	 <1351237923-10313-4-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351237923-10313-4-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

UEFI variable filesystem need a new mount point, so this patch add
efivars kobject to efi_kobj for create a /sys/firmware/efi/efivars
folder.

Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
Signed-off-by: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

v2: Address comments from Alan Cox where efivars->kset was unregistered
    in the success path, not the error path.

 drivers/firmware/efivars.c | 9 +++++++++
 include/linux/efi.h        | 1 +
 2 files changed, 10 insertions(+)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index d7658b4..6793965 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -1527,6 +1527,7 @@ void unregister_efivars(struct efivars *efivars)
 		sysfs_remove_bin_file(&efivars->kset->kobj, efivars->del_var);
 	kfree(efivars->new_var);
 	kfree(efivars->del_var);
+	kobject_put(efivars->kobject);
 	kset_unregister(efivars->kset);
 }
 EXPORT_SYMBOL_GPL(unregister_efivars);
@@ -1558,6 +1559,14 @@ int register_efivars(struct efivars *efivars,
 		goto out;
 	}
 
+	efivars->kobject = kobject_create_and_add("efivars", parent_kobj);
+	if (!efivars->kobject) {
+		pr_err("efivars: Subsystem registration failed.\n");
+		error = -ENOMEM;
+		kset_unregister(efivars->kset);
+		goto out;
+	}
+
 	/*
 	 * Per EFI spec, the maximum storage allocated for both
 	 * the variable name and variable data is 1024 bytes.
diff --git a/include/linux/efi.h b/include/linux/efi.h
index b2af157..337aefb 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -662,6 +662,7 @@ struct efivars {
 	spinlock_t lock;
 	struct list_head list;
 	struct kset *kset;
+	struct kobject *kobject;
 	struct bin_attribute *new_var, *del_var;
 	const struct efivar_operations *ops;
 	struct efivar_entry *walk_entry;
-- 
1.7.11.7
