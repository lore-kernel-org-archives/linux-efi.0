From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 5/8] vmbus: Use recently introduced uuid_le_cmp_p{p}()
 helpers
Date: Fri, 21 Apr 2017 17:46:42 +0300
Message-ID: <20170421144645.45189-5-andriy.shevchenko@linux.intel.com>
References: <20170421144645.45189-1-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20170421144645.45189-1-andriy.shevchenko@linux.intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Mika Westerberg <mika.westerberg@linux.intel.com>, alsa-devel@alsa-project.org, linux-input@vger.kernel.org, kvm@vger.kernel.org, devel@linuxdriverproject.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: Haiyang Zhang <haiyangz@microsoft.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Stephen Hemminger <sthemmin@microsoft.com>
List-Id: linux-efi@vger.kernel.org

Recently introduced helpers take pointers to uuid_{be|le} instead of
reference.

Using them makes code less ugly.

Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/hv/channel_mgmt.c | 10 +++++-----
 drivers/hv/vmbus_drv.c    |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 735f9363f2e4..01570c50ed04 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -176,7 +176,7 @@ static bool is_unsupported_vmbus_devs(const uuid_le *guid)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(vmbus_unsupported_devs); i++)
-		if (!uuid_le_cmp(*guid, vmbus_unsupported_devs[i].guid))
+		if (!uuid_le_cmp_p(guid, vmbus_unsupported_devs[i].guid))
 			return true;
 	return false;
 }
@@ -190,7 +190,7 @@ static u16 hv_get_dev_type(const struct vmbus_channel *channel)
 		return HV_UNKNOWN;
 
 	for (i = HV_IDE; i < HV_UNKNOWN; i++) {
-		if (!uuid_le_cmp(*guid, vmbus_devs[i].guid))
+		if (!uuid_le_cmp_p(guid, vmbus_devs[i].guid))
 			return i;
 	}
 	pr_info("Unknown GUID: %pUl\n", guid);
@@ -456,9 +456,9 @@ static void vmbus_process_offer(struct vmbus_channel *newchannel)
 
 	list_for_each_entry(channel, &vmbus_connection.chn_list, listentry) {
 		if (!uuid_le_cmp(channel->offermsg.offer.if_type,
-			newchannel->offermsg.offer.if_type) &&
-			!uuid_le_cmp(channel->offermsg.offer.if_instance,
-				newchannel->offermsg.offer.if_instance)) {
+				 newchannel->offermsg.offer.if_type) &&
+		    !uuid_le_cmp(channel->offermsg.offer.if_instance,
+				 newchannel->offermsg.offer.if_instance)) {
 			fnew = false;
 			break;
 		}
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 0087b49095eb..b41a2be778f6 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -557,7 +557,7 @@ static const struct hv_vmbus_device_id *hv_vmbus_get_id(struct hv_driver *drv,
 	/* Look at the dynamic ids first, before the static ones */
 	spin_lock(&drv->dynids.lock);
 	list_for_each_entry(dynid, &drv->dynids.list, node) {
-		if (!uuid_le_cmp(dynid->id.guid, *guid)) {
+		if (!uuid_le_cmp_p(guid, dynid->id.guid)) {
 			id = &dynid->id;
 			break;
 		}
-- 
2.11.0
