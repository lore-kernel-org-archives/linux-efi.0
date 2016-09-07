From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH v2 0/4] Apple device properties
Date: Wed, 7 Sep 2016 12:49:18 +0200
Message-ID: <cover.1473242067.git.lukas@wunner.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Noever <andreas.noever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, grub-devel-mXXj517/zsQ@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Retrieve device properties from EFI on Macs before ExitBootServices is
called and assign them to devices (patch [3/4]). The devices that
properties pertain to are encoded as EFI Device Paths, so add a parser
for these (patch [2/4]). As a first use case, amend the Thunderbolt driver
to take advantage of the Device ROM supplied by EFI (patch [4/4]).

Patch [1/4] is already queued in Rafael J. Wysocki's tree for 4.9 and is
included here only because patch [2/4] wouldn't compile without it.

The series also depends on these two patches which are already queued
in Matt's tree for 4.9:

- x86/efi: Optimize away setup_gop32/64 if unused
  https://patchwork.kernel.org/patch/9315763/

- x86/efi: Allow invocation of arbitrary boot services
  https://patchwork.kernel.org/patch/9293371/


Changes since v1:

- Previously there were two separate patches for retrieving properties
  and assigning them to devices. These are now squashed together in
  patch [3/4]. (Requested by Matt Fleming.)

- The version of the EFI properties protocol as well as the properties
  payload is now checked.

- Applied a bit of polish all over.


Link to v1:
https://lkml.org/lkml/2016/7/27/218

Browseable on GitHub:
https://github.com/l1k/linux/commits/apple_properties_v2

Thanks,

Lukas


Lukas Wunner (4):
  ACPI / bus: Make acpi_get_first_physical_node() public
  efi: Add device path parser
  x86/efi: Retrieve and assign Apple device properties
  thunderbolt: Use Device ROM retrieved from EFI

 Documentation/kernel-parameters.txt     |   5 +
 arch/x86/boot/compressed/eboot.c        |  63 +++++++++
 arch/x86/include/uapi/asm/bootparam.h   |   1 +
 drivers/acpi/internal.h                 |   1 -
 drivers/firmware/efi/Kconfig            |  18 +++
 drivers/firmware/efi/Makefile           |   2 +
 drivers/firmware/efi/apple-properties.c | 230 ++++++++++++++++++++++++++++++++
 drivers/firmware/efi/dev-path-parser.c  | 186 ++++++++++++++++++++++++++
 drivers/thunderbolt/Kconfig             |   1 +
 drivers/thunderbolt/eeprom.c            |  42 ++++++
 drivers/thunderbolt/switch.c            |   2 +-
 include/linux/acpi.h                    |   7 +
 include/linux/efi.h                     |  38 ++++++
 13 files changed, 594 insertions(+), 2 deletions(-)
 create mode 100644 drivers/firmware/efi/apple-properties.c
 create mode 100644 drivers/firmware/efi/dev-path-parser.c

-- 
2.9.3
