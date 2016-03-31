From: Octavian Purdila <octavian.purdila@intel.com>
Subject: [RFC PATCH 00/10] ACPI overlays
Date: Thu, 31 Mar 2016 12:36:56 +0300
Message-ID: <1459417026-6697-1-git-send-email-octavian.purdila@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Mark Brown <broonie@kernel.org>, Wolfram Sang <wsa@the-dreams.de>
Cc: Joel Becker <jlbec@evilplan.org>, Christoph Hellwig <hch@lst.de>, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org, irina.tirdea@intel.com, Octavian Purdila <octavian.purdila@intel.com>
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

Octavian Purdila (10):
  kernel: add TAINT_OVERLAY_ACPI_TABLE
  acpi: install SSDT tables from initrd
  acpi: add support for ACPI reconfiguration notifiers
  acpi: fix enumeration (visited) flags for bus rescans
  i2c: add support for ACPI reconfigure notifications
  spi: add support for ACPI reconfigure notifications
  efi: load SSTDs from EFI variables
  configfs: fix CONFIGFS_BIN_ATTR_[RW]O definitions
  acpi: add support for configfs
  acpi: add support for loading SSDTs via configfs

 Documentation/ABI/testing/configfs-acpi |  23 +++++
 Documentation/acpi/ssdt-overlays.txt    | 174 ++++++++++++++++++++++++++++++++
 Documentation/kernel-parameters.txt     |   7 ++
 Documentation/oops-tracing.txt          |   2 +
 Documentation/sysctl/kernel.txt         |   1 +
 MAINTAINERS                             |   1 +
 drivers/acpi/Kconfig                    |   9 ++
 drivers/acpi/Makefile                   |   1 +
 drivers/acpi/bus.c                      |  72 +++++++++++++
 drivers/acpi/configfs.c                 | 143 ++++++++++++++++++++++++++
 drivers/acpi/internal.h                 |   3 +
 drivers/acpi/scan.c                     |  73 +++++++++++++-
 drivers/acpi/sysfs.c                    |   6 +-
 drivers/firmware/efi/efi.c              | 107 ++++++++++++++++++++
 drivers/i2c/i2c-core.c                  |  38 ++++++-
 drivers/spi/spi.c                       |  36 ++++++-
 include/acpi/acpi_bus.h                 |   8 ++
 include/linux/configfs.h                |   4 +-
 include/linux/kernel.h                  |   1 +
 kernel/panic.c                          |   2 +
 20 files changed, 699 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/ABI/testing/configfs-acpi
 create mode 100644 Documentation/acpi/ssdt-overlays.txt
 create mode 100644 drivers/acpi/configfs.c

-- 
1.9.1
