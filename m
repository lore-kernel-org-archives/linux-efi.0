From: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/5] efi: Make efivarfs entries immutable by default. (v5)
Date: Fri, 12 Feb 2016 14:36:28 +0100
Message-ID: <56BDDFDC.406@redhat.com>
References: <1454600074-14854-1-git-send-email-pjones@redhat.com>
 <1454600074-14854-6-git-send-email-pjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454600074-14854-6-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: efi kernel list <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 02/04/16 16:34, Peter Jones wrote:
> "rm -rf" is bricking some peoples' laptops because of variables being
> used to store non-reinitializable firmware driver data that's required
> to POST the hardware.
> 
> These are 100% bugs, and they need to be fixed, but in the mean time it
> shouldn't be easy to *accidentally* brick machines.
> 
> We have to have delete working, and picking which variables do and don't
> work for deletion is quite intractable, so instead make everything
> immutable by default (except for a whitelist), and make tools that
> aren't quite so broad-spectrum unset the immutable flag.

I think that the whitelist should include the following pattern
(permitting deletion):
- GUID:                  LINUX_EFI_CRASH_GUID
- variable name pattern: "dump-type*"

This is because the pstore filesystem can be backed by UEFI variables,
and (for example) a crash might dump the last kilobytes of the dmesg
into a number of pstore entries, each entry backed by a separate UEFI
variable in the above GUID namespace, and with a variable name according
to the above pattern.

Please see "drivers/firmware/efi/efi-pstore.c".

While this patch series will not prevent the user from deleting those
UEFI variables via the pstore filesystem (i.e., deleting a pstore fs
entry will continue to delete the backing UEFI variable), I think it
would be nice to preserve the possibility for the sysadmin to delete
Linux-created UEFI variables that carry portions of the crash log,
*without* having to mount the pstore filesystem.

Thanks
Laszlo

> 
> v2: - adds Timeout to our whitelist.
> v3: - takes the extra Timeout out of the whitelist
>     - fixes whitelist matching to actually work
>     - inverts the flag on efivarfs_get_inode() and calls it is_removable
>     - adds documentation and test cases
> v4: - fix a double-free on the end of list traversal
> v5: - fix the inode locking in _setxflags()
>     - use namelen not dentry->d_name.len when we're calling
>       efivar_variable_is_removable() from efivarfs_create()
> 
> Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA-XMD5yJDbdMReXY1tMh2IBg@public.gmane.org>
> Tested-by: Lee, Chun-Yi <jlee-IBi9RG/b67k-XMD5yJDbdMReXY1tMh2IBg@public.gmane.org>
> Acked-by: Matthew Garrett <mjg59-JW9irJGTvgXQT0dZR+AlfA-XMD5yJDbdMReXY1tMh2IBg@public.gmane.org>
> ---
>  Documentation/filesystems/efivarfs.txt         |  7 ++
>  drivers/firmware/efi/vars.c                    | 88 +++++++++++++++++++-------
>  fs/efivarfs/file.c                             | 70 ++++++++++++++++++++
>  fs/efivarfs/inode.c                            | 30 +++++----
>  fs/efivarfs/internal.h                         |  3 +-
>  fs/efivarfs/super.c                            |  9 ++-
>  include/linux/efi.h                            |  2 +
>  tools/testing/selftests/efivarfs/efivarfs.sh   | 19 +++++-
>  tools/testing/selftests/efivarfs/open-unlink.c | 72 ++++++++++++++++++++-
>  9 files changed, 259 insertions(+), 41 deletions(-)
> 
> diff --git a/Documentation/filesystems/efivarfs.txt b/Documentation/filesystems/efivarfs.txt
> index c477af0..686a64b 100644
> --- a/Documentation/filesystems/efivarfs.txt
> +++ b/Documentation/filesystems/efivarfs.txt
> @@ -14,3 +14,10 @@ filesystem.
>  efivarfs is typically mounted like this,
>  
>  	mount -t efivarfs none /sys/firmware/efi/efivars
> +
> +Due to the presence of numerous firmware bugs where removing non-standard
> +UEFI variables causes the system firmware to fail to POST, efivarfs
> +files that are not well-known standardized variables are created
> +as immutable files.  This doesn't prevent removal - "chattr -i" will work -
> +but it does prevent this kind of failure from being accomplished
> +accidentally.
> diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
> index 0fc9194..721194e 100644
> --- a/drivers/firmware/efi/vars.c
> +++ b/drivers/firmware/efi/vars.c
> @@ -172,10 +172,12 @@ struct variable_validate {
>  };
>  
>  /*
> - * This is the list of variables we need to validate.
> + * This is the list of variables we need to validate, as well as the
> + * whitelist for what we think is safe not to default to immutable.
>   *
>   * If it has a validate() method that's not NULL, it'll go into the
> - * validation routine.  If not, it is assumed valid.
> + * validation routine.  If not, it is assumed valid, but still used for
> + * whitelisting.
>   *
>   * Note that it's sorted by {vendor,name}, but globbed names must come after
>   * any other name with the same prefix.
> @@ -193,11 +195,37 @@ static const struct variable_validate variable_validate[] = {
>  	{ EFI_GLOBAL_VARIABLE_GUID, "ErrOut", validate_device_path },
>  	{ EFI_GLOBAL_VARIABLE_GUID, "ErrOutDev", validate_device_path },
>  	{ EFI_GLOBAL_VARIABLE_GUID, "Lang", validate_ascii_string },
> +	{ EFI_GLOBAL_VARIABLE_GUID, "OsIndications", NULL },
>  	{ EFI_GLOBAL_VARIABLE_GUID, "PlatformLang", validate_ascii_string },
>  	{ EFI_GLOBAL_VARIABLE_GUID, "Timeout", validate_uint16 },
>  	{ NULL_GUID, "", NULL },
>  };
>  
> +static bool
> +variable_matches(const char *var_name, size_t len, const char *match_name,
> +		 int *match)
> +{
> +	for (*match = 0; ; (*match)++) {
> +		char c = match_name[*match];
> +		char u = var_name[*match];
> +
> +		/* Wildcard in the matching name means we've matched */
> +		if (c == '*')
> +			return true;
> +
> +		/* Case sensitive match */
> +		if (!c && *match == len)
> +			return true;
> +
> +		if (c != u)
> +			return false;
> +
> +		if (!c)
> +			return true;
> +	}
> +	return true;
> +}
> +
>  bool
>  efivar_validate(efi_guid_t vendor, efi_char16_t *var_name, u8 *data,
>  		unsigned long len)
> @@ -220,35 +248,49 @@ efivar_validate(efi_guid_t vendor, efi_char16_t *var_name, u8 *data,
>  		if (efi_guidcmp(vendor, variable_validate[i].vendor))
>  			continue;
>  
> -		for (match = 0; ; match++) {
> -			char c = name[match];
> -			char u = utf8_name[match];
> -
> -			/* Wildcard in the matching name means we've matched */
> -			if (c == '*') {
> -				kfree(utf8_name);
> -				return variable_validate[i].validate(var_name,
> -							     match, data, len);
> -			}
> -
> -			/* Case sensitive match */
> -			if (c != u)
> +		if (variable_matches(utf8_name, utf8_size+1, name, &match)) {
> +			if (variable_validate[i].validate == NULL)
>  				break;
> -
> -			/* Reached the end of the string while matching */
> -			if (!c) {
> -				kfree(utf8_name);
> -				return variable_validate[i].validate(var_name,
> -							     match, data, len);
> -			}
> +			kfree(utf8_name);
> +			return variable_validate[i].validate(var_name, match,
> +							     data, len);
>  		}
>  	}
> -
>  	kfree(utf8_name);
>  	return true;
>  }
>  EXPORT_SYMBOL_GPL(efivar_validate);
>  
> +bool
> +efivar_variable_is_removable(efi_guid_t vendor, const char *var_name,
> +			     size_t len)
> +{
> +	int i;
> +	bool found = false;
> +	int match = 0;
> +
> +	/*
> +	 * Now check the validated variables list and then the whitelist -
> +	 * both are whitelists
> +	 */
> +	for (i = 0; variable_validate[i].name[0] != '\0'; i++) {
> +		if (efi_guidcmp(variable_validate[i].vendor, vendor))
> +			continue;
> +
> +		if (variable_matches(var_name, len,
> +				     variable_validate[i].name, &match)) {
> +			found = true;
> +			break;
> +		}
> +	}
> +
> +	/*
> +	 * If we found it in our list, it /isn't/ one of our protected names.
> +	 */
> +	return found;
> +}
> +EXPORT_SYMBOL_GPL(efivar_variable_is_removable);
> +
>  static efi_status_t
>  check_var_size(u32 attributes, unsigned long size)
>  {
> diff --git a/fs/efivarfs/file.c b/fs/efivarfs/file.c
> index c424e48..d48e0d2 100644
> --- a/fs/efivarfs/file.c
> +++ b/fs/efivarfs/file.c
> @@ -10,6 +10,7 @@
>  #include <linux/efi.h>
>  #include <linux/fs.h>
>  #include <linux/slab.h>
> +#include <linux/mount.h>
>  
>  #include "internal.h"
>  
> @@ -103,9 +104,78 @@ out_free:
>  	return size;
>  }
>  
> +static int
> +efivarfs_ioc_getxflags(struct file *file, void __user *arg)
> +{
> +	struct inode *inode = file->f_mapping->host;
> +	unsigned int i_flags;
> +	unsigned int flags = 0;
> +
> +	i_flags = inode->i_flags;
> +	if (i_flags & S_IMMUTABLE)
> +		flags |= FS_IMMUTABLE_FL;
> +
> +	if (copy_to_user(arg, &flags, sizeof(flags)))
> +		return -EFAULT;
> +	return 0;
> +}
> +
> +static int
> +efivarfs_ioc_setxflags(struct file *file, void __user *arg)
> +{
> +	struct inode *inode = file->f_mapping->host;
> +	unsigned int flags;
> +	unsigned int i_flags = 0;
> +	int error;
> +
> +	if (!inode_owner_or_capable(inode))
> +		return -EACCES;
> +
> +	if (copy_from_user(&flags, arg, sizeof(flags)))
> +		return -EFAULT;
> +
> +	if (flags & ~FS_IMMUTABLE_FL)
> +		return -EOPNOTSUPP;
> +
> +	if (!capable(CAP_LINUX_IMMUTABLE))
> +		return -EPERM;
> +
> +	if (flags & FS_IMMUTABLE_FL)
> +		i_flags |= S_IMMUTABLE;
> +
> +
> +	error = mnt_want_write_file(file);
> +	if (error)
> +		return error;
> +
> +	inode_lock(inode);
> +	inode_set_flags(inode, i_flags, S_IMMUTABLE);
> +	inode_unlock(inode);
> +
> +	mnt_drop_write_file(file);
> +
> +	return 0;
> +}
> +
> +long
> +efivarfs_file_ioctl(struct file *file, unsigned int cmd, unsigned long p)
> +{
> +	void __user *arg = (void __user *)p;
> +
> +	switch (cmd) {
> +	case FS_IOC_GETFLAGS:
> +		return efivarfs_ioc_getxflags(file, arg);
> +	case FS_IOC_SETFLAGS:
> +		return efivarfs_ioc_setxflags(file, arg);
> +	}
> +
> +	return -ENOTTY;
> +}
> +
>  const struct file_operations efivarfs_file_operations = {
>  	.open	= simple_open,
>  	.read	= efivarfs_file_read,
>  	.write	= efivarfs_file_write,
>  	.llseek	= no_llseek,
> +	.unlocked_ioctl = efivarfs_file_ioctl,
>  };
> diff --git a/fs/efivarfs/inode.c b/fs/efivarfs/inode.c
> index 3381b9d..e2ab6d0 100644
> --- a/fs/efivarfs/inode.c
> +++ b/fs/efivarfs/inode.c
> @@ -15,7 +15,8 @@
>  #include "internal.h"
>  
>  struct inode *efivarfs_get_inode(struct super_block *sb,
> -				const struct inode *dir, int mode, dev_t dev)
> +				const struct inode *dir, int mode,
> +				dev_t dev, bool is_removable)
>  {
>  	struct inode *inode = new_inode(sb);
>  
> @@ -23,6 +24,7 @@ struct inode *efivarfs_get_inode(struct super_block *sb,
>  		inode->i_ino = get_next_ino();
>  		inode->i_mode = mode;
>  		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
> +		inode->i_flags = is_removable ? 0 : S_IMMUTABLE;
>  		switch (mode & S_IFMT) {
>  		case S_IFREG:
>  			inode->i_fop = &efivarfs_file_operations;
> @@ -102,22 +104,17 @@ static void efivarfs_hex_to_guid(const char *str, efi_guid_t *guid)
>  static int efivarfs_create(struct inode *dir, struct dentry *dentry,
>  			  umode_t mode, bool excl)
>  {
> -	struct inode *inode;
> +	struct inode *inode = NULL;
>  	struct efivar_entry *var;
>  	int namelen, i = 0, err = 0;
> +	bool is_removable = false;
>  
>  	if (!efivarfs_valid_name(dentry->d_name.name, dentry->d_name.len))
>  		return -EINVAL;
>  
> -	inode = efivarfs_get_inode(dir->i_sb, dir, mode, 0);
> -	if (!inode)
> -		return -ENOMEM;
> -
>  	var = kzalloc(sizeof(struct efivar_entry), GFP_KERNEL);
> -	if (!var) {
> -		err = -ENOMEM;
> -		goto out;
> -	}
> +	if (!var)
> +		return -ENOMEM;
>  
>  	/* length of the variable name itself: remove GUID and separator */
>  	namelen = dentry->d_name.len - EFI_VARIABLE_GUID_LEN - 1;
> @@ -125,6 +122,16 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
>  	efivarfs_hex_to_guid(dentry->d_name.name + namelen + 1,
>  			&var->var.VendorGuid);
>  
> +	if (efivar_variable_is_removable(var->var.VendorGuid,
> +					 dentry->d_name.name, namelen))
> +		is_removable = true;
> +
> +	inode = efivarfs_get_inode(dir->i_sb, dir, mode, 0, is_removable);
> +	if (!inode) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +
>  	for (i = 0; i < namelen; i++)
>  		var->var.VariableName[i] = dentry->d_name.name[i];
>  
> @@ -138,7 +145,8 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
>  out:
>  	if (err) {
>  		kfree(var);
> -		iput(inode);
> +		if (inode)
> +			iput(inode);
>  	}
>  	return err;
>  }
> diff --git a/fs/efivarfs/internal.h b/fs/efivarfs/internal.h
> index b5ff16a..b450518 100644
> --- a/fs/efivarfs/internal.h
> +++ b/fs/efivarfs/internal.h
> @@ -15,7 +15,8 @@ extern const struct file_operations efivarfs_file_operations;
>  extern const struct inode_operations efivarfs_dir_inode_operations;
>  extern bool efivarfs_valid_name(const char *str, int len);
>  extern struct inode *efivarfs_get_inode(struct super_block *sb,
> -			const struct inode *dir, int mode, dev_t dev);
> +			const struct inode *dir, int mode, dev_t dev,
> +			bool is_removable);
>  
>  extern struct list_head efivarfs_list;
>  
> diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
> index 8651ac2..dd029d1 100644
> --- a/fs/efivarfs/super.c
> +++ b/fs/efivarfs/super.c
> @@ -120,6 +120,7 @@ static int efivarfs_callback(efi_char16_t *name16, efi_guid_t vendor,
>  	char *name;
>  	int len;
>  	int err = -ENOMEM;
> +	bool is_removable = false;
>  
>  	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
>  	if (!entry)
> @@ -137,13 +138,17 @@ static int efivarfs_callback(efi_char16_t *name16, efi_guid_t vendor,
>  
>  	ucs2_as_utf8(name, entry->var.VariableName, len);
>  
> +	if (efivar_variable_is_removable(entry->var.VendorGuid, name, len))
> +		is_removable = true;
> +
>  	name[len] = '-';
>  
>  	efi_guid_to_str(&entry->var.VendorGuid, name + len + 1);
>  
>  	name[len + EFI_VARIABLE_GUID_LEN+1] = '\0';
>  
> -	inode = efivarfs_get_inode(sb, d_inode(root), S_IFREG | 0644, 0);
> +	inode = efivarfs_get_inode(sb, d_inode(root), S_IFREG | 0644, 0,
> +				   is_removable);
>  	if (!inode)
>  		goto fail_name;
>  
> @@ -199,7 +204,7 @@ static int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
>  	sb->s_d_op		= &efivarfs_d_ops;
>  	sb->s_time_gran         = 1;
>  
> -	inode = efivarfs_get_inode(sb, NULL, S_IFDIR | 0755, 0);
> +	inode = efivarfs_get_inode(sb, NULL, S_IFDIR | 0755, 0, true);
>  	if (!inode)
>  		return -ENOMEM;
>  	inode->i_op = &efivarfs_dir_inode_operations;
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 52444fd..1869d5c 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -1201,6 +1201,8 @@ struct efivar_entry *efivar_entry_find(efi_char16_t *name, efi_guid_t guid,
>  
>  bool efivar_validate(efi_guid_t vendor, efi_char16_t *var_name, u8 *data,
>  		     unsigned long len);
> +bool efivar_variable_is_removable(efi_guid_t vendor, const char *name,
> +				  size_t len);
>  
>  extern struct work_struct efivar_work;
>  void efivar_run_worker(void);
> diff --git a/tools/testing/selftests/efivarfs/efivarfs.sh b/tools/testing/selftests/efivarfs/efivarfs.sh
> index 77edcdc..0572784 100755
> --- a/tools/testing/selftests/efivarfs/efivarfs.sh
> +++ b/tools/testing/selftests/efivarfs/efivarfs.sh
> @@ -88,7 +88,11 @@ test_delete()
>  		exit 1
>  	fi
>  
> -	rm $file
> +	rm $file 2>/dev/null
> +	if [ $? -ne 0 ]; then
> +		chattr -i $file
> +		rm $file
> +	fi
>  
>  	if [ -e $file ]; then
>  		echo "$file couldn't be deleted" >&2
> @@ -111,6 +115,7 @@ test_zero_size_delete()
>  		exit 1
>  	fi
>  
> +	chattr -i $file
>  	printf "$attrs" > $file
>  
>  	if [ -e $file ]; then
> @@ -141,7 +146,11 @@ test_valid_filenames()
>  			echo "$file could not be created" >&2
>  			ret=1
>  		else
> -			rm $file
> +			rm $file 2>/dev/null
> +			if [ $? -ne 0 ]; then
> +				chattr -i $file
> +				rm $file
> +			fi
>  		fi
>  	done
>  
> @@ -174,7 +183,11 @@ test_invalid_filenames()
>  
>  		if [ -e $file ]; then
>  			echo "Creating $file should have failed" >&2
> -			rm $file
> +			rm $file 2>/dev/null
> +			if [ $? -ne 0 ]; then
> +				chattr -i $file
> +				rm $file
> +			fi
>  			ret=1
>  		fi
>  	done
> diff --git a/tools/testing/selftests/efivarfs/open-unlink.c b/tools/testing/selftests/efivarfs/open-unlink.c
> index 8c07644..4af74f7 100644
> --- a/tools/testing/selftests/efivarfs/open-unlink.c
> +++ b/tools/testing/selftests/efivarfs/open-unlink.c
> @@ -1,10 +1,68 @@
> +#include <errno.h>
>  #include <stdio.h>
>  #include <stdint.h>
>  #include <stdlib.h>
>  #include <unistd.h>
> +#include <sys/ioctl.h>
>  #include <sys/types.h>
>  #include <sys/stat.h>
>  #include <fcntl.h>
> +#include <linux/fs.h>
> +
> +static int set_immutable(const char *path, int immutable)
> +{
> +	unsigned int flags;
> +	int fd;
> +	int rc;
> +	int error;
> +
> +	fd = open(path, O_RDONLY);
> +	if (fd < 0)
> +		return fd;
> +
> +	rc = ioctl(fd, FS_IOC_GETFLAGS, &flags);
> +	if (rc < 0) {
> +		error = errno;
> +		close(fd);
> +		errno = error;
> +		return rc;
> +	}
> +
> +	if (immutable)
> +		flags |= FS_IMMUTABLE_FL;
> +	else
> +		flags &= ~FS_IMMUTABLE_FL;
> +
> +	rc = ioctl(fd, FS_IOC_SETFLAGS, &flags);
> +	error = errno;
> +	close(fd);
> +	errno = error;
> +	return rc;
> +}
> +
> +static int get_immutable(const char *path)
> +{
> +	unsigned int flags;
> +	int fd;
> +	int rc;
> +	int error;
> +
> +	fd = open(path, O_RDONLY);
> +	if (fd < 0)
> +		return fd;
> +
> +	rc = ioctl(fd, FS_IOC_GETFLAGS, &flags);
> +	if (rc < 0) {
> +		error = errno;
> +		close(fd);
> +		errno = error;
> +		return rc;
> +	}
> +	close(fd);
> +	if (flags & FS_IMMUTABLE_FL)
> +		return 1;
> +	return 0;
> +}
>  
>  int main(int argc, char **argv)
>  {
> @@ -27,7 +85,7 @@ int main(int argc, char **argv)
>  	buf[4] = 0;
>  
>  	/* create a test variable */
> -	fd = open(path, O_WRONLY | O_CREAT);
> +	fd = open(path, O_WRONLY | O_CREAT, 0600);
>  	if (fd < 0) {
>  		perror("open(O_WRONLY)");
>  		return EXIT_FAILURE;
> @@ -41,6 +99,18 @@ int main(int argc, char **argv)
>  
>  	close(fd);
>  
> +	rc = get_immutable(path);
> +	if (rc < 0) {
> +		perror("ioctl(FS_IOC_GETFLAGS)");
> +		return EXIT_FAILURE;
> +	} else if (rc) {
> +		rc = set_immutable(path, 0);
> +		if (rc < 0) {
> +			perror("ioctl(FS_IOC_SETFLAGS)");
> +			return EXIT_FAILURE;
> +		}
> +	}
> +
>  	fd = open(path, O_RDONLY);
>  	if (fd < 0) {
>  		perror("open");
> 
