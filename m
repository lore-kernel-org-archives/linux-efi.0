From: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH V2 0/2] CPER ARM error information parsing
Date: Thu,  7 Dec 2017 14:25:25 -0500
Message-ID: <1512674727-25770-1-git-send-email-tbaicar@codeaurora.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, james.morse-5wv7dgnIgG8@public.gmane.org, andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Break out the ARM CPER code into a new file so it's separate from the main of
the CPER code.

Add parsing for the ARM error information value based on UEFI 2.7 spec tables
263-265.

Tyler Baicar (2):
  efi: move ARM CPER code to new file
  efi: parse ARM error information value

 drivers/firmware/efi/Kconfig    |   5 +
 drivers/firmware/efi/Makefile   |   1 +
 drivers/firmware/efi/cper-arm.c | 356 ++++++++++++++++++++++++++++++++++++++++
 drivers/firmware/efi/cper.c     | 123 --------------
 include/linux/cper.h            |  53 ++++++
 5 files changed, 415 insertions(+), 123 deletions(-)
 create mode 100644 drivers/firmware/efi/cper-arm.c

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
