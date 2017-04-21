From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 2/8] ASoC: Intel: Skylake: Use recently introduced
 uuid_le_cmp_p{p}()
Date: Fri, 21 Apr 2017 17:46:39 +0300
Message-ID: <20170421144645.45189-2-andriy.shevchenko@linux.intel.com>
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
Cc: Vinod Koul <vinod.koul@intel.com>, Mark Brown <broonie@kernel.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Liam Girdwood <lgirdwood@gmail.com>
List-Id: linux-efi@vger.kernel.org

Recently introduced helpers take pointers to uuid_{be|le} instead of
reference.

Using them makes code less ugly.

Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 sound/soc/intel/skylake/skl-pcm.c       | 2 +-
 sound/soc/intel/skylake/skl-sst-utils.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/intel/skylake/skl-pcm.c b/sound/soc/intel/skylake/skl-pcm.c
index 600faad19bd4..4bf171985872 100644
--- a/sound/soc/intel/skylake/skl-pcm.c
+++ b/sound/soc/intel/skylake/skl-pcm.c
@@ -1207,7 +1207,7 @@ static int skl_get_module_info(struct skl *skl, struct skl_module_cfg *mconfig)
 	}
 
 	list_for_each_entry(module, &ctx->uuid_list, list) {
-		if (uuid_le_cmp(*uuid_mod, module->uuid) == 0) {
+		if (uuid_le_cmp_p(uuid_mod, module->uuid) == 0) {
 			mconfig->id.module_id = module->id;
 			mconfig->is_loadable = module->is_loadable;
 			return 0;
diff --git a/sound/soc/intel/skylake/skl-sst-utils.c b/sound/soc/intel/skylake/skl-sst-utils.c
index 6d5bff04bf65..67288580c743 100644
--- a/sound/soc/intel/skylake/skl-sst-utils.c
+++ b/sound/soc/intel/skylake/skl-sst-utils.c
@@ -189,7 +189,7 @@ int skl_get_pvt_id(struct skl_sst *ctx, uuid_le *uuid_mod, int instance_id)
 	int pvt_id;
 
 	list_for_each_entry(module, &ctx->uuid_list, list) {
-		if (uuid_le_cmp(*uuid_mod, module->uuid) == 0) {
+		if (uuid_le_cmp_p(uuid_mod, module->uuid) == 0) {
 
 			pvt_id = skl_pvtid_128(module);
 			if (pvt_id >= 0) {
@@ -218,7 +218,7 @@ int skl_put_pvt_id(struct skl_sst *ctx, uuid_le *uuid_mod, int *pvt_id)
 	struct uuid_module *module;
 
 	list_for_each_entry(module, &ctx->uuid_list, list) {
-		if (uuid_le_cmp(*uuid_mod, module->uuid) == 0) {
+		if (uuid_le_cmp_p(uuid_mod, module->uuid) == 0) {
 
 			if (*pvt_id != 0)
 				i = (*pvt_id) / 64;
-- 
2.11.0
