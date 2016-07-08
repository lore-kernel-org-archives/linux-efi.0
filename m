From: Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH v7 0/8] ACPI overlays
Date: Fri,  8 Jul 2016 19:13:06 +0300
Message-ID: <1467994394-23983-1-git-send-email-octavian.purdila@intel.com>
Return-path: <linux-i2c-owner@vger.kernel.org>
Sender: linux-i2c-owner@vger.kernel.org
To: "Rafael J . Wysocki" <rjw@rjwysocki.net>
Cc: linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org, leonard.crestez@intel.com, Octavian Purdila <octavian.purdila@intel.com>
List-Id: linux-efi@vger.kernel.org

This patch set enables custom ACPI board configuration by adding
mechanisms in the Linux kernel for loading user defined SSDTs.

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

Changes from v6:

 * make acpi_table_events_fn static, fix (c) year and fix a typo

Changes from v5:

* EFI: enable duplicate detection to avoid firmware bugs that returns the
same variable over and over again; this requires pushing the entry
allocation back into efivar_ssdt_iter() and creating a temporary list
that is iterated over in efivar_ssdt_load()

* EFI: marked efivar_ssdt with __initdata

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
 drivers/acpi/Kconfig                    |   8 +
 drivers/acpi/Makefile                   |   1 +
 drivers/acpi/bus.c                      |   9 ++
 drivers/acpi/configfs.c                 | 267 ++++++++++++++++++++++++++++++++
 drivers/acpi/internal.h                 |   3 +
 drivers/acpi/scan.c                     |  81 +++++++++-
 drivers/acpi/sysfs.c                    |   6 +-
 drivers/firmware/efi/efi.c              |  96 ++++++++++++
 drivers/i2c/i2c-core.c                  | 175 ++++++++++++++++-----
 drivers/spi/spi.c                       | 100 +++++++++++-
 include/linux/acpi.h                    |  36 +++++
 15 files changed, 942 insertions(+), 56 deletions(-)
 create mode 100644 Documentation/ABI/testing/configfs-acpi
 create mode 100644 Documentation/acpi/ssdt-overlays.txt
 create mode 100644 drivers/acpi/configfs.c

-- 
2.7.4
