From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH v2 0/3] Apple device properties
Date: Mon, 17 Oct 2016 12:57:23 +0200
Message-ID: <cover.1476698603.git.lukas@wunner.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Andreas Noever <andreas.noever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Resending this series as requested by Matt, now that 4.9-rc1 is out
which contains all prerequisites:

On Tue, Sep 13, 2016 at 12:29:21PM +0100, Matt Fleming wrote:
> I had a quick look over these series and nothing looks too crazy, but
> I still need to do an in-depth review.
> 
> Given the patch dependencies you outlined above, could you resubmit
> this after the v4.9 merge window closes? That way it won't be
> forgotten about.


Retrieve device properties from EFI on Macs before ExitBootServices is
called and assign them to devices (patch [2/3]). The devices that
properties pertain to are encoded as EFI Device Paths, so add a parser
for these (patch [1/3]). As a first use case, amend the Thunderbolt driver
to take advantage of the Device ROM supplied by EFI (patch [3/3]).


Changes since v1:

- Previously there were two separate patches for retrieving properties
  and assigning them to devices. These are now squashed together in
  patch [2/3]. (Requested by Matt Fleming.)

- The version of the EFI properties protocol as well as the properties
  payload is now checked.

- Applied a bit of polish all over.


Link to v1:
https://lkml.org/lkml/2016/7/27/218

Browseable on GitHub:
https://github.com/l1k/linux/commits/apple_properties_v2

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
 drivers/firmware/efi/apple-properties.c | 232 ++++++++++++++++++++++++++++++++
 drivers/firmware/efi/dev-path-parser.c  | 186 +++++++++++++++++++++++++
 drivers/thunderbolt/Kconfig             |   1 +
 drivers/thunderbolt/eeprom.c            |  42 ++++++
 drivers/thunderbolt/switch.c            |   2 +-
 include/linux/efi.h                     |  38 ++++++
 11 files changed, 589 insertions(+), 1 deletion(-)
 create mode 100644 drivers/firmware/efi/apple-properties.c
 create mode 100644 drivers/firmware/efi/dev-path-parser.c

-- 
2.9.3
