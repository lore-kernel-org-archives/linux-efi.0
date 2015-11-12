From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH 2/6] x86/mm/pageattr: Do not strip pte flags from cpa->pfn
Date: Thu, 12 Nov 2015 19:47:30 +0100
Message-ID: <20151112184730.GI3838@pd.tnic>
References: <1447342823-3612-1-git-send-email-matt@codeblueprint.co.uk>
 <1447342823-3612-3-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1447342823-3612-3-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Nov 12, 2015 at 03:40:19PM +0000, Matt Fleming wrote:
> Removing the PAGE_NX bit from cpa->pfn will corrupt the page frame
> number address rather than removing PAGE_NX as the code intends. This
> is unlikley to be a problem in practice because _PAGE_BIT_NX is bit 63
> and most machines do not have page frame numbers that reach that high.
> 
> Still, pte flags are never stored in cpa->pfn so we can safely delete
> the code.
> 
> Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
> Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> ---
>  arch/x86/mm/pageattr.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
> index 893921b12272..d5240be55915 100644
> --- a/arch/x86/mm/pageattr.c
> +++ b/arch/x86/mm/pageattr.c
> @@ -885,11 +885,6 @@ static void populate_pte(struct cpa_data *cpa,
>  	pte = pte_offset_kernel(pmd, start);
>  
>  	while (num_pages-- && start < end) {
> -
> -		/* deal with the NX bit */
> -		if (!(pgprot_val(pgprot) & _PAGE_NX))
> -			cpa->pfn &= ~_PAGE_NX;
> -
>  		set_pte(pte, pfn_pte(cpa->pfn, pgprot));
>  
>  		start	 += PAGE_SIZE;
> -- 

I think this should be part of the 1st patch because there you're
correcting ->pfn to actually be a pfn.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
