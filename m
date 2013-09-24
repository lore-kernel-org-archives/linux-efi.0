From: Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
Date: Tue, 24 Sep 2013 16:57:31 +0800
Message-ID: <20130924085731.GI5561@dhcp-16-126.nay.redhat.com>
References: <1379602494-26684-12-git-send-email-bp@alien8.de>
 <20130921113929.GB1587@pd.tnic>
 <20130922123515.GA7476@dhcp-16-126.nay.redhat.com>
 <20130922133722.GC28718@pd.tnic>
 <1ba7eca6-419c-4181-9927-9ba0927a6abf@email.android.com>
 <20130924025209.GA5561@dhcp-16-126.nay.redhat.com>
 <2d27a1bc-eabf-4d45-8303-27ae58511b11@email.android.com>
 <20130924045705.GB5561@dhcp-16-126.nay.redhat.com>
 <20130924045818.GC5561@dhcp-16-126.nay.redhat.com>
 <20130924052334.GD5561@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130924052334.GD5561@dhcp-16-126.nay.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>, Matt Fleming <matt@console-pimps.org>, Matthew Garrett <mjg59@srcf.ucam.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 09/24/13 at 01:23pm, Dave Young wrote:
> On 09/24/13 at 12:58pm, Dave Young wrote:
> > On 09/24/13 at 12:57pm, Dave Young wrote:
> > > On 09/23/13 at 08:06pm, H. Peter Anvin wrote:
> > > > Okay... I see two problems.
> > > > 
> > > > 1. It looks like we subtract the region size after, rather than before, assigning an address.
> 
> Could you explain more about this problem? Where is the code?
> 
> > > > 
> > > > 2. The second region is assigned the same address in the secondary kernel as in the first, implying the size of the first region was somehow set to zero.
> > > 
> > > I find the reason, efi_reserve_boot_services will reserve the BOOT_SERVICE_DATA region
> > > thus the memmap size is changed to 0, so in 2nd kernel the virtual mapping addr after
> > > the md will be not same as 1st kernel, see below code:
> > >  
> > > void __init efi_map_region(efi_memory_desc_t *md)
> > > {
> > >         unsigned long size = md->num_pages << PAGE_SHIFT;
> > > 
> > >         efi_va -= size;
> > >         ^^^^^^^^^^^^^^^
> > > 	[snip]
> > > }
> > 
> > So how about just reserve BOOT_SERVICE_DATA region but keep the md.numpages as is?
> 
> Hmm, num_pages = 0 is only set when boot service region reservation is imporsible, I'm
> lost.. But there must be somewhere set the size to 0.
> 

digging more about it, it is indeed below code move the num_pages to 0:
void __init efi_reserve_boot_services(void)
{
 [snip]
                if ((start+size >= __pa_symbol(_text)
                                && start <= __pa_symbol(_end)) ||
                        !e820_all_mapped(start, start+size, E820_RAM) ||
                        memblock_is_region_reserved(start, size)) {
                        /* Could not reserve, skip it */
                        md->num_pages = 0;
 [snip]
}

During my test, the first region overlaps with kernel _text <-> _end, thus cause this issue.

I wonder if md->num_pages must be set to 0 here. If so I think we have to save the original memmap
for kexec use. Any better idea?
