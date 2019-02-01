From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] efi/arm: Don't expect a return value of ptdump_debugfs_register
Date: Fri, 1 Feb 2019 23:18:22 +0100
Message-ID: <CAKv+Gu9tcpZvMZdbD0D+EUCTbdnszv3+MHM68utLZssuMcxyZw@mail.gmail.com>
References: <20190201192001.6495-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190201192001.6495-1-natechancellor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 1 Feb 2019 at 20:21, Nathan Chancellor <natechancellor@gmail.com> wrote:
>
> As of commit e2a2e56e4082 ("arm64: dump: no need to check return value
> of debugfs_create functions") in the arm64 for-next/core branch,
> ptdump_debugfs_register does not have a return value, which causes a
> build error here:
>
> drivers/firmware/efi/arm-runtime.c:51:9: error: returning 'void' from a
> function with incompatible result type 'int'
>         return ptdump_debugfs_register(&efi_ptdump_info, "efi_page_tables");
>                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 1 error generated.
>
> The arm version is still awaiting acceptance [1] but in anticipation
> of that patch being merged, restructure this function to call
> ptdump_debugfs_register without expecting a return value.
>
> [1]: https://lore.kernel.org/lkml/20190122144114.9816-3-gregkh@linuxfoundation.org/
>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>


Catalin, Will,

Could you please apply this directly?

> ---
>  drivers/firmware/efi/arm-runtime.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
> index 23ea1ed409d1..7ae3b797caf8 100644
> --- a/drivers/firmware/efi/arm-runtime.c
> +++ b/drivers/firmware/efi/arm-runtime.c
> @@ -45,10 +45,10 @@ static struct ptdump_info efi_ptdump_info = {
>
>  static int __init ptdump_init(void)
>  {
> -       if (!efi_enabled(EFI_RUNTIME_SERVICES))
> -               return 0;
> +       if (efi_enabled(EFI_RUNTIME_SERVICES))
> +               ptdump_debugfs_register(&efi_ptdump_info, "efi_page_tables");
>
> -       return ptdump_debugfs_register(&efi_ptdump_info, "efi_page_tables");
> +       return 0;
>  }
>  device_initcall(ptdump_init);
>
> --
> 2.20.1
>
