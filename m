From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: EFI_STUB fails to boot non-EFI on arm64
Date: Wed, 28 May 2014 21:42:39 +0100
Message-ID: <20140528204239.GV4179@bivouac.eciton.net>
References: <20140523094513.GC9252@arm.com>
 <20140523131656.GR4179@bivouac.eciton.net>
 <20140523134720.GA9256@arm.com>
 <20140523150331.GS4179@bivouac.eciton.net>
 <20140528155931.GA20523@arm.com>
 <20140528180525.GU4179@bivouac.eciton.net>
 <20140528184043.GB20523@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140528184043.GB20523-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, May 28, 2014 at 07:40:43PM +0100, Will Deacon wrote:
> > Well, but (for the output part) my patch already did that?
> > If the "Getting parameters from FDT:\n" was too verbose, we could
> > just drop it, and have the same effect on output.
> 
> It's the pr_err which is annoying, not the "Getting parameters from FDT:\n"
> message. Why should I have an error logged to my console when I was never
> intending to boot using EFI anyway?

The pr_err would now only be triggered if some UEFI properties were
present and not others. I.e. if the UEFI stub loader failed miserably
without detecting it, or something corrupted the DT later on. We would
then be the proud owners of a system in an undefined state.

> > Thing is - there is not really any error case available anywhere
> > during the execution of efi_init() and its branches other than:
> > - Information required for UEFI boot cannot be found.
> > - Information exists, but is invalid.
> > - Failed to early_memremap some UEFI regions into the kernel.
> > which all amounts to "UEFI not available or something went wrong",
> > rather than "UEFI failed to initialise".
> 
> Fine, but in this case the DT had the relevant properties which is a good
> indication that the user was at least *trying* to boot using EFI, no?

Having a partial/invalid DT is going to cause undefined behaviour
regardless of your method of booting.

And if the data provided proved inaccessible or broken, the symptom
would be a complete lack of memblocks. So it may in fact not be
possible for that pr_err to ever make it to the console :)

> > If efi_init returns successfully, EFI_BOOT is set, and testable using
> > the efi_enabled() macro.
> > 
> > The proper "UEFI failed to initialise" bit does not come until the
> > early_initcall arm64_enter_virtual_mode(), and is indicated not by
> > a return value, but by setting the flag indicating that
> > EFI_RUNTIME_SERVICES are available, which is checked later in core
> > code using the efi_enabled() macro.
> 
> Sorry, I naively assumed that with a name like efi_init it might, you know,
> initialise EFI? ;)

Name cargo-culted from ia64/x86 by me, and from me by Mark :)

> > So moving the call to efi_get_fdt_params() would have little effect
> > other than adding a third call site for UEFI bits in setup_arch().
> 
> I don't mind having the extra call site if it allows us to distinguish
> errors from information.

And I still don't see how an extra call site in setup_arch would make
this more possible than it already is (with my suggested patch to the
current version of the code).

/
    Leif
