From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH v4 0/4] Apple device properties
Date: Mon, 7 Nov 2016 11:09:00 +0100
Message-ID: <cover.1478506920.git.lukas@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Andreas Noever <andreas.noever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Retrieve device properties from EFI on Macs before ExitBootServices is
called and assign them to devices (patch [3/4]). The devices that
properties pertain to are encoded as EFI Device Paths, so add a parser
for these (patch [1/4]). As a first use case, amend the Thunderbolt driver
to take advantage of the Device ROM supplied by EFI (patch [4/4]).

Changes since v3:

- New patch [2/4] which introduces efi_call_proto() and efi_table_attr()
  macros to allow bitness-agnostic EFI protocol calls and table lookups.
  Previously when retrieving the properties in patch [3/4], a ternary
  operator was used to make the code work in mixed-mode, but Matt
  correctly remarked that it impacted readability.  The new approach
  seeks to maintain readability while avoiding code duplication.

- Address all other comments by Matt on patch [3/4]:  In eboot.c, move
  comparison of fw_vendor and call to retrieve_apple_device_properties()
  out of efi_main() and into a separate setup_quirks() function which
  may accommodate future vendor- or device-specific quirks.  Fix up
  comments and curly braces, add newlines and suffix typedefs with "_t"
  as requested by Matt.

- Fix bug in comparison of fw_vendor in patch [3/4] wherein the system
  table was assumed to be the 64-bit version when compiling on x86_64,
  which obviously didn't work in mixed-mode.

- Fix double free in error path in patch [4/4] spotted by Andreas.

Link to v3:
http://www.spinics.net/lists/linux-efi/msg09647.html

Browseable on GitHub:
https://github.com/l1k/linux/commits/apple_properties_v4

Thanks,

Lukas


Lukas Wunner (4):
  efi: Add device path parser
  efi: Allow bitness-agnostic protocol calls
  x86/efi: Retrieve and assign Apple device properties
  thunderbolt: Use Device ROM retrieved from EFI

 Documentation/kernel-parameters.txt     |   5 +
 arch/arm/include/asm/efi.h              |   3 +
 arch/arm64/include/asm/efi.h            |   3 +
 arch/x86/boot/compressed/eboot.c        |  65 +++++++++
 arch/x86/include/asm/efi.h              |  16 ++-
 arch/x86/include/uapi/asm/bootparam.h   |   1 +
 drivers/firmware/efi/Kconfig            |  18 +++
 drivers/firmware/efi/Makefile           |   2 +
 drivers/firmware/efi/apple-properties.c | 248 ++++++++++++++++++++++++++++++++
 drivers/firmware/efi/dev-path-parser.c  | 203 ++++++++++++++++++++++++++
 drivers/thunderbolt/Kconfig             |   1 +
 drivers/thunderbolt/eeprom.c            |  43 ++++++
 drivers/thunderbolt/switch.c            |   2 +-
 include/linux/efi.h                     |  37 +++++
 14 files changed, 641 insertions(+), 6 deletions(-)
 create mode 100644 drivers/firmware/efi/apple-properties.c
 create mode 100644 drivers/firmware/efi/dev-path-parser.c

-- 
2.10.1
