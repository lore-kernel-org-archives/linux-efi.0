Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792570126;
	b=0KSzSNBBVX8IJHrGCVGe4yTHn/+FX3+Qb8FI3k8XlkwRJh59WonZgg/k247uOq7OqpGd
	 QxLvIiLKR68vJiz0KfyrwU3eXJmHOBRy7vLscntkt7o2cbifEmxzUIl4WhEFENcESk2HJ
	 ZUhsexzYPEXZLTfXLUEpoifUXKRNd/ChYOmjIHQ3zhHVOzCIxkQ+90iS+GT2Rj/OGmmcS
	 q3Cj4EbcS1GyRftYYTPkfvKo26tZl07xTmMHzKLA2iulrpYNxG8CkrOMjHQDPEIRe9VRh
	 OvJXXYm5QXumhxFJbfDwx6EEesh8wcPVsSYyIdUlK1roGX/1LGw5WuBGFD2vTHW9wHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792570126;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=AqlZ3i98W8KIbKL/1v8ATr9shp2SQpSgzOXsLucMZMc=;
	b=d0Llr8D4Cxwl4A3mSZBDdB/GftSAl8TC5GUGWP2Af2bJRpia/Iu85GxsCqrW926tmV17
	 KkRMIZjzuQsQMf6GKZc7Zs+pHt/cCfqH2P9EwSz6MdCphv+MD1gt7XQzEt+LEUrpxKRPB
	 veJVUDfiN9Q+4+5ObyRC7VFp0jvnsegMqbrfjxPrtg0mI5sK/bgGEPIdomSBgtzxq4ZmH
	 rL5jOf3GI/h+h2cc4ZxwnajJUB/OI0P8IB3Pr3qydI0rEeuHqVaY6EE6zbnwOWZbmSEYz
	 6HgxjzHu5TJJkLuXj1bpCE5YeQ7dSW4vgUe9T8bLzLc0jkQ/BOOs4NmxyWflG7KtzIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=QWTE8VNC;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96836606A31C;
	Wed, 21 Oct 2026 08:08:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 96836606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=QWTE8VNC
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 768F41595;
	Wed, 21 Oct 2026 01:08:40 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2E2B63F7B4;
	Wed, 21 Oct 2026 01:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792570123; bh=cnyaEnul7lwGJfjB43Qer2YuUdo+zKOTOANHUovpt8U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QWTE8VNC/AdoGW019vhpgeWWcJzn9DWgmoS9MuR8/DW6vM35uoQ3+eaqVROLKArdR
	 xuDjU731EIsKkFLN1tAyXJbvHHNAbi7ZH9VUqzwmbZ9ErkGfm5ssYs3AUc8ZoRD3IS
	 CW90xGvB3du+N8D+SSO9tKTZaobu8I69mNET1k5I=
Date: Wed, 21 Oct 2026 09:08:36 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>,
	Ard Biesheuvel <ardb@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, David Sterba <dsterba@suse.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-efi@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Simon Glass <sjg@chromium.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Nick Terrell <terrelln@fb.com>, Will Deacon <will@kernel.org>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	linux-integrity@vger.kernel.org,
	Palmer Dabbelt <palmer@rivosinc.com>, patches@lists.linux.dev,
	Piotr =?iso-8859-1?Q?Kr=F3l?= <piotr.krol@3mdeb.com>,
	Ross Philipson <ross.philipson@gmail.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Song Shuai <songshuaishuai@tinylab.org>
Subject: Re: [PATCH v2 15/15] efi/arm64: Implement ARM64 DRTM in the stub
Message-ID: <athzBHFwyp0bFEu9@e129823.arm.com>
References: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
 <15-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>

Hi Jason,

Overall patches are look good to me.

But small one question more.

> Provide an implementation of the CONFIG_EFI_STUB_DRTM protocol for ARM64
> DEN0113 >= v1.1.
> 
> First, it queries the FW for support and collects all the
> information. This is needed to compute the extra_size, which comes
> from FW reporting how much memory it needs during the launch for the
> DLME Data and DCE-owned data. The generic stub ensures there is
> trailing memory after Image for this.
> 
> Then the DRTM_PARAMETERS launch structure is computed using the
> offsets in the efi_info.
> 
> Finally, the stub does ExitBootServices and calls the actual launch.
> 
> The feature discovery process is deliberately fairly verbose to help
> debug any FW weirdness in the field. Enable it with efi=debug
> 
> It looks something like:
> 
>  EFI stub: DRTM: interface version 1.4
>  EFI stub: DEBUG: DRTM: TPM algorithm 0xc, TPM hashing unavailable, PCR schemas 0x1
>  EFI stub: DEBUG: DRTM: minimum DLME data 73728 bytes, Normal-world DCE 0 bytes
>  EFI stub: Decompressing Linux Kernel...
>  EFI stub: Generating empty DTB
>  EFI stub: Exiting boot services...
>  EFI stub: DEBUG: DRTM: will launch, selected launch features 0x0
>  [    0.000000] Booting Linux on physical CPU 0x0000000000 [0x000f0510]
> 
> Eventually the launch'd kernel is going to require built in crypto
> libraries that match what the FW is using so it can validate some of the
> information left behind during early boot. Refuse to launch if these are
> not built in and build in the most common ones from the ARM64_DRTM
> kconfig.
> 
> One nit, if the platform does not support SMC then using drtm=auto may
> crash on the SMC op. As far as I can tell there is no way to discover SMC
> support through EFI. Learning it from the ACPI FADT is doable and costs
> about 250 lines of code.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  arch/arm64/Kconfig                        |  16 +
>  drivers/firmware/efi/libstub/Makefile     |   1 +
>  drivers/firmware/efi/libstub/arm64-drtm.c | 426 ++++++++++++++++++++++
>  3 files changed, 443 insertions(+)
>  create mode 100644 drivers/firmware/efi/libstub/arm64-drtm.c
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 4a752835ce1116..30244bc2d57696 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -2543,6 +2543,22 @@ config EFI
>  	  allow the kernel to be booted as an EFI application. This
>  	  is only useful on systems that have UEFI firmware.
>  
> +config ARM64_DRTM
> +	bool "Arm Dynamic Root of Trust for Measurement support"
> +	depends on EFI
> +	select CRYPTO
> +	select CRYPTO_SHA256
> +	select CRYPTO_SHA512
> +	select EFI_STUB_DRTM
> +	help
> +	  Support launching Linux as a Dynamically Launched Measured
> +	  Environment (DLME) using Arm's DEN0113 DRTM specification. Requires
> +	  booting through the EFI stub. The drtm= kernel command line option
> +	  enables or disables the launch at boot.
> +
> +	  If unsure, say N. This option is EXPERIMENTAL and does not yet provide
> +	  security.
> +
>  config COMPRESSED_INSTALL
>  	bool "Install compressed image by default"
>  	help
> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
> index 3f1921e6c334d1..f0958b4df16592 100644
> --- a/drivers/firmware/efi/libstub/Makefile
> +++ b/drivers/firmware/efi/libstub/Makefile
> @@ -83,6 +83,7 @@ lib-$(CONFIG_EFI_GENERIC_STUB)	+= efi-stub.o string.o intrinsics.o systable.o \
>  
>  lib-$(CONFIG_ARM)		+= arm32-stub.o
>  lib-$(CONFIG_ARM64)		+= kaslr.o arm64.o arm64-stub.o smbios.o
> +lib-$(CONFIG_ARM64_DRTM)	+= arm64-drtm.o
>  lib-$(CONFIG_X86)		+= x86-stub.o smbios.o
>  lib-$(CONFIG_X86_64)		+= x86-5lvl.o
>  lib-$(CONFIG_RISCV)		+= kaslr.o riscv.o riscv-stub.o
> diff --git a/drivers/firmware/efi/libstub/arm64-drtm.c b/drivers/firmware/efi/libstub/arm64-drtm.c
> new file mode 100644
> index 00000000000000..2fc58babc3e7cb
> --- /dev/null
> +++ b/drivers/firmware/efi/libstub/arm64-drtm.c
> @@ -0,0 +1,426 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES
> + *
> + * EFI Stub implementation for ARM DEN 0113 "DRTM Architecture for Arm"
> + *
> + * This code runs on the untrusted side of the boot in the EFI stub. Nothing it
> + * does should impact the integrity of the post-launch world and it does not
> + * need to take special security precautions.
> + */
> +#include <linux/bitfield.h>
> +#include <linux/efi.h>
> +#include <linux/kconfig.h>
> +#include <linux/overflow.h>
> +#include <linux/sizes.h>
> +#include <linux/tpm_command.h>
> +#include <linux/unaligned.h>
> +
> +#include <uapi/linux/psci.h>
> +
> +#include <asm/cputype.h>
> +#include <asm/drtm.h>
> +#include <asm/image.h>
> +
> +#include "efistub.h"
> +
> +struct efi_drtm_config {
> +	u32 launch_features;
> +	unsigned long dlme_data_size;
> +	unsigned long nw_dce_size;
> +	struct arm_drtm_parameters *params_addr;
> +};
> +static struct efi_drtm_config drtm_cfg;
> +
> +/* True if SMCCC 1.0 or later is available. */
> +static bool efi_arm64_psci_smccc_compatible(void)
> +{
> +	struct arm_smccc_res res;
> +	s32 status;
> +
> +	arm_smccc_1_1_smc(PSCI_0_2_FN_PSCI_VERSION, &res);
> +	if ((s32)res.a0 < 0)
> +		return false;
> +
> +	if (PSCI_VERSION_MAJOR(res.a0) < 1)
> +		return false;
> +
> +	arm_smccc_1_1_smc(PSCI_1_0_FN_PSCI_FEATURES, ARM_SMCCC_VERSION_FUNC_ID,
> +			  &res);
> +	status = (s32)res.a0;
> +	if (status == PSCI_RET_NOT_SUPPORTED) {
> +		/*
> +		 * SMCCC_VERSION was introduced by SMCCC 1.1, so firmware that
> +		 * does not advertise that function through PSCI_FEATURES is
> +		 * using the valid SMCCC 1.0 baseline.
> +		 */
> +		return true;
> +	} else if (status < 0) {
> +		return false;
> +	} else {
> +		u32 version;
> +
> +		arm_smccc_1_1_smc(ARM_SMCCC_VERSION_FUNC_ID, &res);
> +		version = res.a0;
> +		if ((version >> 16) != 1 || version < ARM_SMCCC_VERSION_1_1)
> +			return false;
> +	}
> +	return true;
> +}
> +
> +static bool efi_drtm_query_feature(u64 feature, u64 *value)
> +{
> +	s64 status;
> +
> +	status = arm_drtm_query_feature(feature, value);
> +	if (status < 1) {
> +		efi_err("DRTM: feature %llx query failed (x0=%lld)\n", feature,
> +			status);
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +/*
> + * For the kernel to boot it must have the matching hash algorithm built in to
> + * be able to validate the TCB hashes. Assume the TPM hash algorithm is the one
> + * that TCB_HASH_TABLE will be using.
> + */
> +static bool efi_drtm_hash_algorithm_supported(u16 algorithm)
> +{
> +	switch (algorithm) {
> +	case TPM_ALG_SHA256:
> +		return IS_BUILTIN(CONFIG_CRYPTO_SHA256);
> +	case TPM_ALG_SHA384:
> +	case TPM_ALG_SHA512:
> +		return IS_BUILTIN(CONFIG_CRYPTO_SHA512);
> +	default:
> +		return false;
> +	}
> +}
> +
> +static bool efi_drtm_probe_tpm(void)
> +{
> +	u16 algorithm;
> +	u8 schemas;
> +	u64 value;
> +
> +	if (!efi_drtm_query_feature(ARM_DRTM_FEATURE_TPM, &value))
> +		return false;
> +	algorithm = FIELD_GET(ARM_DRTM_TPM_ALG_MASK, value);
> +	schemas = FIELD_GET(ARM_DRTM_PCR_SCHEMA_MASK, value);
> +
> +	if (!efi_drtm_hash_algorithm_supported(algorithm)) {
> +		efi_err("DRTM: firmware hash algorithm 0x%x is unavailable (feature 0x%llx)\n",
> +			algorithm, value);
> +		return false;
> +	}
> +
> +	if (!(schemas & BIT(ARM_DRTM_PCR_SCHEMA_DEFAULT))) {
> +		efi_err("DRTM: default PCR schema is unavailable (feature 0x%llx)\n",
> +			value);
> +		return false;
> +	}
> +
> +	efi_debug("DRTM: TPM algorithm 0x%x, TPM hashing %s, PCR schemas 0x%x\n",
> +		  algorithm,
> +		  value & ARM_DRTM_TPM_HASHING ? "available" : "unavailable",
> +		  schemas);
> +	return true;
> +}
> +
> +static bool efi_drtm_probe_memory(void)
> +{
> +	u64 value;
> +
> +	if (!efi_drtm_query_feature(ARM_DRTM_FEATURE_MIN_MEMORY, &value))
> +		return false;
> +
> +	drtm_cfg.dlme_data_size =
> +		FIELD_GET(ARM_DRTM_DLME_DATA_PAGES_MASK, value) *
> +		ARM_DRTM_PAGE_SIZE;
> +	drtm_cfg.nw_dce_size = FIELD_GET(ARM_DRTM_NW_DCE_PAGES_MASK, value) *
> +			       ARM_DRTM_PAGE_SIZE;
> +
> +	efi_debug("DRTM: minimum DLME data %lu bytes, Normal-world DCE %lu bytes\n",
> +		  drtm_cfg.dlme_data_size, drtm_cfg.nw_dce_size);
> +	return true;
> +}
> +
> +static bool efi_drtm_probe_dma(void)
> +{
> +	u64 value;
> +
> +	if (!efi_drtm_query_feature(ARM_DRTM_FEATURE_DMA_PROTECTION, &value))
> +		return false;
> +
> +	if (!(FIELD_GET(ARM_DRTM_DMA_PROTECTION_MASK, value) &
> +	      BIT(ARM_DRTM_DMA_PROTECTION_COMPLETE))) {
> +		efi_err("DRTM: complete DMA protection is unavailable (feature 0x%llx)\n",
> +			value);
> +		return false;
> +	}
> +	return true;
> +}
> +
> +/* Sanity check nothing has gone wrong */
> +static bool efi_drtm_probe_boot_pe(void)
> +{
> +	u64 current_pe = read_cpuid_mpidr() & MPIDR_HWID_BITMASK;
> +	u64 boot_pe;
> +
> +	if (!efi_drtm_query_feature(ARM_DRTM_FEATURE_BOOT_PE, &boot_pe))
> +		return false;
> +
> +	if ((boot_pe & MPIDR_HWID_BITMASK) != current_pe) {
> +		efi_err("DRTM: boot PE 0x%llx does not match current PE 0x%llx\n",
> +			boot_pe, current_pe);
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +static void efi_drtm_report_previous_error(void)
> +{
> +	s64 error_code;
> +	s64 status;
> +
> +	status = arm_drtm_query_function(ARM_DRTM_SMC_GET_ERROR);
> +	if (status != ARM_DRTM_SUCCESS) {
> +		efi_debug("DRTM: GET_ERROR is unavailable (x0=%lld)\n", status);
> +		return;
> +	}
> +
> +	status = arm_drtm_get_error(&error_code);
> +	if (status != ARM_DRTM_SUCCESS) {
> +		efi_warn("DRTM: failed to read previous error (x0=%lld)\n",
> +			 status);
> +		return;
> +	}
> +
> +	if (error_code) {
> +		efi_warn("DRTM: firmware reports previous launch error 0x%llx\n",
> +			 error_code);
> +		if (efi_drtm_policy != EFI_DRTM_ENFORCE)
> +			efi_drtm_policy = EFI_DRTM_OFF;
> +	}
> +}
> +
> +static efi_status_t efi_drtm_failure(void)
> +{
> +	if (efi_drtm_policy == EFI_DRTM_AUTO) {
> +		efi_warn("DRTM: preparation failed, continuing without DRTM\n");
> +		efi_drtm_policy = EFI_DRTM_OFF;
> +		return EFI_SUCCESS;
> +	}
> +
> +	efi_err("DRTM: enforced preparation failed\n");
> +	return EFI_UNSUPPORTED;
> +}
> +
> +efi_status_t efi_drtm_prepare(void)
> +{
> +	s64 feature_status;
> +	u16 major, minor;
> +	s32 status;
> +
> +	if (efi_drtm_policy == EFI_DRTM_OFF)
> +		return EFI_SUCCESS;
> +
> +	if (!efi_arm64_psci_smccc_compatible())
> +		return efi_drtm_failure();
> +
> +	/*
> +	 * v1.4B section 3.2.1 "DRTM_VERSION usage" explains that a new major
> +	 * ABI version may "Change behavior of existing functions". Verify the
> +	 * major version before calling anything so we don't trigger unknown
> +	 * behavior.
> +	 */
> +	status = arm_drtm_version(&major, &minor);
> +	if (status != ARM_DRTM_SUCCESS) {
> +		efi_err("DRTM: failed to read interface version (x0=%d)\n",
> +			status);
> +		return efi_drtm_failure();
> +	}
> +	if (major != ARM_DRTM_VERSION_MAJOR) {
> +		efi_err("DRTM: unsupported interface version %u.%u\n", major,
> +			minor);
> +		return efi_drtm_failure();
> +	}
> +	efi_info("DRTM: interface version %u.%u\n", major, minor);
> +
> +	efi_drtm_report_previous_error();
> +	if (efi_drtm_policy == EFI_DRTM_OFF)
> +		return EFI_SUCCESS;
> +
> +	feature_status = arm_drtm_query_function(ARM_DRTM_SMC_DYNAMIC_LAUNCH);
> +	if (feature_status != ARM_DRTM_SUCCESS) {
> +		efi_err("DRTM: dynamic launch is unavailable (x0=%lld)\n",
> +			feature_status);
> +		return efi_drtm_failure();
> +	}
> +
> +	if (!efi_drtm_probe_tpm() || !efi_drtm_probe_memory() ||
> +	    !efi_drtm_probe_dma() || !efi_drtm_probe_boot_pe())
> +		return efi_drtm_failure();
> +
> +	drtm_cfg.launch_features =
> +		ARM_DRTM_LAUNCH_HASH_FIRMWARE |
> +		FIELD_PREP(ARM_DRTM_LAUNCH_PCR_SCHEMA_MASK,
> +			   ARM_DRTM_PCR_SCHEMA_DEFAULT) |
> +		FIELD_PREP(ARM_DRTM_LAUNCH_DMA_PROTECTION_MASK,
> +			   ARM_DRTM_DMA_PROTECTION_COMPLETE) |
> +		ARM_DRTM_LAUNCH_NO_AUTH | ARM_DRTM_LAUNCH_KEEP_SECURE_IRQS;
> +
> +	return EFI_SUCCESS;
> +}
> +
> +unsigned long efi_drtm_get_extra_size(void)
> +{
> +	/*
> +	 * See arch/arm64/kernel/vmlinux.lds.S for the DRTM Memory layout.
> +	 *
> +	 * v1.4B Table 6 "Return values for DRTM features", feature 0x2 reports
> +	 * both minimum sizes in 4 KiB pages.
> +	 *
> +	 * The linker places the DLME data at the 4 KiB-aligned end of the
> +	 * static Image as required by R314030 in Table 13 "DLME region
> +	 * requirements".
> +	 *
> +	 * The DLME region must include all of that data (R45200 in Table 30
> +	 * "DCE requirements for the DLME"), and an optional Normal-world DCE
> +	 * follows it at another 4 KiB-aligned address as required by R312080 in
> +	 * Table 10 "DRTM_PARAMETERS requirements".
> +	 *
> +	 * A final page holds the 4 KiB-aligned DRTM_PARAMETERS required by
> +	 * R312010 in the same table. Only the first area is part of the DLME
> +	 * region.
> +	 */
> +	if (efi_drtm_policy == EFI_DRTM_OFF)
> +		return 0;
> +	return drtm_cfg.dlme_data_size + drtm_cfg.nw_dce_size +
> +	       ARM_DRTM_PAGE_SIZE;
> +}
> +
> +efi_status_t efi_drtm_prepare_launch(unsigned long image_base,
> +				     unsigned long fdt_addr)
> +{
> +	const struct arm64_image_header *header = (const void *)image_base;
> +	const struct efi_image_info *info = efi_get_image_info(image_base);
> +	struct arm64_drtm_handoff *handoff =
> +		efi_get_image_symbol(image_base, arm64_drtm_handoff);
> +	struct arm_drtm_parameters *params;
> +	unsigned long measured_offset;
> +	unsigned long measured_size;
> +	unsigned long image_size;
> +	unsigned long dlme_start;
> +	unsigned long dlme_end;
> +	unsigned long dce_end;
> +	unsigned long entry;
> +
> +	if (efi_drtm_policy == EFI_DRTM_OFF)
> +		return EFI_SUCCESS;
> +
> +	image_size = le64_to_cpu(header->image_size);
> +	measured_offset = info->drtm_measured_start;
> +	measured_size = info->dlme_measured_size;
> +	entry = info->drtm_entry;
> +	dlme_start = image_base + image_size;
> +	dlme_end = dlme_start + drtm_cfg.dlme_data_size;
> +	dce_end = dlme_end + drtm_cfg.nw_dce_size;

Suppose user boot the kernel via decompressed Image which is the
part of artifact of compressed image and use the drtm option (e.g.
booting via UEFI shell with decompressed Image).

Since the drtm extra memory is allocated only in efi_zboot_entry(),
I think the drtm extra memory wouldn't be allocated so it would corrupt
memory while setting the laucn parameter or by DRTM...

Is this simply an example of incorrect usage which is ignorable?

Thanks.

[...snip...]

-- 
Sincerely,
Yeoreum Yun
