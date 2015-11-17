From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH 1/2] Remove EFI memmap quirk for UV
Date: Tue, 17 Nov 2015 20:32:59 +0100
Message-ID: <20151117193258.GB9374@pd.tnic>
References: <1447696781-159611-1-git-send-email-athorlton@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1447696781-159611-1-git-send-email-athorlton-sJ/iWh9BUns@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Hedi Berriche <hedi-sJ/iWh9BUns@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Nov 16, 2015 at 11:59:40AM -0600, Alex Thorlton wrote:
> Commit a5d90c923bcf ("x86/efi: Quirk out SGI UV") added a quirk to
> efi_apply_memmap_quirks to force SGI UV systems to fall back to the old
> EFI memmap mechanism.  We have a BIOS fix for this issue now, so we no
> longer need this quirk in the kernel.

So does that mean that all UV systems out there will get the BIOS update
or at least will have a BIOS update available so that we won't need the
quirk at all?

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
