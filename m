From: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH 0/2] process vendor proprietary CPER error section
Date: Tue, 21 Jul 2015 16:36:45 -0700
Message-ID: <1437521807-27571-1-git-send-email-zjzhang@codeaurora.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, al.stone-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, mchehab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org
Cc: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linaro-acpi-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, vgandhi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

UEFI spec allows for non-standard (eg. vendor proprietary) error
section in CPER (COmmon Platform Error Record), as defined in section
N2.3 of UEFI version 2.5.

If section Type field of Generic Error Data Entry matches with one
of the GUID as defined in include/linux/cper.h, print out the raw data
in dmesg buffer, and also add a tracepoint for reporting such error.

Jonathan (Zhixiong) Zhang (2):
  efi: parse vendor proprietary CPER section
  ras: acpi/apei: trace event for vendor proprietary CPER section

 drivers/firmware/efi/cper.c | 61 +++++++++++++++++++++++++++++++++++++++++++--
 include/linux/cper.h        |  4 +++
 drivers/acpi/apei/ghes.c | 29 +++++++++++++++++++++++++++--
 drivers/ras/ras.c        |  1 +
 include/ras/ras_event.h  | 30 ++++++++++++++++++++++++++++++
 5 files changed, 121 insertions(+), 4 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
