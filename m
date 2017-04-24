From: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH v1 2/8] ASoC: Intel: Skylake: Use recently introduced
 uuid_le_cmp_p{p}()
Date: Mon, 24 Apr 2017 10:21:05 +0530
Message-ID: <20170424045105.GF6263@localhost>
References: <20170421144645.45189-1-andriy.shevchenko@linux.intel.com>
 <20170421144645.45189-2-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170421144645.45189-2-andriy.shevchenko@linux.intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Mika Westerberg <mika.westerberg@linux.intel.com>, alsa-devel@alsa-project.org, linux-input@vger.kernel.org, kvm@vger.kernel.org, devel@linuxdriverproject.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Apr 21, 2017 at 05:46:39PM +0300, Andy Shevchenko wrote:
> Recently introduced helpers take pointers to uuid_{be|le} instead of
> reference.

Are they in linus's tree, if not it introduces dependency, so we might want
to defer after merge window

> 
> Using them makes code less ugly.

How so..?

> 
> Cc: Liam Girdwood <lgirdwood@gmail.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  sound/soc/intel/skylake/skl-pcm.c       | 2 +-
>  sound/soc/intel/skylake/skl-sst-utils.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/sound/soc/intel/skylake/skl-pcm.c b/sound/soc/intel/skylake/skl-pcm.c
> index 600faad19bd4..4bf171985872 100644
> --- a/sound/soc/intel/skylake/skl-pcm.c
> +++ b/sound/soc/intel/skylake/skl-pcm.c
> @@ -1207,7 +1207,7 @@ static int skl_get_module_info(struct skl *skl, struct skl_module_cfg *mconfig)
>  	}
>  
>  	list_for_each_entry(module, &ctx->uuid_list, list) {
> -		if (uuid_le_cmp(*uuid_mod, module->uuid) == 0) {
> +		if (uuid_le_cmp_p(uuid_mod, module->uuid) == 0) {
>  			mconfig->id.module_id = module->id;
>  			mconfig->is_loadable = module->is_loadable;
>  			return 0;
> diff --git a/sound/soc/intel/skylake/skl-sst-utils.c b/sound/soc/intel/skylake/skl-sst-utils.c
> index 6d5bff04bf65..67288580c743 100644
> --- a/sound/soc/intel/skylake/skl-sst-utils.c
> +++ b/sound/soc/intel/skylake/skl-sst-utils.c
> @@ -189,7 +189,7 @@ int skl_get_pvt_id(struct skl_sst *ctx, uuid_le *uuid_mod, int instance_id)
>  	int pvt_id;
>  
>  	list_for_each_entry(module, &ctx->uuid_list, list) {
> -		if (uuid_le_cmp(*uuid_mod, module->uuid) == 0) {
> +		if (uuid_le_cmp_p(uuid_mod, module->uuid) == 0) {
>  
>  			pvt_id = skl_pvtid_128(module);
>  			if (pvt_id >= 0) {
> @@ -218,7 +218,7 @@ int skl_put_pvt_id(struct skl_sst *ctx, uuid_le *uuid_mod, int *pvt_id)
>  	struct uuid_module *module;
>  
>  	list_for_each_entry(module, &ctx->uuid_list, list) {
> -		if (uuid_le_cmp(*uuid_mod, module->uuid) == 0) {
> +		if (uuid_le_cmp_p(uuid_mod, module->uuid) == 0) {
>  
>  			if (*pvt_id != 0)
>  				i = (*pvt_id) / 64;
> -- 
> 2.11.0
> 

-- 
~Vinod
