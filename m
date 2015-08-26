From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3] arm64: use core efi=debug instead of uefi_debug
 command line parameter
Date: Wed, 26 Aug 2015 18:30:00 +0100
Message-ID: <20150826173000.GG10728@bivouac.eciton.net>
References: <1440595498-30630-1-git-send-email-leif.lindholm@linaro.org>
 <1440595498-30630-3-git-send-email-leif.lindholm@linaro.org>
 <20150826172455.GB2837@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150826172455.GB2837-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Aug 26, 2015 at 06:24:55PM +0100, Matt Fleming wrote:
> On Wed, 26 Aug, at 02:24:57PM, Leif Lindholm wrote:
> > Now that we have an efi=debug command line option in the core code, use
> > this instead of the arm64-specific uefi_debug option.
> > 
> > Signed-off-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > ---
> >  Documentation/arm/uefi.txt |  2 --
> >  arch/arm64/kernel/efi.c    | 19 +++++--------------
> >  2 files changed, 5 insertions(+), 16 deletions(-)
> 
> Are there no concerns with backwards-compatibility here? I expected
> this patch to internally convert uefi_debug to efi=debug if old boot
> loaders, kernel config, etc specify it.
> 
> Is that something that can be safely ignored?

Since it is purely a debug feature, I opted to just drop it.
I don't have strong feelings, and it could certainly be kept as an
arm64-only alias (but setting the EFI_DBG flag) if others disagree.

/
    Leif
