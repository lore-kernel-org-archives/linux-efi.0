From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [GIT PULL 0/9] EFI changes for v4.10
Date: Sat, 12 Nov 2016 21:32:28 +0000
Message-ID: <20161112213237.8804-1-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Noever <andreas.noever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, grub-devel-mXXj517/zsQ@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>, =?UTF-8?q?Pedro=20Vila=C3=A7a?= <reverser-P1ImLx+pFc0@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pierre Moreau <pierre.morrow-GANU6spQydw@public.gmane.org>, Roy Franz <roy.franz-ZPxbGqLxI0U@public.gmane.org>, Russell King <rmk+kernel-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Folks, please pull the following v4.10 material. There isn't a huge
amount of stuff here. The biggest change is the EFI dev path parser
code from Lukas to get thunderbolt working on his macbook.

 [ The thunderbolt patch has been ACK'd by Andreas and given the OK to
   take it through the EFI tree ]

The following changes since commit a75dcb5848359f488c32c0aef8711d9bd37a77b8:

  efi/efivar_ssdt_load: Don't return success on allocation failure (2016-10-18 17:11:20 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-next

for you to fetch changes up to 9110bc036062fcd31994a35540d63f8deed22efa:

  thunderbolt: Use Device ROM retrieved from EFI (2016-11-12 21:14:43 +0000)

----------------------------------------------------------------
 * Fix an allocation bug in the generic EFI libstub where alignment
   and adjusted size isn't taken into account - Roy Franz

 * Update the EFI MAINTAINERS entry to include ARM and arm64 files and
   directories - Ard Biesheuvel

 * Add new feature to seed the RNG from the stashed value returned by
   EFI_RNG_PROTOCOL in EFI stub and wire up for ARM/arm64 - Ard Biesheuvel

 * Retrieve Apple device properties from within the EFI stub to fully
   support thunderbolt devices on Apple Macbooks - Lukas Wunner

----------------------------------------------------------------
Ard Biesheuvel (4):
      MAINTAINERS: Add ARM and arm64 EFI specific files to EFI subsystem
      efi: Add support for seeding the RNG from a UEFI config table
      efi/libstub: Add random.c to ARM build
      efi/arm*: libstub: Invoke EFI_RNG_PROTOCOL to seed the UEFI RNG table

Lukas Wunner (4):
      efi: Add device path parser
      efi: Allow bitness-agnostic protocol calls
      x86/efi: Retrieve and assign Apple device properties
      thunderbolt: Use Device ROM retrieved from EFI

Roy Franz (1):
      efi/libstub: Fix allocation size calculations

 Documentation/kernel-parameters.txt            |   5 +
 MAINTAINERS                                    |   6 +-
 arch/arm/include/asm/efi.h                     |   3 +
 arch/arm64/include/asm/efi.h                   |   3 +
 arch/x86/boot/compressed/eboot.c               |  65 +++++++
 arch/x86/include/asm/efi.h                     |  16 +-
 arch/x86/include/uapi/asm/bootparam.h          |   1 +
 drivers/firmware/efi/Kconfig                   |  18 ++
 drivers/firmware/efi/Makefile                  |   2 +
 drivers/firmware/efi/apple-properties.c        | 248 +++++++++++++++++++++++++
 drivers/firmware/efi/dev-path-parser.c         | 203 ++++++++++++++++++++
 drivers/firmware/efi/efi.c                     |  72 +++++++
 drivers/firmware/efi/libstub/Makefile          |   4 +-
 drivers/firmware/efi/libstub/arm-stub.c        |   2 +
 drivers/firmware/efi/libstub/efi-stub-helper.c |  33 ++--
 drivers/firmware/efi/libstub/efistub.h         |  11 ++
 drivers/firmware/efi/libstub/random.c          |  56 +++++-
 drivers/thunderbolt/Kconfig                    |   1 +
 drivers/thunderbolt/eeprom.c                   |  43 +++++
 drivers/thunderbolt/switch.c                   |   2 +-
 include/linux/efi.h                            |  46 +++++
 21 files changed, 808 insertions(+), 32 deletions(-)
 create mode 100644 drivers/firmware/efi/apple-properties.c
 create mode 100644 drivers/firmware/efi/dev-path-parser.c
