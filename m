From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/8] lib/uuid: Introduce uuid_{be|le}_cmp_p{p}() helpers
Date: Fri, 21 Apr 2017 17:46:38 +0300
Message-ID: <20170421144645.45189-1-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
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
Cc: Alex Williamson <alex.williamson@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Vinod Koul <vinod.koul@intel.com>, Haiyang Zhang <haiyangz@microsoft.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Liam Girdwood <lgirdwood@gmail.com>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, Kirti Wankhede <kwankhede@nvidia.com>, Mark Brown <broonie@kernel.org>, Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Stephen Hemminger <sthemmin@microsoft.com>, Tomas Winkler <tomas.winkler@intel.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>
List-Id: linux-efi@vger.kernel.org

New helpers take pointers to uuid_{be|le} as parameters.

When using them on a raw data we don't need to do an ugly dereference
and, in some cases, a type casting.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Kirti Wankhede <kwankhede@nvidia.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 include/linux/uuid.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/uuid.h b/include/linux/uuid.h
index 4dff73a89758..45312cb5ac65 100644
--- a/include/linux/uuid.h
+++ b/include/linux/uuid.h
@@ -58,6 +58,26 @@ static inline int uuid_be_cmp(const uuid_be u1, const uuid_be u2)
 	return memcmp(&u1, &u2, sizeof(uuid_be));
 }
 
+static inline int uuid_le_cmp_p(const uuid_le *pu1, const uuid_le u2)
+{
+	return memcmp(pu1, &u2, sizeof(uuid_le));
+}
+
+static inline int uuid_be_cmp_p(const uuid_be *pu1, const uuid_be u2)
+{
+	return memcmp(pu1, &u2, sizeof(uuid_be));
+}
+
+static inline int uuid_le_cmp_pp(const uuid_le *pu1, const uuid_le *pu2)
+{
+	return memcmp(pu1, pu2, sizeof(uuid_le));
+}
+
+static inline int uuid_be_cmp_pp(const uuid_be *pu1, const uuid_be *pu2)
+{
+	return memcmp(pu1, pu2, sizeof(uuid_be));
+}
+
 void generate_random_uuid(unsigned char uuid[16]);
 
 extern void uuid_le_gen(uuid_le *u);
-- 
2.11.0
