From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [GIT PULL] x86/mm changes for v4.4
Date: Fri, 6 Nov 2015 14:24:47 +0100
Message-ID: <20151106132447.GB19522@pd.tnic>
References: <20151103111649.GA3477@gmail.com>
 <CA+55aFzcwO+RSLeHOwAYvjZ5AcVvD9Th2=G3R=ZQY1xf+MkDow@mail.gmail.com>
 <20151104233907.GA25925@codemonkey.org.uk>
 <CA+55aFxb14eM6b=ctq65Dx-Ujehj2dbtsVM9rrVOVfLgT=EoHg@mail.gmail.com>
 <20151105021710.GA22941@codemonkey.org.uk>
 <CA+55aFyXNFu_TfmBjGedCRujoAbhqiBcia7XOtzSq0uxbVv6MA@mail.gmail.com>
 <20151106065549.GA2031@gmail.com>
 <CALCETrU2dn4TEj_2QiCPy4Mjw6hCbB84k1RnPzx7sLNygj4D5Q@mail.gmail.com>
 <20151106130948.GD2651@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151106130948.GD2651-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, Nov 06, 2015 at 01:09:48PM +0000, Matt Fleming wrote:
> On Thu, 05 Nov, at 11:05:35PM, Andy Lutomirski wrote:
> > 
> > Admittedly, we might need to use a certain amount of care to avoid
> > interesting conflicts with the vmap mechanism.  We might need to vmap
> > all of the EFI stuff, and possibly even all the top-level entries that
> > contain EFI stuff (i.e. exactly one of them unless EFI ends up *huge*)
> > as a blank not-present region to avoid overlaps, but that's not a big
> > deal.
> 
> There shouldn't be any room for conflicting with vmap() because the VA
> region where we map EFI regions is still carved out especially for us.
> 
> Right Boris?

Yap:

ffffea0000000000 - ffffeaffffffffff (=40 bits) virtual memory map (1TB)

vs

ffffffef00000000 - ffffffff00000000 EFI region in trampoline_pgd

the new pagetable will make that issue moot too.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
