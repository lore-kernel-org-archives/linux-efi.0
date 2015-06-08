From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] efi: rtc-efi: use correct EFI 'epoch'
Date: Mon,  8 Jun 2015 13:27:14 +0200
Message-ID: <1433762834-17961-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-efi@vger.kernel.org

The rtc-efi driver declares that the EFI 'epoch' is 1/1/1998, but
the UEFI spec does not define it at all. It does define a minimum
of 1900 for the 'Year' member of the EFI_TIME struct, so let's use
1900 as the minimum year and not 1998.

This prevents rtc_read_time() failures when the RTC that backs the
EFI time services is set to a date before 1998.

Cc: Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>
Cc: Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Cc: rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/rtc/rtc-efi.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/rtc-efi.c b/drivers/rtc/rtc-efi.c
index cb989cd00b14..4a93b0bbf22c 100644
--- a/drivers/rtc/rtc-efi.c
+++ b/drivers/rtc/rtc-efi.c
@@ -25,9 +25,12 @@
 
 #define EFI_ISDST (EFI_TIME_ADJUST_DAYLIGHT|EFI_TIME_IN_DAYLIGHT)
 /*
- * EFI Epoch is 1/1/1998
+ * The UEFI spec does not literally define an epoch, but it does
+ * define EFI_TIME::Year as having a value between 1900 and 9999.
+ * (UEFI spec v2.5 paragraph 7.3)
+ * So let's use 1900 as the EFI epoch year.
  */
-#define EFI_RTC_EPOCH		1998
+#define EFI_RTC_EPOCH		1900
 
 /*
  * returns day of the year [0-365]
@@ -40,8 +43,6 @@ compute_yday(efi_time_t *eft)
 }
 /*
  * returns day of the week [0-6] 0=Sunday
- *
- * Don't try to provide a year that's before 1998, please !
  */
 static int
 compute_wday(efi_time_t *eft)
@@ -60,9 +61,9 @@ compute_wday(efi_time_t *eft)
 	ndays += compute_yday(eft);
 
 	/*
-	 * 4=1/1/1998 was a Thursday
+	 * 1=1/1/1900 was a Monday
 	 */
-	return (ndays + 4) % 7;
+	return (ndays + 1) % 7;
 }
 
 static void
-- 
1.9.1
