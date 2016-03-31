From: Octavian Purdila <octavian.purdila@intel.com>
Subject: [RFC PATCH 03/10] acpi: add support for ACPI reconfiguration notifiers
Date: Thu, 31 Mar 2016 12:36:59 +0300
Message-ID: <1459417026-6697-4-git-send-email-octavian.purdila@intel.com>
References: <1459417026-6697-1-git-send-email-octavian.purdila@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459417026-6697-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Mark Brown <broonie@kernel.org>, Wolfram Sang <wsa@the-dreams.de>
Cc: Joel Becker <jlbec@evilplan.org>, Christoph Hellwig <hch@lst.de>, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org, irina.tirdea@intel.com, Octavian Purdila <octavian.purdila@intel.com>
List-Id: linux-efi@vger.kernel.org

Add support for ACPI reconfiguration notifiers to allow subsystems to
react to changes in the ACPI tables that happen after the initial
enumeration. This is similar with the way dynamic device tree
notifications work.

Right now only two reconfigure notifications are supported: table load
and table unload operations. This could be extended with finer grained
notification like ACPI device added or removed in the future.

Since ACPICA allows only one table notification handler, this patch
makes the table notifier function generic and moves it out of the
sysfs specific code.

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 drivers/acpi/bus.c      |  9 +++++++
 drivers/acpi/internal.h |  3 +++
 drivers/acpi/scan.c     | 62 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/sysfs.c    |  6 ++---
 include/acpi/acpi_bus.h |  8 +++++++
 5 files changed, 84 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 5e0d076..09134ed 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -1037,6 +1037,13 @@ void __init acpi_subsystem_init(void)
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
@@ -1078,6 +1085,8 @@ static int __init acpi_bus_init(void)
 	 * _PDC control method may load dynamic SSDT tables,
 	 * and we need to install the table handler before that.
 	 */
+	status = acpi_install_table_handler(acpi_bus_table_handler, NULL);
+
 	acpi_sysfs_init();
 
 	acpi_early_processor_set_pdc();
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index 1e6833a..cd4724f 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -80,6 +80,9 @@ bool acpi_queue_hotplug_work(struct work_struct *work);
 void acpi_device_hotplug(struct acpi_device *adev, u32 src);
 bool acpi_scan_is_offline(struct acpi_device *adev, bool uevent);
 
+acpi_status acpi_sysfs_table_handler(u32 event, void *table, void *context);
+void acpi_scan_table_handler(u32 event, void *table, void *context);
+
 /* --------------------------------------------------------------------------
                      Device Node Initialization / Removal
    -------------------------------------------------------------------------- */
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 407a376..a7e476c 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1916,6 +1916,8 @@ static int acpi_bus_scan_fixed(void)
 	return result < 0 ? result : 0;
 }
 
+static bool acpi_scan_initialized;
+
 int __init acpi_scan_init(void)
 {
 	int result;
@@ -1959,6 +1961,8 @@ int __init acpi_scan_init(void)
 
 	acpi_update_all_gpes();
 
+	acpi_scan_initialized = true;
+
  out:
 	mutex_unlock(&acpi_scan_lock);
 	return result;
@@ -2002,3 +2006,61 @@ int __init __acpi_probe_device_table(struct acpi_probe_entry *ap_head, int nr)
 
 	return count;
 }
+
+static BLOCKING_NOTIFIER_HEAD(acpi_reconfig_chain);
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
+	enum acpi_reconfig_event event;
+
+	tew = container_of(work, struct acpi_table_events_work, work);
+
+	acpi_scan_lock_acquire();
+	acpi_bus_scan(ACPI_ROOT_OBJECT);
+	acpi_scan_lock_release();
+
+	if (tew->event == ACPI_TABLE_EVENT_LOAD)
+		event = ACPI_RECONFIG_TABLE_LOAD;
+	else
+		event = ACPI_RECONFIG_TABLE_UNLOAD;
+
+	blocking_notifier_call_chain(&acpi_reconfig_chain, event, tew->table);
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
index 0243d37..d132d66 100644
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
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 14362a8..2faf183 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -518,6 +518,14 @@ int acpi_match_device_ids(struct acpi_device *device,
 int acpi_create_dir(struct acpi_device *);
 void acpi_remove_dir(struct acpi_device *);
 
+enum acpi_reconfig_event  {
+	ACPI_RECONFIG_TABLE_LOAD = 0,
+	ACPI_RECONFIG_TABLE_UNLOAD,
+};
+
+int acpi_reconfig_notifier_register(struct notifier_block *nb);
+int acpi_reconfig_notifier_unregister(struct notifier_block *nb);
+
 static inline bool acpi_device_enumerated(struct acpi_device *adev)
 {
 	return adev && adev->flags.initialized && adev->flags.visited;
-- 
1.9.1
