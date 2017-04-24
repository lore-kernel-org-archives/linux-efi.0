From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v1 2/8] ASoC: Intel: Skylake: Use recently introduced
 uuid_le_cmp_p{p}()
Date: Mon, 24 Apr 2017 11:50:52 +0300
Message-ID: <1493023852.24567.148.camel@linux.intel.com>
References: <20170421144645.45189-1-andriy.shevchenko@linux.intel.com>
         <20170421144645.45189-2-andriy.shevchenko@linux.intel.com>
         <20170424045105.GF6263@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170424045105.GF6263@localhost>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vinod Koul <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Mika Westerberg <mika.westerberg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org, linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liam Girdwood <lgirdwood-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 2017-04-24 at 10:21 +0530, Vinod Koul wrote:
> On Fri, Apr 21, 2017 at 05:46:39PM +0300, Andy Shevchenko wrote:
> > Recently introduced helpers take pointers to uuid_{be|le} instead of
> > reference.
> 
> Are they in linus's tree, if not it introduces dependency, so we might
> want
> to defer after merge window

You are Cc'ed to patch 1 which brings them.

> > 
> > Using them makes code less ugly.
> 
> How so..?

Consider below example.

- if (uuid_le_cmp(*uuid_mod, module->uuid) == 0) {
+ if (uuid_le_cmp_p(uuid_mod, module->uuid) == 0) {

There are two points:
1) caller don't need to dereference pointers to its values;
2) this allow compiler to not copy the data (though clever compiler
might optimize that).

> 
> > 
> > Cc: Liam Girdwood <lgirdwood-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Cc: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Cc: Vinod Koul <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > ---
> >  sound/soc/intel/skylake/skl-pcm.c       | 2 +-
> >  sound/soc/intel/skylake/skl-sst-utils.c | 4 ++--
> >  2 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/sound/soc/intel/skylake/skl-pcm.c
> > b/sound/soc/intel/skylake/skl-pcm.c
> > index 600faad19bd4..4bf171985872 100644
> > --- a/sound/soc/intel/skylake/skl-pcm.c
> > +++ b/sound/soc/intel/skylake/skl-pcm.c
> > @@ -1207,7 +1207,7 @@ static int skl_get_module_info(struct skl
> > *skl, struct skl_module_cfg *mconfig)
> >  	}
> >  
> >  	list_for_each_entry(module, &ctx->uuid_list, list) {
> > -		if (uuid_le_cmp(*uuid_mod, module->uuid) == 0) {
> > +		if (uuid_le_cmp_p(uuid_mod, module->uuid) == 0) {
> >  			mconfig->id.module_id = module->id;
> >  			mconfig->is_loadable = module->is_loadable;
> >  			return 0;
> > diff --git a/sound/soc/intel/skylake/skl-sst-utils.c
> > b/sound/soc/intel/skylake/skl-sst-utils.c
> > index 6d5bff04bf65..67288580c743 100644
> > --- a/sound/soc/intel/skylake/skl-sst-utils.c
> > +++ b/sound/soc/intel/skylake/skl-sst-utils.c
> > @@ -189,7 +189,7 @@ int skl_get_pvt_id(struct skl_sst *ctx, uuid_le
> > *uuid_mod, int instance_id)
> >  	int pvt_id;
> >  
> >  	list_for_each_entry(module, &ctx->uuid_list, list) {
> > -		if (uuid_le_cmp(*uuid_mod, module->uuid) == 0) {
> > +		if (uuid_le_cmp_p(uuid_mod, module->uuid) == 0) {
> >  
> >  			pvt_id = skl_pvtid_128(module);
> >  			if (pvt_id >= 0) {
> > @@ -218,7 +218,7 @@ int skl_put_pvt_id(struct skl_sst *ctx, uuid_le
> > *uuid_mod, int *pvt_id)
> >  	struct uuid_module *module;
> >  
> >  	list_for_each_entry(module, &ctx->uuid_list, list) {
> > -		if (uuid_le_cmp(*uuid_mod, module->uuid) == 0) {
> > +		if (uuid_le_cmp_p(uuid_mod, module->uuid) == 0) {
> >  
> >  			if (*pvt_id != 0)
> >  				i = (*pvt_id) / 64;
> > -- 
> > 2.11.0
> > 
> 
> 

-- 
Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Intel Finland Oy
