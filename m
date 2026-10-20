Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792495195;
	b=p7T0mxm4TyxU0H42kEbRKbld3y2ApnEeojKVXYpSvzJz9oSFF5GUj8n9ffxRhiBHSYa6
	 6zAbq/qQPFyG0sNGMuG8+bGiE2nqd+gJRatT6lroNfihjJReF3JL/Cip+m/aIhRXt2sDt
	 9U3rkIqxkZV7UiJEt+eTE5JoyHr+A7BdH9DDhi0WtOtbdnYFskJu2py0PLTc3lT9Njfsf
	 RUnXCTCiUpX2WfDwiTzAvq3J61Wi0DyRKc6qihhWMUwJqtHgIUUqD7Jkjuge8Hek5WC/O
	 QpQWmDJOoCRvvgR/HYeKHq2jg67DFMvsiMr5beo0k0RCJR4medsBdrrbK6ViL8He1pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792495195;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Rspamd-Server:
	 X-Rspamd-Queue-Id:X-Rspamd-Action:X-Spam-Level:X-Spamd-Result:
	 X-Spam-Flag:X-Spam-Score;
	bh=XEjT1B8EZxnfEOBDye2fbuQgb1ZJOGqBj60y1y2pLXw=;
	b=Xk3gEnAUsgTmLq4QgS8c/w2699c0QkSSKzb3/TRRgrmh6bydrhTSa8e9kH22R6wpaqH8
	 TxTMCt+6Q9zimmxBsNu4YNUFEhsNAc6l+CH+yilefPBdl4ZY+03wvLg6KMruFmMehbrYB
	 KsVU6pMA0xMdQonHq8YyGYUMePZaOEyd1tPDyLBizxraMoXB1IZtfEyGn072nis6uf7GP
	 jUNEsSiBpT1BNX/6FhKTjRzCOklRmVc5vidcqnMbUUIOexE0dO5V9XwwHfDORetlp/IFA
	 RiTcs2O0ju3DxB7S6PRX5hsLW2WkybE54qIjlc62nCk1kAv3iVvm88peAlxDyDUnNKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=JCFdSIsX;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=r14ipVSh;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=fsmZNRxN;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=7EHCEX8U;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764A8606A31E;
	Tue, 20 Oct 2026 11:19:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 764A8606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=JCFdSIsX;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=r14ipVSh;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=fsmZNRxN;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=7EHCEX8U
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F066A1F7B9;
	Tue, 20 Oct 2026 11:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792495186; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XEjT1B8EZxnfEOBDye2fbuQgb1ZJOGqBj60y1y2pLXw=;
	b=JCFdSIsXsxipfKsQD1Dh11Cqthf+EYHmgkARYwyvYUjEWR1gyBzd/3hB2I564vU5RREThQ
	SbbxHyX2T+J1rDvwkWxVQw242Nhe2rhQbm3HE7OJQKmT0wrz2Kqb/YkfBMc/ko4sO0+H16
	B0vLnEYTgpYMnotzS9V//PUfADPQnQ8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792495186;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XEjT1B8EZxnfEOBDye2fbuQgb1ZJOGqBj60y1y2pLXw=;
	b=r14ipVShQWjgl6SGqyu41VM5MEzOrZlqJRwdsSIN/w1lKHdo4L+0NOWwqVikPLltsUjORZ
	2JSVS7NJiRt7e9Cg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fsmZNRxN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7EHCEX8U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792495185; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XEjT1B8EZxnfEOBDye2fbuQgb1ZJOGqBj60y1y2pLXw=;
	b=fsmZNRxNSBagoJ3FOhVLjYOesNBbsF+DgO33QrHAaO0dLj8vuy9v4m01tHQIXXrbx2vkHd
	ymeloqpZj+Er2L9JYpdCk0Bug1FR1OESBhOvVVkPfx/7Avo8+IyquhYVtVixCH5LToBdEZ
	otQVDsDj/Ny2N19H0xtsqw3PxxF5lV4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792495185;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XEjT1B8EZxnfEOBDye2fbuQgb1ZJOGqBj60y1y2pLXw=;
	b=7EHCEX8UwYa2iPaVQ+6SbdLGrJmnbCRpNnldhtEXCvG+mLQEQ9AinH36tH6oE0F0qrEJlV
	WPfgi6goMEPs8/CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4B7D0136C6;
	Tue, 20 Oct 2026 11:19:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZzVPOVBO12pldQAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Tue, 20 Oct 2026 11:19:45 +0000
Message-ID: <ad6a04b7-cf57-4b22-9c22-85a61af29f1f@suse.de>
Date: Tue, 20 Oct 2026 13:19:44 +0200
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
Subject: Re: [PATCH v5 10/13] drm/client: splash: take the background colour
 from the image source
To: =?UTF-8?Q?M=C3=A0xim_Pedraza_Padilla?= <maximpedraza@gmail.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>
Cc: Francesco Valla <francesco@valla.it>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Mario Limonciello <mario.limonciello@amd.com>,
 Javier Martinez Canillas <javierm@redhat.com>,
 Jocelyn Falempe <jfalempe@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, dri-devel@lists.freedesktop.org,
 devicetree@vger.kernel.org, linux-efi@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-embedded@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261013093243.505776-1-maximpedraza@gmail.com>
 <20261013093243.505776-11-maximpedraza@gmail.com>
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
In-Reply-To: <20261013093243.505776-11-maximpedraza@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: F066A1F7B9
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-3.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[gmail.com,linux.intel.com,kernel.org,ffwll.ch,lwn.net];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[25];
	URIBL_BLOCKED(0.00)[suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:url];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[dt];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.com:url]
X-Spam-Flag: NO
X-Spam-Score: -3.00



Am 13.10.26 um 11:32 schrieb Màxim Pedraza Padilla:
> A logo designed for a light background looks wrong framed in black, and
> products that share a board support package differ in their colours as
> much as in their logos. The background colour belongs with the image,
> so take it from the same place:
>
> - a device tree image uses the optional "background-color" of its node;
> - the BGRT carries no colour, and firmware splashes sit on black, so it
>    uses the kernel's default;

> - the BMP loaded as firmware is named on the command line, and so is its
>    colour, through drm_client_lib.splash_color, which also covers the
>    screen when there is no image at all.

Please see my earlier comment in module parameters.

>
> CONFIG_DRM_CLIENT_SPLASH_BACKGROUND_COLOR remains the default wherever
> the source says nothing. The command line no longer overrides a device
> tree image: a bootloader that wants another colour for a given boot,
> say to flag a failed test on a production line, changes the node.
>
> Assisted-by: Claude:claude-opus-5-5
> Signed-off-by: Màxim Pedraza Padilla <maximpedraza@gmail.com>
> ---
>   drivers/gpu/drm/clients/Kconfig      |  7 ++++--
>   drivers/gpu/drm/clients/drm_splash.c | 36 +++++++++++++++++++++-------
>   2 files changed, 32 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/gpu/drm/clients/Kconfig b/drivers/gpu/drm/clients/Kconfig
> index aef3781cc110..f471019bab87 100644
> --- a/drivers/gpu/drm/clients/Kconfig
> +++ b/drivers/gpu/drm/clients/Kconfig
> @@ -105,8 +105,11 @@ config DRM_CLIENT_SPLASH_BACKGROUND_COLOR
>   	help
>   	  The default splash background color, in RGB888 format.
>   
> -	  The color can be overridden through the drm_client_lib.splash_color
> -	  kernel command line parameter.
> +	  The background color comes from the same place as the image. A
> +	  device tree image can carry its own, and the drm_client_lib.splash_color
> +	  kernel command line parameter sets it for a BMP loaded as firmware,
> +	  or for the whole screen when there is no image. This color is used
> +	  otherwise, and always with the BGRT image, which carries none.
>   
>   config DRM_CLIENT_SPLASH_SRC_DT
>   	bool "Device tree as splash source"
> diff --git a/drivers/gpu/drm/clients/drm_splash.c b/drivers/gpu/drm/clients/drm_splash.c
> index fdf398987007..463aff27c747 100644
> --- a/drivers/gpu/drm/clients/drm_splash.c
> +++ b/drivers/gpu/drm/clients/drm_splash.c
> @@ -42,7 +42,8 @@
>   
>   static unsigned int splash_color = CONFIG_DRM_CLIENT_SPLASH_BACKGROUND_COLOR;
>   module_param(splash_color, uint, 0400);
> -MODULE_PARM_DESC(splash_color, "Splash background color (RGB888)");
> +MODULE_PARM_DESC(splash_color,
> +		 "Background color (RGB888) around the BMP loaded as firmware, or of the whole screen with no image");
>   
>   #if IS_ENABLED(CONFIG_DRM_CLIENT_SPLASH_SRC_BMP)
>   #define DEFAULT_SPLASH_BMP "drm_splash.bmp"
> @@ -133,6 +134,8 @@ struct drm_splash {
>   	s32 off_x, off_y;
>   	/* One of DRM_MODE_ROTATE_*: turns the image, not the screen */
>   	unsigned int rotation;
> +	/* RGB888, from the same place as the image */
> +	u32 bg_color;
>   };
>   
>   static struct drm_splash *client_to_drm_splash(struct drm_client_dev *client)
> @@ -271,12 +274,18 @@ static struct device_node *drm_splash_dt_node(struct drm_splash *splash)
>   	return NULL;
>   }
>   
> -/* The optional placement properties of the node, read once */
> -static void drm_splash_dt_placement(struct drm_splash *splash,
> -				    struct device_node *np)
> +/* The optional properties of the node, read once */
> +static void drm_splash_dt_props(struct drm_splash *splash,
> +				struct device_node *np)
>   {
>   	u32 val[2];
>   
> +	/* The colour travels with the image, or it is the kernel's default */
> +	if (!of_property_read_u32(np, "background-color", &val[0]))
> +		splash->bg_color = val[0] & 0xffffff;
> +	else
> +		splash->bg_color = CONFIG_DRM_CLIENT_SPLASH_BACKGROUND_COLOR;
> +
>   	if (!of_property_read_u32_array(np, "logo-position", val, 2)) {
>   		splash->pos_x = (s32)val[0];
>   		splash->pos_y = (s32)val[1];
> @@ -365,8 +374,8 @@ static struct device_node *drm_splash_dt_node(struct drm_splash *splash)
>   	return NULL;
>   }
>   
> -static void drm_splash_dt_placement(struct drm_splash *splash,
> -				    struct device_node *np)
> +static void drm_splash_dt_props(struct drm_splash *splash,
> +				struct device_node *np)
>   {
>   }
>   
> @@ -780,13 +789,22 @@ static enum drm_splash_source drm_splash_pick_source(struct drm_splash *splash)
>   
>   	np = drm_splash_dt_node(splash);
>   	if (np) {
> -		drm_splash_dt_placement(splash, np);
> +		drm_splash_dt_props(splash, np);
>   		of_node_put(np);
>   		return DRM_SPLASH_SRC_DT;
>   	}
>   
> -	if (drm_splash_bgrt_available(splash))
> +	/* The BGRT carries no colour: firmware splashes sit on black */
> +	if (drm_splash_bgrt_available(splash)) {
> +		splash->bg_color = CONFIG_DRM_CLIENT_SPLASH_BACKGROUND_COLOR;
>   		return DRM_SPLASH_SRC_BGRT;
> +	}
> +
> +	/*
> +	 * The BMP loaded as firmware is named on the command line, and so is
> +	 * its colour, which also covers the screen when there is no image.
> +	 */
> +	splash->bg_color = splash_color & 0xffffff;
>   	if (IS_ENABLED(CONFIG_DRM_CLIENT_SPLASH_SRC_BMP))
>   		return DRM_SPLASH_SRC_BMP;
>   
> @@ -844,7 +862,7 @@ static int drm_splash_render_thread(void *data)
>   
>   			if (!scanout->bg_drawn) {
>   				drm_dbg(client->dev, "draw background for scanout %d", i);
> -				u32 color = drm_draw_color_from_xrgb8888(splash_color,
> +				u32 color = drm_draw_color_from_xrgb8888(splash->bg_color,
>   									 scanout->format);
>   				drm_splash_fill_solid_color(scanout->buffer, color);
>   				scanout->bg_drawn = true;

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Stefan Gaiser, Jochen Jaser, Abhinav Puri, (HRB 36809, AG Nürnberg)


