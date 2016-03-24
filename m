From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: [PATCH v7 01/17] Xen: ACPI: Hide UART used by Xen
Date: Thu, 24 Mar 2016 22:44:20 +0800
Message-ID: <1458830676-27075-2-git-send-email-shannon.zhao@linaro.org>
References: <1458830676-27075-1-git-send-email-shannon.zhao@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1458830676-27075-1-git-send-email-shannon.zhao@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org, stefano.stabellini@citrix.com, david.vrabel@citrix.com
Cc: devicetree@vger.kernel.org, linux-efi@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, peter.huangpeng@huawei.com, "open list:ACPI" <linux-acpi@vger.kernel.org>, julien.grall@arm.com, shannon.zhao@linaro.org, zhaoshenglong@huawei.com, xen-devel@lists.xen.org, Len Brown <lenb@kernel.org>
List-Id: linux-efi@vger.kernel.org

ACPI 6.0 introduces a new table STAO to list the devices which are used
by Xen and can't be used by Dom0. On Xen virtual platforms, the physical
UART is used by Xen. So here it hides UART from Dom0.

CC: "Rafael J. Wysocki" <rjw@rjwysocki.net> (supporter:ACPI)
CC: Len Brown <lenb@kernel.org> (supporter:ACPI)
CC: linux-acpi@vger.kernel.org (open list:ACPI)
Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 drivers/acpi/scan.c | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 5f28cf7..e96a058 100644
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
@@ -1916,9 +1955,24 @@ static int acpi_bus_scan_fixed(void)
 	return result < 0 ? result : 0;
 }
 
+static void acpi_get_spcr_uart_addr(void)
+{
+	acpi_status status;
+	struct acpi_table_spcr *spcr_ptr;
+
+	status = acpi_get_table(ACPI_SIG_SPCR, 0,
+				(struct acpi_table_header **)&spcr_ptr);
+	if (ACPI_SUCCESS(status))
+		spcr_uart_addr = spcr_ptr->serial_port.address;
+	else
+		printk(KERN_WARNING PREFIX "STAO table present, but SPCR is missing\n");
+}
+
 int __init acpi_scan_init(void)
 {
 	int result;
+	acpi_status status;
+	struct acpi_table_stao *stao_ptr;
 
 	acpi_pci_root_init();
 	acpi_pci_link_init();
@@ -1934,6 +1988,20 @@ int __init acpi_scan_init(void)
 
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
+		if (stao_ptr->ignore_uart)
+			acpi_get_spcr_uart_addr();
+	}
+
 	mutex_lock(&acpi_scan_lock);
 	/*
 	 * Enumerate devices in the ACPI namespace.
-- 
2.1.4
