Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB8547D95E
	for <linux-efi@vger.kernel.org>; Wed,  2 Sep 2026 11:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788347210; cv=none; b=TkuZqQZ2VVObvNeHozQJgVYGTHdeiQSjuszKPvdh++DOSkaxfjKPsyMgj7ufwW7Uq1cVvxcIr4Gp0WJKmqMg/TUvfaqxCRGNfiN2mFMe3yx2HTM+2Mw0aTJAHdx6QQYFNuB/NaDff94JL45kBVhpfn5hsKojxqAKrJecuz+YS/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788347210; c=relaxed/simple;
	bh=Q4ImRTjBzBhYse+/OcG6vj8zIBPUtJr8YOhW2BFMIec=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=es+CS04jB70/U57HNqHUjc06iRKLT1gz0h6N177CKQsDM6BJdTUW1NtQ/Vy6u1tO6KXCmwkhgPcDqscBUUsae3X5jYHy9U0G3iSQ5A6jw8Cgg53rdTves0YU6KX7KfqUoZ1RU8rS74EILZzqLkZwAlAf5S9yEJ/0qont1ekr5VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=B1JaIv6E; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=RX4G2UPT; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=zhTUZgxM; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UveK7SZK; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="B1JaIv6E";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="RX4G2UPT";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="zhTUZgxM";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UveK7SZK"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 19D8F21D89;
	Wed,  2 Sep 2026 11:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788347202; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=NDZnR+WrNJW7WgXTyjTEUCWyg16URLKBsflVxpbY274=;
	b=B1JaIv6EciIpqoE1+zd8eYFovsK6ei8NLvzPW/o1yAwLML7z3aOnxf2dy1GvKqk7vh1KCB
	rDGBLx5vYwWbl9uY+aJVvu1ou/jyqZ2nKhrwu6EQnIIMR5s+GGyb7APD7Dp6huetHiN0Xc
	73YsXajGJjcqDkMZle/tpgikJ6rMI28=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788347202;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=NDZnR+WrNJW7WgXTyjTEUCWyg16URLKBsflVxpbY274=;
	b=RX4G2UPT/8+/FSkHkSUfq3pV99x7+d+O5TzFsvCDC+WtbyiZ9xPjilYAsLn6BAUdHIhLlO
	chF63Nd7yfv2YrCw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zhTUZgxM;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=UveK7SZK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788347198; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=NDZnR+WrNJW7WgXTyjTEUCWyg16URLKBsflVxpbY274=;
	b=zhTUZgxMzjUjtbSMNWJxpYMPdCjQdaHMdEzIVoAV9jLIw0zphcx74kkMYycXNRs2EK4Yod
	jIR4EqWLbMNSeDK+1HkJRK91wg+BPUDKQQjrM5t1rjhkft7Ot1GUj9Hq2imjNcqs7IxxaA
	WZAEWecQRDtU6bedNzUrIdcK/uZhxgE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788347198;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=NDZnR+WrNJW7WgXTyjTEUCWyg16URLKBsflVxpbY274=;
	b=UveK7SZKIil3unePiJhKOK0Mia3N1PIs8SVnFz7SyShpiGYJsxvZn6G9sOYKK3AGMLgSAU
	lcMkcqe/s6pdwHDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A652113736;
	Wed,  2 Sep 2026 11:06:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gy4qJz0DmGqGRQAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Wed, 02 Sep 2026 11:06:37 +0000
Message-ID: <32790b27-0b11-4e2c-b3ad-052df38ffded@suse.de>
Date: Wed, 2 Sep 2026 13:06:36 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] drm/edid: Add drm_edid_detect_panel_size()
To: Jani Nikula <jani.nikula@linux.intel.com>, javierm@redhat.com,
 ardb@kernel.org, ilias.apalodimas@linaro.org,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, simona@ffwll.ch,
 airlied@gmail.com
Cc: dri-devel@lists.freedesktop.org, linux-efi@vger.kernel.org,
 sashiko-reviews@lists.linux.dev
References: <20260901082057.37617-1-tzimmermann@suse.de>
 <20260901082057.37617-3-tzimmermann@suse.de>
 <6d2a818833af42b5d9160b7e72822b2d2b4bf04a@intel.com>
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
In-Reply-To: <6d2a818833af42b5d9160b7e72822b2d2b4bf04a@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: 19D8F21D89
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[linux.intel.com,redhat.com,kernel.org,linaro.org,ffwll.ch,gmail.com];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:url];
	URIBL_BLOCKED(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,suse.com:url,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO

Hi

Am 02.09.26 um 10:45 schrieb Jani Nikula:
> On Tue, 01 Sep 2026, Thomas Zimmermann <tzimmermann@suse.de> wrote:
>> Add drm_edid_detect_panel_size() to extract the panel's preferred
>> display resolution from a given EDID. Required for setting up DRM's
>> panel orientation quirks in sysfb drivers.
>>
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
>>   drivers/gpu/drm/drm_edid.c | 47 ++++++++++++++++++++++++++++++++++++++
>>   include/drm/drm_edid.h     |  2 ++
>>   2 files changed, 49 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
>> index 9990a836d0b6..d5d9e77dc91b 100644
>> --- a/drivers/gpu/drm/drm_edid.c
>> +++ b/drivers/gpu/drm/drm_edid.c
>> @@ -7852,3 +7852,50 @@ bool drm_edid_is_digital(const struct drm_edid *drm_edid)
>>   		drm_edid->edid->input & DRM_EDID_INPUT_DIGITAL;
>>   }
>>   EXPORT_SYMBOL(drm_edid_is_digital);
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
>> +	if (edid->revision < 4 && !(edid->features & DRM_EDID_FEATURE_PREFERRED_TIMING))
>> +		return -EINVAL; /* no Preferred Timing Descriptor */
> Okay, so I should've asked this n versions ago, but should that be
> s/&&/||/ instead?

You're right. And I could have sworn that I took this logic from 
somewhere in this file, but that doesn't seem to be the case. Apologies 
for such a stupid mistake.

Best regards
Thomas

>
>> +
>> +	dt = &edid->detailed_timings[0];
>> +
>> +	if (!is_detailed_timing_descriptor(dt))
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
>> +EXPORT_SYMBOL(drm_edid_detect_panel_size);
>> diff --git a/include/drm/drm_edid.h b/include/drm/drm_edid.h
>> index 04f7a7f1f108..a2617aa34edf 100644
>> --- a/include/drm/drm_edid.h
>> +++ b/include/drm/drm_edid.h
>> @@ -490,5 +490,7 @@ u32 drm_edid_get_panel_id(const struct drm_edid *drm_edid);
>>   bool drm_edid_match(const struct drm_edid *drm_edid,
>>   		    const struct drm_edid_ident *ident);
>>   bool drm_edid_has_quirk(struct drm_connector *connector, enum drm_edid_quirk quirk);
>> +int drm_edid_detect_panel_size(const struct drm_edid *drm_edid,
>> +			       unsigned int *width, unsigned int *height);
>>   
>>   #endif /* __DRM_EDID_H__ */

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Jochen Jaser, Andrew McDonald, (HRB 36809, AG Nürnberg)


