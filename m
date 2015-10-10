From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 1/9] arm64/efi: split off EFI init and runtime code for
 reuse by 32-bit ARM
Date: Sat, 10 Oct 2015 21:53:11 +0100
Message-ID: <20151010205311.GF2723@codeblueprint.co.uk>
References: <1443719063-6832-1-git-send-email-ard.biesheuvel@linaro.org>
 <1443719063-6832-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1443719063-6832-2-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, ryan.harkin-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 01 Oct, at 07:04:15PM, Ard Biesheuvel wrote:
> This splits off the early EFI init and runtime code that
> - discovers the EFI params and the memory map from the FDT, and installs
>   the memblocks and config tables.
> - prepares and installs the EFI page tables so that UEFI Runtime Services
>   can be invoked at the virtual address installed by the stub.
> 
> This will allow it to be reused for 32-bit ARM.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/arm64/kernel/efi.c            | 363 +-------------------
>  drivers/firmware/efi/Makefile      |   4 +-
>  drivers/firmware/efi/arm-init.c    | 214 ++++++++++++
>  drivers/firmware/efi/arm-runtime.c | 191 ++++++++++
>  4 files changed, 409 insertions(+), 363 deletions(-)

[...]

> +static int uefi_debug __initdata;
> +static int __init uefi_debug_setup(char *str)
> +{
> +	uefi_debug = 1;
> +
> +	return 0;
> +}
> +early_param("uefi_debug", uefi_debug_setup);

Was this hunk an unintentional reintroduction of the code Leif deleted
in commit a9cc0cf5701b ("arm64: Use core efi=debug instead of
uefi_debug command line parameter")?

-- 
Matt Fleming, Intel Open Source Technology Center
