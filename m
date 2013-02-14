From: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFE PATCH 2/2] rtc, add write functionality to sysfs
Date: Thu, 14 Feb 2013 12:02:55 -0500
Message-ID: <1360861375-24131-3-git-send-email-prarit@redhat.com>
References: <1360861375-24131-1-git-send-email-prarit@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1360861375-24131-1-git-send-email-prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

/sys/class/rtc/rtcX/date and /sys/class/rtc/rtcX/time currently have
read-only access.  This patch introduces write functionality which will
set the rtc time.

Usage: echo YYYY-MM-DD > /sys/class/rtc/rtcX/date
       echo HH:MM:SS > /sys/class/rtc/rtcX/time

Signed-off-by: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 drivers/rtc/rtc-sysfs.c | 86 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 84 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-sysfs.c b/drivers/rtc/rtc-sysfs.c
index b70e2bb..87d63d7 100644
--- a/drivers/rtc/rtc-sysfs.c
+++ b/drivers/rtc/rtc-sysfs.c
@@ -48,6 +48,46 @@ rtc_sysfs_show_date(struct device *dev, struct device_attribute *attr,
 }
 
 static ssize_t
+rtc_sysfs_store_date(struct device *dev, struct device_attribute *attr,
+		     const char *buf, size_t count)
+{
+	ssize_t retval;
+	struct rtc_time tm;
+	char tmp[11] = "\0", *tmpptr = tmp;
+	char *cyear, *cmonth, *cday;
+	int year, month, day;
+
+	if (!capable(CAP_SYS_TIME))
+		return -EPERM;
+
+	/* from rtc_sysfs_show_date(): date string format is YYYY-MM-DD */
+	if (strlen(buf) != 11)
+		return -EINVAL;
+
+	strncpy(tmp, buf, 11);
+	cyear = strsep(&tmpptr, "-");
+	sscanf(cyear, "%i", &year);
+	cmonth = strsep(&tmpptr, "-");
+	sscanf(cmonth, "%i", &month);
+	cday = strsep(&tmpptr, "-");
+	sscanf(cday, "%i", &day);
+
+	retval = rtc_read_time(to_rtc_device(dev), &tm);
+	if (retval)
+		return -ENODEV;
+
+	tm.tm_year = year - 1900;
+	tm.tm_mon = month - 1;
+	tm.tm_mday = day;
+
+	retval = rtc_set_time(to_rtc_device(dev), &tm);
+	if (retval)
+		return retval;
+
+	return count;
+}
+
+static ssize_t
 rtc_sysfs_show_time(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
@@ -64,6 +104,46 @@ rtc_sysfs_show_time(struct device *dev, struct device_attribute *attr,
 }
 
 static ssize_t
+rtc_sysfs_store_time(struct device *dev, struct device_attribute *attr,
+		     const char *buf, size_t count)
+{
+	ssize_t retval;
+	struct rtc_time tm;
+	char tmp[9] = "\0", *tmpptr = tmp;
+	char *chour, *cmin, *csec;
+	int hour, min, sec;
+
+	if (!capable(CAP_SYS_TIME))
+		return -EPERM;
+
+	/* from rtc_sysfs_show_time(): time string format is HH:MM:SS */
+	if (strlen(buf) != 9)
+		return -EINVAL;
+
+	strncpy(tmp, buf, 9);
+	chour = strsep(&tmpptr, ":");
+	sscanf(chour, "%i", &hour);
+	cmin = strsep(&tmpptr, ":");
+	sscanf(cmin, "%i", &min);
+	csec = strsep(&tmpptr, ":");
+	sscanf(csec, "%i", &sec);
+
+	retval = rtc_read_time(to_rtc_device(dev), &tm);
+	if (retval)
+		return -ENODEV;
+
+	tm.tm_hour = hour;
+	tm.tm_min = min;
+	tm.tm_sec = sec;
+
+	retval = rtc_set_time(to_rtc_device(dev), &tm);
+	if (retval)
+		return retval;
+
+	return count;
+}
+
+static ssize_t
 rtc_sysfs_show_since_epoch(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
@@ -124,8 +204,10 @@ rtc_sysfs_show_hctosys(struct device *dev, struct device_attribute *attr,
 
 static struct device_attribute rtc_attrs[] = {
 	__ATTR(name, S_IRUGO, rtc_sysfs_show_name, NULL),
-	__ATTR(date, S_IRUGO, rtc_sysfs_show_date, NULL),
-	__ATTR(time, S_IRUGO, rtc_sysfs_show_time, NULL),
+	__ATTR(date, S_IRUGO | S_IWUGO, rtc_sysfs_show_date,
+	       rtc_sysfs_store_date),
+	__ATTR(time, S_IRUGO | S_IWUGO, rtc_sysfs_show_time,
+	       rtc_sysfs_store_time),
 	__ATTR(since_epoch, S_IRUGO, rtc_sysfs_show_since_epoch, NULL),
 	__ATTR(max_user_freq, S_IRUGO | S_IWUSR, rtc_sysfs_show_max_user_freq,
 			rtc_sysfs_set_max_user_freq),
-- 
1.8.1.2
