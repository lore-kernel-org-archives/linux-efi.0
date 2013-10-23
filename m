From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 12/12] EFI: Runtime services virtual mapping
Date: Wed, 23 Oct 2013 20:51:31 +0800
Message-ID: <20131023125131.GA5552@dhcp-16-126.nay.redhat.com>
References: <20131012103054.GA13739@pd.tnic>
 <20131013031126.GB1914@darkstar.nay.redhat.com>
 <20131013092521.GA22866@pd.tnic>
 <20131014155851.GJ4009@pd.tnic>
 <20131021124739.GA4515@dhcp-16-126.nay.redhat.com>
 <20131021133741.GA5716@nazgul.tnic>
 <20131021150426.GB4515@dhcp-16-126.nay.redhat.com>
 <20131022111857.GA10660@nazgul.tnic>
 <20131023021730.GE4594@dhcp-16-126.nay.redhat.com>
 <20131023122531.GA15848@nazgul.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131023122531.GA15848-K5JNixvcfoxupOikMc4+xw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fwts-devel-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 10/23/13 at 02:25pm, Borislav Petkov wrote:
> On Wed, Oct 23, 2013 at 10:17:31AM +0800, Dave Young wrote:
> > The reason is that I only pass runtime regions from 1st kernel to
> > kexec kernel, your efi mapping function uses the region size to
> > determin the virtual address from top to down. Because the passed-in
> > md ranges in kexec kernel are different from ranges booting from
> > firmware so the virtual address will be different.
> 
> Well, this shouldn't be because SetVirtualAddressMap has already fixed
> the virtual addresses for us. And if they're different, then runtime
> services won't work anyway. Or am I missing something...?

Maybe I did not explain clear enough.
Say first kernel mapping below regions:
Region A (boot service):phys_start_a size_a -> virt_start_a size_a
Region B (runtime):	phys_start_b size_b -> virt_start_b size_b

I will pass Range B into 2nd kernel
(phys_start_b, size_b, virt_start_b)

In kexed 2nd kernel, phys_start_b need to be mapped to virt_start_b
Simply use efi_map_region from your patch does not work because it
will map phys_start_b to a different virt address, isn't it?

So I need simply map according to the kexec passed in mapping addr.

Thanks
Dave
