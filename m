From: Matthias Kaehlcke <mka-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH] efi/libstub: Indicate clang the relocation mode for arm64
Date: Wed, 17 May 2017 09:09:56 -0700
Message-ID: <20170517160956.GE141096@google.com>
References: <20170509193612.64105-1-mka@chromium.org>
 <25d94b46-765e-f12f-a287-853c76782143@google.com>
 <20170509214905.GH128305@google.com>
 <CAKv+Gu_6my-rCc3E1V1n23dHY5OH97qpZ672ST8AZGLjedquAg@mail.gmail.com>
 <20170510183848.GI128305@google.com>
 <69A18345-6933-4C6A-8FAC-DBD4D7EF30DE@linaro.org>
 <20170510194734.GJ128305@google.com>
 <CAKv+Gu8H9H=Rax4iiKaZ2z2GikXTjseCAyKrYgQPQWkekjsN8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8H9H=Rax4iiKaZ2z2GikXTjseCAyKrYgQPQWkekjsN8w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Grant Grundler <grundler-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michael Davidson <md-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Bernhard =?utf-8?Q?Rosenkr=C3=A4nzer?= <Bernhard.Rosenkranzer-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

El Thu, May 11, 2017 at 02:51:48PM +0100 Ard Biesheuvel ha dit:

> (adding Arnd and Will to cc, who are likely to have an opinion as to
> which GCC is the oldest we need to support for arm64)
> 
> On 10 May 2017 at 20:47, Matthias Kaehlcke <mka-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
> > El Wed, May 10, 2017 at 09:05:28PM +0200 Ard Biesheuvel ha dit:
> >
> >>
> >>
> >> > On 10 May 2017, at 20:38, Matthias Kaehlcke <mka-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
> >> >
> >> > Hoi Ard,
> >> >
> >> > El Wed, May 10, 2017 at 08:51:44AM +0100 Ard Biesheuvel ha dit:
> >> >
> >> >> On 9 May 2017 at 22:49, Matthias Kaehlcke <mka-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
> >> >>> El Tue, May 09, 2017 at 01:50:36PM -0700 Greg Hackmann ha dit:
> >> >>>
> >> >>>> On 05/09/2017 12:36 PM, Matthias Kaehlcke wrote:
> >> >>>>> From: Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >> >>>>>
> >> >>>>> Without any extra guidance, clang will generate libstub with either
> >> >>>>> absolute or relative ELF relocations. Use the right combination of
> >> >>>>> -fpic and -fno-pic on different files to avoid this.
> >> >>>>>
> >> >>>>> Signed-off-by: Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >> >>>>> Signed-off-by: Bernhard Rosenkränzer <Bernhard.Rosenkranzer-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> >> >>>>> Signed-off-by: Matthias Kaehlcke <mka-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> >> >>>>> ---
> >> >>>>> drivers/firmware/efi/libstub/Makefile | 6 ++++++
> >> >>>>> 1 file changed, 6 insertions(+)
> >> >>>>>
> >> >>>>> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
> >> >>>>> index f7425960f6a5..ccbaaf4d8650 100644
> >> >>>>> --- a/drivers/firmware/efi/libstub/Makefile
> >> >>>>> +++ b/drivers/firmware/efi/libstub/Makefile
> >> >>>>> @@ -11,6 +11,9 @@ cflags-$(CONFIG_X86)               += -m$(BITS) -D__KERNEL__ -O2 \
> >> >>>>>                               -mno-mmx -mno-sse
> >> >>>>>
> >> >>>>> cflags-$(CONFIG_ARM64)              := $(subst -pg,,$(KBUILD_CFLAGS))
> >> >>>>> +ifeq ($(cc-name),clang)
> >> >>>>> +cflags-$(CONFIG_ARM64)              += -fpic
> >> >>>>> +endif
> >> >>>>> cflags-$(CONFIG_ARM)                := $(subst -pg,,$(KBUILD_CFLAGS)) \
> >> >>>>>                               -fno-builtin -fpic -mno-single-pic-base
> >> >>>>>
> >> >>>>> @@ -38,6 +41,9 @@ $(obj)/lib-%.o: $(srctree)/lib/%.c FORCE
> >> >>>>>
> >> >>>>> lib-$(CONFIG_EFI_ARMSTUB)   += arm-stub.o fdt.o string.o random.o \
> >> >>>>>                               $(patsubst %.c,lib-%.o,$(arm-deps))
> >> >>>>> +ifeq ($(cc-name),clang)
> >> >>>>> +CFLAGS_arm64-stub.o            += -fno-pic
> >> >>>>> +endif
> >> >>>>>
> >> >>>>> lib-$(CONFIG_ARM)           += arm32-stub.o
> >> >>>>> lib-$(CONFIG_ARM64)         += arm64-stub.o
> >> >>>>>
> >> >>>>
> >> >>>> NAK.
> >> >>>>
> >> >>>> This patch was labeled "HACK:" in our experimental tree.  There's no
> >> >>>> rhyme or reason to why this combination of -f[no-]pic flags
> >> >>>> generates code without problematic relocations.  It's inherently
> >> >>>> fragile, and was only intended as a temporary workaround until I (or
> >> >>>> someone more familiar with EFI) got a chance to revisit the problem.
> >> >>>>
> >> >>>> Unless the gcc CFLAGS are also an artifact of "mess with -f[no-]pic
> >> >>>> until the compiler generates what you want", this doesn't belong
> >> >>>> upstream.
> >> >>>
> >> >>> Sorry, I didn't realize it is that bad of a hack. Unfortunately I'm
> >> >>> not very familiar with EFI either.
> >> >>>
> >> >>> I saw Ard did some work in this code related with relocation, maybe he
> >> >>> can provide a pointer towards a better solution.
> >> >>>
> >> >>
> >> >> This is a known issue. The problem is that generic AArch64 small model
> >> >> code is mostly position independent already, due to its use of
> >> >> adrp/add pairs to generate symbol references with a +/- 4 GB range.
> >> >> Building the same code with -fpic will result in GOT entries to be
> >> >> generated, which carry absolute addresses, so this achieves the exact
> >> >> opposite of what we want.
> >> >>
> >> >> The reason for the GOT entries is that GCC (and Clang, apparently)
> >> >> infer from the -fpic flag that you are building objects that will be
> >> >> linked into a shared library, to which ELF symbol preemption rules
> >> >> apply that stipulate that a symbol in the main executable supersedes a
> >> >> symbol under the same name in the shared library, and that the shared
> >> >> library should update all its internal references to the main
> >> >> executable's version of the symbol. The easiest way (but certainly not
> >> >> the only way) to achieve that is to indirect all internal symbol
> >> >> references via GOT entries, which can be made to refer to another
> >> >> symbol by updating a single value.
> >> >>
> >> >> The workaround I used is to use hidden visibility, using a #pragma.
> >> >> (There is a -fvisibility=hidden command line option as well, but this
> >> >> is a weaker form that does not apply to extern declarations, only to
> >> >> definitions). So if you add
> >> >>
> >> >> #pragma GCC visibility push(hidden)
> >> >>
> >> >> at the beginning of arm64-stub.c (and perhaps to one or two other
> >> >> files that contain externally visible symbol declarations these days),
> >> >> you should be able to compile the entire EFI stub with -fpic. Note
> >> >> that making those externally visible symbols 'static' where possible
> >> >> would solve the problem as well, but this triggers another issue in
> >> >> the 32-bit ARM stub.
> >> >>
> >> >> In my opinion, the correct fix would be to make -fpie (as opposed to
> >> >> -fpic) imply hidden visibility, given that PIE executables don't
> >> >> export symbols in the first place, and so the preemption rules do not
> >> >> apply. It is worth a try whether -fpie works as expected in this case
> >> >> on Clang, but the last time I tried it on GCC, it behaved exactly like
> >> >> -fpic.
> >> >
> >> > Thanks a lot for the detailed description and your suggestions!
> >> >
> >> > A clang build with -fpie for the EFI stub succeeds without complaints
> >> > about GOT entries. I will send out an updated patch (with -fpie only
> >> > for clang) later.
> >> >
> >>
> >> Good! I never liked the visibility hack, which is why I never upstreamed it.
> >>
> >> Could you please check how recent GCC behaves?
> >
> > I tried GCC v4.9.4 and v6.3.1, both build the EFI stub with -fpie
> > without errors.
> >
> > Are you suggesting to use -fpie for both clang and GCC? Do you know
> > what the minimum required GCC version is for building an arm64 kernel?
> 
> Yes. Up until now, we have been relying on the position independent
> nature of small model code, but it would be better to specify it
> explicitly, so if -fpie gives us mostly identical code and does not
> need visibility hacks, I would prefer to add it for all compilers and
> not have an exception only for Clang. Note that the same applies to
> the entire kernel when built in KASLR mode, so it would also be good
> to know our options here.

Thanks, makes perfect sense.

> Arnd, Will, what is the oldest GCC version we claim to support for arm64?

Any comments on this Arnd/Will?
