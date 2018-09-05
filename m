From: Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH] efi_stub: update documentation on dtb= parameter
Date: Wed, 5 Sep 2018 21:39:51 +0200
Message-ID: <8bed0e5b-cfb7-e1dd-199d-9643b964cb9d@suse.de>
References: <20180905190750.4566-1-grant.likely@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180905190750.4566-1-grant.likely@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Grant Likely <grant.likely@arm.com>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: olof@lixom.net, scott.branden@broadcom.com, catalin.marinas@arm.com, will.deacon@arm.com, arnd@arndb.de, leif.lindholm@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-efi@vger.kernel.org



On 05.09.18 21:07, Grant Likely wrote:
> The dtb= parameter is no longer the primary mechanism for providing a
> devicetree to the kernel. Now either firmware or the boot selector (ex.
> Grub) should provide the devicetree and dtb= should only be used for
> debug or when using firmware that doesn't understand DT.
> Update the EFI stub documentation to reflect the current usage.
> 
> Signed-off-by: Grant Likely <grant.likely@arm.com>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Jonathan Corbet <corbet@lwn.net>

Reviewed-by: Alexander Graf <agraf@suse.de>

Btw, isn't the option missing from kernel-parameters.rst/txt?


Alex

> ---
>  Documentation/efi-stub.txt | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/efi-stub.txt b/Documentation/efi-stub.txt
> index 41df801f9a50..833edb0d0bc4 100644
> --- a/Documentation/efi-stub.txt
> +++ b/Documentation/efi-stub.txt
> @@ -83,7 +83,18 @@ is passed to bzImage.efi.
>  The "dtb=" option
>  -----------------
> 
> -For the ARM and arm64 architectures, we also need to be able to provide a
> -device tree to the kernel. This is done with the "dtb=" command line option,
> -and is processed in the same manner as the "initrd=" option that is
> +For the ARM and arm64 architectures, a device tree must be provided to
> +the kernel. Normally firmware shall supply the device tree via the
> +EFI CONFIGURATION TABLE. However, the "dtb=" command line option can
> +be used to override the firmware supplied device tree, or to supply
> +one when firmware is unable to.
> +
> +Please note: Firmware adds runtime configuration information to the
> +device tree before booting the kernel. If dtb= is used to override
> +the device tree, then any runtime data provided by firmware will be
> +lost. The dtb= option should only be used either as a debug tool, or
> +as a last resort when a device tree is not provided in the EFI
> +CONFIGURATION TABLE.
> +
> +"dtb=" is processed in the same manner as the "initrd=" option that is
>  described above.
> --
> 2.11.0
> 
> IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
> 
