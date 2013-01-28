From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [RFC,PATCH] efivarfs: Don't delete efivar_entry structures on
 unlink
Date: Mon, 28 Jan 2013 16:45:39 +0000
Message-ID: <1359391539.8282.28.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1359240720.964087.170020751085.1.gpush@pororo>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359240720.964087.170020751085.1.gpush@pororo>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Anton Vorontsov <cbouatmailru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

(Including the pstore folks and quoting in full)

On Sun, 2013-01-27 at 06:52 +0800, Jeremy Kerr wrote:
> We can cause an oops by unlinking an open efivarfs file, then reading
> (or writing) from the deleted file. The unlink operation causes the
> efivarfs_entry struct to be freed, which is referenced again in the
> read.
> 
> This change allow the efivar_entry structures to remain present after
> the variable has been removed, but flagged as not present in firmware by
> way of having an empty ->list member. We keep a refcount to determine
> when the entry can actually be freed.
> 
> Signed-off-by: Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>
> 
> ---
>  drivers/firmware/efivars.c |  105 +++++++++++++++++++++++++++++++------
>  1 file changed, 89 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> index 053f28b..764f548 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -121,6 +121,15 @@ struct efi_variable {
>  struct efivar_entry {
>  	struct efivars *efivars;
>  	struct efi_variable var;
> +
> +	/* references to the kref are held by:
> +	 *  - open efivarfs files
> +	 *  - efivarfs inodes
> +	 *  - the kobj
> +	 *  - presence in the global efivar list
> +	 */
> +	struct kref kref;
> +
>  	struct list_head list;
>  	struct kobject kobj;
>  };
> @@ -147,7 +156,8 @@ struct efivar_attribute efivar_attr_##_name = { \
>  };
>  
>  #define to_efivar_attr(_attr) container_of(_attr, struct efivar_attribute, attr)
> -#define to_efivar_entry(obj)  container_of(obj, struct efivar_entry, kobj)
> +#define kobj_to_efivar_entry(obj)  container_of(obj, struct efivar_entry, kobj)
> +#define kref_to_efivar_entry(obj)  container_of(obj, struct efivar_entry, kref)
>  
>  /*
>   * Prototype for sysfs creation function
> @@ -580,7 +590,7 @@ efivar_show_raw(struct efivar_entry *entry, char *buf)
>  static ssize_t efivar_attr_show(struct kobject *kobj, struct attribute *attr,
>  				char *buf)
>  {
> -	struct efivar_entry *var = to_efivar_entry(kobj);
> +	struct efivar_entry *var = kobj_to_efivar_entry(kobj);
>  	struct efivar_attribute *efivar_attr = to_efivar_attr(attr);
>  	ssize_t ret = -EIO;
>  
> @@ -596,7 +606,7 @@ static ssize_t efivar_attr_show(struct kobject *kobj, struct attribute *attr,
>  static ssize_t efivar_attr_store(struct kobject *kobj, struct attribute *attr,
>  				const char *buf, size_t count)
>  {
> -	struct efivar_entry *var = to_efivar_entry(kobj);
> +	struct efivar_entry *var = kobj_to_efivar_entry(kobj);
>  	struct efivar_attribute *efivar_attr = to_efivar_attr(attr);
>  	ssize_t ret = -EIO;
>  
> @@ -614,12 +624,28 @@ static const struct sysfs_ops efivar_attr_ops = {
>  	.store = efivar_attr_store,
>  };
>  
> -static void efivar_release(struct kobject *kobj)
> +static void efivar_entry_release(struct kref *kref)
>  {
> -	struct efivar_entry *var = container_of(kobj, struct efivar_entry, kobj);
> +	struct efivar_entry *var = kref_to_efivar_entry(kref);
>  	kfree(var);
>  }
>  
> +static void efivar_entry_put(struct efivar_entry *entry)
> +{
> +	kref_put(&entry->kref, efivar_entry_release);
> +}
> +
> +static void efivar_entry_get(struct efivar_entry *entry)
> +{
> +	kref_get(&entry->kref);
> +}
> +
> +static void efivar_release(struct kobject *kobj)
> +{
> +	struct efivar_entry *var = kobj_to_efivar_entry(kobj);
> +	efivar_entry_put(var);
> +}
> +
>  static EFIVAR_ATTR(guid, 0400, efivar_guid_read, NULL);
>  static EFIVAR_ATTR(attributes, 0400, efivar_attr_read, NULL);
>  static EFIVAR_ATTR(size, 0400, efivar_size_read, NULL);
> @@ -647,9 +673,22 @@ efivar_unregister(struct efivar_entry *var)
>  	kobject_put(&var->kobj);
>  }
>  
> +static bool efivar_is_present(struct efivar_entry *entry)
> +{
> +	bool present;
> +
> +	spin_lock(&entry->efivars->lock);
> +	present = !list_empty(&entry->list);
> +	spin_unlock(&entry->efivars->lock);
> +
> +	return present;
> +}
> +
>  static int efivarfs_file_open(struct inode *inode, struct file *file)
>  {
> -	file->private_data = inode->i_private;
> +	struct efivar_entry *entry = inode->i_private;
> +	file->private_data = entry;
> +	efivar_entry_get(entry);
>  	return 0;
>  }

Isn't there a race here? Can't the efivar_entry be deleted and freed
before we call efivar_get_entry()?

The problem is you need to be able to ensure the validity of
inode->i_private, but you can't in the open() function if you haven't
already taken a reference to the variable. A ref count of some
description needs to be incremented in efivarfs_fill_super() before the
efivar_entry pointer is stored in the inode, and while we're holding the
lock.

> @@ -706,6 +745,15 @@ static ssize_t efivarfs_file_write(struct file *file,
>  	if (attributes & ~(EFI_VARIABLE_MASK))
>  		return -EINVAL;
>  
> +	/*
> +	 * It's possible that the variable has been removed from firmware
> +	 * since the open(), in which case we need to flag an error
> +	 * TODO: allow writes that would reinstate the variable, but check
> +	 * against duplicate variables...
> +	 */
> +	if (!efivar_is_present(var))
> +		return -EIO;
> +
>  	efivars = var->efivars;
>  
>  	/*
> @@ -789,9 +837,10 @@ static ssize_t efivarfs_file_write(struct file *file,
>  		mutex_unlock(&inode->i_mutex);
>  
>  	} else if (status == EFI_NOT_FOUND) {
> -		list_del(&var->list);
> +		list_del_init(&var->list);
>  		spin_unlock(&efivars->lock);
>  		efivar_unregister(var);
> +		efivar_entry_put(var);
>  		drop_nlink(inode);
>  		d_delete(file->f_dentry);
>  		dput(file->f_dentry);
> @@ -819,6 +868,13 @@ static ssize_t efivarfs_file_read(struct file *file, char __user *userbuf,
>  	void *data;
>  	ssize_t size = 0;
>  
> +	/*
> +	 * It's possible that the variable has been removed from firmware
> +	 * since the open(), in which case we need to flag an error.
> +	 */
> +	if (!efivar_is_present(var))
> +		return -EIO;
> +
>  	spin_lock(&efivars->lock);
>  	status = efivars->ops->get_variable(var->var.VariableName,
>  					    &var->var.VendorGuid,
> @@ -854,8 +910,15 @@ out_free:
>  	return size;
>  }
>  
> +static int efivarfs_file_release(struct inode *inode, struct file *file)
> +{
> +	efivar_entry_put(file->private_data);
> +	return 0;
> +}
> +
>  static void efivarfs_evict_inode(struct inode *inode)
>  {
> +	efivar_entry_put(inode->i_private);
>  	clear_inode(inode);
>  }
>  
> @@ -871,10 +934,11 @@ static struct super_block *efivarfs_sb;
>  static const struct inode_operations efivarfs_dir_inode_operations;
>  
>  static const struct file_operations efivarfs_file_operations = {
> -	.open	= efivarfs_file_open,
> -	.read	= efivarfs_file_read,
> -	.write	= efivarfs_file_write,
> -	.llseek	= no_llseek,
> +	.open    = efivarfs_file_open,
> +	.read    = efivarfs_file_read,
> +	.write   = efivarfs_file_write,
> +	.release = efivarfs_file_release,
> +	.llseek  = no_llseek,
>  };
>  
>  static struct inode *efivarfs_get_inode(struct super_block *sb,
> @@ -946,6 +1010,8 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
>  		goto out;
>  	}
>  
> +	kref_init(&var->kref);
> +
>  	/* length of the variable name itself: remove GUID and separator */
>  	namelen = dentry->d_name.len - GUID_LEN - 1;
>  
> @@ -969,6 +1035,7 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
>  	kobject_uevent(&var->kobj, KOBJ_ADD);
>  	spin_lock(&efivars->lock);
>  	list_add(&var->list, &efivars->list);
> +	efivar_entry_get(var);
>  	spin_unlock(&efivars->lock);
>  	d_instantiate(dentry, inode);
>  	dget(dentry);
> @@ -993,9 +1060,10 @@ static int efivarfs_unlink(struct inode *dir, struct dentry *dentry)
>  					    0, 0, NULL);
>  
>  	if (status == EFI_SUCCESS || status == EFI_NOT_FOUND) {
> -		list_del(&var->list);
> +		list_del_init(&var->list);
>  		spin_unlock(&efivars->lock);
>  		efivar_unregister(var);
> +		efivar_entry_put(var);
>  		drop_nlink(dentry->d_inode);
>  		dput(dentry);
>  		return 0;
> @@ -1077,6 +1145,7 @@ int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
>  
>  		mutex_lock(&inode->i_mutex);
>  		inode->i_private = entry;
> +		efivar_entry_get(entry);
>  		i_size_write(inode, size+4);
>  		mutex_unlock(&inode->i_mutex);
>  		d_add(dentry, inode);
> @@ -1221,8 +1290,10 @@ static int efi_pstore_write(enum pstore_type_id type,
>  					   0, NULL);
>  	}
>  
> -	if (found)
> -		list_del(&found->list);
> +	if (found) {
> +		list_del_init(&found->list);
> +		efivar_entry_put(found);
> +	}
>  
>  	for (i = 0; i < DUMP_NAME_LEN; i++)
>  		efi_name[i] = name[i];
> @@ -1414,7 +1485,7 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
>  		spin_unlock(&efivars->lock);
>  		return -EIO;
>  	}
> -	list_del(&search_efivar->list);
> +	list_del_init(&search_efivar->list);
>  	/* We need to release this lock before unregistering. */
>  	spin_unlock(&efivars->lock);
>  	efivar_unregister(search_efivar);
> @@ -1533,6 +1604,7 @@ efivar_create_sysfs_entry(struct efivars *efivars,
>  
>  	spin_lock(&efivars->lock);
>  	list_add(&new_efivar->list, &efivars->list);
> +	efivar_entry_get(new_efivar);
>  	spin_unlock(&efivars->lock);
>  
>  	return 0;
> @@ -1603,8 +1675,9 @@ void unregister_efivars(struct efivars *efivars)
>  
>  	list_for_each_entry_safe(entry, n, &efivars->list, list) {
>  		spin_lock(&efivars->lock);
> -		list_del(&entry->list);
> +		list_del_init(&entry->list);
>  		spin_unlock(&efivars->lock);
> +		efivar_entry_put(entry);
>  		efivar_unregister(entry);
>  	}
>  	if (efivars->new_var)


-- 
Matt Fleming, Intel Open Source Technology Center
