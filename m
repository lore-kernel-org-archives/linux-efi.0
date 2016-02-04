From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 5/5] efi: Make efivarfs entries immutable by default. (v5)
Date: Thu, 4 Feb 2016 23:42:11 +0000
Message-ID: <20160204234211.GI2586@codeblueprint.co.uk>
References: <1454600074-14854-1-git-send-email-pjones@redhat.com>
 <1454600074-14854-6-git-send-email-pjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1454600074-14854-6-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 04 Feb, at 10:34:34AM, Peter Jones wrote:
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
> Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Tested-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
> Acked-by: Matthew Garrett <mjg59-JW9irJGTvgXQT0dZR+AlfA@public.gmane.org>
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

[...]

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

I don't understand this comment. There are two lists?
