From: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v6 01/17] Xen: ACPI: Hide UART used by Xen
Date: Thu, 17 Mar 2016 17:57:00 +0800
Message-ID: <1458208636-12960-2-git-send-email-zhaoshenglong@huawei.com>
References: <1458208636-12960-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1458208636-12960-1-git-send-email-zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org
Cc: catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, julien.grall-5wv7dgnIgG8@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "open list:ACPI" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

ACPI 6.0 introduces a new table STAO to list the devices which are used
by Xen and can't be used by Dom0. On Xen virtual platforms, the physical
UART is used by Xen. So here it hides UART from Dom0.

Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
CC: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org> (supporter:ACPI)
CC: Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> (supporter:ACPI)
CC: linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (open list:ACPI)
---
 drivers/acpi/scan.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 5f28cf7..55ceb69 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -45,6 +45,7 @@ static LIST_HEAD(acpi_scan_handlers_list);
 DEFINE_MUTEX(acpi_device_lock);
 LIST_HEAD(acpi_wakeup_device_list);
 static DEFINE_MUTEX(acpi_hp_context_lock);
+static u64 spcr_uart_addr;
 
 struct acpi_dep_data {
 	struct list_head node;
@@ -1453,6 +1454,41 @@ static int acpi_add_single_object(struct acpi_device **child,
 	return 0;
 }
 
+static acpi_status acpi_get_resource_memory(struct acpi_resource *ares,
+					    void *context)
+{
+	struct resource *res = context;
+
+	if (acpi_dev_resource_memory(ares, res))
+		return AE_CTRL_TERMINATE;
+
+	return AE_OK;
+}
+
+static bool acpi_device_should_be_hidden(acpi_handle handle)
+{
+	acpi_status status;
+	struct resource res;
+
+	/* Check if it should ignore the UART device */
+	if (spcr_uart_addr != 0) {
+		if (!acpi_has_method(handle, METHOD_NAME__CRS))
+			return false;
+
+		status = acpi_walk_resources(handle, METHOD_NAME__CRS,
+					     acpi_get_resource_memory, &res);
+		if (ACPI_FAILURE(status))
+			return false;
+
+		if (res.start == spcr_uart_addr) {
+			printk(KERN_INFO PREFIX "The UART device in SPCR table will be hidden\n");
+			return true;
+		}
+	}
+
+	return false;
+}
+
 static int acpi_bus_type_and_status(acpi_handle handle, int *type,
 				    unsigned long long *sta)
 {
@@ -1466,6 +1502,9 @@ static int acpi_bus_type_and_status(acpi_handle handle, int *type,
 	switch (acpi_type) {
 	case ACPI_TYPE_ANY:		/* for ACPI_ROOT_OBJECT */
 	case ACPI_TYPE_DEVICE:
+		if (acpi_device_should_be_hidden(handle))
+			return -ENODEV;
+
 		*type = ACPI_BUS_TYPE_DEVICE;
 		status = acpi_bus_get_status_handle(handle, sta);
 		if (ACPI_FAILURE(status))
@@ -1919,6 +1958,8 @@ static int acpi_bus_scan_fixed(void)
 int __init acpi_scan_init(void)
 {
 	int result;
+	acpi_status status;
+	struct acpi_table_stao *stao_ptr;
 
 	acpi_pci_root_init();
 	acpi_pci_link_init();
@@ -1934,6 +1975,28 @@ int __init acpi_scan_init(void)
 
 	acpi_scan_add_handler(&generic_device_handler);
 
+	/*
+	 * If there is STAO table, check whether it needs to ignore the UART
+	 * device in SPCR table.
+	 */
+	status = acpi_get_table(ACPI_SIG_STAO, 0,
+				(struct acpi_table_header **)&stao_ptr);
+	if (ACPI_SUCCESS(status)) {
+		if (stao_ptr->header.length > sizeof(struct acpi_table_stao))
+			printk(KERN_INFO PREFIX "STAO Name List not yet supported.");
+
+		if (stao_ptr->ignore_uart) {
+			struct acpi_table_spcr *spcr_ptr;
+
+			status = acpi_get_table(ACPI_SIG_SPCR, 0,
+					(struct acpi_table_header **)&spcr_ptr);
+			if (ACPI_SUCCESS(status))
+				spcr_uart_addr = spcr_ptr->serial_port.address;
+			else
+				printk(KERN_WARNING PREFIX "STAO table present, but SPCR is missing\n");
+		}
+	}
+
 	mutex_lock(&acpi_scan_lock);
 	/*
 	 * Enumerate devices in the ACPI namespace.
-- 
2.0.4
