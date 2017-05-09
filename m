From: Matthias Kaehlcke <mka@chromium.org>
Subject: Re: [PATCH] efi/libstub: Indicate clang the relocation mode for arm64
Date: Tue, 9 May 2017 14:49:05 -0700
Message-ID: <20170509214905.GH128305@google.com>
References: <20170509193612.64105-1-mka@chromium.org>
 <25d94b46-765e-f12f-a287-853c76782143@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <25d94b46-765e-f12f-a287-853c76782143@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Hackmann <ghackmann@google.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Grant Grundler <grundler@chromium.org>, Michael Davidson <md@google.com>, Bernhard =?utf-8?Q?Rosenkr=C3=A4nzer?= <Bernhard.Rosenkranzer@linaro.org>
List-Id: linux-efi@vger.kernel.org

El Tue, May 09, 2017 at 01:50:36PM -0700 Greg Hackmann ha dit:

> On 05/09/2017 12:36 PM, Matthias Kaehlcke wrote:
> >From: Greg Hackmann <ghackmann@google.com>
> >
> >Without any extra guidance, clang will generate libstub with either
> >absolute or relative ELF relocations. Use the right combination of
> >-fpic and -fno-pic on different files to avoid this.
> >
> >Signed-off-by: Greg Hackmann <ghackmann@google.com>
> >Signed-off-by: Bernhard Rosenkränzer <Bernhard.Rosenkranzer@linaro.org>
> >Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> >---
> > drivers/firmware/efi/libstub/Makefile | 6 ++++++
> > 1 file changed, 6 insertions(+)
> >
> >diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
> >index f7425960f6a5..ccbaaf4d8650 100644
> >--- a/drivers/firmware/efi/libstub/Makefile
> >+++ b/drivers/firmware/efi/libstub/Makefile
> >@@ -11,6 +11,9 @@ cflags-$(CONFIG_X86)		+= -m$(BITS) -D__KERNEL__ -O2 \
> > 				   -mno-mmx -mno-sse
> >
> > cflags-$(CONFIG_ARM64)		:= $(subst -pg,,$(KBUILD_CFLAGS))
> >+ifeq ($(cc-name),clang)
> >+cflags-$(CONFIG_ARM64)		+= -fpic
> >+endif
> > cflags-$(CONFIG_ARM)		:= $(subst -pg,,$(KBUILD_CFLAGS)) \
> > 				   -fno-builtin -fpic -mno-single-pic-base
> >
> >@@ -38,6 +41,9 @@ $(obj)/lib-%.o: $(srctree)/lib/%.c FORCE
> >
> > lib-$(CONFIG_EFI_ARMSTUB)	+= arm-stub.o fdt.o string.o random.o \
> > 				   $(patsubst %.c,lib-%.o,$(arm-deps))
> >+ifeq ($(cc-name),clang)
> >+CFLAGS_arm64-stub.o            += -fno-pic
> >+endif
> >
> > lib-$(CONFIG_ARM)		+= arm32-stub.o
> > lib-$(CONFIG_ARM64)		+= arm64-stub.o
> >
> 
> NAK.
> 
> This patch was labeled "HACK:" in our experimental tree.  There's no
> rhyme or reason to why this combination of -f[no-]pic flags
> generates code without problematic relocations.  It's inherently
> fragile, and was only intended as a temporary workaround until I (or
> someone more familiar with EFI) got a chance to revisit the problem.
> 
> Unless the gcc CFLAGS are also an artifact of "mess with -f[no-]pic
> until the compiler generates what you want", this doesn't belong
> upstream.

Sorry, I didn't realize it is that bad of a hack. Unfortunately I'm
not very familiar with EFI either.

I saw Ard did some work in this code related with relocation, maybe he
can provide a pointer towards a better solution.

Thanks

Matthias
