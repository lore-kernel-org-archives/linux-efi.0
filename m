From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 3/8] HID: intel_ish-hid: Use recently
	introduced uuid_le_cmp_p{p}()
Date: Fri, 21 Apr 2017 17:46:40 +0300
Message-ID: <20170421144645.45189-3-andriy.shevchenko@linux.intel.com>
References: <20170421144645.45189-1-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <alsa-devel-bounces@alsa-project.org>
In-Reply-To: <20170421144645.45189-1-andriy.shevchenko@linux.intel.com>
List-Unsubscribe: <http://mailman.alsa-project.org/mailman/options/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=unsubscribe>
List-Archive: <http://mailman.alsa-project.org/pipermail/alsa-devel/>
List-Post: <mailto:alsa-devel@alsa-project.org>
List-Help: <mailto:alsa-devel-request@alsa-project.org?subject=help>
List-Subscribe: <http://mailman.alsa-project.org/mailman/listinfo/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=subscribe>
Errors-To: alsa-devel-bounces@alsa-project.org
Sender: alsa-devel-bounces@alsa-project.org
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Mika Westerberg <mika.westerberg@linux.intel.com>, alsa-devel@alsa-project.org, linux-input@vger.kernel.org, kvm@vger.kernel.org, devel@linuxdriverproject.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
List-Id: linux-efi@vger.kernel.org

Recently introduced helpers take pointers to uuid_{be|le} instead of
reference.

Using them makes code less ugly.

Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/hid/intel-ish-hid/ishtp/bus.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/hid/intel-ish-hid/ishtp/bus.c b/drivers/hid/intel-ish-hid/ishtp/bus.c
index 5f382fedc2ab..165e21b7ee9f 100644
--- a/drivers/hid/intel-ish-hid/ishtp/bus.c
+++ b/drivers/hid/intel-ish-hid/ishtp/bus.c
@@ -138,8 +138,7 @@ int ishtp_fw_cl_by_uuid(struct ishtp_device *dev, const uuid_le *uuid)
 	int i, res = -ENOENT;
 
 	for (i = 0; i < dev->fw_clients_num; ++i) {
-		if (uuid_le_cmp(*uuid, dev->fw_clients[i].props.protocol_name)
-				== 0) {
+		if (!uuid_le_cmp_p(uuid, dev->fw_clients[i].props.protocol_name)) {
 			res = i;
 			break;
 		}
-- 
2.11.0
