From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] arm64: add EFI runtime services
Date: Tue, 10 Dec 2013 12:58:02 -0500
Message-ID: <1386698282.1979.44.camel@deneb.redhat.com>
References: <1385762712-17043-1-git-send-email-msalter@redhat.com>
	 <1385762712-17043-4-git-send-email-msalter@redhat.com>
	 <20131209135158.GH24997@rocoto.smurfnet.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131209135158.GH24997-GZEopFhza0F985/tl1ce8aaDwS/vmuI7@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 2013-12-09 at 14:52 +0100, Leif Lindholm wrote:
> Apologies for late feedback.
> 
> On Fri, Nov 29, 2013 at 05:05:12PM -0500, Mark Salter wrote:
> > diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> > new file mode 100644
> > index 0000000..1bad8a7
> > --- /dev/null
> > +++ b/arch/arm64/kernel/efi.c
> > @@ -0,0 +1,507 @@
> > +/*
> > + * Extensible Firmware Interface
> > + *
> > + * Based on Extensible Firmware Interface Specification version 2.3.1
> 
> Actually, for arm64, we're relying on UEFI 2.4 or later.

You're right.

> 
> > + *
> > + * Copyright (C) 2013 Linaro Ltd.
> 
> And I'd say you've easily done enough here to motivate adding Red Hat.
> 
> > + *
> > + * Adapted for arm64 from arch/arm/kernel/efi.c code
> > + */
> > +
> > +#include <linux/efi.h>
> > +#include <linux/export.h>
> > +#include <linux/memblock.h>
> > +#include <linux/of.h>
> > +#include <linux/of_fdt.h>
> > +#include <linux/sched.h>
> > +#include <linux/slab.h>
> > +#include <linux/bootmem.h>
> > +
> > +#include <asm/cacheflush.h>
> > +#include <asm/efi.h>
> > +#include <asm/tlbflush.h>
> > +#include <asm/mmu_context.h>
> > +
> > +#define efi_early_remap(a, b) \
> > +	((__force void *)early_ioremap((a), (b)))
> 
> Do we not want early_memremap() here, rather than early_ioremap()?
> 

Yes.
