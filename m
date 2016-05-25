From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi: fix for_each_efi_memory_desc_in_map() for empty
 memmaps
Date: Wed, 25 May 2016 21:48:05 +0100
Message-ID: <20160525204805.GE2984@codeblueprint.co.uk>
References: <1464187015-5640-1-git-send-email-vkuznets@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1464187015-5640-1-git-send-email-vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "K. Y. Srinivasan" <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

(Cc'ing Mark, the original author)

On Wed, 25 May, at 04:36:55PM, Vitaly Kuznetsov wrote:
> Commit 78ce248faa3c ("efi: Iterate over efi.memmap in
> for_each_efi_memory_desc()") introduced a regression for systems booted
> with 'noefi' kernel option. In particular, I observe early kernel hang in
> efi_find_mirror() on for_each_efi_memory_desc() call. As we don't have
> efi memmap we enter this iterator with the following parameters:
> 
> efi.memmap.map = 0, efi.memmap.map_end = 0, efi.memmap.desc_size = 28
> 
> for_each_efi_memory_desc_in_map() does the following comparison:
> 
> (md) <= (efi_memory_desc_t *)((m)->map_end - (m)->desc_size);
> 
> where md = 0, (m)->map_end = 0 and (m)->desc_size = 28 but when we subtract
> something from a NULL pointer wrap around happens and we end up returning
> invalid pointer.
> 
> Fixes: 78ce248faa3c ("efi: Iterate over efi.memmap in for_each_efi_memory_desc()")
> Signed-off-by: Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  include/linux/efi.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index c2db3ca..229ccb5 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -1005,7 +1005,8 @@ extern int efi_memattr_apply_permissions(struct mm_struct *mm,
>  /* Iterate through an efi_memory_map */
>  #define for_each_efi_memory_desc_in_map(m, md)				   \
>  	for ((md) = (m)->map;						   \
> -	     (md) <= (efi_memory_desc_t *)((m)->map_end - (m)->desc_size); \
> +	     (efi_memory_desc_t *)((md) + (m)->desc_size) <=		   \
> +		     (efi_memory_desc_t *)(m)->map_end;			   \
>  	     (md) = (void *)(md) + (m)->desc_size)

Curse C type casting!

You're adding m->desc_size to a (efi_memory_desc_t *) which is 40
bytes. You need the below to avoid breaking regular EFI boot.

But yeah, this looks like a fine fix. Mark, any concerns?

---

diff --git a/include/linux/efi.h b/include/linux/efi.h
index d8ab480b1089..3a3f8d8bd9be 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1026,7 +1026,7 @@ extern int efi_memattr_apply_permissions(struct mm_struct *mm,
 /* Iterate through an efi_memory_map */
 #define for_each_efi_memory_desc_in_map(m, md)				   \
 	for ((md) = (m)->map;						   \
-	     (md) <= (efi_memory_desc_t *)((m)->map_end - (m)->desc_size); \
+	     ((void *)(md) + (m)->desc_size) <=	(m)->map_end;		   \
 	     (md) = (void *)(md) + (m)->desc_size)
 
 /**
