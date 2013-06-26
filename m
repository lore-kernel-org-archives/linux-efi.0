From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/4] Documentation: arm: [U]EFI runtime services
Date: Wed, 26 Jun 2013 16:04:59 +0200
Message-ID: <20130626140459.GB9078@rocoto.smurfnet.nu>
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org>
 <1372183863-11333-2-git-send-email-leif.lindholm@linaro.org>
 <CACxGe6tUpo31p6N0BZt_jdonuPP8ijvLBygC76wQ044EFsqOwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CACxGe6tUpo31p6N0BZt_jdonuPP8ijvLBygC76wQ044EFsqOwA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Jun 26, 2013 at 02:13:39PM +0100, Grant Likely wrote:
> > diff --git a/Documentation/arm/uefi.txt b/Documentation/arm/uefi.txt
> > +It (early) parses the FDT for the following parameters:
> 
> Need to state which node these properties can be found in. I recommend /chosen

Will do.
 
> I would also prefix all of the following properties with "linux,"
> since they are very much about what the Linux kernel needs for
> booting. EFI stub will be creating these properties specifically for
> Linux, and the LinuxLoader should do the same (until we eventually
> kill it).
 
And that.

> > +- 'efi-system-table':
> > +  Physical address of the system table. (required)
> 
> Need to mention the size of this address. Is it 64 bit or 32 bit? I
> would follow the lead of 'linux,initrd-start' here and make the size
> of property the size of the address. ie. If it is 8 bytes long, then
> it is a 64 bit address.
 
Currently, it's a 4-byte address.
Although technically possible to be >32-bit in an LPAE system, the 1:1
mappign requirement of the UEFI spec forces it to reside in the lower
4GB on a 32-bit system.

> > +- 'efi-runtime-mmap':
> > +  Physical address of an EFI memory map, containing at least
> > +  the regions to be preserved. (required)
> > +- 'efi-runtime-mmap-size':
> > +  Size in bytes of the provided memory map. (required)
> 
> I would collapse the above two properties into a single property that
> actually contains the memory map instead of pointing to it. You will
> also need to specify the exact format of the data in this property.
 
Ok, that makes sense.

Hmm. The data is an array of struct EFI_MEMORY_DESCRIPTOR entries,
known in Linux as efi_memory_desc_t. Is that a good enough description?

> > +- 'efi-mmap-desc-size':
> > +  Size of each descriptor in the memory map. (override default)
> > +- 'efi-mmap-desc-ver':
> > +  Memory descriptor format version. (override default)
> 
> I don't understand how these properties will actually work. What
> changes in the parsing if these properties are set?
 
I guess the intended use is that these options would permit you to
append new fields to the struct and have old code correctly parse the
array anyway.

/
    Leif
