From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 4.11 049/150] efi/bgrt: Skip efi_bgrt_init() in case of
 non-EFI boot
Date: Thu, 15 Jun 2017 09:17:43 +0200
Message-ID: <20170615071743.GC25693@kroah.com>
References: <20170612152519.404936272@linuxfoundation.org>
 <20170612152521.552786146@linuxfoundation.org>
 <9a71b41b-5e6a-e0a5-776d-829792e7f998@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9a71b41b-5e6a-e0a5-776d-829792e7f998-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Maniaxx <tripleshiftone-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sabrina Dubroca <sd-y1jBWg8GRStKuXlAQpz2QA@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 15, 2017 at 01:34:38AM +0200, Maniaxx wrote:
> On 12.06.2017 at 17:24 wrote Greg Kroah-Hartman:
> > 4.11-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > 
> > commit 7425826f4f7ac60f2538b06a7f0a5d1006405159 upstream.
> > 
> > Sabrina Dubroca reported an early panic:
> > 
> >   BUG: unable to handle kernel paging request at ffffffffff240001
> >   IP: efi_bgrt_init+0xdc/0x134
> > 
> >   [...]
> > 
> >   ---[ end Kernel panic - not syncing: Attempted to kill the idle task!
> > 
> > ... which was introduced by:
> > 
> >   7b0a911478c7 ("efi/x86: Move the EFI BGRT init code to early init code")
> > 
> > The cause is that on this machine the firmware provides the EFI ACPI BGRT
> > table even on legacy non-EFI bootups - which table should be EFI only.
> > 
> > The garbage BGRT data causes the efi_bgrt_init() panic.
> > 
> > Add a check to skip efi_bgrt_init() in case non-EFI bootup to work around
> > this firmware bug.
> > 
> > Tested-by: Sabrina Dubroca <sd-y1jBWg8GRStKuXlAQpz2QA@public.gmane.org>
> > Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> > Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> > Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> > Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> > Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Fixes: 7b0a911478c7 ("efi/x86: Move the EFI BGRT init code to early init code")
> > Link: http://lkml.kernel.org/r/20170526113652.21339-6-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
> > [ Rewrote the changelog to be more readable. ]
> > Signed-off-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> > 
> > ---
> >  arch/x86/platform/efi/efi-bgrt.c |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > --- a/arch/x86/platform/efi/efi-bgrt.c
> > +++ b/arch/x86/platform/efi/efi-bgrt.c
> > @@ -36,6 +36,9 @@ void __init efi_bgrt_init(struct acpi_ta
> >  	if (acpi_disabled)
> >  		return;
> >  
> > +	if (!efi_enabled(EFI_BOOT))
> > +		return;
> > +
> >  	if (table->length < sizeof(bgrt_tab)) {
> >  		pr_notice("Ignoring BGRT: invalid length %u (expected %zu)\n",
> >  		       table->length, sizeof(bgrt_tab));
> > 
> > 
> > 
> 
> The patch is ok but it only fixes BIOS systems.
> To fix the regression above (commit 7b0a911478c7) for EFI systems 
> it needs this patch as well:
> commit 792ef14df5c585c19b2831673a077504a09e5203 master
> (efi: Fix boot panic because of invalid BGRT image address)

Thanks for letting me know, now queued up.

greg k-h
