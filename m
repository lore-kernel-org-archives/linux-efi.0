From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [REGRESSION] "efi: efistub: Convert into static library" and
 preparation patches
Date: Wed, 03 Sep 2014 14:47:32 -0700
Message-ID: <54078C74.2060804@zytor.com>
References: <5405E186.2080406@canonical.com> <20140902192941.GB3001@console-pimps.org> <CAKv+Gu_eSe+FeNkGm+w3sSsRn2_hr70xLVBieZgyhawAv6PQvw@mail.gmail.com> <5406D0DB.90401@canonical.com> <CAKv+Gu8OD3p+GSwB+SPRf3pKwZB2R1t6x1zK7czGCXj1QhB7_g@mail.gmail.com> <54073409.6030004@canonical.com> <CAKv+Gu9q1qTh6DZXsCG2tGVBn-uwuQKQa_6FEMmchDVFi5vJtw@mail.gmail.com> <20140903175948.GH3001@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140903175948.GH3001-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Maarten Lankhorst <maarten.lankhorst-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Ulf Winkelvos <ulf-rS3t9PEbhQ0OIzVOb1FTxg@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> 
> Any reason we can't reuse the existing GOT fixup code in the early x86
> boot code? We're not executing it before the EFI boot stub atm, which is
> the reason Maarten is hitting these difficulties.
> 
> Maarten, does the following help?
> 
> If not, Ard please go ahead with option #2 above. Overkill yes, but I've
> done the single __attribute__() hacks in other projects and someone
> (usually me) always eventually forgets to tag some instance.
> 

I think we really have two options: either fix up the GOT (which may be
a null operation, if the GOT is empty) or we add a compile-time check
that the GOT is empty, lest we will keep having these problems.

Since the GOT fixup loop is only a few instructions, it doesn't seem to
be all that problematic to just do it -- but make sure we don't end up
running it twice on any code path!

	-hpa
