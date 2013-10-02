From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
Date: Wed, 02 Oct 2013 10:32:19 -0700
Message-ID: <524C58A3.4090704@zytor.com>
References: <1379602494-26684-1-git-send-email-bp@alien8.de> <1379602494-26684-12-git-send-email-bp@alien8.de> <20130921113929.GB1587@pd.tnic> <20130922123515.GA7476@dhcp-16-126.nay.redhat.com> <20130922133722.GC28718@pd.tnic> <1ba7eca6-419c-4181-9927-9ba0927a6abf@email.android.com> <20130924025209.GA5561@dhcp-16-126.nay.redhat.com> <2d27a1bc-eabf-4d45-8303-27ae58511b11@email.android.com> <20131002100426.GB20568@pd.tnic> <524C3F38.6050507@zytor.com> <20131002170522.GA20647@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131002170522.GA20647-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 10/02/2013 10:05 AM, Borislav Petkov wrote:
> 
> Btw, Matt just found another issue with the bottom-up approach - due to
> different alignment of VA and PA addresses, this messes up the pagetable
> in terms of the order in which we're using 4K, 2M, etc pages.
> 
> What can happen is that, you can get a non-2M aligned PA mapped with
> 2M-aligned VA which results in a #PF with PF_RSVD set, which most likely
> happens because one or more of the bits in the [12:20] slice of the PMD
> are reserved but they get set due to the PA having address bits set in
> the aforementioned slice and thus a #PF is raised.
> 

So this is a bug in the sense that 2M pages were used when they were not
safe to use (matching alignment is part of the requirement for 2M pages
being allowable.)  However, we of course want to use 2M pages, so see below.

> So we changed the mapping method to a more straight-forward one: we map
> all EFI regions in the following range:
> 
> [ efi_va - -4G ]
> 
> and we compute efi_va by subtracting the highest EFI region address from
> -4G, i.e. 0xffff_ffff_0000_0000.
> 
> Then, each VA is computed by doing efi_va + PA.
> 
> Oh, and the alignment remains compatible this way.
> 
> So this mapping scheme - courtesy of Matt - is very straight-forward
> and simple and I like simple. This way we won't need the setup_data
> games with kexec tools as we'll be simply doing the same mappings in the
> kexec'ed kernel.
> 
> Anyway, I'll clean up the patch and send it out later.
> 

We could achieve the same thing by doing alignment after subtracting the
pointer.  HOWEVER, it also goes to show that any mapping scheme is
inherently fragile (consider if the mapping scheme above ends up
consuming too much virtual space in the future), and as a result I
really think that explicitly passing the map to the kexec kernel really
is the only sane thing to do, as otherwise we have to maintain the same
algorithm forever.

	-hpa
