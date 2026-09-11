Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E75F433E61
	for <linux-efi@vger.kernel.org>; Fri, 11 Sep 2026 07:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789112131; cv=none; b=FVB8pFdWp+PqRoBvhHID/XvuqCWxJg/DqkLQBGaASYRgbhfkPrVR68o8XVPGcypgYinSwFfyimF3ZcqHD43f1Vd0zc+XAqKsaiSoNZQLPcyTzRSproNH720hNmgHfCHvaNp/RD3ZvcXXF87B+hQxFz0f3Xs0ahhFAPG5Ja2bi1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789112131; c=relaxed/simple;
	bh=J5z51FjHLASY/boVTzhW8lFB+N063Y8l4YjtmCuX5Ss=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ItXsFyzMtEDOcvFgjIhLQHWlgjS9CVRqjxyLB8KViu6b//p7PZLkwNVB5AkwanttvlniL7usEJm23CCUUJWWG8XOSTJiYne9Ac8Cxrle6U+WZKVzNRlU3C/4c8HwCl7/ETdJwJkt8G4TOPfLt9lsOJ4TVDc9Hbe6YjZjAk2UI6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iFSQp0IR; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iFSQp0IR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789112128; x=1820648128;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=J5z51FjHLASY/boVTzhW8lFB+N063Y8l4YjtmCuX5Ss=;
  b=iFSQp0IR5UFNwAUBgnKKHNtrPXyic1KIK+WAsAkO5xw/A4cNUf9P3wO3
   HM4TVLGaKipKmUPmgi4HmF9mbKHs0xZAEzwNZj1IqEEfMcxoWRX/zPDSz
   mYAc1KBFKzttAkt2Sdy1UO/44Yi7pKKGodFBcWsP0DByER+Q96sFBMVDM
   DFyro+Xuc19Yz+3OcLNC/oT3SQJZXQE1qlgoteqK8WK04ya4z0rNPXKmJ
   oLouzQwBoY/xLQ05aGRehHzIsF36MBIPdZUEmCk76mYoW4NG7n/oN4XoZ
   EzviT5MpuMTfDR440UmX5AAoS3hs4gUarALCjavSVBP1VWqK3ARjpLDX7
   A==;
X-CSE-ConnectionGUID: YGNOXcurT/Kpr0p8kqLRJw==
X-CSE-MsgGUID: yzkv9oW0SbO+4gvdi5Q4MA==
X-IronPort-AV: E=McAfee;i="6800,10657,11901"; a="100235860"
X-IronPort-AV: E=Sophos;i="6.27,96,1787036400"; 
   d="scan'208";a="100235860"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2026 00:35:27 -0700
X-CSE-ConnectionGUID: gzBaBml6QnGcfHpFIT4MEw==
X-CSE-MsgGUID: RxWIuRAtQQ+WKoQWUTbPyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,96,1787036400"; 
   d="scan'208";a="301746254"
Received: from ettammin-mobl3.ger.corp.intel.com (HELO localhost) ([10.245.244.127])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2026 00:35:24 -0700
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Javier Martinez Canillas <javierm@redhat.com>, Thomas Zimmermann
 <tzimmermann@suse.de>, ardb@kernel.org, ilias.apalodimas@linaro.org,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, simona@ffwll.ch,
 airlied@gmail.com
Cc: dri-devel@lists.freedesktop.org, linux-efi@vger.kernel.org,
 sashiko-reviews@lists.linux.dev, Thomas Zimmermann <tzimmermann@suse.de>
Subject: Re: [PATCH v4 2/3] drm/edid: Add drm_edid_detect_panel_size()
In-Reply-To: <87y0d9cysk.fsf@ocarina.mail-host-address-is-not-set>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park,
 6 krs Bertel Jungin Aukio 5, 02600 Espoo, Finland
References: <20260904090850.43060-1-tzimmermann@suse.de>
 <20260904090850.43060-3-tzimmermann@suse.de>
 <87y0d9cysk.fsf@ocarina.mail-host-address-is-not-set>
Date: Fri, 11 Sep 2026 10:35:20 +0300
Message-ID: <e34932b2f44659ab8c0843e85b78a60336f9c7ce@intel.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, 10 Sep 2026, Javier Martinez Canillas <javierm@redhat.com> wrote:
> Thomas Zimmermann <tzimmermann@suse.de> writes:
>
>> Add drm_edid_detect_panel_size() to extract the panel's preferred
>> display resolution from a given EDID. Required for setting up DRM's
>> panel orientation quirks in sysfb drivers.
>>
>> v4:
>> - fix test for EDID PTD (Jani)
>> v3:
>> - mention use case in documentation (Jani)
>> - use is_detailed_timing_descriptor() (Jani)
>> - rename helper to drm_edid_detect_panel_size()
>> v2:
>> - handle EDID without pixel timing descriptor (Sashiko)
>> - fix checks for width and height pointers
>>
>> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
>> Acked-by: Ard Biesheuvel <ardb@kernel.org>
>> ---
>>  drivers/gpu/drm/drm_edid.c | 47 ++++++++++++++++++++++++++++++++++++++
>>  include/drm/drm_edid.h     |  2 ++
>>  2 files changed, 49 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
>> index 9990a836d0b6..1331efb4876c 100644
>> --- a/drivers/gpu/drm/drm_edid.c
>> +++ b/drivers/gpu/drm/drm_edid.c
>> @@ -7852,3 +7852,50 @@ bool drm_edid_is_digital(const struct drm_edid *drm_edid)
>>  		drm_edid->edid->input & DRM_EDID_INPUT_DIGITAL;
>>  }
>>  EXPORT_SYMBOL(drm_edid_is_digital);
>> +
>> +/**
>> + * drm_edid_detect_panel_size - Get a panel's size from EDID
>> + * @drm_edid: EDID of the panel.
>> + * @width: Returns the panel's width in pixels per scanline, if given
>> + * @height: Returns the panel's height in scanlines, if given
>> + *
>> + * This function detects the preferred size of a panel from the given
>> + * EDID. There is no such information stored in the EDID block directly,
>> + * but the preferred mode often corresponds to the panel's native geometry.
>> + *
>> + * This helper should only be used during initialization before the
>> + * connector is available. For regular use, retrieve the available display
>> + * modes with the connector functions.
>> + *
>> + * Return: Zero on success, or a negative errno code otherwise.
>> + */
>> +int drm_edid_detect_panel_size(const struct drm_edid *drm_edid,
>> +			       unsigned int *width, unsigned int *height)
>> +{
>> +	const struct edid *edid = drm_edid->edid;
>> +	const struct detailed_timing *dt;
>> +	const struct detailed_pixel_timing *pt;
>> +
>> +	/*
>> +	 * Use display mode from the Preferred Timing Descriptor. For old
>> +	 * and obscure displays, we might need better heuristics.
>> +	 */
>> +
>> +	if (edid->revision < 4 || !(edid->features & DRM_EDID_FEATURE_PREFERRED_TIMING))
>> +		return -EINVAL; /* no Preferred Timing Descriptor */
>> +
>
> I saw that Jani and you discussed this logic in v3. I originally thought that
> your v3 was correct and this one was wrong, but I noticed now that this flag
> changed its semantic between 1.3 and 1.4.
>
> So I think that this latest version is correct indeed, 1.3 didn't include the
> native pixel format and 1.4 does not either if DRM_EDID_FEATURE_PREFERRED_TIMING
> flag is not set.

Yeah, and "pixel format" makes me think RGB, YCbCr, 4:4:4, 4:2:2, etc,
*not* the resolution! Had to separately find the section that says pixel
format means resolution here.

BR,
Jani.

>
> Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>

-- 
Jani Nikula, Intel
