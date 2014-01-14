From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v4 4/5] arm: Add [U]EFI runtime services support
Date: Tue, 14 Jan 2014 07:52:32 +0100
Message-ID: <201401140752.33257.arnd@arndb.de>
References: <1389445524-30623-1-git-send-email-leif.lindholm@linaro.org> <201401131943.10352.arnd@arndb.de> <20140113200135.GF30907@bivouac.eciton.net>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140113200135.GF30907-t77nlHhSwNqAroYi2ySoxKxOck334EZe@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Monday 13 January 2014, Leif Lindholm wrote:
> On Mon, Jan 13, 2014 at 07:43:09PM +0100, Arnd Bergmann wrote:
> > > This patch implements basic support for UEFI runtime services in the
> > > ARM architecture - a requirement for using efibootmgr to read and update
> > > the system boot configuration.
> > > 
> > > It uses the generic configuration table scanning to populate ACPI and
> > > SMBIOS pointers.
> > 
> > As far as I'm concerned there are no plans to have ACPI support on ARM32,
> > so I wonder what the code to populate the ACPI tables is about. Can
> > you clarify this?
> 
> Are you suggesting that I should #ifndef ARM in common code, or that I
> should neglect to document what the common code will do with data it is
> given by UEFI?

It would probably be good to document the fact that it won't work,
possibly even having a BUG_ON statement in the code for this case.

> > > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > > index 78a79a6a..1ab24cc 100644
> > > --- a/arch/arm/Kconfig
> > > +++ b/arch/arm/Kconfig
> > > @@ -1853,6 +1853,20 @@ config EARLY_IOREMAP
> > >  	  the same virtual memory range as kmap so all early mappings must
> > >  	  be unapped before paging_init() is called.
> > >  
> > > +config EFI
> > > +	bool "UEFI runtime service support"
> > > +	depends on OF && !CPU_BIG_ENDIAN
> > 
> > What is the dependency on !CPU_BIG_ENDIAN?
> 
> Mainly on code not being implemented to byte-reverse UCS strings.

Why would you byte-reverse /strings/? They normally just come in
order of the characters, and UTF-16 strings are already defined
as being big-endian or marked by the BOM character.

> > We try hard to have
> > all kernel code support both big-endian and little-endian, and
> > I'm guessing there is a significant overlap between the people
> > that want UEFI support and those that want big-endian kernels.
> 
> Not really. There might be some. Also, it is not necessarily the case
> that those people want to run the big-endian kernel at EL2.
> 
> If a need is seen, this support can be added at a later date.

Ok.

> > > +struct efi_memory_map memmap;
> > 
> > "memmap" is not a good name for a global identifier, particularly because
> > it's easily confused with the well-known "mem_map" array. This
> > wants namespace prefix like you other variable, or a "static" tag,
> > preferably both.
> 
> It is defined by include/linux/efi.h.

This seems to be a mistake: there is no user of this variable outside
of arch/x86/platform/efi/efi.c and arch/x86/platform/efi/efi_64.c.
I think it should just be moved into an x86 specific header file,
or preferably be renamed in the process. There is also efi->memmap,
which seems to be the same pointer.

Note that a number of drivers have local memmap variables.

	Arnd
