From: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] x86/efi: Correct a tiny mistake in code comment
Date: Wed, 8 Mar 2017 18:17:50 +0800
Message-ID: <20170308101750.GD6570@x1>
References: <1488959258-4731-1-git-send-email-bhe@redhat.com>
 <20170308081812.GA12600@dhcp-128-65.nay.redhat.com>
 <CACi5LpOjxiiCEvdOHGxHj_c+G-W3HKHr8EgOURpZ-cb5XqQnNQ@mail.gmail.com>
 <20170308090955.GB6570@x1>
 <20170308093555.yrhygjxx4mu562lp@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170308093555.yrhygjxx4mu562lp-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 03/08/17 at 10:35am, Borislav Petkov wrote:
> On Wed, Mar 08, 2017 at 05:09:55PM +0800, Baoquan He wrote:
> > Yes, it looks better. I can repost with this change. Thanks.
> 
> No it doesn't:

All right, I will just update the code comment. Just back ported kaslr
to our OS product, people reviewed and found the upper boundary of kaslr
mm region is EFI_VA_START, that's not correct, it has to be corrected
firstly in upstream. Then found the confusion in code comment.

Change or keep it, both is fine to me.

Thanks!

> 
> #define EFI_VA_START     ( -4 * (_AC(1, UL) << 30))
> #define EFI_VA_END       (-68 * (_AC(1, UL) << 30))
> 
> That's -4G (the shift by 30) and -68G, respectively.
> 
> > > #define EFI_VA_START    _AC(0xfffffffeffffffff, UL)
> > > #define EFI_VA_END    _AC(0xffffffef00000000, UL)
> 
> That is something which I need to type into a calculator first.
> 
> Can you guys point your attention to something which is really broken
> and stop wasting your time? And there's enough really broken crap left
> and right...
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Good mailing practices for 400: avoid top-posting and trim the reply.
