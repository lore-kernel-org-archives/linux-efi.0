Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76AD341834D
	for <linux-efi@vger.kernel.org>; Thu, 10 Sep 2026 08:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789027811; cv=none; b=dD2s92I+8Y70QWFZBnaBFldtyorw1wZAxm6NTwmYFDsn/wVPzy5Y7zF6mVnheJTQYwz7mBAG07wZuwkLy7N8UwAp63nDxwxeQTiTEVmb/a3fn7B/RE3c1xUgZGdSG+5Yciq6VsYtL+cHe4nM2SRWu3snYKcrqqO7bTkY8Q5bXS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789027811; c=relaxed/simple;
	bh=WkSg7LSexZkUOQ8zOAAVGML9vwe/7hyS7QXw6ngueQo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=REXBWZplLG6aw29ofqmI97UEJWS8O1C4y6qsg4UXGHCxQGzMZ5YpHkytRhU3EFpab1NTEkLd1EpfD3RnThZYn4R6fX4MlZSipvGyytQS8lx+iUof5GgC8JAqUXL/dt1Z15bws0D5lljoRQJ75rUkq+JmtesaeSwQ1zecAnDLXE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b8/ia5ID; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=GmsW+4CE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b8/ia5ID";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="GmsW+4CE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789027808;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ww5DLB2Q6HbTXqc3AvcjNL7DcG0OH+QY3n8HRzmcc6A=;
	b=b8/ia5IDNKCKEF+GkH/YkMBVXtrNeJExGNcQuNM0BcfBmc7Pj+zyE1U46EjnQ201gP0eYW
	DsJ2On/yzVhsKEX/jSPCr4IjjJRaXArBSC+6keXVzhd87jdbHDtnCUtjrVlJ7l2qLixD5I
	IsIUd59lZyq90yO/G680u2cFdcTQiRw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-269-tXBVC0kvMiKzUISWiOgocw-1; Thu, 10 Sep 2026 04:10:07 -0400
X-MC-Unique: tXBVC0kvMiKzUISWiOgocw-1
X-Mimecast-MFC-AGG-ID: tXBVC0kvMiKzUISWiOgocw_1789027806
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4957287363bso51796885e9.0
        for <linux-efi@vger.kernel.org>; Thu, 10 Sep 2026 01:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789027806; x=1789632606; darn=vger.kernel.org;
        h=content-type:mime-version:message-id:date:references:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ww5DLB2Q6HbTXqc3AvcjNL7DcG0OH+QY3n8HRzmcc6A=;
        b=GmsW+4CEGrR/p29wj/9JFKrCg7KhPhVqpQKJlotcbSVRLP3OIwMmJWK+GUGjUbl4kU
         jTdj2k6f2/7W+7oDGPqNHwkpdbmosd3tVHeqxzTO4FU+fzXPekOEMfwTJ2CoERdHRG8n
         T8LMy0VJqmWBdOojsSNxcT6mC9Mv2iNNXBMY+aCtlZ0rX/ifP/43d/rGTQN5k4uWdMRc
         FthU7+ZofercgANDkYatjEKlIPqkORl/PD/g1r8LY+vg29Jink6uPSnwI8vYjJ+su30w
         Xpol6WkPY9uNzYc47imtXcOWRW2QbHMfMmm/t+v2ZFKZmEkrsoaXIBVQcIDvxxaxV8nX
         0wMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789027806; x=1789632606;
        h=content-type:mime-version:message-id:date:references:in-reply-to
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ww5DLB2Q6HbTXqc3AvcjNL7DcG0OH+QY3n8HRzmcc6A=;
        b=psiM/2mfqoGY6JzCMCAuBo1pxfMWcReT7eQzFQTDiQDOv6vsQkdUsxxodI//X64odp
         FN8LvkYULhYAzqurPP40wzL2h3MtCvAOkEJiW7Jp6MekOVjeJRj95ROyPZ3CHJHZPTwB
         dcEYaDhYFDeMywlOEP/vNZdFing6UwmpX1JiHW1XNC6YBKDSFnXywqkGDQGZHncVsKiF
         9+qFblyLxk5X1uhjFFPUQSsU8Qq71tbvw5Mr+ljGmdqP/mWjEwp1zqcINCXSJhiJ4jR3
         uB0ZAIN6j2mLrKuj1xKnlvE+tDZF/3V50IwabbR4ljYRxjJwcepy09bp4sbkLmQNexum
         Vcag==
X-Forwarded-Encrypted: i=1; AKwUvBzwKMgBy/pojkKoyQx1ccd3rG9rioUS/ajOxM/P3BMXGNP5zGpzgA2kOXH46+od+eAXYPltVvFXEXQ=@vger.kernel.org
X-Gm-Message-State: AFuF++m7EUCOuHFvPiPrts92OIRgnnUPSsNslmUTs0hodJLKEKSZMbJ+
	bSW6GsRAw+HVK2gE0kIM/j1S4f3B/96n4Na9OjmN7jpYAGSxVtWAZOYCzC88M2dr2klUQtusx5J
	cM72QY7WPzAG+6TaIMvJb+4phDuafrVLmY2N9wCN+SNEsyHzEQGxLUkrd/nPy7g==
X-Gm-Gg: AYBFou1+wUReHfKRZ0l7veWPt6jvZdZmHylFSV5ekbTIvpCHpUoC9WZqDylnYUzjcZ4
	xDiUGTqUox/bpZddks3fqH6A4hy6oPTeS/IqIasiMPVoFMUpV8VvJsyJ39Oho5w9UVkfqA99Krp
	/bTBl960NI7pmXBKxur/0LtLqrV/zr3z/oUG5Km3USz6NcifmxafARJfb7XOSnCVd/rKq7EooAs
	fd98/oj31oq8IxuhdNChWHNbkNN5xDXil12zsYHjdBuASMlA571LmmxOefKoKLw7Ng/UbMQ4iRa
	pnYynrbnE8HX9yu8FHu21MVMs2QwNpBF/hjChA/Y5BOTPCB2t2O91O1lhDd2bbBqvOVKEbHqeuH
	WMwTJfOjc/smJrp9zkOgy3Gd0IK3WtSYZi/CHvctbf30LiZYw0QHmxRnYyg==
X-Received: by 2002:a05:600c:8715:b0:49c:fa20:cc06 with SMTP id 5b1f17b1804b1-49cfe7a30demr323256385e9.29.1789027805776;
        Thu, 10 Sep 2026 01:10:05 -0700 (PDT)
X-Received: by 2002:a05:600c:8715:b0:49c:fa20:cc06 with SMTP id 5b1f17b1804b1-49cfe7a30demr323255955e9.29.1789027805326;
        Thu, 10 Sep 2026 01:10:05 -0700 (PDT)
Received: from localhost (62-151-111-63.jazzfree.ya.com. [62.151.111.63])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485883953cfsm41228794f8f.13.2026.09.10.01.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 01:10:04 -0700 (PDT)
From: Javier Martinez Canillas <javierm@redhat.com>
To: Thomas Zimmermann <tzimmermann@suse.de>, ardb@kernel.org,
 ilias.apalodimas@linaro.org, jani.nikula@linux.intel.com,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, simona@ffwll.ch,
 airlied@gmail.com
Cc: dri-devel@lists.freedesktop.org, linux-efi@vger.kernel.org,
 sashiko-reviews@lists.linux.dev, Thomas Zimmermann <tzimmermann@suse.de>
Subject: Re: [PATCH v4 2/3] drm/edid: Add drm_edid_detect_panel_size()
In-Reply-To: <20260904090850.43060-3-tzimmermann@suse.de>
References: <20260904090850.43060-1-tzimmermann@suse.de>
 <20260904090850.43060-3-tzimmermann@suse.de>
Date: Thu, 10 Sep 2026 10:10:03 +0200
Message-ID: <87y0d9cysk.fsf@ocarina.mail-host-address-is-not-set>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Thomas Zimmermann <tzimmermann@suse.de> writes:

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

I saw that Jani and you discussed this logic in v3. I originally thought that
your v3 was correct and this one was wrong, but I noticed now that this flag
changed its semantic between 1.3 and 1.4.

So I think that this latest version is correct indeed, 1.3 didn't include the
native pixel format and 1.4 does not either if DRM_EDID_FEATURE_PREFERRED_TIMING
flag is not set.

Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>

-- 
Best regards,

Javier Martinez Canillas
Core Platforms
Red Hat

