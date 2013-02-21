From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4] efi: split efisubsystem from efivars
Date: Thu, 21 Feb 2013 11:17:01 +0000
Message-ID: <1361445421.2842.3.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1361041300-3760-1-git-send-email-teg@jklm.no>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1361041300-3760-1-git-send-email-teg-B22kvLQNl6c@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>, Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Chun-Yi Lee <jlee-IBi9RG/b67k@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Tobias Powalowski <tpowa-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, 2013-02-16 at 20:01 +0100, Tom Gundersen wrote:
> This registers /sys/firmware/efi/{,systab,efivars/} whenever EFI is enabled
> and the system is booted with EFI.
> 
> This allows
>  *) userspace to check for the existence of /sys/firmware/efi as a way
>     to determine whether or it is running on an EFI system.
>  *) 'mount -t efivarfs none /sys/firmware/efi/efivars' without manually
>     loading any modules.
> 
> v4: rebase on top of the chainsaw branch:
>     - split into efi.c and vars.c
>     - move systab from vars.c to efi.c
>     - address checkpatch warnings
> v3: rebase on top of new efi_enabled()
> v2: only create /sys/firmware/efi/efivars if the module is being compiled,
>     and move extern's to efi.h
> 
> Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>
> Cc: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
> Cc: Chun-Yi Lee <jlee-IBi9RG/b67k@public.gmane.org>
> Cc: Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> Cc: Tobias Powalowski <tpowa-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
> Signed-off-by: Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
> ---
>  drivers/firmware/Makefile     |   1 -
>  drivers/firmware/efi/Makefile |   2 +
>  drivers/firmware/efi/efi.c    | 107 +++++
>  drivers/firmware/efi/vars.c   | 858 +++++++++++++++++++++++++++++++++++++
>  drivers/firmware/efivars.c    | 955 ------------------------------------------
>  include/linux/efi.h           |   2 +
>  6 files changed, 969 insertions(+), 956 deletions(-)
>  create mode 100644 drivers/firmware/efi/efi.c
>  create mode 100644 drivers/firmware/efi/vars.c
>  delete mode 100644 drivers/firmware/efivars.c
> 
> diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
> index 31bf68c..299fad6 100644
> --- a/drivers/firmware/Makefile
> +++ b/drivers/firmware/Makefile
> @@ -4,7 +4,6 @@
>  obj-$(CONFIG_DMI)		+= dmi_scan.o
>  obj-$(CONFIG_DMI_SYSFS)		+= dmi-sysfs.o
>  obj-$(CONFIG_EDD)		+= edd.o
> -obj-$(CONFIG_EFI_VARS)		+= efivars.o
>  obj-$(CONFIG_EFI_PCDP)		+= pcdp.o
>  obj-$(CONFIG_DELL_RBU)          += dell_rbu.o
>  obj-$(CONFIG_DCDBAS)		+= dcdbas.o
> diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
> index ef5066f..9660b3d 100644
> --- a/drivers/firmware/efi/Makefile
> +++ b/drivers/firmware/efi/Makefile
> @@ -1,6 +1,8 @@
>  #
>  # Makefile for linux kernel
>  #
> +obj-$(CONFIG_EFI)			+= efi.o

The $(CONFIG_EFI) part is redundant. We only build things in
drivers/firmware/efi/ if CONFIG_EFI=y.

[...]

> +/*
> + * We register the efi subsystem with the firmware subsystem and the
> + * efivars subsystem with the efi subsystem, if the system was booted with
> + * EFI.
> + */
> +static int __init efisubsys_init(void)
> +{
> +	int error;
> +
> +	if (!efi_enabled(EFI_BOOT))
> +		return 0;

OK, this makes sense, and you've highlighted a really good point. We
need to add checks in a bunch of places to see if EFI runtime services
are available. But you don't need to worry about that, I need to do that
in earlier patches, not this one.

> +	/* We register the efi directory at /sys/firmware/efi */
> +	efi_kobj = kobject_create_and_add("efi", firmware_kobj);
> +	if (!efi_kobj) {
> +		pr_err("efi: Firmware registration failed.\n");
> +		return -ENOMEM;
> +	}
> +
> +	error = sysfs_create_group(efi_kobj, &efi_subsys_attr_group);
> +	if (error) {
> +		pr_err("efi: Sysfs attribute export failed with error %d.\n",
> +		       error);
> +	}
> +
> +#if defined(CONFIG_EFIVAR_FS) || defined(CONFIG_EFIVAR_FS_MODULE)
> +	/* and the standard mountpoint for efivarfs */
> +	efivars_kobj = kobject_create_and_add("efivars", efi_kobj);
> +	if (!efivars_kobj) {
> +		pr_err("efivars: Subsystem registration failed.\n");
> +		kobject_put(efi_kobj);
> +		return -ENOMEM;
> +	}
> +#endif /* CONFIG_EFIVAR_FS */

Does it make sense to hide the efivarfs mount point? I'm not crazy about
sprinkling more #ifdef's around. If the efivarfs code isn't compiled
into the kernel/built as a module then mounting will fail anyway.
