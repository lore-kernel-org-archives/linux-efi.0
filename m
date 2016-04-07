From: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v11 10/17] arm/xen: Get event-channel irq through HVM_PARAM when booting with ACPI
Date: Thu, 7 Apr 2016 20:03:27 +0800
Message-ID: <1460030614-16112-11-git-send-email-zhaoshenglong@huawei.com>
References: <1460030614-16112-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460030614-16112-1-git-send-email-zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, sstabellini-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, julien.grall-5wv7dgnIgG8@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

The kernel will get the event-channel IRQ through
HVM_PARAM_CALLBACK_IRQ.

Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Reviewed-by: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
Reviewed-by: Julien Grall <julien.grall-5wv7dgnIgG8@public.gmane.org>
---
 arch/arm/xen/enlighten.c | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index d94f726..06bd61a 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -30,6 +30,7 @@
 #include <linux/time64.h>
 #include <linux/timekeeping.h>
 #include <linux/timekeeper_internal.h>
+#include <linux/acpi.h>
 
 #include <linux/mm.h>
 
@@ -278,6 +279,35 @@ void __init xen_early_init(void)
 		add_preferred_console("hvc", 0, NULL);
 }
 
+static void __init xen_acpi_guest_init(void)
+{
+#ifdef CONFIG_ACPI
+	struct xen_hvm_param a;
+	int interrupt, trigger, polarity;
+
+	a.domid = DOMID_SELF;
+	a.index = HVM_PARAM_CALLBACK_IRQ;
+
+	if (HYPERVISOR_hvm_op(HVMOP_get_param, &a)
+	    || (a.value >> 56) != HVM_PARAM_CALLBACK_TYPE_PPI) {
+		xen_events_irq = 0;
+		return;
+	}
+
+	interrupt = a.value & 0xff;
+	trigger = ((a.value >> 8) & 0x1) ? ACPI_EDGE_SENSITIVE
+					 : ACPI_LEVEL_SENSITIVE;
+	polarity = ((a.value >> 8) & 0x2) ? ACPI_ACTIVE_LOW
+					  : ACPI_ACTIVE_HIGH;
+	xen_events_irq = acpi_register_gsi(NULL, interrupt, trigger, polarity);
+#endif
+}
+
+static void __init xen_dt_guest_init(void)
+{
+	xen_events_irq = irq_of_parse_and_map(xen_node, 0);
+}
+
 static int __init xen_guest_init(void)
 {
 	struct xen_add_to_physmap xatp;
@@ -286,7 +316,11 @@ static int __init xen_guest_init(void)
 	if (!xen_domain())
 		return 0;
 
-	xen_events_irq = irq_of_parse_and_map(xen_node, 0);
+	if (!acpi_disabled)
+		xen_acpi_guest_init();
+	else
+		xen_dt_guest_init();
+
 	if (!xen_events_irq) {
 		pr_err("Xen event channel interrupt not found\n");
 		return -ENODEV;
-- 
2.0.4
