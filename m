Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0E5431A23
	for <linux-efi@vger.kernel.org>; Mon, 31 Aug 2026 13:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183077; cv=none; b=VYpJlfhdExBQUpLNZrd8p7R8GoyfjpI9SzaZTSGzHr63TR3bYRZOeBJOkTYbz9ZdYZvL3Ksk4Z9DI3rZIRXV+L4PGQmIYWy/7KhmV18ROOmBwCNnNekoeTXgbaSyoGYFJfD2dQl7+AupHBxDdJJQDWT2PowCnF/VLlrDeKTpnLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183077; c=relaxed/simple;
	bh=MAC1oBqBWClyqwhBFLkrPPD+2eM0WWYA6Mx8DrG3vhw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m2thNetFD2Ss72V461L1HKaAwJr56pCpexH/hBrY3fvHebkUtCbrJUOxXtONK93ImPTZsigIhYiBMsVsaPbCkjkGRrtgNmDXKmVvtXRQ9eNenuTAm1fr+IN6OsSB/xf2QlE7Z6y+lnnS+5b0lcyBNtPk8S0EpyAhfzHlPBVaStM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=x1yoRMDe; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Y/3CfRAl; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=V7shmypE; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VFEyb77a; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="x1yoRMDe";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Y/3CfRAl";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="V7shmypE";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VFEyb77a"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 135F721ABC;
	Mon, 31 Aug 2026 13:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788183067; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=NOMBgcLmNkBzpWIcVR1RbS+oZh+lwqeib1q4qSeu3nQ=;
	b=x1yoRMDeN5OAhvSucXGLLhqM4ZHs8dtbQo7jT3FoeMhsBaeXr8fgboKmoYHZX3I1mSjfgJ
	ex4M59ds3rgEkOU4r8dwerFnbMMHtNWrX4w18omCxSdxH9SuVEBeouNun5a33D3UBsL6am
	YuQ9QN6nWeRRTxd4XgsJzZ+TBsuGaQg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788183067;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=NOMBgcLmNkBzpWIcVR1RbS+oZh+lwqeib1q4qSeu3nQ=;
	b=Y/3CfRAlmKxSZWb+d9L6IijQ6m6T5c4XipJVcNsdTsBsa4L1iws5knT6ZFTLrX9tO7fwS6
	dsuQAi5hx7iem7Ag==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788183063; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=NOMBgcLmNkBzpWIcVR1RbS+oZh+lwqeib1q4qSeu3nQ=;
	b=V7shmypE5mW7yFs3Zw2hTzw2T2PjuplphBd31Vt9pYOPcnDaBph4as87RKqeiQJ1m1H5hv
	xnGBIn1fhnXMNWKY0IA0GcL1QeC82ku5Zr5QMw7RGp2rycsJxgRbQMo/Bwk1X2DgF92mwD
	2oyJ55EJBDeyna2uXj3oCiEYHzI2id8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788183063;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=NOMBgcLmNkBzpWIcVR1RbS+oZh+lwqeib1q4qSeu3nQ=;
	b=VFEyb77anAFIGFJPudPEEvOYifvGJ7qFmRQZkaVLVAD3IR0BsyrQyvbw/65mv8IWRRX4cj
	QYzA/fJryyJv4RBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AA7D3136B2;
	Mon, 31 Aug 2026 13:31:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id //BwKBaClWp+QwAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Mon, 31 Aug 2026 13:31:02 +0000
Message-ID: <4645113d-3b31-4d92-b392-5d5284225211@suse.de>
Date: Mon, 31 Aug 2026 15:31:02 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] drm/edid: Add drm_edid_get_preferred_size()
To: Jani Nikula <jani.nikula@linux.intel.com>, javierm@redhat.com,
 ardb@kernel.org, ilias.apalodimas@linaro.org,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, simona@ffwll.ch,
 airlied@gmail.com
Cc: dri-devel@lists.freedesktop.org, linux-efi@vger.kernel.org,
 sashiko-reviews@lists.linux.dev
References: <20260831093020.494701-1-tzimmermann@suse.de>
 <20260831093020.494701-3-tzimmermann@suse.de>
 <f5f1ab9e6fab9499e49f116369858ee4da626025@intel.com>
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
In-Reply-To: <f5f1ab9e6fab9499e49f116369858ee4da626025@intel.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,suse.com:url,imap1.dmz-prg2.suse.org:helo]

Hi

Am 31.08.26 um 15:13 schrieb Jani Nikula:
> On Mon, 31 Aug 2026, Thomas Zimmermann <tzimmermann@suse.de> wrote:
>> Add drm_edid_get_preferred_size() to extract the panel's preferred
>> display resolution from a given EDID. Required for DRM's panel
>> orientation quirks.
>>
>> v2:
>> - handle EDID without pixel timing descriptor (Sashiko)
>> - fix checks for width and height pointers
>>
>> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
>> Acked-by: Ard Biesheuvel <ardb@kernel.org>
>> ---
>>   drivers/gpu/drm/drm_edid.c | 46 ++++++++++++++++++++++++++++++++++++++
>>   include/drm/drm_edid.h     |  2 ++
>>   2 files changed, 48 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
>> index 9990a836d0b6..53c7eed7a73e 100644
>> --- a/drivers/gpu/drm/drm_edid.c
>> +++ b/drivers/gpu/drm/drm_edid.c
>> @@ -2872,6 +2872,52 @@ u32 drm_edid_get_panel_id(const struct drm_edid *drm_edid)
>>   }
>>   EXPORT_SYMBOL(drm_edid_get_panel_id);
>>   
>> +/**
>> + * drm_edid_get_preferred_size - Get a panel's preferred size from EDID
>> + * @drm_edid: EDID that contains panel ID.
>> + * @width: Returns the panel's width in pixels per scanline, if given
>> + * @height: Returns the panel's height in scanlines, if given
>> + *
>> + * This function detects the preferred size of a panel from the given
>> + * EDID. There is no such information stored in the EDID block directly,
>> + * but the preferred mode often corresponds to the panel's native geometry.
> I think the special use case for this function should be mentioned. In
> the regular EDID parsing case, the connector will include the modes, one
> of them will be preferred, and that should be, uh, preferred.
>
> I dislike adding multiple functions for parsing the same thing, but
> looks like it can't be helped here. Let's at least avoid adding users
> for this in the paths that can use the normal stuff?

Absolutely.  The only reason I added this helper is that the driver 
needs the size for setting up the display pipeline before the connector 
exists. I looked into using the existing code without the connector, but 
that refactoring seemed to do more harm than good. Hence the new helper.

Should the new function be named drm_edid_detect_panel_size() to signal 
the use case?


>
>> + *
>> + * Return: Zero on success, or a negative errno code otherwise.
>> + */
>> +int drm_edid_get_preferred_size(const struct drm_edid *drm_edid,
>> +				unsigned int *width, unsigned int *height)
>> +{
>> +	const struct edid *edid = drm_edid->edid;
>> +	const struct detailed_timing *dt;
>> +	const struct detailed_pixel_timing *pt;
>> +
>> +	if (drm_edid->size < EDID_LENGTH)
>> +		return -EINVAL;
> This is guaranteed. drm_edid_alloc() intentionally won't hand you out a
> struct drm_edid with size smaller than EDID_LENGTH. Maybe check for
> !drm_edid instead.

Ok.

>
>> +
>> +	/*
>> +	 * Use display mode from the Preferred Timing Descriptor. For old
>> +	 * and obscure displays, we might need better heuristics.
>> +	 */
>> +
>> +	if (edid->revision < 4 && !(edid->features & DRM_EDID_FEATURE_PREFERRED_TIMING))
> The preferred timing mode should always be there starting from EDID
> 1.3. The bit doesn't indicate whether it's there or not. It should be
> always set for EDID 1.3, and for EDID 1.4 it indicates whether the
> preferred timing includes the native pixel format and the preferred
> refresh rate.
>
> I think just if (edid->revision < 3) should be enough.

Ok

>
>> +		return -EINVAL; /* no Preferred Timing Descriptor */
>> +
>> +	dt = &edid->detailed_timings[0];
>> +
>> +	if (!le16_to_cpu(dt->pixel_clock))
> There's is_detailed_timing_descriptor() for this.

Great!

Best regards
Thomas

>
>> +		return -EINVAL;
>> +
>> +	pt = &dt->data.pixel_data;
>> +
>> +	if (width)
>> +		*width = (pt->hactive_hblank_hi & 0xf0) << 4 | pt->hactive_lo;
>> +	if (height)
>> +		*height = (pt->vactive_vblank_hi & 0xf0) << 4 | pt->vactive_lo;
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL(drm_edid_get_preferred_size);
>> +
>>   /**
>>    * drm_edid_read_base_block - Get a panel's EDID base block
>>    * @adapter: I2C adapter to use for DDC
>> diff --git a/include/drm/drm_edid.h b/include/drm/drm_edid.h
>> index 04f7a7f1f108..981aeeb6ddf9 100644
>> --- a/include/drm/drm_edid.h
>> +++ b/include/drm/drm_edid.h
>> @@ -487,6 +487,8 @@ void drm_edid_get_product_id(const struct drm_edid *drm_edid,
>>   void drm_edid_print_product_id(struct drm_printer *p,
>>   			       const struct drm_edid_product_id *id, bool raw);
>>   u32 drm_edid_get_panel_id(const struct drm_edid *drm_edid);
>> +int drm_edid_get_preferred_size(const struct drm_edid *drm_edid,
>> +				unsigned int *width, unsigned int *height);
>>   bool drm_edid_match(const struct drm_edid *drm_edid,
>>   		    const struct drm_edid_ident *ident);
>>   bool drm_edid_has_quirk(struct drm_connector *connector, enum drm_edid_quirk quirk);

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Jochen Jaser, Andrew McDonald, (HRB 36809, AG Nürnberg)


