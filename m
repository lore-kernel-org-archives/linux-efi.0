From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 10/14] efi: Make checkpatch complain less about efi.h
 GUID additions
Date: Wed, 3 Feb 2016 10:44:32 +0000
Message-ID: <20160203104432.GA2597@codeblueprint.co.uk>
References: <1454364428-494-1-git-send-email-matt@codeblueprint.co.uk>
 <1454364428-494-11-git-send-email-matt@codeblueprint.co.uk>
 <20160203103335.GA7310@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160203103335.GA7310@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Jones <pjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 03 Feb, at 11:33:35AM, Ingo Molnar wrote:
> 
> * Matt Fleming <matt@codeblueprint.co.uk> wrote:
> 
> > From: Peter Jones <pjones@redhat.com>
> > 
> > This reformats the GUID definitions in include/linux/efi.h so that if
> > you add another one with the same style, checkpatch won't complain about
> > it.
> > 
> > Signed-off-by: Peter Jones <pjones@redhat.com>
> > Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
> > ---
> >  include/linux/efi.h | 63 +++++++++++++++++++++++++++++++++++------------------
> >  1 file changed, 42 insertions(+), 21 deletions(-)
> > 
> > diff --git a/include/linux/efi.h b/include/linux/efi.h
> > index 09f1559e7525..f468f7c53236 100644
> > --- a/include/linux/efi.h
> > +++ b/include/linux/efi.h
> > @@ -535,67 +535,88 @@ void efi_native_runtime_setup(void);
> >   *  EFI Configuration Table and GUID definitions
> >   */
> >  #define NULL_GUID \
> > -    EFI_GUID(  0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 )
> > +	EFI_GUID(0x00000000, 0x0000, 0x0000, \
> > +		 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00)
> >  
> >  #define MPS_TABLE_GUID    \
> > -    EFI_GUID(  0xeb9d2d2f, 0x2d88, 0x11d3, 0x9a, 0x16, 0x0, 0x90, 0x27, 0x3f, 0xc1, 0x4d )
> > +	EFI_GUID(0xeb9d2d2f, 0x2d88, 0x11d3, \
> > +		 0x9a, 0x16, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
> 
> So I really think this is a step backwards.
> 
> Checkpatch should be fixed/enhanced to allow targeted exemption. Something like:
> 
> 
> 	#define CHECKPATCH_IGNORE
> 	...
> 	#undef CHECKPATCH_IGNORE
> 
> ... which checkpatch would parse and interpret accordingly.

Irrespective of which tool suggested this change, I think this patch
is an improvement because the GUIDs now match the format from the UEFI
spec, making checking for typos that much easier (yes, I've really had
to do that in the past).
