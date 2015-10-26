From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] arm64/efi: move arm64 specific stub C code to libstub
Date: Mon, 26 Oct 2015 21:11:33 +0000
Message-ID: <20151026211133.GB3526@codeblueprint.co.uk>
References: <1445611694-31838-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1445611694-31838-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jeremy.linton-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, Suzuki.Poulose-5wv7dgnIgG8@public.gmane.org, ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 23 Oct, at 04:48:14PM, Ard Biesheuvel wrote:
> Now that we added special handling to the C files in libstub, move
> the one remaining arm64 specific EFI stub C file to libstub as
> well, so that it gets the same treatment. This should prevent future
> changes from resulting in binaries that may execute incorrectly in
> UEFI context.
 
Sorry, I'm coming at this cache-cold: What special handling was added
to libstub that you want to make use of here?

> With efi-entry.S the only remaining EFI stub source file under
> arch/arm64, we can also simplify the Makefile logic somewhat.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
> 
> I would like to suggest that this be taken on top of the stuff that is
> queued for 4.4 at the moment (if it is not too late already).
 
That's upto the tip folks (Cc'd). Ingo, would you consider applying
a minimal build cleanup patch like this for v4.4?

>  arch/arm64/kernel/Makefile                                                | 9 ++-------
>  drivers/firmware/efi/libstub/Makefile                                     | 3 +++
>  arch/arm64/kernel/efi-stub.c => drivers/firmware/efi/libstub/arm64-stub.c | 0
>  3 files changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
> index 1b6bda2ff102..474691f8b13a 100644
> --- a/arch/arm64/kernel/Makefile
> +++ b/arch/arm64/kernel/Makefile
> @@ -4,11 +4,8 @@
>  
>  CPPFLAGS_vmlinux.lds	:= -DTEXT_OFFSET=$(TEXT_OFFSET)
>  AFLAGS_head.o		:= -DTEXT_OFFSET=$(TEXT_OFFSET)
> -CFLAGS_efi-stub.o 	:= -DTEXT_OFFSET=$(TEXT_OFFSET)
>  CFLAGS_armv8_deprecated.o := -I$(src)
>  
> -KASAN_SANITIZE_efi-stub.o	:= n
> -
>  CFLAGS_REMOVE_ftrace.o = -pg
>  CFLAGS_REMOVE_insn.o = -pg
>  CFLAGS_REMOVE_return_address.o = -pg
> @@ -22,9 +19,7 @@ arm64-obj-y		:= debug-monitors.o entry.o irq.o fpsimd.o		\
>  			   cpufeature.o alternative.o cacheinfo.o		\
>  			   smp.o smp_spin_table.o topology.o
>  
> -stub-obj				:= efi-stub.o efi-entry.o
> -extra-y					:= $(stub-obj)
> -stub-obj				:= $(patsubst %.o,%.stub.o,$(stub-obj))
> +extra-$(CONFIG_EFI)			:= efi-entry.o
>  
>  OBJCOPYFLAGS := --prefix-symbols=__efistub_
>  $(obj)/%.stub.o: $(obj)/%.o FORCE
> @@ -42,7 +37,7 @@ arm64-obj-$(CONFIG_CPU_PM)		+= sleep.o suspend.o
>  arm64-obj-$(CONFIG_CPU_IDLE)		+= cpuidle.o
>  arm64-obj-$(CONFIG_JUMP_LABEL)		+= jump_label.o
>  arm64-obj-$(CONFIG_KGDB)		+= kgdb.o
> -arm64-obj-$(CONFIG_EFI)			+= efi.o $(stub-obj)
> +arm64-obj-$(CONFIG_EFI)			+= efi.o efi-entry.stub.o
>  arm64-obj-$(CONFIG_PCI)			+= pci.o
>  arm64-obj-$(CONFIG_ARMV8_DEPRECATED)	+= armv8_deprecated.o
>  arm64-obj-$(CONFIG_ACPI)		+= acpi.o
> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
> index bca9a76cbd33..92ae557abbbc 100644
> --- a/drivers/firmware/efi/libstub/Makefile
> +++ b/drivers/firmware/efi/libstub/Makefile
> @@ -34,6 +34,9 @@ $(obj)/lib-%.o: $(srctree)/lib/%.c FORCE
>  lib-$(CONFIG_EFI_ARMSTUB)	+= arm-stub.o fdt.o string.o \
>  				   $(patsubst %.c,lib-%.o,$(arm-deps))
>  
> +lib-$(CONFIG_ARM64)		+= arm64-stub.o
> +CFLAGS_arm64-stub.o 		:= -DTEXT_OFFSET=$(TEXT_OFFSET)
> +
>  #
>  # arm64 puts the stub in the kernel proper, which will unnecessarily retain all
>  # code indefinitely unless it is annotated as __init/__initdata/__initconst etc.
> diff --git a/arch/arm64/kernel/efi-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
> similarity index 100%
> rename from arch/arm64/kernel/efi-stub.c
> rename to drivers/firmware/efi/libstub/arm64-stub.c
> -- 
> 2.1.4
> 
