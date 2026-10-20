Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792494975;
	b=X3D0ffCFEZbw2XqR+BRg7yiQYscHbnC4xpidwPocB758pRVbyZlqo5YfkZEe7stnQRZs
	 TmtgNcORj11cJ7neKg5Mkn7WVEiTmsPy+rfT/GGrvbC4a+LYN8WBxfvZUbI59vBWsBUJW
	 bRB7wOAnv7tUqUL160BJ1MNinHYrYftjjaEtpMNC6vd8hlhw0FUlUzVhuGXUBuWBhtTDr
	 d2YcMDi5LeAp7JQX4Nb4qe1WxMYMn9D4NWs7FUBXYJAULD8X4U9K4/oPjYlO0ov2Heq63
	 NCi0GeliQQ+1AaGoCMaUizAwEgOGKsTE04ULUltJrU745Yht5v86y3YFm3joKcZFwQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792494975;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=bxw/EhE4FNjfEBFr+SgmSBcERnLEt+GnFpVvWXnolUs=;
	b=PNlqxNGEoy9OC2oySsPs90ESpSCbm3jsbfWpUlGH5GDJ1o+zbOVKTdhqBA555vCq28mK
	 SEqoBTVPyh36SxXl97IuMZiGn1Rr9QsUNsY7XEFqZyR4s6GqeOOwH2+HL9eQeTq3kGqq1
	 XwRfPPb1obpjLTGboU+xdoXOtllKzYQ7cU3NgOp7iOSVRyalFF4azlfeaZZciOjBxai4j
	 uE91pFq83LF8cYzf5ZjBvByAou3nFc628boAlhAbHkrbVu9lUgLbETftjGJG0wgvD+2kE
	 JS3bcbC/sfY52z1NER00XBIOoOcmNUEOcb6HcvfWeBXQszinkjACnLUG8QKguQvYWcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b="FJc/wkba";
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=E8ivwJid;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b="FJc/wkba";
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=E8ivwJid;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC33606A319;
	Tue, 20 Oct 2026 11:16:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0EC33606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=FJc/wkba;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=E8ivwJid;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=FJc/wkba;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=E8ivwJid
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9ED601F79A;
	Tue, 20 Oct 2026 11:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792494965; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bxw/EhE4FNjfEBFr+SgmSBcERnLEt+GnFpVvWXnolUs=;
	b=FJc/wkbaMpKB25TLPlT6kazIvDNZJdxK39tVGCmtzSwaeVGOv/QxjTke/0I2XreI9ZvNr5
	PVKe6ZWxSFxUI99fjekfAdmv5Um1ywqm6Qc7BbwjEgCC71WDmapi2lPvCEZULng295HipB
	2voZo+sGnbC8nEhDVZF+KdJK+4vqRSY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792494965;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bxw/EhE4FNjfEBFr+SgmSBcERnLEt+GnFpVvWXnolUs=;
	b=E8ivwJids2MHCFrTYPFJZCqqJoT+NgFq1hdnL1TE4Zbe4MDxeZFGi8p7u7vlR2bqlRQEJn
	G49uMm9PAxTycjBA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792494965; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bxw/EhE4FNjfEBFr+SgmSBcERnLEt+GnFpVvWXnolUs=;
	b=FJc/wkbaMpKB25TLPlT6kazIvDNZJdxK39tVGCmtzSwaeVGOv/QxjTke/0I2XreI9ZvNr5
	PVKe6ZWxSFxUI99fjekfAdmv5Um1ywqm6Qc7BbwjEgCC71WDmapi2lPvCEZULng295HipB
	2voZo+sGnbC8nEhDVZF+KdJK+4vqRSY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792494965;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bxw/EhE4FNjfEBFr+SgmSBcERnLEt+GnFpVvWXnolUs=;
	b=E8ivwJids2MHCFrTYPFJZCqqJoT+NgFq1hdnL1TE4Zbe4MDxeZFGi8p7u7vlR2bqlRQEJn
	G49uMm9PAxTycjBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E5954136C6;
	Tue, 20 Oct 2026 11:16:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dv8oJHRN12qhcQAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Tue, 20 Oct 2026 11:16:04 +0000
Message-ID: <350adc03-dd7f-4120-ac9c-b6d04ff44faf@suse.de>
Date: Tue, 20 Oct 2026 13:16:04 +0200
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
Subject: Re: [PATCH v5 09/13] drm/client: splash: turn the device tree image
 as it asks
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
 <20261013093243.505776-10-maximpedraza@gmail.com>
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
In-Reply-To: <20261013093243.505776-10-maximpedraza@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.79 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	TAGGED_RCPT(0.00)[dt];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	FREEMAIL_TO(0.00)[gmail.com,linux.intel.com,kernel.org,ffwll.ch,lwn.net];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:url,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -2.79
X-Spam-Level: 
X-Spam-Flag: NO

Hi

Am 13.10.26 um 11:32 schrieb Màxim Pedraza Padilla:
> The same board is often fitted with the same panel mounted in more than
> one orientation. Let the device tree node ask for the image to be turned,
> with a "rotation" property counting degrees counter clockwise, as panels
> already do and as DRM_MODE_ROTATE_* count, which is what it is kept as.
>
> The rotation turns the image and not the screen: "logo-position" and
> "logo-offset" stay in screen pixels, and a quarter turn only swaps how
> much room the image takes up. Placing it in a frame that turned with it
> would make the same pair of coordinates mean different places on the
> same panel, decided by a property that describes the image.

> The three blitters, one per destination pixel size, become one that

Reading the code below, may I suggest to do this in two steps: first 
read the image data into a temporary buffer, invert height and rotate as 
needed.  Second, copy the temporary image into the graphics buffer and 
adjust the color format.

Eventually we want to have a useful and flexible drawing/blitting API 
for the DRM clients. Keeping drawing steps separate will help a lot in 
the long run.

Best regards
Thomas

> reads the source pixel through the rotation and writes it according to
> the pixel size. Each source pixel is read as three bytes rather than as
> an unaligned u32: a BMP row is only padded as a whole, so with 3 * width
> already a multiple of four the last pixel of the image was read one byte
> past its end. An upright image going to an RGB888 buffer is still copied
> a row at a time.
>
> Assisted-by: Claude:claude-opus-5-5
> Signed-off-by: Màxim Pedraza Padilla <maximpedraza@gmail.com>
> ---
>   drivers/gpu/drm/clients/drm_splash.c | 206 ++++++++++++++-------------
>   1 file changed, 110 insertions(+), 96 deletions(-)
>
> diff --git a/drivers/gpu/drm/clients/drm_splash.c b/drivers/gpu/drm/clients/drm_splash.c
> index 8561d00a5b96..fdf398987007 100644
> --- a/drivers/gpu/drm/clients/drm_splash.c
> +++ b/drivers/gpu/drm/clients/drm_splash.c
> @@ -25,6 +25,7 @@
>   #include <drm/drm_drv.h>
>   #include <drm/drm_fourcc.h>
>   #include <drm/drm_framebuffer.h>
> +#include <drm/drm_mode.h>
>   #include <drm/drm_plane.h>
>   #include <drm/drm_print.h>
>   
> @@ -130,6 +131,8 @@ struct drm_splash {
>   	 */
>   	s32 pos_x, pos_y;
>   	s32 off_x, off_y;
> +	/* One of DRM_MODE_ROTATE_*: turns the image, not the screen */
> +	unsigned int rotation;
>   };
>   
>   static struct drm_splash *client_to_drm_splash(struct drm_client_dev *client)
> @@ -283,6 +286,28 @@ static void drm_splash_dt_placement(struct drm_splash *splash,
>   		splash->off_x = (s32)val[0];
>   		splash->off_y = (s32)val[1];
>   	}
> +
> +	/* Degrees counter clockwise, as for panels, and as DRM counts them */
> +	if (!of_property_read_u32(np, "rotation", &val[0])) {
> +		switch (val[0]) {
> +		case 0:
> +			splash->rotation = DRM_MODE_ROTATE_0;
> +			break;
> +		case 90:
> +			splash->rotation = DRM_MODE_ROTATE_90;
> +			break;
> +		case 180:
> +			splash->rotation = DRM_MODE_ROTATE_180;
> +			break;
> +		case 270:
> +			splash->rotation = DRM_MODE_ROTATE_270;
> +			break;
> +		default:
> +			drm_warn(splash->client.dev,
> +				 "splash: %pOF: unsupported rotation %u",
> +				 np, val[0]);
> +		}
> +	}
>   }
>   
>   static int drm_splash_dt_load(struct drm_splash *splash, const u8 **data,
> @@ -479,73 +504,68 @@ static unsigned int drm_splash_place_axis(s32 pos, s32 off, unsigned int span,
>   	return clamp_t(s64, coord + off, 0, last);
>   }
>   
> -static void drm_splash_blit_pix16(struct iosys_map *map, unsigned int dpitch,
> -				  unsigned int x_pad, unsigned int y_pad,
> -				  const u8 *sbuf8, unsigned int spitch,
> -				  unsigned int width, unsigned int height,
> -				  bool invert_y, u32 format)
> -{
> -	unsigned int x, y, src_offset, dst_offset;
> -	u32 scolor, dcolor, wr_off;
> -
> -	for (y = 0; y < height; y++) {
> -		src_offset = (invert_y ? (height - y - 1) : y) * spitch;
> -		dst_offset = (y_pad + y) * dpitch;
> -
> -		for (x = 0; x < width; x++) {
> -			scolor = *(const u32 *)(&sbuf8[src_offset + 3 * x]);
> -			dcolor = drm_draw_color_from_xrgb8888(scolor, format);
> -			wr_off = dst_offset + (x_pad + x) * sizeof(u16);
> -
> -			iosys_map_wr(map, wr_off, u16, dcolor);
> -		}
> -	}
> -}
> -
> -static void drm_splash_blit_pix24(struct iosys_map *map, unsigned int dpitch,
> -				  unsigned int x_pad, unsigned int y_pad,
> -				  const u8 *sbuf8, unsigned int spitch,
> -				  unsigned int width, unsigned int height,
> -				  bool invert_y, u32 format)
> -{
> -	unsigned int x, y, src_offset, dst_offset;
> -	u32 scolor, dcolor, wr_off;
> -
> -	for (y = 0; y < height; y++) {
> -		src_offset = (invert_y ? (height - y - 1) : y) * spitch;
> -		dst_offset = (y_pad + y) * dpitch;
> -
> -		for (x = 0; x < width; x++) {
> -			scolor = *(const u32 *)(&sbuf8[src_offset + 3 * x]);
> -			dcolor = drm_draw_color_from_xrgb8888(scolor, format);
> -			wr_off = dst_offset + (x_pad + x) * 3;
> -
> -			iosys_map_wr(map, wr_off, u8, (dcolor & 0x000000FF) >> 0);
> -			iosys_map_wr(map, wr_off + 1, u8, (dcolor & 0x0000FF00) >> 8);
> -			iosys_map_wr(map, wr_off + 2, u8, (dcolor & 0x00FF0000) >> 16);
> -		}
> -	}
> -}
> -
> -static void drm_splash_blit_pix32(struct iosys_map *map, unsigned int dpitch,
> -				  unsigned int x_pad, unsigned int y_pad,
> -				  const u8 *sbuf8, unsigned int spitch,
> -				  unsigned int width, unsigned int height,
> -				  bool invert_y, u32 format)
> +/*
> + * Copy the BMP pixels into the buffer, converted to its format and turned by
> + * @rotation, one of DRM_MODE_ROTATE_*, which count counter clockwise. The
> + * rotation turns the image, not the screen: a quarter turn swaps how much
> + * room the image takes up, and @x_pad and @y_pad place that room on screen.
> + *
> + * Each source pixel is three bytes read on their own, since a BMP row is
> + * only padded to four bytes as a whole and the image need not be aligned.
> + */
> +static void drm_splash_blit(struct iosys_map *map, unsigned int dpitch,
> +			    u32 format, unsigned int cpp,
> +			    unsigned int x_pad, unsigned int y_pad,
> +			    const u8 *sbuf8, unsigned int spitch,
> +			    unsigned int width, unsigned int height,
> +			    bool invert_y, unsigned int rotation)
>   {
> -	unsigned int x, y, src_offset, dst_offset;
> -	u32 scolor, dcolor, wr_off;
> -
> -	for (y = 0; y < height; y++) {
> -		src_offset = (invert_y ? (height - y - 1) : y) * spitch;
> -		dst_offset = (y_pad + y) * dpitch;
> +	bool quarter = rotation & (DRM_MODE_ROTATE_90 | DRM_MODE_ROTATE_270);
> +	unsigned int dw = quarter ? height : width;
> +	unsigned int dh = quarter ? width : height;
> +	unsigned int x, y, sx, sy, row, off;
> +	u32 scolor, dcolor;
> +
> +	for (y = 0; y < dh; y++) {
> +		for (x = 0; x < dw; x++) {
> +			switch (rotation) {
> +			case DRM_MODE_ROTATE_90:
> +				sx = width - 1 - y;
> +				sy = x;
> +				break;
> +			case DRM_MODE_ROTATE_180:
> +				sx = width - 1 - x;
> +				sy = height - 1 - y;
> +				break;
> +			case DRM_MODE_ROTATE_270:
> +				sx = y;
> +				sy = height - 1 - x;
> +				break;
> +			default:
> +				sx = x;
> +				sy = y;
> +				break;
> +			}
>   
> -		for (x = 0; x < width; x++) {
> -			scolor = *(const u32 *)(&sbuf8[src_offset + 3 * x]);
> +			/* A positive BMP height stores the rows bottom up */
> +			row = invert_y ? height - 1 - sy : sy;
> +			scolor = get_unaligned_le24(&sbuf8[row * spitch + 3 * sx]);
>   			dcolor = drm_draw_color_from_xrgb8888(scolor, format);
> -			wr_off = dst_offset + (x_pad + x) * sizeof(u32);
> +			off = (y_pad + y) * dpitch + (x_pad + x) * cpp;
>   
> -			iosys_map_wr(map, wr_off, u32, dcolor);
> +			switch (cpp) {
> +			case 2:
> +				iosys_map_wr(map, off, u16, dcolor);
> +				break;
> +			case 3:
> +				iosys_map_wr(map, off, u8, dcolor & 0xff);
> +				iosys_map_wr(map, off + 1, u8, (dcolor >> 8) & 0xff);
> +				iosys_map_wr(map, off + 2, u8, (dcolor >> 16) & 0xff);
> +				break;
> +			case 4:
> +				iosys_map_wr(map, off, u32, dcolor);
> +				break;
> +			}
>   		}
>   	}
>   }
> @@ -584,7 +604,7 @@ static int drm_splash_bmp_to_scanout(struct drm_splash *splash,
>   	bool bmp_invert_y;
>   	u32 bitmap_offset;
>   	size_t row_len, pixels_len, end;
> -	unsigned int x_pad, y_pad;
> +	unsigned int x_pad, y_pad, img_w, img_h;
>   	const u8 *image_data;
>   	struct iosys_map map;
>   	struct drm_rect r;
> @@ -644,7 +664,16 @@ static int drm_splash_bmp_to_scanout(struct drm_splash *splash,
>   	}
>   	bmp_pitch = row_len & ~(size_t)3;
>   
> -	if (bmp_width > scanout->width || bmp_height > scanout->height) {
> +	/* The room the image takes up on screen, once turned */
> +	if (splash->rotation & (DRM_MODE_ROTATE_90 | DRM_MODE_ROTATE_270)) {
> +		img_w = bmp_height;
> +		img_h = bmp_width;
> +	} else {
> +		img_w = bmp_width;
> +		img_h = bmp_height;
> +	}
> +
> +	if (img_w > scanout->width || img_h > scanout->height) {
>   		drm_err(client->dev, "splash: BMP image is too big for the screen");
>   		return -EINVAL;
>   	}
> @@ -678,9 +707,9 @@ static int drm_splash_bmp_to_scanout(struct drm_splash *splash,
>   #endif
>   	} else {
>   		x_pad = drm_splash_place_axis(splash->pos_x, splash->off_x,
> -					      scanout->width, bmp_width);
> +					      scanout->width, img_w);
>   		y_pad = drm_splash_place_axis(splash->pos_y, splash->off_y,
> -					      scanout->height, bmp_height);
> +					      scanout->height, img_h);
>   	}
>   
>   	image_data = data + bitmap_offset;
> @@ -691,40 +720,24 @@ static int drm_splash_bmp_to_scanout(struct drm_splash *splash,
>   		return ret;
>   	}
>   
> -	r = DRM_RECT_INIT(x_pad, y_pad, bmp_width, bmp_height);
> +	r = DRM_RECT_INIT(x_pad, y_pad, img_w, img_h);
>   
> -	/* In case the target format is RGB888, source data can be copied to
> -	 * the video buffer line by line, avoiding some overhead.
> +	/*
> +	 * An unturned image going to an RGB888 buffer has the same byte order
> +	 * as the BMP, so it is copied a row at a time.
>   	 */
> -	if (scanout->format == DRM_FORMAT_RGB888) {
> +	if (scanout->format == DRM_FORMAT_RGB888 &&
> +	    splash->rotation == DRM_MODE_ROTATE_0) {
>   		drm_splash_blit_rgb888(&map, fb->pitches[0], x_pad, y_pad,
>   				       image_data, bmp_pitch, bmp_width,
>   				       bmp_height, bmp_invert_y);
> +	} else if (px_width >= 2 && px_width <= 4) {
> +		drm_splash_blit(&map, fb->pitches[0], scanout->format, px_width,
> +				x_pad, y_pad, image_data, bmp_pitch, bmp_width,
> +				bmp_height, bmp_invert_y, splash->rotation);
>   	} else {
> -		switch (px_width) {
> -		case 2:
> -			drm_splash_blit_pix16(&map, fb->pitches[0], x_pad,
> -					      y_pad, image_data, bmp_pitch,
> -					      bmp_width, bmp_height,
> -					      bmp_invert_y, scanout->format);
> -			break;
> -		case 3:
> -			drm_splash_blit_pix24(&map, fb->pitches[0], x_pad,
> -					      y_pad, image_data, bmp_pitch,
> -					      bmp_width, bmp_height,
> -					      bmp_invert_y, scanout->format);
> -			break;
> -		case 4:
> -			drm_splash_blit_pix32(&map, fb->pitches[0], x_pad,
> -					      y_pad, image_data, bmp_pitch,
> -					      bmp_width, bmp_height,
> -					      bmp_invert_y, scanout->format);
> -			break;
> -		default:
> -			drm_warn_once(client->dev,
> -				      "splash: can't blit with pixel width %d",
> -				      px_width);
> -		}
> +		drm_warn_once(client->dev, "splash: can't blit with pixel width %d",
> +			      px_width);
>   	}
>   
>   	drm_client_buffer_vunmap_local(buffer);
> @@ -1193,9 +1206,10 @@ void drm_splash_register(struct drm_device *dev,
>   	spin_lock_init(&splash->fw_lock);
>   	init_completion(&splash->fw_done);
>   
> -	/* Centred unless the image source asks otherwise */
> +	/* Centred and upright unless the image source asks otherwise */
>   	splash->pos_x = -1;
>   	splash->pos_y = -1;
> +	splash->rotation = DRM_MODE_ROTATE_0;
>   
>   	if (format && format->num_planes == 1)
>   		splash->preferred_format = format->format;

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Stefan Gaiser, Jochen Jaser, Abhinav Puri, (HRB 36809, AG Nürnberg)


