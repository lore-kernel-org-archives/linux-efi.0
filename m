From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 7/8] efi/capsule-loader: use page addresses rather than
 struct page pointers
Date: Tue, 18 Apr 2017 13:56:31 +0100
Message-ID: <20170418125631.GI24360@codeblueprint.co.uk>
References: <20170405092317.27921-1-ard.biesheuvel@linaro.org>
 <20170405092317.27921-8-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170405092317.27921-8-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org, hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, sascha.weisenberger-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org, jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 05 Apr, at 10:23:16AM, Ard Biesheuvel wrote:
> To give some leeway to code that handles non-standard capsule headers,
> let's keep an array of page addresses rather than struct page pointers.
> 
> This gives special implementations of efi_capsule_setup_info() the
> opportunity to mangle the payload a bit before it is presented to the
> firmware, without putting any knowledge of the nature of such quirks
> into the generic code.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/capsule-loader.c | 12 ++++++++----
>  drivers/firmware/efi/capsule.c        |  7 ++++---
>  include/linux/efi.h                   |  4 ++--
>  3 files changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
> index d68a1ecebbf3..22b2bb73176c 100644
> --- a/drivers/firmware/efi/capsule-loader.c
> +++ b/drivers/firmware/efi/capsule-loader.c
> @@ -20,6 +20,10 @@
>  
>  #define NO_FURTHER_WRITE_ACTION -1
>  
> +#ifndef phys_to_page
> +#define phys_to_page(x)		virt_to_page((unsigned long)__va(x))
> +#endif

Is this going to work with highmem pages, which presumably, is a
possibility for the 32-bit Quark?
