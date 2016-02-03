From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 10/14] efi: Make checkpatch complain less about efi.h
 GUID additions
Date: Wed, 3 Feb 2016 11:50:35 +0100
Message-ID: <20160203105035.GB21257@gmail.com>
References: <1454364428-494-1-git-send-email-matt@codeblueprint.co.uk>
 <1454364428-494-11-git-send-email-matt@codeblueprint.co.uk>
 <20160203103335.GA7310@gmail.com>
 <20160203104432.GA2597@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160203104432.GA2597-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:

> On Wed, 03 Feb, at 11:33:35AM, Ingo Molnar wrote:
> > 
> > * Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> > 
> > > From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > 
> > > This reformats the GUID definitions in include/linux/efi.h so that if
> > > you add another one with the same style, checkpatch won't complain about
> > > it.
> > > 
> > > Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > > Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> > > ---
> > >  include/linux/efi.h | 63 +++++++++++++++++++++++++++++++++++------------------
> > >  1 file changed, 42 insertions(+), 21 deletions(-)
> > > 
> > > diff --git a/include/linux/efi.h b/include/linux/efi.h
> > > index 09f1559e7525..f468f7c53236 100644
> > > --- a/include/linux/efi.h
> > > +++ b/include/linux/efi.h
> > > @@ -535,67 +535,88 @@ void efi_native_runtime_setup(void);
> > >   *  EFI Configuration Table and GUID definitions
> > >   */
> > >  #define NULL_GUID \
> > > -    EFI_GUID(  0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 )
> > > +	EFI_GUID(0x00000000, 0x0000, 0x0000, \
> > > +		 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00)
> > >  
> > >  #define MPS_TABLE_GUID    \
> > > -    EFI_GUID(  0xeb9d2d2f, 0x2d88, 0x11d3, 0x9a, 0x16, 0x0, 0x90, 0x27, 0x3f, 0xc1, 0x4d )
> > > +	EFI_GUID(0xeb9d2d2f, 0x2d88, 0x11d3, \
> > > +		 0x9a, 0x16, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
> > 
> > So I really think this is a step backwards.
> > 
> > Checkpatch should be fixed/enhanced to allow targeted exemption. Something like:
> > 
> > 
> > 	#define CHECKPATCH_IGNORE
> > 	...
> > 	#undef CHECKPATCH_IGNORE
> > 
> > ... which checkpatch would parse and interpret accordingly.
> 
> Irrespective of which tool suggested this change, I think this patch
> is an improvement because the GUIDs now match the format from the UEFI
> spec, making checking for typos that much easier (yes, I've really had
> to do that in the past).

Hm, so the GUIDs are line-broken in the same fashion in the spec, after the third 
parameter?

That's a strong reason indeed - and then the changelog and title should say that: 
're-format GUID tables to follow the format of the UEFI spec'. That it also 
pacifies checkpatch is a side effect.

Thanks,

	Ingo
