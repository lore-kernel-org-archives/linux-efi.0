From: Julien Grall <julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Xen-devel] [PATCH 02/13] xen/grant-table: Move xlated_setup_gnttab_pages
 to common place
Date: Wed, 18 Nov 2015 12:25:48 +0000
Message-ID: <564C6E4C.9080003@citrix.com>
References: <1447754231-7772-1-git-send-email-shannon.zhao@linaro.org>
 <1447754231-7772-3-git-send-email-shannon.zhao@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447754231-7772-3-git-send-email-shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hangaohuai-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi Shannon,

On 17/11/15 09:57, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org wrote:
> diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> index 62f591f..c084ba6 100644
> --- a/drivers/xen/grant-table.c
> +++ b/drivers/xen/grant-table.c
> @@ -664,6 +664,55 @@ int gnttab_setup_auto_xlat_frames(phys_addr_t addr)
>  }
>  EXPORT_SYMBOL_GPL(gnttab_setup_auto_xlat_frames);
>  
> +int __init xlated_setup_gnttab_pages(void)
> +{
> +	struct page **pages;
> +	xen_pfn_t *pfns;
> +	void *vaddr;
> +	int rc;
> +	unsigned int i;
> +	unsigned long nr_grant_frames = gnttab_max_grant_frames();
> +
> +	BUG_ON(nr_grant_frames == 0);
> +	pages = kcalloc(nr_grant_frames, sizeof(pages[0]), GFP_KERNEL);
> +	if (!pages)
> +		return -ENOMEM;
> +
> +	pfns = kcalloc(nr_grant_frames, sizeof(pfns[0]), GFP_KERNEL);
> +	if (!pfns) {
> +		kfree(pages);
> +		return -ENOMEM;
> +	}
> +	rc = alloc_xenballooned_pages(nr_grant_frames, pages, 0 /* lowmem */);

Can you rebase your patch on top of linux/master? The 3rd parameters has
been dropped for alloc_xenballooned_pages.

> +	if (rc) {
> +		pr_warn("%s Couldn't balloon alloc %ld pfns rc:%d\n", __func__,
> +			nr_grant_frames, rc);
> +		kfree(pages);
> +		kfree(pfns);
> +		return rc;
> +	}
> +	for (i = 0; i < nr_grant_frames; i++)
> +		pfns[i] = page_to_pfn(pages[i]);

This code needs to be adapt for 64KB page granularity. Please use
page_to_xen_pfn here.

> +
> +	vaddr = vmap(pages, nr_grant_frames, 0, PAGE_KERNEL);
> +	if (!vaddr) {
> +		pr_warn("%s Couldn't map %ld pfns rc:%d\n", __func__,
> +			nr_grant_frames, rc);
> +		free_xenballooned_pages(nr_grant_frames, pages);
> +		kfree(pages);
> +		kfree(pfns);
> +		return -ENOMEM;
> +	}
> +	kfree(pages);
> +
> +	xen_auto_xlat_grant_frames.pfn = pfns;
> +	xen_auto_xlat_grant_frames.count = nr_grant_frames;
> +	xen_auto_xlat_grant_frames.vaddr = vaddr;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(xlated_setup_gnttab_pages);
> +
>  void gnttab_free_auto_xlat_frames(void)
>  {
>  	if (!xen_auto_xlat_grant_frames.count)
> diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
> index 4478f4b..fa31e66 100644
> --- a/include/xen/grant_table.h
> +++ b/include/xen/grant_table.h
> @@ -177,6 +177,7 @@ struct grant_frames {
>  extern struct grant_frames xen_auto_xlat_grant_frames;
>  unsigned int gnttab_max_grant_frames(void);
>  int gnttab_setup_auto_xlat_frames(phys_addr_t addr);
> +int xlated_setup_gnttab_pages(void);
>  void gnttab_free_auto_xlat_frames(void);
>  
>  #define gnttab_map_vaddr(map) ((void *)(map.host_virt_addr))
> 

Regards,


-- 
Julien Grall
