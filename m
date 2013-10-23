From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 12/12] EFI: Runtime services virtual mapping
Date: Wed, 23 Oct 2013 10:17:31 +0800
Message-ID: <20131023021730.GE4594@dhcp-16-126.nay.redhat.com>
References: <20131012075443.GD7550@dhcp-16-126.nay.redhat.com>
 <20131012101308.GI12321@console-pimps.org>
 <20131012103054.GA13739@pd.tnic>
 <20131013031126.GB1914@darkstar.nay.redhat.com>
 <20131013092521.GA22866@pd.tnic>
 <20131014155851.GJ4009@pd.tnic>
 <20131021124739.GA4515@dhcp-16-126.nay.redhat.com>
 <20131021133741.GA5716@nazgul.tnic>
 <20131021150426.GB4515@dhcp-16-126.nay.redhat.com>
 <20131022111857.GA10660@nazgul.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131022111857.GA10660-K5JNixvcfoxupOikMc4+xw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fwts-devel-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 10/22/13 at 01:18pm, Borislav Petkov wrote:
> On Mon, Oct 21, 2013 at 11:04:26PM +0800, Dave Young wrote:
> > > You need this to map the runtime regions in the kexec kernel, right?
> > > Please write that in the commit message.
> > 
> > Yes, will do
> 
> Ok, but but, why doesn't the normal code path in efi_enter_virtual_mode
> work anymore? I mean, why do you need another function instead of doing
> what you did previously:
> 
> 	if (!kexec)
> 		phys_efi_set_virtual_address_map(...)
> 
> The path up to here does the mapping already anyway so you only need to
> do the mapping in the kexec kernel and skip set set_virtual_map thing.

Hi,

The reason is that I only pass runtime regions from 1st kernel to kexec
kernel, your efi mapping function uses the region size to determin the 
virtual address from top to down. Because the passed-in md ranges in kexec
kernel are different from ranges booting from firmware so the virtual address
will be different.

Even I pass the whole untouched ranges including BOOT_SERVICE there's still
chance the function for reserving boot regions overwrite the boot region
size to 0, and 1st kernel will leave it to be used as normal memory after efi init.
I think we have talked about this issue previously.

Thanks
Dave


> 
> Thanks.
