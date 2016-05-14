From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 2/5] efibc: Fix excessive stack footprint warning
Date: Sat, 14 May 2016 20:20:47 +0100
Message-ID: <20160514192047.GC2283@codeblueprint.co.uk>
References: <1462570771-13324-1-git-send-email-matt@codeblueprint.co.uk>
 <1462570771-13324-3-git-send-email-matt@codeblueprint.co.uk>
 <94D0CD8314A33A4D9D801C0FE68B4029639618A2@G4W3202.americas.hpqcorp.net>
 <87r3dauwzt.fsf@intel.com>
 <20160511124338.GW2839@codeblueprint.co.uk>
 <8737povd4n.fsf@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8737povd4n.fsf-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Compostella, Jeremy" <jeremy.compostella-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Elliott, Robert (Persistent Memory)" <elliott-ZPxbGqLxI0U@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 11 May, at 05:16:24PM, Jeremy Compostella wrote:
> From 3a54e6872e220e1ac4db0eae126a20b5383dae3e Mon Sep 17 00:00:00 2001
> From: Jeremy Compostella <jeremy.compostella-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Date: Tue, 10 May 2016 10:34:21 +0200
> Subject: [PATCH] efibc: report more information in the error messages
> 
> Report the name of the EFI variable if the value size is too large or
> if efibc_set_variable() fails to allocate the struct efivar_entry
> object.  If efibc_set_variable() fails because the value size is too
> large, it also reports the value size in the error message.
> 
> Signed-off-by: Jeremy Compostella <jeremy.compostella-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/firmware/efi/efibc.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

Applied, thanks Jeremy.
