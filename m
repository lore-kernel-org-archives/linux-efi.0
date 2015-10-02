From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 9/9] ARM: add UEFI stub support
Date: Fri, 2 Oct 2015 21:33:02 +0200
Message-ID: <CAKv+Gu8G616q00oRHtLgfPZVJH8syUXswcyRuzHLS51psomECA@mail.gmail.com>
References: <1443719063-6832-1-git-send-email-ard.biesheuvel@linaro.org>
	<1443719063-6832-10-git-send-email-ard.biesheuvel@linaro.org>
	<CAD0U-h+zPhDe6Fqpg_vhF46FLjvvsbeSrQ_Fnj86o5cRc+A2QQ@mail.gmail.com>
	<CAKv+Gu8y-ooMHPCHftb+_aYgb-FpbfeR==R9v+hY-_oetkPisw@mail.gmail.com>
	<CAKv+Gu8Dby7u_aM+=1hxf0fdXVVbH3FYzDfgB=3z3GzO_VYpKw@mail.gmail.com>
	<CAD0U-hK8=65digSpQ8b3zQcx4P3DFayu8eONDsYp9wA4ypPscg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAD0U-hK8=65digSpQ8b3zQcx4P3DFayu8eONDsYp9wA4ypPscg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ryan Harkin <ryan.harkin-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 2 October 2015 at 20:50, Ryan Harkin <ryan.harkin-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>
>
> On 2 October 2015 at 19:07, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> wrote:
>>
>> On 2 October 2015 at 20:03, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> wrote:
>> > On 2 October 2015 at 18:29, Ryan Harkin <ryan.harkin-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> >> Hi Ard/Roy,
>> >>
>> >> On 1 October 2015 at 18:04, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> >> wrote:
>> >>>
>> >>> From: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> >>>
>> >>> This patch adds EFI stub support for the ARM Linux kernel.
>> >>>
>> >>> The EFI stub operates similarly to the x86 and arm64 stubs: it is a
>> >>> shim between the EFI firmware and the normal zImage entry point, and
>> >>> sets up the environment that the zImage is expecting. This includes
>> >>> optionally loading the initrd and device tree from the system
>> >>> partition
>> >>> based on the kernel command line.
>> >>>
>> >>> Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> >>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> >>> ---
>> >>>  arch/arm/Kconfig                       |  19 +++
>> >>>  arch/arm/boot/compressed/Makefile      |   5 +-
>> >>>  arch/arm/boot/compressed/efi-header.S  | 130 ++++++++++++++++++++
>> >>>  arch/arm/boot/compressed/efi-stub.c    |  89 ++++++++++++++
>> >>>  arch/arm/boot/compressed/head.S        |  54 +++++++-
>> >>>  arch/arm/boot/compressed/vmlinux.lds.S |   7 ++
>> >>>  arch/arm/include/asm/efi.h             |  23 ++++
>> >>>  drivers/firmware/efi/libstub/Makefile  |  12 ++
>> >>>  8 files changed, 336 insertions(+), 3 deletions(-)
>> >>>
>> >>> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
>> >>> index e4b7d6cfd8eb..6d7fd83c2ee4 100644
>> >>> --- a/arch/arm/Kconfig
>> >>> +++ b/arch/arm/Kconfig
>> >>> @@ -2061,6 +2061,25 @@ config AUTO_ZRELADDR
>> >>>           0xf8000000. This assumes the zImage being placed in the
>> >>> first
>> >>> 128MB
>> >>>           from start of memory.
>> >>>
>> >>> +config EFI_STUB
>> >>> +       bool
>> >>> +
>> >>> +config EFI
>> >>> +       bool "UEFI runtime support"
>> >>> +       depends on OF && !CPU_BIG_ENDIAN && MMU && AUTO_ZRELADDR &&
>> >>> !XIP_KERNEL
>> >>> +       select UCS2_STRING
>> >>> +       select EFI_PARAMS_FROM_FDT
>> >>> +       select EFI_STUB
>> >>> +       select EFI_ARMSTUB
>> >>> +       select EFI_RUNTIME_WRAPPERS
>> >>
>> >>
>> >> Should we make this "default y" like ARM64?  I think so.
>> >>
>> >>
>> >
>> > It is not necessarily something that should be enabled by default,
>> > imo. The distro kernels will probably enabled it, which is good enough
>> > for me.
>
>
> That's fair enough.  I think it is default for arm64, hence why I asked.
> But I can enable it myself in my own configs easily enough.
>
>> >
>> >>> +       ---help---
>> >>> +         This option provides support for runtime services provided
>> >>> +         by UEFI firmware (such as non-volatile variables, realtime
>> >>> +         clock, and platform reset). A UEFI stub is also provided to
>> >>> +         allow the kernel to be booted as an EFI application. This
>> >>> +         is only useful for kernels that may run on systems that have
>> >>> +         UEFI firmware.
>> >>> +
>> >>>  endmenu
>> >>>
>> >>>  menu "CPU Power Management"
>> >>> diff --git a/arch/arm/boot/compressed/Makefile
>> >>> b/arch/arm/boot/compressed/Makefile
>> >>> index 3f9a9ebc77c3..0e5624d6215d 100644
>> >>> --- a/arch/arm/boot/compressed/Makefile
>> >>> +++ b/arch/arm/boot/compressed/Makefile
>> >>> @@ -167,9 +167,12 @@ if [ $(words $(ZRELADDR)) -gt 1 -a
>> >>> "$(CONFIG_AUTO_ZRELADDR)" = "" ]; then \
>> >>>         false; \
>> >>>  fi
>> >>>
>> >>> +efi-obj-$(CONFIG_EFI_STUB) := $(obj)/efi-stub.o $(obj)/efi-banner.o \
>> >>
>> >>
>> >> When I try to compile the kernel from your branch, I get:
>> >>
>> >> make[2]: *** No rule to make target
>> >> 'arch/arm/boot/compressed/efi-banner.o',
>> >> needed by 'arch/arm/boot/compressed/vmlinux'. Stop.
>> >>
>> >> Did I miss something or is this a problem?
>> >>
>> >
>> > It was I who missed something: I have been reshuffling some bits, and
>> > this fell through the cracks. I didn't spot it since I apparently did
>> > not try to rebuild it cleanly.
>> >
>> > I would like to get rid of the linux_banner reference in the stub
>> > completely, and I posted a patch here
>> >
>>
>> Where? Here:
>> http://marc.info/?l=linux-arm-kernel&m=144313135923256
>>
>> > In the mean time, could you try with this folded in?
>> >
>> > -------------------8<--------------------
>> > diff --git a/arch/arm/boot/compressed/Makefile
>> > b/arch/arm/boot/compressed/Makefile
>> > index 0e5624d6215d..a6aa7f9123a2 100644
>> > --- a/arch/arm/boot/compressed/Makefile
>> > +++ b/arch/arm/boot/compressed/Makefile
>> > @@ -170,6 +170,10 @@ fi
>> >  efi-obj-$(CONFIG_EFI_STUB) := $(obj)/efi-stub.o $(obj)/efi-banner.o \
>> >
>> > $(objtree)/drivers/firmware/efi/libstub/lib.a
>> >
>> > +$(obj)/efi-banner.o: OBJCOPYFLAGS=-j .rodata
>> > +$(obj)/efi-banner.o: $(objtree)/init/version.o FORCE
>> > +       $(call if_changed,objcopy)
>> > +
>> >  $(obj)/vmlinux: $(obj)/vmlinux.lds $(obj)/$(HEAD)
>> > $(obj)/piggy.$(suffix_y).o \
>> >                 $(addprefix $(obj)/, $(OBJS)) $(lib1funcs) $(ashldi3) \
>> >                 $(bswapsdi2) $(efi-obj-y) FORCE
>> > diff --git a/drivers/firmware/efi/libstub/fdt.c
>> > b/drivers/firmware/efi/libstub/fdt.c
>> > index a7e87cd582f2..f45a6f715e73 100644
>> > --- a/drivers/firmware/efi/libstub/fdt.c
>> > +++ b/drivers/firmware/efi/libstub/fdt.c
>> > @@ -16,6 +16,8 @@
>> >
>> >  #include "efistub.h"
>> >
>> > +extern __attribute__((__visibility__("hidden"))) const char
>> > linux_banner[];
>> > +
>> >  efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
>> >                         unsigned long orig_fdt_size,
>> >                         void *fdt, int new_fdt_size, char *cmdline_ptr,
>> > -------------------8<--------------------
>> >
>
> Now I get a slightly different error, but it amounts to the same thing:
>
> arm-linux-gnueabi-ld: cannot find arch/arm/boot/compressed/efi-banner.o: No
> such file or directory
>

Strange. So did it actually build efi-banner.o ?
Could you check if the leading tabs in the Makefile hunks got pasted ok?

-- 
Ard.
