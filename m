From: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>
Subject: Re: [PATCH 0/2] RFC: Move efi bgrt code out of arch/x86
Date: Thu, 16 Feb 2017 00:44:47 +0100
Message-ID: <4695986.Exl6llDaHp@aspire.rjw.lan>
References: <1487163892-27701-1-git-send-email-bhsharma@redhat.com> <CAKv+Gu-qv83fi9qBugA=Od2htcLb966SPBpZXSnXdH=AYw-COw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu-qv83fi9qBugA=Od2htcLb966SPBpZXSnXdH=AYw-COw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Prakhya, Sai Praneeth" <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bhupesh SHARMA <bhupesh.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Mark Rutland <mark.rutland@arm.>
List-Id: linux-efi@vger.kernel.org

On Wednesday, February 15, 2017 05:44:28 PM Ard Biesheuvel wrote:
> Hello Bhupesh,
> 
> On 15 February 2017 at 13:04, Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > This patchset presents a RFC approach to move the ACPI BGRT table
> > handling related code out of 'arch/x86' and place it inside
> > 'drivers/firmware/efi' so that it can be used to support
> > ACPI BGRT table and BGRT logo across x86 and AARCH64 ARCHs.
> >
> > Note that this patchset is primarily tested on Qemu VMs for x86_64
> > and AARCH64 environments, while I try to get my hands on a real
> > AARCH64 hardware which supports a graphic card and whose boot firmware
> > I can modify to support the ACPI BGRT table to be passed to the kernel.
> >
> > Here are some details/outputs about/from the test environment:
> >
> > AARCH64:
> > ========
> > 1. I used the latest Qemu (master branch) and compiled it for aarch64 with softmmu support.
> >    Here is the command line I use to launch the same:
> >
> > # qemu-system-aarch64 -cpu cortex-a57 -M virt -m 2048 -bios QEMU_EFI.fd -kernel Image -initrd rootfs.cpio -serial stdio --append "acpi=force" -device virtio-gpu-pci
> >
> > where, QEMU_EFI.fd is the DEBUG build of EDK2 ArmVirtQemu.dsc (master branch)
> >        rootfs.cpio is the AARCH64 build of Buildroot (Little Endian AARCH64)
> >        -device virtio-gpu-pci provides the Graphical support required to have BGRT logo.
> >
> >
> > 2. Here are some test results once Linux boots up, which show a valid BGRT table/logo being
> >    seen by the kernel:
> >
> > # acpidump
> > ...
> >
> > BGRT @ 0x0000000000000000
> >   0000: 42 47 52 54 38 00 00 00 01 B4 49 4E 54 45 4C 20  BGRT8.....INTEL
> >   0010: 45 44 4B 32 20 20 20 20 02 00 00 00 20 20 20 20  EDK2    ....
> >   0020: 13 00 00 01 01 00 01 00 00 80 B0 BA 00 00 00 00  ................
> >   0030: 2F 01 00 00 0F 01 00 00                          /.......
> >
> > # dmesg | grep -i BGRT
> > [    0.000000] ACPI: BGRT 0x00000000B8640000 000038 (v01 INTEL  EDK2     00000002      01000013)
> >
> >
> > # ls -lah /sys/firmware/acpi/bgrt/image
> > -r--r--r--    1 root     root       32.9K Feb 15 11:27 /sys/firmware/acpi/bgrt/image
> >
> > x86:
> > ====
> > 1. I used the latest Qemu (master branch) and compiled it for x86.
> >    Here is the command line I use to launch the same:
> >
> > # qemu-system-x86_64 -enable-kvm -sdl -m 2048 -vga std -boot c -cpu host -bios OVMF_CODE.fd -kernel bzImage -initrd rootfs.cpio -serial stdio
> >
> > where, OVMF_CODE.fd is the RELEASE build of EDK2 OvmfPkg (master branch)
> >        rootfs.cpio is the x86_64 build of Buildroot
> >
> > 2. Similar test results are seen as noted for the AARCH64 case above, which show a valid BGRT table/logo being
> >    seen by the kernel.
> >
> > Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> > Cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> > Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> > Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
> >
> > Bhupesh Sharma (2):
> >   x86/efi-bgrt: Move efi-bgrt handling out of arch/x86
> >   bgrt: Make ACPI BGRT parsing code common for ARCHs
> >
> >  arch/arm64/kernel/acpi.c                               | 3 +++
> >  arch/x86/kernel/acpi/boot.c                            | 6 ------
> >  arch/x86/platform/efi/Makefile                         | 1 -
> >  drivers/acpi/Kconfig                                   | 2 +-
> >  drivers/acpi/bgrt.c                                    | 6 ++++++
> >  drivers/firmware/efi/Makefile                          | 1 +
> >  {arch/x86/platform => drivers/firmware}/efi/efi-bgrt.c | 0
> >  include/linux/efi-bgrt.h                               | 2 ++
> >  8 files changed, 13 insertions(+), 8 deletions(-)
> >  rename {arch/x86/platform => drivers/firmware}/efi/efi-bgrt.c (100%)
> >
> 
> These patches look fine to me, and I think we should be able to merge
> them without any changes.
> 
> Reviewed-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> 
> You only failed to cc the ACPI maintainers, please add Len and Rafael next time.

No worries.

The changes are fine by me.

Thanks,
Rafael
