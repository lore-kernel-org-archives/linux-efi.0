From: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH V2 0/2] process unrecognized CPER error section
Date: Tue,  8 Sep 2015 14:29:19 -0700
Message-ID: <1441747761-12012-1-git-send-email-zjzhang@codeaurora.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, al.stone-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, gong.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
Cc: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linaro-acpi-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, vgandhi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

Currently the kernel ignores CPER records that are unrecognized.
On the other hand, UEFI spec allows for non-standard (eg. vendor
proprietary) error section type in CPER (Common Platform Error Record),
as defined in section N2.3 of UEFI version 2.5. Therefore, user
is not able to see hardware error data of non-standard section.

If section Type field of Generic Error Data Entry is unrecognized,
prints out the raw data in dmesg buffer, and also adds a tracepoint
for reporting such hardware error.

V2:
1. Handle all unrecognized CPER records instead of matching with
section type that is known to be vendor proprietary. (Borislav)

Jonathan (Zhixiong) Zhang (2):
  efi: print unrecognized CPER section
  ras: acpi/apei: generate trace event for unrecognized CPER section

 drivers/acpi/apei/ghes.c    | 23 +++++++++++++++++++++--
 drivers/firmware/efi/cper.c | 39 +++++++++++++++++++++++++++++++--------
 drivers/ras/ras.c           |  1 +
 include/ras/ras_event.h     | 45 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 98 insertions(+), 10 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
