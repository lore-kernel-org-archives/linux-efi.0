From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [RFC][PATCH 03/11] x86/mm/pageattr: Make
 __lookup_address_in_pgd() global
Date: Thu, 30 Jan 2014 17:36:31 +0100
Message-ID: <20140130163631.GF23342@pd.tnic>
References: <1391012637-4839-1-git-send-email-matt@console-pimps.org>
 <1391012637-4839-4-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1391012637-4839-4-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Jan 29, 2014 at 04:23:49PM +0000, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Now that we have EFI-specific page tables we need to lookup the pgd when
> dumping those page tables, rather than assuming that swapper_pgdir is
> the current pgdir.
> 
> Remove the double underscore prefix, which is usually reserved for
> static functions.
> 
> Cc: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
> Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Good, like the show_fault_oops() improvement.

Acked-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>

Btw, the commit title

"x86/mm/pageattr: Make __lookup_address_in_pgd() global"

doesn't give the patch its due credit. I'd say

"x86/mm/pageattr: Always dump the right page table in an oopsie"

or so.

> ---
>  arch/x86/include/asm/pgtable_types.h |  2 ++
>  arch/x86/mm/fault.c                  |  7 ++++++-
>  arch/x86/mm/pageattr.c               | 12 ++++++++----
>  3 files changed, 16 insertions(+), 5 deletions(-)

...

> @@ -365,7 +369,7 @@ static pte_t *__lookup_address_in_pgd(pgd_t *pgd, unsigned long address,
>   */
>  pte_t *lookup_address(unsigned long address, unsigned int *level)
>  {
> -        return __lookup_address_in_pgd(pgd_offset_k(address), address, level);
> +        return lookup_address_in_pgd(pgd_offset_k(address), address, level);

Looks like I've introduced some whitespace booboo here:

ERROR: code indent should use tabs where possible
#57: FILE: arch/x86/mm/pageattr.c:372:
+        return lookup_address_in_pgd(pgd_offset_k(address), address, level);$

WARNING: please, no spaces at the start of a line
#57: FILE: arch/x86/mm/pageattr.c:372:
+        return lookup_address_in_pgd(pgd_offset_k(address), address, level);$

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
