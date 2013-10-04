From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
Date: Fri, 04 Oct 2013 07:43:37 -0700
Message-ID: <89e0284e-89b5-42ad-8120-128ef1bf0152@email.android.com>
References: <20130922133722.GC28718@pd.tnic> <1ba7eca6-419c-4181-9927-9ba0927a6abf@email.android.com> <20130924025209.GA5561@dhcp-16-126.nay.redhat.com> <2d27a1bc-eabf-4d45-8303-27ae58511b11@email.android.com> <20131002100426.GB20568@pd.tnic> <524C3F38.6050507@zytor.com> <20131002170522.GA20647@pd.tnic> <524C58A3.4090704@zytor.com> <20131002184229.GE20568@pd.tnic> <524C6A14.40905@zytor.com> <20131004094247.GA6796@nazgul.tnic>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131004094247.GA6796-K5JNixvcfoxupOikMc4+xw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

We can do that... but it is different from what Windows does to my understanding and it also has the potential of severe pathologies... e.g. a window at the top of the address space being mapped.

Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org> wrote:
>On Wed, Oct 02, 2013 at 11:46:44AM -0700, H. Peter Anvin wrote:
>> It's pretty straightforward - just drop the starting address to
>proper
>> alignment after you subtract the size.
>
>Ok, just an observation - it is not necessarily a bad thing but I
>thought we should talk about it:
>
>So, when we do the VA space saving mapping, we're basically mapping
>huge
>physical ranges onto a much smaller VA range and adding other mappings
>in there pots-factum could turn out to be not straight-forward and
>problematic.
>
>To illustrate what I'm trying to say, here's an example from two
>regions
>in OVMF:
>
>[    0.011005] __map_region: VA: 0xfffffffeff800000..0xffffffff00000000
>-> PA: 0x800000.. 0x1000000
>[    0.017005] __map_region: VA: 0xfffffffeff600000..0xfffffffeff620000
>-> PA: 0x7c000000.. 0x7c020000
>
>Now, the physical address range spanned by those regions is:
>
>0x7c020000 - 0x800000 = 0x7b820000 =~ 2G
>
>while the virtual is
>
>0xffffffff00000000 - 0xfffffffeff600000 = 0xa00000 =~ 10M
>
>Now, we obviously cannot map the whole PA space in there, the question
>is: do we care?
>
>I mean, we can map it to other VA range but this will totally destroy
>the simple math of computing EFI VA addresses with an offset, similar
>to
>PAGE_OFFSET.
>
>OTOH, if we keep Matt's suggestion of mapping the whole EFI address
>space window, we don't have that issue. And we've reserved 64G for
>EFI and if it needs more, we probably can give it since we're using a
>different pagetable anyway.
>
>Opinions?
>
>Thanks.

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
