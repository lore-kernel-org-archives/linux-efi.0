Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3473F2118;
	Tue, 15 Sep 2026 17:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789491778; cv=none; b=kbYQHo/c79lWaohnJFqjFnHUv0qEGphTOqeIiQyTfw6zW6TX3QtxuTBggcCIlJMO8MwaC66xrRZjoY1oSUoswH3Qmb0lJv9PLEGVL4tYMojJj25pfdEBacQpna16eGEtrLuPYUmpgK/fHaMoKJV/jF1PEv0u1KXOXLO/wxbcVDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789491778; c=relaxed/simple;
	bh=HQQcSvXWwWkznCA2oz45yowmtAQOi+aqkAekUHPwtxI=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=cJBQel64JTKVdASwVSq2Nkmq/ZZFoyJcFYJCHu44fCrS3xt2XeWbh8ZKw9WcfxcFsGCQQ1npze5904yOnnoJo8uckkQtDJdo7hz/3PlXEqb5Lq+O0PoXuoLxbc15vxdKo/LPqh0Ec8tC5cScotcnKZfcG+RQC8xi9SMm6NNf5ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l29wTyxC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l29wTyxC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079281F000FF;
	Tue, 15 Sep 2026 17:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789491776;
	bh=WTXKV6wijB+L2zgRoU/8AHp8dn9P8hPtyu3Zx1VPL+0=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=l29wTyxC6FhDaQS8M/8A306/NCuQLDXn4drwuAarN43UAzz0IrGw2it1NK1KdSyzg
	 GemuyhqgyTs7m+44kFz+SLQPRkDdmMIWbpT3tLRSCvP6N+fo8oFE5GHNq9W/TKidH4
	 DTDxcwglfYR+DcdHiuHZJ4xUtho2tgvqV1hRmvy2kqh4aIz30UGHS4v+jTKUJEAEzK
	 GaNIh67ML+THgYoz0LlgHy2y1hi22DvorrLhmn6uQ2fCKwSoxBUgSGdnyUcehmZ5no
	 jBGNbycFYQqYyLhcl3kXGhW+Lap+cl066HVDbl+fQsfxSyK2H7pXkE8yUOi9qD+joa
	 d9LLeqqEEhlAw==
Message-ID: <2febb9ac-6b25-4037-8cdb-f8fe5734ec01@kernel.org>
Date: Tue, 15 Sep 2026 19:02:53 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vincent Mailhol <mailhol@kernel.org>
Subject: Re: [PATCH v2 10/10] efi/libstub: add initial Boot Loader Interface
 support
To: Ard Biesheuvel <ardb+git@google.com>, linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 x86@kernel.org
References: <20260909115530.1924665-12-ardb+git@google.com>
 <20260909115530.1924665-22-ardb+git@google.com>
Content-Language: en-US
Autocrypt: addr=mailhol@kernel.org; keydata=
 xjMEZluomRYJKwYBBAHaRw8BAQdAf+/PnQvy9LCWNSJLbhc+AOUsR2cNVonvxhDk/KcW7FvN
 JFZpbmNlbnQgTWFpbGhvbCA8bWFpbGhvbEBrZXJuZWwub3JnPsKZBBMWCgBBFiEE7Y9wBXTm
 fyDldOjiq1/riG27mcIFAmdfB/kCGwMFCQp/CJcFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcC
 F4AACgkQq1/riG27mcKBHgEAygbvORJOfMHGlq5lQhZkDnaUXbpZhxirxkAHwTypHr4A/joI
 2wLjgTCm5I2Z3zB8hqJu+OeFPXZFWGTuk0e2wT4JzjgEZx4y8xIKKwYBBAGXVQEFAQEHQJrb
 YZzu0JG5w8gxE6EtQe6LmxKMqP6EyR33sA+BR9pLAwEIB8J+BBgWCgAmFiEE7Y9wBXTmfyDl
 dOjiq1/riG27mcIFAmceMvMCGwwFCQPCZwAACgkQq1/riG27mcJU7QEA+LmpFhfQ1aij/L8V
 zsZwr/S44HCzcz5+jkxnVVQ5LZ4BANOCpYEY+CYrld5XZvM8h2EntNnzxHHuhjfDOQ3MAkEK
In-Reply-To: <20260909115530.1924665-22-ardb+git@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 9/9/26 13:55, Ard Biesheuvel wrote:
> From: Vincent Mailhol <mailhol@kernel.org>
> 
> The Boot Loader Interface (BLI) [1] defines EFI variables that expose
> boot loader state to the running OS. LoaderInfo identifies the boot
> loader, while LoaderDevicePartUUID records the GPT partition UUID of
> the partition containing it.
> 
> LoaderDevicePartUUID is used, for example, by systemd-gpt-auto-generator
> [2] to identify the disk the boot loader was launched from and
> automatically detect and mount partitions on it.
> 
> GRUB [3] and systemd-boot [4] populate these variables, but when the
> kernel is started directly by EFI firmware, there is no conventional
> external boot loader to provide them. In that case, because the EFI stub
> performs the boot loader role, it should provide the variables itself.
> 
> Use LoaderInfo as a sentinel: if it is already set by an earlier boot
> stage or cannot be set, bail out. Otherwise, populate the other BLI
> variables.
> 
> Parse the loaded image device path, extract the GUID signature from its
> GPT HD() node and publish it under the Linux loader entry vendor GUID as
> the volatile LoaderDevicePartUUID EFI variable.
> 
> Install the efi_bli_set_variables() hook in both the generic efi-stub.c
> path and the x86-specific x86-stub.c path.
> 
> [1] The Boot Loader Interface
> Link: https://systemd.io/BOOT_LOADER_INTERFACE/
> 
> [2] systemd-gpt-auto-generator
> Link: https://www.freedesktop.org/software/systemd/man/latest/systemd-gpt-auto-generator.html
> 
> [3] GRUB -- §16.2 bli
> Link: https://www.gnu.org/software/grub/manual/grub/html_node/bli_005fmodule.html
> 
> [4] systemd -- systemd-boot UEFI Boot Manager
> Link: https://github.com/systemd/systemd/blob/main/docs/BOOT.md?plain=1#L102
> 
> Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
> [ardb: - constify 'image' pointer parameter
>        - pass efi_guid_t* to efi_snprintf()]
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---

(...)

> diff --git a/drivers/firmware/efi/libstub/bli.c b/drivers/firmware/efi/libstub/bli.c
> new file mode 100644
> index 000000000000..b2407f63b743
> --- /dev/null
> +++ b/drivers/firmware/efi/libstub/bli.c
> @@ -0,0 +1,87 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <generated/utsrelease.h>
> +
> +#include <linux/efi.h>
> +#include <linux/errno.h>

<linux/errno.h> is not needed anymore following the changes in v3.

(Sorry, this is my mistake)

> +#include <linux/unaligned.h>
> +
> +#include "efistub.h"

(...)


Yours sincerely,
Vincent Mailhol
