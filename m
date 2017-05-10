From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] efi/libstub: Indicate clang the relocation mode for arm64
Date: Wed, 10 May 2017 08:51:44 +0100
Message-ID: <CAKv+Gu_6my-rCc3E1V1n23dHY5OH97qpZ672ST8AZGLjedquAg@mail.gmail.com>
References: <20170509193612.64105-1-mka@chromium.org> <25d94b46-765e-f12f-a287-853c76782143@google.com>
 <20170509214905.GH128305@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170509214905.GH128305@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthias Kaehlcke <mka@chromium.org>
Cc: Greg Hackmann <ghackmann@google.com>, Matt Fleming <matt@codeblueprint.co.uk>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Grant Grundler <grundler@chromium.org>, Michael Davidson <md@google.com>, =?UTF-8?Q?Bernhard_Rosenkr=C3=A4nzer?= <Bernhard.Rosenkranzer@linaro.org>
List-Id: linux-efi@vger.kernel.org

On 9 May 2017 at 22:49, Matthias Kaehlcke <mka@chromium.org> wrote:
> El Tue, May 09, 2017 at 01:50:36PM -0700 Greg Hackmann ha dit:
>
>> On 05/09/2017 12:36 PM, Matthias Kaehlcke wrote:
>> >From: Greg Hackmann <ghackmann@google.com>
>> >
>> >Without any extra guidance, clang will generate libstub with either
>> >absolute or relative ELF relocations. Use the right combination of
>> >-fpic and -fno-pic on different files to avoid this.
>> >
>> >Signed-off-by: Greg Hackmann <ghackmann@google.com>
>> >Signed-off-by: Bernhard Rosenkr=C3=A4nzer <Bernhard.Rosenkranzer@linaro=
.org>
>> >Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
>> >---
>> > drivers/firmware/efi/libstub/Makefile | 6 ++++++
>> > 1 file changed, 6 insertions(+)
>> >
>> >diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/e=
fi/libstub/Makefile
>> >index f7425960f6a5..ccbaaf4d8650 100644
>> >--- a/drivers/firmware/efi/libstub/Makefile
>> >+++ b/drivers/firmware/efi/libstub/Makefile
>> >@@ -11,6 +11,9 @@ cflags-$(CONFIG_X86)               +=3D -m$(BITS) -D_=
_KERNEL__ -O2 \
>> >                                -mno-mmx -mno-sse
>> >
>> > cflags-$(CONFIG_ARM64)              :=3D $(subst -pg,,$(KBUILD_CFLAGS)=
)
>> >+ifeq ($(cc-name),clang)
>> >+cflags-$(CONFIG_ARM64)              +=3D -fpic
>> >+endif
>> > cflags-$(CONFIG_ARM)                :=3D $(subst -pg,,$(KBUILD_CFLAGS)=
) \
>> >                                -fno-builtin -fpic -mno-single-pic-base
>> >
>> >@@ -38,6 +41,9 @@ $(obj)/lib-%.o: $(srctree)/lib/%.c FORCE
>> >
>> > lib-$(CONFIG_EFI_ARMSTUB)   +=3D arm-stub.o fdt.o string.o random.o \
>> >                                $(patsubst %.c,lib-%.o,$(arm-deps))
>> >+ifeq ($(cc-name),clang)
>> >+CFLAGS_arm64-stub.o            +=3D -fno-pic
>> >+endif
>> >
>> > lib-$(CONFIG_ARM)           +=3D arm32-stub.o
>> > lib-$(CONFIG_ARM64)         +=3D arm64-stub.o
>> >
>>
>> NAK.
>>
>> This patch was labeled "HACK:" in our experimental tree.  There's no
>> rhyme or reason to why this combination of -f[no-]pic flags
>> generates code without problematic relocations.  It's inherently
>> fragile, and was only intended as a temporary workaround until I (or
>> someone more familiar with EFI) got a chance to revisit the problem.
>>
>> Unless the gcc CFLAGS are also an artifact of "mess with -f[no-]pic
>> until the compiler generates what you want", this doesn't belong
>> upstream.
>
> Sorry, I didn't realize it is that bad of a hack. Unfortunately I'm
> not very familiar with EFI either.
>
> I saw Ard did some work in this code related with relocation, maybe he
> can provide a pointer towards a better solution.
>

This is a known issue. The problem is that generic AArch64 small model
code is mostly position independent already, due to its use of
adrp/add pairs to generate symbol references with a +/- 4 GB range.
Building the same code with -fpic will result in GOT entries to be
generated, which carry absolute addresses, so this achieves the exact
opposite of what we want.

The reason for the GOT entries is that GCC (and Clang, apparently)
infer from the -fpic flag that you are building objects that will be
linked into a shared library, to which ELF symbol preemption rules
apply that stipulate that a symbol in the main executable supersedes a
symbol under the same name in the shared library, and that the shared
library should update all its internal references to the main
executable's version of the symbol. The easiest way (but certainly not
the only way) to achieve that is to indirect all internal symbol
references via GOT entries, which can be made to refer to another
symbol by updating a single value.

The workaround I used is to use hidden visibility, using a #pragma.
(There is a -fvisibility=3Dhidden command line option as well, but this
is a weaker form that does not apply to extern declarations, only to
definitions). So if you add

#pragma GCC visibility push(hidden)

at the beginning of arm64-stub.c (and perhaps to one or two other
files that contain externally visible symbol declarations these days),
you should be able to compile the entire EFI stub with -fpic. Note
that making those externally visible symbols 'static' where possible
would solve the problem as well, but this triggers another issue in
the 32-bit ARM stub.

In my opinion, the correct fix would be to make -fpie (as opposed to
-fpic) imply hidden visibility, given that PIE executables don't
export symbols in the first place, and so the preemption rules do not
apply. It is worth a try whether -fpie works as expected in this case
on Clang, but the last time I tried it on GCC, it behaved exactly like
-fpic.
