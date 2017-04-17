From: "Roy Franz (HPE)" <roy.lists-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] efi: Config options to assign versions in the PE-COFF header
Date: Mon, 17 Apr 2017 11:09:38 -0700
Message-ID: <CAK-u0Q=cxHpFw9_LsPgabPGFAs1A9FD3=Kk_y9Djyo4v78OdEw@mail.gmail.com>
References: <20170413035827.9820-1-glin@suse.com> <CAKv+Gu8ZS1rdDwLrspv_VnYHOfxkdxUpZe_h1Sw3-N2SBpeJ5g@mail.gmail.com>
 <20170413074728.5zglfjw2rxgc6lpj@GaryWorkstation>
Reply-To: roy.franz-ZPxbGqLxI0U@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170413074728.5zglfjw2rxgc6lpj@GaryWorkstation>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gary Lin <glin-IBi9RG/b67k@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joey Lee <jlee-IBi9RG/b67k@public.gmane.org>, Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Apr 13, 2017 at 12:47 AM, Gary Lin <glin-IBi9RG/b67k@public.gmane.org> wrote:
> On Thu, Apr 13, 2017 at 08:26:04AM +0100, Ard Biesheuvel wrote:
>> On 13 April 2017 at 04:58, Gary Lin <glin-IBi9RG/b67k@public.gmane.org> wrote:
>> > This commit adds the new config options to allow the user to modify the
>> > following fields in the PE-COFF header.
>> >
>> > UINT16 MajorOperatingSystemVersion
>> > UINT16 MinorOperatingSystemVersion
>> > UINT16 MajorImageVersion
>> > UINT16 MinorImageVersion
>> >
>> > Those fields are mainly for the executables or libraries in Windows NT
>> > or higher to specify the minimum supported Windows version and the
>> > version of the image itself.
>> >
>> > Given the fact that those fields are ignored in UEFI, we can safely reuse
>> > those fields for other purposes, e.g. Security Version(*).
>> >
>> > (*) https://github.com/lcp/shim/wiki/Security-Version
>> >
>> > v2 changes:
>> > - Modify the header direct instead of using an external script as
>> >   suggested by Ard Biesheuvel
>> > - Include arm and arm64
>> >
>>
>> Thanks for the update. Could we put the Kconfig changes in
>> drivers/firmware/efi/Kconfig, rather than duplicating them 3 times?
>
> Sure. Will send a v3 to update Kconfig.
>
> Thanks,
>
> Gary Lin

I think it would be nice to have a comment in the code (or maybe help
in the kconfig, or Documentation/efi-stub.txt) that indicates the
expected use of these variables, as the field names and PE/COFF spec
won't help here.

Thanks,
Roy

>
>>
>> > Cc: Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>
>> > Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
>> > Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> > Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
>> > Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
>> > Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
>> > Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> > Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
>> > Cc: Joey Lee <jlee-IBi9RG/b67k@public.gmane.org>
>> > Cc: Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>
>> > Signed-off-by: Gary Lin <glin-IBi9RG/b67k@public.gmane.org>
>> > ---
>> >  arch/arm/Kconfig                      | 24 ++++++++++++++++++++++++
>> >  arch/arm/boot/compressed/efi-header.S |  8 ++++----
>> >  arch/arm64/Kconfig                    | 24 ++++++++++++++++++++++++
>> >  arch/arm64/kernel/head.S              |  8 ++++----
>> >  arch/x86/Kconfig                      | 24 ++++++++++++++++++++++++
>> >  arch/x86/boot/header.S                |  8 ++++----
>> >  6 files changed, 84 insertions(+), 12 deletions(-)
>> >
>> > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
>> > index 0d4e71b42c77..4965ad2ccc23 100644
>> > --- a/arch/arm/Kconfig
>> > +++ b/arch/arm/Kconfig
>> > @@ -2090,6 +2090,30 @@ config EFI
>> >           is only useful for kernels that may run on systems that have
>> >           UEFI firmware.
>> >
>> > +config EFI_MAJOR_OS
>> > +       hex "EFI Major OS Version"
>> > +       range 0x0 0xFFFF
>> > +       default "0x0"
>> > +       depends on EFI_STUB
>> > +
>> > +config EFI_MINOR_OS
>> > +       hex "EFI Minor OS Version"
>> > +       range 0x0 0xFFFF
>> > +       default "0x0"
>> > +       depends on EFI_STUB
>> > +
>> > +config EFI_MAJOR_IMAGE
>> > +       hex "EFI Major Image Version"
>> > +       range 0x0 0xFFFF
>> > +       default "0x0"
>> > +       depends on EFI_STUB
>> > +
>> > +config EFI_MINOR_IMAGE
>> > +       hex "EFI Minor Image Version"
>> > +       range 0x0 0xFFFF
>> > +       default "0x0"
>> > +       depends on EFI_STUB
>> > +
>> >  endmenu
>> >
>> >  menu "CPU Power Management"
>> > diff --git a/arch/arm/boot/compressed/efi-header.S b/arch/arm/boot/compressed/efi-header.S
>> > index 9d5dc4fda3c1..67715472a76f 100644
>> > --- a/arch/arm/boot/compressed/efi-header.S
>> > +++ b/arch/arm/boot/compressed/efi-header.S
>> > @@ -69,10 +69,10 @@ extra_header_fields:
>> >                 .long   0                       @ ImageBase
>> >                 .long   0x200                   @ SectionAlignment
>> >                 .long   0x200                   @ FileAlignment
>> > -               .short  0                       @ MajorOperatingSystemVersion
>> > -               .short  0                       @ MinorOperatingSystemVersion
>> > -               .short  0                       @ MajorImageVersion
>> > -               .short  0                       @ MinorImageVersion
>> > +               .short  CONFIG_EFI_MAJOR_OS     @ MajorOperatingSystemVersion
>> > +               .short  CONFIG_EFI_MINOR_OS     @ MinorOperatingSystemVersion
>> > +               .short  CONFIG_EFI_MAJOR_IMAGE  @ MajorImageVersion
>> > +               .short  CONFIG_EFI_MINOR_IMAGE  @ MinorImageVersion
>> >                 .short  0                       @ MajorSubsystemVersion
>> >                 .short  0                       @ MinorSubsystemVersion
>> >                 .long   0                       @ Win32VersionValue
>> > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> > index 3741859765cf..c782c422e58c 100644
>> > --- a/arch/arm64/Kconfig
>> > +++ b/arch/arm64/Kconfig
>> > @@ -1033,6 +1033,30 @@ config EFI
>> >           allow the kernel to be booted as an EFI application. This
>> >           is only useful on systems that have UEFI firmware.
>> >
>> > +config EFI_MAJOR_OS
>> > +       hex "EFI Major OS Version"
>> > +       range 0x0 0xFFFF
>> > +       default "0x0"
>> > +       depends on EFI_STUB
>> > +
>> > +config EFI_MINOR_OS
>> > +       hex "EFI Minor OS Version"
>> > +       range 0x0 0xFFFF
>> > +       default "0x0"
>> > +       depends on EFI_STUB
>> > +
>> > +config EFI_MAJOR_IMAGE
>> > +       hex "EFI Major Image Version"
>> > +       range 0x0 0xFFFF
>> > +       default "0x0"
>> > +       depends on EFI_STUB
>> > +
>> > +config EFI_MINOR_IMAGE
>> > +       hex "EFI Minor Image Version"
>> > +       range 0x0 0xFFFF
>> > +       default "0x0"
>> > +       depends on EFI_STUB
>> > +
>> >  config DMI
>> >         bool "Enable support for SMBIOS (DMI) tables"
>> >         depends on EFI
>> > diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
>> > index 4fb6ccd886d1..9faa4b04d0ef 100644
>> > --- a/arch/arm64/kernel/head.S
>> > +++ b/arch/arm64/kernel/head.S
>> > @@ -129,10 +129,10 @@ extra_header_fields:
>> >         .quad   0                               // ImageBase
>> >         .long   0x1000                          // SectionAlignment
>> >         .long   PECOFF_FILE_ALIGNMENT           // FileAlignment
>> > -       .short  0                               // MajorOperatingSystemVersion
>> > -       .short  0                               // MinorOperatingSystemVersion
>> > -       .short  0                               // MajorImageVersion
>> > -       .short  0                               // MinorImageVersion
>> > +       .short  CONFIG_EFI_MAJOR_OS             // MajorOperatingSystemVersion
>> > +       .short  CONFIG_EFI_MINOR_OS             // MinorOperatingSystemVersion
>> > +       .short  CONFIG_EFI_MAJOR_IMAGE          // MajorImageVersion
>> > +       .short  CONFIG_EFI_MINOR_IMAGE          // MinorImageVersion
>> >         .short  0                               // MajorSubsystemVersion
>> >         .short  0                               // MinorSubsystemVersion
>> >         .long   0                               // Win32VersionValue
>> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> > index 5bbdef151805..233933fde7dd 100644
>> > --- a/arch/x86/Kconfig
>> > +++ b/arch/x86/Kconfig
>> > @@ -1803,6 +1803,30 @@ config EFI_STUB
>> >
>> >           See Documentation/efi-stub.txt for more information.
>> >
>> > +config EFI_MAJOR_OS
>> > +       hex "EFI Major OS Version"
>> > +       range 0x0 0xFFFF
>> > +       default "0x0"
>> > +       depends on EFI_STUB
>> > +
>> > +config EFI_MINOR_OS
>> > +       hex "EFI Minor OS Version"
>> > +       range 0x0 0xFFFF
>> > +       default "0x0"
>> > +       depends on EFI_STUB
>> > +
>> > +config EFI_MAJOR_IMAGE
>> > +       hex "EFI Major Image Version"
>> > +       range 0x0 0xFFFF
>> > +       default "0x0"
>> > +       depends on EFI_STUB
>> > +
>> > +config EFI_MINOR_IMAGE
>> > +       hex "EFI Minor Image Version"
>> > +       range 0x0 0xFFFF
>> > +       default "0x0"
>> > +       depends on EFI_STUB
>> > +
>> >  config EFI_MIXED
>> >         bool "EFI mixed-mode support"
>> >         depends on EFI_STUB && X86_64
>> > diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
>> > index 3dd5be33aaa7..863813007207 100644
>> > --- a/arch/x86/boot/header.S
>> > +++ b/arch/x86/boot/header.S
>> > @@ -156,10 +156,10 @@ extra_header_fields:
>> >  #endif
>> >         .long   0x20                            # SectionAlignment
>> >         .long   0x20                            # FileAlignment
>> > -       .word   0                               # MajorOperatingSystemVersion
>> > -       .word   0                               # MinorOperatingSystemVersion
>> > -       .word   0                               # MajorImageVersion
>> > -       .word   0                               # MinorImageVersion
>> > +       .word   CONFIG_EFI_MAJOR_OS             # MajorOperatingSystemVersion
>> > +       .word   CONFIG_EFI_MINOR_OS             # MinorOperatingSystemVersion
>> > +       .word   CONFIG_EFI_MAJOR_IMAGE          # MajorImageVersion
>> > +       .word   CONFIG_EFI_MINOR_IMAGE          # MinorImageVersion
>> >         .word   0                               # MajorSubsystemVersion
>> >         .word   0                               # MinorSubsystemVersion
>> >         .long   0                               # Win32VersionValue
>> > --
>> > 2.12.0
>> >
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
