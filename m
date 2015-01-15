From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2] arm64/efi: efistub: apply __init annotation
Date: Thu, 15 Jan 2015 21:27:34 +0000
Message-ID: <20150115212734.GD12079@codeblueprint.co.uk>
References: <1421094500-15659-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1421094500-15659-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 12 Jan, at 08:28:20PM, Ard Biesheuvel wrote:
> This ensures all stub component are freed when the kernel proper is
> done booting, by prefixing the names of all ELF sections that have
> the SHF_ALLOC attribute with ".init". This approach ensures that even
> implicitly emitted allocated data (like initializer values and string
> literals) are covered.
> 
> At the same time, remove some __init annotations in the stub that have
> now become redundant, and add the __init annotation to handle_kernel_image
> which will now trigger a section mismatch warning without it.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
> v2: fixed an issue with spurious rebuilding of object files, now setting
>     $(extra-y) correctly, which also allows the .PRECIOUS: to be dropped.
> 
> 
>  arch/arm64/kernel/efi-stub.c                   | 14 +++++++-------
>  drivers/firmware/efi/libstub/Makefile          | 14 ++++++++++++++
>  drivers/firmware/efi/libstub/arm-stub.c        |  8 ++++----
>  drivers/firmware/efi/libstub/efi-stub-helper.c |  2 +-
>  4 files changed, 26 insertions(+), 12 deletions(-)

Applied for v3.20, thanks Ard.

-- 
Matt Fleming, Intel Open Source Technology Center
