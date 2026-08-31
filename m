Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705CA4D2EC6
	for <linux-efi@vger.kernel.org>; Mon, 31 Aug 2026 14:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185524; cv=none; b=parR1/ppQv+wylinT0XikaiJiOHhFpcgr4dDCVRzUAV23/r8HhJsa7hlyhrCWRXRioxN+w1AvPauqtAJrUCm+9S+emADYRGBBkpCv+Zo6RsgDYlGkpvdb3m4r3ful1bxA9TiWf8ueG1SkaF2yZ2sYgg9kERXirjGRjX09RQp4gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185524; c=relaxed/simple;
	bh=HWPIBWzzbMwumgFMc17vWU1woudco/zjK0YqQJv0io0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=kzO6cU9qyRMmJ9EPS/2EJlp7gsV5uMIXgkDE1g3sHTvmnpRtIlu/4Yap+ExfijoUscUU2WrxNdaT8dx1yPNjWQxmVkttoAaOtV/mbABeGojoXYuQb5IvLdHW/mZM51ziJTcE+RlNNAYlrW/ej0UFQkTJMPKdTjmtNipGXHI6q0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ebXZQqIz; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ebXZQqIz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788185522; x=1819721522;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=HWPIBWzzbMwumgFMc17vWU1woudco/zjK0YqQJv0io0=;
  b=ebXZQqIzFrvNFH6pHlmTCQZK1gZaoN8H0sAlqxxaL3qfyYxSudC+82EI
   v9uZgsT7wK/lxXTmp/R7j9Xf+O8FC7lf2dyrovTEZ8LxmrsoslR40feD6
   5z74Ph4WMW4XNSyJjYQ9xcogY12PVo4H53gfEzNKSpTta4rVUCHMFgxn3
   cEPJrwzzE2qU952pxI7JbUfVZrGJhSrr5EYodUXXWrdqYhfVALvpKUMy6
   5Mcn7i2KUVPebJPqRTnrIIvm6MhuSf1/gCBQbQVpAOl3Zy/GG+kYeSW2u
   lYSSC9RfEO8s9Jm4F5BNRml/Uw1mPDcYr7sd6Cvr6duQk/L60e+mZYVvJ
   w==;
X-CSE-ConnectionGUID: ZPDlJoKrQM62TiCk29xrwA==
X-CSE-MsgGUID: 645O81+hTgKFSFYz4CLe8A==
X-IronPort-AV: E=McAfee;i="6800,10657,11891"; a="92403399"
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="92403399"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 07:12:01 -0700
X-CSE-ConnectionGUID: D5dIK2cQQPCScyCrBeUCIQ==
X-CSE-MsgGUID: FdFGga3oRZ+6F2o1qpQk+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="274079290"
Received: from abityuts-desk1.ger.corp.intel.com (HELO localhost) ([10.245.244.22])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 07:11:58 -0700
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Thomas Zimmermann <tzimmermann@suse.de>, javierm@redhat.com,
 ardb@kernel.org, ilias.apalodimas@linaro.org,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, simona@ffwll.ch,
 airlied@gmail.com
Cc: dri-devel@lists.freedesktop.org, linux-efi@vger.kernel.org,
 sashiko-reviews@lists.linux.dev
Subject: Re: [PATCH v2 3/3] drm/sysfb: Use preferred panel size for panel
 orientation quirks
In-Reply-To: <abe7ae7c-9df7-44d2-8760-2378fc72cf38@suse.de>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park,
 6 krs Bertel Jungin Aukio 5, 02600 Espoo, Finland
References: <20260831093020.494701-1-tzimmermann@suse.de>
 <20260831093020.494701-4-tzimmermann@suse.de>
 <81d5820013693b38a88084d6818c5809373c16c2@intel.com>
 <abe7ae7c-9df7-44d2-8760-2378fc72cf38@suse.de>
Date: Mon, 31 Aug 2026 17:11:56 +0300
Message-ID: <f48489c047930ee02295a3f3f3b61258f57e86c8@intel.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, 31 Aug 2026, Thomas Zimmermann <tzimmermann@suse.de> wrote:
> Hi
>
> Am 31.08.26 um 15:23 schrieb Jani Nikula:
>> On Mon, 31 Aug 2026, Thomas Zimmermann <tzimmermann@suse.de> wrote:
>>> Sysfb drivers currently use the given display mode for looking up the
>>> panel orientation. But the look-up table stores the native geometry of
>>> the panels, so the lookup fails if the current mode sizes differs.
>>>
>>> Get the panel's native geometry with drm_edid_get_preferred_size() from
>>> the EDID and use it for looking up the panel orientation.
>>>
>>> v2:
>>> - ofdrm: validate EDID header before using it (Sashiko)
>>>
>>> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
>>> Acked-by: Ard Biesheuvel <ardb@kernel.org>
>>> ---
>>>   drivers/gpu/drm/sysfb/efidrm.c  | 17 ++++++++++++++++-
>>>   drivers/gpu/drm/sysfb/ofdrm.c   | 18 ++++++++++++++++--
>>>   drivers/gpu/drm/sysfb/vesadrm.c | 17 ++++++++++++++++-
>>>   3 files changed, 48 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/gpu/drm/sysfb/efidrm.c b/drivers/gpu/drm/sysfb/efi=
drm.c
>>> index 3f9cd5d03efb..7a7d12003304 100644
>>> --- a/drivers/gpu/drm/sysfb/efidrm.c
>>> +++ b/drivers/gpu/drm/sysfb/efidrm.c
>>> @@ -152,6 +152,7 @@ static struct efidrm_device *efidrm_device_create(s=
truct drm_driver *drv,
>>>   	const struct screen_info *si;
>>>   	const struct drm_format_info *format;
>>>   	int width, height, stride;
>>> +	unsigned int panel_width, panel_height;
>>>   	s64 vsize;
>>>   	u64 mem_flags;
>>>   	struct resource resbuf;
>>> @@ -217,6 +218,20 @@ static struct efidrm_device *efidrm_device_create(=
struct drm_driver *drv,
>>>   	if (drm_edid_header_is_valid(dpy->edid.dummy) =3D=3D 8)
>>>   		sysfb->edid =3D dpy->edid.dummy;
>>>   #endif
>>> +
>>> +	panel_width =3D width;
>>> +	panel_height =3D height;
>>> +
>>> +	if (sysfb->edid) {
>>> +		const struct drm_edid *drm_edid;
>>> +
>>> +		drm_edid =3D drm_edid_alloc(sysfb->edid, EDID_LENGTH);
>>> +		if (drm_edid) {
>>> +			drm_edid_get_preferred_size(drm_edid, &panel_width, &panel_height);
>>> +			drm_edid_free(drm_edid);
>>> +		}
>>> +	}
>>> +
>> Unrelated to the patch at hand, but does all of this code assume EDID is
>> always just one block? Scary. The whole sysfs->edid being a u8 pointer
>> without size feels like a footgun.
>
> For UEFI and VESA it's always one block of 128 bytes in size. The boot=20
> parameters hard-code this value and there's no space for additional=20
> blocks. [1]=C2=A0 On OpenFirmware, ofdrm checks the size to be EDID_LENGT=
H.=20
> [2] I guess there could more blocks there, but AFAIK the DT property=20
> only exists on ancient PPC MACs. I have no means of testing, but the=20
> test file I obtained from such a system is 128 bytes.
>
> [1]=20
> https://elixir.bootlin.com/linux/v7.2.2/source/arch/x86/include/uapi/asm/=
bootparam.h#L133
> [2]=20
> https://elixir.bootlin.com/linux/v7.2.2/source/drivers/gpu/drm/sysfb/ofdr=
m.c#L229
>
>
>>
>> Here, the above should work, but I've been kind of hoping to eradicate
>> EDID_LENGTH assumptions and calculations from everywhere outside of
>> drm_edid.c, because it's complicated.
>
> We need some way of importing the raw data block into drm_edid.c, which=20
> in turn needs the buffer size. The drivers could do this without=20
> EDID_LENGTH if that helps. Note that the drivers use the regular=20
> machinery from drm_edid.c for dissecting the EDID block. See [3].
>
> [3]=20
> https://elixir.bootlin.com/linux/v7.2.2/source/drivers/gpu/drm/sysfb/drm_=
sysfb_modeset.c#L594

Okay, thanks for the pointers.

BR,
Jani.


>
> Best regards
> Thomas
>
>
>>
>>
>> BR,
>> Jani.
>>
>>
>>>   	sysfb->fb_mode =3D drm_sysfb_mode(width, height, 0, 0);
>>>   	sysfb->fb_format =3D format;
>>>   	sysfb->fb_pitch =3D stride;
>>> @@ -340,7 +355,7 @@ static struct efidrm_device *efidrm_device_create(s=
truct drm_driver *drv,
>>>   	drm_connector_helper_add(connector, &efidrm_connector_helper_funcs);
>>>   	drm_connector_set_panel_orientation_with_quirk(connector,
>>>   						       DRM_MODE_PANEL_ORIENTATION_UNKNOWN,
>>> -						       width, height);
>>> +						       panel_width, panel_height);
>>>   	if (sysfb->edid)
>>>   		drm_connector_attach_edid_property(connector);
>>>=20=20=20
>>> diff --git a/drivers/gpu/drm/sysfb/ofdrm.c b/drivers/gpu/drm/sysfb/ofdr=
m.c
>>> index 9d60db45139c..a0a865aee098 100644
>>> --- a/drivers/gpu/drm/sysfb/ofdrm.c
>>> +++ b/drivers/gpu/drm/sysfb/ofdrm.c
>>> @@ -229,7 +229,7 @@ static const u8 *display_get_edid_of(struct drm_dev=
ice *dev, struct device_node
>>>   {
>>>   	int ret =3D of_property_read_u8_array(of_node, "EDID", buf, EDID_LEN=
GTH);
>>>=20=20=20
>>> -	if (ret)
>>> +	if (ret || drm_edid_header_is_valid(buf) !=3D 8)
>>>   		return NULL;
>>>   	return buf;
>>>   }
>>> @@ -828,6 +828,7 @@ static struct ofdrm_device *ofdrm_device_create(str=
uct drm_driver *drv,
>>>   	enum ofdrm_model model;
>>>   	bool big_endian;
>>>   	int width, height, depth, linebytes;
>>> +	unsigned int panel_width, panel_height;
>>>   	const struct drm_format_info *format;
>>>   	u64 address;
>>>   	const u8 *edid;
>>> @@ -998,6 +999,19 @@ static struct ofdrm_device *ofdrm_device_create(st=
ruct drm_driver *drv,
>>>   		sysfb->fb_gamma_lut_size =3D OFDRM_GAMMA_LUT_SIZE;
>>>   	sysfb->edid =3D edid;
>>>=20=20=20
>>> +	panel_width =3D width;
>>> +	panel_height =3D height;
>>> +
>>> +	if (sysfb->edid) {
>>> +		const struct drm_edid *drm_edid;
>>> +
>>> +		drm_edid =3D drm_edid_alloc(sysfb->edid, EDID_LENGTH);
>>> +		if (drm_edid) {
>>> +			drm_edid_get_preferred_size(drm_edid, &panel_width, &panel_height);
>>> +			drm_edid_free(drm_edid);
>>> +		}
>>> +	}
>>> +
>>>   	drm_dbg(dev, "display mode=3D{" DRM_MODE_FMT "}\n", DRM_MODE_ARG(&sy=
sfb->fb_mode));
>>>   	drm_dbg(dev, "framebuffer format=3D%p4cc, size=3D%dx%d, linebytes=3D=
%d byte\n",
>>>   		&format->format, width, height, linebytes);
>>> @@ -1069,7 +1083,7 @@ static struct ofdrm_device *ofdrm_device_create(s=
truct drm_driver *drv,
>>>   	drm_connector_helper_add(connector, &ofdrm_connector_helper_funcs);
>>>   	drm_connector_set_panel_orientation_with_quirk(connector,
>>>   						       DRM_MODE_PANEL_ORIENTATION_UNKNOWN,
>>> -						       width, height);
>>> +						       panel_width, panel_height);
>>>   	if (edid)
>>>   		drm_connector_attach_edid_property(connector);
>>>=20=20=20
>>> diff --git a/drivers/gpu/drm/sysfb/vesadrm.c b/drivers/gpu/drm/sysfb/ve=
sadrm.c
>>> index 6a67b2d2e451..8c52bbac6d2f 100644
>>> --- a/drivers/gpu/drm/sysfb/vesadrm.c
>>> +++ b/drivers/gpu/drm/sysfb/vesadrm.c
>>> @@ -402,6 +402,7 @@ static struct vesadrm_device *vesadrm_device_create=
(struct drm_driver *drv,
>>>   	const struct screen_info *si;
>>>   	const struct drm_format_info *format;
>>>   	int width, height, stride;
>>> +	unsigned int panel_width, panel_height;
>>>   	s64 vsize;
>>>   	struct resource resbuf;
>>>   	struct resource *res;
>>> @@ -484,6 +485,20 @@ static struct vesadrm_device *vesadrm_device_creat=
e(struct drm_driver *drv,
>>>   	if (drm_edid_header_is_valid(dpy->edid.dummy) =3D=3D 8)
>>>   		sysfb->edid =3D dpy->edid.dummy;
>>>   #endif
>>> +
>>> +	panel_width =3D width;
>>> +	panel_height =3D height;
>>> +
>>> +	if (sysfb->edid) {
>>> +		const struct drm_edid *drm_edid;
>>> +
>>> +		drm_edid =3D drm_edid_alloc(sysfb->edid, EDID_LENGTH);
>>> +		if (drm_edid) {
>>> +			drm_edid_get_preferred_size(drm_edid, &panel_width, &panel_height);
>>> +			drm_edid_free(drm_edid);
>>> +		}
>>> +	}
>>> +
>>>   	sysfb->fb_mode =3D drm_sysfb_mode(width, height, 0, 0);
>>>   	sysfb->fb_format =3D format;
>>>   	sysfb->fb_pitch =3D stride;
>>> @@ -585,7 +600,7 @@ static struct vesadrm_device *vesadrm_device_create=
(struct drm_driver *drv,
>>>   	drm_connector_helper_add(connector, &vesadrm_connector_helper_funcs);
>>>   	drm_connector_set_panel_orientation_with_quirk(connector,
>>>   						       DRM_MODE_PANEL_ORIENTATION_UNKNOWN,
>>> -						       width, height);
>>> +						       panel_width, panel_height);
>>>   	if (sysfb->edid)
>>>   		drm_connector_attach_edid_property(connector);

--=20
Jani Nikula, Intel
