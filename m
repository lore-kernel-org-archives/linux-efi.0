From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 05/16] x86/efi: Get entropy through EFI random
 number generator protocol
Date: Fri, 31 Jul 2015 13:01:18 +0100
Message-ID: <1438344078.11322.46.camel@intel.com>
References: <1437056730-15247-1-git-send-email-jlee@suse.com>
	 <1437056730-15247-6-git-send-email-jlee@suse.com>
	 <20150728122853.GB12681@amd> <20150731095854.GC13113@linux-rxt1.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150731095854.GC13113-empE8CJ7fzk2xCFIczX1Fw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Cc: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 2015-07-31 at 17:58 +0800, joeyli wrote:
> > 
> > Can you do something to avoid each function having two very similar
> > versions of these functions?
> >
> 
> They are similar but I want follow the style in eboot.c.
> On the other hand, it's earlier to locate problem on 32-bit or 64-bit EFI.
> 
> So, I will keep the above codes.

FWIW, I think that's fine. I would happily accept a patch to cleanup the
duplication, but I don't think that needs to be a prerequisite for this
support.

I've no problem with the duplication right now.

> > 
> > > --- a/include/linux/efi.h
> > > +++ b/include/linux/efi.h
> > > @@ -427,6 +427,16 @@ typedef struct {
> > >  #define EFI_PCI_IO_ATTRIBUTE_VGA_PALETTE_IO_16 0x20000
> > >  #define EFI_PCI_IO_ATTRIBUTE_VGA_IO_16 0x40000
> > >  
> > > +typedef struct {
> > > +	u32 get_info;
> > > +	u32 get_rng;
> > > +} efi_rng_protocol_32;
> > > +
> > > +typedef struct {
> > > +	u64 get_info;
> > > +	u64 get_rng;
> > > +} efi_rng_protocol_64;
> > 
> > We don't typedef structs usually...
> > 
> > Make it union so you can have just one
> >
> 
> I want to follow the style as efi_pci_io_protocolxxx in efi.h.
> So I will keep it.

Yeah, consistency is better here than sticking with the general Linux
coding style rules.

> > > +	switch (status) {
> > > +	case EFI_SUCCESS:
> > > +		str = "EFI_SUCCESS";
> > > +		break;
> > 
> > Can you use macros to reduce code duplication here?
> > 									Pavel
> I will try to reduce duplicate code.

Take a look at __stringify().
