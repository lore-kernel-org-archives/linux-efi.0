From: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 00/14] Support timezone of ACPI TAD and EFI TIME
Date: Thu, 19 Dec 2013 15:51:41 +0800
Message-ID: <1387439515-8926-1-git-send-email-jlee@suse.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: Elliott-VXdhtT5mjnY@public.gmane.org, samer.el-haj-mahmoud-VXdhtT5mjnY@public.gmane.org, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, werner-IBi9RG/b67k@public.gmane.org, trenn-l3A5Bk7waGM@public.gmane.org, JBeulich-IBi9RG/b67k@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This patchset add the timezone support of ACPI TAD and EFI TIME, it
also add codes for adjusting system time base on the timezone value
from EFI TIME services when system boot.

Those patches bring the following changes:

 + Add ACPI driver against ACPI000E ACPI Time and Alarm Device.

 + Add RTC driver of ACPI TAD.

 + Add rtc ioctl functions, RTC_RD_GMTOFF and RTC_SET_GMTOFF, provide
   interface to user space for maintain timezone value in BIOS.
   The GMTOFF names of ioctl functions match with the tm_gmtoff field
   in rtc_time and tm structure in GNU C library.

 + Add rtc ioctl function, RTC_CAPS_READ, provide to user space for
   grab the capabilities value to timezone and daylight of interface.

 + Moved duplicate functions to efi.h header for convert EFI Time.

 + When "CMOS RTC not Present" flag set in FADT, block CMOS RTC interface
   and switch to EFI time services.

 + Adjusting system time base on timezone from EFI time when system boot.

 + Add rtc-tz.txt document.

Please set CONFIG_RTC_DRV_EFI=m and CONFIG_RTC_ACPI_TAD=m to build RTC ACPI
TAD and EFI TIME drivers.For testing, please use "acpi_no_cmos_rtc=1" to set
CMOST RTC not Present flag in FADT to trigger the mechanism for adjust system
time and block CMOS interface.

About the definition of timezone and the format transformation between ACPI,
EFI and tm_gmtoff of GNU. Please check the rtc-tz.txt document in patch.


Jan Beulich (1):
  x86-64/efi: Use EFI to deal with platform wall clock (again)

Lee, Chun-Yi (13):
  rtc-efi: fix decrease day twice when computing year days
  rtc: block registration of rtc-cmos when CMOS RTC Not Present
  ACPI: Add ACPI 5.0 Time and Alarm Device driver
  rtc: Add RTC driver of ACPI Time and Alarm Device
  rtc-efi: register rtc-efi device when EFI enabled
  rtc-efi: add GMTOFF support to rtc_efi
  rtc-efi: set uie_unsupported for indicate rtc-efi doesn't support UIE
  efi: move functions of access efi time to header file for sharing
  rtc: improve and move week day computing function to rtc header
  rtc: switch to get/set rtc time to efi functions if CMOS RTC Not
  efi: adjust system time base on timezone from EFI time services
  Documentation/RTC: add document of ACPI TAD and EFI TIME driver
  acpi: add early parameter to set CMOS RTC Not Present bit for testing

 Documentation/rtc-tz.txt    |  510 +++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/acpi/boot.c |   17 ++
 arch/x86/kernel/rtc.c       |   28 ++-
 arch/x86/mm/pageattr.c      |   10 +-
 arch/x86/platform/efi/efi.c |   89 ++++++--
 drivers/acpi/Makefile       |    3 +
 drivers/acpi/acpi_tad.c     |  176 +++++++++++++++
 drivers/acpi/bus.c          |    3 +
 drivers/acpi/internal.h     |    5 +
 drivers/char/efirtc.c       |   98 ---------
 drivers/rtc/Kconfig         |   12 +-
 drivers/rtc/Makefile        |    1 +
 drivers/rtc/rtc-acpitad.c   |  283 ++++++++++++++++++++++++
 drivers/rtc/rtc-cmos.c      |    9 +
 drivers/rtc/rtc-dev.c       |    4 +
 drivers/rtc/rtc-efi.c       |  177 +++++++---------
 drivers/rtc/rtc-sysfs.c     |    8 +
 include/asm-generic/rtc.h   |   22 ++
 include/linux/acpi.h        |   31 +++
 include/linux/efi.h         |  127 +++++++++++-
 include/linux/rtc.h         |   43 ++++
 include/uapi/linux/rtc.h    |    5 +
 init/main.c                 |   13 +-
 kernel/time.c               |    2 +-
 24 files changed, 1439 insertions(+), 237 deletions(-)
 create mode 100644 Documentation/rtc-tz.txt
 create mode 100644 drivers/acpi/acpi_tad.c
 create mode 100644 drivers/rtc/rtc-acpitad.c
