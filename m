Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E289E33A02B
	for <linux-efi@vger.kernel.org>; Mon, 31 Aug 2026 13:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788182012; cv=none; b=hKw+ZDpymMiobf5O0Ikkj5U0BVd38HqdE+ZROV0TRpgOwqwm3L5vq4Ykw59k2RL0LjRkUWeryrZiAqK/ugbwx8p3E5MYdS3ZB7R6atlJNMPWgweUfGPNc9ZaEJMlKAlQNxw8PnQK9qY82yjgH88Ty3DZun40fPjOhm8f0r5atmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788182012; c=relaxed/simple;
	bh=gGkEA30qAcCS836tsqMXLUUo1XiCVXjdP7PDl+1MtCU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=JDYK/Zr6G4LDbfJi+lehTxNGnZoqBtPJcSNvwRZ1Hl516iGsRBa9UyNDlwvTnR6lmyoQFWH8/MBNHT2AZhwWnePjWx0ockYro73/+E4LUc/pgXemIsVpsINVXuikM45Ni3yZXDxw/4tv89mqNrfXh9uTMEw7yeO9fwFAZZmRpnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a5mefDxP; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a5mefDxP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788182005; x=1819718005;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=gGkEA30qAcCS836tsqMXLUUo1XiCVXjdP7PDl+1MtCU=;
  b=a5mefDxP3mN5oOJFjrdDTxMkUchR67URR5Eidk6Ewk0e8bJJkOewz/UL
   VFAbPKVe72uzqJEDaKJASx1DJVtmvvRs3k6QRxJF10WurOLOpOhYJ59Gi
   Enff18zpZjyfrzy2AqxY0W0xZlkxwx/8s2RKJkdkoK/a8RGaOo+gdERqV
   tp8veTn8pF6AI2I4vLQuRyCKvRubW3ZOFvJ8rpVyK2fgs08qTrdcPHMHQ
   k8qyhiZGmFwlQobota7If+PbArbCU6CeuL96eYGNBaYwdzAvhXS6QjjfC
   8NuLQ7/oJ0zLxZUNDH4Gpz5ube8ahuBB7StQw1coAM2hO9pVg+vSydAon
   Q==;
X-CSE-ConnectionGUID: qf0YUQ4ZT++sT4Nu6wNGPQ==
X-CSE-MsgGUID: OOlncS9ZSayHmFCZDBMsRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11891"; a="92398757"
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="92398757"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 06:13:25 -0700
X-CSE-ConnectionGUID: gVgP45ggTjaAvHNEXWl+jA==
X-CSE-MsgGUID: 8orwyznRR8+/stM/ePNwiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="293624396"
Received: from abityuts-desk1.ger.corp.intel.com (HELO localhost) ([10.245.244.22])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 06:13:21 -0700
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Thomas Zimmermann <tzimmermann@suse.de>, javierm@redhat.com,
 ardb@kernel.org, ilias.apalodimas@linaro.org,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, simona@ffwll.ch,
 airlied@gmail.com
Cc: dri-devel@lists.freedesktop.org, linux-efi@vger.kernel.org,
 sashiko-reviews@lists.linux.dev, Thomas Zimmermann <tzimmermann@suse.de>
Subject: Re: [PATCH v2 2/3] drm/edid: Add drm_edid_get_preferred_size()
In-Reply-To: <20260831093020.494701-3-tzimmermann@suse.de>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park,
 6 krs Bertel Jungin Aukio 5, 02600 Espoo, Finland
References: <20260831093020.494701-1-tzimmermann@suse.de>
 <20260831093020.494701-3-tzimmermann@suse.de>
Date: Mon, 31 Aug 2026 16:13:19 +0300
Message-ID: <f5f1ab9e6fab9499e49f116369858ee4da626025@intel.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, 31 Aug 2026, Thomas Zimmermann <tzimmermann@suse.de> wrote:
> Add drm_edid_get_preferred_size() to extract the panel's preferred
> display resolution from a given EDID. Required for DRM's panel
> orientation quirks.
>
> v2:
> - handle EDID without pixel timing descriptor (Sashiko)
> - fix checks for width and height pointers
>
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Acked-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  drivers/gpu/drm/drm_edid.c | 46 ++++++++++++++++++++++++++++++++++++++
>  include/drm/drm_edid.h     |  2 ++
>  2 files changed, 48 insertions(+)
>
> diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
> index 9990a836d0b6..53c7eed7a73e 100644
> --- a/drivers/gpu/drm/drm_edid.c
> +++ b/drivers/gpu/drm/drm_edid.c
> @@ -2872,6 +2872,52 @@ u32 drm_edid_get_panel_id(const struct drm_edid *drm_edid)
>  }
>  EXPORT_SYMBOL(drm_edid_get_panel_id);
>  
> +/**
> + * drm_edid_get_preferred_size - Get a panel's preferred size from EDID
> + * @drm_edid: EDID that contains panel ID.
> + * @width: Returns the panel's width in pixels per scanline, if given
> + * @height: Returns the panel's height in scanlines, if given
> + *
> + * This function detects the preferred size of a panel from the given
> + * EDID. There is no such information stored in the EDID block directly,
> + * but the preferred mode often corresponds to the panel's native geometry.

I think the special use case for this function should be mentioned. In
the regular EDID parsing case, the connector will include the modes, one
of them will be preferred, and that should be, uh, preferred.

I dislike adding multiple functions for parsing the same thing, but
looks like it can't be helped here. Let's at least avoid adding users
for this in the paths that can use the normal stuff?

> + *
> + * Return: Zero on success, or a negative errno code otherwise.
> + */
> +int drm_edid_get_preferred_size(const struct drm_edid *drm_edid,
> +				unsigned int *width, unsigned int *height)
> +{
> +	const struct edid *edid = drm_edid->edid;
> +	const struct detailed_timing *dt;
> +	const struct detailed_pixel_timing *pt;
> +
> +	if (drm_edid->size < EDID_LENGTH)
> +		return -EINVAL;

This is guaranteed. drm_edid_alloc() intentionally won't hand you out a
struct drm_edid with size smaller than EDID_LENGTH. Maybe check for
!drm_edid instead.

> +
> +	/*
> +	 * Use display mode from the Preferred Timing Descriptor. For old
> +	 * and obscure displays, we might need better heuristics.
> +	 */
> +
> +	if (edid->revision < 4 && !(edid->features & DRM_EDID_FEATURE_PREFERRED_TIMING))

The preferred timing mode should always be there starting from EDID
1.3. The bit doesn't indicate whether it's there or not. It should be
always set for EDID 1.3, and for EDID 1.4 it indicates whether the
preferred timing includes the native pixel format and the preferred
refresh rate.

I think just if (edid->revision < 3) should be enough.

> +		return -EINVAL; /* no Preferred Timing Descriptor */
> +
> +	dt = &edid->detailed_timings[0];
> +
> +	if (!le16_to_cpu(dt->pixel_clock))

There's is_detailed_timing_descriptor() for this.

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
> +EXPORT_SYMBOL(drm_edid_get_preferred_size);
> +
>  /**
>   * drm_edid_read_base_block - Get a panel's EDID base block
>   * @adapter: I2C adapter to use for DDC
> diff --git a/include/drm/drm_edid.h b/include/drm/drm_edid.h
> index 04f7a7f1f108..981aeeb6ddf9 100644
> --- a/include/drm/drm_edid.h
> +++ b/include/drm/drm_edid.h
> @@ -487,6 +487,8 @@ void drm_edid_get_product_id(const struct drm_edid *drm_edid,
>  void drm_edid_print_product_id(struct drm_printer *p,
>  			       const struct drm_edid_product_id *id, bool raw);
>  u32 drm_edid_get_panel_id(const struct drm_edid *drm_edid);
> +int drm_edid_get_preferred_size(const struct drm_edid *drm_edid,
> +				unsigned int *width, unsigned int *height);
>  bool drm_edid_match(const struct drm_edid *drm_edid,
>  		    const struct drm_edid_ident *ident);
>  bool drm_edid_has_quirk(struct drm_connector *connector, enum drm_edid_quirk quirk);

-- 
Jani Nikula, Intel
