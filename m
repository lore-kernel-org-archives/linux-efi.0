From: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 0/8]
Date: Fri, 17 Jun 2016 14:52:08 +0300
Message-ID: <1466164336-9508-1-git-send-email-octavian.purdila@intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Rafael J . Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>
Cc: Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, irina.tirdea-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, leonard.crestez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This patch set enables custom ACPI board configuration by adding
mechanisms in the Linux kernel for loading user defined SSDTs.

In order to support ACPI open-ended hardware configurations we need a
way to augment the ACPI configuration provided by the firmware
image. A common example is connecting sensors on I2C / SPI buses on
development boards.

Although this can be accomplished by creating a kernel platform driver
or recompiling the firmware image with updated ACPI tables, neither is
practical: the former proliferates board specific kernel code while
the latter requires access to firmware tools which are often not
publicly available.

Because ACPI supports external references in AML code a more practical
way to augment firmware ACPI configuration is by dynamically loading
user defined SSDT tables that contain the board specific information.

Currently it is possible to load SSDT overlays using the upgrade
initrd mechanism introduced in 4.7. This patch series adds support for
two more methods:

* From an EFI variable

 This is the preferred method, when EFI is supported on the platform,
 because it allows a persistent, OS independent way of storing and
 updating the user defined SSDTs. There is also work underway to
 implement EFI support for loading user defined SSDTs and using this
 method will make it easier to convert to the EFI loading mechanism
 when that will arrive.

* From userspace via configfs

 This is useful when we want to defer the operation to userspace for
 platform detection, loading the SSDTs from a custom partition, etc.


Changes from v3:

* fix a bisectability issue reported by kbuild

* rework the enumeration fix to support PRP0001 enumeration; also,
  introduce acpi_device_set/clear_enumerated() for clarity

* clear the enumerated status for acpi_device when the I2C/SPI clients
  are removed (for example as a result of an adapter removal) to allow
  the devices to be re-enumerated later

Changes from v2:

* fix a few issues caught by the kbuild test robot

* add more configfs table attributes

* removed the initrd based loading functionality from this patch set
  as this can already be accomplished in 4.7 using the ACPI table
  upgrade mechanism

* rebased to 4.7-rc3

Changes from v1:

* rebased on top of the ACPI install from initrd table functionality;
  there is significant overlap between the 1st patch in this series
  and these patch [1] from Lv - I kept it in this series until the
  discussions around the taint and config option are resolved

* make sure EFI_RUNTIME_SERVICES are available before trying to use
  EFI variables to load tables

* rework the ACPI reconfiguration notifications to work on device
  granularity (device added or removed) instead of table granularity
  (table loaded or unloaded)

* add support for table unloading / device removal

* note that the last patch is just a hack to be able to test the table
  unload / device remove functionality, if someone wants to try out
  this patch set

[1] https://patchwork.kernel.org/patch/8795931/

Octavian Purdila (8):
  Documentation: acpi: add SSDT overlays documentation
  acpi: fix enumeration (visited) flags for bus rescans
  acpi: add support for ACPI reconfiguration notifiers
  i2c: add support for ACPI reconfigure notifications
  spi: add support for ACPI reconfigure notifications
  efi: load SSTDs from EFI variables
  acpi: add support for configfs
  acpi: add support for loading SSDTs via configfs

 Documentation/ABI/testing/configfs-acpi |  36 +++++
 Documentation/acpi/ssdt-overlays.txt    | 172 ++++++++++++++++++++
 Documentation/kernel-parameters.txt     |   7 +
 MAINTAINERS                             |   1 +
 drivers/acpi/Kconfig                    |   9 ++
 drivers/acpi/Makefile                   |   1 +
 drivers/acpi/bus.c                      |   9 ++
 drivers/acpi/configfs.c                 | 267 ++++++++++++++++++++++++++++++++
 drivers/acpi/internal.h                 |   3 +
 drivers/acpi/scan.c                     |  81 +++++++++-
 drivers/acpi/sysfs.c                    |   6 +-
 drivers/firmware/efi/efi.c              | 106 +++++++++++++
 drivers/i2c/i2c-core.c                  | 172 +++++++++++++++-----
 drivers/spi/spi.c                       |  96 +++++++++++-
 include/linux/acpi.h                    |  36 +++++
 15 files changed, 946 insertions(+), 56 deletions(-)
 create mode 100644 Documentation/ABI/testing/configfs-acpi
 create mode 100644 Documentation/acpi/ssdt-overlays.txt
 create mode 100644 drivers/acpi/configfs.c

-- 
2.7.4
