From: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/3] rtc-efi: add timezone to rtc_time that will used by rtc-efi
Date: Sat, 29 Dec 2012 00:26:40 +0800
Message-ID: <1356712001-12198-2-git-send-email-jlee@suse.com>
References: <1356712001-12198-1-git-send-email-jlee@suse.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1356712001-12198-1-git-send-email-jlee-IBi9RG/b67k@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Per UEFI 2.3.1 spec, we can use SetTime() to store the timezone value to BIOS and 
get it back by GetTime(). It's good for installation system to gain the default 
timezone setting from BIOS that was set by manufacturer. 

This patch adds new field tm_timezone to rtc_time struct for expose the timezone
to userspace. And, patch also adds the check logic to rtc-efi when convert timezone.
The check logic of timezone only affect on x86 architecture and keep the original
EFI_UNSPECIFIED_TIMEZONE value on IA64.

Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>
Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
---
 drivers/rtc/rtc-efi.c    |   20 +++++++++++++++++---
 include/uapi/linux/rtc.h |    1 +
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-efi.c b/drivers/rtc/rtc-efi.c
index c9f890b..4e74ec0 100644
--- a/drivers/rtc/rtc-efi.c
+++ b/drivers/rtc/rtc-efi.c
@@ -62,7 +62,7 @@ compute_wday(efi_time_t *eft)
 	return (ndays + 4) % 7;
 }
 
-static void
+static int
 convert_to_efi_time(struct rtc_time *wtime, efi_time_t *eft)
 {
 	eft->year	= wtime->tm_year + 1900;
@@ -73,7 +73,16 @@ convert_to_efi_time(struct rtc_time *wtime, efi_time_t *eft)
 	eft->second 	= wtime->tm_sec;
 	eft->nanosecond = 0;
 	eft->daylight	= wtime->tm_isdst ? EFI_ISDST : 0;
+#ifdef CONFIG_X86
+	if (abs(wtime->tm_timezone) > 1440 &&
+			wtime->tm_timezone != EFI_UNSPECIFIED_TIMEZONE)
+		return -EINVAL;
+	eft->timezone	= wtime->tm_timezone;
+#else
 	eft->timezone	= EFI_UNSPECIFIED_TIMEZONE;
+#endif /* CONFIG_X86 */
+
+	return 0;
 }
 
 static void
@@ -86,6 +95,9 @@ convert_from_efi_time(efi_time_t *eft, struct rtc_time *wtime)
 	wtime->tm_mday = eft->day;
 	wtime->tm_mon  = eft->month - 1;
 	wtime->tm_year = eft->year - 1900;
+#ifdef CONFIG_X86
+	wtime->tm_timezone = eft->timezone;
+#endif /* CONFIG_X86 */
 
 	/* day of the week [0-6], Sunday=0 */
 	wtime->tm_wday = compute_wday(eft);
@@ -130,7 +142,8 @@ static int efi_set_alarm(struct device *dev, struct rtc_wkalrm *wkalrm)
 	efi_time_t eft;
 	efi_status_t status;
 
-	convert_to_efi_time(&wkalrm->time, &eft);
+	if (convert_to_efi_time(&wkalrm->time, &eft))
+		return -EINVAL;
 
 	/*
 	 * XXX Fixme:
@@ -171,7 +184,8 @@ static int efi_set_time(struct device *dev, struct rtc_time *tm)
 	efi_status_t status;
 	efi_time_t eft;
 
-	convert_to_efi_time(tm, &eft);
+	if (convert_to_efi_time(tm, &eft))
+		return -EINVAL;
 
 	status = efi.set_time(&eft);
 
diff --git a/include/uapi/linux/rtc.h b/include/uapi/linux/rtc.h
index f8c82e6..841725f 100644
--- a/include/uapi/linux/rtc.h
+++ b/include/uapi/linux/rtc.h
@@ -27,6 +27,7 @@ struct rtc_time {
 	int tm_wday;
 	int tm_yday;
 	int tm_isdst;
+	int tm_timezone;
 };
 
 /*
-- 
1.6.4.2
