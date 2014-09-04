From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [REGRESSION] "efi: efistub: Convert into static library" and
 preparation patches
Date: Thu, 4 Sep 2014 21:12:25 +0200
Message-ID: <CAKv+Gu8wALTqtNQK_855A7M5f2a+EB1JyLxo=j6G0T1cf8ZFog@mail.gmail.com>
References: <5405E186.2080406@canonical.com>
	<20140902192941.GB3001@console-pimps.org>
	<CAKv+Gu_eSe+FeNkGm+w3sSsRn2_hr70xLVBieZgyhawAv6PQvw@mail.gmail.com>
	<5406D0DB.90401@canonical.com>
	<CAKv+Gu8OD3p+GSwB+SPRf3pKwZB2R1t6x1zK7czGCXj1QhB7_g@mail.gmail.com>
	<54073409.6030004@canonical.com>
	<CAKv+Gu9q1qTh6DZXsCG2tGVBn-uwuQKQa_6FEMmchDVFi5vJtw@mail.gmail.com>
	<20140903175948.GH3001@console-pimps.org>
	<CAKv+Gu9tejixb3Kb3YM_7sLcpKNuRHN+Dn+twFyCAXx99wYRCw@mail.gmail.com>
	<54084376.8090002@canonical.com>
	<540860F1.6060801@fensystems.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <540860F1.6060801-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Cc: Maarten Lankhorst <maarten.lankhorst-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Ulf Winkelvos <ulf-rS3t9PEbhQ0OIzVOb1FTxg@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 4 September 2014 14:54, Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org> wrote:
> On 04/09/14 11:48, Maarten Lankhorst wrote:
>>>>
>>>> If not, Ard please go ahead with option #2 above. Overkill yes, but I've
>>>> done the single __attribute__() hacks in other projects and someone
>>>> (usually me) always eventually forgets to tag some instance.
>>>>
>>> It appears we just got lucky on arm64, since we don't have any global
>>> variables, but the issue does exist there as well.
>>>
>> FWIW, visibility pushing doesn't seem to work for functions declared with
>> extern.
>> Following seems to get rid of all GOTPCREL:
>
>
> Are you sure?  The iPXE build process relies on this:
>
>   /* Force visibility of all symbols to "hidden", i.e. inform gcc that
>    * all symbol references resolve strictly within our final binary.
>    * This avoids unnecessary PLT/GOT entries on x86_64.
>    *
>    * This is a stronger claim than specifying "-fvisibility=hidden",
>    * since it also affects symbols marked with "extern".
>    */
>   #ifndef ASSEMBLY
>   #if __GNUC__ >= 4
>   #pragma GCC visibility push(hidden)
>   #endif
>   #endif /* ASSEMBLY */
>
> and https://gcc.gnu.org/wiki/Visibility states that
>
>   "#pragma GCC visibility is stronger than -fvisibility; it affects extern
> declarations as well. -fvisibility only affects definitions, so that
> existing code can be recompiled with minimal changes. This is more true for
> C than C++; C++ interfaces tend use classes, which are affected by
> -fvisibility."
>

This is exactly the reason I suggested using the #pragma in the first
place, only you need to take care to put it before #includes or it
won't apply to extern declarations contained in those.

But my later suggestion was to apply the attribute to extern
declarations explicitly, it is probably more portable, and if we can
assert that the GOT is empty, we can easily spot new ones popping up
before they make it into the tree.
Since Maarten's research seems to suggest that using the visibility
attribute is feasible as it dates back to the GCC 3.x days, I will go
ahead and implement the fix I suggested.

-- 
Ard.
