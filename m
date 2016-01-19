From: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
Subject: Re: [Xen-devel] [PATCH v2 03/16] Xen: xlate: Use page_to_xen_pfn
 instead of page_to_pfn
Date: Tue, 19 Jan 2016 14:59:39 +0000
Message-ID: <alpine.DEB.2.02.1601191456370.9400@kaball.uk.xensource.com>
References: <1452840929-19612-1-git-send-email-zhaoshenglong@huawei.com>
 <1452840929-19612-4-git-send-email-zhaoshenglong@huawei.com>
 <alpine.DEB.2.02.1601151558010.16178@kaball.uk.xensource.com>
 <569C7363.80106@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <569C7363.80106-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 18 Jan 2016, Shannon Zhao wrote:
> On 2016/1/16 1:08, Stefano Stabellini wrote:
> > On Fri, 15 Jan 2016, Shannon Zhao wrote:
> >> From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> >>
> >> Use page_to_xen_pfn in case of 64KB page.
> >>
> >> Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> >> ---
> >>  drivers/xen/xlate_mmu.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/xen/xlate_mmu.c b/drivers/xen/xlate_mmu.c
> >> index 9692656..b9fcc2c 100644
> >> --- a/drivers/xen/xlate_mmu.c
> >> +++ b/drivers/xen/xlate_mmu.c
> >> @@ -227,7 +227,7 @@ int __init xen_xlate_map_ballooned_pages(xen_pfn_t **gfns, void **virt,
> >>  		return rc;
> >>  	}
> >>  	for (i = 0; i < nr_grant_frames; i++)
> >> -		pfns[i] = page_to_pfn(pages[i]);
> >> +		pfns[i] = page_to_xen_pfn(pages[i]);
> > 
> > Shannon, thanks for the patch.
> > 
> > Keeping in mind that in the 64K case, kernel pages are 64K but xen pages
> > are still 4K, I think you also need to allocate
> > (nr_grant_frames/XEN_PFN_PER_PAGE) kernel pages (assuming that they are
> > allocated contiguously): nr_grant_frames refers to 4K pages, while
> > xen_xlate_map_ballooned_pages is allocating pages on a 64K granularity
> > (sizeof(pages[0]) == 64K).
> > 
> > Be careful that alloc_xenballooned_pages deals with 64K pages (because
> > it deals with kernel pages), while xen_pfn_t is always 4K based (because
> > it deals with Xen pfns).
> > 
> > Please test it with and without CONFIG_ARM64_64K_PAGES. Thanks!
> > 
> Stefano, thanks for your explanation. How about below patch?

Good work, it looks like you covered all bases, I think it should work,
but I haven't tested it myself. Just one note below.


> diff --git a/drivers/xen/xlate_mmu.c b/drivers/xen/xlate_mmu.c
> index 9692656..e1f7c95 100644
> --- a/drivers/xen/xlate_mmu.c
> +++ b/drivers/xen/xlate_mmu.c
> @@ -207,9 +207,12 @@ int __init xen_xlate_map_ballooned_pages(xen_pfn_t
> **gfns, void **virt,
>         void *vaddr;
>         int rc;
>         unsigned int i;
> +       unsigned long nr_pages;
> +       xen_pfn_t xen_pfn = 0;
> 
>         BUG_ON(nr_grant_frames == 0);
> -       pages = kcalloc(nr_grant_frames, sizeof(pages[0]), GFP_KERNEL);
> +       nr_pages = DIV_ROUND_UP(nr_grant_frames, XEN_PFN_PER_PAGE);
> +       pages = kcalloc(nr_pages, sizeof(pages[0]), GFP_KERNEL);
>         if (!pages)
>                 return -ENOMEM;
> 
> @@ -218,22 +221,25 @@ int __init xen_xlate_map_ballooned_pages(xen_pfn_t
> **gfns, void **virt,
>                 kfree(pages);
>                 return -ENOMEM;
>         }
> -       rc = alloc_xenballooned_pages(nr_grant_frames, pages);
> +       rc = alloc_xenballooned_pages(nr_pages, pages);
>         if (rc) {
> -               pr_warn("%s Couldn't balloon alloc %ld pfns rc:%d\n",
> __func__,
> -                       nr_grant_frames, rc);
> +               pr_warn("%s Couldn't balloon alloc %ld pages rc:%d\n",
> __func__,
> +                       nr_pages, rc);
>                 kfree(pages);
>                 kfree(pfns);
>                 return rc;
>         }
> -       for (i = 0; i < nr_grant_frames; i++)
> -               pfns[i] = page_to_pfn(pages[i]);
> +       for (i = 0; i < nr_grant_frames; i++) {
> +               if ((i % XEN_PFN_PER_PAGE) == 0)
> +                       xen_pfn = page_to_xen_pfn(pages[i /
> XEN_PFN_PER_PAGE]);
> +               pfns[i] = xen_pfn++;
> +       }

We might want to:

  pfns[i] = pfn_to_gfn(xen_pfn++);

for consistency, even though for autotranslate guests pfn_to_gfn always
returns pfn.


> -       vaddr = vmap(pages, nr_grant_frames, 0, PAGE_KERNEL);
> +       vaddr = vmap(pages, nr_pages, 0, PAGE_KERNEL);
>         if (!vaddr) {
> -               pr_warn("%s Couldn't map %ld pfns rc:%d\n", __func__,
> -                       nr_grant_frames, rc);
> -               free_xenballooned_pages(nr_grant_frames, pages);
> +               pr_warn("%s Couldn't map %ld pages rc:%d\n", __func__,
> +                       nr_pages, rc);
> +               free_xenballooned_pages(nr_pages, pages);
>                 kfree(pages);
>                 kfree(pfns);
>                 return -ENOMEM;
> 
> -- 
> Shannon
> 
