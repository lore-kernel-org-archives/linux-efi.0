From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi/libstub: Indicate clang the relocation mode for arm64
Date: Wed, 10 May 2017 21:05:28 +0200
Message-ID: <69A18345-6933-4C6A-8FAC-DBD4D7EF30DE@linaro.org>
References: <20170509193612.64105-1-mka@chromium.org> <25d94b46-765e-f12f-a287-853c76782143@google.com> <20170509214905.GH128305@google.com> <CAKv+Gu_6my-rCc3E1V1n23dHY5OH97qpZ672ST8AZGLjedquAg@mail.gmail.com> <20170510183848.GI128305@google.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170510183848.GI128305-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthias Kaehlcke <mka-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Grant Grundler <grundler-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michael Davidson <md-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?utf-8?Q?Bernhard_Rosenkr=C3=A4nzer?= <Bernhard.Rosenkranzer-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org



> On 10 May 2017, at 20:38, Matthias Kaehlcke <mka-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
>=20
> Hoi Ard,
>=20
> El Wed, May 10, 2017 at 08:51:44AM +0100 Ard Biesheuvel ha dit:
>=20
>> On 9 May 2017 at 22:49, Matthias Kaehlcke <mka-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
>>> El Tue, May 09, 2017 at 01:50:36PM -0700 Greg Hackmann ha dit:
>>>=20
>>>> On 05/09/2017 12:36 PM, Matthias Kaehlcke wrote:
>>>>> From: Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>>>>=20
>>>>> Without any extra guidance, clang will generate libstub with either
>>>>> absolute or relative ELF relocations. Use the right combination of
>>>>> -fpic and -fno-pic on different files to avoid this.
>>>>>=20
>>>>> Signed-off-by: Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>>>> Signed-off-by: Bernhard Rosenkr=C3=A4nzer <Bernhard.Rosenkranzer@linar=
o.org>
>>>>> Signed-off-by: Matthias Kaehlcke <mka-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>>>>> ---
>>>>> drivers/firmware/efi/libstub/Makefile | 6 ++++++
>>>>> 1 file changed, 6 insertions(+)
>>>>>=20
>>>>> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/=
efi/libstub/Makefile
>>>>> index f7425960f6a5..ccbaaf4d8650 100644
>>>>> --- a/drivers/firmware/efi/libstub/Makefile
>>>>> +++ b/drivers/firmware/efi/libstub/Makefile
>>>>> @@ -11,6 +11,9 @@ cflags-$(CONFIG_X86)               +=3D -m$(BITS) -D=
__KERNEL__ -O2 \
>>>>>                               -mno-mmx -mno-sse
>>>>>=20
>>>>> cflags-$(CONFIG_ARM64)              :=3D $(subst -pg,,$(KBUILD_CFLAGS)=
)
>>>>> +ifeq ($(cc-name),clang)
>>>>> +cflags-$(CONFIG_ARM64)              +=3D -fpic
>>>>> +endif
>>>>> cflags-$(CONFIG_ARM)                :=3D $(subst -pg,,$(KBUILD_CFLAGS)=
) \
>>>>>                               -fno-builtin -fpic -mno-single-pic-base
>>>>>=20
>>>>> @@ -38,6 +41,9 @@ $(obj)/lib-%.o: $(srctree)/lib/%.c FORCE
>>>>>=20
>>>>> lib-$(CONFIG_EFI_ARMSTUB)   +=3D arm-stub.o fdt.o string.o random.o \
>>>>>                               $(patsubst %.c,lib-%.o,$(arm-deps))
>>>>> +ifeq ($(cc-name),clang)
>>>>> +CFLAGS_arm64-stub.o            +=3D -fno-pic
>>>>> +endif
>>>>>=20
>>>>> lib-$(CONFIG_ARM)           +=3D arm32-stub.o
>>>>> lib-$(CONFIG_ARM64)         +=3D arm64-stub.o
>>>>>=20
>>>>=20
>>>> NAK.
>>>>=20
>>>> This patch was labeled "HACK:" in our experimental tree.  There's no
>>>> rhyme or reason to why this combination of -f[no-]pic flags
>>>> generates code without problematic relocations.  It's inherently
>>>> fragile, and was only intended as a temporary workaround until I (or
>>>> someone more familiar with EFI) got a chance to revisit the problem.
>>>>=20
>>>> Unless the gcc CFLAGS are also an artifact of "mess with -f[no-]pic
>>>> until the compiler generates what you want", this doesn't belong
>>>> upstream.
>>>=20
>>> Sorry, I didn't realize it is that bad of a hack. Unfortunately I'm
>>> not very familiar with EFI either.
>>>=20
>>> I saw Ard did some work in this code related with relocation, maybe he
>>> can provide a pointer towards a better solution.
>>>=20
>>=20
>> This is a known issue. The problem is that generic AArch64 small model
>> code is mostly position independent already, due to its use of
>> adrp/add pairs to generate symbol references with a +/- 4 GB range.
>> Building the same code with -fpic will result in GOT entries to be
>> generated, which carry absolute addresses, so this achieves the exact
>> opposite of what we want.
>>=20
>> The reason for the GOT entries is that GCC (and Clang, apparently)
>> infer from the -fpic flag that you are building objects that will be
>> linked into a shared library, to which ELF symbol preemption rules
>> apply that stipulate that a symbol in the main executable supersedes a
>> symbol under the same name in the shared library, and that the shared
>> library should update all its internal references to the main
>> executable's version of the symbol. The easiest way (but certainly not
>> the only way) to achieve that is to indirect all internal symbol
>> references via GOT entries, which can be made to refer to another
>> symbol by updating a single value.
>>=20
>> The workaround I used is to use hidden visibility, using a #pragma.
>> (There is a -fvisibility=3Dhidden command line option as well, but this
>> is a weaker form that does not apply to extern declarations, only to
>> definitions). So if you add
>>=20
>> #pragma GCC visibility push(hidden)
>>=20
>> at the beginning of arm64-stub.c (and perhaps to one or two other
>> files that contain externally visible symbol declarations these days),
>> you should be able to compile the entire EFI stub with -fpic. Note
>> that making those externally visible symbols 'static' where possible
>> would solve the problem as well, but this triggers another issue in
>> the 32-bit ARM stub.
>>=20
>> In my opinion, the correct fix would be to make -fpie (as opposed to
>> -fpic) imply hidden visibility, given that PIE executables don't
>> export symbols in the first place, and so the preemption rules do not
>> apply. It is worth a try whether -fpie works as expected in this case
>> on Clang, but the last time I tried it on GCC, it behaved exactly like
>> -fpic.
>=20
> Thanks a lot for the detailed description and your suggestions!
>=20
> A clang build with -fpie for the EFI stub succeeds without complaints
> about GOT entries. I will send out an updated patch (with -fpie only
> for clang) later.
>=20

Good! I never liked the visibility hack, which is why I never upstreamed it.=


Could you please check how recent GCC behaves?=
