From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] x86/efi: Correct a tiny mistake in code comment
Date: Thu, 9 Mar 2017 08:48:59 +0800
Message-ID: <20170309004859.GC12600@dhcp-128-65.nay.redhat.com>
References: <1488959258-4731-1-git-send-email-bhe@redhat.com>
 <20170308081812.GA12600@dhcp-128-65.nay.redhat.com>
 <CACi5LpOjxiiCEvdOHGxHj_c+G-W3HKHr8EgOURpZ-cb5XqQnNQ@mail.gmail.com>
 <20170308090955.GB6570@x1>
 <20170308093555.yrhygjxx4mu562lp@pd.tnic>
 <20170308101750.GD6570@x1>
 <20170308105047.pggc6hai3gplsbg2@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170308105047.pggc6hai3gplsbg2-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 03/08/17 at 11:50am, Borislav Petkov wrote:
> On Wed, Mar 08, 2017 at 06:17:50PM +0800, Baoquan He wrote:
> > All right, I will just update the code comment. Just back ported kaslr
> > to our OS product, people reviewed and found the upper boundary of kaslr
> > mm region is EFI_VA_START, that's not correct, it has to be corrected
> > firstly in upstream. Then found the confusion in code comment.
> 
>         BUILD_BUG_ON(IS_ENABLED(CONFIG_X86_ESPFIX64) &&
> +                    vaddr_end >= EFI_VA_END);
> 
> so I think that once we've done the mapping, we won't need anymore VA
> space so we could simply check the range [efi_va, EFI_VA_START] instead.
> 
> However, that won't work currently because evi_va is not valid at
> build time. And it won't work at boot time either because, AFAICT,
> kernel_randomize_memory() runs before efi_enter_virtual_mode() so ...
> 
> So yours is probably OK.
> 
> I guess what's confusing there is the naming - EFI_VA_START and
> EFI_VA_END. They're kinda swapped because of the direction we take when
> we start mapping runtime services, i.e., from the higher (unsigned)
> address to lower.
> 
> I guess we could swap the naming so that it doesn't confuse people but
> that would be up to EFI maintainers.
> 
> Then stuff like that:
> 
> # ifdef CONFIG_EFI
>         { EFI_VA_END,           "EFI Runtime Services" },
> # endif
> 
> will make more sense when they are:
> 
> # ifdef CONFIG_EFI
>         { EFI_VA_START,           "EFI Runtime Services" },
> # endif
> 
> But changing it now could confuse more people who have the current
> mental picture of the mapping direction so I'd vote for the simple fix
> above.

People should understand the meaning of the macro then use it correctly,
one should not assume START == lower address unless they are sure. 

> 
> Again, as previously, this is a maintainer decision.
> 

Personally I think current way is just fine, but agreed it is up to efi
maintainer. 

Thanks
Dave
