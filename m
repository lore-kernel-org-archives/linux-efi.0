Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563AD3B2FE9
	for <linux-efi@vger.kernel.org>; Fri,  4 Sep 2026 09:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788514885; cv=none; b=u1+tGPMU63TIKg/9oxgv/IMBp/CdjghsATcviu4Wu2VYg3sWWCBFuMr1QyDGowunapdLm0DViF+QOekFNjwvfnPQvF27aHnw/psO3JGvypnBP7G0C8gWuVYnfaqZ9JPflmd+//iw9jb6fAIeq9idjwqrO4n0JI4CDZegFNCuldE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788514885; c=relaxed/simple;
	bh=ZAsXYph+3UL5QbS4apKrLnhh+iWZ6jvjIOFOd0lsZS0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Ht2fhRYwLXT0X0ligSYWTbf8T4Pof2Fw9DCNdkdr/vWhonJaH+CmEMuj3KtmZiInf1htzbTrQvwOtCxJSmMoiyJAMi7z+AFh8qyxK49IvSvsaIVcEOngSV9RZi5KQvb4dgHNpWg3/6w48/2AjaNciLSu8wq7LMxRDAM30SJ38gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ltn7tyEZ; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ltn7tyEZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788514883; x=1820050883;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=ZAsXYph+3UL5QbS4apKrLnhh+iWZ6jvjIOFOd0lsZS0=;
  b=Ltn7tyEZukOnVEJFKg9McRiZQ5BxUf8ZKQda0NUqUgeJjuba4X0eAjPW
   vnvCDayD8bKOSDuuzx87ITw/OT/3j92yBfCFS5y+i5Sg9P8pPfxbkPpEd
   f96Z1zCDY7BJjGKF2Q8QSkLy6VbVtCznmlHnUVR7RDXevPMfSQ7QXJDZq
   pFU2hOH/nd53zYX7yZWU4VMx4gvr1z+E5hbWaVh2uPlgUxP7lIK6gxps1
   pveHP/tzNL6GiL1OQzRnGuZu9hBaZIqeXHPTIrxepOqcqom3pvYdhX/WD
   jSyEXfHCT5hTwrvnJFVyZuuBbbUhIpEc8Iq/uGYKHgyvCgDYxc4VBZxD4
   w==;
X-CSE-ConnectionGUID: ekXspIgwSney7wFLNAE2qQ==
X-CSE-MsgGUID: CUZW2HQISgCJGJ8YpjQT3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11895"; a="88861116"
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="88861116"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2026 02:41:23 -0700
X-CSE-ConnectionGUID: mNDvgPXDSJOj7O8+SpJEhg==
X-CSE-MsgGUID: l7wCaX8OS0+uyxOZqWyrXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="268679512"
Received: from abityuts-desk1.ger.corp.intel.com (HELO localhost) ([10.245.245.29])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2026 02:41:19 -0700
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Thomas Zimmermann <tzimmermann@suse.de>, javierm@redhat.com,
 ardb@kernel.org, ilias.apalodimas@linaro.org,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, simona@ffwll.ch,
 airlied@gmail.com
Cc: dri-devel@lists.freedesktop.org, linux-efi@vger.kernel.org,
 sashiko-reviews@lists.linux.dev, Thomas Zimmermann <tzimmermann@suse.de>
Subject: Re: [PATCH v4 3/3] drm/sysfb: Use preferred panel size for panel
 orientation quirks
In-Reply-To: <20260904090850.43060-4-tzimmermann@suse.de>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park,
 6 krs Bertel Jungin Aukio 5, 02600 Espoo, Finland
References: <20260904090850.43060-1-tzimmermann@suse.de>
 <20260904090850.43060-4-tzimmermann@suse.de>
Date: Fri, 04 Sep 2026 12:41:16 +0300
Message-ID: <e5622c247ffac253ef61cf66ffeeba2f8e36d68d@intel.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, 04 Sep 2026, Thomas Zimmermann <tzimmermann@suse.de> wrote:
> Sysfb drivers currently use the given display mode for looking up the
> panel orientation. But the look-up table stores the native geometry of
> the panels, so the lookup fails if the current mode sizes differs.
>
> Get the panel's native geometry with drm_edid_detect_panel_size() from
> the EDID and use it for looking up the panel orientation.
>
> v2:
> - ofdrm: validate EDID header before using it (Sashiko)
>
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Acked-by: Ard Biesheuvel <ardb@kernel.org>

Acked-by: Jani Nikula <jani.nikula@intel.com>

> ---
>  drivers/gpu/drm/sysfb/efidrm.c  | 17 ++++++++++++++++-
>  drivers/gpu/drm/sysfb/ofdrm.c   | 18 ++++++++++++++++--
>  drivers/gpu/drm/sysfb/vesadrm.c | 17 ++++++++++++++++-
>  3 files changed, 48 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/gpu/drm/sysfb/efidrm.c b/drivers/gpu/drm/sysfb/efidrm.c
> index 3f9cd5d03efb..8b19f437308e 100644
> --- a/drivers/gpu/drm/sysfb/efidrm.c
> +++ b/drivers/gpu/drm/sysfb/efidrm.c
> @@ -152,6 +152,7 @@ static struct efidrm_device *efidrm_device_create(struct drm_driver *drv,
>  	const struct screen_info *si;
>  	const struct drm_format_info *format;
>  	int width, height, stride;
> +	unsigned int panel_width, panel_height;
>  	s64 vsize;
>  	u64 mem_flags;
>  	struct resource resbuf;
> @@ -217,6 +218,20 @@ static struct efidrm_device *efidrm_device_create(struct drm_driver *drv,
>  	if (drm_edid_header_is_valid(dpy->edid.dummy) == 8)
>  		sysfb->edid = dpy->edid.dummy;
>  #endif
> +
> +	panel_width = width;
> +	panel_height = height;
> +
> +	if (sysfb->edid) {
> +		const struct drm_edid *drm_edid;
> +
> +		drm_edid = drm_edid_alloc(sysfb->edid, EDID_LENGTH);
> +		if (drm_edid) {
> +			drm_edid_detect_panel_size(drm_edid, &panel_width, &panel_height);
> +			drm_edid_free(drm_edid);
> +		}
> +	}
> +
>  	sysfb->fb_mode = drm_sysfb_mode(width, height, 0, 0);
>  	sysfb->fb_format = format;
>  	sysfb->fb_pitch = stride;
> @@ -340,7 +355,7 @@ static struct efidrm_device *efidrm_device_create(struct drm_driver *drv,
>  	drm_connector_helper_add(connector, &efidrm_connector_helper_funcs);
>  	drm_connector_set_panel_orientation_with_quirk(connector,
>  						       DRM_MODE_PANEL_ORIENTATION_UNKNOWN,
> -						       width, height);
> +						       panel_width, panel_height);
>  	if (sysfb->edid)
>  		drm_connector_attach_edid_property(connector);
>  
> diff --git a/drivers/gpu/drm/sysfb/ofdrm.c b/drivers/gpu/drm/sysfb/ofdrm.c
> index 9d60db45139c..c41255569854 100644
> --- a/drivers/gpu/drm/sysfb/ofdrm.c
> +++ b/drivers/gpu/drm/sysfb/ofdrm.c
> @@ -229,7 +229,7 @@ static const u8 *display_get_edid_of(struct drm_device *dev, struct device_node
>  {
>  	int ret = of_property_read_u8_array(of_node, "EDID", buf, EDID_LENGTH);
>  
> -	if (ret)
> +	if (ret || drm_edid_header_is_valid(buf) != 8)
>  		return NULL;
>  	return buf;
>  }
> @@ -828,6 +828,7 @@ static struct ofdrm_device *ofdrm_device_create(struct drm_driver *drv,
>  	enum ofdrm_model model;
>  	bool big_endian;
>  	int width, height, depth, linebytes;
> +	unsigned int panel_width, panel_height;
>  	const struct drm_format_info *format;
>  	u64 address;
>  	const u8 *edid;
> @@ -998,6 +999,19 @@ static struct ofdrm_device *ofdrm_device_create(struct drm_driver *drv,
>  		sysfb->fb_gamma_lut_size = OFDRM_GAMMA_LUT_SIZE;
>  	sysfb->edid = edid;
>  
> +	panel_width = width;
> +	panel_height = height;
> +
> +	if (sysfb->edid) {
> +		const struct drm_edid *drm_edid;
> +
> +		drm_edid = drm_edid_alloc(sysfb->edid, EDID_LENGTH);
> +		if (drm_edid) {
> +			drm_edid_detect_panel_size(drm_edid, &panel_width, &panel_height);
> +			drm_edid_free(drm_edid);
> +		}
> +	}
> +
>  	drm_dbg(dev, "display mode={" DRM_MODE_FMT "}\n", DRM_MODE_ARG(&sysfb->fb_mode));
>  	drm_dbg(dev, "framebuffer format=%p4cc, size=%dx%d, linebytes=%d byte\n",
>  		&format->format, width, height, linebytes);
> @@ -1069,7 +1083,7 @@ static struct ofdrm_device *ofdrm_device_create(struct drm_driver *drv,
>  	drm_connector_helper_add(connector, &ofdrm_connector_helper_funcs);
>  	drm_connector_set_panel_orientation_with_quirk(connector,
>  						       DRM_MODE_PANEL_ORIENTATION_UNKNOWN,
> -						       width, height);
> +						       panel_width, panel_height);
>  	if (edid)
>  		drm_connector_attach_edid_property(connector);
>  
> diff --git a/drivers/gpu/drm/sysfb/vesadrm.c b/drivers/gpu/drm/sysfb/vesadrm.c
> index 6a67b2d2e451..f6358a0a68bd 100644
> --- a/drivers/gpu/drm/sysfb/vesadrm.c
> +++ b/drivers/gpu/drm/sysfb/vesadrm.c
> @@ -402,6 +402,7 @@ static struct vesadrm_device *vesadrm_device_create(struct drm_driver *drv,
>  	const struct screen_info *si;
>  	const struct drm_format_info *format;
>  	int width, height, stride;
> +	unsigned int panel_width, panel_height;
>  	s64 vsize;
>  	struct resource resbuf;
>  	struct resource *res;
> @@ -484,6 +485,20 @@ static struct vesadrm_device *vesadrm_device_create(struct drm_driver *drv,
>  	if (drm_edid_header_is_valid(dpy->edid.dummy) == 8)
>  		sysfb->edid = dpy->edid.dummy;
>  #endif
> +
> +	panel_width = width;
> +	panel_height = height;
> +
> +	if (sysfb->edid) {
> +		const struct drm_edid *drm_edid;
> +
> +		drm_edid = drm_edid_alloc(sysfb->edid, EDID_LENGTH);
> +		if (drm_edid) {
> +			drm_edid_detect_panel_size(drm_edid, &panel_width, &panel_height);
> +			drm_edid_free(drm_edid);
> +		}
> +	}
> +
>  	sysfb->fb_mode = drm_sysfb_mode(width, height, 0, 0);
>  	sysfb->fb_format = format;
>  	sysfb->fb_pitch = stride;
> @@ -585,7 +600,7 @@ static struct vesadrm_device *vesadrm_device_create(struct drm_driver *drv,
>  	drm_connector_helper_add(connector, &vesadrm_connector_helper_funcs);
>  	drm_connector_set_panel_orientation_with_quirk(connector,
>  						       DRM_MODE_PANEL_ORIENTATION_UNKNOWN,
> -						       width, height);
> +						       panel_width, panel_height);
>  	if (sysfb->edid)
>  		drm_connector_attach_edid_property(connector);

-- 
Jani Nikula, Intel
