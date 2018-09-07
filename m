From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH RESEND] efi_stub: update documentation on dtb= parameter
Date: Fri, 7 Sep 2018 12:43:25 +0200
Message-ID: <CAKv+Gu_k5Yr-aRhE6atrtGQOVpw60XfevVdUb8BvH1G3mfoU+Q@mail.gmail.com>
References: <20180906182927.22318-1-grant.likely@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180906182927.22318-1-grant.likely@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Grant Likely <grant.likely@arm.com>
Cc: linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Olof Johansson <olof@lixom.net>, Scott Branden <scott.branden@broadcom.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Leif Lindholm <leif.lindholm@linaro.org>, Alexander Graf <agraf@suse.de>, nd <nd@arm.com>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-efi@vger.kernel.org

On 6 September 2018 at 20:29, Grant Likely <grant.likely@arm.com> wrote:
> The dtb= parameter is no longer the primary mechanism for providing a
> devicetree to the kernel. Now either firmware or the boot selector (ex.
> Grub) should provide the devicetree and dtb= should only be used for
> debug or when using firmware that doesn't understand DT.
> Update the EFI stub documentation to reflect the current usage.
>
> Signed-off-by: Grant Likely <grant.likely@arm.com>
> Reviewed-by: Alexander Graf <agraf@suse.de>
> Acked-by: Leif Lindholm <leif.lindholm@linaro.org>
> Acked-by: Olof Johansson <olof@lixom.net>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Jonathan Corbet <corbet@lwn.net>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>


> ---
>
> Resending because original post included Arm corporate disclaimer.
>
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
