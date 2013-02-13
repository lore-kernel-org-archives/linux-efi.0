From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
Date: Wed, 13 Feb 2013 09:20:46 -0800
Message-ID: <511BCB6E.8080102@zytor.com>
References: <dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>     <CAGXu5jLAufTRm=sDST0br_WEkn4o0Hpjv2jDP2Na=cCvuM+MGg@mail.gmail.com>     <1360355671.18083.18.camel@x230.lan>     <CAGXu5jKo2PfMBO4A0ZgQcrPuj8OHNaff+CjAesOAWkZc0vB9+Q@mail.gmail.com>     <51157C9C.6030501@zytor.com> <20130208230655.GB28990@pd.tnic>     <1360366012.18083.21.camel@x230.lan> <5115A4CC.3080102@zytor.com>     <1360373383.18083.23.camel@x230.lan>     <CAGXu5j+xvJ3L5ejxtZ-Jw3F6rV7OsrE0_HZCGu_er0rH2_PwKA@mail.gmail.com>     <20130209092925.GA17728@pd.tnic> <1360422712.18083.24.camel@x230.lan>    <511AE2CC.5040705@zytor.com> <1360733962.18083.30.camel@x230.lan>   <511B2EB9.5070406@zytor.com> <1360736860.18083.33.camel@x230.lan>  <511B33BC.9080307@zytor.com> <1360737709.18083.36.camel@x230.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1360737709.18083.36.camel-+5W/JHIUVxg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 02/12/2013 10:41 PM, Matthew Garrett wrote:
> On Tue, 2013-02-12 at 22:33 -0800, H. Peter Anvin wrote:
>
>> That is just batshit crazy.  If you have CAP_SYS_RAWIO you can do iopl()
>> which means you can reprogram your northbridge, at which point you most
>> definitely *can* modify the running kernel.
>
> Well right, that's the point of this patchset - it adds some extra
> permission checks to some of the existing CAP_SYS_RAWIO checks.
> CAP_SYS_RAWIO hasn't meant "I can perform arbitrary pio and mmio" for
> years - it means "I can do things that might maybe break something
> somehow". So sure, removing CAP_SYS_RAWIO would give us basically all
> the security we want in a secure boot environment, but it would also
> block things that we *want* to work.
>

So, let 's see...

Problem:

Someone adds SYS_CAP_RAWIO to some places it definitely does not
belong.

Solution:

Break all the *appropriate* (as defined)uses of SYS_CAP_RAWIO?

What the heck?

	-hpa



-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
