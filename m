From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 1/3] efi: Introduce *_continue efi_memory_desc iterators
Date: Wed, 1 Jun 2016 11:34:47 +0100
Message-ID: <20160601103446.GC9280@leverpostej>
References: <1464707672-21882-1-git-send-email-catalin.marinas@arm.com>
 <1464707672-21882-2-git-send-email-catalin.marinas@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1464707672-21882-2-git-send-email-catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi Catalin,

On Tue, May 31, 2016 at 04:14:30PM +0100, Catalin Marinas wrote:
> The for_each_efi_memory_desc_continue() macro and corresponding
> "_in_map" allow iterating over an efi_memory_map from a given position.
> For code reuse between the existing iterator and the _continue variant,
> this patch also introduces efi_memory_desc_next_entry_map().
> 
> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Signed-off-by: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
> ---
>  include/linux/efi.h | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index c2db3ca22217..4b0d880f1cd7 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -1002,11 +1002,16 @@ extern int efi_memattr_init(void);
>  extern int efi_memattr_apply_permissions(struct mm_struct *mm,
>  					 efi_memattr_perm_setter fn);
>  
> +/* Find next entry in an efi_memory_map or NULL if md is last */
> +#define efi_memory_desc_next_entry_map(m, md)				   \
> +	((md) == (efi_memory_desc_t *)((m)->map_end - (m)->desc_size)	   \
> +	 ? NULL : (void *)(md) + (m)->desc_size)
> +
>  /* Iterate through an efi_memory_map */
>  #define for_each_efi_memory_desc_in_map(m, md)				   \
>  	for ((md) = (m)->map;						   \
> -	     (md) <= (efi_memory_desc_t *)((m)->map_end - (m)->desc_size); \
> -	     (md) = (void *)(md) + (m)->desc_size)
> +	     (md);							   \
> +	     (md) = efi_memory_desc_next_entry_map(m, md))

As a heads-up, this will conflict with the efi/urgent branch [1], due to
commit ee92562e33c516dd ("efi: Fix for_each_efi_memory_desc_in_map() for
empty memmaps"). A pull went out for that yesterday [2].

Thanks,
Mark.

[1] git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git urgent
[2] http://lkml.kernel.org/r/1464690224-4503-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
