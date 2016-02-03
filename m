From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 5/5] efi: Make efivarfs entries immutable by default. (v3)
Date: Thu, 4 Feb 2016 02:00:16 +0800
Message-ID: <20160203180016.GQ26698@linux-rxt1.site>
References: <1454517834-13736-1-git-send-email-pjones@redhat.com>
 <1454517834-13736-5-git-send-email-pjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1454517834-13736-5-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Feb 03, 2016 at 11:43:54AM -0500, Peter Jones wrote:
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
> v2: adds Timeout to our whitelist.
> v3:
>  - takes the extra Timeout out of the whitelist
>  - fixes whitelist matching to actually work
>  - inverts the flag on efivarfs_get_inode() and calls it is_removable
>  - adds documentation and test cases
> 
> Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Tested-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>

Regards

Joey Lee

> ---
>  Documentation/filesystems/efivarfs.txt         |  7 ++
>  drivers/firmware/efi/vars.c                    | 97 ++++++++++++++++++++------
>  fs/efivarfs/file.c                             | 69 ++++++++++++++++++
>  fs/efivarfs/inode.c                            | 31 +++++---
>  fs/efivarfs/internal.h                         |  3 +-
>  fs/efivarfs/super.c                            |  9 ++-
>  include/linux/efi.h                            |  2 +
>  tools/testing/selftests/efivarfs/efivarfs.sh   | 19 ++++-
>  tools/testing/selftests/efivarfs/open-unlink.c | 72 ++++++++++++++++++-
>  9 files changed, 268 insertions(+), 41 deletions(-)
> 
> diff --git a/Documentation/filesystems/efivarfs.txt b/Documentation/filesystems/efivarfs.txt
> index c477af0..686a64b 100644
> --- a/Documentation/filesystems/efivarfs.txt
> +++ b/Documentation/filesystems/efivarfs.txt
> @@ -14,3 +14,10 @@ filesystem.
>  efivarfs is typically mounted like this,
> 
[...snip] 
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

Yes, this change works on my testing.  

Regards

Joey Lee
