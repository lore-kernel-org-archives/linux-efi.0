From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH v3 0/3] Apple device properties
Date: Thu, 3 Nov 2016 11:18:48 +0100
Message-ID: <cover.1478145888.git.lukas@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Andreas Noever <andreas.noever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Retrieve device properties from EFI on Macs before ExitBootServices is
called and assign them to devices (patch [2/3]). The devices that
properties pertain to are encoded as EFI Device Paths, so add a parser
for these (patch [1/3]). As a first use case, amend the Thunderbolt driver
to take advantage of the Device ROM supplied by EFI (patch [3/3]).

Changes since v2:

- Renamed get_device_by_efi_path() to efi_get_device_by_path() in
  patch [1/3]. (Matt Fleming)

- Support multiple instance device paths in patch [1/3]. (Peter Jones)

- Validate the size specified in the properties payload in patch [2/3].

- Other than that, just some minor polishing and rebasing.

Link to v2:
http://www.spinics.net/lists/linux-efi/msg09498.html

Browseable on GitHub:
https://github.com/l1k/linux/commits/apple_properties_v3

Thanks,

Lukas


Lukas Wunner (3):
  efi: Add device path parser
  x86/efi: Retrieve and assign Apple device properties
  thunderbolt: Use Device ROM retrieved from EFI

 Documentation/kernel-parameters.txt     |   5 +
 arch/x86/boot/compressed/eboot.c        |  63 +++++++++
 arch/x86/include/uapi/asm/bootparam.h   |   1 +
 drivers/firmware/efi/Kconfig            |  18 +++
 drivers/firmware/efi/Makefile           |   2 +
 drivers/firmware/efi/apple-properties.c | 239 ++++++++++++++++++++++++++++++++
 drivers/firmware/efi/dev-path-parser.c  | 203 +++++++++++++++++++++++++++
 drivers/thunderbolt/Kconfig             |   1 +
 drivers/thunderbolt/eeprom.c            |  42 ++++++
 drivers/thunderbolt/switch.c            |   2 +-
 include/linux/efi.h                     |  37 +++++
 11 files changed, 612 insertions(+), 1 deletion(-)
 create mode 100644 drivers/firmware/efi/apple-properties.c
 create mode 100644 drivers/firmware/efi/dev-path-parser.c

-- 
2.10.1
