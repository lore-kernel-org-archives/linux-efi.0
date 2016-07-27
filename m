From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH 0/6] Apple device properties
Date: Wed, 27 Jul 2016 13:20:41 +0200
Message-ID: <cover.1469616641.git.lukas@wunner.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Noever <andreas.noever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pierre Moreau <pierre.morrow-GANU6spQydw@public.gmane.org>, reverser-P1ImLx+pFc0@public.gmane.org, grub-devel-mXXj517/zsQ@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Aleksey Makarov <aleksey.makarov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Rafael J. Wysocki" <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mika Westerberg <mika.westerberg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Apple EFI drivers supply device properties which are needed to support
Macs optimally.

This series extends the efistub to retrieve the device properties before
ExitBootServices is called (patch [1/6]). They are assigned to devices
in an fs_initcall (patch [5/6]). As a first use case, the Thunderbolt
driver is amended to take advantage of the Device ROM supplied by EFI
(patch [6/6]).

A by-product is a parser for EFI Device Paths which finds the struct
device corresponding to a given path. This is needed to assign
properties to their devices (patch [3/6]).


I've pushed these patches to GitHub where they can be reviewed more
comfortably with green/red highlighting:
https://github.com/l1k/linux/commits/apple_properties_v1


It would be good if one of the resident EFI experts could look over
patch [1/6] to see if I've made any mistakes that might prevent this
from working on 32 bit. It was only tested on 64 bit, I don't know
anyone with an older Mac who could test this.

Specifically, is the following okay:
efi_early->call((unsigned long)sys_table->boottime->locate_protocol, ...)

It would be convenient to have LocateProtocol or LocateHandleBuffer in
struct efi_config so that they can be called with efi_call_early().
Would a patch to add those be entertained? Right now we only offer
LocateHandle and HandleProtocol, which is somewhat cumbersome and
needs more code as the setup_pci() functions show.

Thanks,

Lukas


Lukas Wunner (6):
  efi: Retrieve Apple device properties
  ACPI / bus: Make acpi_get_first_physical_node() public
  efi: Add device path parser
  driver core: Don't leak secondary fwnode on device removal
  efi: Assign Apple device properties
  thunderbolt: Use Device ROM retrieved from EFI

 Documentation/kernel-parameters.txt     |   5 +
 arch/x86/boot/compressed/eboot.c        |  55 ++++++++
 arch/x86/include/uapi/asm/bootparam.h   |   1 +
 drivers/acpi/internal.h                 |   1 -
 drivers/base/core.c                     |   1 +
 drivers/firmware/efi/Kconfig            |  16 +++
 drivers/firmware/efi/Makefile           |   2 +
 drivers/firmware/efi/apple-properties.c | 219 ++++++++++++++++++++++++++++++++
 drivers/firmware/efi/dev-path-parser.c  | 186 +++++++++++++++++++++++++++
 drivers/thunderbolt/Kconfig             |   1 +
 drivers/thunderbolt/eeprom.c            |  42 ++++++
 drivers/thunderbolt/switch.c            |   2 +-
 include/linux/acpi.h                    |   7 +
 include/linux/efi.h                     |  38 ++++++
 14 files changed, 574 insertions(+), 2 deletions(-)
 create mode 100644 drivers/firmware/efi/apple-properties.c
 create mode 100644 drivers/firmware/efi/dev-path-parser.c

-- 
2.8.1
