From: Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH v3 3/8] acpi: add support for ACPI reconfiguration notifiers
Date: Tue, 14 Jun 2016 18:17:21 +0300
Message-ID: <1465917446-14043-4-git-send-email-octavian.purdila@intel.com>
References: <1465917446-14043-1-git-send-email-octavian.purdila@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1465917446-14043-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Mark Brown <broonie@kernel.org>, Wolfram Sang <wsa@the-dreams.de>
Cc: Joel Becker <jlbec@evilplan.org>, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org, irina.tirdea@intel.com, Octavian Purdila <octavian.purdila@intel.com>
List-Id: linux-efi@vger.kernel.org

Add support for ACPI reconfiguration notifiers to allow subsystems to
react to changes in the ACPI tables that happen after the initial
enumeration. This is similar with the way dynamic device tree
notifications work.

The reconfigure notifications supported for now are device add and
device remove.

Since ACPICA allows only one table notification handler, this patch
makes the table notifier function generic and moves it out of the
sysfs specific code.

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 drivers/acpi/bus.c      |  9 +++++++
 drivers/acpi/internal.h |  3 +++
 drivers/acpi/scan.c     | 68 ++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/acpi/sysfs.c    |  6 ++---
 include/linux/acpi.h    | 18 +++++++++++++
 5 files changed, 99 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 262ca31..97e270e 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -990,6 +990,13 @@ void __init acpi_subsystem_init(void)
 	}
 }
 
+static acpi_status acpi_bus_table_handler(u32 event, void *table, void *context)
+{
+	acpi_scan_table_handler(event, table, context);
+
+	return acpi_sysfs_table_handler(event, table, context);
+}
+
 static int __init acpi_bus_init(void)
 {
 	int result;
@@ -1043,6 +1050,8 @@ static int __init acpi_bus_init(void)
 	 * _PDC control method may load dynamic SSDT tables,
 	 * and we need to install the table handler before that.
 	 */
+	status = acpi_install_table_handler(acpi_bus_table_handler, NULL);
+
 	acpi_sysfs_init();
 
 	acpi_early_processor_set_pdc();
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index 27cc7fe..940218f 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -87,6 +87,9 @@ bool acpi_queue_hotplug_work(struct work_struct *work);
 void acpi_device_hotplug(struct acpi_device *adev, u32 src);
 bool acpi_scan_is_offline(struct acpi_device *adev, bool uevent);
 
+acpi_status acpi_sysfs_table_handler(u32 event, void *table, void *context);
+void acpi_scan_table_handler(u32 event, void *table, void *context);
+
 /* --------------------------------------------------------------------------
                      Device Node Initialization / Removal
    -------------------------------------------------------------------------- */
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 7656ea4..343c105 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -494,6 +494,8 @@ static void acpi_device_del(struct acpi_device *device)
 	device_del(&device->dev);
 }
 
+static BLOCKING_NOTIFIER_HEAD(acpi_reconfig_chain);
+
 static LIST_HEAD(acpi_device_del_list);
 static DEFINE_MUTEX(acpi_device_del_lock);
 
@@ -514,6 +516,9 @@ static void acpi_device_del_work_fn(struct work_struct *work_not_used)
 
 		mutex_unlock(&acpi_device_del_lock);
 
+		blocking_notifier_call_chain(&acpi_reconfig_chain,
+					     ACPI_RECONFIG_DEVICE_REMOVE, adev);
+
 		acpi_device_del(adev);
 		/*
 		 * Drop references to all power resources that might have been
@@ -1676,7 +1681,7 @@ static bool acpi_default_enumeration(struct acpi_device *device)
 	bool is_spi_i2c_slave = false;
 
 	/*
-	 * Do not enemerate SPI/I2C slaves as they will be enuerated by their
+	 * Do not enemerate SPI/I2C slaves as they will be enumerated by their
 	 * respective parents.
 	 */
 	INIT_LIST_HEAD(&resource_list);
@@ -1685,6 +1690,9 @@ static bool acpi_default_enumeration(struct acpi_device *device)
 	acpi_dev_free_resource_list(&resource_list);
 	if (!is_spi_i2c_slave)
 		acpi_create_platform_device(device);
+	else
+		blocking_notifier_call_chain(&acpi_reconfig_chain,
+					     ACPI_RECONFIG_DEVICE_ADD, device);
 	return !is_spi_i2c_slave;
 }
 
@@ -1919,6 +1927,8 @@ static int acpi_bus_scan_fixed(void)
 	return result < 0 ? result : 0;
 }
 
+static bool acpi_scan_initialized;
+
 int __init acpi_scan_init(void)
 {
 	int result;
@@ -1963,6 +1973,8 @@ int __init acpi_scan_init(void)
 
 	acpi_update_all_gpes();
 
+	acpi_scan_initialized = true;
+
  out:
 	mutex_unlock(&acpi_scan_lock);
 	return result;
@@ -2006,3 +2018,57 @@ int __init __acpi_probe_device_table(struct acpi_probe_entry *ap_head, int nr)
 
 	return count;
 }
+
+struct acpi_table_events_work {
+	struct work_struct work;
+	void *table;
+	u32 event;
+};
+
+void acpi_table_events_fn(struct work_struct *work)
+{
+	struct acpi_table_events_work *tew;
+
+	tew = container_of(work, struct acpi_table_events_work, work);
+
+	if (tew->event == ACPI_TABLE_EVENT_LOAD) {
+		acpi_scan_lock_acquire();
+		acpi_bus_scan(ACPI_ROOT_OBJECT);
+		acpi_scan_lock_release();
+	}
+
+	kfree(tew);
+}
+
+void acpi_scan_table_handler(u32 event, void *table, void *context)
+{
+	struct acpi_table_events_work *tew;
+
+	if (!acpi_scan_initialized)
+		return;
+
+	if (event != ACPI_TABLE_EVENT_LOAD)
+		return;
+
+	tew = kmalloc(sizeof(*tew), GFP_KERNEL);
+	if (!tew)
+		return;
+
+	INIT_WORK(&tew->work, acpi_table_events_fn);
+	tew->table = table;
+	tew->event = event;
+
+	schedule_work(&tew->work);
+}
+
+int acpi_reconfig_notifier_register(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_register(&acpi_reconfig_chain, nb);
+}
+EXPORT_SYMBOL(acpi_reconfig_notifier_register);
+
+int acpi_reconfig_notifier_unregister(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_unregister(&acpi_reconfig_chain, nb);
+}
+EXPORT_SYMBOL(acpi_reconfig_notifier_unregister);
diff --git a/drivers/acpi/sysfs.c b/drivers/acpi/sysfs.c
index 4b3a9e2..358165e 100644
--- a/drivers/acpi/sysfs.c
+++ b/drivers/acpi/sysfs.c
@@ -378,8 +378,7 @@ static void acpi_table_attr_init(struct acpi_table_attr *table_attr,
 	return;
 }
 
-static acpi_status
-acpi_sysfs_table_handler(u32 event, void *table, void *context)
+acpi_status acpi_sysfs_table_handler(u32 event, void *table, void *context)
 {
 	struct acpi_table_attr *table_attr;
 
@@ -452,9 +451,8 @@ static int acpi_tables_sysfs_init(void)
 
 	kobject_uevent(tables_kobj, KOBJ_ADD);
 	kobject_uevent(dynamic_tables_kobj, KOBJ_ADD);
-	status = acpi_install_table_handler(acpi_sysfs_table_handler, NULL);
 
-	return ACPI_FAILURE(status) ? -EINVAL : 0;
+	return 0;
 err_dynamic_tables:
 	kobject_put(tables_kobj);
 err:
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 288fac5..d2ad476 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -532,6 +532,14 @@ void acpi_walk_dep_device_list(acpi_handle handle);
 struct platform_device *acpi_create_platform_device(struct acpi_device *);
 #define ACPI_PTR(_ptr)	(_ptr)
 
+enum acpi_reconfig_event  {
+	ACPI_RECONFIG_DEVICE_ADD = 0,
+	ACPI_RECONFIG_DEVICE_REMOVE,
+};
+
+int acpi_reconfig_notifier_register(struct notifier_block *nb);
+int acpi_reconfig_notifier_unregister(struct notifier_block *nb);
+
 #else	/* !CONFIG_ACPI */
 
 #define acpi_disabled 1
@@ -678,6 +686,16 @@ static inline enum dev_dma_attr acpi_get_dma_attr(struct acpi_device *adev)
 
 #define ACPI_PTR(_ptr)	(NULL)
 
+static inline int acpi_reconfig_notifier_register(struct notifier_block *nb)
+{
+	return -EINVAL;
+}
+
+static inline int acpi_reconfig_notifier_unregister(struct notifier_block *nb)
+{
+	return -EINVAL;
+}
+
 #endif	/* !CONFIG_ACPI */
 
 #ifdef CONFIG_ACPI
-- 
2.7.4
