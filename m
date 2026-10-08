Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743B238DC7C;
	Thu,  8 Oct 2026 16:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791476588; cv=none; b=rSdZ4LyQpxWx0WVQeGu843d9FA9pG5mPyBipcT3Fqc7Zzh0POgFaP0L9wlDLnT6omhgfmKh8YIoircbCM8aef1BCEsMBFWZCextnLRp9/TvkWfbFga7K3SpmJolvvS0WmMvLuH9DWa2elrc+FOLC9QxCrza65l3I2t2EsTSz4UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791476588; c=relaxed/simple;
	bh=6w5F28puS0UCiI60WP1ctAM/yyexfdyg1sBqKt8Dapw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uvgcFFbt4+ARyTx3ULbhxhTNbU31fugoTXBvpDF8CKcvdIIa66NrceRxT83ddt/0dqIuhIiWJyHwv3l9DPp8u72/xU8WGKzZXb50UVeSf0nbB7Q59zD7oRmLamnZuDbF8hEEJ67efgbv5QW8ZT0Tlo753sxe02smrmwWHYU2Nis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T0Yz0MNO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T0Yz0MNO"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B53FE1F000FF;
	Thu,  8 Oct 2026 16:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791476586;
	bh=RlBXLFgx0SnigQAAnpnOvlS/U30XQPjPt2Aw/4r5Wks=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=T0Yz0MNOnBi6Asuf5hTGZb+geQyZeCp+Xr6OxwLNzAZ/8rTaJUIVlj8X3P5gW6Sbr
	 ZdJMtzyyPd/nl8FvfmjoF//WzofcePQEvxWOdSSxW10Pqy90de9QMVdIvvDFaIB7OS
	 d88W+H/BdTGfBtHrH1KqMJQf0FTcpn0Qph/ZYP348qVQrc5+x7OJavwpNNxTtWm01E
	 ZX6KUnpkUUy+AIx3MFBI3KrcuqYNq5Y+fxCvcNWfweA99VzKZcX0aEXQym+amTpIY/
	 wtroCaYfc9dPn7IO1uApUDNXqTgiPRmjdQw4IOp0VqZ+CO1i3gJuqh2nbjubW+RmNf
	 In0XUjr6+9Tsw==
Date: Thu, 8 Oct 2026 19:23:02 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Matthew Garrett <matthewg@nvidia.com>
Cc: mjg59@srcf.ucam.org, keyrings@vger.kernel.org,
	James.Bottomley@hansenpartnership.com,
	linux-integrity@vger.kernel.org, rafael@kernel.org,
	linux-pm@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH 01/17] tpm: Define a kernel-owned TPM NV index that can't
 be modified by userland
Message-ID: <asfDZiuFKCuuRysC@kernel.org>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
 <20261008132532.1155166-2-matthewg@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008132532.1155166-2-matthewg@nvidia.com>

On Thu, Oct 08, 2026 at 06:20:17AM -0700, Matthew Garrett wrote:
> TPM NV indexes can be used for various purposes, including using them as
> PCRs without depleting the limited number of hardware PCRs. It would be
> beneficial to have one that's under control of the kernel in order to be
> able to prove whether certain TPM operations occurred within the kernel
> or not.
> 
> Reserve NV index 0x014c4853 for use by the kernel, and filter commands
> submitted through /dev/tpm* and /dev/tpmrm* so that userspace cannot
> undefine or modify it. Blocking definition is more awkward so let's
> allow that for now, not being able to modify it means there's nothing
> interesting they can do there. The filter simply validates which handle
> the relevant set of commands is referring to and returns -EPERM if it's
> the kernel one.
> 
> NV indexes are from allocated ranges and this is a range allocated to
> Linux, so there should be no userland depending on the ability to access
> this - but let's gate it behind a default N config option anyway.
> 
> Signed-off-by: Matthew Garrett <matthewg@nvidia.com>
> ---
>  drivers/char/tpm/Kconfig          |  8 ++++
>  drivers/char/tpm/tpm-dev-common.c | 67 +++++++++++++++++++++++++++++++
>  include/linux/tpm.h               |  6 +++
>  include/linux/tpm_command.h       | 10 +++++
>  4 files changed, 91 insertions(+)
> 
> diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
> index 5f672f2c01b0..a454b63edca5 100644
> --- a/drivers/char/tpm/Kconfig
> +++ b/drivers/char/tpm/Kconfig
> @@ -253,5 +253,13 @@ config TCG_SVSM
>  	  level (usually VMPL0).  To compile this driver as a module, choose M
>  	  here; the module will be called tpm_svsm.
>  
> +config TCG_TPM_KERNEL_NVINDEX
> +	bool "Kernel-only NV index"
> +	help
> +	  Allocate a TPM NV index and block userland from modifying it. This
> +	  allows the kernel to develop a unique state that distinguishes it
> +	  from userspace, making it possible to prove that a TPM object
> +	  was created by the kernel.
> +
>  source "drivers/char/tpm/st33zp24/Kconfig"
>  endif # TCG_TPM
> diff --git a/drivers/char/tpm/tpm-dev-common.c b/drivers/char/tpm/tpm-dev-common.c
> index f942c0c8e402..1fd93cdaf306 100644
> --- a/drivers/char/tpm/tpm-dev-common.c
> +++ b/drivers/char/tpm/tpm-dev-common.c
> @@ -15,18 +15,85 @@
>  #include <linux/poll.h>
>  #include <linux/slab.h>
>  #include <linux/uaccess.h>
> +#include <linux/unaligned.h>
>  #include <linux/workqueue.h>
>  #include "tpm.h"
>  #include "tpm-dev.h"
>  
>  static struct workqueue_struct *tpm_dev_wq;
>  
> +#ifdef CONFIG_TCG_TPM_KERNEL_NVINDEX
> +/*
> + * Commands that undefine or modify an NV index, and the position of the
> + * NV index in the command's handle area.
> + */
> +static const struct {
> +	u32 cc;
> +	unsigned int handle;
> +} tpm2_nv_modify_cmds[] = {
> +	{ TPM2_CC_NV_UNDEFINE_SPACE_SPECIAL,	0 },
> +	{ TPM2_CC_NV_UNDEFINE_SPACE,		1 },
> +	{ TPM2_CC_NV_INCREMENT,			1 },
> +	{ TPM2_CC_NV_SET_BITS,			1 },
> +	{ TPM2_CC_NV_EXTEND,			1 },
> +	{ TPM2_CC_NV_WRITE,			1 },
> +	{ TPM2_CC_NV_WRITE_LOCK,		1 },
> +	{ TPM2_CC_NV_CHANGE_AUTH,		0 },
> +	{ TPM2_CC_NV_READ_LOCK,			1 },
> +};
> +
> +/*
> + * Returns true if a command from userspace attempts to define, undefine
> + * or modify the kernel-owned NV index.
> + */
> +static bool tpm2_dev_cmd_is_blocked(const u8 *buf, size_t bufsiz)

This function could have less generic name.

tpm2_dev_is_kernel_nv_change?

I'm not a huge fan of this name either but it does say quite clearly
what the function does at least. Just a suggestion.


> +{
> +	const struct tpm_header *header = (const void *)buf;
> +	size_t len = min_t(size_t, be32_to_cpu(header->length), bufsiz);
> +	u32 cc;
> +	int i, index;
> +
> +	if (len < TPM_HEADER_SIZE)
> +		return false;
> +
> +	cc = be32_to_cpu(header->ordinal);
> +
> +	for (i = 0; i < ARRAY_SIZE(tpm2_nv_modify_cmds); i++) {
> +		size_t offset;
> +
> +		if (tpm2_nv_modify_cmds[i].cc != cc)
> +			continue;
> +
> +		offset = TPM_HEADER_SIZE +
> +			 tpm2_nv_modify_cmds[i].handle * sizeof(u32);
> +		if (len < offset + sizeof(u32))
> +			return false;

This will result -E2BIG in tpm_try_transmit() if I recall correctly.

Probably that's how it should be so that errnos are given at a single
location.

So not asking for anything :-)

> +
> +		index = get_unaligned_be32(&buf[offset]);
> +
> +		if (index == TPM2_KERNEL_NV_INDEX)
> +			return true;
> +	}
> +
> +	return false;
> +}
> +#else
> +static inline bool tpm2_dev_cmd_is_blocked(const u8 *buf, size_t bufsiz)
> +{
> +	return false;
> +}
> +#endif
> +
>  static ssize_t tpm_dev_transmit(struct tpm_chip *chip, struct tpm_space *space,
>  				u8 *buf, size_t bufsiz)
>  {
>  	struct tpm_header *header = (void *)buf;
>  	ssize_t ret, len;
>  
> +	if ((chip->flags & TPM_CHIP_FLAG_TPM2) &&
> +	    tpm2_dev_cmd_is_blocked(buf, bufsiz))
> +		return -EPERM;
> +
>  	if (chip->flags & TPM_CHIP_FLAG_TPM2)
>  		tpm2_end_auth_session(chip);
>  
> diff --git a/include/linux/tpm.h b/include/linux/tpm.h
> index 0db277af45c3..b6b862c3be3b 100644
> --- a/include/linux/tpm.h
> +++ b/include/linux/tpm.h
> @@ -178,6 +178,12 @@ static inline enum tpm2_mso_type tpm2_handle_mso(u32 handle)
>  	return handle >> 24;
>  }
>  
> +/*
> + * NV index reserved for use by the kernel. Userspace is not permitted to
> + * undefine or modify it.
> + */
> +#define TPM2_KERNEL_NV_INDEX	0x014c4853
> +
>  #define TPM_VID_INTEL    0x8086
>  #define TPM_VID_WINBOND  0x1050
>  #define TPM_VID_STM      0x104A
> diff --git a/include/linux/tpm_command.h b/include/linux/tpm_command.h
> index fc446a1282e2..79f547ca6dbf 100644
> --- a/include/linux/tpm_command.h
> +++ b/include/linux/tpm_command.h
> @@ -214,14 +214,24 @@ enum tpm2_return_codes {
>  
>  enum tpm2_command_codes {
>  	TPM2_CC_FIRST			= 0x011F,
> +	TPM2_CC_NV_UNDEFINE_SPACE_SPECIAL = 0x011F,
>  	TPM2_CC_HIERARCHY_CONTROL	= 0x0121,
> +	TPM2_CC_NV_UNDEFINE_SPACE	= 0x0122,
>  	TPM2_CC_HIERARCHY_CHANGE_AUTH	= 0x0129,
> +	TPM2_CC_NV_DEFINE_SPACE		= 0x012A,
>  	TPM2_CC_CREATE_PRIMARY		= 0x0131,
> +	TPM2_CC_NV_INCREMENT		= 0x0134,
> +	TPM2_CC_NV_SET_BITS		= 0x0135,
> +	TPM2_CC_NV_EXTEND		= 0x0136,
> +	TPM2_CC_NV_WRITE		= 0x0137,
> +	TPM2_CC_NV_WRITE_LOCK		= 0x0138,
> +	TPM2_CC_NV_CHANGE_AUTH		= 0x013B,
>  	TPM2_CC_SEQUENCE_COMPLETE	= 0x013E,
>  	TPM2_CC_SELF_TEST		= 0x0143,
>  	TPM2_CC_STARTUP			= 0x0144,
>  	TPM2_CC_SHUTDOWN		= 0x0145,
>  	TPM2_CC_NV_READ			= 0x014E,
> +	TPM2_CC_NV_READ_LOCK		= 0x014F,
>  	TPM2_CC_CREATE			= 0x0153,
>  	TPM2_CC_LOAD			= 0x0157,
>  	TPM2_CC_SEQUENCE_UPDATE		= 0x015C,
> -- 
> 2.43.0
> 
> 

Br, Jarkko
