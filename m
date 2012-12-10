From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch] x86, efi: precedence error in setup_efi_pci()
Date: Mon, 10 Dec 2012 11:44:27 +0300
Message-ID: <20121210084426.GQ22569@mwanda>
References: <20121207061649.GA18220@elgon.mountain>
 <50C2AE91.9060800@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <50C2AE91.9060800-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, Dec 07, 2012 at 07:05:53PM -0800, H. Peter Anvin wrote:
> On 12/06/2012 10:16 PM, Dan Carpenter wrote:
> >Negate has higher precedence than bitwise AND so the condition is always
> >false.
> >
> >Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> >
> >diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> >index b1942e2..18e329c 100644
> >--- a/arch/x86/boot/compressed/eboot.c
> >+++ b/arch/x86/boot/compressed/eboot.c
> >@@ -302,7 +302,7 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
> >  		if (status != EFI_SUCCESS)
> >  			continue;
> >
> >-		if (!attributes & EFI_PCI_IO_ATTRIBUTE_EMBEDDED_ROM)
> >+		if (!(attributes & EFI_PCI_IO_ATTRIBUTE_EMBEDDED_ROM))
> >  			continue;
> >
> >  		if (!pci->romimage || !pci->romsize)
> >
> 
> What is the baseline for this patch?
> 

Sorry, this is a linux-next bug.  Introduced in:

commit dd5fc854de5fd37adfcef8a366cd21a55aa01d3d
Author: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date:   Wed Dec 5 14:33:26 2012 -0700

    EFI: Stash ROMs if they're not in the PCI BAR

regards,
dan carpenter
