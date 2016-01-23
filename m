From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v3 01/17] Xen: ACPI: Hide UART used by Xen
Date: Sat, 23 Jan 2016 11:19:28 +0800
Message-ID: <1453519184-11908-2-git-send-email-zhaoshenglong@huawei.com>
References: <1453519184-11908-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1453519184-11908-1-git-send-email-zhaoshenglong@huawei.com>
Sender: linux-acpi-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, mark.rutland@arm.com, stefano.stabellini@citrix.com, david.vrabel@citrix.com
Cc: catalin.marinas@arm.com, will.deacon@arm.com, julien.grall@citrix.com, xen-devel@lists.xen.org, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, ian.campbell@citrix.com, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, "open list:ACPI" <linux-acpi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

From: Shannon Zhao <shannon.zhao@linaro.org>

ACPI 6.0 introduces a new table STAO to list the devices which are used
by Xen and can't be used by Dom0. On Xen virtual platforms, the physical
UART is used by Xen. So here it hides UART from Dom0.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net> (supporter:ACPI)
CC: Len Brown <lenb@kernel.org> (supporter:ACPI)
CC: linux-acpi@vger.kernel.org (open list:ACPI)
---
 drivers/acpi/bus.c | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index a212cef..7f85b54 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -46,6 +46,7 @@ ACPI_MODULE_NAME("bus");
 struct acpi_device *acpi_root;
 struct proc_dir_entry *acpi_root_dir;
 EXPORT_SYMBOL(acpi_root_dir);
+static u64 spcr_uart_addr;
 
 #ifdef CONFIG_X86
 #ifdef CONFIG_ACPI_CUSTOM_DSDT
@@ -105,6 +106,22 @@ acpi_status acpi_bus_get_status_handle(acpi_handle handle,
 	return status;
 }
 
+static bool acpi_check_device_is_ignored(acpi_handle handle)
+{
+	acpi_status status;
+	u64 addr;
+
+	/* Check if it should ignore the UART device */
+	if (spcr_uart_addr != 0) {
+		status = acpi_evaluate_integer(handle, METHOD_NAME__ADR, NULL,
+					       &addr);
+		if (ACPI_SUCCESS(status) && addr == spcr_uart_addr)
+			return true;
+	}
+
+	return false;
+}
+
 int acpi_bus_get_status(struct acpi_device *device)
 {
 	acpi_status status;
@@ -114,7 +131,8 @@ int acpi_bus_get_status(struct acpi_device *device)
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
 
-	acpi_set_device_status(device, sta);
+	if (!acpi_check_device_is_ignored(device->handle))
+		acpi_set_device_status(device, sta);
 
 	if (device->status.functional && !device->status.present) {
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device [%s] status [%08x]: "
@@ -1069,6 +1087,8 @@ EXPORT_SYMBOL_GPL(acpi_kobj);
 static int __init acpi_init(void)
 {
 	int result;
+	acpi_status status;
+	struct acpi_table_stao *stao_ptr;
 
 	if (acpi_disabled) {
 		printk(KERN_INFO PREFIX "Interpreter disabled.\n");
@@ -1081,6 +1101,20 @@ static int __init acpi_init(void)
 		acpi_kobj = NULL;
 	}
 
+	/* If there is STAO table, check whether it needs to ignore the UART
+	 * device in SPCR table.
+	 */
+	status = acpi_get_table(ACPI_SIG_STAO, 0,
+				(struct acpi_table_header **)&stao_ptr);
+	if (ACPI_SUCCESS(status) && stao_ptr->ignore_uart) {
+		struct acpi_table_spcr *spcr_ptr;
+
+		status = acpi_get_table(ACPI_SIG_SPCR, 0,
+					(struct acpi_table_header **)&spcr_ptr);
+		if (ACPI_SUCCESS(status))
+			spcr_uart_addr = spcr_ptr->serial_port.address;
+	}
+
 	init_acpi_device_notify();
 	result = acpi_bus_init();
 	if (result) {
-- 
2.0.4


