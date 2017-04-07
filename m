From: Justin Forbes <jmforbes@linuxtx.org>
Subject: Re: [PATCH 00/24] Kernel lockdown
Date: Fri, 7 Apr 2017 11:32:51 -0500
Message-ID: <CAFxkdAqm+5PF1phOf3G6RiNQvJH_CEOO2AG7hSFJ7s24r0UTfg@mail.gmail.com>
References: <149141201983.30815.1240162780237131881.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <149141201983.30815.1240162780237131881.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, linux-efi@vger.kernel.org, matthew.garrett@nebula.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Wed, Apr 5, 2017 at 12:07 PM, David Howells <dhowells@redhat.com> wrote:
>
> These patches provide a facility by which a variety of avenues by which
> userspace can feasibly modify the running kernel image can be locked down.
> These include:
>
>  (*) No unsigned modules and no modules for which can't validate the
>      signature.
>
>  (*) No use of ioperm(), iopl() and no writing to /dev/port.
>
>  (*) No writing to /dev/mem or /dev/kmem.
>
>  (*) No hibernation.
>
>  (*) Restrict PCI BAR access.
>
>  (*) Restrict MSR access.
>
>  (*) No kexec_load().
>
>  (*) Certain ACPI restrictions.
>
>  (*) Restrict debugfs interface to ASUS WMI.
>
> The lock-down can be configured to be triggered by the EFI secure boot
> status, provided the shim isn't insecure.  The lock-down can be lifted by
> typing SysRq+x on a keyboard attached to the system.
>
>
> The patches can be found here also:
>
>         http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=efi-lockdown
>
> They are dependent on the hwparam branch, which I posted separately.
>
> David
> ---
> Dave Young (1):
>       Copy secure_boot flag in boot params across kexec reboot
>
> David Howells (7):
>       Add the ability to lock down access to the running kernel image
>       efi: Lock down the kernel if booted in secure boot mode
>       Enforce module signatures if the kernel is locked down
>       scsi: Lock down the eata driver
>       Prohibit PCMCIA CIS storage when the kernel is locked down
>       Lock down TIOCSSERIAL
>       Lock down module params that specify hardware parameters (eg. ioport)
>
> Josh Boyer (3):
>       efi: Add EFI_SECURE_BOOT bit
>       hibernate: Disable when the kernel is locked down
>       acpi: Ignore acpi_rsdp kernel param when the kernel has been locked down
>
> Kyle McMartin (1):
>       Add a sysrq option to exit secure boot mode
>
> Lee, Chun-Yi (2):
>       kexec_file: Disable at runtime if securelevel has been set
>       bpf: Restrict kernel image access functions when the kernel is locked down
>
> Linn Crosetto (2):
>       acpi: Disable ACPI table override if the kernel is locked down
>       acpi: Disable APEI error injection if the kernel is locked down
>
> Matthew Garrett (8):
>       Restrict /dev/mem and /dev/kmem when the kernel is locked down
>       kexec: Disable at runtime if the kernel is locked down
>       uswsusp: Disable when the kernel is locked down
>       PCI: Lock down BAR access when the kernel is locked down
>       x86: Lock down IO port access when the kernel is locked down
>       x86: Restrict MSR access when the kernel is locked down
>       asus-wmi: Restrict debugfs interface when the kernel is locked down
>       ACPI: Limit access to custom_method when the kernel is locked down
>
>
>  arch/x86/Kconfig                  |   22 ++++++++++++++++++++
>  arch/x86/kernel/ioport.c          |    4 ++--
>  arch/x86/kernel/kexec-bzimage64.c |    1 +
>  arch/x86/kernel/msr.c             |    7 ++++++
>  arch/x86/kernel/setup.c           |   40 ++++++++++++++++++++++++++++++++++++-
>  drivers/acpi/apei/einj.c          |    3 +++
>  drivers/acpi/custom_method.c      |    3 +++
>  drivers/acpi/osl.c                |    2 +-
>  drivers/acpi/tables.c             |    5 +++++
>  drivers/char/mem.c                |    8 +++++++
>  drivers/input/misc/uinput.c       |    1 +
>  drivers/pci/pci-sysfs.c           |    9 ++++++++
>  drivers/pci/proc.c                |    8 ++++++-
>  drivers/pci/syscall.c             |    2 +-
>  drivers/pcmcia/cistpl.c           |    5 +++++
>  drivers/platform/x86/asus-wmi.c   |    9 ++++++++
>  drivers/scsi/eata.c               |    7 ++++++
>  drivers/tty/serial/serial_core.c  |    6 ++++++
>  drivers/tty/sysrq.c               |   19 ++++++++++++------
>  include/linux/efi.h               |    1 +
>  include/linux/input.h             |    5 +++++
>  include/linux/kernel.h            |    9 ++++++++
>  include/linux/security.h          |   11 ++++++++++
>  include/linux/sysrq.h             |    8 ++++++-
>  kernel/debug/kdb/kdb_main.c       |    2 +-
>  kernel/kexec.c                    |    7 ++++++
>  kernel/kexec_file.c               |    6 ++++++
>  kernel/module.c                   |    2 +-
>  kernel/params.c                   |   27 ++++++++++++++++++++-----
>  kernel/power/hibernate.c          |    2 +-
>  kernel/power/user.c               |    3 +++
>  kernel/trace/bpf_trace.c          |   11 ++++++++++
>  security/Kconfig                  |   15 ++++++++++++++
>  security/Makefile                 |    3 +++
>  security/lock_down.c              |   40 +++++++++++++++++++++++++++++++++++++
>  35 files changed, 291 insertions(+), 22 deletions(-)
>  create mode 100644 security/lock_down.c
>

Tested-by: Justin Forbes <jforbes@fedoraproject.org>
