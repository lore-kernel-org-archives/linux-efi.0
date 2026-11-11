Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794404588;
	b=hJvgjRnW30xkQsBz3hWeoYYsqNNosWY+KLlFAQ1uA2E3sELDNPwVJkbIckS5YPyo1ovw
	 UnOGW/kcEXLnQR2kX/uC0TwvZOE7IltU4oefsSbiMBpfOOkAXe3KW7pjk6hCuqUUQyHzj
	 iNpxkMU8jXquSzYueMdwiEaANEfQ0q5p+3QD/QDmgbO5nWlvpgd4OVlOKMNRNWPIVvRaD
	 sZ+yEOq+gZyLeoIeRU2EUUahRQi4iAlFWAaCQ1wlqTUMc/07YSD1gf3AKypI1ymkPhwqs
	 8Sjlf2bBorXqDKDaSHI2b4iigBXKzvoZ+kzaAak0RgTLE9Xm/kw6yLa5GnZJjkHPl5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794404588;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=gBW4ewbMTG6RG9hWValIfTxQoON66XUwaxu1E612AK0=;
	b=vJ29cNKxJ/IDBEk3EbikoMQU+8fT9xYQDoHqVhUgs44vYtBqi+h73tDH76e7fHiNyes+
	 nwrsTWva5Z/fQr/vaDpO3gtzvimCtR9+1PsZpegjIwcV2g2ZrVAah+Qs7kNwS3IvNWFM3
	 MezjjjgJj8iOsD8M8R5N1ZzCScomDOIDTu4NJdNKF3vLc6K4LApA/kG0tNIwp5ARVbIsj
	 eM486UGg21Fvf4q3EqE2pi+3kLdqCtUp8xF9Nmls6BRpn2rhZPL6JJf0xKfVJYj/gZRQk
	 /h1blKfxChBfC2cOCuhZus3vu3Lf9PRXHCCbyIBDFSHXZJ7HWw4Yde6RvQAXxG7J+2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=nCJHLJSH;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=HltmtrYc;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b="ZqMFgX/Y";
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=kSurVkYJ;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92CA606A331;
	Wed, 11 Nov 2026 13:43:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A92CA606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=nCJHLJSH;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=HltmtrYc;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=ZqMFgX/Y;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=kSurVkYJ
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C1A005CD45;
	Wed, 11 Nov 2026 13:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794404578; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gBW4ewbMTG6RG9hWValIfTxQoON66XUwaxu1E612AK0=;
	b=nCJHLJSHmwetqnRekosDQH3pW0NXodCbj5AHXg2bajivqcMdFbHe3X+6Kjh4xwUS5C3riS
	izaX5wyF4Mk8xdl+hnBkSZDsT6u1w61M4J5jG/80/dIkMQzLED0hAd4kPNsVIZAxb4XK0A
	IOLwJYTgCtmax6j1TEYQFLDxXtzGpQU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794404578;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gBW4ewbMTG6RG9hWValIfTxQoON66XUwaxu1E612AK0=;
	b=HltmtrYcdBKzJla3QuYhHR3mK6Mfp6J1+2MNQ7gHSPMrZxiN6zGQTOCICr2XajaBlRP/aZ
	EN0fc3nZkamHFzCg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="ZqMFgX/Y";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=kSurVkYJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794404577; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gBW4ewbMTG6RG9hWValIfTxQoON66XUwaxu1E612AK0=;
	b=ZqMFgX/Ycvj0V6D7whtErBY4t0j61F7Nu9eWp7O8VRLMjoEgydkBWkFvMHQvzjw0Wqlk8w
	kYMOo09J0n6vu0HQHcCkbToT10nnIhepXA5p9ZXrkwUp3AaTKXwuHT7uE4r3Gi5sjeE03b
	/QEh4F7EVGf2SgUnUL84Olt3dwsjnPc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794404577;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gBW4ewbMTG6RG9hWValIfTxQoON66XUwaxu1E612AK0=;
	b=kSurVkYJsIz/A7tx1thcSWtnZkSFgZO/pTOaWGQqDfgiBUI4kYwZkS7txD7cR/aYOQgrVn
	brOagByGJ553hdDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F01331339F;
	Wed, 11 Nov 2026 13:42:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id utsxMeBw9GpeXwAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Wed, 11 Nov 2026 13:42:56 +0000
Message-ID: <8eaf9955-485f-4908-bb65-1e0c3184fb36@suse.de>
Date: Wed, 11 Nov 2026 14:42:56 +0100
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 08/15] drm/client: splash: pick the image source in one
 place
To: =?UTF-8?Q?M=C3=A0xim_Pedraza_Padilla?= <maximpedraza@gmail.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Helge Deller <deller@gmx.de>,
 Peter Jones <pjones@redhat.com>
Cc: Francesco Valla <francesco@valla.it>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Mario Limonciello <mario.limonciello@amd.com>,
 Javier Martinez Canillas <javierm@redhat.com>,
 Jocelyn Falempe <jfalempe@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, dri-devel@lists.freedesktop.org,
 devicetree@vger.kernel.org, linux-efi@vger.kernel.org,
 linux-fbdev@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261027135342.2003632-1-maximpedraza@gmail.com>
 <20261027135342.2003632-9-maximpedraza@gmail.com>
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
In-Reply-To: <20261027135342.2003632-9-maximpedraza@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-12.00 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,gmx.de];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[28];
	FREEMAIL_TO(0.00)[gmail.com,linux.intel.com,kernel.org,ffwll.ch,lwn.net,gmx.de,redhat.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[dt];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:url,suse.de:email,suse.de:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.00
X-Spam-Level: 
X-Rspamd-Queue-Id: C1A005CD45

Hi

Am 27.10.26 um 14:53 schrieb Màxim Pedraza Padilla:
> The client chooses between two sources with a boolean: the BGRT if the
> firmware left one, otherwise the BMP loaded as firmware. A third one is
> coming, and with it an order of preference that a boolean cannot hold.
>
> Name the source in use with an enum, picked once by
> drm_splash_pick_source(), and have drm_splash_image_load() switch on
> it. No functional change.
>
> Suggested-by: Thomas Zimmermann <tzimmermann@suse.de>
> Assisted-by: Claude:claude-opus-5-5
> Signed-off-by: Màxim Pedraza Padilla <maximpedraza@gmail.com>
> ---
>   drivers/gpu/drm/clients/drm_splash.c | 45 +++++++++++++++++++++++-----
>   1 file changed, 38 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/gpu/drm/clients/drm_splash.c b/drivers/gpu/drm/clients/drm_splash.c
> index 337c7160c4a1..911149b92a52 100644
> --- a/drivers/gpu/drm/clients/drm_splash.c
> +++ b/drivers/gpu/drm/clients/drm_splash.c
> @@ -39,6 +39,16 @@
>    * a static image.
>    */
>   
> +/*
> + * Where the image comes from. drm_splash_pick_source() sets the order of
> + * preference; NONE is zero, so that a new splash starts without a source.
> + */
> +enum drm_splash_source {
> +	DRM_SPLASH_SRC_NONE,
> +	DRM_SPLASH_SRC_BGRT,
> +	DRM_SPLASH_SRC_BMP,

I'd call this DRM_SPLASH_SRC_FW, because that's what you're loading 
from.  Although the format is a BMP, BMP is also the format of BGRT.

Patch 4 already mixed this up. Renaming the BMP names there to FW seems 
sensible.

The rest of the patch looks good.

> +};
> +
>   struct drm_splash_scanout {
>   	int id;
>   	/* Modesets scanning this buffer out, by position in the list */
> @@ -87,7 +97,7 @@ struct drm_splash {
>   	const struct firmware *fw;
>   	void *map_data;
>   
> -	bool use_bgrt;
> +	enum drm_splash_source src;
>   };
>   
>   static struct drm_splash *client_to_drm_splash(struct drm_client_dev *client)
> @@ -429,7 +439,7 @@ static int drm_splash_bmp_to_scanout(struct drm_splash *splash,
>   		return -EINVAL;
>   	}
>   
> -	if (splash->use_bgrt) {
> +	if (splash->src == DRM_SPLASH_SRC_BGRT) {
>   		x_pad = efi_bgrt_image_offset_x();
>   		y_pad = efi_bgrt_image_offset_y();
>   
> @@ -498,10 +508,31 @@ static int drm_splash_bmp_to_scanout(struct drm_splash *splash,
>   static int drm_splash_image_load(struct drm_splash *splash, const u8 **img_data,
>   				 size_t *img_data_len)
>   {
> -	if (splash->use_bgrt)
> +	switch (splash->src) {
> +	case DRM_SPLASH_SRC_BGRT:
>   		return drm_splash_bgrt_load(splash, img_data, img_data_len);
> +	case DRM_SPLASH_SRC_BMP:
> +		return drm_splash_fw_load(splash, img_data, img_data_len);
> +	case DRM_SPLASH_SRC_NONE:
> +		break;
> +	}
> +
> +	return -ENOENT;
> +}
> +
> +/*
> + * Pick the one source the image will come from: the BGRT is whatever the
> + * firmware shows, and the BMP loaded as firmware is the fallback. With
> + * neither, only the background colour is drawn.
> + */
> +static enum drm_splash_source drm_splash_pick_source(struct drm_splash *splash)
> +{
> +	if (drm_splash_bgrt_available(splash))
> +		return DRM_SPLASH_SRC_BGRT;
> +	if (IS_ENABLED(CONFIG_DRM_CLIENT_SPLASH_SRC_BMP))
> +		return DRM_SPLASH_SRC_BMP;
>   
> -	return drm_splash_fw_load(splash, img_data, img_data_len);
> +	return DRM_SPLASH_SRC_NONE;
>   }
>   
>   /* At unregister, once nothing else can use the image */
> @@ -818,10 +849,10 @@ static int drm_splash_client_hotplug(struct drm_client_dev *client)
>   
>   	if (!splash->source_picked) {
>   		splash->source_picked = true;
> -		splash->use_bgrt = drm_splash_bgrt_available(splash);
> +		splash->src = drm_splash_pick_source(splash);
>   
> -		/* If no other image has been loaded, try to load a BMP as firmware */
> -		if (IS_ENABLED(CONFIG_DRM_CLIENT_SPLASH_SRC_BMP) && !splash->use_bgrt) {
> +		/* The BMP loaded as firmware is the only source that arrives later */
> +		if (splash->src == DRM_SPLASH_SRC_BMP) {
>   			ret = drm_splash_fw_request_bmp(splash);
>   			splash->fw_requested = !ret;
>   			if (ret)

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Stefan Gaiser, Jochen Jaser, Abhinav Puri, (HRB 36809, AG Nürnberg)


