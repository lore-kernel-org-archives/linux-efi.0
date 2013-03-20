From: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 01/12] Security: Add CAP_COMPROMISE_KERNEL
Date: Tue, 19 Mar 2013 21:18:23 -0600
Message-ID: <1363749503.24132.482.camel@bling.home>
References: <3pfl8u1ugprwkcs5xmtjth3l.1363742692541@email.android.com>
	 <51492379.3090302@zytor.com> <51492828.5070803@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51492828.5070803-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 2013-03-19 at 20:08 -0700, H. Peter Anvin wrote:
> On 03/19/2013 07:48 PM, H. Peter Anvin wrote:
> > On 03/19/2013 06:28 PM, Matthew Garrett wrote:
> >> Mm. The question is whether we can reliably determine the ranges a
> device should be able to access without having to trust userspace
> (and, ideally, without having to worry about whether iommu vendors
> have done their job). It's pretty important for PCI passthrough, so we
> do need to care. 
> > 
> > It is actually very simple: the device should be able to DMA into/out of:
> > 
> > 1. pinned pages
> > 2. owned by the process controlling the device
> > 
> > ... and nothing else.
> > 
> 
> The "pinning" process needs to involve a call to the kernel to process
> the page for DMA (pinning the page and opening it in the iommu) and
> return a transaction address, of course.
> 
> I think we have the interface for that in vfio, but I haven't followed
> that work.

Yes, vfio does this and is meant to provide a secure-boot-friendly PCI
passthrough interface.  Thanks,

Alex
