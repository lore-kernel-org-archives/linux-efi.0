From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v7 01/10] arch/ia64: Define early_memunmap()
Date: Mon, 7 Jul 2014 15:50:16 +0100
Message-ID: <20140707145016.GB2914@console-pimps.org>
References: <1404150784-27921-1-git-send-email-daniel.kiper@oracle.com>
 <1404150784-27921-2-git-send-email-daniel.kiper@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1404150784-27921-2-git-send-email-daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tony Luck <tony.luck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, andrew.cooper3-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, eshelton-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org, fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, jbeulich-IBi9RG/b67k@public.gmane.org, jeremy-TSDbQ3PG+2Y@public.gmane.org, konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 30 Jun, at 07:52:55PM, Daniel Kiper wrote:
> This is odd to use early_iounmap() function do tear down mapping
> created by early_memremap() function, even if it works right now,
> because they belong to different set of functions. The former is
> I/O related function and the later is memory related. So, create
> early_memunmap() macro which in real is early_iounmap(). This
> thing will help to not confuse code readers longer by mixing
> functions from different classes.
> 
> EFI patches following this patch uses that functionality.
> 
> Signed-off-by: Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/ia64/include/asm/io.h |    1 +
>  1 file changed, 1 insertion(+)

Tony, this looks pretty straight forward but I'd be much obliged if you
could give me an Acked-by.

-- 
Matt Fleming, Intel Open Source Technology Center
