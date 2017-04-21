From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 6/8] mei: Use recently introduced uuid_le_cmp_p{p}() helpers
Date: Fri, 21 Apr 2017 17:46:43 +0300
Message-ID: <20170421144645.45189-6-andriy.shevchenko@linux.intel.com>
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
Cc: Tomas Winkler <tomas.winkler@intel.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>
List-Id: linux-efi@vger.kernel.org

Recently introduced helpers take pointers to uuid_{be|le} instead of
reference.

Using them makes code less ugly.

Cc: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/misc/mei/bus-fixup.c | 2 +-
 drivers/misc/mei/bus.c       | 2 +-
 drivers/misc/mei/client.c    | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/mei/bus-fixup.c b/drivers/misc/mei/bus-fixup.c
index 0208c4b027c5..de0fcd98d162 100644
--- a/drivers/misc/mei/bus-fixup.c
+++ b/drivers/misc/mei/bus-fixup.c
@@ -416,7 +416,7 @@ void mei_cl_bus_dev_fixup(struct mei_cl_device *cldev)
 
 		f = &mei_fixups[i];
 		if (uuid_le_cmp(f->uuid, MEI_UUID_ANY) == 0 ||
-		    uuid_le_cmp(f->uuid, *uuid) == 0)
+		    uuid_le_cmp_p(uuid, f->uuid) == 0)
 			f->hook(cldev);
 	}
 }
diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index d1928fdd0f43..e15549f71891 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -615,7 +615,7 @@ struct mei_cl_device_id *mei_cl_device_find(struct mei_cl_device *cldev,
 
 	id = cldrv->id_table;
 	while (uuid_le_cmp(NULL_UUID_LE, id->uuid)) {
-		if (!uuid_le_cmp(*uuid, id->uuid)) {
+		if (!uuid_le_cmp_p(uuid, id->uuid)) {
 			match = true;
 
 			if (cldev->name[0])
diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index be64969d986a..590accb369bd 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -148,7 +148,7 @@ static struct mei_me_client *__mei_me_cl_by_uuid(struct mei_device *dev,
 
 	list_for_each_entry(me_cl, &dev->me_clients, list) {
 		pn = &me_cl->props.protocol_name;
-		if (uuid_le_cmp(*uuid, *pn) == 0)
+		if (uuid_le_cmp_pp(uuid, pn) == 0)
 			return mei_me_cl_get(me_cl);
 	}
 
@@ -228,7 +228,7 @@ static struct mei_me_client *__mei_me_cl_by_uuid_id(struct mei_device *dev,
 
 	list_for_each_entry(me_cl, &dev->me_clients, list) {
 		pn = &me_cl->props.protocol_name;
-		if (uuid_le_cmp(*uuid, *pn) == 0 &&
+		if (uuid_le_cmp_pp(uuid, pn) == 0 &&
 		    me_cl->client_id == client_id)
 			return mei_me_cl_get(me_cl);
 	}
-- 
2.11.0
