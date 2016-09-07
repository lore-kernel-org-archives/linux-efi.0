From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH v2 1/4] ACPI / bus: Make acpi_get_first_physical_node() public
Date: Wed, 7 Sep 2016 12:49:18 +0200
Message-ID: <2ccf03905d16368aabed0619835292b6d7f2c99e.1473242067.git.lukas@wunner.de>
References: <cover.1473242067.git.lukas@wunner.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1473242067.git.lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Noever <andreas.noever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Following the fwnode of a device is currently a one-way road: We provide
ACPI_COMPANION() to obtain the fwnode but there's no (public) method to
do the reverse. Granted, there may be multiple physical_nodes, but often
the first one in the list is sufficient.

A handy function to obtain it was introduced with commit 3b95bd160547
("ACPI: introduce a function to find the first physical device"), but
currently it's only available internally.

We're about to add an EFI Device Path parser which needs this function.
Consider the following device path: ACPI(PNP0A03,0)/PCI(28,2)/PCI(0,0)
The PCI root is encoded as an ACPI device in the path, so the parser
has to find the corresponding ACPI device, then find its physical node,
find the PCI bridge in slot 1c (decimal 28), function 2 below it and
finally find the PCI device in slot 0, function 0.

To this end, make acpi_get_first_physical_node() public.

Cc: Aleksey Makarov <aleksey.makarov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/acpi/internal.h | 1 -
 include/linux/acpi.h    | 7 +++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index 27cc7fe..48e718e 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -113,7 +113,6 @@ bool acpi_device_is_present(struct acpi_device *adev);
 bool acpi_device_is_battery(struct acpi_device *adev);
 bool acpi_device_is_first_physical_node(struct acpi_device *adev,
 					const struct device *dev);
-struct device *acpi_get_first_physical_node(struct acpi_device *adev);
 
 /* --------------------------------------------------------------------------
                      Device Matching and Notification
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 288fac5..8ab6a95 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -85,6 +85,8 @@ static inline const char *acpi_dev_name(struct acpi_device *adev)
 	return dev_name(&adev->dev);
 }
 
+struct device *acpi_get_first_physical_node(struct acpi_device *adev);
+
 enum acpi_irq_model_id {
 	ACPI_IRQ_MODEL_PIC = 0,
 	ACPI_IRQ_MODEL_IOAPIC,
@@ -588,6 +590,11 @@ static inline const char *acpi_dev_name(struct acpi_device *adev)
 	return NULL;
 }
 
+static inline struct device *acpi_get_first_physical_node(struct acpi_device *adev)
+{
+	return NULL;
+}
+
 static inline void early_acpi_table_init(void *data, size_t size) { }
 static inline void acpi_early_init(void) { }
 static inline void acpi_subsystem_init(void) { }
-- 
2.9.3
