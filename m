From: Anton Vorontsov <cbouatmailru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: EFI pstore: BUG: scheduling while atomic, and possible circular
 locking dependency
Date: Thu, 22 Nov 2012 02:07:19 -0800
Message-ID: <20121122100719.GA1687@lizard>
References: <50AD94A4.4030100@redhat.com>
 <20121122041239.GA24623@lizard.sbx14280.paloaca.wayport.net>
 <50ADD509.2060800@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <50ADD509.2060800-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Nov 22, 2012 at 03:32:25PM +0800, Lingzhu Xiang wrote:
[...]
> efi_pstore_read stops trying to kmalloc(GFP_KERNEL), but some others still do.
> 
> [   38.185217] BUG: sleeping function called from invalid context at mm/slub.c:930
> [   38.186584] in_atomic(): 1, irqs_disabled(): 0, pid: 852, name: mount
> [   38.187749] 3 locks held by mount/852:
> [   38.188457]  #0:  (&type->s_umount_key#38/1){+.+.+.}, at: [<ffffffff811d0cce>] sget+0x3ae/0x670
> [   38.190208]  #1:  (&psinfo->read_mutex){+.+.+.}, at: [<ffffffff812c060b>] pstore_get_records+0x3b/0x130
> [   38.191956]  #2:  (&(&efivars->lock)->rlock){+.+.+.}, at: [<ffffffff8154e55d>] efi_pstore_open+0x1d/0x40

Ugh. It really should not leave spinlocks locked after returning from
open(). That's because pstore itself does sleeping stuff after ->open().

So, I guess efivars's pstore part needs a complete rework.

In it current design, the read routine has to use rcu lock-less technique,
and we need a really ugly hack in the sysfs routine to make write actually
work. This is because the efi's sysfs routine is responsible for adding
variables to a list, not just for adding variables to sysfs hierarchy.

The down below is a patch to give an idea. It might happen to work on
adding and reading the dumps, but it surely won't work on removing things.
I didn't test it.

Anyway, it's not pstore's core issue, it's purely EFI which makes things
messy, so EFI maintainers will need to continue this, as I really have no
time currently.


diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index d10c987..7327a6d 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -144,7 +144,8 @@ static int
 efivar_create_sysfs_entry(struct efivars *efivars,
 			  unsigned long variable_name_size,
 			  efi_char16_t *variable_name,
-			  efi_guid_t *vendor_guid);
+			  efi_guid_t *vendor_guid,
+			  gfp_t gfp);
 
 /* Return the number of unicode characters in data */
 static unsigned long
@@ -643,17 +644,20 @@ static int efi_pstore_open(struct pstore_info *psi)
 {
 	struct efivars *efivars = psi->data;
 
-	spin_lock(&efivars->lock);
-	efivars->walk_entry = list_first_entry(&efivars->list,
-					       struct efivar_entry, list);
+	rcu_read_lock();
+	efivars->walk_entry = list_first_or_null_rcu(&efivars->list,
+						     struct efivar_entry,
+						     list);
+	if (!efivars->walk_entry) {
+		rcu_read_unlock();
+		return -ENODATA;
+	}
 	return 0;
 }
 
 static int efi_pstore_close(struct pstore_info *psi)
 {
-	struct efivars *efivars = psi->data;
-
-	spin_unlock(&efivars->lock);
+	rcu_read_unlock();
 	return 0;
 }
 
@@ -661,38 +665,43 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 			       struct timespec *timespec,
 			       char **buf, struct pstore_info *psi)
 {
-	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
 	struct efivars *efivars = psi->data;
-	char name[DUMP_NAME_LEN];
-	int i;
-	unsigned int part, size;
-	unsigned long time;
-
-	while (&efivars->walk_entry->list != &efivars->list) {
-		if (!efi_guidcmp(efivars->walk_entry->var.VendorGuid,
-				 vendor)) {
-			for (i = 0; i < DUMP_NAME_LEN; i++) {
-				name[i] = efivars->walk_entry->var.VariableName[i];
-			}
-			if (sscanf(name, "dump-type%u-%u-%lu", type, &part, &time) == 3) {
-				*id = part;
-				timespec->tv_sec = time;
-				timespec->tv_nsec = 0;
-				get_var_data_locked(efivars, &efivars->walk_entry->var);
-				size = efivars->walk_entry->var.DataSize;
-				*buf = kmalloc(size, GFP_KERNEL);
-				if (*buf == NULL)
-					return -ENOMEM;
-				memcpy(*buf, efivars->walk_entry->var.Data,
-				       size);
-				efivars->walk_entry = list_entry(efivars->walk_entry->list.next,
-					           struct efivar_entry, list);
-				return size;
-			}
-		}
-		efivars->walk_entry = list_entry(efivars->walk_entry->list.next,
-						 struct efivar_entry, list);
+	struct efivar_entry *entry = efivars->walk_entry;
+
+	list_for_each_entry_continue_rcu(entry, &efivars->list, list) {
+		efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
+		char name[DUMP_NAME_LEN];
+		int i;
+		unsigned int part;
+		unsigned int size;
+		unsigned long time;
+
+		if (efi_guidcmp(entry->var.VendorGuid, vendor))
+			continue;
+
+		for (i = 0; i < DUMP_NAME_LEN; i++)
+			name[i] = entry->var.VariableName[i];
+
+		if (sscanf(name, "dump-type%u-%u-%lu", type, &part, &time) != 3)
+			continue;
+
+		*id = part;
+		timespec->tv_sec = time;
+		timespec->tv_nsec = 0;
+
+		get_var_data_locked(efivars, &entry->var);
+		size = entry->var.DataSize;
+		if (!size)
+			return -ENODATA;
+
+		*buf = kmalloc(size, GFP_KERNEL);
+		if (!*buf)
+			return -ENOMEM;
+
+		memcpy(*buf, entry->var.Data, size);
+		return size;
 	}
+
 	return 0;
 }
 
@@ -741,7 +750,7 @@ static int efi_pstore_write(enum pstore_type_id type,
 	}
 
 	if (found)
-		list_del(&found->list);
+		list_del_rcu(&found->list);
 
 	for (i = 0; i < DUMP_NAME_LEN; i++)
 		efi_name[i] = name[i];
@@ -753,12 +762,11 @@ static int efi_pstore_write(enum pstore_type_id type,
 
 	if (found)
 		efivar_unregister(found);
-
 	if (size)
 		ret = efivar_create_sysfs_entry(efivars,
 					  utf16_strsize(efi_name,
 							DUMP_NAME_LEN * 2),
-					  efi_name, &vendor);
+					  efi_name, &vendor, GFP_ATOMIC);
 
 	*id = part;
 	return ret;
@@ -875,7 +883,8 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 					   utf16_strsize(new_var->VariableName,
 							 1024),
 					   new_var->VariableName,
-					   &new_var->VendorGuid);
+					   &new_var->VendorGuid,
+					   GFP_KERNEL);
 	if (status) {
 		printk(KERN_WARNING "efivars: variable created, but sysfs entry wasn't.\n");
 	}
@@ -933,7 +942,7 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 		spin_unlock(&efivars->lock);
 		return -EIO;
 	}
-	list_del(&search_efivar->list);
+	list_del_rcu(&search_efivar->list);
 	/* We need to release this lock before unregistering. */
 	spin_unlock(&efivars->lock);
 	efivar_unregister(search_efivar);
@@ -999,14 +1008,15 @@ static int
 efivar_create_sysfs_entry(struct efivars *efivars,
 			  unsigned long variable_name_size,
 			  efi_char16_t *variable_name,
-			  efi_guid_t *vendor_guid)
+			  efi_guid_t *vendor_guid,
+			  gfp_t gfp)
 {
 	int i, short_name_size = variable_name_size / sizeof(efi_char16_t) + 38;
 	char *short_name;
 	struct efivar_entry *new_efivar;
 
-	short_name = kzalloc(short_name_size + 1, GFP_KERNEL);
-	new_efivar = kzalloc(sizeof(struct efivar_entry), GFP_KERNEL);
+	short_name = kzalloc(short_name_size + 1, gfp);
+	new_efivar = kzalloc(sizeof(struct efivar_entry), gfp);
 
 	if (!short_name || !new_efivar)  {
 		kfree(short_name);
@@ -1018,6 +1028,8 @@ efivar_create_sysfs_entry(struct efivars *efivars,
 	memcpy(new_efivar->var.VariableName, variable_name,
 		variable_name_size);
 	memcpy(&(new_efivar->var.VendorGuid), vendor_guid, sizeof(efi_guid_t));
+	if (gfp == GFP_ATOMIC)
+		goto just_add;
 
 	/* Convert Unicode to normal chars (assume top bits are 0),
 	   ala UTF-8 */
@@ -1040,11 +1052,12 @@ efivar_create_sysfs_entry(struct efivars *efivars,
 	}
 
 	kobject_uevent(&new_efivar->kobj, KOBJ_ADD);
+just_add:
 	kfree(short_name);
 	short_name = NULL;
 
 	spin_lock(&efivars->lock);
-	list_add(&new_efivar->list, &efivars->list);
+	list_add_tail_rcu(&new_efivar->list, &efivars->list);
 	spin_unlock(&efivars->lock);
 
 	return 0;
@@ -1115,7 +1128,7 @@ void unregister_efivars(struct efivars *efivars)
 
 	list_for_each_entry_safe(entry, n, &efivars->list, list) {
 		spin_lock(&efivars->lock);
-		list_del(&entry->list);
+		list_del_rcu(&entry->list);
 		spin_unlock(&efivars->lock);
 		efivar_unregister(entry);
 	}
@@ -1172,7 +1185,8 @@ int register_efivars(struct efivars *efivars,
 			efivar_create_sysfs_entry(efivars,
 						  variable_name_size,
 						  variable_name,
-						  &vendor_guid);
+						  &vendor_guid,
+						  GFP_KERNEL);
 			break;
 		case EFI_NOT_FOUND:
 			break;
