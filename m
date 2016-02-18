From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 2/2] efi: Make efivarfs entries immutable by default.
Date: Thu, 18 Feb 2016 14:56:50 +0000
Message-ID: <20160218145650.GJ2651@codeblueprint.co.uk>
References: <1455638983-30455-1-git-send-email-pjones@redhat.com>
 <1455638983-30455-3-git-send-email-pjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1455638983-30455-3-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 16 Feb, at 11:09:43AM, Peter Jones wrote:
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
> 
> Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  Documentation/filesystems/efivarfs.txt         |   7 ++
>  drivers/firmware/efi/vars.c                    | 115 ++++++++++++++++++++-----
>  fs/efivarfs/file.c                             |  70 +++++++++++++++
>  fs/efivarfs/inode.c                            |  30 ++++---
>  fs/efivarfs/internal.h                         |   3 +-
>  fs/efivarfs/super.c                            |   9 +-
>  include/linux/efi.h                            |   4 +-
>  tools/testing/selftests/efivarfs/efivarfs.sh   |  19 +++-
>  tools/testing/selftests/efivarfs/open-unlink.c |  72 +++++++++++++++-
>  9 files changed, 287 insertions(+), 42 deletions(-)
 
[...]

> @@ -193,17 +195,59 @@ static const struct variable_validate variable_validate[] = {
>  	{ EFI_GLOBAL_VARIABLE_GUID, "ErrOut", validate_device_path },
>  	{ EFI_GLOBAL_VARIABLE_GUID, "ErrOutDev", validate_device_path },
>  	{ EFI_GLOBAL_VARIABLE_GUID, "Lang", validate_ascii_string },
> +	{ EFI_GLOBAL_VARIABLE_GUID, "OsIndications", NULL },
>  	{ EFI_GLOBAL_VARIABLE_GUID, "PlatformLang", validate_ascii_string },
>  	{ EFI_GLOBAL_VARIABLE_GUID, "Timeout", validate_uint16 },
> +	{ LINUX_EFI_CRASH_GUID, "*", NULL },
>  	{ NULL_GUID, "", NULL },
>  };
>  

You don't need to fold in patches that can be applied verbatim from
upstream. It makes validation of backports harder and the git history
bizarre.

> +static bool
> +variable_matches(const efi_char16_t *ucs2_name, const char *var_name,
> +		 size_t len, const char *match_name, int *match)
> +{
> +	for (*match = 0; ; (*match)++) {
> +		char c = match_name[*match];
> +		char u = var_name[*match];
> +
> +		/* Wildcard in the matching name means we've matched */
> +		if (c == '*')
> +			return true;
> +
> +		/* All special variables are plain ascii unless they were
> +		 * wildcards. */
> +		if (ucs2_name[*match] > 127)
> +			return false;
> +

This caught my eye. You've inverted the check from here,

[...]
  
> -			/* All special variables are plain ascii */
> -			if (u > 127)
> -				return true;

Was that intentional?
