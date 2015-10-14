From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Fix kernel panic when CONFIG_DEBUG_VIRTUAL is
 enabled
Date: Wed, 14 Oct 2015 16:41:34 +0200
Message-ID: <20151014144134.GA8263@pd.tnic>
References: <1444765377-29303-1-git-send-email-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1444765377-29303-1-git-send-email-sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Glenn P Williamson <glenn.p.williamson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Oct 13, 2015 at 12:42:57PM -0700, Sai Praneeth Prakhya wrote:
> From: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> When CONFIG_DEBUG_VIRTUAL is turned on, all accesses to __pa(address)
> are monitored to see whether address falls in direct mapping or kernel
> mapping,

make that

"... or kernel text mapping (see Documentation/x86/x86_64/mm.txt for
details)"

for more clarity please. It just took mfleming and me a while to figure
out what what is.

> if it does not kernel panics. During 1:1 mapping of EFI runtime
> services we access addresses which are below 4G and hence when passed as

not "below 4G" but "we access virtual adresses which are == physical
addresses, thus the 1:1 mapping" - on a box with more than 4G, physical
addresses can be above 4G too :)

> arguments to __pa() kernel panics as reported by Dave Hansen here
> https://lkml.org/lkml/2015/1/27/742.

Please quote this mail with the k.org redirector:

https://lkml.kernel.org/r/5462999A.7090706-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

lkml.org is unreliable.

> So, before calling __pa() virtual
> addresses should be validated which results in skipping call to
> split_page_count() and that should be fine because it is used to keep
> track of direct kernel mappings and not 1:1 mappings.

I think that should say:

"to keep track of everything *but* 1:1 mappings."

The 1:1 mappings are EFI-specific thing and the physaddr.c checkers
aren't aware of them.

Again, IMHO.

> Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reported-by: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Glenn P Williamson <glenn.p.williamson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  arch/x86/mm/pageattr.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
> index 727158cb3b3c..3a603830503a 100644
> --- a/arch/x86/mm/pageattr.c
> +++ b/arch/x86/mm/pageattr.c
> @@ -648,9 +648,11 @@ __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
>  	for (i = 0; i < PTRS_PER_PTE; i++, pfn += pfninc)
>  		set_pte(&pbase[i], pfn_pte(pfn, canon_pgprot(ref_prot)));
>  
> -	if (pfn_range_is_mapped(PFN_DOWN(__pa(address)),
> -				PFN_DOWN(__pa(address)) + 1))
> -		split_page_count(level);
> +	if (virt_addr_valid(address)) {
> +		if (pfn_range_is_mapped(PFN_DOWN(__pa(address)),
> +					PFN_DOWN(__pa(address)) + 1))
> +			split_page_count(level);

Maybe make it a bit more readable:

	if (virt_addr_valid(address)) {
		unsigned long pfn = PFN_DOWN(__pa(address));

		if (pfn_range_is_mapped(pfn, pfn + 1))
			split_page_count(level);
	}


But yeah, patch makes sense to me.

Thanks for fixing that!

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
