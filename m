From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 3/6] staging: unisys: Switch to use new generic UUID API
Date: Wed, 19 Jul 2017 21:28:54 +0300
Message-ID: <20170719182857.73693-4-andriy.shevchenko@linux.intel.com>
References: <20170719182857.73693-1-andriy.shevchenko@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170719182857.73693-1-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-acpi@vger.kernel.org, devel@linuxdriverproject.org, sparmaintainer@unisys.com, devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org, linux-watchdog@vger.kernel.org, linux-efi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, Lukas Wunner <lukas@wunner.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, David Kershner <david.kershner@unisys.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-efi@vger.kernel.org

There are new types and helpers that are supposed to be used in new code.

As a preparation to get rid of legacy types and API functions do
the conversion here.

While here, re-indent couple of lines to increase readability.

Cc: David Kershner <david.kershner@unisys.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: sparmaintainer@unisys.com
Cc: devel@driverdev.osuosl.org
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/staging/unisys/Documentation/overview.txt  | 14 +++----
 drivers/staging/unisys/include/channel.h           | 45 ++++++++++----------
 drivers/staging/unisys/include/iochannel.h         | 14 +------
 drivers/staging/unisys/include/visorbus.h          | 12 +++---
 drivers/staging/unisys/visorbus/controlvmchannel.h | 24 ++++-------
 drivers/staging/unisys/visorbus/vbuschannel.h      |  7 ++--
 drivers/staging/unisys/visorbus/visorbus_main.c    | 28 ++++++-------
 drivers/staging/unisys/visorbus/visorbus_private.h |  6 +--
 drivers/staging/unisys/visorbus/visorchannel.c     | 48 +++++++++++-----------
 drivers/staging/unisys/visorbus/visorchipset.c     | 39 ++++++++++--------
 drivers/staging/unisys/visorhba/visorhba_main.c    |  6 +--
 drivers/staging/unisys/visorinput/visorinput.c     | 38 ++++++++---------
 drivers/staging/unisys/visornic/visornic_main.c    |  6 +--
 13 files changed, 135 insertions(+), 152 deletions(-)

diff --git a/drivers/staging/unisys/Documentation/overview.txt b/drivers/staging/unisys/Documentation/overview.txt
index e0466bfada2f..9ab30af265a5 100644
--- a/drivers/staging/unisys/Documentation/overview.txt
+++ b/drivers/staging/unisys/Documentation/overview.txt
@@ -221,7 +221,7 @@ The following files exist under /sys/devices/visorbus<x>/vbus<x>:dev<y>:
 
 The visorhba driver registers with visorbus as the function driver to
 handle virtual scsi disk devices, specified using the
-VISOR_VHBA_CHANNEL_UUID type in the visorbus_register_visor_driver()
+VISOR_VHBA_CHANNEL_GUID type in the visorbus_register_visor_driver()
 call. visorhba uses scsi_add_host() to expose a Linux block device
 (e.g., /sys/block/) in the guest environment for each s-Par virtual device.
 
@@ -240,7 +240,7 @@ When compiled as a module, visorhba can be autoloaded by visorbus in
 standard udev/systemd environments, as it includes the modules.alias
 definition:
 
-    "visorbus:"+VISOR_VHBA_CHANNEL_UUID_STR
+    "visorbus:"+VISOR_VHBA_CHANNEL_GUID_STR
 
 i.e.:
 
@@ -252,7 +252,7 @@ i.e.:
 
 The visornic driver registers with visorbus as the function driver to
 handle virtual network devices, specified using the
-VISOR_VNIC_CHANNEL_UUID type in the visorbus_register_visor_driver()
+VISOR_VNIC_CHANNEL_GUID type in the visorbus_register_visor_driver()
 call. visornic uses register_netdev() to expose a Linux device of class net
 (e.g., /sys/class/net/) in the guest environment for each s-Par virtual
 device.
@@ -270,7 +270,7 @@ When compiled as a module, visornic can be autoloaded by visorbus in
 standard udev/systemd environments, as it includes the modules.alias
 definition:
 
-    "visorbus:"+VISOR_VNIC_CHANNEL_UUID_STR
+    "visorbus:"+VISOR_VNIC_CHANNEL_GUID_STR
 
 i.e.:
 
@@ -282,7 +282,7 @@ i.e.:
 
 The visorinput driver registers with visorbus as the function driver to
 handle human input devices, specified using the
-VISOR_KEYBOARD_CHANNEL_UUID and VISOR_MOUSE_CHANNEL_UUID
+VISOR_KEYBOARD_CHANNEL_GUID and VISOR_MOUSE_CHANNEL_GUID
 types in the visorbus_register_visor_driver() call. visorinput uses
 input_register_device() to expose devices of class input
 (e.g., /sys/class/input/) for virtual keyboard and virtual mouse devices.
@@ -307,8 +307,8 @@ When compiled as a module, visorinput can be autoloaded by visorbus in
 standard udev/systemd environments, as it includes the modules.alias
 definition:
 
-    "visorbus:"+VISOR_MOUSE_CHANNEL_UUID_STR
-    "visorbus:"+VISOR_KEYBOARD_CHANNEL_UUID_STR
+    "visorbus:"+VISOR_MOUSE_CHANNEL_GUID_STR
+    "visorbus:"+VISOR_KEYBOARD_CHANNEL_GUID_STR
 
 i.e.:
 
diff --git a/drivers/staging/unisys/include/channel.h b/drivers/staging/unisys/include/channel.h
index 692efcb38245..b09b1f55a6f1 100644
--- a/drivers/staging/unisys/include/channel.h
+++ b/drivers/staging/unisys/include/channel.h
@@ -116,13 +116,13 @@ struct channel_header {
 	u32 header_size;	/* sizeof(struct channel_header) */
 	u64 size;		/* Total size of this channel in bytes */
 	u64 features;		/* Flags to modify behavior */
-	uuid_le chtype;		/* Channel type: data, bus, control, etc. */
+	guid_t chtype;		/* Channel type: data, bus, control, etc. */
 	u64 partition_handle;	/* ID of guest partition */
 	u64 handle;		/* Device number of this channel in client */
 	u64 ch_space_offset;	/* Offset in bytes to channel specific area */
 	u32 version_id;		/* struct channel_header Version ID */
 	u32 partition_index;	/* Index of guest partition */
-	uuid_le zone_uuid;	/* Guid of Channel's zone */
+	guid_t zone_guid;	/* Guid of Channel's zone */
 	u32 cli_str_offset;	/* offset from channel header to
 				 * nul-terminated ClientString (0 if
 				 * ClientString not present)
@@ -205,25 +205,25 @@ struct signal_queue_header {
  */
 static inline int
 visor_check_channel(struct channel_header *ch,
-		    uuid_le expected_uuid,
+		    const guid_t *expected_guid,
 		    char *chname,
 		    u64 expected_min_bytes,
 		    u32 expected_version,
 		    u64 expected_signature)
 {
-	if (uuid_le_cmp(expected_uuid, NULL_UUID_LE) != 0) {
+	if (!guid_is_null(expected_guid)) {
 		/* caller wants us to verify type GUID */
-		if (uuid_le_cmp(ch->chtype, expected_uuid) != 0) {
+		if (!guid_equal(&ch->chtype, expected_guid)) {
 			pr_err("Channel mismatch on channel=%s(%pUL) field=type expected=%pUL actual=%pUL\n",
-			       chname, &expected_uuid,
-			       &expected_uuid, &ch->chtype);
+			       chname, expected_guid,
+			       expected_guid, &ch->chtype);
 			return 0;
 		}
 	}
 	if (expected_min_bytes > 0) {	/* verify channel size */
 		if (ch->size < expected_min_bytes) {
 			pr_err("Channel mismatch on channel=%s(%pUL) field=size expected=0x%-8.8Lx actual=0x%-8.8Lx\n",
-			       chname, &expected_uuid,
+			       chname, expected_guid,
 			       (unsigned long long)expected_min_bytes,
 			       ch->size);
 			return 0;
@@ -232,7 +232,7 @@ visor_check_channel(struct channel_header *ch,
 	if (expected_version > 0) {	/* verify channel version */
 		if (ch->version_id != expected_version) {
 			pr_err("Channel mismatch on channel=%s(%pUL) field=version expected=0x%-8.8lx actual=0x%-8.8x\n",
-			       chname, &expected_uuid,
+			       chname, expected_guid,
 			       (unsigned long)expected_version,
 			       ch->version_id);
 			return 0;
@@ -241,7 +241,7 @@ visor_check_channel(struct channel_header *ch,
 	if (expected_signature > 0) {	/* verify channel signature */
 		if (ch->signature != expected_signature) {
 			pr_err("Channel mismatch on channel=%s(%pUL) field=signature expected=0x%-8.8Lx actual=0x%-8.8Lx\n",
-			       chname, &expected_uuid,
+			       chname, expected_guid,
 			       expected_signature, ch->signature);
 			return 0;
 		}
@@ -254,25 +254,22 @@ visor_check_channel(struct channel_header *ch,
  */
 
 /* {414815ed-c58c-11da-95a9-00e08161165f} */
-#define VISOR_VHBA_CHANNEL_UUID \
-	UUID_LE(0x414815ed, 0xc58c, 0x11da, \
-		0x95, 0xa9, 0x0, 0xe0, 0x81, 0x61, 0x16, 0x5f)
-static const uuid_le visor_vhba_channel_uuid = VISOR_VHBA_CHANNEL_UUID;
-#define VISOR_VHBA_CHANNEL_UUID_STR \
+#define VISOR_VHBA_CHANNEL_GUID \
+	GUID_INIT(0x414815ed, 0xc58c, 0x11da, \
+		  0x95, 0xa9, 0x0, 0xe0, 0x81, 0x61, 0x16, 0x5f)
+#define VISOR_VHBA_CHANNEL_GUID_STR \
 	"414815ed-c58c-11da-95a9-00e08161165f"
 
 /* {8cd5994d-c58e-11da-95a9-00e08161165f} */
-#define VISOR_VNIC_CHANNEL_UUID \
-	UUID_LE(0x8cd5994d, 0xc58e, 0x11da, \
-		0x95, 0xa9, 0x0, 0xe0, 0x81, 0x61, 0x16, 0x5f)
-static const uuid_le visor_vnic_channel_uuid = VISOR_VNIC_CHANNEL_UUID;
-#define VISOR_VNIC_CHANNEL_UUID_STR \
+#define VISOR_VNIC_CHANNEL_GUID \
+	GUID_INIT(0x8cd5994d, 0xc58e, 0x11da, \
+		  0x95, 0xa9, 0x0, 0xe0, 0x81, 0x61, 0x16, 0x5f)
+#define VISOR_VNIC_CHANNEL_GUID_STR \
 	"8cd5994d-c58e-11da-95a9-00e08161165f"
 
 /* {72120008-4AAB-11DC-8530-444553544200} */
-#define VISOR_SIOVM_UUID \
-	UUID_LE(0x72120008, 0x4AAB, 0x11DC, \
-		0x85, 0x30, 0x44, 0x45, 0x53, 0x54, 0x42, 0x00)
-static const uuid_le visor_siovm_uuid = VISOR_SIOVM_UUID;
+#define VISOR_SIOVM_GUID \
+	GUID_INIT(0x72120008, 0x4AAB, 0x11DC, \
+		  0x85, 0x30, 0x44, 0x45, 0x53, 0x54, 0x42, 0x00)
 
 #endif
diff --git a/drivers/staging/unisys/include/iochannel.h b/drivers/staging/unisys/include/iochannel.h
index c7cb3fbde7b2..8f05bdd5197c 100644
--- a/drivers/staging/unisys/include/iochannel.h
+++ b/drivers/staging/unisys/include/iochannel.h
@@ -49,18 +49,6 @@
 #define VISOR_VNIC_CHANNEL_VERSIONID 2
 #define VISOR_VSWITCH_CHANNEL_VERSIONID 1
 
-#define VISOR_VHBA_CHANNEL_OK_CLIENT(ch) \
-	(visor_check_channel(ch, visor_vhba_channel_uuid, \
-			     "vhba", MIN_IO_CHANNEL_SIZE, \
-			     VISOR_VHBA_CHANNEL_VERSIONID, \
-			     VISOR_VHBA_CHANNEL_SIGNATURE))
-
-#define VISOR_VNIC_CHANNEL_OK_CLIENT(ch) \
-	(visor_check_channel(ch, visor_vnic_channel_uuid, \
-			     "vnic", MIN_IO_CHANNEL_SIZE, \
-			     VISOR_VNIC_CHANNEL_VERSIONID, \
-			     VISOR_VNIC_CHANNEL_SIGNATURE))
-
 /*
  * Everything necessary to handle SCSI & NIC traffic between Guest Partition and
  * IO Partition is defined below.
@@ -522,7 +510,7 @@ struct iochannel_vnic {
 	u8 macaddr[6];			/* 6 bytes */
 	u32 num_rcv_bufs;		/* 4 bytes */
 	u32 mtu;			/* 4 bytes */
-	uuid_le zone_uuid;		/* 16 bytes */
+	guid_t zone_guid;		/* 16 bytes */
 } __packed;
 /*
  * This is just the header of the IO channel. It is assumed that directly after
diff --git a/drivers/staging/unisys/include/visorbus.h b/drivers/staging/unisys/include/visorbus.h
index de0635542fbd..38ce0878c55e 100644
--- a/drivers/staging/unisys/include/visorbus.h
+++ b/drivers/staging/unisys/include/visorbus.h
@@ -58,7 +58,7 @@ struct visorchipset_state {
  *  GUID, name, and sizes.
  */
 struct visor_channeltype_descriptor {
-	const uuid_le guid;
+	const guid_t guid;
 	const char *name;
 };
 
@@ -141,14 +141,14 @@ struct visor_driver {
  *				hypervisor requests.
  * @vbus_hdr_info:		A pointer to header info. Private use by bus
  *				driver.
- * @partition_uuid:		Indicates client partion id. This should be the
+ * @partition_guid:		Indicates client partion id. This should be the
  *				same across all visor_devices in the current
  *				guest. Private use by bus driver only.
  */
 
 struct visor_device {
 	struct visorchannel *visorchannel;
-	uuid_le channel_type_guid;
+	guid_t channel_type_guid;
 	/* These fields are for private use by the bus driver only. */
 	struct device device;
 	struct list_head list_all;
@@ -161,11 +161,11 @@ struct visor_device {
 	u32 chipset_bus_no;
 	u32 chipset_dev_no;
 	struct visorchipset_state state;
-	uuid_le inst;
+	guid_t inst;
 	u8 *name;
 	struct controlvm_message_header *pending_msg_hdr;
 	void *vbus_hdr_info;
-	uuid_le partition_uuid;
+	guid_t partition_guid;
 	struct dentry *debugfs_dir;
 	struct dentry *debugfs_client_bus_info;
 };
@@ -207,7 +207,7 @@ int visorchannel_signalremove(struct visorchannel *channel, u32 queue,
 int visorchannel_signalinsert(struct visorchannel *channel, u32 queue,
 			      void *msg);
 bool visorchannel_signalempty(struct visorchannel *channel, u32 queue);
-uuid_le visorchannel_get_uuid(struct visorchannel *channel);
+const guid_t *visorchannel_get_guid(struct visorchannel *channel);
 
 #define BUS_ROOT_DEVICE UINT_MAX
 struct visor_device *visorbus_get_device_by_id(u32 bus_no, u32 dev_no,
diff --git a/drivers/staging/unisys/visorbus/controlvmchannel.h b/drivers/staging/unisys/visorbus/controlvmchannel.h
index ed045eff0e33..d9d7628aff50 100644
--- a/drivers/staging/unisys/visorbus/controlvmchannel.h
+++ b/drivers/staging/unisys/visorbus/controlvmchannel.h
@@ -19,9 +19,9 @@
 #include "channel.h"
 
 /* {2B3C2D10-7EF5-4ad8-B966-3448B7386B3D} */
-#define VISOR_CONTROLVM_CHANNEL_UUID \
-	UUID_LE(0x2b3c2d10, 0x7ef5, 0x4ad8, \
-		0xb9, 0x66, 0x34, 0x48, 0xb7, 0x38, 0x6b, 0x3d)
+#define VISOR_CONTROLVM_CHANNEL_GUID \
+	GUID_INIT(0x2b3c2d10, 0x7ef5, 0x4ad8, \
+		  0xb9, 0x66, 0x34, 0x48, 0xb7, 0x38, 0x6b, 0x3d)
 
 #define VISOR_CONTROLVM_CHANNEL_SIGNATURE VISOR_CHANNEL_SIGNATURE
 #define CONTROLVM_MESSAGE_MAX 64
@@ -34,14 +34,6 @@
  */
 #define VISOR_CONTROLVM_CHANNEL_VERSIONID 1
 
-#define VISOR_CONTROLVM_CHANNEL_OK_CLIENT(ch) \
-	(visor_check_channel(ch, \
-			     VISOR_CONTROLVM_CHANNEL_UUID, \
-			     "controlvm", \
-			     sizeof(struct visor_controlvm_channel), \
-			     VISOR_CONTROLVM_CHANNEL_VERSIONID, \
-			     VISOR_CONTROLVM_CHANNEL_SIGNATURE))
-
 /* Defines for various channel queues */
 #define CONTROLVM_QUEUE_REQUEST	 0
 #define CONTROLVM_QUEUE_RESPONSE 1
@@ -222,8 +214,8 @@ struct controlvm_packet_device_create  {
 	 */
 	u64 channel_addr;
 	u64 channel_bytes;	/* specifies size of the channel in bytes */
-	uuid_le data_type_uuid;	/* specifies format of data in channel */
-	uuid_le dev_inst_uuid;	/* instance guid for the device */
+	guid_t data_type_guid;	/* specifies format of data in channel */
+	guid_t dev_inst_guid;	/* instance guid for the device */
 	struct irq_info intr;	/* specifies interrupt information */
 } __packed;	/* for CONTROLVM_DEVICE_CREATE */
 
@@ -258,8 +250,8 @@ struct controlvm_message_packet  {
 			u64 channel_addr;
 			u64 channel_bytes;	/* size of the channel */
 	/* indicates format of data in bus channel*/
-			uuid_le bus_data_type_uuid;
-			uuid_le bus_inst_uuid;	/* instance uuid for the bus */
+			guid_t bus_data_type_guid;
+			guid_t bus_inst_guid;	/* instance GUID for the bus */
 		} __packed create_bus;	/* for CONTROLVM_BUS_CREATE */
 		struct  {
 	/* bus # (0..n-1) from the msg receiver's perspective */
@@ -455,7 +447,7 @@ struct visor_controlvm_parameters_header {
 	u32 client_length;
 	u32 name_offset;
 	u32 name_length;
-	uuid_le id;
+	guid_t id;
 	u32 revision;
 	u32 reserved;		/* Natural alignment */
 } __packed;
diff --git a/drivers/staging/unisys/visorbus/vbuschannel.h b/drivers/staging/unisys/visorbus/vbuschannel.h
index 01d7d517dba7..8f256dbf7ad2 100644
--- a/drivers/staging/unisys/visorbus/vbuschannel.h
+++ b/drivers/staging/unisys/visorbus/vbuschannel.h
@@ -27,10 +27,9 @@
 #include "channel.h"
 
 /* {193b331b-c58f-11da-95a9-00e08161165f} */
-#define VISOR_VBUS_CHANNEL_UUID \
-	UUID_LE(0x193b331b, 0xc58f, 0x11da, \
-		0x95, 0xa9, 0x0, 0xe0, 0x81, 0x61, 0x16, 0x5f)
-static const uuid_le visor_vbus_channel_uuid = VISOR_VBUS_CHANNEL_UUID;
+#define VISOR_VBUS_CHANNEL_GUID \
+	GUID_INIT(0x193b331b, 0xc58f, 0x11da, \
+		  0x95, 0xa9, 0x0, 0xe0, 0x81, 0x61, 0x16, 0x5f)
 
 #define VISOR_VBUS_CHANNEL_SIGNATURE VISOR_CHANNEL_SIGNATURE
 
diff --git a/drivers/staging/unisys/visorbus/visorbus_main.c b/drivers/staging/unisys/visorbus/visorbus_main.c
index 1c785dd19ddd..dd932e39607b 100644
--- a/drivers/staging/unisys/visorbus/visorbus_main.c
+++ b/drivers/staging/unisys/visorbus/visorbus_main.c
@@ -20,6 +20,8 @@
 #include "visorbus.h"
 #include "visorbus_private.h"
 
+static const guid_t visor_vbus_channel_guid = VISOR_VBUS_CHANNEL_GUID;
+
 #define MYDRVNAME "visorbus"
 
 /* Display string that is guaranteed to be no longer the 99 characters*/
@@ -40,11 +42,11 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 			     char *buf)
 {
 	struct visor_device *vdev;
-	uuid_le guid;
+	const guid_t *guid;
 
 	vdev = to_visor_device(dev);
-	guid = visorchannel_get_uuid(vdev->visorchannel);
-	return sprintf(buf, "visorbus:%pUl\n", &guid);
+	guid = visorchannel_get_guid(vdev->visorchannel);
+	return sprintf(buf, "visorbus:%pUl\n", guid);
 }
 static DEVICE_ATTR_RO(modalias);
 
@@ -77,12 +79,12 @@ static int
 visorbus_uevent(struct device *xdev, struct kobj_uevent_env *env)
 {
 	struct visor_device *dev;
-	uuid_le guid;
+	const guid_t *guid;
 
 	dev = to_visor_device(xdev);
-	guid = visorchannel_get_uuid(dev->visorchannel);
+	guid = visorchannel_get_guid(dev->visorchannel);
 
-	return add_uevent_var(env, "MODALIAS=visorbus:%pUl", &guid);
+	return add_uevent_var(env, "MODALIAS=visorbus:%pUl", guid);
 }
 
 /*
@@ -97,24 +99,22 @@ visorbus_uevent(struct device *xdev, struct kobj_uevent_env *env)
 static int
 visorbus_match(struct device *xdev, struct device_driver *xdrv)
 {
-	uuid_le channel_type;
+	const guid_t *channel_type;
 	int i;
 	struct visor_device *dev;
 	struct visor_driver *drv;
 
 	dev = to_visor_device(xdev);
 	drv = to_visor_driver(xdrv);
-	channel_type = visorchannel_get_uuid(dev->visorchannel);
+	channel_type = visorchannel_get_guid(dev->visorchannel);
 
 	if (!drv->channel_types)
 		return 0;
 
 	for (i = 0;
-	     (uuid_le_cmp(drv->channel_types[i].guid, NULL_UUID_LE) != 0) ||
-	     (drv->channel_types[i].name);
+	     !guid_is_null(&drv->channel_types[i].guid) || drv->channel_types[i].name;
 	     i++)
-		if (uuid_le_cmp(drv->channel_types[i].guid,
-				channel_type) == 0)
+		if (guid_equal(&drv->channel_types[i].guid, channel_type))
 			return i + 1;
 
 	return 0;
@@ -283,7 +283,7 @@ static ssize_t partition_guid_show(struct device *dev,
 				   char *buf) {
 	struct visor_device *vdev = to_visor_device(dev);
 
-	return sprintf(buf, "{%pUb}\n", &vdev->partition_uuid);
+	return sprintf(buf, "{%pUb}\n", &vdev->partition_guid);
 }
 static DEVICE_ATTR_RO(partition_guid);
 
@@ -687,7 +687,7 @@ get_vbus_header_info(struct visorchannel *chan,
 	int err;
 
 	if (!visor_check_channel(visorchannel_get_header(chan),
-				 visor_vbus_channel_uuid,
+				 &visor_vbus_channel_guid,
 				 "vbus",
 				 sizeof(struct visor_vbus_channel),
 				 VISOR_VBUS_CHANNEL_VERSIONID,
diff --git a/drivers/staging/unisys/visorbus/visorbus_private.h b/drivers/staging/unisys/visorbus/visorbus_private.h
index 98a5af19189d..0856179338df 100644
--- a/drivers/staging/unisys/visorbus/visorbus_private.h
+++ b/drivers/staging/unisys/visorbus/visorbus_private.h
@@ -48,10 +48,10 @@ void visorbus_exit(void);
 
 struct visorchannel *visorchannel_create(u64 physaddr,
 					 unsigned long channel_bytes,
-					 gfp_t gfp, uuid_le guid);
+					 gfp_t gfp, const guid_t *guid);
 struct visorchannel *visorchannel_create_with_lock(u64 physaddr,
 						   unsigned long channel_bytes,
-						   gfp_t gfp, uuid_le guid);
+						   gfp_t gfp, const guid_t *guid);
 void visorchannel_destroy(struct visorchannel *channel);
 int visorchannel_read(struct visorchannel *channel, ulong offset,
 		      void *dest, ulong nbytes);
@@ -64,6 +64,6 @@ char *visorchannel_zoneid(struct visorchannel *channel, char *s);
 u64 visorchannel_get_clientpartition(struct visorchannel *channel);
 int visorchannel_set_clientpartition(struct visorchannel *channel,
 				     u64 partition_handle);
-char *visorchannel_uuid_id(uuid_le *guid, char *s);
+char *visorchannel_guid_id(const guid_t *guid, char *s);
 void *visorchannel_get_header(struct visorchannel *channel);
 #endif
diff --git a/drivers/staging/unisys/visorbus/visorchannel.c b/drivers/staging/unisys/visorbus/visorchannel.c
index 6885c2cb7135..fd64be952628 100644
--- a/drivers/staging/unisys/visorbus/visorchannel.c
+++ b/drivers/staging/unisys/visorbus/visorchannel.c
@@ -29,10 +29,10 @@
 #define MYDRVNAME "visorchannel"
 
 #define VISOR_CONSOLEVIDEO_CHANNEL_GUID \
-	UUID_LE(0x3cd6e705, 0xd6a2, 0x4aa5, \
-		0xad, 0x5c, 0x7b, 0x8, 0x88, 0x9d, 0xff, 0xe2)
+	GUID_INIT(0x3cd6e705, 0xd6a2, 0x4aa5, \
+		  0xad, 0x5c, 0x7b, 0x8, 0x88, 0x9d, 0xff, 0xe2)
 
-static const uuid_le visor_video_guid = VISOR_CONSOLEVIDEO_CHANNEL_GUID;
+static const guid_t visor_video_guid = VISOR_CONSOLEVIDEO_CHANNEL_GUID;
 
 struct visorchannel {
 	u64 physaddr;
@@ -40,14 +40,14 @@ struct visorchannel {
 	void *mapped;
 	bool requested;
 	struct channel_header chan_hdr;
-	uuid_le guid;
+	guid_t guid;
 	bool needs_lock;	/* channel creator knows if more than one */
 				/* thread will be inserting or removing */
 	spinlock_t insert_lock; /* protect head writes in chan_hdr */
 	spinlock_t remove_lock;	/* protect tail writes in chan_hdr */
 
-	uuid_le type;
-	uuid_le inst;
+	guid_t type;
+	guid_t inst;
 };
 
 void
@@ -76,7 +76,7 @@ visorchannel_get_nbytes(struct visorchannel *channel)
 }
 
 char *
-visorchannel_uuid_id(uuid_le *guid, char *s)
+visorchannel_guid_id(const guid_t *guid, char *s)
 {
 	sprintf(s, "%pUL", guid);
 	return s;
@@ -85,13 +85,13 @@ visorchannel_uuid_id(uuid_le *guid, char *s)
 char *
 visorchannel_id(struct visorchannel *channel, char *s)
 {
-	return visorchannel_uuid_id(&channel->guid, s);
+	return visorchannel_guid_id(&channel->guid, s);
 }
 
 char *
 visorchannel_zoneid(struct visorchannel *channel, char *s)
 {
-	return visorchannel_uuid_id(&channel->chan_hdr.zone_uuid, s);
+	return visorchannel_guid_id(&channel->chan_hdr.zone_guid, s);
 }
 
 u64
@@ -109,17 +109,17 @@ visorchannel_set_clientpartition(struct visorchannel *channel,
 }
 
 /**
- * visorchannel_get_uuid() - queries the UUID of the designated channel
+ * visorchannel_get_guid() - queries the GUID of the designated channel
  * @channel: the channel to query
  *
- * Return: the UUID of the provided channel
+ * Return: the GUID of the provided channel
  */
-uuid_le
-visorchannel_get_uuid(struct visorchannel *channel)
+const guid_t *
+visorchannel_get_guid(struct visorchannel *channel)
 {
-	return channel->guid;
+	return &channel->guid;
 }
-EXPORT_SYMBOL_GPL(visorchannel_get_uuid);
+EXPORT_SYMBOL_GPL(visorchannel_get_guid);
 
 int
 visorchannel_read(struct visorchannel *channel, ulong offset,
@@ -376,7 +376,7 @@ signalinsert_inner(struct visorchannel *channel, u32 queue, void *msg)
  *                 back-end), in which case the actual channel size will be
  *                 read from the channel header in memory
  * @gfp:           gfp_t to use when allocating memory for the data struct
- * @guid:          uuid that identifies channel type; this may 0 if the channel
+ * @guid:          GUID that identifies channel type; this may 0 if the channel
  *                 has already been initialized in memory (which is true for all
  *                 channels provided to guest environments by the s-Par
  *                 back-end), in which case the actual channel guid will be
@@ -390,7 +390,7 @@ signalinsert_inner(struct visorchannel *channel, u32 queue, void *msg)
  */
 static struct visorchannel *
 visorchannel_create_guts(u64 physaddr, unsigned long channel_bytes,
-			 gfp_t gfp, uuid_le guid, bool needs_lock)
+			 gfp_t gfp, const guid_t *guid, bool needs_lock)
 {
 	struct visorchannel *channel;
 	int err;
@@ -415,7 +415,7 @@ visorchannel_create_guts(u64 physaddr, unsigned long channel_bytes,
 	 * release later on.
 	 */
 	channel->requested = request_mem_region(physaddr, size, MYDRVNAME);
-	if (!channel->requested && uuid_le_cmp(guid, visor_video_guid))
+	if (!channel->requested && !guid_equal(guid, &visor_video_guid))
 		/* we only care about errors if this is not the video channel */
 		goto err_destroy_channel;
 
@@ -436,8 +436,8 @@ visorchannel_create_guts(u64 physaddr, unsigned long channel_bytes,
 	/* we had better be a CLIENT of this channel */
 	if (channel_bytes == 0)
 		channel_bytes = (ulong)channel->chan_hdr.size;
-	if (uuid_le_cmp(guid, NULL_UUID_LE) == 0)
-		guid = channel->chan_hdr.chtype;
+	if (guid_is_null(guid))
+		guid = &channel->chan_hdr.chtype;
 
 	memunmap(channel->mapped);
 	if (channel->requested)
@@ -445,7 +445,7 @@ visorchannel_create_guts(u64 physaddr, unsigned long channel_bytes,
 	channel->mapped = NULL;
 	channel->requested = request_mem_region(channel->physaddr,
 						channel_bytes, MYDRVNAME);
-	if (!channel->requested && uuid_le_cmp(guid, visor_video_guid))
+	if (!channel->requested && !guid_equal(guid, &visor_video_guid))
 		/* we only care about errors if this is not the video channel */
 		goto err_destroy_channel;
 
@@ -457,7 +457,7 @@ visorchannel_create_guts(u64 physaddr, unsigned long channel_bytes,
 	}
 
 	channel->nbytes = channel_bytes;
-	channel->guid = guid;
+	guid_copy(&channel->guid, guid);
 	return channel;
 
 err_destroy_channel:
@@ -467,7 +467,7 @@ visorchannel_create_guts(u64 physaddr, unsigned long channel_bytes,
 
 struct visorchannel *
 visorchannel_create(u64 physaddr, unsigned long channel_bytes,
-		    gfp_t gfp, uuid_le guid)
+		    gfp_t gfp, const guid_t *guid)
 {
 	return visorchannel_create_guts(physaddr, channel_bytes, gfp, guid,
 					false);
@@ -475,7 +475,7 @@ visorchannel_create(u64 physaddr, unsigned long channel_bytes,
 
 struct visorchannel *
 visorchannel_create_with_lock(u64 physaddr, unsigned long channel_bytes,
-			      gfp_t gfp, uuid_le guid)
+			      gfp_t gfp, const guid_t *guid)
 {
 	return visorchannel_create_guts(physaddr, channel_bytes, gfp, guid,
 					true);
diff --git a/drivers/staging/unisys/visorbus/visorchipset.c b/drivers/staging/unisys/visorbus/visorchipset.c
index 22150564b4fb..5e2bb9b8fa1b 100644
--- a/drivers/staging/unisys/visorbus/visorchipset.c
+++ b/drivers/staging/unisys/visorbus/visorchipset.c
@@ -27,6 +27,10 @@
 #include "visorbus_private.h"
 #include "vmcallinterface.h"
 
+static const guid_t visor_vhba_channel_guid = VISOR_VHBA_CHANNEL_GUID;
+static const guid_t visor_siovm_guid = VISOR_SIOVM_GUID;
+static const guid_t visor_controlvm_channel_guid = VISOR_CONTROLVM_CHANNEL_GUID;
+
 #define CURRENT_FILE_PC VISOR_BUS_PC_visorchipset_c
 
 #define POLLJIFFIES_CONTROLVMCHANNEL_FAST 1
@@ -277,13 +281,12 @@ static ssize_t remaining_steps_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(remaining_steps);
 
-static uuid_le
-parser_id_get(struct parser_context *ctx)
+static const guid_t *parser_id_get(struct parser_context *ctx)
 {
 	struct visor_controlvm_parameters_header *phdr = NULL;
 
 	phdr = (struct visor_controlvm_parameters_header *)(ctx->data);
-	return phdr->id;
+	return &phdr->id;
 }
 
 static void parser_done(struct parser_context *ctx)
@@ -595,7 +598,7 @@ visorbus_create(struct controlvm_message *inmsg)
 	bus_info->chipset_bus_no = bus_no;
 	bus_info->chipset_dev_no = BUS_ROOT_DEVICE;
 
-	if (uuid_le_cmp(cmd->create_bus.bus_inst_uuid, visor_siovm_uuid) == 0) {
+	if (guid_equal(&cmd->create_bus.bus_inst_guid, &visor_siovm_guid)) {
 		err = save_crash_message(inmsg, CRASH_BUS);
 		if (err)
 			goto err_free_bus_info;
@@ -617,7 +620,7 @@ visorbus_create(struct controlvm_message *inmsg)
 	visorchannel = visorchannel_create(cmd->create_bus.channel_addr,
 					   cmd->create_bus.channel_bytes,
 					   GFP_KERNEL,
-					   cmd->create_bus.bus_data_type_uuid);
+					   &cmd->create_bus.bus_data_type_guid);
 
 	if (!visorchannel) {
 		err = -ENOMEM;
@@ -722,7 +725,9 @@ visorbus_configure(struct controlvm_message *inmsg,
 		goto err_respond;
 
 	if (parser_ctx) {
-		bus_info->partition_uuid = parser_id_get(parser_ctx);
+		const guid_t *partition_guid = parser_id_get(parser_ctx);
+
+		guid_copy(&bus_info->partition_guid, partition_guid);
 		bus_info->name = parser_name_get(parser_ctx);
 	}
 
@@ -781,7 +786,7 @@ visorbus_device_create(struct controlvm_message *inmsg)
 
 	dev_info->chipset_bus_no = bus_no;
 	dev_info->chipset_dev_no = dev_no;
-	dev_info->inst = cmd->create_device.dev_inst_uuid;
+	guid_copy(&dev_info->inst, &cmd->create_device.dev_inst_guid);
 
 	/* not sure where the best place to set the 'parent' */
 	dev_info->device.parent = &bus_info->device;
@@ -790,7 +795,7 @@ visorbus_device_create(struct controlvm_message *inmsg)
 	       visorchannel_create_with_lock(cmd->create_device.channel_addr,
 					     cmd->create_device.channel_bytes,
 					     GFP_KERNEL,
-					     cmd->create_device.data_type_uuid);
+					     &cmd->create_device.data_type_guid);
 
 	if (!visorchannel) {
 		dev_err(&chipset_dev->acpi_device->dev,
@@ -800,9 +805,8 @@ visorbus_device_create(struct controlvm_message *inmsg)
 		goto err_free_dev_info;
 	}
 	dev_info->visorchannel = visorchannel;
-	dev_info->channel_type_guid = cmd->create_device.data_type_uuid;
-	if (uuid_le_cmp(cmd->create_device.data_type_uuid,
-			visor_vhba_channel_uuid) == 0) {
+	guid_copy(&dev_info->channel_type_guid, &cmd->create_device.data_type_guid);
+	if (guid_equal(&cmd->create_device.data_type_guid, &visor_vhba_channel_guid)) {
 		err = save_crash_message(inmsg, CRASH_DEV);
 		if (err)
 			goto err_destroy_visorchannel;
@@ -1817,7 +1821,6 @@ visorchipset_init(struct acpi_device *acpi_device)
 {
 	int err = -ENODEV;
 	u64 addr;
-	uuid_le uuid = VISOR_CONTROLVM_CHANNEL_UUID;
 	struct visorchannel *controlvm_channel;
 
 	chipset_dev = kzalloc(sizeof(*chipset_dev), GFP_KERNEL);
@@ -1832,9 +1835,9 @@ visorchipset_init(struct acpi_device *acpi_device)
 
 	chipset_dev->acpi_device = acpi_device;
 	chipset_dev->poll_jiffies = POLLJIFFIES_CONTROLVMCHANNEL_FAST;
-	controlvm_channel = visorchannel_create_with_lock(addr,
-							  0, GFP_KERNEL, uuid);
 
+	controlvm_channel = visorchannel_create_with_lock(addr, 0, GFP_KERNEL,
+						&visor_controlvm_channel_guid);
 	if (!controlvm_channel)
 		goto error_free_chipset_dev;
 
@@ -1845,8 +1848,12 @@ visorchipset_init(struct acpi_device *acpi_device)
 	if (err < 0)
 		goto error_destroy_channel;
 
-	if (!VISOR_CONTROLVM_CHANNEL_OK_CLIENT(
-				visorchannel_get_header(controlvm_channel)))
+	if (!visor_check_channel(visorchannel_get_header(controlvm_channel),
+				 &visor_controlvm_channel_guid,
+				 "controlvm",
+				 sizeof(struct visor_controlvm_channel),
+				 VISOR_CONTROLVM_CHANNEL_VERSIONID,
+				 VISOR_CONTROLVM_CHANNEL_SIGNATURE))
 		goto error_delete_groups;
 
 	/* if booting in a crash kernel */
diff --git a/drivers/staging/unisys/visorhba/visorhba_main.c b/drivers/staging/unisys/visorhba/visorhba_main.c
index a6e7a6bbc428..d0e84ca08a5a 100644
--- a/drivers/staging/unisys/visorhba/visorhba_main.c
+++ b/drivers/staging/unisys/visorhba/visorhba_main.c
@@ -39,12 +39,12 @@ static struct visor_channeltype_descriptor visorhba_channel_types[] = {
 	/* Note that the only channel type we expect to be reported by the
 	 * bus driver is the VISOR_VHBA channel.
 	 */
-	{ VISOR_VHBA_CHANNEL_UUID, "sparvhba" },
-	{ NULL_UUID_LE, NULL }
+	{ VISOR_VHBA_CHANNEL_GUID, "sparvhba" },
+	{}
 };
 
 MODULE_DEVICE_TABLE(visorbus, visorhba_channel_types);
-MODULE_ALIAS("visorbus:" VISOR_VHBA_CHANNEL_UUID_STR);
+MODULE_ALIAS("visorbus:" VISOR_VHBA_CHANNEL_GUID_STR);
 
 struct visordisk_info {
 	u32 valid;
diff --git a/drivers/staging/unisys/visorinput/visorinput.c b/drivers/staging/unisys/visorinput/visorinput.c
index 45bc340d4e9d..fbf4957ffa15 100644
--- a/drivers/staging/unisys/visorinput/visorinput.c
+++ b/drivers/staging/unisys/visorinput/visorinput.c
@@ -33,16 +33,16 @@
 #include "ultrainputreport.h"
 
 /* Keyboard channel {c73416d0-b0b8-44af-b304-9d2ae99f1b3d} */
-#define VISOR_KEYBOARD_CHANNEL_UUID \
-	UUID_LE(0xc73416d0, 0xb0b8, 0x44af, \
-		0xb3, 0x4, 0x9d, 0x2a, 0xe9, 0x9f, 0x1b, 0x3d)
-#define VISOR_KEYBOARD_CHANNEL_UUID_STR "c73416d0-b0b8-44af-b304-9d2ae99f1b3d"
+#define VISOR_KEYBOARD_CHANNEL_GUID \
+	GUID_INIT(0xc73416d0, 0xb0b8, 0x44af, \
+		  0xb3, 0x4, 0x9d, 0x2a, 0xe9, 0x9f, 0x1b, 0x3d)
+#define VISOR_KEYBOARD_CHANNEL_GUID_STR "c73416d0-b0b8-44af-b304-9d2ae99f1b3d"
 
 /* Mouse channel {addf07d4-94a9-46e2-81c3-61abcdbdbd87} */
-#define VISOR_MOUSE_CHANNEL_UUID \
-	UUID_LE(0xaddf07d4, 0x94a9, 0x46e2, \
-		0x81, 0xc3, 0x61, 0xab, 0xcd, 0xbd, 0xbd, 0x87)
-#define VISOR_MOUSE_CHANNEL_UUID_STR "addf07d4-94a9-46e2-81c3-61abcdbdbd87"
+#define VISOR_MOUSE_CHANNEL_GUID \
+	GUID_INIT(0xaddf07d4, 0x94a9, 0x46e2, \
+		  0x81, 0xc3, 0x61, 0xab, 0xcd, 0xbd, 0xbd, 0x87)
+#define VISOR_MOUSE_CHANNEL_GUID_STR "addf07d4-94a9-46e2-81c3-61abcdbdbd87"
 
 #define PIXELS_ACROSS_DEFAULT 800
 #define PIXELS_DOWN_DEFAULT   600
@@ -69,8 +69,8 @@ struct visorinput_devdata {
 	unsigned char keycode_table[0];
 };
 
-static const uuid_le visor_keyboard_channel_uuid = VISOR_KEYBOARD_CHANNEL_UUID;
-static const uuid_le visor_mouse_channel_uuid = VISOR_MOUSE_CHANNEL_UUID;
+static const guid_t visor_keyboard_channel_guid = VISOR_KEYBOARD_CHANNEL_GUID;
+static const guid_t visor_mouse_channel_guid = VISOR_MOUSE_CHANNEL_GUID;
 
 /*
  * Borrowed from drivers/input/keyboard/atakbd.c
@@ -449,13 +449,13 @@ devdata_create(struct visor_device *dev, enum visorinput_device_type devtype)
 static int
 visorinput_probe(struct visor_device *dev)
 {
-	uuid_le guid;
+	const guid_t *guid;
 	enum visorinput_device_type devtype;
 
-	guid = visorchannel_get_uuid(dev->visorchannel);
-	if (uuid_le_cmp(guid, visor_mouse_channel_uuid) == 0)
+	guid = visorchannel_get_guid(dev->visorchannel);
+	if (guid_equal(guid, &visor_mouse_channel_guid))
 		devtype = visorinput_mouse;
-	else if (uuid_le_cmp(guid, visor_keyboard_channel_uuid) == 0)
+	else if (guid_equal(guid, &visor_keyboard_channel_guid))
 		devtype = visorinput_keyboard;
 	else
 		return -ENODEV;
@@ -727,9 +727,9 @@ visorinput_resume(struct visor_device *dev,
 
 /* GUIDS for all channel types supported by this driver. */
 static struct visor_channeltype_descriptor visorinput_channel_types[] = {
-	{ VISOR_KEYBOARD_CHANNEL_UUID, "keyboard"},
-	{ VISOR_MOUSE_CHANNEL_UUID, "mouse"},
-	{ NULL_UUID_LE, NULL }
+	{ VISOR_KEYBOARD_CHANNEL_GUID, "keyboard"},
+	{ VISOR_MOUSE_CHANNEL_GUID, "mouse"},
+	{}
 };
 
 static struct visor_driver visorinput_driver = {
@@ -764,5 +764,5 @@ MODULE_AUTHOR("Unisys");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("s-Par human input driver for virtual keyboard/mouse");
 
-MODULE_ALIAS("visorbus:" VISOR_MOUSE_CHANNEL_UUID_STR);
-MODULE_ALIAS("visorbus:" VISOR_KEYBOARD_CHANNEL_UUID_STR);
+MODULE_ALIAS("visorbus:" VISOR_MOUSE_CHANNEL_GUID_STR);
+MODULE_ALIAS("visorbus:" VISOR_KEYBOARD_CHANNEL_GUID_STR);
diff --git a/drivers/staging/unisys/visornic/visornic_main.c b/drivers/staging/unisys/visornic/visornic_main.c
index 2891622eef18..10c1d036f996 100644
--- a/drivers/staging/unisys/visornic/visornic_main.c
+++ b/drivers/staging/unisys/visornic/visornic_main.c
@@ -41,8 +41,8 @@ static struct visor_channeltype_descriptor visornic_channel_types[] = {
 	/* Note that the only channel type we expect to be reported by the
 	 * bus driver is the VISOR_VNIC channel.
 	 */
-	{ VISOR_VNIC_CHANNEL_UUID, "ultravnic" },
-	{ NULL_UUID_LE, NULL }
+	{ VISOR_VNIC_CHANNEL_GUID, "ultravnic" },
+	{}
 };
 MODULE_DEVICE_TABLE(visorbus, visornic_channel_types);
 /*
@@ -52,7 +52,7 @@ MODULE_DEVICE_TABLE(visorbus, visornic_channel_types);
  * must be added to scripts/mode/file2alias.c, etc., to get this working
  * properly.
  */
-MODULE_ALIAS("visorbus:" VISOR_VNIC_CHANNEL_UUID_STR);
+MODULE_ALIAS("visorbus:" VISOR_VNIC_CHANNEL_GUID_STR);
 
 struct chanstat {
 	unsigned long got_rcv;
-- 
2.11.0
