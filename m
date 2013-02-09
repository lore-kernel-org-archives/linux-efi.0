From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
Date: Fri, 08 Feb 2013 17:22:20 -0800
Message-ID: <5115A4CC.3080102@zytor.com>
References: <20130208191213.GA25081@www.outflux.net>  <00780235-deac-4f80-b936-867834e05661@email.android.com>  <CAGXu5jJnLY6Qp3J6HBpVg-AdUGdKYm-e4wErZO3=NuRo04ajvg@mail.gmail.com>  <5115553A.5000708@zytor.com>  <CAGXu5j+_mGzR+72YqORhErMUY1aF1H2urczZ8SwuJHZK-oZL6g@mail.gmail.com>  <dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>  <CAGXu5jLAufTRm=sDST0br_WEkn4o0Hpjv2jDP2Na=cCvuM+MGg@mail.gmail.com>  <1360355671.18083.18.camel@x230.lan>  <CAGXu5jKo2PfMBO4A0ZgQcrPuj8OHNaff+CjAesOAWkZc0vB9+Q@mail.gmail.com>  <51157C9C.6030501@zytor.com> <20130208230655.GB28990@pd.tnic> <1360366012.18083.21.camel@x230.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1360366012.18083.21.camel-+5W/JHIUVxg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 02/08/2013 03:26 PM, Matthew Garrett wrote:
> On Sat, 2013-02-09 at 00:06 +0100, Borislav Petkov wrote:
>> On Fri, Feb 08, 2013 at 02:30:52PM -0800, H. Peter Anvin wrote:
>>> Also, keep in mind that there is a very simple way to deny MSR access
>>> completely, which is to not include the driver in your kernel (and not
>>> allow module loading, but if you can load modules you can just load a
>>> module to muck with whatever MSR you want.)
>>
>> I was contemplating that too. What is the use case of having
>> msr.ko in a secure boot environment? Isn't that an all-no-tools,
>> you-can't-do-sh*t-except-what-you're-explicitly-allowed-to environment which
>> simply doesn't need to write MSRs in the first place?
> 
> Well, sure, distributions could build every kernel twice. That seems a
> little excessive, though.
> 

You don't have to build the kernel twice to exclude a loadable module.

	-hpa
