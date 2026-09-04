Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7683B2FFB
	for <linux-efi@vger.kernel.org>; Fri,  4 Sep 2026 09:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788514110; cv=none; b=Vgq+tXa9O92fjYjMv63lSTIkiM9R9EgBZZr+TyrH9rgie8xdRNbsaY73iEOflH0lxFcRtT+Sr1HBU/sb0L657y5CwIjVbC2NbSJwui8QF5GkyEr0GN0dr2BKOnqPE3TGlvVxc02KHzi+78dPvLjO3MXh3UxXuvBfHI1ZnRY8jsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788514110; c=relaxed/simple;
	bh=ntiVxOLOr7AIxMpDgx+NOZVUpb8mIfroaaZgQ/Tw6KE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=mfg2YhlrcfOy8xPIze0YLJtDRv+G3nXJ+RtKNjGxK5N/YZScEOOzTyQ3pBiKxXoIjqSPZn8z4egN6FBJf5Rum7WWS1xVDCoQmlkA83VhP1ZioHsI2qZN+xscKEZKONKFGlhi24wUvrIY0lCEli5u5N5V6xwjrEVavSzWH4+gFtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gGvtmonE; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gGvtmonE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788514107; x=1820050107;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=ntiVxOLOr7AIxMpDgx+NOZVUpb8mIfroaaZgQ/Tw6KE=;
  b=gGvtmonEHGJVlTDd8J4OQdHis5ESZDXK27f9Y0tmHi7B15V1FfLNyCNw
   dI2D4KfoSS77bPxOnbh81LTHpiHnZoZBE9Bu0MmPK1PVV2t6yKU3DX3N0
   z/7dXcC6ZB4oCMYFchD/OHBd2Aho6pxn8Ou4Ezs393zg6rmvzrtMLOPMj
   eOdNVsNCoaYs/GOM+3hZcHuSBvpd191eLpAgViWeJ3cxP/uKG6gpOYM8o
   XdjUGD7+CCJa3cVu6TM/t8r/+QCOUWvVthJF2hQ7J3phddVw76kRzAUVy
   Xy6vurIe5TuBWvja3MJJDqkW9tA/veZsMFDt9zrHSBndpTlNOsMKJnuZo
   w==;
X-CSE-ConnectionGUID: YEZZqPxQSVGcj3zanYNrqQ==
X-CSE-MsgGUID: /2SnYSoSS9ePNzwxrRUN5A==
X-IronPort-AV: E=McAfee;i="6800,10657,11895"; a="92833199"
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="92833199"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2026 02:28:26 -0700
X-CSE-ConnectionGUID: gNZwmO8aQzmUjLg5UUFUpQ==
X-CSE-MsgGUID: RvhOfUz2TAKzjmhupCoXOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="293498852"
Received: from abityuts-desk1.ger.corp.intel.com (HELO localhost) ([10.245.245.29])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2026 02:28:24 -0700
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Thomas Zimmermann <tzimmermann@suse.de>, javierm@redhat.com,
 ardb@kernel.org, ilias.apalodimas@linaro.org,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, simona@ffwll.ch,
 airlied@gmail.com
Cc: dri-devel@lists.freedesktop.org, linux-efi@vger.kernel.org,
 sashiko-reviews@lists.linux.dev, Thomas Zimmermann <tzimmermann@suse.de>
Subject: Re: [PATCH v4 2/3] drm/edid: Add drm_edid_detect_panel_size()
In-Reply-To: <20260904090850.43060-3-tzimmermann@suse.de>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park,
 6 krs Bertel Jungin Aukio 5, 02600 Espoo, Finland
References: <20260904090850.43060-1-tzimmermann@suse.de>
 <20260904090850.43060-3-tzimmermann@suse.de>
Date: Fri, 04 Sep 2026 12:28:21 +0300
Message-ID: <78772b0911f1cab7d79b8fdcd41defd15deb9cac@intel.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, 04 Sep 2026, Thomas Zimmermann <tzimmermann@suse.de> wrote:
> Add drm_edid_detect_panel_size() to extract the panel's preferred
> display resolution from a given EDID. Required for setting up DRM's
> panel orientation quirks in sysfb drivers.
>
> v4:
> - fix test for EDID PTD (Jani)
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

Given my shoddy comments before, not sure what it's worth, but,

Reviewed-by: Jani Nikula <jani.nikula@intel.com>

> ---
>  drivers/gpu/drm/drm_edid.c | 47 ++++++++++++++++++++++++++++++++++++++
>  include/drm/drm_edid.h     |  2 ++
>  2 files changed, 49 insertions(+)
>
> diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
> index 9990a836d0b6..1331efb4876c 100644
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
> +	if (edid->revision < 4 || !(edid->features & DRM_EDID_FEATURE_PREFERRED_TIMING))
> +		return -EINVAL; /* no Preferred Timing Descriptor */
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
