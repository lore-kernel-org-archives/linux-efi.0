From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v3 2/8] efi: Decode IA32/X64 Processor Error Section
Date: Thu, 29 Mar 2018 11:46:13 +0200
Message-ID: <20180329094613.GA29198@pd.tnic>
References: <20180324184940.19762-1-Yazen.Ghannam@amd.com>
 <20180324184940.19762-3-Yazen.Ghannam@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180324184940.19762-3-Yazen.Ghannam@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yazen Ghannam <Yazen.Ghannam@amd.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, ard.biesheuvel@linaro.org, x86@kernel.org, tony.luck@intel.com
List-Id: linux-efi@vger.kernel.org

On Sat, Mar 24, 2018 at 01:49:34PM -0500, Yazen Ghannam wrote:
> From: Yazen Ghannam <yazen.ghannam@amd.com>
> 
> Recognize the IA32/X64 Processor Error Section.
> 
> Do the section decoding in a new "cper-x86.c" file and add this to the
> Makefile depending on a new "UEFI_CPER_X86" config option.
> 
> Print the Local APIC ID and CPUID info from the Processor Error Record.
> 
> The "Processor Error Info" and "Processor Context" fields will be
> decoded in following patches.
> 
> Based on UEFI 2.7 Table 252. Processor Error Record.
> 
> Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
> ---
> Link:
> https://lkml.kernel.org/r/20180226193904.20532-3-Yazen.Ghannam@amd.com
> 
> v2->v3:
> * Fix table number in commit message.
> * Don't print raw validation bits.
> 
> v1->v2:
> * Change config option depends to "X86" instead of "X86_32 || X64_64".
> * Remove extra newline in Makefile changes.
> * Drop author copyright line.
> 
>  drivers/firmware/efi/Kconfig    |  5 +++++
>  drivers/firmware/efi/Makefile   |  1 +
>  drivers/firmware/efi/cper-x86.c | 23 +++++++++++++++++++++++

I'd prefer if that were:

drivers/firmware/efi/cper/x86.c
drivers/firmware/efi/cper/arm.c

but that's Ard's call.

>  drivers/firmware/efi/cper.c     | 10 ++++++++++
>  include/linux/cper.h            |  2 ++
>  5 files changed, 41 insertions(+)
>  create mode 100644 drivers/firmware/efi/cper-x86.c
> 
> diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
> index 3098410abad8..781a4a337557 100644
> --- a/drivers/firmware/efi/Kconfig
> +++ b/drivers/firmware/efi/Kconfig
> @@ -174,6 +174,11 @@ config UEFI_CPER_ARM
>  	depends on UEFI_CPER && ( ARM || ARM64 )
>  	default y
>  
> +config UEFI_CPER_X86
> +	bool
> +	depends on UEFI_CPER && X86
> +	default y
> +
>  config EFI_DEV_PATH_PARSER
>  	bool
>  	depends on ACPI
> diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
> index cb805374f4bc..5f9f5039de50 100644
> --- a/drivers/firmware/efi/Makefile
> +++ b/drivers/firmware/efi/Makefile
> @@ -31,3 +31,4 @@ obj-$(CONFIG_ARM)			+= $(arm-obj-y)
>  obj-$(CONFIG_ARM64)			+= $(arm-obj-y)
>  obj-$(CONFIG_EFI_CAPSULE_LOADER)	+= capsule-loader.o
>  obj-$(CONFIG_UEFI_CPER_ARM)		+= cper-arm.o
> +obj-$(CONFIG_UEFI_CPER_X86)		+= cper-x86.o
> diff --git a/drivers/firmware/efi/cper-x86.c b/drivers/firmware/efi/cper-x86.c
> new file mode 100644
> index 000000000000..863f0cd2a0ff
> --- /dev/null
> +++ b/drivers/firmware/efi/cper-x86.c
> @@ -0,0 +1,23 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (C) 2018, Advanced Micro Devices, Inc.
> +
> +#include <linux/cper.h>
> +
> +/*
> + * We don't need a "CPER_IA" prefix since these are all locally defined.
> + * This will save us a lot of line space.
> + */
> +#define VALID_LAPIC_ID			BIT_ULL(0)
> +#define VALID_CPUID_INFO		BIT_ULL(1)
> +
> +void cper_print_proc_ia(const char *pfx, const struct cper_sec_proc_ia *proc)
> +{
> +	if (proc->validation_bits & VALID_LAPIC_ID)
> +		printk("%sLocal APIC_ID: 0x%llx\n", pfx, proc->lapic_id);
> +
> +	if (proc->validation_bits & VALID_CPUID_INFO) {
> +		printk("%sCPUID Info:\n", pfx);
> +		print_hex_dump(pfx, "", DUMP_PREFIX_OFFSET, 16, 4, proc->cpuid,
> +			       sizeof(proc->cpuid), 0);

That's dumping 48 bytes of static information for every error!
Information which can be dumped only once when collecting system info.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
