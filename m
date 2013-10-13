From: Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH 12/12] EFI: Runtime services virtual mapping
Date: Sun, 13 Oct 2013 11:06:03 +0800
Message-ID: <20131013030602.GA1914@darkstar.nay.redhat.com>
References: <20131008164551.GB16793@pd.tnic>
 <20131008164831.GD16793@pd.tnic>
 <20131010080635.GA3692@dhcp-16-126.nay.redhat.com>
 <20131010081434.GB3692@dhcp-16-126.nay.redhat.com>
 <20131010085827.GA9929@pd.tnic>
 <20131010123453.GA12321@console-pimps.org>
 <20131011062437.GA14115@dhcp-16-126.nay.redhat.com>
 <20131011074144.GA18719@pd.tnic>
 <20131012075443.GD7550@dhcp-16-126.nay.redhat.com>
 <20131012101308.GI12321@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131012101308.GI12321@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>
Cc: Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>, "H. Peter Anvin" <hpa@zytor.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org, fwts-devel@lists.ubuntu.com
List-Id: linux-efi@vger.kernel.org

On Sat, Oct 12, 2013 at 11:13:08AM +0100, Matt Fleming wrote:
> On Sat, 12 Oct, at 03:54:44PM, Dave Young wrote:
> > Boris:
> > 
> > For the boot service region overlapping problem I have another idea,
> > how about modify your mapping code to always mapping the RUNTIME region
> > (non boot service region) firstly from the efi_va, then mapping other
> > regions in order, in this way kexec 2nd kernel will be happy because
> > it does not call SetVirtualAddressMap and it does not need the boot
> > service area at all.
> 
> Coalescing the runtime regions together implies that the second kernel
> would care about the fragmentation caused by unmapping the boot service
> regions - it shouldn't. We've sliced up a considerable chunk of kernel
> virtual address space (64G) and fragmentation shouldn't be an issue
> right now.
> 
> Even if we run out of address space in the future due to fragmentation,
> and end up needing to coalesce runtime regions, this would be
> transparent to the kexec kernel because it's passed the memmap entries
> through setup_data.

Ok, so passing setup_data looks better like hpa said previously.

> 
> Though we are defining an ABI around the EFI address range
> (0xffffffef00000000 - 0xffffffff00000000), such that it needs to be the
> same between kernels, we must not make the layout of regions within that
> range part of the ABI. We need the freedom to change the layout in the
> future.

Agree.

> 
> -- 
> Matt Fleming, Intel Open Source Technology Center
