From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 12/12] EFI: Runtime services virtual mapping
Date: Sat, 12 Oct 2013 11:13:08 +0100
Message-ID: <20131012101308.GI12321@console-pimps.org>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <20131008164551.GB16793@pd.tnic>
 <20131008164831.GD16793@pd.tnic>
 <20131010080635.GA3692@dhcp-16-126.nay.redhat.com>
 <20131010081434.GB3692@dhcp-16-126.nay.redhat.com>
 <20131010085827.GA9929@pd.tnic>
 <20131010123453.GA12321@console-pimps.org>
 <20131011062437.GA14115@dhcp-16-126.nay.redhat.com>
 <20131011074144.GA18719@pd.tnic>
 <20131012075443.GD7550@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131012075443.GD7550-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fwts-devel-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Sat, 12 Oct, at 03:54:44PM, Dave Young wrote:
> Boris:
> 
> For the boot service region overlapping problem I have another idea,
> how about modify your mapping code to always mapping the RUNTIME region
> (non boot service region) firstly from the efi_va, then mapping other
> regions in order, in this way kexec 2nd kernel will be happy because
> it does not call SetVirtualAddressMap and it does not need the boot
> service area at all.

Coalescing the runtime regions together implies that the second kernel
would care about the fragmentation caused by unmapping the boot service
regions - it shouldn't. We've sliced up a considerable chunk of kernel
virtual address space (64G) and fragmentation shouldn't be an issue
right now.

Even if we run out of address space in the future due to fragmentation,
and end up needing to coalesce runtime regions, this would be
transparent to the kexec kernel because it's passed the memmap entries
through setup_data.

Though we are defining an ABI around the EFI address range
(0xffffffef00000000 - 0xffffffff00000000), such that it needs to be the
same between kernels, we must not make the layout of regions within that
range part of the ABI. We need the freedom to change the layout in the
future.

-- 
Matt Fleming, Intel Open Source Technology Center
