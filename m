From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v1 2/6] mei: Switch to use new generic UUID API
Date: Wed, 19 Jul 2017 21:28:53 +0300
Message-ID: <20170719182857.73693-3-andriy.shevchenko@linux.intel.com>
References: <20170719182857.73693-1-andriy.shevchenko@linux.intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170719182857.73693-1-andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org, sparmaintainer-GLv8BlqOqDDQT0dZR+AlfA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-watchdog-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Cc: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

There are new types and helpers that are supposed to be used in new code.

As a preparation to get rid of legacy types and API functions do
the conversion here.

Cc: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Cc: Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/misc/mei/bus-fixup.c    | 35 +++++++++++++++++++----------------
 drivers/misc/mei/bus.c          | 14 +++++++-------
 drivers/misc/mei/client.c       | 21 ++++++++++-----------
 drivers/misc/mei/client.h       | 12 ++++++------
 drivers/misc/mei/hbm.c          |  2 +-
 drivers/misc/mei/hw.h           |  2 +-
 drivers/misc/mei/main.c         |  2 +-
 drivers/nfc/mei_phy.h           |  5 +++--
 drivers/watchdog/mei_wdt.c      |  5 +++--
 include/linux/mei_cl_bus.h      |  2 +-
 include/linux/mod_devicetable.h |  6 +++---
 include/uapi/linux/mei.h        |  4 +---
 samples/mei/mei-amt-version.c   | 21 +++++++++++++++++----
 13 files changed, 73 insertions(+), 58 deletions(-)

diff --git a/drivers/misc/mei/bus-fixup.c b/drivers/misc/mei/bus-fixup.c
index 0208c4b027c5..9eaac4f2d427 100644
--- a/drivers/misc/mei/bus-fixup.c
+++ b/drivers/misc/mei/bus-fixup.c
@@ -27,21 +27,27 @@
 #include "mei_dev.h"
 #include "client.h"
 
-#define MEI_UUID_NFC_INFO UUID_LE(0xd2de1625, 0x382d, 0x417d, \
-			0x48, 0xa4, 0xef, 0xab, 0xba, 0x8a, 0x12, 0x06)
+#define MEI_UUID_NFC_INFO						\
+	GUID_INIT(0xd2de1625, 0x382d, 0x417d,				\
+		  0x48, 0xa4, 0xef, 0xab, 0xba, 0x8a, 0x12, 0x06)
 
-static const uuid_le mei_nfc_info_guid = MEI_UUID_NFC_INFO;
+static const guid_t mei_nfc_info_guid = MEI_UUID_NFC_INFO;
 
-#define MEI_UUID_NFC_HCI UUID_LE(0x0bb17a78, 0x2a8e, 0x4c50, \
-			0x94, 0xd4, 0x50, 0x26, 0x67, 0x23, 0x77, 0x5c)
+#define MEI_UUID_NFC_HCI						\
+	GUID_INIT(0x0bb17a78, 0x2a8e, 0x4c50,				\
+		  0x94, 0xd4, 0x50, 0x26, 0x67, 0x23, 0x77, 0x5c)
 
-#define MEI_UUID_WD UUID_LE(0x05B79A6F, 0x4628, 0x4D7F, \
-			    0x89, 0x9D, 0xA9, 0x15, 0x14, 0xCB, 0x32, 0xAB)
+#define MEI_UUID_WD							\
+	GUID_INIT(0x05B79A6F, 0x4628, 0x4D7F,				\
+		  0x89, 0x9D, 0xA9, 0x15, 0x14, 0xCB, 0x32, 0xAB)
 
-#define MEI_UUID_MKHIF_FIX UUID_LE(0x55213584, 0x9a29, 0x4916, \
-			0xba, 0xdf, 0xf, 0xb7, 0xed, 0x68, 0x2a, 0xeb)
+#define MEI_UUID_MKHIF_FIX						\
+	GUID_INIT(0x55213584, 0x9a29, 0x4916,				\
+		  0xba, 0xdf, 0x0f, 0xb7, 0xed, 0x68, 0x2a, 0xeb)
 
-#define MEI_UUID_ANY NULL_UUID_LE
+#define MEI_UUID_ANY							\
+	GUID_INIT(0x00000000, 0x0000, 0x0000,				\
+		  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00)
 
 /**
  * number_of_connections - determine whether an client be on the bus
@@ -391,7 +397,7 @@ static void mei_nfc(struct mei_cl_device *cldev)
 
 static struct mei_fixup {
 
-	const uuid_le uuid;
+	const guid_t uuid;
 	void (*hook)(struct mei_cl_device *cldev);
 } mei_fixups[] = {
 	MEI_FIXUP(MEI_UUID_ANY, number_of_connections),
@@ -409,15 +415,12 @@ static struct mei_fixup {
 void mei_cl_bus_dev_fixup(struct mei_cl_device *cldev)
 {
 	struct mei_fixup *f;
-	const uuid_le *uuid = mei_me_cl_uuid(cldev->me_cl);
+	const guid_t *uuid = mei_me_cl_uuid(cldev->me_cl);
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(mei_fixups); i++) {
-
 		f = &mei_fixups[i];
-		if (uuid_le_cmp(f->uuid, MEI_UUID_ANY) == 0 ||
-		    uuid_le_cmp(f->uuid, *uuid) == 0)
+		if (guid_is_null(&f->uuid) || guid_equal(&f->uuid, uuid))
 			f->hook(cldev);
 	}
 }
-
diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 40c79089e548..c5165f2ec842 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -417,7 +417,7 @@ EXPORT_SYMBOL_GPL(mei_cldev_set_drvdata);
  *
  * Return: me client uuid
  */
-const uuid_le *mei_cldev_uuid(const struct mei_cl_device *cldev)
+const guid_t *mei_cldev_uuid(const struct mei_cl_device *cldev)
 {
 	return mei_me_cl_uuid(cldev->me_cl);
 }
@@ -606,7 +606,7 @@ struct mei_cl_device_id *mei_cl_device_find(struct mei_cl_device *cldev,
 					    struct mei_cl_driver *cldrv)
 {
 	const struct mei_cl_device_id *id;
-	const uuid_le *uuid;
+	const guid_t *uuid;
 	u8 version;
 	bool match;
 
@@ -614,8 +614,8 @@ struct mei_cl_device_id *mei_cl_device_find(struct mei_cl_device *cldev,
 	version = mei_me_cl_ver(cldev->me_cl);
 
 	id = cldrv->id_table;
-	while (uuid_le_cmp(NULL_UUID_LE, id->uuid)) {
-		if (!uuid_le_cmp(*uuid, id->uuid)) {
+	while (!guid_is_null(&id->uuid)) {
+		if (guid_equal(uuid, &id->uuid)) {
 			match = true;
 
 			if (cldev->name[0])
@@ -742,7 +742,7 @@ static ssize_t uuid_show(struct device *dev, struct device_attribute *a,
 			     char *buf)
 {
 	struct mei_cl_device *cldev = to_mei_cl_device(dev);
-	const uuid_le *uuid = mei_me_cl_uuid(cldev->me_cl);
+	const guid_t *uuid = mei_me_cl_uuid(cldev->me_cl);
 
 	return scnprintf(buf, PAGE_SIZE, "%pUl", uuid);
 }
@@ -762,7 +762,7 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *a,
 			     char *buf)
 {
 	struct mei_cl_device *cldev = to_mei_cl_device(dev);
-	const uuid_le *uuid = mei_me_cl_uuid(cldev->me_cl);
+	const guid_t *uuid = mei_me_cl_uuid(cldev->me_cl);
 	u8 version = mei_me_cl_ver(cldev->me_cl);
 
 	return scnprintf(buf, PAGE_SIZE, "mei:%s:%pUl:%02X:",
@@ -790,7 +790,7 @@ ATTRIBUTE_GROUPS(mei_cldev);
 static int mei_cl_device_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
 	struct mei_cl_device *cldev = to_mei_cl_device(dev);
-	const uuid_le *uuid = mei_me_cl_uuid(cldev->me_cl);
+	const guid_t *uuid = mei_me_cl_uuid(cldev->me_cl);
 	u8 version = mei_me_cl_ver(cldev->me_cl);
 
 	if (add_uevent_var(env, "MEI_CL_VERSION=%d", version))
diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index be64969d986a..a44fb96452a9 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -139,16 +139,16 @@ void mei_me_cl_add(struct mei_device *dev, struct mei_me_client *me_cl)
  * Locking: dev->me_clients_rwsem
  */
 static struct mei_me_client *__mei_me_cl_by_uuid(struct mei_device *dev,
-					const uuid_le *uuid)
+					const guid_t *uuid)
 {
 	struct mei_me_client *me_cl;
-	const uuid_le *pn;
+	const guid_t *pn;
 
 	WARN_ON(!rwsem_is_locked(&dev->me_clients_rwsem));
 
 	list_for_each_entry(me_cl, &dev->me_clients, list) {
 		pn = &me_cl->props.protocol_name;
-		if (uuid_le_cmp(*uuid, *pn) == 0)
+		if (guid_equal(uuid, pn))
 			return mei_me_cl_get(me_cl);
 	}
 
@@ -167,7 +167,7 @@ static struct mei_me_client *__mei_me_cl_by_uuid(struct mei_device *dev,
  * Locking: dev->me_clients_rwsem
  */
 struct mei_me_client *mei_me_cl_by_uuid(struct mei_device *dev,
-					const uuid_le *uuid)
+					const guid_t *uuid)
 {
 	struct mei_me_client *me_cl;
 
@@ -219,17 +219,16 @@ struct mei_me_client *mei_me_cl_by_id(struct mei_device *dev, u8 client_id)
  * Locking: dev->me_clients_rwsem
  */
 static struct mei_me_client *__mei_me_cl_by_uuid_id(struct mei_device *dev,
-					   const uuid_le *uuid, u8 client_id)
+					   const guid_t *uuid, u8 client_id)
 {
 	struct mei_me_client *me_cl;
-	const uuid_le *pn;
+	const guid_t *pn;
 
 	WARN_ON(!rwsem_is_locked(&dev->me_clients_rwsem));
 
 	list_for_each_entry(me_cl, &dev->me_clients, list) {
 		pn = &me_cl->props.protocol_name;
-		if (uuid_le_cmp(*uuid, *pn) == 0 &&
-		    me_cl->client_id == client_id)
+		if (guid_equal(uuid, pn) && me_cl->client_id == client_id)
 			return mei_me_cl_get(me_cl);
 	}
 
@@ -248,7 +247,7 @@ static struct mei_me_client *__mei_me_cl_by_uuid_id(struct mei_device *dev,
  * Return: me client or null if not found
  */
 struct mei_me_client *mei_me_cl_by_uuid_id(struct mei_device *dev,
-					   const uuid_le *uuid, u8 client_id)
+					   const guid_t *uuid, u8 client_id)
 {
 	struct mei_me_client *me_cl;
 
@@ -267,7 +266,7 @@ struct mei_me_client *mei_me_cl_by_uuid_id(struct mei_device *dev,
  *
  * Locking: called under "dev->device_lock" lock
  */
-void mei_me_cl_rm_by_uuid(struct mei_device *dev, const uuid_le *uuid)
+void mei_me_cl_rm_by_uuid(struct mei_device *dev, const guid_t *uuid)
 {
 	struct mei_me_client *me_cl;
 
@@ -288,7 +287,7 @@ void mei_me_cl_rm_by_uuid(struct mei_device *dev, const uuid_le *uuid)
  *
  * Locking: called under "dev->device_lock" lock
  */
-void mei_me_cl_rm_by_uuid_id(struct mei_device *dev, const uuid_le *uuid, u8 id)
+void mei_me_cl_rm_by_uuid_id(struct mei_device *dev, const guid_t *uuid, u8 id)
 {
 	struct mei_me_client *me_cl;
 
diff --git a/drivers/misc/mei/client.h b/drivers/misc/mei/client.h
index 5371df4d8af3..5d996e1e39fa 100644
--- a/drivers/misc/mei/client.h
+++ b/drivers/misc/mei/client.h
@@ -34,13 +34,13 @@ void mei_me_cl_add(struct mei_device *dev, struct mei_me_client *me_cl);
 void mei_me_cl_del(struct mei_device *dev, struct mei_me_client *me_cl);
 
 struct mei_me_client *mei_me_cl_by_uuid(struct mei_device *dev,
-					const uuid_le *uuid);
+					const guid_t *uuid);
 struct mei_me_client *mei_me_cl_by_id(struct mei_device *dev, u8 client_id);
 struct mei_me_client *mei_me_cl_by_uuid_id(struct mei_device *dev,
-					   const uuid_le *uuid, u8 client_id);
-void mei_me_cl_rm_by_uuid(struct mei_device *dev, const uuid_le *uuid);
+					   const guid_t *uuid, u8 client_id);
+void mei_me_cl_rm_by_uuid(struct mei_device *dev, const guid_t *uuid);
 void mei_me_cl_rm_by_uuid_id(struct mei_device *dev,
-			     const uuid_le *uuid, u8 id);
+			     const guid_t *uuid, u8 id);
 void mei_me_cl_rm_all(struct mei_device *dev);
 
 /**
@@ -62,7 +62,7 @@ static inline bool mei_me_cl_is_active(const struct mei_me_client *me_cl)
  *
  * Return: me client protocol name
  */
-static inline const uuid_le *mei_me_cl_uuid(const struct mei_me_client *me_cl)
+static inline const guid_t *mei_me_cl_uuid(const struct mei_me_client *me_cl)
 {
 	return &me_cl->props.protocol_name;
 }
@@ -177,7 +177,7 @@ static inline bool mei_cl_is_single_recv_buf(const struct mei_cl *cl)
  *
  * Return: return uuid of connected me client
  */
-static inline const uuid_le *mei_cl_uuid(const struct mei_cl *cl)
+static inline const guid_t *mei_cl_uuid(const struct mei_cl *cl)
 {
 	return mei_me_cl_uuid(cl->me_cl);
 }
diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index fe6595fe94f1..059b8dfef67b 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -329,7 +329,7 @@ static int mei_hbm_me_cl_add(struct mei_device *dev,
 			     struct hbm_props_response *res)
 {
 	struct mei_me_client *me_cl;
-	const uuid_le *uuid = &res->client_properties.protocol_name;
+	const guid_t *uuid = &res->client_properties.protocol_name;
 
 	mei_me_cl_rm_by_uuid(dev, uuid);
 
diff --git a/drivers/misc/mei/hw.h b/drivers/misc/mei/hw.h
index 5c8286b40b62..e061f449ea75 100644
--- a/drivers/misc/mei/hw.h
+++ b/drivers/misc/mei/hw.h
@@ -288,7 +288,7 @@ struct hbm_host_enum_response {
 } __packed;
 
 struct mei_client_properties {
-	uuid_le protocol_name;
+	guid_t protocol_name;
 	u8 protocol_version;
 	u8 max_number_of_connections;
 	u8 fixed_address;
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index e825f013e54e..be576c625f9f 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -342,7 +342,7 @@ static int mei_ioctl_connect_client(struct file *file,
 		return  -EBUSY;
 
 	/* find ME client we're trying to connect to */
-	me_cl = mei_me_cl_by_uuid(dev, &data->in_client_uuid);
+	me_cl = mei_me_cl_by_uuid(dev, (guid_t *)&data->in_client_uuid);
 	if (!me_cl) {
 		dev_dbg(dev->dev, "Cannot connect to FW Client UUID = %pUl\n",
 			&data->in_client_uuid);
diff --git a/drivers/nfc/mei_phy.h b/drivers/nfc/mei_phy.h
index acd3a1fc69e6..bf4775a111e8 100644
--- a/drivers/nfc/mei_phy.h
+++ b/drivers/nfc/mei_phy.h
@@ -5,8 +5,9 @@
 #include <net/nfc/hci.h>
 #include <linux/uuid.h>
 
-#define MEI_NFC_UUID UUID_LE(0x0bb17a78, 0x2a8e, 0x4c50, \
-		0x94, 0xd4, 0x50, 0x26, 0x67, 0x23, 0x77, 0x5c)
+#define MEI_NFC_UUID							\
+	GUID_INIT(0x0bb17a78, 0x2a8e, 0x4c50,				\
+		  0x94, 0xd4, 0x50, 0x26, 0x67, 0x23, 0x77, 0x5c)
 #define MEI_NFC_HEADER_SIZE 10
 #define MEI_NFC_MAX_HCI_PAYLOAD 300
 
diff --git a/drivers/watchdog/mei_wdt.c b/drivers/watchdog/mei_wdt.c
index b29c6fde7473..a0f052a96913 100644
--- a/drivers/watchdog/mei_wdt.c
+++ b/drivers/watchdog/mei_wdt.c
@@ -667,8 +667,9 @@ static int mei_wdt_remove(struct mei_cl_device *cldev)
 	return 0;
 }
 
-#define MEI_UUID_WD UUID_LE(0x05B79A6F, 0x4628, 0x4D7F, \
-			    0x89, 0x9D, 0xA9, 0x15, 0x14, 0xCB, 0x32, 0xAB)
+#define MEI_UUID_WD							\
+	GUID_INIT(0x05B79A6F, 0x4628, 0x4D7F,				\
+		  0x89, 0x9D, 0xA9, 0x15, 0x14, 0xCB, 0x32, 0xAB)
 
 static struct mei_cl_device_id mei_wdt_tbl[] = {
 	{ .uuid = MEI_UUID_WD, .version = MEI_CL_VERSION_ANY },
diff --git a/include/linux/mei_cl_bus.h b/include/linux/mei_cl_bus.h
index a0d274fe08f1..81a860bfd076 100644
--- a/include/linux/mei_cl_bus.h
+++ b/include/linux/mei_cl_bus.h
@@ -94,7 +94,7 @@ int mei_cldev_register_rx_cb(struct mei_cl_device *cldev, mei_cldev_cb_t rx_cb);
 int mei_cldev_register_notif_cb(struct mei_cl_device *cldev,
 				mei_cldev_cb_t notif_cb);
 
-const uuid_le *mei_cldev_uuid(const struct mei_cl_device *cldev);
+const guid_t *mei_cldev_uuid(const struct mei_cl_device *cldev);
 u8 mei_cldev_ver(const struct mei_cl_device *cldev);
 
 void *mei_cldev_get_drvdata(const struct mei_cl_device *cldev);
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 3f74ef2281e8..13b403b8cec4 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -627,15 +627,15 @@ struct ipack_device_id {
 /**
  * struct mei_cl_device_id - MEI client device identifier
  * @name: helper name
- * @uuid: client uuid
+ * @uuid: client GUID
  * @version: client protocol version
  * @driver_info: information used by the driver.
  *
- * identifies mei client device by uuid and name
+ * identifies mei client device by GUID and name
  */
 struct mei_cl_device_id {
 	char name[MEI_CL_NAME_SIZE];
-	uuid_le uuid;
+	guid_t uuid;
 	__u8    version;
 	kernel_ulong_t driver_info;
 };
diff --git a/include/uapi/linux/mei.h b/include/uapi/linux/mei.h
index 7c3b64f6a215..cf02d56a13e6 100644
--- a/include/uapi/linux/mei.h
+++ b/include/uapi/linux/mei.h
@@ -67,8 +67,6 @@
 #ifndef _LINUX_MEI_H
 #define _LINUX_MEI_H
 
-#include <linux/uuid.h>
-
 /*
  * This IOCTL is used to associate the current file descriptor with a
  * FW Client (given by UUID). This opens a communication channel
@@ -102,7 +100,7 @@ struct mei_client {
  */
 struct mei_connect_client_data {
 	union {
-		uuid_le in_client_uuid;
+		__u8 in_client_uuid[16];
 		struct mei_client out_client_properties;
 	};
 };
diff --git a/samples/mei/mei-amt-version.c b/samples/mei/mei-amt-version.c
index 57d0d871dcf7..26d85860c838 100644
--- a/samples/mei/mei-amt-version.c
+++ b/samples/mei/mei-amt-version.c
@@ -89,8 +89,20 @@
 	fprintf(stderr, "Error: " fmt, ##ARGS); \
 } while (0)
 
+/* FIXME: Use libuuid instead */
+typedef struct {
+	__u8 b[16];
+} guid_t;
+
+#define GUID_INIT(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)		\
+((guid_t)								\
+{{ (a) & 0xff, ((a) >> 8) & 0xff, ((a) >> 16) & 0xff, ((a) >> 24) & 0xff, \
+   (b) & 0xff, ((b) >> 8) & 0xff,					\
+   (c) & 0xff, ((c) >> 8) & 0xff,					\
+   (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
+
 struct mei {
-	uuid_le guid;
+	guid_t guid;
 	bool initialized;
 	bool verbose;
 	unsigned int buf_size;
@@ -108,7 +120,7 @@ static void mei_deinit(struct mei *cl)
 	cl->initialized = false;
 }
 
-static bool mei_init(struct mei *me, const uuid_le *guid,
+static bool mei_init(struct mei *me, const guid_t *guid,
 		unsigned char req_protocol_version, bool verbose)
 {
 	int result;
@@ -270,8 +282,9 @@ struct amt_host_if_resp_header {
 	unsigned char data[0];
 } __attribute__((packed));
 
-const uuid_le MEI_IAMTHIF = UUID_LE(0x12f80028, 0xb4b7, 0x4b2d,  \
-				0xac, 0xa8, 0x46, 0xe0, 0xff, 0x65, 0x81, 0x4c);
+const guid_t MEI_IAMTHIF =
+	GUID_INIT(0x12f80028, 0xb4b7, 0x4b2d,
+		  0xac, 0xa8, 0x46, 0xe0, 0xff, 0x65, 0x81, 0x4c);
 
 #define AMT_HOST_IF_CODE_VERSIONS_REQUEST  0x0400001A
 #define AMT_HOST_IF_CODE_VERSIONS_RESPONSE 0x0480001A
-- 
2.11.0
