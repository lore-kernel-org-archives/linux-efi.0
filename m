From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH -next] efi: Do not include asm/efi.h if not needed
Date: Sun, 10 Jan 2016 18:31:14 +0100
Message-ID: <CAKv+Gu96_7fZ15rK7-nuHyhs=c6VhrWz55r88Vjz9sdXOSP3uA@mail.gmail.com>
References: <1452440128-15134-1-git-send-email-linux@roeck-us.net>
	<CAKv+Gu-uK0sVuJPz0_e4Xy-754ZSrvsVAkoPeO6qdNY1EbwoXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu-uK0sVuJPz0_e4Xy-754ZSrvsVAkoPeO6qdNY1EbwoXg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Guenter Roeck <linux@roeck-us.net>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Will Deacon <will.deacon@arm.com>
List-Id: linux-efi@vger.kernel.org

On 10 January 2016 at 18:02, Ard Biesheuvel <ard.biesheuvel@linaro.org>=
 wrote:
> On 10 January 2016 at 16:35, Guenter Roeck <linux@roeck-us.net> wrote=
:
>> Commit f7d924894265 ("arm64/efi: refactor EFI init and runtime code
>> for reuse by 32-bit ARM") adds an include of asm/efi.h to efi.c.
>> This causes a build failure for ia64, where asm/efi.h does not exist=
=2E
>>
>> drivers/firmware/efi/efi.c:28:21: fatal error:
>>         asm/efi.h: No such file or directory
>>
>> asm/efi.h does not define or declare anything used by efi.c, thus
>> including it should not be needed.
>>
>> Fixes: f7d924894265 ("arm64/efi: refactor EFI init and runtime code =
for reuse by 32-bit ARM")
>> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> Cc: Will Deacon <will.deacon@arm.com>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>
> This fixes ia64 but breaks ARM
>
> drivers/firmware/efi/efi.c: In function =E2=80=98efi_mem_desc_lookup=E2=
=80=99:
> drivers/firmware/efi/efi.c:291:3: error: implicit declaration of
> function =E2=80=98early_memremap=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
> drivers/firmware/efi/efi.c:291:6: warning: assignment makes pointer
> from integer without a cast [enabled by default]
> drivers/firmware/efi/efi.c:301:4: error: implicit declaration of
> function =E2=80=98early_memunmap=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
> drivers/firmware/efi/efi.c: In function =E2=80=98efi_config_parse_tab=
les=E2=80=99:
> drivers/firmware/efi/efi.c:404:7: warning: assignment makes pointer
> from integer without a cast [enabled by default]
> drivers/firmware/efi/efi.c: In function =E2=80=98efi_config_init=E2=80=
=99:
> drivers/firmware/efi/efi.c:433:16: warning: assignment makes pointer
> from integer without a cast [enabled by default]
>

This means efi.c should include <asm/early_ioremap.h> but that does
not exist on ia64 either.
Perhaps add a #ifdef CONFIG_IA64?

>> ---
>>  drivers/firmware/efi/efi.c | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
>> index cffa89b3317b..027ca212179f 100644
>> --- a/drivers/firmware/efi/efi.c
>> +++ b/drivers/firmware/efi/efi.c
>> @@ -25,8 +25,6 @@
>>  #include <linux/io.h>
>>  #include <linux/platform_device.h>
>>
>> -#include <asm/efi.h>
>> -
>>  struct efi __read_mostly efi =3D {
>>         .mps                    =3D EFI_INVALID_TABLE_ADDR,
>>         .acpi                   =3D EFI_INVALID_TABLE_ADDR,
>> --
>> 2.1.4
>>
