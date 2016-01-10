From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next] efi: Do not include asm/efi.h if not needed
Date: Sun, 10 Jan 2016 18:02:26 +0100
Message-ID: <CAKv+Gu-uK0sVuJPz0_e4Xy-754ZSrvsVAkoPeO6qdNY1EbwoXg@mail.gmail.com>
References: <1452440128-15134-1-git-send-email-linux@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452440128-15134-1-git-send-email-linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 10 January 2016 at 16:35, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org> wrote:
> Commit f7d924894265 ("arm64/efi: refactor EFI init and runtime code
> for reuse by 32-bit ARM") adds an include of asm/efi.h to efi.c.
> This causes a build failure for ia64, where asm/efi.h does not exist.
>
> drivers/firmware/efi/efi.c:28:21: fatal error:
>         asm/efi.h: No such file or directory
>
> asm/efi.h does not define or declare anything used by efi.c, thus
> including it should not be needed.
>
> Fixes: f7d924894265 ("arm64/efi: refactor EFI init and runtime code f=
or reuse by 32-bit ARM")
> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
> Signed-off-by: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>

This fixes ia64 but breaks ARM

drivers/firmware/efi/efi.c: In function =E2=80=98efi_mem_desc_lookup=E2=
=80=99:
drivers/firmware/efi/efi.c:291:3: error: implicit declaration of
function =E2=80=98early_memremap=E2=80=99 [-Werror=3Dimplicit-function-=
declaration]
drivers/firmware/efi/efi.c:291:6: warning: assignment makes pointer
from integer without a cast [enabled by default]
drivers/firmware/efi/efi.c:301:4: error: implicit declaration of
function =E2=80=98early_memunmap=E2=80=99 [-Werror=3Dimplicit-function-=
declaration]
drivers/firmware/efi/efi.c: In function =E2=80=98efi_config_parse_table=
s=E2=80=99:
drivers/firmware/efi/efi.c:404:7: warning: assignment makes pointer
from integer without a cast [enabled by default]
drivers/firmware/efi/efi.c: In function =E2=80=98efi_config_init=E2=80=99=
:
drivers/firmware/efi/efi.c:433:16: warning: assignment makes pointer
from integer without a cast [enabled by default]

> ---
>  drivers/firmware/efi/efi.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index cffa89b3317b..027ca212179f 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -25,8 +25,6 @@
>  #include <linux/io.h>
>  #include <linux/platform_device.h>
>
> -#include <asm/efi.h>
> -
>  struct efi __read_mostly efi =3D {
>         .mps                    =3D EFI_INVALID_TABLE_ADDR,
>         .acpi                   =3D EFI_INVALID_TABLE_ADDR,
> --
> 2.1.4
>
