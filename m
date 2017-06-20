From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2 18/31] efi-stub.txt: standardize document format
Date: Tue, 20 Jun 2017 09:02:53 +0200
Message-ID: <CAKv+Gu8=6pF9uawA92p0fsfC6a6DV4gd9NaLjiqgLQKd7TNwVA@mail.gmail.com>
References: <f0f77a106d183325dce9eecd3c11214154050e11.1497713142.git.mchehab@s-opensource.com>
 <66bd3bc59477944b65a010904ff7f812d3f48d7c.1497713142.git.mchehab@s-opensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <66bd3bc59477944b65a010904ff7f812d3f48d7c.1497713142.git.mchehab@s-opensource.com>
Sender: linux-doc-owner@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>, Leif Lindholm <leif.lindholm@linaro.org>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 17 June 2017 at 17:25, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> Each text file under Documentation follows a different
> format. Some doesn't even have titles!
>
> Change its representation to follow the adopted standard,
> using ReST markups for it to be parseable by Sphinx:
>
> - use proper markups for titles;
> - identify literal blocks.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>


> ---
>  Documentation/efi-stub.txt | 25 +++++++++++++++----------
>  1 file changed, 15 insertions(+), 10 deletions(-)
>
> diff --git a/Documentation/efi-stub.txt b/Documentation/efi-stub.txt
> index e15746988261..41df801f9a50 100644
> --- a/Documentation/efi-stub.txt
> +++ b/Documentation/efi-stub.txt
> @@ -1,5 +1,6 @@
> -                         The EFI Boot Stub
> -                    ---------------------------
> +=================
> +The EFI Boot Stub
> +=================
>
>  On the x86 and ARM platforms, a kernel zImage/bzImage can masquerade
>  as a PE/COFF image, thereby convincing EFI firmware loaders to load
> @@ -25,7 +26,8 @@ a certain sense it *IS* the boot loader.
>  The EFI boot stub is enabled with the CONFIG_EFI_STUB kernel option.
>
>
> -**** How to install bzImage.efi
> +How to install bzImage.efi
> +--------------------------
>
>  The bzImage located in arch/x86/boot/bzImage must be copied to the EFI
>  System Partition (ESP) and renamed with the extension ".efi". Without
> @@ -37,14 +39,16 @@ may not need to be renamed. Similarly for arm64, arch/arm64/boot/Image
>  should be copied but not necessarily renamed.
>
>
> -**** Passing kernel parameters from the EFI shell
> +Passing kernel parameters from the EFI shell
> +--------------------------------------------
>
> -Arguments to the kernel can be passed after bzImage.efi, e.g.
> +Arguments to the kernel can be passed after bzImage.efi, e.g.::
>
>         fs0:> bzImage.efi console=ttyS0 root=/dev/sda4
>
>
> -**** The "initrd=" option
> +The "initrd=" option
> +--------------------
>
>  Like most boot loaders, the EFI stub allows the user to specify
>  multiple initrd files using the "initrd=" option. This is the only EFI
> @@ -54,9 +58,9 @@ kernel when it boots.
>  The path to the initrd file must be an absolute path from the
>  beginning of the ESP, relative path names do not work. Also, the path
>  is an EFI-style path and directory elements must be separated with
> -backslashes (\). For example, given the following directory layout,
> +backslashes (\). For example, given the following directory layout::
>
> -fs0:>
> +  fs0:>
>         Kernels\
>                         bzImage.efi
>                         initrd-large.img
> @@ -66,7 +70,7 @@ fs0:>
>                         initrd-medium.img
>
>  to boot with the initrd-large.img file if the current working
> -directory is fs0:\Kernels, the following command must be used,
> +directory is fs0:\Kernels, the following command must be used::
>
>         fs0:\Kernels> bzImage.efi initrd=\Kernels\initrd-large.img
>
> @@ -76,7 +80,8 @@ which understands relative paths, whereas the rest of the command line
>  is passed to bzImage.efi.
>
>
> -**** The "dtb=" option
> +The "dtb=" option
> +-----------------
>
>  For the ARM and arm64 architectures, we also need to be able to provide a
>  device tree to the kernel. This is done with the "dtb=" command line option,
> --
> 2.9.4
>
