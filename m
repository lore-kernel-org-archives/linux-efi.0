From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [RFC][PATCH 1/7] efivars: Keep a private global pointer to efivars
Date: Fri,  8 Feb 2013 20:59:12 +0000
Message-ID: <1360357158-8168-2-git-send-email-matt@console-pimps.org>
References: <1360357158-8168-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1360357158-8168-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This may seem like a step backwards in terms of modularity, but we
don't need to track more than one 'struct efivars' at one time. There
is no synchronisation done between multiple EFI variable operations,
and according to Mike no one is using both the generic EFI var ops and
CONFIG_GOOGLE_SMI.

Make this explicit by returning -EBUSY if someone has already called
register_efivars().

Cc: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efivars.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 5eafa22..24585c3 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -132,8 +132,11 @@ struct efivar_attribute {
 	ssize_t (*store)(struct efivar_entry *entry, const char *buf, size_t count);
 };
 
-static struct efivars __efivars;
-static struct efivar_operations ops;
+static struct efivars generic_efivars;
+static struct efivar_operations generic_ops;
+
+/* Private pointer to registered efivars */
+static struct efivars *__efivars;
 
 #define PSTORE_EFI_ATTRIBUTES \
 	(EFI_VARIABLE_NON_VOLATILE | \
@@ -974,7 +977,7 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
 			  umode_t mode, bool excl)
 {
 	struct inode *inode;
-	struct efivars *efivars = &__efivars;
+	struct efivars *efivars = __efivars;
 	struct efivar_entry *var;
 	int namelen, i = 0, err = 0;
 
@@ -1140,7 +1143,7 @@ static int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 	struct inode *inode = NULL;
 	struct dentry *root;
 	struct efivar_entry *entry, *n;
-	struct efivars *efivars = &__efivars;
+	struct efivars *efivars = __efivars;
 	char *name;
 
 	efivarfs_sb = sb;
@@ -1835,6 +1838,12 @@ int register_efivars(struct efivars *efivars,
 	unsigned long variable_name_size = 1024;
 	int error = 0;
 
+	if (__efivars) {
+		return -EBUSY;
+	}
+
+	__efivars = efivars;
+
 	variable_name = kzalloc(variable_name_size, GFP_KERNEL);
 	if (!variable_name) {
 		printk(KERN_ERR "efivars: Memory allocation failed.\n");
@@ -1937,12 +1946,12 @@ efivars_init(void)
 		return -ENOMEM;
 	}
 
-	ops.get_variable = efi.get_variable;
-	ops.set_variable = efi.set_variable;
-	ops.get_next_variable = efi.get_next_variable;
-	ops.query_variable_info = efi.query_variable_info;
+	generic_ops.get_variable = efi.get_variable;
+	generic_ops.set_variable = efi.set_variable;
+	generic_ops.get_next_variable = efi.get_next_variable;
+	generic_ops.query_variable_info = efi.query_variable_info;
 
-	error = register_efivars(&__efivars, &ops, efi_kobj);
+	error = register_efivars(&generic_efivars, &generic_ops, efi_kobj);
 	if (error)
 		goto err_put;
 
@@ -1958,7 +1967,7 @@ efivars_init(void)
 	return 0;
 
 err_unregister:
-	unregister_efivars(&__efivars);
+	unregister_efivars(&generic_efivars);
 err_put:
 	kobject_put(efi_kobj);
 	return error;
@@ -1968,7 +1977,7 @@ static void __exit
 efivars_exit(void)
 {
 	if (efi_enabled(EFI_RUNTIME_SERVICES)) {
-		unregister_efivars(&__efivars);
+		unregister_efivars(&generic_efivars);
 		kobject_put(efi_kobj);
 	}
 }
-- 
1.7.11.7
