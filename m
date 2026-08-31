Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACC1423799
	for <linux-efi@vger.kernel.org>; Mon, 31 Aug 2026 13:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788182597; cv=none; b=cfV3U5Gn+nT3KF2EnuhY1eac1ScBeTTY2AdwFpTJNkjyeXxFERRGwCDeMwwlCiTcPAFOqkeEvn919Hv7skKJlnsAnW76hT6X55zdp7JOOtoF2cGFJp0IlOYdhWsZtOQgSO52ZsvE7YoWtTfVsf1tSdFdyWDdExcvLJFma1yEpCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788182597; c=relaxed/simple;
	bh=4/mxgQzTZlYhJ8Uu1WVGnWSEOmeRuUU0XS6quLN8b5s=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=A5Plv3mgvXBahDLi+80lUDBvHRhx1KWu54C9YMNj5K4knOQT3d+2SRqImkkVfPhMHzlWdi38EOI2e5dh+uwEuR418U5nwc/SeqJ533nn3NK7yOd69HF1IMn/wldYqW16GE6v7p7m9Y8c5SDpITDn76K+8eCa35pyzd8t05Tbzpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=laZ3y0F2; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="laZ3y0F2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788182595; x=1819718595;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=4/mxgQzTZlYhJ8Uu1WVGnWSEOmeRuUU0XS6quLN8b5s=;
  b=laZ3y0F2uN+xenYv+2GhG8fGFq9YE9amMAJ9RPKW56eMKX5C08SGXVDZ
   dRP4h9+gmvjmTrEVpH3UW+SsWCkhTOhn9owhF5rQrr6RrucwIpToIprdn
   XCeF6jqicqO6d/cqSAfqc+WUuGPqwxDobpH+u6n8J4ejgA6z+Tn66PUhU
   zHK6XYWO0Qc8/olgZKSgSwcMw/AiJGle2RQ55Cyq1xQbRfAJ5A+gZMP68
   Pf1zyTVeK9QIcvfbL9cqrvJ9nY9FlceZV0yNbBlKX42hupy2AS2sB1nYe
   e2ErzlmB1GXM7ui0gusRn5U6JxLkdaREAFzf1TfrLE6egNuKvbJeTVw/2
   A==;
X-CSE-ConnectionGUID: sc8X9nUNS1SINrBCmiwqdQ==
X-CSE-MsgGUID: TF7gOiPWQzetCgehHw0WGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11891"; a="105966386"
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="105966386"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 06:23:15 -0700
X-CSE-ConnectionGUID: lfLZGp65QS6Sh1ZNWZnXIQ==
X-CSE-MsgGUID: lbd71b/ATBO3Q3hCKs0TkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="292301307"
Received: from abityuts-desk1.ger.corp.intel.com (HELO localhost) ([10.245.244.22])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 06:23:12 -0700
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Thomas Zimmermann <tzimmermann@suse.de>, javierm@redhat.com,
 ardb@kernel.org, ilias.apalodimas@linaro.org,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, simona@ffwll.ch,
 airlied@gmail.com
Cc: dri-devel@lists.freedesktop.org, linux-efi@vger.kernel.org,
 sashiko-reviews@lists.linux.dev, Thomas Zimmermann <tzimmermann@suse.de>
Subject: Re: [PATCH v2 3/3] drm/sysfb: Use preferred panel size for panel
 orientation quirks
In-Reply-To: <20260831093020.494701-4-tzimmermann@suse.de>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park,
 6 krs Bertel Jungin Aukio 5, 02600 Espoo, Finland
References: <20260831093020.494701-1-tzimmermann@suse.de>
 <20260831093020.494701-4-tzimmermann@suse.de>
Date: Mon, 31 Aug 2026 16:23:09 +0300
Message-ID: <81d5820013693b38a88084d6818c5809373c16c2@intel.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, 31 Aug 2026, Thomas Zimmermann <tzimmermann@suse.de> wrote:
> Sysfb drivers currently use the given display mode for looking up the
> panel orientation. But the look-up table stores the native geometry of
> the panels, so the lookup fails if the current mode sizes differs.
>
> Get the panel's native geometry with drm_edid_get_preferred_size() from
> the EDID and use it for looking up the panel orientation.
>
> v2:
> - ofdrm: validate EDID header before using it (Sashiko)
>
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Acked-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  drivers/gpu/drm/sysfb/efidrm.c  | 17 ++++++++++++++++-
>  drivers/gpu/drm/sysfb/ofdrm.c   | 18 ++++++++++++++++--
>  drivers/gpu/drm/sysfb/vesadrm.c | 17 ++++++++++++++++-
>  3 files changed, 48 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/gpu/drm/sysfb/efidrm.c b/drivers/gpu/drm/sysfb/efidrm.c
> index 3f9cd5d03efb..7a7d12003304 100644
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
> +			drm_edid_get_preferred_size(drm_edid, &panel_width, &panel_height);
> +			drm_edid_free(drm_edid);
> +		}
> +	}
> +

Unrelated to the patch at hand, but does all of this code assume EDID is
always just one block? Scary. The whole sysfs->edid being a u8 pointer
without size feels like a footgun.

Here, the above should work, but I've been kind of hoping to eradicate
EDID_LENGTH assumptions and calculations from everywhere outside of
drm_edid.c, because it's complicated.


BR,
Jani.


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
> index 9d60db45139c..a0a865aee098 100644
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
> +			drm_edid_get_preferred_size(drm_edid, &panel_width, &panel_height);
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
> index 6a67b2d2e451..8c52bbac6d2f 100644
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
> +			drm_edid_get_preferred_size(drm_edid, &panel_width, &panel_height);
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
