From: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] efi: stub: define DISABLE_BRANCH_PROFILING for all
 architectures
Date: Mon, 4 Jan 2016 12:31:45 +0000
Message-ID: <20160104123145.GB1616@arm.com>
References: <1450862968-20222-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1450862968-20222-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Dec 23, 2015 at 10:29:28AM +0100, Ard Biesheuvel wrote:
> This moves the DISABLE_BRANCH_PROFILING define from the x86 specific
> to the general CFLAGS definition for the stub. This fixes build errors
> when building for arm64 with CONFIG_PROFILE_ALL_BRANCHES_ENABLED.
> 
> Reported-by: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/libstub/Makefile | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Cheers, Ard. The kernel now builds and boots as an EFI application for
me when the dreaded #define if config option is enabled:

  Tested-by: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>

Will

> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
> index 3c0467d3688c..c0ddd1b8dca3 100644
> --- a/drivers/firmware/efi/libstub/Makefile
> +++ b/drivers/firmware/efi/libstub/Makefile
> @@ -8,7 +8,7 @@ cflags-$(CONFIG_X86_32)		:= -march=i386
>  cflags-$(CONFIG_X86_64)		:= -mcmodel=small
>  cflags-$(CONFIG_X86)		+= -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2 \
>  				   -fPIC -fno-strict-aliasing -mno-red-zone \
> -				   -mno-mmx -mno-sse -DDISABLE_BRANCH_PROFILING
> +				   -mno-mmx -mno-sse
>  
>  cflags-$(CONFIG_ARM64)		:= $(subst -pg,,$(KBUILD_CFLAGS))
>  cflags-$(CONFIG_ARM)		:= $(subst -pg,,$(KBUILD_CFLAGS)) \
> @@ -16,7 +16,7 @@ cflags-$(CONFIG_ARM)		:= $(subst -pg,,$(KBUILD_CFLAGS)) \
>  
>  cflags-$(CONFIG_EFI_ARMSTUB)	+= -I$(srctree)/scripts/dtc/libfdt
>  
> -KBUILD_CFLAGS			:= $(cflags-y) \
> +KBUILD_CFLAGS			:= $(cflags-y) -DDISABLE_BRANCH_PROFILING \
>  				   $(call cc-option,-ffreestanding) \
>  				   $(call cc-option,-fno-stack-protector)
>  
> -- 
> 2.5.0
> 
