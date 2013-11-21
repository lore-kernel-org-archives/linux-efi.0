From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [patch 5/9 v3] efi: export more efi table variable to sysfs
Date: Thu, 21 Nov 2013 08:42:24 -0800
Message-ID: <20131121164224.GA15083@kroah.com>
References: <20131121061704.363730447@dhcp-16-126.nay.redhat.com>
 <20131121061754.887381332@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131121061754.887381332-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Nov 21, 2013 at 02:17:09PM +0800, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> Export fw_vendor, runtime and config tables physical
> addresses to /sys/firmware/efi/systab becaue kexec
> kernel will need them.
> 
> >From EFI spec these 3 variables will be updated to
> virtual address after entering virtual mode. But
> kernel startup code will need the physical address.
> 
> changelog:
> Greg: add standalone sysfs files instead of add lines to systab
> Document them as testing ABI
> 
> Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  Documentation/ABI/testing/sysfs-firmware-efi |   26 +++++++++
>  arch/x86/platform/efi/efi.c                  |    4 +
>  drivers/firmware/efi/efi.c                   |   71 +++++++++++++++++++++++++--
>  include/linux/efi.h                          |    3 +
>  4 files changed, 101 insertions(+), 3 deletions(-)
> 
> --- efi.orig/drivers/firmware/efi/efi.c
> +++ efi/drivers/firmware/efi/efi.c
> @@ -32,6 +32,9 @@ struct efi __read_mostly efi = {
>  	.hcdp       = EFI_INVALID_TABLE_ADDR,
>  	.uga        = EFI_INVALID_TABLE_ADDR,
>  	.uv_systab  = EFI_INVALID_TABLE_ADDR,
> +	.fw_vendor  = EFI_INVALID_TABLE_ADDR,
> +	.runtime    = EFI_INVALID_TABLE_ADDR,
> +	.config_table  = EFI_INVALID_TABLE_ADDR,
>  };
>  EXPORT_SYMBOL(efi);
>  
> @@ -71,6 +74,31 @@ static ssize_t systab_show(struct kobjec
>  static struct kobj_attribute efi_attr_systab =
>  			__ATTR(systab, 0400, systab_show, NULL);
>  
> +static ssize_t fw_vendor_show(struct kobject *kobj,
> +				struct kobj_attribute *attr, char *buf)
> +{
> +	return sprintf(buf, "0x%lx\n", efi.fw_vendor);
> +}
> +
> +static ssize_t runtime_show(struct kobject *kobj,
> +				struct kobj_attribute *attr, char *buf)
> +{
> +	return sprintf(buf, "0x%lx\n", efi.runtime);
> +}
> +
> +static ssize_t config_table_show(struct kobject *kobj,
> +				struct kobj_attribute *attr, char *buf)
> +{
> +	return sprintf(buf, "0x%lx\n", efi.config_table);
> +}
> +
> +static struct kobj_attribute efi_attr_fw_vendor =
> +				__ATTR(fw_vendor, 0400, fw_vendor_show, NULL);
> +static struct kobj_attribute efi_attr_runtime =
> +			__ATTR(runtime, 0400, runtime_show, NULL);
> +static struct kobj_attribute efi_attr_config_table =
> +			__ATTR(config_table, 0400, config_table_show, NULL);
> +
>  static struct attribute *efi_subsys_attrs[] = {
>  	&efi_attr_systab.attr,
>  	NULL,	/* maybe more in the future? */
> @@ -123,21 +151,58 @@ static int __init efisubsys_init(void)
>  
>  	error = sysfs_create_group(efi_kobj, &efi_subsys_attr_group);
>  	if (error) {
> -		pr_err("efi: Sysfs attribute export failed with error %d.\n",
> -		       error);
> +		pr_err("efi: Sysfs attribute %s export failed with error %d.\n",
> +		       efi_attr_systab.attr.name, error);
>  		goto err_unregister;
>  	}
>  
> +	if (efi.fw_vendor != EFI_INVALID_TABLE_ADDR) {
> +		error = sysfs_create_file(efi_kobj, &efi_attr_fw_vendor.attr);
> +		if (error) {
> +			pr_err("efi: Sysfs attribute %s export failed with error %d.\n",
> +				efi_attr_fw_vendor.attr.name, error);
> +			goto err_remove_group;
> +		}
> +	}
> +
> +	if (efi.runtime != EFI_INVALID_TABLE_ADDR) {
> +		error = sysfs_create_file(efi_kobj, &efi_attr_runtime.attr);
> +		if (error) {
> +			pr_err("efi: Sysfs attribute %s export failed with error %d.\n",
> +				efi_attr_runtime.attr.name, error);
> +			goto err_remove_fw_vendor;
> +		}
> +	}
> +
> +	if (efi.config_table != EFI_INVALID_TABLE_ADDR) {
> +		error = sysfs_create_file(efi_kobj,
> +					&efi_attr_config_table.attr);
> +		if (error) {
> +			pr_err("efi: Sysfs attribute %s export failed with error %d.\n",
> +				efi_attr_config_table.attr.name, error);
> +			goto err_remove_runtime;
> +		}
> +	}

You don't need to do this "if SOMETHING then create the file", just use
the "is_visible" attribute in the group to do this as a callback to
determine this when the group is registered.

That should clean up this logic a bunch.

thanks,

greg k-h
