From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 14/14] x86/efi: Print size in binary units in
 efi_print_memmap
Date: Wed, 3 Feb 2016 11:40:45 +0100
Message-ID: <20160203104045.GB7310@gmail.com>
References: <1454364428-494-1-git-send-email-matt@codeblueprint.co.uk>
 <1454364428-494-15-git-send-email-matt@codeblueprint.co.uk>
 <56B0756E.9010603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56B0756E.9010603@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Laszlo Ersek <lersek@redhat.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Robert Elliott <elliott@hpe.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-efi@vger.kernel.org


* Laszlo Ersek <lersek@redhat.com> wrote:

> I'll take being CC'd as "please offer an opinion", so I'll offer one. :)
> 
> On 02/01/16 23:07, Matt Fleming wrote:
> > From: Robert Elliott <elliott@hpe.com>
> > 
> > Print the size in the best-fit B, KiB, MiB, etc. units rather than
> > always MiB. This avoids rounding, which can be misleading.
> > 
> > Use proper IEC binary units (KiB, MiB, etc.) rather than misuse SI
> > decimal units (KB, MB, etc.).
> > 
> > old:
> >     efi: mem61: [Persistent Memory  |   |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff) (16384MB)
> > 
> > new:
> >     efi: mem61: [Persistent Memory  |   |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff] (16 GiB)
> > 
> > Signed-off-by: Robert Elliott <elliott@hpe.com>
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
> > Cc: Laszlo Ersek <lersek@redhat.com>
> > Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
> > ---
> >  arch/x86/platform/efi/efi.c | 25 ++++++++++++++++++-------
> >  1 file changed, 18 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> > index e80826e6f3a9..2c457c5e8203 100644
> > --- a/arch/x86/platform/efi/efi.c
> > +++ b/arch/x86/platform/efi/efi.c
> > @@ -35,6 +35,7 @@
> >  #include <linux/efi.h>
> >  #include <linux/efi-bgrt.h>
> >  #include <linux/export.h>
> > +#include <linux/bitops.h>
> >  #include <linux/bootmem.h>
> >  #include <linux/slab.h>
> >  #include <linux/memblock.h>
> > @@ -117,6 +118,17 @@ void efi_get_time(struct timespec *now)
> >  	now->tv_nsec = 0;
> >  }
> >  
> > +static char * __init efi_size_format(char *buf, size_t size, u64 bytes)
> > +{
> > +	static const char *const units_2[] = {
> > +		"B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB"
> > +	};
> 
> Blech. Blech blech blech. As far as I'm concerned, "IEC binary units"
> rewrite history. I propose to just say "KB" & friends.

So I kind of agree. Memory is almost never measured in marketing bytes, we should 
simply output KB/MB/GB/TB/PB/EB like the rest of the memory management code does 
and ignore all the 'i' silliness that infests storage sizes ...

Thanks,

	Ingo
