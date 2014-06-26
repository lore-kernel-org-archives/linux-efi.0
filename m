From: Jason Luan <jianhai.luan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/9] x86: Do full rtc synchronization with ntp
Date: Thu, 26 Jun 2014 14:29:41 +0800
Message-ID: <1403764189-30797-2-git-send-email-jianhai.luan@oracle.com>
References: <1403764189-30797-1-git-send-email-jianhai.luan@oracle.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1403764189-30797-1-git-send-email-jianhai.luan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gmarsden_org_ww-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-ueK_WW-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, annie.li-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Luan <jianhai.luan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Every 11 minutes ntp attempts to update the x86 rtc with the current
system time.  Currently, the x86 code only updates the rtc if the system
time is within +/-15 minutes of the current value of the rtc. This
was done originally to avoid setting the RTC if the RTC was in localtime
mode (common with Windows dualbooting).  Other architectures do a full
synchronization and now that we have better infrastructure to detect
when the RTC is in localtime, there is no reason that x86 should be
software limited to a 30 minute window.

This patch changes the behavior of the kernel to do a full synchronization
(year, month, day, hour, minute, and second) of the rtc when ntp requests
a synchronization between the system time and the rtc.

I've used the RTC library functions in this patchset as they do all the
required bounds checking.

Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
[jstultz: Tweak commit message, fold in build fix found by fengguang
Also add select RTC_LIB to X86, per new dependency, as found by prarit]
Signed-off-by: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

(cherry picked from commit 3195ef59cb42cda3aeeb24a7fd2ba1b900c4a3cc)
Signed-off-by: Jason Luan <jianhai.luan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Conflicts:
	arch/x86/Kconfig

Signed-off-by: Jason Luan <jianhai.luan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/Kconfig              |  1 +
 arch/x86/kernel/rtc.c         | 69 ++++++++-----------------------------------
 arch/x86/platform/efi/efi.c   | 24 ++++++++++-----
 arch/x86/platform/mrst/vrtc.c | 44 ++++++++++++++++-----------
 4 files changed, 55 insertions(+), 83 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2c64e6e..4b830d4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -114,6 +114,7 @@ config X86
 	select MODULES_USE_ELF_RELA if X86_64
 	select CLONE_BACKWARDS if X86_32
 	select GENERIC_SIGALTSTACK
+	select RTC_LIB
 
 config INSTRUCTION_DECODER
 	def_bool y
diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index 801602b..44e6c3a 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -13,6 +13,7 @@
 #include <asm/x86_init.h>
 #include <asm/time.h>
 #include <asm/mrst.h>
+#include <asm/rtc.h>
 
 #ifdef CONFIG_X86_32
 /*
@@ -36,70 +37,24 @@ EXPORT_SYMBOL(rtc_lock);
  * nowtime is written into the registers of the CMOS clock, it will
  * jump to the next second precisely 500 ms later. Check the Motorola
  * MC146818A or Dallas DS12887 data sheet for details.
- *
- * BUG: This routine does not handle hour overflow properly; it just
- *      sets the minutes. Usually you'll only notice that after reboot!
  */
 int mach_set_rtc_mmss(unsigned long nowtime)
 {
-	int real_seconds, real_minutes, cmos_minutes;
-	unsigned char save_control, save_freq_select;
-	unsigned long flags;
+	struct rtc_time tm;
 	int retval = 0;
 
-	spin_lock_irqsave(&rtc_lock, flags);
-
-	 /* tell the clock it's being set */
-	save_control = CMOS_READ(RTC_CONTROL);
-	CMOS_WRITE((save_control|RTC_SET), RTC_CONTROL);
-
-	/* stop and reset prescaler */
-	save_freq_select = CMOS_READ(RTC_FREQ_SELECT);
-	CMOS_WRITE((save_freq_select|RTC_DIV_RESET2), RTC_FREQ_SELECT);
-
-	cmos_minutes = CMOS_READ(RTC_MINUTES);
-	if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD)
-		cmos_minutes = bcd2bin(cmos_minutes);
-
-	/*
-	 * since we're only adjusting minutes and seconds,
-	 * don't interfere with hour overflow. This avoids
-	 * messing with unknown time zones but requires your
-	 * RTC not to be off by more than 15 minutes
-	 */
-	real_seconds = nowtime % 60;
-	real_minutes = nowtime / 60;
-	/* correct for half hour time zone */
-	if (((abs(real_minutes - cmos_minutes) + 15)/30) & 1)
-		real_minutes += 30;
-	real_minutes %= 60;
-
-	if (abs(real_minutes - cmos_minutes) < 30) {
-		if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-			real_seconds = bin2bcd(real_seconds);
-			real_minutes = bin2bcd(real_minutes);
-		}
-		CMOS_WRITE(real_seconds, RTC_SECONDS);
-		CMOS_WRITE(real_minutes, RTC_MINUTES);
+	rtc_time_to_tm(nowtime, &tm);
+	if (!rtc_valid_tm(&tm)) {
+		retval = set_rtc_time(&tm);
+		if (retval)
+			printk(KERN_ERR "%s: RTC write failed with error %d\n",
+			       __FUNCTION__, retval);
 	} else {
-		printk_once(KERN_NOTICE
-		       "set_rtc_mmss: can't update from %d to %d\n",
-		       cmos_minutes, real_minutes);
-		retval = -1;
+		printk(KERN_ERR
+		       "%s: Invalid RTC value: write of %lx to RTC failed\n",
+			__FUNCTION__, nowtime);
+		retval = -EINVAL;
 	}
-
-	/* The following flags have to be released exactly in this order,
-	 * otherwise the DS12887 (popular MC146818A clone with integrated
-	 * battery and quartz) will not reset the oscillator and will not
-	 * update precisely 500 ms later. You won't find this mentioned in
-	 * the Dallas Semiconductor data sheets, but who believes data
-	 * sheets anyway ...                           -- Markus Kuhn
-	 */
-	CMOS_WRITE(save_control, RTC_CONTROL);
-	CMOS_WRITE(save_freq_select, RTC_FREQ_SELECT);
-
-	spin_unlock_irqrestore(&rtc_lock, flags);
-
 	return retval;
 }
 
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 6ffceef..09db48e 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -48,6 +48,7 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 #include <asm/x86_init.h>
+#include <asm/rtc.h>
 
 #define EFI_DEBUG	1
 
@@ -273,10 +274,10 @@ static efi_status_t __init phys_efi_get_time(efi_time_t *tm,
 
 int efi_set_rtc_mmss(unsigned long nowtime)
 {
-	int real_seconds, real_minutes;
 	efi_status_t 	status;
 	efi_time_t 	eft;
 	efi_time_cap_t 	cap;
+	struct rtc_time	tm;
 
 	status = efi.get_time(&eft, &cap);
 	if (status != EFI_SUCCESS) {
@@ -284,13 +285,20 @@ int efi_set_rtc_mmss(unsigned long nowtime)
 		return -1;
 	}
 
-	real_seconds = nowtime % 60;
-	real_minutes = nowtime / 60;
-	if (((abs(real_minutes - eft.minute) + 15)/30) & 1)
-		real_minutes += 30;
-	real_minutes %= 60;
-	eft.minute = real_minutes;
-	eft.second = real_seconds;
+	rtc_time_to_tm(nowtime, &tm);
+	if (!rtc_valid_tm(&tm)) {
+		eft.year = tm.tm_year + 1900;
+		eft.month = tm.tm_mon + 1;
+		eft.day = tm.tm_mday;
+		eft.minute = tm.tm_min;
+		eft.second = tm.tm_sec;
+		eft.nanosecond = 0;
+	} else {
+		printk(KERN_ERR
+		       "%s: Invalid EFI RTC value: write of %lx to EFI RTC failed\n",
+		       __FUNCTION__, nowtime);
+		return -1;
+	}
 
 	status = efi.set_time(&eft);
 	if (status != EFI_SUCCESS) {
diff --git a/arch/x86/platform/mrst/vrtc.c b/arch/x86/platform/mrst/vrtc.c
index 225bd0f..d62b0a3 100644
--- a/arch/x86/platform/mrst/vrtc.c
+++ b/arch/x86/platform/mrst/vrtc.c
@@ -85,27 +85,35 @@ unsigned long vrtc_get_time(void)
 	return mktime(year, mon, mday, hour, min, sec);
 }
 
-/* Only care about the minutes and seconds */
 int vrtc_set_mmss(unsigned long nowtime)
 {
-	int real_sec, real_min;
 	unsigned long flags;
-	int vrtc_min;
-
-	spin_lock_irqsave(&rtc_lock, flags);
-	vrtc_min = vrtc_cmos_read(RTC_MINUTES);
-
-	real_sec = nowtime % 60;
-	real_min = nowtime / 60;
-	if (((abs(real_min - vrtc_min) + 15)/30) & 1)
-		real_min += 30;
-	real_min %= 60;
-
-	vrtc_cmos_write(real_sec, RTC_SECONDS);
-	vrtc_cmos_write(real_min, RTC_MINUTES);
-	spin_unlock_irqrestore(&rtc_lock, flags);
-
-	return 0;
+	struct rtc_time tm;
+	int year;
+	int retval = 0;
+
+	rtc_time_to_tm(nowtime, &tm);
+	if (!rtc_valid_tm(&tm) && tm.tm_year >= 72) {
+		/*
+		 * tm.year is the number of years since 1900, and the
+		 * vrtc need the years since 1972.
+		 */
+		year = tm.tm_year - 72;
+		spin_lock_irqsave(&rtc_lock, flags);
+		vrtc_cmos_write(year, RTC_YEAR);
+		vrtc_cmos_write(tm.tm_mon, RTC_MONTH);
+		vrtc_cmos_write(tm.tm_mday, RTC_DAY_OF_MONTH);
+		vrtc_cmos_write(tm.tm_hour, RTC_HOURS);
+		vrtc_cmos_write(tm.tm_min, RTC_MINUTES);
+		vrtc_cmos_write(tm.tm_sec, RTC_SECONDS);
+		spin_unlock_irqrestore(&rtc_lock, flags);
+	} else {
+		printk(KERN_ERR
+		       "%s: Invalid vRTC value: write of %lx to vRTC failed\n",
+			__FUNCTION__, nowtime);
+		retval = -EINVAL;
+	}
+	return retval;
 }
 
 void __init mrst_rtc_init(void)
-- 
1.9.3
