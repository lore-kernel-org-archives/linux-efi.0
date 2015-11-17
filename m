From: shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Subject: [PATCH 12/13] arm/xen: Get event-channel irq through HVM_PARAM when booting with ACPI
Date: Tue, 17 Nov 2015 17:57:10 +0800
Message-ID: <1447754231-7772-13-git-send-email-shannon.zhao@linaro.org>
References: <1447754231-7772-1-git-send-email-shannon.zhao@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447754231-7772-1-git-send-email-shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hangaohuai-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

When booting with ACPI, it could get the event-channel irq through
HVM_PARAM_CALLBACK_IRQ.

Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm/xen/enlighten.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index 1373d6d..b8e9db8 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -25,6 +25,7 @@
 #include <linux/cpufreq.h>
 #include <linux/cpu.h>
 #include <linux/console.h>
+#include <linux/acpi.h>
 
 #include <linux/mm.h>
 
@@ -190,10 +191,24 @@ static int __init xen_guest_init(void)
 	if (!xen_domain())
 		return 0;
 
-	xen_events_irq = irq_of_parse_and_map(xen_node, 0);
-	if (!xen_events_irq) {
-		pr_err("Xen event channel interrupt not found\n");
-		return -ENODEV;
+	if (!acpi_disabled) {
+		struct xen_hvm_param a;
+
+		a.domid = DOMID_SELF;
+		a.index = HVM_PARAM_CALLBACK_IRQ;
+		if (HYPERVISOR_hvm_op(HVMOP_get_param, &a)) {
+			if ((a.value >> 56) != 3) {
+				pr_err("Can't get Xen event-channel irq\n");
+				return -ENODEV;
+			}
+		}
+		xen_events_irq = a.value & 0xff;
+	} else {
+		xen_events_irq = irq_of_parse_and_map(xen_node, 0);
+		if (!xen_events_irq) {
+			pr_err("Xen event channel interrupt not found\n");
+			return -ENODEV;
+		}
 	}
 
 	shared_info_page = (struct shared_info *)get_zeroed_page(GFP_KERNEL);
-- 
2.1.0
