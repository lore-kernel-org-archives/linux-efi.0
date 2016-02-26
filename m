From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 1/2] efi: get rid of EFI_SYSTEM_TABLES status bit
Date: Fri, 26 Feb 2016 14:43:30 +0000
Message-ID: <20160226144330.GB7475@codeblueprint.co.uk>
References: <1456496435-12679-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1456496435-12679-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 26 Feb, at 03:20:34PM, Ard Biesheuvel wrote:
> The EFI_SYSTEM_TABLES status bit is set by all EFI supporting architectures
> upon discovery of the EFI system table, but the bit is never tested in any
> code we have in the tree. So remove it.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/ia64/kernel/efi.c             | 2 --
>  arch/x86/platform/efi/efi.c        | 2 --
>  drivers/firmware/efi/arm-runtime.c | 1 -
>  include/linux/efi.h                | 1 -
>  4 files changed, 6 deletions(-)

Oops. Looks good, thanks Ard.
