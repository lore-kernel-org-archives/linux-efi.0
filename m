From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 0/6] uuid: Convert rest users to new API
Date: Wed, 19 Jul 2017 21:28:51 +0300
Message-ID: <20170719182857.73693-1-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: linux-acpi@vger.kernel.org, devel@linuxdriverproject.org, sparmaintainer@unisys.com, devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org, linux-watchdog@vger.kernel.org, linux-efi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, Lukas Wunner <lukas@wunner.de>
Cc: Stephen Hemminger <sthemmin@microsoft.com>, Samuel Ortiz <sameo@linux.intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Haiyang Zhang <haiyangz@microsoft.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tomas Winkler <tomas.winkler@intel.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Guenter Roeck <linux@roeck-us.net>, Len Brown <lenb@kernel.org>
List-Id: linux-efi@vger.kernel.org

This series is converting the rest of the users of old UUID API to a new
one and dropping UUID UAPI header away. Note, ABI is kept the same.

User space should have not used those headers. We have libuuid and it
likely would be extended to cover GUID operations.

All patches have been compiled tested on x86_64 machine.

The series is supposed to go via UUID tree with immutable branch
(in case we have new users of obsolete API).

I dunno if it's a good idea to put them to v4.13-rc2 where first part of
the changes is applied.

Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: David Kershner <david.kershner@unisys.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <lenb@kernel.org>


Andy Shevchenko (6):
  efi: Switch to use new generic UUID API
  mei: Switch to use new generic UUID API
  staging: unisys: Switch to use new generic UUID API
  vmbus: Switch to use new generic UUID API
  uuid: Kill uapi/uuid.h
  device property: Switch to use new generic UUID API

 drivers/acpi/property.c                            | 50 +++++------
 drivers/firmware/efi/cper.c                        | 10 +--
 drivers/hv/channel.c                               |  4 +-
 drivers/hv/channel_mgmt.c                          | 18 ++--
 drivers/hv/hyperv_vmbus.h                          |  4 +-
 drivers/hv/vmbus_drv.c                             | 43 ++++------
 drivers/misc/mei/bus-fixup.c                       | 35 ++++----
 drivers/misc/mei/bus.c                             | 14 ++--
 drivers/misc/mei/client.c                          | 21 +++--
 drivers/misc/mei/client.h                          | 12 +--
 drivers/misc/mei/hbm.c                             |  2 +-
 drivers/misc/mei/hw.h                              |  2 +-
 drivers/misc/mei/main.c                            |  2 +-
 drivers/nfc/mei_phy.h                              |  5 +-
 drivers/staging/unisys/Documentation/overview.txt  | 14 ++--
 drivers/staging/unisys/include/channel.h           | 45 +++++-----
 drivers/staging/unisys/include/iochannel.h         | 14 +---
 drivers/staging/unisys/include/visorbus.h          | 12 +--
 drivers/staging/unisys/visorbus/controlvmchannel.h | 24 ++----
 drivers/staging/unisys/visorbus/vbuschannel.h      |  7 +-
 drivers/staging/unisys/visorbus/visorbus_main.c    | 28 +++----
 drivers/staging/unisys/visorbus/visorbus_private.h |  6 +-
 drivers/staging/unisys/visorbus/visorchannel.c     | 48 +++++------
 drivers/staging/unisys/visorbus/visorchipset.c     | 39 +++++----
 drivers/staging/unisys/visorhba/visorhba_main.c    |  6 +-
 drivers/staging/unisys/visorinput/visorinput.c     | 38 ++++-----
 drivers/staging/unisys/visornic/visornic_main.c    |  6 +-
 drivers/watchdog/mei_wdt.c                         |  5 +-
 include/linux/cper.h                               | 94 ++++++++++-----------
 include/linux/efi.h                                |  4 +-
 include/linux/hyperv.h                             | 98 +++++++++++-----------
 include/linux/mei_cl_bus.h                         |  2 +-
 include/linux/mod_devicetable.h                    |  8 +-
 include/linux/uuid.h                               | 20 ++++-
 include/uapi/linux/hyperv.h                        |  6 +-
 include/uapi/linux/mei.h                           |  4 +-
 include/uapi/linux/uuid.h                          | 42 ----------
 samples/mei/mei-amt-version.c                      | 21 ++++-
 scripts/mod/file2alias.c                           |  4 +-
 39 files changed, 387 insertions(+), 430 deletions(-)
 delete mode 100644 include/uapi/linux/uuid.h

-- 
2.11.0
