From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH v1 1/8] lib/uuid: Introduce uuid_{be|le}_cmp_p{p}()
 helpers
Date: Mon, 24 Apr 2017 12:44:02 +0200
Message-ID: <20170424104402.GA9723@wunner.de>
References: <20170421144645.45189-1-andriy.shevchenko@linux.intel.com>
 <5B8DA87D05A7694D9FA63FD143655C1B543E8399@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B543E8399-Jy8z56yoSI8MvF1YICWikbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Mika Westerberg <mika.westerberg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org" <alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org>, "linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org" <devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liam Girdwood <lgirdwood-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Koul, Vinod" <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Srinivas Pandruvada <srinivas.pandruvada-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Benjamin Tissoires <benjamin.ti>
List-Id: linux-efi@vger.kernel.org

> New helpers take pointers to uuid_{be|le} as parameters.
> 
> When using them on a raw data we don't need to do an ugly dereference and,
> in some cases, a type casting.
> 
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> Cc: Liam Girdwood <lgirdwood-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Vinod Koul <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Srinivas Pandruvada <srinivas.pandruvada-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Benjamin Tissoires <benjamin.tissoires-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Kirti Wankhede <kwankhede-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> Cc: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: "K. Y. Srinivasan" <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> Cc: Haiyang Zhang <haiyangz-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> Cc: Stephen Hemminger <sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> Cc: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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

There's a bug in gcc wherein constant compound literals are generated
on the stack at runtime, rather than stored in rodata.  The bug occurs
if the compound literal is passed by reference.  It does not manifest
itself when passing by value:

https://gcc.gnu.org/bugzilla/show_bug.cgi?id=68725

Hence this patch is unfortunately counterproductive if the UUIDs are
declared const.

FWIW I've posted a series back in January to constify UUIDs as much as
possible, but I got some objections and lacked the time so far to
address them.  In fact I'm thinking that gcc needs to be fixed first,
then we can focus on improving the kernel side of things:

https://www.spinics.net/lists/linux-efi/msg10093.html

Best regards,

Lukas
