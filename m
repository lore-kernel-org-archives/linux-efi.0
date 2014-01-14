From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v4 4/5] arm: Add [U]EFI runtime services support
Date: Tue, 14 Jan 2014 14:26:15 +0100
Message-ID: <201401141426.16497.arnd@arndb.de>
References: <1389445524-30623-1-git-send-email-leif.lindholm@linaro.org> <201401140752.33257.arnd@arndb.de> <20140114114419.GH30907@bivouac.eciton.net>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140114114419.GH30907-t77nlHhSwNqAroYi2ySoxKxOck334EZe@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tuesday 14 January 2014, Leif Lindholm wrote:
> On Tue, Jan 14, 2014 at 07:52:32AM +0100, Arnd Bergmann wrote:
> > > > > It uses the generic configuration table scanning to populate ACPI and
> > > > > SMBIOS pointers.
> > > > 
> > > > As far as I'm concerned there are no plans to have ACPI support on ARM32,
> > > > so I wonder what the code to populate the ACPI tables is about. Can
> > > > you clarify this?
> > > 
> > > Are you suggesting that I should #ifndef ARM in common code, or that I
> > > should neglect to document what the common code will do with data it is
> > > given by UEFI?
> > 
> > It would probably be good to document the fact that it won't work,
> > possibly even having a BUG_ON statement in the code for this case.
> 
> Why?
> 
> You'll only touch that pointer if you enable CONFIG_ACPI, and if you
> do you probably want that address. Sounds a bit hostile to throw a BUG
> in the face of someone who's (for example) just succeeded to get Linux
> running on a Windows RT device.

But we know that it can't work unless a lot of other things get changed
in the kernel.

> > > > > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > > > > index 78a79a6a..1ab24cc 100644
> > > > > --- a/arch/arm/Kconfig
> > > > > +++ b/arch/arm/Kconfig
> > > > > @@ -1853,6 +1853,20 @@ config EARLY_IOREMAP
> > > > >  	  the same virtual memory range as kmap so all early mappings must
> > > > >  	  be unapped before paging_init() is called.
> > > > >  
> > > > > +config EFI
> > > > > +	bool "UEFI runtime service support"
> > > > > +	depends on OF && !CPU_BIG_ENDIAN
> > > > 
> > > > What is the dependency on !CPU_BIG_ENDIAN?
> > > 
> > > Mainly on code not being implemented to byte-reverse UCS strings.
> > 
> > Why would you byte-reverse /strings/? They normally just come in
> > order of the characters, and UTF-16 strings are already defined
> > as being big-endian or marked by the BOM character.
> 
> Well, then that bit might just work[tm].
> 
> Although no other architectures supported by UEFI support big-endian,
> so to be honest, I don't want to have to be the first one to validate
> that in order to get the basic support into the kernel.

I think there was a project to run UEFI on PowerPC on some stage, though
I can't find any code now.

> Some of the data structures might need swizzling though...
> Again - if there is demand, this can be dealt with at a later date.

Ok.

	Arnd
