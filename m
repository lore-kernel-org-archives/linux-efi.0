Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AEA751C35D
	for <linux-efi@vger.kernel.org>; Mon, 31 Aug 2026 13:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183825; cv=none; b=o1wLGQcLMq/jO8H9TKtNwEJFHdMOZiCmB+VfnmQUm3EXg5Uj/3V8oele19G4h7PQIpkxIVGvJV0rQKOq6pVP2RMXTHz24/j1WaMkRp1X5zNOp5ctTTsbLIR1Z5GnJp9Hz+vm/yuX4+mThwp4IakebUt6MciOVMS73PJcSYHtho4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183825; c=relaxed/simple;
	bh=KtHcUEidokwEgyATus27k0A9whjwXePvA74qlGrYftI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VnJLtguoOFVRTYnqAZb1GKaeZuVEQRcP+zIgXxtDtdpWafaVEkmc1Yk+ZyxCRhRG7PbumlDWceIywjQfh5vu1yz3HlpeCLL5I/vF4JabMIwjZ88uNWyVdAzk9RBa1QSxqrI59s8jrjhUpU5UJZPnmNIjGRn3yKCrTxqj5jx59+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ypPd5Cbg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+mpBXmlM; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Z4EiA1w2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cJ5vZl/K; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ypPd5Cbg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+mpBXmlM";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Z4EiA1w2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="cJ5vZl/K"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 550E61FD3D;
	Mon, 31 Aug 2026 13:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788183798; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pvDe9DXy2/YFgDABCJ+VWyiyngHjo5GiNuW8ZNScJnQ=;
	b=ypPd5CbgZnCvj3WOTcXl7aANQQY2pGOfla8mevfXX8F4xKeTXSrXHLHHOacYOSfQWgi0/H
	cWw0ETWG13tXyR9nztW35wUS0ROrPOwQ94GagF+b/OlNxOt4lfhffJZI6JaUgntygIGh7Y
	VfMHMTVCeadxgl/dYaIE/zqV/SbNbOQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788183798;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pvDe9DXy2/YFgDABCJ+VWyiyngHjo5GiNuW8ZNScJnQ=;
	b=+mpBXmlMJpxH5Fwf52L9vhiOPlnxzu+cpLQNBfI8Xrc4Ti5UGsyllJqrfByyQ5aaSIgrCz
	AII7/8CI2iXhlTAg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788183794; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pvDe9DXy2/YFgDABCJ+VWyiyngHjo5GiNuW8ZNScJnQ=;
	b=Z4EiA1w2Bd8XibPMFbxMAs1tTVRYS+BypiCGRonbLf54PvaPnr0iHIjlqFYnlckWWsqf+Y
	lfY3SQTJYPfJXuzNCGd+RTILmrjchf3TOPq8/uk8zzV8oRKJ7+Z2TTdPqEZ57GVhaqQbCd
	8Z1lHIo/FDd2ts0TMPzC2zTNmy5c33c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788183794;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pvDe9DXy2/YFgDABCJ+VWyiyngHjo5GiNuW8ZNScJnQ=;
	b=cJ5vZl/K2RC6WB15rabjyfsmcqpxRGOx14DFFj8ogJbjbx+NsYbdVJFVL43bFrrjRF+WMG
	FkvVbI1P505POUDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E22E413515;
	Mon, 31 Aug 2026 13:43:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id p/baNfGElWrQTwAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Mon, 31 Aug 2026 13:43:13 +0000
Message-ID: <abe7ae7c-9df7-44d2-8760-2378fc72cf38@suse.de>
Date: Mon, 31 Aug 2026 15:43:13 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] drm/sysfb: Use preferred panel size for panel
 orientation quirks
To: Jani Nikula <jani.nikula@linux.intel.com>, javierm@redhat.com,
 ardb@kernel.org, ilias.apalodimas@linaro.org,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, simona@ffwll.ch,
 airlied@gmail.com
Cc: dri-devel@lists.freedesktop.org, linux-efi@vger.kernel.org,
 sashiko-reviews@lists.linux.dev
References: <20260831093020.494701-1-tzimmermann@suse.de>
 <20260831093020.494701-4-tzimmermann@suse.de>
 <81d5820013693b38a88084d6818c5809373c16c2@intel.com>
Content-Language: en-US
From: Thomas Zimmermann <tzimmermann@suse.de>
Autocrypt: addr=tzimmermann@suse.de; keydata=
 xsBNBFs50uABCADEHPidWt974CaxBVbrIBwqcq/WURinJ3+2WlIrKWspiP83vfZKaXhFYsdg
 XH47fDVbPPj+d6tQrw5lPQCyqjwrCPYnq3WlIBnGPJ4/jreTL6V+qfKRDlGLWFjZcsrPJGE0
 BeB5BbqP5erN1qylK9i3gPoQjXGhpBpQYwRrEyQyjuvk+Ev0K1Jc5tVDeJAuau3TGNgah4Yc
 hdHm3bkPjz9EErV85RwvImQ1dptvx6s7xzwXTgGAsaYZsL8WCwDaTuqFa1d1jjlaxg6+tZsB
 9GluwvIhSezPgnEmimZDkGnZRRSFiGP8yjqTjjWuf0bSj5rUnTGiyLyRZRNGcXmu6hjlABEB
 AAHNJ1Rob21hcyBaaW1tZXJtYW5uIDx0emltbWVybWFubkBzdXNlLmRlPsLAjgQTAQgAOAIb
 AwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgBYhBHIX+6yM6c9jRKFo5WgNwR1TC3ojBQJftODH
 AAoJEGgNwR1TC3ojx1wH/0hKGWugiqDgLNXLRD/4TfHBEKmxIrmfu9Z5t7vwUKfwhFL6hqvo
 lXPJJKQpQ2z8+X2vZm/slsLn7J1yjrOsoJhKABDi+3QWWSGkaGwRJAdPVVyJMfJRNNNIKwVb
 U6B1BkX2XDKDGffF4TxlOpSQzdtNI/9gleOoUA8+jy8knnDYzjBNOZqLG2FuTdicBXblz0Mf
 vg41gd9kCwYXDnD91rJU8tzylXv03E75NCaTxTM+FBXPmsAVYQ4GYhhgFt8S2UWMoaaABLDe
 7l5FdnLdDEcbmd8uLU2CaG4W2cLrUaI4jz2XbkcPQkqTQ3EB67hYkjiEE6Zy3ggOitiQGcqp
 j//OwE0EWznS4AEIAMYmP4M/V+T5RY5at/g7rUdNsLhWv1APYrh9RQefODYHrNRHUE9eosYb
 T6XMryR9hT8XlGOYRwKWwiQBoWSDiTMo/Xi29jUnn4BXfI2px2DTXwc22LKtLAgTRjP+qbU6
 3Y0xnQN29UGDbYgyyK51DW3H0If2a3JNsheAAK+Xc9baj0LGIc8T9uiEWHBnCH+RdhgATnWW
 GKdDegUR5BkDfDg5O/FISymJBHx2Dyoklv5g4BzkgqTqwmaYzsl8UxZKvbaxq0zbehDda8lv
 hFXodNFMAgTLJlLuDYOGLK2AwbrS3Sp0AEbkpdJBb44qVlGm5bApZouHeJ/+n+7r12+lqdsA
 EQEAAcLAdgQYAQgAIAIbDBYhBHIX+6yM6c9jRKFo5WgNwR1TC3ojBQJftOH6AAoJEGgNwR1T
 C3ojVSkIALpAPkIJPQoURPb1VWjh34l0HlglmYHvZszJWTXYwavHR8+k6Baa6H7ufXNQtThR
 yIxJrQLW6rV5lm7TjhffEhxVCn37+cg0zZ3j7zIsSS0rx/aMwi6VhFJA5hfn3T0TtrijKP4A
 SAQO9xD1Zk9/61JWk8OysuIh7MXkl0fxbRKWE93XeQBhIJHQfnc+YBLprdnxR446Sh8Wn/2D
 Ya8cavuWf2zrB6cZurs048xe0UbSW5AOSo4V9M0jzYI4nZqTmPxYyXbm30Kvmz0rYVRaitYJ
 4kyYYMhuULvrJDMjZRvaNe52tkKAvMevcGdt38H4KSVXAylqyQOW5zvPc4/sq9c=
In-Reply-To: <81d5820013693b38a88084d6818c5809373c16c2@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -4.30
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[linux.intel.com,redhat.com,kernel.org,linaro.org,ffwll.ch,gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:url,suse.de:email,suse.de:mid,bootlin.com:url,imap1.dmz-prg2.suse.org:helo]

Hi

Am 31.08.26 um 15:23 schrieb Jani Nikula:
> On Mon, 31 Aug 2026, Thomas Zimmermann <tzimmermann@suse.de> wrote:
>> Sysfb drivers currently use the given display mode for looking up the
>> panel orientation. But the look-up table stores the native geometry of
>> the panels, so the lookup fails if the current mode sizes differs.
>>
>> Get the panel's native geometry with drm_edid_get_preferred_size() from
>> the EDID and use it for looking up the panel orientation.
>>
>> v2:
>> - ofdrm: validate EDID header before using it (Sashiko)
>>
>> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
>> Acked-by: Ard Biesheuvel <ardb@kernel.org>
>> ---
>>   drivers/gpu/drm/sysfb/efidrm.c  | 17 ++++++++++++++++-
>>   drivers/gpu/drm/sysfb/ofdrm.c   | 18 ++++++++++++++++--
>>   drivers/gpu/drm/sysfb/vesadrm.c | 17 ++++++++++++++++-
>>   3 files changed, 48 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/sysfb/efidrm.c b/drivers/gpu/drm/sysfb/efidrm.c
>> index 3f9cd5d03efb..7a7d12003304 100644
>> --- a/drivers/gpu/drm/sysfb/efidrm.c
>> +++ b/drivers/gpu/drm/sysfb/efidrm.c
>> @@ -152,6 +152,7 @@ static struct efidrm_device *efidrm_device_create(struct drm_driver *drv,
>>   	const struct screen_info *si;
>>   	const struct drm_format_info *format;
>>   	int width, height, stride;
>> +	unsigned int panel_width, panel_height;
>>   	s64 vsize;
>>   	u64 mem_flags;
>>   	struct resource resbuf;
>> @@ -217,6 +218,20 @@ static struct efidrm_device *efidrm_device_create(struct drm_driver *drv,
>>   	if (drm_edid_header_is_valid(dpy->edid.dummy) == 8)
>>   		sysfb->edid = dpy->edid.dummy;
>>   #endif
>> +
>> +	panel_width = width;
>> +	panel_height = height;
>> +
>> +	if (sysfb->edid) {
>> +		const struct drm_edid *drm_edid;
>> +
>> +		drm_edid = drm_edid_alloc(sysfb->edid, EDID_LENGTH);
>> +		if (drm_edid) {
>> +			drm_edid_get_preferred_size(drm_edid, &panel_width, &panel_height);
>> +			drm_edid_free(drm_edid);
>> +		}
>> +	}
>> +
> Unrelated to the patch at hand, but does all of this code assume EDID is
> always just one block? Scary. The whole sysfs->edid being a u8 pointer
> without size feels like a footgun.

For UEFI and VESA it's always one block of 128 bytes in size. The boot 
parameters hard-code this value and there's no space for additional 
blocks. [1]  On OpenFirmware, ofdrm checks the size to be EDID_LENGTH. 
[2] I guess there could more blocks there, but AFAIK the DT property 
only exists on ancient PPC MACs. I have no means of testing, but the 
test file I obtained from such a system is 128 bytes.

[1] 
https://elixir.bootlin.com/linux/v7.2.2/source/arch/x86/include/uapi/asm/bootparam.h#L133
[2] 
https://elixir.bootlin.com/linux/v7.2.2/source/drivers/gpu/drm/sysfb/ofdrm.c#L229


>
> Here, the above should work, but I've been kind of hoping to eradicate
> EDID_LENGTH assumptions and calculations from everywhere outside of
> drm_edid.c, because it's complicated.

We need some way of importing the raw data block into drm_edid.c, which 
in turn needs the buffer size. The drivers could do this without 
EDID_LENGTH if that helps. Note that the drivers use the regular 
machinery from drm_edid.c for dissecting the EDID block. See [3].

[3] 
https://elixir.bootlin.com/linux/v7.2.2/source/drivers/gpu/drm/sysfb/drm_sysfb_modeset.c#L594

Best regards
Thomas


>
>
> BR,
> Jani.
>
>
>>   	sysfb->fb_mode = drm_sysfb_mode(width, height, 0, 0);
>>   	sysfb->fb_format = format;
>>   	sysfb->fb_pitch = stride;
>> @@ -340,7 +355,7 @@ static struct efidrm_device *efidrm_device_create(struct drm_driver *drv,
>>   	drm_connector_helper_add(connector, &efidrm_connector_helper_funcs);
>>   	drm_connector_set_panel_orientation_with_quirk(connector,
>>   						       DRM_MODE_PANEL_ORIENTATION_UNKNOWN,
>> -						       width, height);
>> +						       panel_width, panel_height);
>>   	if (sysfb->edid)
>>   		drm_connector_attach_edid_property(connector);
>>   
>> diff --git a/drivers/gpu/drm/sysfb/ofdrm.c b/drivers/gpu/drm/sysfb/ofdrm.c
>> index 9d60db45139c..a0a865aee098 100644
>> --- a/drivers/gpu/drm/sysfb/ofdrm.c
>> +++ b/drivers/gpu/drm/sysfb/ofdrm.c
>> @@ -229,7 +229,7 @@ static const u8 *display_get_edid_of(struct drm_device *dev, struct device_node
>>   {
>>   	int ret = of_property_read_u8_array(of_node, "EDID", buf, EDID_LENGTH);
>>   
>> -	if (ret)
>> +	if (ret || drm_edid_header_is_valid(buf) != 8)
>>   		return NULL;
>>   	return buf;
>>   }
>> @@ -828,6 +828,7 @@ static struct ofdrm_device *ofdrm_device_create(struct drm_driver *drv,
>>   	enum ofdrm_model model;
>>   	bool big_endian;
>>   	int width, height, depth, linebytes;
>> +	unsigned int panel_width, panel_height;
>>   	const struct drm_format_info *format;
>>   	u64 address;
>>   	const u8 *edid;
>> @@ -998,6 +999,19 @@ static struct ofdrm_device *ofdrm_device_create(struct drm_driver *drv,
>>   		sysfb->fb_gamma_lut_size = OFDRM_GAMMA_LUT_SIZE;
>>   	sysfb->edid = edid;
>>   
>> +	panel_width = width;
>> +	panel_height = height;
>> +
>> +	if (sysfb->edid) {
>> +		const struct drm_edid *drm_edid;
>> +
>> +		drm_edid = drm_edid_alloc(sysfb->edid, EDID_LENGTH);
>> +		if (drm_edid) {
>> +			drm_edid_get_preferred_size(drm_edid, &panel_width, &panel_height);
>> +			drm_edid_free(drm_edid);
>> +		}
>> +	}
>> +
>>   	drm_dbg(dev, "display mode={" DRM_MODE_FMT "}\n", DRM_MODE_ARG(&sysfb->fb_mode));
>>   	drm_dbg(dev, "framebuffer format=%p4cc, size=%dx%d, linebytes=%d byte\n",
>>   		&format->format, width, height, linebytes);
>> @@ -1069,7 +1083,7 @@ static struct ofdrm_device *ofdrm_device_create(struct drm_driver *drv,
>>   	drm_connector_helper_add(connector, &ofdrm_connector_helper_funcs);
>>   	drm_connector_set_panel_orientation_with_quirk(connector,
>>   						       DRM_MODE_PANEL_ORIENTATION_UNKNOWN,
>> -						       width, height);
>> +						       panel_width, panel_height);
>>   	if (edid)
>>   		drm_connector_attach_edid_property(connector);
>>   
>> diff --git a/drivers/gpu/drm/sysfb/vesadrm.c b/drivers/gpu/drm/sysfb/vesadrm.c
>> index 6a67b2d2e451..8c52bbac6d2f 100644
>> --- a/drivers/gpu/drm/sysfb/vesadrm.c
>> +++ b/drivers/gpu/drm/sysfb/vesadrm.c
>> @@ -402,6 +402,7 @@ static struct vesadrm_device *vesadrm_device_create(struct drm_driver *drv,
>>   	const struct screen_info *si;
>>   	const struct drm_format_info *format;
>>   	int width, height, stride;
>> +	unsigned int panel_width, panel_height;
>>   	s64 vsize;
>>   	struct resource resbuf;
>>   	struct resource *res;
>> @@ -484,6 +485,20 @@ static struct vesadrm_device *vesadrm_device_create(struct drm_driver *drv,
>>   	if (drm_edid_header_is_valid(dpy->edid.dummy) == 8)
>>   		sysfb->edid = dpy->edid.dummy;
>>   #endif
>> +
>> +	panel_width = width;
>> +	panel_height = height;
>> +
>> +	if (sysfb->edid) {
>> +		const struct drm_edid *drm_edid;
>> +
>> +		drm_edid = drm_edid_alloc(sysfb->edid, EDID_LENGTH);
>> +		if (drm_edid) {
>> +			drm_edid_get_preferred_size(drm_edid, &panel_width, &panel_height);
>> +			drm_edid_free(drm_edid);
>> +		}
>> +	}
>> +
>>   	sysfb->fb_mode = drm_sysfb_mode(width, height, 0, 0);
>>   	sysfb->fb_format = format;
>>   	sysfb->fb_pitch = stride;
>> @@ -585,7 +600,7 @@ static struct vesadrm_device *vesadrm_device_create(struct drm_driver *drv,
>>   	drm_connector_helper_add(connector, &vesadrm_connector_helper_funcs);
>>   	drm_connector_set_panel_orientation_with_quirk(connector,
>>   						       DRM_MODE_PANEL_ORIENTATION_UNKNOWN,
>> -						       width, height);
>> +						       panel_width, panel_height);
>>   	if (sysfb->edid)
>>   		drm_connector_attach_edid_property(connector);

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Jochen Jaser, Andrew McDonald, (HRB 36809, AG Nürnberg)


