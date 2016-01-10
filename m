From: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Subject: Re: [PATCH -next] efi: Do not include asm/efi.h if not needed
Date: Sun, 10 Jan 2016 11:47:26 -0800
Message-ID: <5692B54E.2020207@roeck-us.net>
References: <1452440128-15134-1-git-send-email-linux@roeck-us.net>
 <CAKv+Gu-uK0sVuJPz0_e4Xy-754ZSrvsVAkoPeO6qdNY1EbwoXg@mail.gmail.com>
 <CAKv+Gu96_7fZ15rK7-nuHyhs=c6VhrWz55r88Vjz9sdXOSP3uA@mail.gmail.com>
 <5692B375.2080600@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5692B375.2080600-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 01/10/2016 11:39 AM, Guenter Roeck wrote:
> On 01/10/2016 09:31 AM, Ard Biesheuvel wrote:
>> On 10 January 2016 at 18:02, Ard Biesheuvel <ard.biesheuvel@linaro.o=
rg> wrote:
>>> On 10 January 2016 at 16:35, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org> wro=
te:
>>>> Commit f7d924894265 ("arm64/efi: refactor EFI init and runtime cod=
e
>>>> for reuse by 32-bit ARM") adds an include of asm/efi.h to efi.c.
>>>> This causes a build failure for ia64, where asm/efi.h does not exi=
st.
>>>>
>>>> drivers/firmware/efi/efi.c:28:21: fatal error:
>>>>          asm/efi.h: No such file or directory
>>>>
>>>> asm/efi.h does not define or declare anything used by efi.c, thus
>>>> including it should not be needed.
>>>>
>>>> Fixes: f7d924894265 ("arm64/efi: refactor EFI init and runtime cod=
e for reuse by 32-bit ARM")
>>>> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>>> Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
>>>> Signed-off-by: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
>>>
>>> This fixes ia64 but breaks ARM
>>>
>>> drivers/firmware/efi/efi.c: In function =E2=80=98efi_mem_desc_looku=
p=E2=80=99:
>>> drivers/firmware/efi/efi.c:291:3: error: implicit declaration of
>>> function =E2=80=98early_memremap=E2=80=99 [-Werror=3Dimplicit-funct=
ion-declaration]
>>> drivers/firmware/efi/efi.c:291:6: warning: assignment makes pointer
>>> from integer without a cast [enabled by default]
>>> drivers/firmware/efi/efi.c:301:4: error: implicit declaration of
>>> function =E2=80=98early_memunmap=E2=80=99 [-Werror=3Dimplicit-funct=
ion-declaration]
>>> drivers/firmware/efi/efi.c: In function =E2=80=98efi_config_parse_t=
ables=E2=80=99:
>>> drivers/firmware/efi/efi.c:404:7: warning: assignment makes pointer
>>> from integer without a cast [enabled by default]
>>> drivers/firmware/efi/efi.c: In function =E2=80=98efi_config_init=E2=
=80=99:
>>> drivers/firmware/efi/efi.c:433:16: warning: assignment makes pointe=
r
>>> from integer without a cast [enabled by default]
>>>
>>
>> This means efi.c should include <asm/early_ioremap.h> but that does
>> not exist on ia64 either.
>> Perhaps add a #ifdef CONFIG_IA64?
>>
> #include <asm/io.h>
>
> I'll check if that works for all architectures.
>

=2E.. and it doesn't.

Ok, I give up on that one. I don't know what a proper fix would be.
My argument would be that the arm changes broke the build for ia64,
are therefore the culprit and should either be reverted or dropped.
But I'll leave that to the ia64 and efi maintainers to sort out.

Thanks,
Guenter
