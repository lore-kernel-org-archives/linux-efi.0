From: Stefan Agner <stefan@agner.ch>
Subject: Re: [PATCH] efi/libstub: arm: support building with clang
Date: Sat, 11 Aug 2018 10:49:14 +0200
Message-ID: <32f5ce9b26a386e81857afcd7d135bad@agner.ch>
References: <20180809164042.210675-1-astrachan@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180809164042.210675-1-astrachan@google.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Alistair Strachan <astrachan@google.com>
Cc: linux-efi@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Will Deacon <will.deacon@arm.com>, Russell King <linux@armlinux.org.uk>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

On 09.08.2018 18:40, Alistair Strachan wrote:
> When building with CONFIG_EFI and CONFIG_EFI_STUB on ARM, the libstub
> Makefile would use -mno-single-pic-base without checking it was
> supported by the compiler. As the ARM (32-bit) clang backend does not
> support this flag, the build would fail.
> 
> This changes the Makefile to check the compiler's support for
> -mno-single-pic-base before using it, similar to c1c386681bd7 ("ARM:
> 8767/1: add support for building ARM kernel with clang").

Looks good to me:

Reviewed-by: Stefan Agner <stefan@agner.ch>

> 
> Cc: Stefan Agner <stefan@agner.ch>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: linux-efi@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Signed-off-by: Alistair Strachan <astrachan@google.com>
> ---
>  drivers/firmware/efi/libstub/Makefile | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/firmware/efi/libstub/Makefile
> b/drivers/firmware/efi/libstub/Makefile
> index a34e9290a699..91339d13f2a1 100644
> --- a/drivers/firmware/efi/libstub/Makefile
> +++ b/drivers/firmware/efi/libstub/Makefile
> @@ -13,7 +13,8 @@ cflags-$(CONFIG_X86)		+= -m$(BITS) -D__KERNEL__ -O2 \
>  
>  cflags-$(CONFIG_ARM64)		:= $(subst -pg,,$(KBUILD_CFLAGS)) -fpie
>  cflags-$(CONFIG_ARM)		:= $(subst -pg,,$(KBUILD_CFLAGS)) \
> -				   -fno-builtin -fpic -mno-single-pic-base
> +				   -fno-builtin -fpic \
> +				   $(call cc-option,-mno-single-pic-base)
>  
>  cflags-$(CONFIG_EFI_ARMSTUB)	+= -I$(srctree)/scripts/dtc/libfdt
