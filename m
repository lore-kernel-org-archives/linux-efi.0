From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] efi, x86: Add a "debug" option to the efi= cmdline
Date: Thu, 5 Feb 2015 16:41:39 +0800
Message-ID: <20150205084139.GA23146@dhcp-16-198.nay.redhat.com>
References: <20141210021741.GA3280@darkstar.nay.redhat.com>
 <20141210104627.GA17053@pd.tnic>
 <20150105140332.GB3163@console-pimps.org>
 <54AAA723.1070605@redhat.com>
 <54BF3DCA.4070708@jonmasters.org>
 <20150121100633.GC12173@pd.tnic>
 <20150126104936.GB3320@codeblueprint.co.uk>
 <20150130164309.GG1451@pd.tnic>
 <20150205031846.GA1903@darkstar.redhat.com>
 <20150205081143.GA23980@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150205081143.GA23980-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Jon Masters <jonathan-Zp4isUonpHBD60Wz+7aTrA@public.gmane.org>, Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 02/05/15 at 09:11am, Borislav Petkov wrote:
> On Thu, Feb 05, 2015 at 11:18:46AM +0800, Dave Young wrote:
> > > diff --git a/include/linux/efi.h b/include/linux/efi.h
> > > index 0238d612750e..14cec75d7e74 100644
> > > --- a/include/linux/efi.h
> > > +++ b/include/linux/efi.h
> > > @@ -940,6 +940,7 @@ extern int __init efi_setup_pcdp_console(char *);
> > >  #define EFI_64BIT		5	/* Is the firmware 64-bit? */
> > >  #define EFI_PARAVIRT		6	/* Access is via a paravirt interface */
> > >  #define EFI_ARCH_1		7	/* First arch-specific bit */
> > > +#define EFI_DBG			8	/* Print additional debug info at runtime */
> > 
> > Boris, a nickpick about alignment of the second column..
> 
> This is due to how diffs show tabs. See EFI_PARAVIRT above, it appears
> misaligned too. If you switch to list mode in vim, for example, it'll
> show you how many tabs are being used:
> 
> #define EFI_PARAVIRT^I^I6^I/* Access is via a paravirt interface */$
> #define EFI_ARCH_1^I^I7^I/* First arch-specific bit */$
> #define EFI_DBG^I^I^I8^I/* Print additional debug info at runtime */$
> 
> and EFI_DBG has an additional tab. However, the vertical alignment is
> correct. You can apply the patch and see for yourself :-)

Interesting, you are right :)

Acked-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thanks
Dave
