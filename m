From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 2/9] arm64/efi: refactor EFI init and runtime code for
 reuse by 32-bit ARM
Date: Sat, 10 Oct 2015 22:00:37 +0100
Message-ID: <20151010210037.GG2723@codeblueprint.co.uk>
References: <1443719063-6832-1-git-send-email-ard.biesheuvel@linaro.org>
 <1443719063-6832-3-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1443719063-6832-3-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, ryan.harkin-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 01 Oct, at 07:04:16PM, Ard Biesheuvel wrote:
> This refactors the EFI init and runtime code that will be shared
> between arm64 and ARM so that it can be built for both archs.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/arm64/include/asm/efi.h       |  16 ++++
>  arch/arm64/kernel/efi.c            |  51 ++++++++++
>  drivers/firmware/efi/arm-init.c    |  11 ++-
>  drivers/firmware/efi/arm-runtime.c | 101 ++++++--------------
>  drivers/firmware/efi/efi.c         |   4 +-
>  5 files changed, 105 insertions(+), 78 deletions(-)

[...]

> diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
> index 56987a5b9033..235677b86e4e 100644
> --- a/drivers/firmware/efi/arm-init.c
> +++ b/drivers/firmware/efi/arm-init.c
> @@ -66,7 +66,7 @@ static int __init uefi_init(void)
>  {
>  	efi_char16_t *c16;
>  	void *config_tables;
> -	u64 table_size;
> +	int table_size;
>  	char vendor[100] = "unknown";
>  	int i, retval;
  
Perhaps 'table_size' should be unsigned long? At the very least it
should be size_t, not int.

> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index f5e586bd3b24..2eb31e28a35c 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -23,6 +23,8 @@
>  #include <linux/io.h>
>  #include <linux/platform_device.h>
>  
> +#include <asm/efi.h>
> +
>  struct efi __read_mostly efi = {
>  	.mps			= EFI_INVALID_TABLE_ADDR,
>  	.acpi			= EFI_INVALID_TABLE_ADDR,

Hmm... not quite sure why this new include is required?

-- 
Matt Fleming, Intel Open Source Technology Center
