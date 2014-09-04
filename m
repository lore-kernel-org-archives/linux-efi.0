From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [REGRESSION] "efi: efistub: Convert into static library" and
 preparation patches
Date: Thu, 4 Sep 2014 08:47:57 +0200
Message-ID: <CAKv+Gu8VkW+unei3vGZxor6ZGuLwsmKktcBJfy3+bKrkrKgPyw@mail.gmail.com>
References: <5405E186.2080406@canonical.com>
	<20140902192941.GB3001@console-pimps.org>
	<CAKv+Gu_eSe+FeNkGm+w3sSsRn2_hr70xLVBieZgyhawAv6PQvw@mail.gmail.com>
	<5406D0DB.90401@canonical.com>
	<CAKv+Gu8OD3p+GSwB+SPRf3pKwZB2R1t6x1zK7czGCXj1QhB7_g@mail.gmail.com>
	<54073409.6030004@canonical.com>
	<CAKv+Gu9q1qTh6DZXsCG2tGVBn-uwuQKQa_6FEMmchDVFi5vJtw@mail.gmail.com>
	<20140903175948.GH3001@console-pimps.org>
	<54078C74.2060804@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54078C74.2060804-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Maarten Lankhorst <maarten.lankhorst-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Ulf Winkelvos <ulf-rS3t9PEbhQ0OIzVOb1FTxg@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 3 September 2014 23:47, H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org> wrote:
>>
>> Any reason we can't reuse the existing GOT fixup code in the early x86
>> boot code? We're not executing it before the EFI boot stub atm, which is
>> the reason Maarten is hitting these difficulties.
>>
>> Maarten, does the following help?
>>
>> If not, Ard please go ahead with option #2 above. Overkill yes, but I've
>> done the single __attribute__() hacks in other projects and someone
>> (usually me) always eventually forgets to tag some instance.
>>
>
> I think we really have two options: either fix up the GOT (which may be
> a null operation, if the GOT is empty) or we add a compile-time check
> that the GOT is empty, lest we will keep having these problems.
>
> Since the GOT fixup loop is only a few instructions, it doesn't seem to
> be all that problematic to just do it -- but make sure we don't end up
> running it twice on any code path!
>

So how about we:
- add ASSERT(_got == _egot, "GOT entries not supported in
boot/compressed") to the linker script
- #define __nogotentry __attribute__((visibility(hidden))) somewhere
in compiler.h or wherever else it belongs
- add the __nogotentry qualifiers to each extern that requires it,
which is currently:
early_serial_base
efi_early
free_mem_end_ptr
free_mem_ptr
real_mode
- get rid of the fixup code in assembly

Any idea what the oldest GCC is we should support?

-- 
Ard.
