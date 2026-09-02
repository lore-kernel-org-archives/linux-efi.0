Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47293F3276
	for <linux-efi@vger.kernel.org>; Wed,  2 Sep 2026 08:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788338748; cv=none; b=HlCrtz6xNPyRuPCw0c1if4s3gISFvbWv+JeRsOAe8B5ujMzG9Hu5PF6NP1fiXIxF/9s5N53CtEWdPPxBKgPjW3+X3zm+jvUGFhzBL/7wwIvRRKGTwtjoBuka9wZSy2vEgPGB2TawuSzdkMrd3eR43OLIH2CBe95BzBZMOUpyp+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788338748; c=relaxed/simple;
	bh=5IORO+Q20OWL7KmEpNWvWv2Q4ojrAuwXm8g14vC5f38=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=TlfCQZgCLJ84epTET7yf7iOF10UvMm8qzRFi1sF/4UdNvn4Q4oMYJFDiYvt8mW/h6QKKLDKDOVc0GnGf3qKsrQGANB0J4yJUsRbg3e7QPRnfikp2Pl1Yo+AXCXJ+VrJWw8R8hc1OiCFelZc0PPQZbfMidNAxKAnFqv5z9rB0sVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gVNBOIt3; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gVNBOIt3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788338746; x=1819874746;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=5IORO+Q20OWL7KmEpNWvWv2Q4ojrAuwXm8g14vC5f38=;
  b=gVNBOIt3R3H0W8QIpE0gmmJDeT91dTT9zIXkI/+Susun6NoI9F7oLkLf
   b0QlH79MpQ3M6ISCbXj/8FrH1d6yjg9NGcNEFpkmAdTsm1quwarEIHeKw
   uqB5jjrld7fW9vTvH27kIcGY36K359gi9+Tmk4ZLVgQWTu0xhqEj9fv8t
   mL+V97xFcv+3qMWaxBcX05J79oehoRQ/GMvdxIZP7wF067FvF/fs18bcz
   OuiAfXniPioGCO1bDUhj7kFG4OhlxD2nKi8fvk1f4yoNLEAk7ZyGEao1n
   Vk0P+viLu8QklJPj5lCSJUiVOkMglCqJswEFynJmHVybGOGeW9UQhYrwd
   Q==;
X-CSE-ConnectionGUID: CHCRFjgUTsmKxrUOumG9+g==
X-CSE-MsgGUID: CUqGuGpnQne77gKBiH+ahA==
X-IronPort-AV: E=McAfee;i="6800,10657,11893"; a="92657973"
X-IronPort-AV: E=Sophos;i="6.25,257,1779174000"; 
   d="scan'208";a="92657973"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 01:45:46 -0700
X-CSE-ConnectionGUID: SgDu0KLKSjaPPOP1bxc0qA==
X-CSE-MsgGUID: /H76fkTkTvWMVrahOPWn9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,257,1779174000"; 
   d="scan'208";a="265052650"
Received: from hrotuna-mobl2.ger.corp.intel.com (HELO localhost) ([10.245.245.84])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 01:45:38 -0700
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Thomas Zimmermann <tzimmermann@suse.de>, javierm@redhat.com,
 ardb@kernel.org, ilias.apalodimas@linaro.org,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, simona@ffwll.ch,
 airlied@gmail.com
Cc: dri-devel@lists.freedesktop.org, linux-efi@vger.kernel.org,
 sashiko-reviews@lists.linux.dev, Thomas Zimmermann <tzimmermann@suse.de>
Subject: Re: [PATCH v3 2/3] drm/edid: Add drm_edid_detect_panel_size()
In-Reply-To: <20260901082057.37617-3-tzimmermann@suse.de>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park,
 6 krs Bertel Jungin Aukio 5, 02600 Espoo, Finland
References: <20260901082057.37617-1-tzimmermann@suse.de>
 <20260901082057.37617-3-tzimmermann@suse.de>
Date: Wed, 02 Sep 2026 11:45:36 +0300
Message-ID: <6d2a818833af42b5d9160b7e72822b2d2b4bf04a@intel.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, 01 Sep 2026, Thomas Zimmermann <tzimmermann@suse.de> wrote:
> Add drm_edid_detect_panel_size() to extract the panel's preferred
> display resolution from a given EDID. Required for setting up DRM's
> panel orientation quirks in sysfb drivers.
>
> v3:
> - mention use case in documentation (Jani)
> - use is_detailed_timing_descriptor() (Jani)
> - rename helper to drm_edid_detect_panel_size()
> v2:
> - handle EDID without pixel timing descriptor (Sashiko)
> - fix checks for width and height pointers
>
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Acked-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  drivers/gpu/drm/drm_edid.c | 47 ++++++++++++++++++++++++++++++++++++++
>  include/drm/drm_edid.h     |  2 ++
>  2 files changed, 49 insertions(+)
>
> diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
> index 9990a836d0b6..d5d9e77dc91b 100644
> --- a/drivers/gpu/drm/drm_edid.c
> +++ b/drivers/gpu/drm/drm_edid.c
> @@ -7852,3 +7852,50 @@ bool drm_edid_is_digital(const struct drm_edid *drm_edid)
>  		drm_edid->edid->input & DRM_EDID_INPUT_DIGITAL;
>  }
>  EXPORT_SYMBOL(drm_edid_is_digital);
> +
> +/**
> + * drm_edid_detect_panel_size - Get a panel's size from EDID
> + * @drm_edid: EDID of the panel.
> + * @width: Returns the panel's width in pixels per scanline, if given
> + * @height: Returns the panel's height in scanlines, if given
> + *
> + * This function detects the preferred size of a panel from the given
> + * EDID. There is no such information stored in the EDID block directly,
> + * but the preferred mode often corresponds to the panel's native geometry.
> + *
> + * This helper should only be used during initialization before the
> + * connector is available. For regular use, retrieve the available display
> + * modes with the connector functions.
> + *
> + * Return: Zero on success, or a negative errno code otherwise.
> + */
> +int drm_edid_detect_panel_size(const struct drm_edid *drm_edid,
> +			       unsigned int *width, unsigned int *height)
> +{
> +	const struct edid *edid = drm_edid->edid;
> +	const struct detailed_timing *dt;
> +	const struct detailed_pixel_timing *pt;
> +
> +	/*
> +	 * Use display mode from the Preferred Timing Descriptor. For old
> +	 * and obscure displays, we might need better heuristics.
> +	 */
> +
> +	if (edid->revision < 4 && !(edid->features & DRM_EDID_FEATURE_PREFERRED_TIMING))
> +		return -EINVAL; /* no Preferred Timing Descriptor */

Okay, so I should've asked this n versions ago, but should that be
s/&&/||/ instead?

> +
> +	dt = &edid->detailed_timings[0];
> +
> +	if (!is_detailed_timing_descriptor(dt))
> +		return -EINVAL;
> +
> +	pt = &dt->data.pixel_data;
> +
> +	if (width)
> +		*width = (pt->hactive_hblank_hi & 0xf0) << 4 | pt->hactive_lo;
> +	if (height)
> +		*height = (pt->vactive_vblank_hi & 0xf0) << 4 | pt->vactive_lo;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(drm_edid_detect_panel_size);
> diff --git a/include/drm/drm_edid.h b/include/drm/drm_edid.h
> index 04f7a7f1f108..a2617aa34edf 100644
> --- a/include/drm/drm_edid.h
> +++ b/include/drm/drm_edid.h
> @@ -490,5 +490,7 @@ u32 drm_edid_get_panel_id(const struct drm_edid *drm_edid);
>  bool drm_edid_match(const struct drm_edid *drm_edid,
>  		    const struct drm_edid_ident *ident);
>  bool drm_edid_has_quirk(struct drm_connector *connector, enum drm_edid_quirk quirk);
> +int drm_edid_detect_panel_size(const struct drm_edid *drm_edid,
> +			       unsigned int *width, unsigned int *height);
>  
>  #endif /* __DRM_EDID_H__ */

-- 
Jani Nikula, Intel
