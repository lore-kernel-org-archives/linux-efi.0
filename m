From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/4] x86: use correct early_[mem,io][re,un]map pairs
Date: Thu, 26 Feb 2015 15:50:11 +0800
Message-ID: <20150226075011.GA6207@darkstar.redhat.com>
References: <1424769211-11378-1-git-send-email-jgross@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1424769211-11378-1-git-send-email-jgross-IBi9RG/b67k@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 02/24/15 at 10:13am, Juergen Gross wrote:
> Areas mapped via early_memremap() should be unmapped via
> early_memunmap(), while I/O-areas should be mapped via early_ioremap()
> and unmapped via early_iounmap().
> 
> There are multiple spots where an area is mapped via the mem variant
> and unmapped via the io variant. This series corrects this by using
> the appropriate variants.
> 
> Juergen Gross (4):
>   x86: use early_memunmap in arch/x86/kernel/devicetree.c
>   x86: use early_memunmap in arch/x86/kernel/e820.c
>   x86: use early_memunmap in arch/x86/kernel/setup.c
>   x86, efi: use early_ioremap in arch/x86/platform/efi/efi-bgrt.c
> 
>  arch/x86/kernel/devicetree.c     | 4 ++--
>  arch/x86/kernel/e820.c           | 2 +-
>  arch/x86/kernel/setup.c          | 8 ++++----
>  arch/x86/platform/efi/efi-bgrt.c | 4 ++--
>  4 files changed, 9 insertions(+), 9 deletions(-)

Acked-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thanks
Dave
