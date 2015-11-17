From: David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Xen-devel] [PATCH 02/13] xen/grant-table: Move xlated_setup_gnttab_pages
 to common place
Date: Tue, 17 Nov 2015 16:02:08 +0000
Message-ID: <564B4F80.2020402@citrix.com>
References: <1447754231-7772-1-git-send-email-shannon.zhao@linaro.org>
 <1447754231-7772-3-git-send-email-shannon.zhao@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447754231-7772-3-git-send-email-shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hangaohuai-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 17/11/15 09:57, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org wrote:
> From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> 
> Move xlated_setup_gnttab_pages to common place, so it can be reused by
> ARM to setup grant table when booting with ACPI.
[...]
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
> +	if (rc) {
> +		pr_warn("%s Couldn't balloon alloc %ld pfns rc:%d\n", __func__,
> +			nr_grant_frames, rc);
> +		kfree(pages);
> +		kfree(pfns);
> +		return rc;
> +	}
> +	for (i = 0; i < nr_grant_frames; i++)
> +		pfns[i] = page_to_pfn(pages[i]);
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

Can you move most of this function into drivers/xen/xlate_mmu.c in a
function like:

/**
 * xen_xlate_map_ballooned_pages - map a new set of ballooned pages
 * count: number of GFNs.
 * pages: returns the array of (now) ballooned pages.
 * gfns: returns the array of corresponding GFNs.
 * virt: returns the virtual address of the mapped region.
 *
 * This allocate a set of ballooned pages and maps them into the
 * kernel's address space.
 */
void *xen_xlate_map_ballooned_pages(
    unsigned int count,
    struct page **pages,
    xen_pfn_t **gfns);

David
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
