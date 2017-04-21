From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 4/8] vfio-mdev: Use recently introduced uuid_le_cmp_p{p}()
Date: Fri, 21 Apr 2017 17:46:41 +0300
Message-ID: <20170421144645.45189-4-andriy.shevchenko@linux.intel.com>
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
Cc: Kirti Wankhede <kwankhede@nvidia.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Alex Williamson <alex.williamson@redhat.com>
List-Id: linux-efi@vger.kernel.org

Recently introduced helpers take pointers to uuid_{be|le} instead of
reference.

Using them makes code less ugly.

Cc: Kirti Wankhede <kwankhede@nvidia.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/vfio/mdev/mdev_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index 126991046eb7..82de886855d8 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -75,7 +75,7 @@ static int _find_mdev_device(struct device *dev, void *data)
 
 	mdev = to_mdev_device(dev);
 
-	if (uuid_le_cmp(mdev->uuid, *(uuid_le *)data) == 0)
+	if (uuid_le_cmp_p(data, mdev->uuid) == 0)
 		return 1;
 
 	return 0;
-- 
2.11.0
