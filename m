From: Octavian Purdila <octavian.purdila@intel.com>
Subject: Re: [PATCH v5 0/8] ACPI overlays
Date: Wed, 6 Jul 2016 09:29:34 +0300
Message-ID: <CAE1zotJjxZn7kL5CUbK4YocHeycEL2Q74FHYQtx8DRuttXi5iw@mail.gmail.com>
References: <1467404352-27101-1-git-send-email-octavian.purdila@intel.com> <9539226.hSY6jyYgKd@vostro.rjw.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-i2c-owner@vger.kernel.org>
In-Reply-To: <9539226.hSY6jyYgKd@vostro.rjw.lan>
Sender: linux-i2c-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Mark Brown <broonie@kernel.org>, Wolfram Sang <wsa@the-dreams.de>, Joel Becker <jlbec@evilplan.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, linux-efi@vger.kernel.org, linux-i2c <linux-i2c@vger.kernel.org>, linux-spi <linux-spi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Irina Tirdea <irina.tirdea@intel.com>, Leonard Crestez <leonard.crestez@intel.com>
List-Id: linux-efi@vger.kernel.org

On Wed, Jul 6, 2016 at 3:34 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Friday, July 01, 2016 11:19:04 PM Octavian Purdila wrote:
>> This patch set enables custom ACPI board configuration by adding
>> mechanisms in the Linux kernel for loading user defined SSDTs.
>>
>> In order to support ACPI open-ended hardware configurations we need a
>> way to augment the ACPI configuration provided by the firmware
>> image. A common example is connecting sensors on I2C / SPI buses on
>> development boards.
>>
>> Although this can be accomplished by creating a kernel platform driver
>> or recompiling the firmware image with updated ACPI tables, neither is
>> practical: the former proliferates board specific kernel code while
>> the latter requires access to firmware tools which are often not
>> publicly available.
>>
>> Because ACPI supports external references in AML code a more practical
>> way to augment firmware ACPI configuration is by dynamically loading
>> user defined SSDT tables that contain the board specific information.
>>
>> Currently it is possible to load SSDT overlays using the upgrade
>> initrd mechanism introduced in 4.7. This patch series adds support for
>> two more methods:
>>
>> * From an EFI variable
>>
>>  This is the preferred method, when EFI is supported on the platform,
>>  because it allows a persistent, OS independent way of storing and
>>  updating the user defined SSDTs. There is also work underway to
>>  implement EFI support for loading user defined SSDTs and using this
>>  method will make it easier to convert to the EFI loading mechanism
>>  when that will arrive.
>>
>> * From userspace via configfs
>>
>>  This is useful when we want to defer the operation to userspace for
>>  platform detection, loading the SSDTs from a custom partition, etc.
>>
>>
>> Changes from v4:
>>
>> * EFI: use ucs2_as_utf8 and memcmp to check if the variable name
>>   matches the kernel command line parameter; fold the EFI ACPI table
>>   load code in the iterator function
>>
>> * I2C/SPI: add more information in the commit logs about how the
>>   enumeration status is set and checked; also add a new check of the
>>   enumerated status for the ACPI device remove reconfiguration
>>   notification
>>
>> Changes from v3:
>>
>> * fix a bisectability issue reported by kbuild
>>
>> * rework the enumeration fix to support PRP0001 enumeration; also,
>>   introduce acpi_device_set/clear_enumerated() for clarity
>>
>> * clear the enumerated status for acpi_device when the I2C/SPI clients
>>   are removed (for example as a result of an adapter removal) to allow
>>   the devices to be re-enumerated later
>>
>> Changes from v2:
>>
>> * fix a few issues caught by the kbuild test robot
>>
>> * add more configfs table attributes
>>
>> * removed the initrd based loading functionality from this patch set
>>   as this can already be accomplished in 4.7 using the ACPI table
>>   upgrade mechanism
>>
>> * rebased to 4.7-rc3
>>
>> Changes from v1:
>>
>> * rebased on top of the ACPI install from initrd table functionality;
>>   there is significant overlap between the 1st patch in this series
>>   and these patch [1] from Lv - I kept it in this series until the
>>   discussions around the taint and config option are resolved
>>
>> * make sure EFI_RUNTIME_SERVICES are available before trying to use
>>   EFI variables to load tables
>>
>> * rework the ACPI reconfiguration notifications to work on device
>>   granularity (device added or removed) instead of table granularity
>>   (table loaded or unloaded)
>>
>> * add support for table unloading / device removal
>>
>> * note that the last patch is just a hack to be able to test the table
>>   unload / device remove functionality, if someone wants to try out
>>   this patch set
>>
>> [1] https://patchwork.kernel.org/patch/8795931/
>>
>> Octavian Purdila (8):
>>   Documentation: acpi: add SSDT overlays documentation
>>   acpi: fix enumeration (visited) flags for bus rescans
>>   acpi: add support for ACPI reconfiguration notifiers
>>   i2c: add support for ACPI reconfigure notifications
>>   spi: add support for ACPI reconfigure notifications
>>   efi: load SSTDs from EFI variables
>>   acpi: add support for configfs
>>   acpi: add support for loading SSDTs via configfs
>>
>>  Documentation/ABI/testing/configfs-acpi |  36 +++++
>>  Documentation/acpi/ssdt-overlays.txt    | 172 ++++++++++++++++++++
>>  Documentation/kernel-parameters.txt     |   7 +
>>  MAINTAINERS                             |   1 +
>>  drivers/acpi/Kconfig                    |   9 ++
>>  drivers/acpi/Makefile                   |   1 +
>>  drivers/acpi/bus.c                      |   9 ++
>>  drivers/acpi/configfs.c                 | 267 ++++++++++++++++++++++++++++++++
>>  drivers/acpi/internal.h                 |   3 +
>>  drivers/acpi/scan.c                     |  81 +++++++++-
>>  drivers/acpi/sysfs.c                    |   6 +-
>>  drivers/firmware/efi/efi.c              |  85 ++++++++++
>>  drivers/i2c/i2c-core.c                  | 175 ++++++++++++++++-----
>>  drivers/spi/spi.c                       | 100 +++++++++++-
>>  include/linux/acpi.h                    |  36 +++++
>>  15 files changed, 932 insertions(+), 56 deletions(-)
>>  create mode 100644 Documentation/ABI/testing/configfs-acpi
>>  create mode 100644 Documentation/acpi/ssdt-overlays.txt
>>  create mode 100644 drivers/acpi/configfs.c
>
> It looks like all patches in this series except for the [6/8] are good to go.
>
> Do any of them depend on the [6/8]?
>

Yes, 6/8 and 8/8 both touch Documentation/acpi/ssdt-overlays.txt, but
it should be trivial to fix 8/8 if we pull out 6/8.

I've send an updated v6 for 6/8 only that fixes the issue Matt and
Geert noticed, so maybe its worth waiting for a couple of days for
Matt's review.
