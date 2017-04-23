From: "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: RE: [PATCH v1 1/8] lib/uuid: Introduce uuid_{be|le}_cmp_p{p}()
 helpers
Date: Sun, 23 Apr 2017 10:29:14 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B543E8399@hasmsx108.ger.corp.intel.com>
References: <20170421144645.45189-1-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20170421144645.45189-1-andriy.shevchenko@linux.intel.com>
Content-Language: en-US
Sender: linux-acpi-owner@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Mika Westerberg <mika.westerberg@linux.intel.com>, "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>, "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, "Koul, Vinod" <vinod.koul@intel.com>, Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, Kirti Wankhede <kwankhede@nvidia.com>, Alex Williamson <alex.williamson@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
List-Id: linux-efi@vger.kernel.org

> New helpers take pointers to uuid_{be|le} as parameters.
> 
> When using them on a raw data we don't need to do an ugly dereference and,
> in some cases, a type casting.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Liam Girdwood <lgirdwood@gmail.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> Cc: Kirti Wankhede <kwankhede@nvidia.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: "K. Y. Srinivasan" <kys@microsoft.com>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: Stephen Hemminger <sthemmin@microsoft.com>
> Cc: Tomas Winkler <tomas.winkler@intel.com>
> Cc: Matt Fleming <matt@codeblueprint.co.uk>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  include/linux/uuid.h | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/include/linux/uuid.h b/include/linux/uuid.h index
> 4dff73a89758..45312cb5ac65 100644
> --- a/include/linux/uuid.h
> +++ b/include/linux/uuid.h
> @@ -58,6 +58,26 @@ static inline int uuid_be_cmp(const uuid_be u1, const
> uuid_be u2)
>  	return memcmp(&u1, &u2, sizeof(uuid_be));  }
> 
> +static inline int uuid_le_cmp_p(const uuid_le *pu1, const uuid_le u2) {
> +	return memcmp(pu1, &u2, sizeof(uuid_le)); }
> +
> +static inline int uuid_be_cmp_p(const uuid_be *pu1, const uuid_be u2) {
> +	return memcmp(pu1, &u2, sizeof(uuid_be)); }
> +
> +static inline int uuid_le_cmp_pp(const uuid_le *pu1, const uuid_le
> +*pu2) {
> +	return memcmp(pu1, pu2, sizeof(uuid_le)); }
> +
> +static inline int uuid_be_cmp_pp(const uuid_be *pu1, const uuid_be
> +*pu2) {
> +	return memcmp(pu1, pu2, sizeof(uuid_be)); }
> +
>  void generate_random_uuid(unsigned char uuid[16]);
> 
>  extern void uuid_le_gen(uuid_le *u);

I think this going overboard, the _pp types  are just enough. 
Tomas
