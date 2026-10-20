Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792495573;
	b=uRVYNH0tfNfJqrvGEbbrBoZzOMssY1v3nSup1KFGGLtdXE8wwnNEZBelrcJ/yw/FqzLd
	 1/ksyVFPJbajDUIT+9DKZILuboWQ7IpooFimexogqJxMEvbLxjR1Go+8n42tDSrNHYR3M
	 Us5sgKA1sUZQppXK3v0Fm5mHPVmMm0b6A9H7bOWR04xXuADaf+8314czNNxjpl7zrYP7q
	 rkigN7nUbDZDRoyaO10rPYzD8Xb6W8q6FnsXTQ3GLTGSxgcqbsIjItLC6vwFV63hNZFZy
	 W8D4UNK5wg8DiXiN4w7PXyJia5C77BJjF7OXoGIEmliqIPOR5fJtgaH65dMvlMDdI+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792495573;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Rspamd-Server:
	 X-Rspamd-Queue-Id:X-Rspamd-Action:X-Spam-Level:X-Spamd-Result:
	 X-Spam-Flag:X-Spam-Score;
	bh=3Bh/yigK0wnqf2PiEoDr8Kp6MfaSzg09nKtrR09P/QY=;
	b=jgYEH5P2r1y+7JiXzMb5zPqhQCwwr5F3SoYHs09u7hlGxJ+wB/wApoR2U+vs1bqJSJoL
	 6sY5oYqc1rtkUUJVWn0p5YFDKlwCN4cX9OaS31cZJNjyNcTDmz/6IXSnVZcHEsrVUsLiU
	 eoqAoUM3AiAaVIMwockSz1F4xv+3C3UekFbuz+sh7nrWr+h000ea0gcJwkfimF39cslq9
	 DV/wn8pQ13HQQv7lOjBfjPFzAA5h6QMnB0aCiF6TUfa0iDpdfsnGVoslbSwo1GpSgOGP9
	 j5oUylezQm+PDkHJQ7ZbFFycRkqAAPfjQTnTa8VRppTTfw1JrY6gxs254jf3XXahHbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=hefTJ58l;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=hGMedScA;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=pjUX1hjV;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=eI7m6fyF;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B4C606A323;
	Tue, 20 Oct 2026 11:26:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 71B4C606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=hefTJ58l;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=hGMedScA;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=pjUX1hjV;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=eI7m6fyF
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EA9FD1F7B6;
	Tue, 20 Oct 2026 11:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792495562; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3Bh/yigK0wnqf2PiEoDr8Kp6MfaSzg09nKtrR09P/QY=;
	b=hefTJ58lVAjj0wg1BVr3Cyed0Mc5nxOeR+NWICINitGNes9vym623Fvy8B/Dytc01dU560
	+cCuCQvdgA2FF3TUBMJ4at9hwObzRXlem0eZ1rLze0H2YDkOUqMuF0VGbQIBu/4vMr8nMB
	rlWHFzCAZZ3PyvY1GCwclJSCZWBpdE4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792495562;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3Bh/yigK0wnqf2PiEoDr8Kp6MfaSzg09nKtrR09P/QY=;
	b=hGMedScAhlC0EZW2VKC0V/Mxd10ogjWSidRurlPo4nh+Xh38ntd6v+KjPlmaGu2o4m5iMY
	+vFVj59d0KWGiWAQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pjUX1hjV;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eI7m6fyF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792495561; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3Bh/yigK0wnqf2PiEoDr8Kp6MfaSzg09nKtrR09P/QY=;
	b=pjUX1hjV6BsXOyHI3eUEbBRDxt/hu28xMaECE3Fgn125+uiH/12hs7Zcl1kQQ+2dvmnbLR
	Yt/kq9+Xh4+H2EhH+eDLUvYwHlqQI3FIlCzus3YqkAwQIHADnWH3MtNrJqw9lT0HkANgdR
	OtxEDnK7OCT/zWiMXgoIjfH23SYeZu0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792495561;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3Bh/yigK0wnqf2PiEoDr8Kp6MfaSzg09nKtrR09P/QY=;
	b=eI7m6fyFB6C6WHfVrE8mPCPj0lz1HPjTJ80NdVASqw5+h0L+slbPNYHRwM8UuXMqfN65T/
	eEddlnjS0DET+XBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 37980136C6;
	Tue, 20 Oct 2026 11:26:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6qvGNshP12qwewAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Tue, 20 Oct 2026 11:26:01 +0000
Message-ID: <45b55f94-0cd2-425b-b985-ba3958502b06@suse.de>
Date: Tue, 20 Oct 2026 13:26:00 +0200
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
Subject: Re: [PATCH v5 12/13] drm/client: splash: prefer what the command line
 asks for
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
 <20261013093243.505776-13-maximpedraza@gmail.com>
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
In-Reply-To: <20261013093243.505776-13-maximpedraza@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: EA9FD1F7B6
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[suse.com:url,suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[25];
	FREEMAIL_TO(0.00)[gmail.com,linux.intel.com,kernel.org,ffwll.ch,lwn.net];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[dt];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:url,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim]
X-Spam-Flag: NO
X-Spam-Score: -3.00



Am 13.10.26 um 11:32 schrieb Màxim Pedraza Padilla:
> A logo or a colour given on the kernel command line was asked for this
> very boot: a bootloader that picks the product variant from an EEPROM
> and passes it along, a developer, or a production line that turns the
> screen red when a test fails. The device tree, the BGRT and the kernel's
> defaults describe what the board or the build normally wants. Let the
> command line win, as console= wins over stdout-path.

Please see my earlier comments on module parameters.

>
> Each parameter wins for what it says, and only when it is given, so
> none has a default of its own:
>
> - drm_client_lib.splash_bmp names a BMP to load as firmware, preferred
>    over the device tree and the BGRT. Without it the order is unchanged:
>    device tree, BGRT, then "drm_splash.bmp" loaded as firmware. An empty
>    value counts as not given. A file that is named but missing gives no
>    image rather than falling back, since it is what was asked for.
>
> - drm_client_lib.splash_bmp=none asks for no image at all: only the
>    background is drawn, whatever the other sources have.
>
> - drm_client_lib.splash_pos=X,Y, splash_offset=DX,DY and
>    splash_rotation=0|90|180|270 place and turn the image with the same
>    meaning as the device tree properties, whatever the image's source.
>    A BMP loaded as firmware has no other way to be placed or turned, and
>    for the others they let a placement be tried without rebuilding a
>    device tree. Positions take both values or are ignored with a
>    warning. When they place a BGRT image, it is placed in screen pixels
>    like any other, and neither the table offsets nor the efifb sanity
>    check apply.
>
> - drm_client_lib.splash_color sets the background whatever the image.
>    Without it the colour comes from the source that supplied the image,
>    a device tree node's "background-color", and otherwise from
>    CONFIG_DRM_CLIENT_SPLASH_BACKGROUND_COLOR. A device tree colour is not
>    used around an image named on the command line: it belongs to another
>    image.
>
> Assisted-by: Claude:claude-opus-5-5
> Signed-off-by: Màxim Pedraza Padilla <maximpedraza@gmail.com>
> ---
>   drivers/gpu/drm/clients/Kconfig      |  20 ++--
>   drivers/gpu/drm/clients/drm_splash.c | 171 +++++++++++++++++++++------
>   2 files changed, 142 insertions(+), 49 deletions(-)
>
> diff --git a/drivers/gpu/drm/clients/Kconfig b/drivers/gpu/drm/clients/Kconfig
> index f471019bab87..2a374bea370b 100644
> --- a/drivers/gpu/drm/clients/Kconfig
> +++ b/drivers/gpu/drm/clients/Kconfig
> @@ -105,11 +105,9 @@ config DRM_CLIENT_SPLASH_BACKGROUND_COLOR
>   	help
>   	  The default splash background color, in RGB888 format.
>   
> -	  The background color comes from the same place as the image. A
> -	  device tree image can carry its own, and the drm_client_lib.splash_color
> -	  kernel command line parameter sets it for a BMP loaded as firmware,
> -	  or for the whole screen when there is no image. This color is used
> -	  otherwise, and always with the BGRT image, which carries none.
> +	  The drm_client_lib.splash_color kernel command line parameter, when
> +	  given, is used whatever the image. Otherwise a device tree image can
> +	  carry its own color, and this one is used for everything else.
>   
>   config DRM_CLIENT_SPLASH_SRC_DT
>   	bool "Device tree as splash source"
> @@ -123,8 +121,9 @@ config DRM_CLIENT_SPLASH_SRC_DT
>   	  show a different logo on each board or product, chosen by the
>   	  device tree it boots with.
>   
> -	  When present, the device tree image is preferred over the other
> -	  sources.
> +	  When present, the device tree image is preferred over the BGRT and
> +	  over the default BMP loaded as firmware. A BMP named on the kernel
> +	  command line is preferred over it.
>   
>   config DRM_CLIENT_SPLASH_SRC_BGRT
>   	bool "EFI BGRT as splash source"
> @@ -150,9 +149,10 @@ config DRM_CLIENT_SPLASH_SRC_BMP
>   
>   	  The image will be loaded using the firmware loading facility the
>   	  kernel provides; it shall use 24 bits per pixel and shall not be
> -	  compressed. The name of the file can be set through the
> -	  drm_client_lib.splash_bmp command line parameter, with the default
> -	  being 'drm_splash.bmp'.
> +	  compressed. A file named through the drm_client_lib.splash_bmp
> +	  command line parameter is preferred over any other image source;
> +	  otherwise 'drm_splash.bmp' is used when neither the device tree nor
> +	  the BGRT provides an image.
>   
>   config DRM_CLIENT_SPLASH_BMP_SUPPORT
>   	bool
> diff --git a/drivers/gpu/drm/clients/drm_splash.c b/drivers/gpu/drm/clients/drm_splash.c
> index 4c30de7c5c16..46faae025ec2 100644
> --- a/drivers/gpu/drm/clients/drm_splash.c
> +++ b/drivers/gpu/drm/clients/drm_splash.c
> @@ -40,18 +40,90 @@
>    * a static image.
>    */
>   
> -static unsigned int splash_color = CONFIG_DRM_CLIENT_SPLASH_BACKGROUND_COLOR;
> -module_param(splash_color, uint, 0400);
> +/*
> + * What is given on the command line wins over the device tree and the
> + * firmware tables, and each parameter only for what it says. Neither has a
> + * value of its own until it is given: -1 and NULL mean "not given".
> + */
> +static int splash_color = -1;
> +module_param(splash_color, int, 0400);
>   MODULE_PARM_DESC(splash_color,
> -		 "Background color (RGB888) around the BMP loaded as firmware, or of the whole screen with no image");
> +		 "Background color as 0xRRGGBB, preferred over any other");
> +
> +static int splash_pos[2];
> +static unsigned int splash_pos_n;
> +module_param_array(splash_pos, int, &splash_pos_n, 0400);
> +MODULE_PARM_DESC(splash_pos,
> +		 "Image position as X,Y in screen pixels, -1 centres that axis");
> +
> +static int splash_offset[2];
> +static unsigned int splash_offset_n;
> +module_param_array(splash_offset, int, &splash_offset_n, 0400);
> +MODULE_PARM_DESC(splash_offset,
> +		 "Displacement as DX,DY in screen pixels, added after placing");
> +
> +static int splash_rotation = -1;
> +module_param(splash_rotation, int, 0400);
> +MODULE_PARM_DESC(splash_rotation,
> +		 "Image rotation in degrees counter clockwise: 0, 90, 180 or 270");
>   
>   #if IS_ENABLED(CONFIG_DRM_CLIENT_SPLASH_SRC_BMP)
>   #define DEFAULT_SPLASH_BMP "drm_splash.bmp"
> -static char *splash_bmp = DEFAULT_SPLASH_BMP;
> +static char *splash_bmp;
>   module_param(splash_bmp, charp, 0400);
> -MODULE_PARM_DESC(splash_bmp, "Name of splash image (default: \"" DEFAULT_SPLASH_BMP "\")");
> +MODULE_PARM_DESC(splash_bmp,
> +		 "BMP to load as firmware, preferred over any other image");
> +
> +/* Given on the command line, and not empty */
> +static bool drm_splash_bmp_given(void)
> +{
> +	return splash_bmp && *splash_bmp;
> +}
> +
> +/* "none" asks for no image at all, whatever the other sources have */
> +static bool drm_splash_bmp_none(void)
> +{
> +	return drm_splash_bmp_given() && !strcmp(splash_bmp, "none");
> +}
> +
> +static const char *drm_splash_bmp_name(void)
> +{
> +	return drm_splash_bmp_given() ? splash_bmp : DEFAULT_SPLASH_BMP;
> +}
> +#else
> +static bool drm_splash_bmp_given(void)
> +{
> +	return false;
> +}
> +
> +static bool drm_splash_bmp_none(void)
> +{
> +	return false;
> +}
>   #endif // CONFIG_DRM_CLIENT_SPLASH_SRC_BMP
>   
> +/* Degrees counter clockwise, as for panels, and as DRM counts them */
> +static bool drm_splash_rotation_from_degrees(u32 degrees,
> +					     unsigned int *rotation)
> +{
> +	switch (degrees) {
> +	case 0:
> +		*rotation = DRM_MODE_ROTATE_0;
> +		return true;
> +	case 90:
> +		*rotation = DRM_MODE_ROTATE_90;
> +		return true;
> +	case 180:
> +		*rotation = DRM_MODE_ROTATE_180;
> +		return true;
> +	case 270:
> +		*rotation = DRM_MODE_ROTATE_270;
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
>   #define BMP_FILE_MAGIC_ID 0x4d42
>   
>   /* BMP header structures copied from drivers/video/fbdev/efifb.c */
> @@ -134,6 +206,8 @@ struct drm_splash {
>   	s32 off_x, off_y;
>   	/* One of DRM_MODE_ROTATE_*: turns the image, not the screen */
>   	unsigned int rotation;
> +	/* Placed from the command line, in screen pixels, whatever the source */
> +	bool place_cmdline;
>   	/* RGB888, from the same place as the image */
>   	u32 bg_color;
>   };
> @@ -218,10 +292,11 @@ static int drm_splash_fw_request_bmp(struct drm_splash *splash)
>   {
>   	struct drm_client_dev *client = &splash->client;
>   
> -	drm_info(client->dev, "splash: request %s as firmware", splash_bmp);
> +	drm_info(client->dev, "splash: request %s as firmware",
> +		 drm_splash_bmp_name());
>   
>   	return request_firmware_nowait(THIS_MODULE, FW_ACTION_UEVENT,
> -				       splash_bmp, client->dev->dev, GFP_KERNEL,
> +				       drm_splash_bmp_name(), client->dev->dev, GFP_KERNEL,
>   				       splash, drm_splash_fw_callback);
>   }
>   #else
> @@ -280,11 +355,9 @@ static void drm_splash_dt_props(struct drm_splash *splash,
>   {
>   	u32 val[2];
>   
> -	/* The colour travels with the image, or it is the kernel's default */
> +	/* The colour travels with the image */
>   	if (!of_property_read_u32(np, "background-color", &val[0]))
>   		splash->bg_color = val[0] & 0xffffff;
> -	else
> -		splash->bg_color = CONFIG_DRM_CLIENT_SPLASH_BACKGROUND_COLOR;
>   
>   	if (!of_property_read_u32_array(np, "logo-position", val, 2)) {
>   		splash->pos_x = (s32)val[0];
> @@ -296,27 +369,10 @@ static void drm_splash_dt_props(struct drm_splash *splash,
>   		splash->off_y = (s32)val[1];
>   	}
>   
> -	/* Degrees counter clockwise, as for panels, and as DRM counts them */
> -	if (!of_property_read_u32(np, "rotation", &val[0])) {
> -		switch (val[0]) {
> -		case 0:
> -			splash->rotation = DRM_MODE_ROTATE_0;
> -			break;
> -		case 90:
> -			splash->rotation = DRM_MODE_ROTATE_90;
> -			break;
> -		case 180:
> -			splash->rotation = DRM_MODE_ROTATE_180;
> -			break;
> -		case 270:
> -			splash->rotation = DRM_MODE_ROTATE_270;
> -			break;
> -		default:
> -			drm_warn(splash->client.dev,
> -				 "splash: %pOF: unsupported rotation %u",
> -				 np, val[0]);
> -		}
> -	}
> +	if (!of_property_read_u32(np, "rotation", &val[0]) &&
> +	    !drm_splash_rotation_from_degrees(val[0], &splash->rotation))
> +		drm_warn(splash->client.dev,
> +			 "splash: %pOF: unsupported rotation %u", np, val[0]);
>   }
>   
>   static int drm_splash_dt_load(struct drm_splash *splash, const u8 **data,
> @@ -702,7 +758,7 @@ static int drm_splash_bmp_to_scanout(struct drm_splash *splash,
>   		return -EINVAL;
>   	}
>   
> -	if (splash->src == DRM_SPLASH_SRC_BGRT) {
> +	if (splash->src == DRM_SPLASH_SRC_BGRT && !splash->place_cmdline) {
>   		/*
>   		 * The BGRT offsets place the upright image on the upright
>   		 * screen, which for a panel mounted turned is not the frame
> @@ -827,10 +883,53 @@ static int drm_splash_image_load(struct drm_splash *splash, const u8 **img_data,
>    * is whatever the firmware shows, and the BMP loaded as firmware is the
>    * fallback. With none of them, only the background colour is drawn.
>    */
> +/*
> + * What the command line gives wins whatever the image and its source, each
> + * parameter for what it says. Positions come in pairs: half of one is
> + * ignored rather than guessed.
> + */
> +static void drm_splash_cmdline_overrides(struct drm_splash *splash)
> +{
> +	struct drm_device *dev = splash->client.dev;
> +
> +	if (splash_color >= 0)
> +		splash->bg_color = splash_color & 0xffffff;
> +
> +	if (splash_pos_n == 2) {
> +		splash->pos_x = splash_pos[0];
> +		splash->pos_y = splash_pos[1];
> +		splash->place_cmdline = true;
> +	} else if (splash_pos_n) {
> +		drm_warn(dev, "splash: splash_pos needs X,Y, ignored");
> +	}
> +
> +	if (splash_offset_n == 2) {
> +		splash->off_x = splash_offset[0];
> +		splash->off_y = splash_offset[1];
> +		splash->place_cmdline = true;
> +	} else if (splash_offset_n) {
> +		drm_warn(dev, "splash: splash_offset needs DX,DY, ignored");
> +	}
> +
> +	if (splash_rotation >= 0 &&
> +	    !drm_splash_rotation_from_degrees(splash_rotation, &splash->rotation))
> +		drm_warn(dev, "splash: unsupported splash_rotation %d, ignored",
> +			 splash_rotation);
> +}
> +
>   static enum drm_splash_source drm_splash_pick_source(struct drm_splash *splash)
>   {
>   	struct device_node *np;
>   
> +	/* Unless the source says otherwise, the kernel's default colour */
> +	splash->bg_color = CONFIG_DRM_CLIENT_SPLASH_BACKGROUND_COLOR;
> +
> +	/* A BMP named on the command line was asked for this very boot */
> +	if (drm_splash_bmp_none())
> +		return DRM_SPLASH_SRC_NONE;
> +	if (drm_splash_bmp_given())
> +		return DRM_SPLASH_SRC_BMP;
> +
>   	np = drm_splash_dt_node(splash);
>   	if (np) {
>   		drm_splash_dt_props(splash, np);
> @@ -838,18 +937,11 @@ static enum drm_splash_source drm_splash_pick_source(struct drm_splash *splash)
>   		return DRM_SPLASH_SRC_DT;
>   	}
>   
> -	/* The BGRT carries no colour: firmware splashes sit on black */
>   	if (drm_splash_bgrt_available(splash)) {
> -		splash->bg_color = CONFIG_DRM_CLIENT_SPLASH_BACKGROUND_COLOR;
>   		splash->rotation = drm_splash_bgrt_rotation();
>   		return DRM_SPLASH_SRC_BGRT;
>   	}
>   
> -	/*
> -	 * The BMP loaded as firmware is named on the command line, and so is
> -	 * its colour, which also covers the screen when there is no image.
> -	 */
> -	splash->bg_color = splash_color & 0xffffff;
>   	if (IS_ENABLED(CONFIG_DRM_CLIENT_SPLASH_SRC_BMP))
>   		return DRM_SPLASH_SRC_BMP;
>   
> @@ -1169,6 +1261,7 @@ static int drm_splash_client_hotplug(struct drm_client_dev *client)
>   	splash->thread = thread;
>   
>   	splash->src = drm_splash_pick_source(splash);
> +	drm_splash_cmdline_overrides(splash);
>   
>   	/* The BMP loaded as firmware is the only source that arrives later */
>   	if (splash->src == DRM_SPLASH_SRC_BMP) {

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Stefan Gaiser, Jochen Jaser, Abhinav Puri, (HRB 36809, AG Nürnberg)


