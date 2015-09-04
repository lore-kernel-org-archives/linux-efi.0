From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] acpi, apei: use appropriate pgprot_t to map GHES
 memory
Date: Fri, 4 Sep 2015 13:36:00 +0200
Message-ID: <20150904113559.GA21396@gmail.com>
References: <1440523642-31373-1-git-send-email-zjzhang@codeaurora.org>
 <20150904112820.GB2737@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150904112820.GB2737-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:

> On Tue, 25 Aug, at 10:27:22AM, Jonathan (Zhixiong) Zhang wrote:
> > From: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> > 
> > If the ACPI APEI firmware handles hardware error first (called "firmware
> > first handling"), the firmware updates the GHES memory region with hardware
> > error record (called "generic hardware error record"). Essentially the
> > firmware writes hardware error records in the GHES memory region, triggers
> > an NMI/interrupt, then the GHES driver goes off and grabs the error record
> > from the GHES region.
> > 
> > The kernel currently maps the GHES memory region as cacheable
> > (PAGE_KERNEL) for all architectures. However, on some arm64 platforms,
> > there is a mismatch between how the kernel maps the GHES region
> > (PAGE_KERNEL) and how the firmware maps it (EFI_MEMORY_UC, ie.
> > uncacheable), leading to the possibility of the kernel GHES driver
> > reading stale data from the cache when it receives the interrupt.
> > 
> > With stale data being read, the kernel is unaware there is new hardware
> > error to be handled when there actually is; this may lead to further damage
> > in various scenarios, such as error propagation caused data corruption.
> > If uncorrected error (such as double bit ECC error) happened in memory
> > operation and if the kernel is unaware of such event happening, errorneous
> > data may be propagated to the disk.
> > 
> > Instead GHES memory region should be mapped with page protection type
> > according to what is returned from arch_apei_get_mem_attribute().
> > 
> > Reviewed-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> > Acked-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
> > Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> > ---
> >  drivers/acpi/apei/ghes.c | 10 +++++++---
> >  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> This patch message looks fine to me. Ingo?

Looks good to me too!

Thanks,

	Ingo
