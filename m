From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
Date: Wed, 13 Feb 2013 17:08:55 -0800
Message-ID: <511C3927.90603@zytor.com>
References: <dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>       <CAGXu5jKo2PfMBO4A0ZgQcrPuj8OHNaff+CjAesOAWkZc0vB9+Q@mail.gmail.com>       <51157C9C.6030501@zytor.com> <20130208230655.GB28990@pd.tnic>       <1360366012.18083.21.camel@x230.lan> <5115A4CC.3080102@zytor.com>       <1360373383.18083.23.camel@x230.lan>       <CAGXu5j+xvJ3L5ejxtZ-Jw3F6rV7OsrE0_HZCGu_er0rH2_PwKA@mail.gmail.com>       <20130209092925.GA17728@pd.tnic> <1360422712.18083.24.camel@x230.lan>      <511AE2CC.5040705@zytor.com> <1360733962.18083.30.camel@x230.lan>     <511B2EB9.5070406@zytor.com> <1360736860.18083.33.camel@x230.lan>    <511B33BC.9080307@zytor.com> <1360737709.18083.36.camel@x230.lan>   <511BCB6E.8080102@zytor.com> <1360776399.18083.39.camel@x230.lan>  <511BD291.1040003@schaufler-ca.com> <511C13
 25.5060601@zytor.com>  <511C1A94.8020804@schaufler-ca.com> <511C2F0C.3060803@zytor.com >  <511C3389.5090604@schaufler-ca.com> <1360803872.18083.46.camel@x230.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1360803872.18083.46.camel-+5W/JHIUVxg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 02/13/2013 05:04 PM, Matthew Garrett wrote:
> On Wed, 2013-02-13 at 16:44 -0800, Casey Schaufler wrote:
> 
>> If you want that sort of granularity throw yourself on the SELinux
>> bandwagon. Fine grained capabilities are insane and unmanageable
>> and will only lead to tears. Security is despised because of the
>> notion that making systems impossible to use is a good thing.
> 
> SELinux is completely unusable for this specific case.
> 

Well, for at least things with device nodes (/dev/mem, /dev/msr and so
on) it should be possible, no?  ioperm() and iopl() are another matter.

	-hpa
