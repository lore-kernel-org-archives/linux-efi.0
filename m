From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 1/2] Remove EFI memmap quirk for UV
Date: Tue, 17 Nov 2015 09:52:08 +0000
Message-ID: <20151117095208.GC2727@codeblueprint.co.uk>
References: <1447696781-159611-1-git-send-email-athorlton@sgi.com>
 <alpine.DEB.2.11.1511161902050.3761@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1511161902050.3761@nanos>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Alex Thorlton <athorlton@sgi.com>, LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Hedi Berriche <hedi@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>, x86@kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Mon, 16 Nov, at 07:02:48PM, Thomas Gleixner wrote:
> On Mon, 16 Nov 2015, Alex Thorlton wrote:
> 
> CC'ing Matt under his correct e-mail address.
> 
> > Commit a5d90c923bcf ("x86/efi: Quirk out SGI UV") added a quirk to
> > efi_apply_memmap_quirks to force SGI UV systems to fall back to the old
> > EFI memmap mechanism.  We have a BIOS fix for this issue now, so we no
> > longer need this quirk in the kernel.  This commit removes the quirk
> > from the function in question.
> > 
> > Signed-off-by: Alex Thorlton <athorlton@sgi.com>
> > Acked-by: Mike Travis <travis@sgi.com>
> > Acked-by: Russ Anderson <rja@sgi.com>
> > Cc: Matt Fleming <matt.fleming@intel.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: Hedi Berriche <hedi@sgi.com>
> > Cc: Dimitri Sivanich <sivanich@sgi.com>
> > Cc: x86@kernel.org
> > Cc: linux-efi@vger.kernel.org
> > 
> > ---
> >  arch/x86/platform/efi/quirks.c | 6 ------
> >  1 file changed, 6 deletions(-)
> > 
> > diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
> > index 1c7380d..96b417c 100644
> > --- a/arch/x86/platform/efi/quirks.c
> > +++ b/arch/x86/platform/efi/quirks.c
> > @@ -259,12 +259,6 @@ void __init efi_apply_memmap_quirks(void)
> >  		pr_info("efi: Setup done, disabling due to 32/64-bit mismatch\n");
> >  		efi_unmap_memmap();
> >  	}
> > -
> > -	/*
> > -	 * UV doesn't support the new EFI pagetable mapping yet.
> > -	 */
> > -	if (is_uv_system())
> > -		set_bit(EFI_OLD_MEMMAP, &efi.flags);

Awesome! Thanks Alex.

Can I also close https://bugzilla.kernel.org/show_bug.cgi?id=75021 ?
