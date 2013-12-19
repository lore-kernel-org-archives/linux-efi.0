From: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 03/14] rtc: block registration of rtc-cmos when CMOS RTC Not Present
Date: Thu, 19 Dec 2013 15:44:02 +0800
Message-ID: <1387439053-8711-4-git-send-email-jlee@suse.com>
References: <1387439053-8711-1-git-send-email-jlee@suse.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1387439053-8711-1-git-send-email-jlee-IBi9RG/b67k@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: Elliott-VXdhtT5mjnY@public.gmane.org, samer.el-haj-mahmoud-VXdhtT5mjnY@public.gmane.org, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, werner-IBi9RG/b67k@public.gmane.org, trenn-l3A5Bk7waGM@public.gmane.org, JBeulich-IBi9RG/b67k@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

We should not acess CMOS address when CMOS RTC Not Present bit set in
FADT. The ee5872be patch didn't avoid rtc-cmos driver loaded when system support
ACPI PNP PNP0B0* devices.
So this patch block the registion of rtc-cmos driver to avoid
user space access RTC through CMOS interface.

Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
---
 arch/x86/kernel/rtc.c  |   20 ++++++++++++++++----
 drivers/rtc/rtc-cmos.c |    9 +++++++++
 2 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index ca9622a..9b6c568 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -174,16 +174,27 @@ static __init int add_rtc_cmos(void)
 	    { "PNP0b00", "PNP0b01", "PNP0b02", };
 	struct pnp_dev *dev;
 	struct pnp_id *id;
-	int i;
+	int i = 0;
+	bool found_pnp;
 
 	pnp_for_each_dev(dev) {
 		for (id = dev->id; id; id = id->next) {
 			for (i = 0; i < ARRAY_SIZE(ids); i++) {
-				if (compare_pnp_id(id, ids[i]) != 0)
-					return 0;
+				if (compare_pnp_id(id, ids[i]) != 0) {
+					found_pnp = true;
+					goto found_pnp;
+				}
 			}
 		}
 	}
+
+found_pnp:
+	if (found_pnp) {
+		if (acpi_gbl_FADT.header.revision >= 5 &&
+		    acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_CMOS_RTC)
+			pr_err(FW_BUG "Found %s device but CMOS RTC Not Present flag set\n", ids[i]);
+		return 0;
+	}
 #endif
 	if (of_have_populated_dt())
 		return 0;
@@ -193,7 +204,8 @@ static __init int add_rtc_cmos(void)
 		return -ENODEV;
 
 #ifdef CONFIG_ACPI
-	if (acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_CMOS_RTC) {
+	if (acpi_gbl_FADT.header.revision >= 5 &&
+	    acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_CMOS_RTC) {
 		/* This warning can likely go away again in a year or two. */
 		pr_info("ACPI: not registering RTC platform device\n");
 		return -ENODEV;
diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index f148762..3a84ca9 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -28,6 +28,9 @@
  * interrupts disabled, holding the global rtc_lock, to exclude those
  * other drivers and utilities on correctly configured systems.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -1144,6 +1147,12 @@ static int __init cmos_init(void)
 {
 	int retval = 0;
 
+	if (acpi_gbl_FADT.header.revision >= 5 &&
+	    acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_CMOS_RTC) {
+		pr_info("ACPI CMOS RTC Not Present detected - not loading\n");
+		return 0;
+	}
+
 #ifdef	CONFIG_PNP
 	retval = pnp_register_driver(&cmos_pnp_driver);
 	if (retval == 0)
-- 
1.6.4.2
