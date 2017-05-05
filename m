From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 1/1 linux-next] efi/capsule: kmap() can't fail
Date: Fri, 5 May 2017 22:21:45 +0100
Message-ID: <20170505212145.GE5225@codeblueprint.co.uk>
References: <20170425181051.2187-1-fabf@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170425181051.2187-1-fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 25 Apr, at 08:10:51PM, Fabian Frederick wrote:
> Remove NULL test on kmap()
> 
> Signed-off-by: Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>
> ---
>  drivers/firmware/efi/capsule-loader.c | 5 -----
>  drivers/firmware/efi/capsule.c        | 4 ----
>  2 files changed, 9 deletions(-)
> 
> diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
> index 9ae6c11..bf8b2ef 100644
> --- a/drivers/firmware/efi/capsule-loader.c
> +++ b/drivers/firmware/efi/capsule-loader.c
> @@ -183,11 +183,6 @@ static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
>  	page = cap_info->pages[cap_info->index - 1];
>  
>  	kbuff = kmap(page);
> -	if (!kbuff) {
> -		pr_debug("%s: kmap() failed\n", __func__);
> -		ret = -EFAULT;
> -		goto failed;
> -	}
>  	kbuff += PAGE_SIZE - cap_info->page_bytes_remain;
>  
>  	/* Copy capsule binary data from user space to kernel space buffer */
> diff --git a/drivers/firmware/efi/capsule.c b/drivers/firmware/efi/capsule.c
> index 6eedff4..e603ccf 100644
> --- a/drivers/firmware/efi/capsule.c
> +++ b/drivers/firmware/efi/capsule.c
> @@ -247,10 +247,6 @@ int efi_capsule_update(efi_capsule_header_t *capsule, struct page **pages)
>  		efi_capsule_block_desc_t *sglist;
>  
>  		sglist = kmap(sg_pages[i]);
> -		if (!sglist) {
> -			rv = -ENOMEM;
> -			goto out;
> -		}
>  
>  		for (j = 0; j < SGLIST_PER_PAGE && count > 0; j++) {
>  			u64 sz = min_t(u64, imagesize, PAGE_SIZE);

Huh, well I didn't know that.

This looks OK to me. Applied, thanks.
