From: joeyli <jlee@suse.com>
Subject: Re: [PATCH] efi: capsule: allocate whole capsule into virtual memory
Date: Thu, 28 Jul 2016 14:07:04 +0800
Message-ID: <20160728060704.GE21549@linux-rxt1.site>
References: <1468600891-15794-1-git-send-email-austinwc@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1468600891-15794-1-git-send-email-austinwc@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Austin Christ <austinwc@codeaurora.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, matt@codeblueprint.co.uk, linux-arm-kernel@lists.infradead.org, jbrasen@codeaurora.org
List-Id: linux-efi@vger.kernel.org

Hi Austin,

On Fri, Jul 15, 2016 at 10:41:31AM -0600, Austin Christ wrote:
> According to UEFI 2.6 section 7.5.3, the capsule should be in contiguous
> virtual memory and firmware may consume the capsule immediately. To
> correctly implement this functionality, the kernel driver needs to vmap
> the entire capsule at the time it is made available to firmware.
> 
> The virtual allocation of the capsule update has been changed from kmap,
> which was only allocating the first page of the update, to vmap and
> allocates the entire data payload.
> 
> Signed-off-by: Austin Christ <austinwc@codeaurora.org>
> ---
>  drivers/firmware/efi/capsule-loader.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
> index c99c24b..c4f3c20 100644
> --- a/drivers/firmware/efi/capsule-loader.c
> +++ b/drivers/firmware/efi/capsule-loader.c
> @@ -16,6 +16,7 @@
>  #include <linux/slab.h>
>  #include <linux/mutex.h>
>  #include <linux/efi.h>
> +#include <linux/vmalloc.h>
>  
>  #define NO_FURTHER_WRITE_ACTION -1
>  
> @@ -108,14 +109,15 @@ static ssize_t efi_capsule_submit_update(struct capsule_info *cap_info)
>  	int ret;
>  	void *cap_hdr_temp;
>  
> -	cap_hdr_temp = kmap(cap_info->pages[0]);
> +	cap_hdr_temp = vmap(cap_info->pages, cap_info->index,
> +			VM_MAP, PAGE_KERNEL);
>  	if (!cap_hdr_temp) {
>  		pr_debug("%s: kmap() failed\n", __func__);
                             ^^^^^^^^ use vmap()?

I have only a minor suggestion as above.

Reviewed-by: Lee, Chun-Yi <jlee@suse.com>

>  		return -EFAULT;
>  	}
>  
>  	ret = efi_capsule_update(cap_hdr_temp, cap_info->pages);
> -	kunmap(cap_info->pages[0]);
> +	vunmap(cap_hdr_temp);
>  	if (ret) {
>  		pr_err("%s: efi_capsule_update() failed\n", __func__);
>  		return ret;
> --

Thanks a lot!
Joey Lee 
