From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 6/8] efi/capsule-loader: indirect calls to
 efi_capsule_setup_info via weak alias
Date: Tue, 18 Apr 2017 13:44:29 +0100
Message-ID: <20170418124429.GG24360@codeblueprint.co.uk>
References: <20170405092317.27921-1-ard.biesheuvel@linaro.org>
 <20170405092317.27921-7-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170405092317.27921-7-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org, hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, sascha.weisenberger-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org, jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 05 Apr, at 10:23:15AM, Ard Biesheuvel wrote:
> To allow platform specific code to hook into the capsule loading
> routines, indirect calls to efi_capsule_setup_info() via a weak alias
> of __efi_capsule_setup_info(), allowing platforms to redefine the former
> but still use the latter.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/capsule-loader.c | 52 +++++++++-----------
>  include/linux/efi.h                   | 12 +++++
>  2 files changed, 35 insertions(+), 29 deletions(-)

[...]

> @@ -97,6 +71,26 @@ static int efi_capsule_setup_info(struct capsule_info *cap_info,
>  }
>  
>  /**
> + * efi_capsule_setup_info - obtain the efi capsule header in the binary and
> + *			    setup capsule_info structure
> + * @cap_info: pointer to current instance of capsule_info structure
> + * @kbuff: a mapped first page buffer pointer
> + * @hdr_bytes: the total received number of bytes for efi header
> + **/
> +int __weak efi_capsule_setup_info(struct capsule_info *cap_info, void *kbuff,
> +				  size_t hdr_bytes)
> +{
> +	/* Only process data block that is larger than efi header size */
> +	if (hdr_bytes < sizeof(efi_capsule_header_t))
> +		return 0;
> +
> +	memcpy(&cap_info->header, kbuff, sizeof(cap_info->header));
> +	cap_info->total_size = cap_info->header.imagesize;
> +
> +	return __efi_capsule_setup_info(cap_info);
> +}

It would be good if you provided a little bit of blurb in the function
comment describing why someone might want to override this __weak
function.

Perhaps just something like,

 "Platforms with non-standard capsule update mechanisms can override
  this __weak function so they can perform any required capsule
  image munging. See quark_quirk_function() for an example."
