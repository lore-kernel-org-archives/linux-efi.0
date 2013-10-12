From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 12/12] EFI: Runtime services virtual mapping
Date: Sat, 12 Oct 2013 15:54:44 +0800
Message-ID: <20131012075443.GD7550@dhcp-16-126.nay.redhat.com>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <20131008164551.GB16793@pd.tnic>
 <20131008164831.GD16793@pd.tnic>
 <20131010080635.GA3692@dhcp-16-126.nay.redhat.com>
 <20131010081434.GB3692@dhcp-16-126.nay.redhat.com>
 <20131010085827.GA9929@pd.tnic>
 <20131010123453.GA12321@console-pimps.org>
 <20131011062437.GA14115@dhcp-16-126.nay.redhat.com>
 <20131011074144.GA18719@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131011074144.GA18719-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fwts-devel-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 10/11/13 at 09:41am, Borislav Petkov wrote:
> On Fri, Oct 11, 2013 at 02:24:37PM +0800, Dave Young wrote:
> > But for current implementation from Boris, getting same mapping
> > between diffrent kernel depends on same md order (same start and
> > size for each one) How about using this mapping solution but at the
> > same time for kexec kernel we also pass the virtual mappings via
> > setup_data, only thing diffrent is we only need map the non boot
> > region and just use the boot region size to ensure the other regions
> > are mapped with same virtual address.
> 
> Actually, as hpa suggested, we will need to be passing the explicit
> virtual addresses to the kexec kernel in case we change the mapping
> algorithm in the future. So all should go through setup_data.
> 
> > OTOH, if we only passing ioremapped data without Boris's current patch
> > the problem I worry about is how can we ensure the addresses are not
> > used by other code before we mapping the in 2nd kernel efi_init.
> 
> Right, the old method of mapping EFI runtime regions used ioremap and
> was mapping the regions in the same address space. Now we have reserved
> a 64G in the VA space ending at -4G (i.e. 0xffff_ffff_0000_0000) which
> is reserved only for EFI RT usage.

Boris:

For the boot service region overlapping problem I have another idea,
how about modify your mapping code to always mapping the RUNTIME region
(non boot service region) firstly from the efi_va, then mapping other
regions in order, in this way kexec 2nd kernel will be happy because
it does not call SetVirtualAddressMap and it does not need the boot
service area at all.

Thanks
Dave
