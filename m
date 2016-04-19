From: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH v2 00/10] ACPI overlays
Date: Wed, 20 Apr 2016 01:38:58 +0300
Message-ID: <1461105548-20618-1-git-send-email-octavian.purdila@intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>
Cc: Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, irina.tirdea-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

This patch sets provides three methods for loading custom SSDTs:

* From an EFI variable

  This is the preferred method, when EFI is supported on the platform,
  because it allows a persistent, OS independent way of storing and
  updating the user defined SSDTs. There is also work underway to
  implement EFI support for loading user defined SSDTs and using this
  method will make it easier to convert to the EFI loading mechanism
  when that will arrive.

* From the first uncompressed initrd (similar with the override
  functionality)

  This is useful when EFI is not supported on the platform and when it
  is not possible to defer the loading to userspace.

* From userspace via configfs

  This is useful when we want to defer the operation to userspace for
  platform detection, loading the SSDTs from a custom partition, etc.


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


Octavian Purdila (10):
  kernel: add TAINT_OVERLAY_ACPI_TABLE
  acpi: decouple initrd table install from
    CONFIG_ACPI_INITRD_TABLE_OVERRIDE
  acpi: fix enumeration (visited) flags for bus rescans
  acpi: add support for ACPI reconfiguration notifiers
  i2c: add support for ACPI reconfigure notifications
  spi: add support for ACPI reconfigure notifications
  efi: load SSTDs from EFI variables
  acpi: add support for configfs
  acpi: add support for loading SSDTs via configfs
  HACK: acpi: configfs: add unload_hanlde_path attribute for tables

 Documentation/ABI/testing/configfs-acpi |  23 ++++
 Documentation/acpi/ssdt-overlays.txt    | 171 +++++++++++++++++++++++++++
 Documentation/kernel-parameters.txt     |   7 ++
 Documentation/oops-tracing.txt          |   2 +
 Documentation/sysctl/kernel.txt         |   1 +
 MAINTAINERS                             |   1 +
 arch/x86/kernel/setup.c                 |   2 +-
 drivers/acpi/Kconfig                    |   9 ++
 drivers/acpi/Makefile                   |   1 +
 drivers/acpi/bus.c                      |   9 ++
 drivers/acpi/configfs.c                 | 198 ++++++++++++++++++++++++++++++++
 drivers/acpi/internal.h                 |   3 +
 drivers/acpi/osl.c                      |  80 +++++++------
 drivers/acpi/scan.c                     |  79 ++++++++++++-
 drivers/acpi/sysfs.c                    |   6 +-
 drivers/firmware/efi/efi.c              | 109 ++++++++++++++++++
 drivers/i2c/i2c-core.c                  | 170 +++++++++++++++++++++------
 drivers/spi/spi.c                       |  94 +++++++++++++--
 include/acpi/acpi_bus.h                 |  18 +++
 include/linux/acpi.h                    |   8 +-
 include/linux/kernel.h                  |   1 +
 kernel/panic.c                          |   2 +
 22 files changed, 895 insertions(+), 99 deletions(-)
 create mode 100644 Documentation/ABI/testing/configfs-acpi
 create mode 100644 Documentation/acpi/ssdt-overlays.txt
 create mode 100644 drivers/acpi/configfs.c

-- 
1.9.1
