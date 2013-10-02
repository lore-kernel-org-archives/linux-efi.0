From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
Date: Wed, 2 Oct 2013 12:04:26 +0200
Message-ID: <20131002100426.GB20568@pd.tnic>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <1379602494-26684-12-git-send-email-bp@alien8.de>
 <20130921113929.GB1587@pd.tnic>
 <20130922123515.GA7476@dhcp-16-126.nay.redhat.com>
 <20130922133722.GC28718@pd.tnic>
 <1ba7eca6-419c-4181-9927-9ba0927a6abf@email.android.com>
 <20130924025209.GA5561@dhcp-16-126.nay.redhat.com>
 <2d27a1bc-eabf-4d45-8303-27ae58511b11@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2d27a1bc-eabf-4d45-8303-27ae58511b11-2ueSQiBKiTY7tOexoI0I+QC/G2K4zDHf@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Sep 23, 2013 at 08:06:38PM -0700, H. Peter Anvin wrote:
> Okay... I see two problems.
> 
> 1. It looks like we subtract the region size after, rather than before, assigning an address.
> 

Ok, so I'm looking at this agan and, actually, we really do subtract the
region size *before* we assign the address:

---
       efi_va -= size;
       if (efi_va < EFI_VA_END) {
               pr_warning(FW_WARN "VA address range overflow!\n");
               return;
       }

       /*
        * Make sure the 1:1 mappings are present as a catch-all for b0rked
        * firmware which doesn't update all internal pointers after switching
        * to virtual mode and would otherwise crap on us.
        */
       __map_region(md, md->phys_addr);

       /* Do the VA map */
       __map_region(md, efi_va);
       md->virt_addr = efi_va;
--

So let me give an example why I think it is correct to subtract *before*
assigning and so that we can talk about it and we completely agree on
the details. :-)

When we start allocating from -4G, i.e. 0xffffffff00000000, I think we
want to do it bottom-up so that 0xffffffff00000000 is the *last*, i.e.
lowest address. Because we link the kernel text at 0xffffffff81000000 by
default, which would mean, if -4G was the first address, we'll have only
2G:

0xffffffff81000000 - 0xffffffff00000000 = 0x0000000081000000 = 2.164.260.864 bytes

of space for UEFI mappings.

That's why, I need to *first* subtract and *then* use the resulting
address to map the region to. Like so (4 hypothetical regions):

1st region: 0xfffffffeffffe000 - 0xffffffff00000000

2nd region: 0xfffffffeffff8000 - 0xfffffffeffffe000

3rd region: 0xfffffffefffec000 - 0xfffffffeffff8000

4th region: 0xfffffffefffd8000 - 0xfffffffefffec000

and so on...

IOW, the VA layout looks like this:

0xfffffffefffd8000
...
region 4
...
0xfffffffefffec000 (non including)
...
region 3
...
0xfffffffeffff8000 (ditto)
...
region 2
...
0xfffffffeffffe000 (ditto)
...
region 1
...
0xffffffff00000000 (ditto)

Am I even making sense here?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
