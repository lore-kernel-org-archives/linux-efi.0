From: joeyli <jlee@suse.com>
Subject: Re: [RFC PATCH 05/16] x86/efi: Get entropy through EFI random number
 generator protocol
Date: Sat, 1 Aug 2015 00:05:36 +0800
Message-ID: <20150731160536.GH2067@linux-rxt1.site>
References: <1437056730-15247-1-git-send-email-jlee@suse.com>
 <1437056730-15247-6-git-send-email-jlee@suse.com>
 <20150728122853.GB12681@amd>
 <20150731095854.GC13113@linux-rxt1.site>
 <1438344078.11322.46.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1438344078.11322.46.camel@intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>, "Lee, Chun-Yi" <joeyli.kernel@gmail.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-efi@vger.kernel.org

On Fri, Jul 31, 2015 at 01:01:18PM +0100, Matt Fleming wrote:
> On Fri, 2015-07-31 at 17:58 +0800, joeyli wrote:
> > > 
> > > Can you do something to avoid each function having two very similar
> > > versions of these functions?
> > >
> > 
> > They are similar but I want follow the style in eboot.c.
> > On the other hand, it's earlier to locate problem on 32-bit or 64-bit EFI.
> > 
> > So, I will keep the above codes.
> 
> FWIW, I think that's fine. I would happily accept a patch to cleanup the
> duplication, but I don't think that needs to be a prerequisite for this
> support.
> 
> I've no problem with the duplication right now.
>

Thanks
 
> > > 
> > > > --- a/include/linux/efi.h
> > > > +++ b/include/linux/efi.h
> > > > @@ -427,6 +427,16 @@ typedef struct {
> > > >  #define EFI_PCI_IO_ATTRIBUTE_VGA_PALETTE_IO_16 0x20000
> > > >  #define EFI_PCI_IO_ATTRIBUTE_VGA_IO_16 0x40000
> > > >  
> > > > +typedef struct {
> > > > +	u32 get_info;
> > > > +	u32 get_rng;
> > > > +} efi_rng_protocol_32;
> > > > +
> > > > +typedef struct {
> > > > +	u64 get_info;
> > > > +	u64 get_rng;
> > > > +} efi_rng_protocol_64;
> > > 
> > > We don't typedef structs usually...
> > > 
> > > Make it union so you can have just one
> > >
> > 
> > I want to follow the style as efi_pci_io_protocolxxx in efi.h.
> > So I will keep it.
> 
> Yeah, consistency is better here than sticking with the general Linux
> coding style rules.
> 
> > > > +	switch (status) {
> > > > +	case EFI_SUCCESS:
> > > > +		str = "EFI_SUCCESS";
> > > > +		break;
> > > 
> > > Can you use macros to reduce code duplication here?
> > > 									Pavel
> > I will try to reduce duplicate code.
> 
> Take a look at __stringify().
>

Thanks for suggestion, I will look at it.

Joey Lee
