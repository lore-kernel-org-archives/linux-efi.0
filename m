From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 1/2] efi: arm64: abort boot on pending SError
Date: Fri, 1 Jul 2016 16:22:52 +0100
Message-ID: <20160701152252.GA17071@leverpostej>
References: <1467385291-9880-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1467385291-9880-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, Jul 01, 2016 at 05:01:30PM +0200, Ard Biesheuvel wrote:
> It is the firmware's job to clear any pending SErrors before entering
> the kernel. On UEFI, we can fail gracefully rather than panic during
> early boot, so check for this condition in the stub.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

An SError could be triggered either asynchronously by FW, or as a result
of our actions at any point after this, e.g. due to the filesystem
accesses made to load an initrd.

So in practice, is checking here useful? Have we seen FW with masked but
pending SError at the point we enter the stub rather than that SError
being triggered later,?

I'm also not sure what this means for CPER, which may use SError to
signal to the OS. It's possible that the UEFI implementation polls
ISR_EL1 itself, and handles SError appropriately internally, or that the
OS can later deal with the SError based on CPER and friends.

> ---
>  drivers/firmware/efi/libstub/arm64-stub.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
> index eae693eb3e91..c7e7396de876 100644
> --- a/drivers/firmware/efi/libstub/arm64-stub.c
> +++ b/drivers/firmware/efi/libstub/arm64-stub.c
> @@ -20,7 +20,14 @@ extern bool __nokaslr;
>  
>  efi_status_t check_platform_features(efi_system_table_t *sys_table_arg)
>  {
> -	u64 tg;
> +	u64 tg, isr;
> +
> +	/* check for a pending SError */
> +	asm ("mrs %0, isr_el1" : "=r"(isr));

I think you can use read_sysreg(isr_el1) here, given that the
read_sysreg helper is a macro function, and we already include sysreg.h
here.

> +	if (isr & BIT(8)) {

Perhaps add:

#define ISR_EL1_A_BIT	BIT(8)

to sysreg.h?

> +		pr_efi_err(sys_table_arg, "Pending SError detected -- aborting\n");
> +		return EFI_LOAD_ERROR;
> +	}

Otherwise, code-wise this looks fine, but as above I'm not sure if this
is the right thiing to do. :/

Thanks,
Mark.

>  
>  	/* UEFI mandates support for 4 KB granularity, no need to check */
>  	if (IS_ENABLED(CONFIG_ARM64_4K_PAGES))
> -- 
> 2.7.4
> 
