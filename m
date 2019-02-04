From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] firmware: efi: arm-runtime: fix build error void value
 not ignored
Date: Mon, 4 Feb 2019 14:42:30 +0100
Message-ID: <CAKv+Gu80Pct6z9K2HSHHxNGQR=LM37e82h9Wgi5pyHFsGXZyyA@mail.gmail.com>
References: <20190204132904.9288-1-anders.roxell@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190204132904.9288-1-anders.roxell@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Anders Roxell <anders.roxell@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Cc: linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 4 Feb 2019 at 14:29, Anders Roxell <anders.roxell@linaro.org> wrote=
:
>
> Commit e2a2e56e4082 ("arm64: dump: no need to check return value of debug=
fs_create functions")
> changed the return value from 'int' to 'void'.
>
> ../drivers/firmware/efi/arm-runtime.c: In function =E2=80=98ptdump_init=
=E2=80=99:
> ../drivers/firmware/efi/arm-runtime.c:52:9: error: void value not ignored=
 as it ought to be
>   return ptdump_debugfs_register(&efi_ptdump_info, "efi_page_tables");
>          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/firmware/efi/arm-runtime.c:53:1: warning: control reaches end =
of non-void function [-Wreturn-type]
>  }
>  ^
>
> Rework so that function 'ptdump_init' doesn't 'return
> ptdump_debug_fs_register(...' since the function can work or not, but
> the code logic should never do something different based on this.
>
> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>

Hi Anders,

Thanks for the fix.

Someone else spotted the same bug, and sent a similar fix, and I asked
Will or Catalin to take it through the arm64 for-next tree since this
is where the offending patch lives.

So for either this patch or for the other one

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>



> ---
>  drivers/firmware/efi/arm-runtime.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/ar=
m-runtime.c
> index 352bd2473162..b9ae798192d6 100644
> --- a/drivers/firmware/efi/arm-runtime.c
> +++ b/drivers/firmware/efi/arm-runtime.c
> @@ -49,7 +49,8 @@ static int __init ptdump_init(void)
>         if (!efi_enabled(EFI_RUNTIME_SERVICES))
>                 return 0;
>
> -       return ptdump_debugfs_register(&efi_ptdump_info, "efi_page_tables=
");
> +       ptdump_debugfs_register(&efi_ptdump_info, "efi_page_tables");
> +       return 0;
>  }
>  device_initcall(ptdump_init);
>
> --
> 2.20.1
>
