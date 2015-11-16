From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 1/5] x86/mm/pageattr: Ensure cpa->pfn only contains
 page frame numbers
Date: Mon, 16 Nov 2015 07:56:17 -0800
Message-ID: <5649FCA1.1000600@intel.com>
References: <1447538451-5793-1-git-send-email-matt@codeblueprint.co.uk>
 <1447538451-5793-2-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447538451-5793-2-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

I'm glad you're looking at this. It obviously needed some love. :)

On 11/14/2015 02:00 PM, Matt Fleming wrote:
> +	npages = (_end - _text) >> PAGE_SHIFT;
> +	text = __pa(_text);
> +	pfn = text >> PAGE_SHIFT;
> +
> +	if (kernel_map_pages_in_pgd(pgd, pfn, text, npages, 0)) {
> +		pr_err("Failed to map kernel text 1:1\n");
> +		return 1;
> +	}

Are _end and _text guaranteed to be aligned?  If not, I think the
calculation might be wrong.  Just for fun, imagine that _end=0xfff and
_text=0x1001.  npages would be 0.

Some other code like set_kernel_text_rw() does alignment on _text.

One nit is that there's quite a bit going on here, like rearranging the
phys_stack arithmetic ordering that is far beyond just simplifying the
paddr vs. pfn issue, but that isn't called out in the changelog at all.

Your fixes all look correct to me, fwiw.
