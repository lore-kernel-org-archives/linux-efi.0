Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794403718;
	b=NHuyjgBASsoGaRJzsPVh2AE+tD5X3OIDoXzn9WwtCD9THwdqQjxcGYLT5jNErzucIdFG
	 mDdO6KjT5/K1QVevXFsFNnZRP1qAN+GVmDrThb+BrVcXUrYhV7foShVkKOL/nijXqOVQT
	 TsHOG9UuokA1143L5MQf4ONLWf+IHvdvkzSVEfwSWS5EUoiGPTN3r35hw1dBMxBBZSEjL
	 8NgF5bUNG30dm9gZ4/6fwAjOKjN+WNrfofnwyfo+eaPPSd+MS2bI9QAwB2FiLnVHYepj+
	 tYUMlfEi+O11V0YTxj7j3PlOfVVPTHbHig4x2U8ypgwMkW7RqLz9rt1BpOc0OvmPjDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794403718;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Spam-Flag:
	 X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=FW5eU1yfp+psDKeNBAOsEj0dksBd4a20D42/+/dRdq8=;
	b=kLTtdDIoQYls7ZnzLgmRAhJbCKBPrQ0KX8YPWRSJ/dZ53+frgj6nVFlU/Lx/tYcPA4/e
	 a8N8+jRrOP1zsyWKIjclg5jA43kawtBYyirdmcZVh8rBkyktp1rDIQfT+PJ/EFNWOZjwj
	 yeDbbbgKgu/WSkpwkr99fYfYatb8+APRukKFCrhZ/5XonZ3C1h9EVyAYK5qlMhyXUQqY+
	 jJ1T0zWS+I+ro6FarqQCMf/TJWz6DlcZ23mcqq9RHidN1SM9Uj+lSc4ZQBPsEdvmHpsA5
	 tSpyRZxarRqxTPCBFfRvATu8VZNvRSOMZuqU4S6mVA8x+WDkXGpPK2hGJ8lXwE935Hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=D4wP5jDs;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=2F8yfFAf;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=htNY92GT;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=wm7tn1dk;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F15606A31C;
	Wed, 11 Nov 2026 13:28:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A9F15606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=D4wP5jDs;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=2F8yfFAf;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=htNY92GT;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=wm7tn1dk
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6E2471FE55;
	Wed, 11 Nov 2026 13:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794403705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FW5eU1yfp+psDKeNBAOsEj0dksBd4a20D42/+/dRdq8=;
	b=D4wP5jDsQDC2tz5yHenehW6+uvYH62K9s2EaWiJQRSHPd2imy1Yae0LShbdfxVXsHABaPI
	VoN0ovI44wOOxj+zus8blb1ZyXlSSNgs7GEazEIvXEg8Xr3MvGvteYxD1NPUOQ+YOxRaiA
	fox6TTkhEM0W8X9Ocnw6sJZz4u4qMcE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794403705;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FW5eU1yfp+psDKeNBAOsEj0dksBd4a20D42/+/dRdq8=;
	b=2F8yfFAf/Y/VACXRNgGx2Xm+whtErbh3dCuosGXD4yoJg17T8dOiipgySDAZ/adKb8LYSO
	wH01KQP+M9vX7rCQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794403704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FW5eU1yfp+psDKeNBAOsEj0dksBd4a20D42/+/dRdq8=;
	b=htNY92GT5XxbmnEAeszi/Ns8Z41MbS2wl2ej89VGgtGe07xF6I1LFpxKoQx6XCRya4Qbvz
	2NOze9ZMMhW66YJtdmjYUGJZ0rrueamNU/cKPuul+0ZyeH5hXLwyhV2Lucb7WKcdDoyVA/
	KPTlY9LYswmXmoB7xMFohz3l6hr+jx0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794403704;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FW5eU1yfp+psDKeNBAOsEj0dksBd4a20D42/+/dRdq8=;
	b=wm7tn1dkL4067WPh6Z8z2aQZquwuJ781BD/UrN7ym38NYlv6dxSd8M+IcENLV1ZshOXwdX
	4ViQrfIEigRWvcCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8F6081339F;
	Wed, 11 Nov 2026 13:28:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oXbRDXdt9GpBUAAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Wed, 11 Nov 2026 13:28:23 +0000
Message-ID: <c2cbc13a-a58d-4c0b-87ac-62daa6de6fba@suse.de>
Date: Wed, 11 Nov 2026 14:28:22 +0100
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
Subject: Re: [PATCH v6 04/15] drm: client: add splash client
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
 <20261027135342.2003632-5-maximpedraza@gmail.com>
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
In-Reply-To: <20261027135342.2003632-5-maximpedraza@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.79 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[dt];
	RCPT_COUNT_TWELVE(0.00)[28];
	FREEMAIL_TO(0.00)[gmail.com,linux.intel.com,kernel.org,ffwll.ch,lwn.net,gmx.de,redhat.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,gmx.de];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.com:url]
X-Spam-Score: -11.79

Hi

Am 27.10.26 um 14:53 schrieb Màxim Pedraza Padilla:
> From: Francesco Valla <francesco@valla.it>
>
> Add a DRM client that draws a simple splash, with possibility to show:
>
>    - the logo provided by EFI BGRT;
>    - a static BMP image (loaded as firmware);
>    - a colored background.
>
> The client is not meant to replace a full-featured bootsplash, but
> rather to remove some complexity (and hopefully boot time) on small
> embedded platforms or on systems with a limited scope (e.g: recovery
> or manufacturing images).
>
> The background color is set at build time from a dedicated config
> option. Any color in RGB888 format can be used.
>
> If enabled, the static BMP image is loaded using the kernel firmware
> infrastructure; a valid BMP image with 24bpp color and no compression
> is expected. The name of the image is set at build time, with the
> default being 'drm_splash.bmp'.
>
> Just like the existing DRM clients, the splash can be enabled from the
> kernel command line using drm_client_lib.active=splash.
>
> v6:
> - draw from a work item on system_power_efficient_wq instead of a
>    render thread
> - set the scanouts up again on every hotplug, and keep the image for
>    the outputs plugged in later
> - keep the scanouts on screen until the new ones are committed, so that
>    a hotplug does not blank every output
> - also when the commit or the hotplug fails; restore retires them too
> - redraw the image after a background that is drawn again
> - accept the V4 and V5 BMP headers
> - limit the background color to RGB888
> - point no modeset at the framebuffer it had, which a probe without
>    connectors leaves in place
> - leave restore to the work while the device is suspended
> - say in DRM_CLIENT_SPLASH_BMP_NAME that the BMP is requested only once
> - don't fail a hotplug, which would stop the later ones for good
> - restore commits whatever the modesets hold: an output without a
>    buffer has no mode either, and is switched off
> - take the BMP headers from <video/bmp.h>
> - draw the image in two steps: the BMP upright in XRGB8888, then into
>    the buffer's format, taken from its drm_format_info
> - drop the splash_color and splash_bmp parameters: the color is set at
>    build time only, and so is the BMP's name, with
>    DRM_CLIENT_SPLASH_BMP_NAME
> - read the 24 bpp source pixels with get_unaligned_le24() instead of a
>    u32 load that runs past the pixel
> - check the BGRT offsets without overflowing
> - size a tiled framebuffer from the tile offsets, whatever order the
>    CRTCs come in, and leave out a tile whose plane cannot take the
>    format of its group
> - don't pick a preferred format that cannot be drawn to, such as C8;
>    without one from the driver, pick the one fbdev would
> - only pick formats the plane takes with the linear modifier, the
>    layout of a dumb buffer
> - switch off a modeset left without a buffer instead of failing the
>    commit for every output
> - mark the background drawn only once it is
> - hold the work back while the device is suspended, drawing included,
>    and queue it on resume
> - drop the fallback to a BMP that was never requested when the BGRT
>    fails to load, and the unused struct device
> - log with drm_dbg() rather than drm_info(), and end the messages with
>    a newline
> - destroy the mutex at unregister, and when registering fails
> - sort the selects of DRM_CLIENT_SELECTION, use unsigned loop counters,
>    and reword the comment on the x86 BGRT sanity check
>
> v5:
> - clear the modesets' framebuffers when the scanouts are freed
> - free the scanouts when setting up fails
> - release a firmware that lands after the drawing is done
> - read the BGRT through the efi_bgrt_*() accessors
> - drop "static inline" from the .c file
>
> v4:
> - fix the render thread never exiting when the BMP firmware is missing,
>    a lost wake-up, and stopping a thread that had exited, never existed
>    or failed to start
> - fix buffers going to the wrong modesets and tiled groups in
>    drm_splash_init_client(), and take modeset_mutex there
> - don't keep an ERR_PTR as a buffer
> - unmap the image only once
> - fix use-after-frees on unbind and in the firmware callback
> - check the BMP size without overflowing
> - indent the Kconfig entry with tabs
>
> Signed-off-by: Francesco Valla <francesco@valla.it>
> Co-developed-by: Màxim Pedraza Padilla <maximpedraza@gmail.com>
> Signed-off-by: Màxim Pedraza Padilla <maximpedraza@gmail.com>

Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>

I have a few comments below, but nothing that blocks the merge. Please 
also see the Sashiko review for another possible issue.


> ---
>   drivers/gpu/drm/clients/Kconfig               |  70 +-
>   drivers/gpu/drm/clients/Makefile              |   1 +
>   drivers/gpu/drm/clients/drm_client_internal.h |   9 +
>   drivers/gpu/drm/clients/drm_client_setup.c    |   8 +
>   drivers/gpu/drm/clients/drm_splash.c          | 976 ++++++++++++++++++
>   5 files changed, 1063 insertions(+), 1 deletion(-)
>   create mode 100644 drivers/gpu/drm/clients/drm_splash.c
>
> diff --git a/drivers/gpu/drm/clients/Kconfig b/drivers/gpu/drm/clients/Kconfig
> index 8d8bc37ec9f2..51ae6c6bd89b 100644
> --- a/drivers/gpu/drm/clients/Kconfig
> +++ b/drivers/gpu/drm/clients/Kconfig
> @@ -13,6 +13,7 @@ config DRM_CLIENT_SELECTION
>   	tristate
>   	depends on DRM
>   	select DRM_CLIENT_LIB if DRM_CLIENT_LOG
> +	select DRM_CLIENT_LIB if DRM_CLIENT_SPLASH
>   	select DRM_CLIENT_LIB if DRM_FBDEV_EMULATION
>   	help
>   	  Drivers that support in-kernel DRM clients have to select this
> @@ -85,10 +86,70 @@ config DRM_CLIENT_LOG
>   	  If you only need logs, but no terminal, or if you prefer userspace
>   	  terminal, say "Y".
>   
> +config DRM_CLIENT_SPLASH
> +	bool "Display graphic splash"
> +	depends on DRM_CLIENT_SELECTION
> +	select DRM_CLIENT
> +	select DRM_CLIENT_SETUP
> +	select DRM_DRAW
> +	help
> +	  This enables a splash drm client, able to display either a plain
> +	  color or a static image until the userspace is ready to take over.
> +	  The splash is displayed on every screen, including those plugged in
> +	  later.
> +
> +config DRM_CLIENT_SPLASH_BACKGROUND_COLOR
> +	hex "Splash background color"
> +	depends on DRM_CLIENT_SPLASH
> +	default 0x000000
> +	range 0x000000 0xffffff
> +	help
> +	  The splash background color, in RGB888 format.
> +
> +config DRM_CLIENT_SPLASH_SRC_BGRT
> +	bool "EFI BGRT as splash source"
> +	depends on DRM_CLIENT_SPLASH
> +	depends on ACPI_BGRT
> +	select DRM_CLIENT_SPLASH_BMP_SUPPORT
> +	help
> +	  Use the BGRT image provided by the EFI bootloader, drawn where the
> +	  firmware drew it. The color specified through the
> +	  DRM_CLIENT_SPLASH_BACKGROUND_COLOR config option will be used as
> +	  background.
> +
> +config DRM_CLIENT_SPLASH_SRC_BMP
> +	bool "BMP image as splash source"
> +	depends on DRM_CLIENT_SPLASH
> +	select DRM_CLIENT_SPLASH_BMP_SUPPORT
> +	select FW_LOADER
> +	help
> +	  Use a BMP (bitmap) image as splash. If the image is smaller than the
> +	  display(s), it will be centered and the color specified through the
> +	  DRM_CLIENT_SPLASH_BACKGROUND_COLOR config option will be used as
> +	  background.
> +
> +	  The image will be loaded using the firmware loading facility the
> +	  kernel provides; it shall use 24 bits per pixel and shall not be
> +	  compressed.
> +
> +config DRM_CLIENT_SPLASH_BMP_NAME
> +	string "Name of the BMP image"
> +	depends on DRM_CLIENT_SPLASH_SRC_BMP
> +	default "drm_splash.bmp"
> +	help
> +	  The file the BMP image is loaded from, looked up like any other
> +	  firmware: built into the kernel through EXTRA_FIRMWARE, in the
> +	  initramfs, or under /lib/firmware. It is requested only once, when
> +	  the splash first sets up: for a driver that probes before the root
> +	  file system is mounted, it has to be built in or in the initramfs.
> +
> +config DRM_CLIENT_SPLASH_BMP_SUPPORT
> +	bool
> +
>   choice
>   	prompt "Default DRM Client"
>   	depends on DRM_CLIENT_SELECTION
> -	depends on DRM_FBDEV_EMULATION || DRM_CLIENT_LOG
> +	depends on DRM_FBDEV_EMULATION || DRM_CLIENT_LOG || DRM_CLIENT_SPLASH
>   	default DRM_CLIENT_DEFAULT_FBDEV
>   	help
>   	  Selects the default drm client.
> @@ -111,6 +172,12 @@ config DRM_CLIENT_DEFAULT_LOG
>   	  screen, but doesn't implement a full terminal. For that you will need
>   	  a userspace terminal using drm/kms.
>   
> +config DRM_CLIENT_DEFAULT_SPLASH
> +	bool "splash"
> +	depends on DRM_CLIENT_SPLASH
> +	help
> +	  Use splash as default drm client.
> +
>   endchoice
>   
>   config DRM_CLIENT_DEFAULT
> @@ -118,6 +185,7 @@ config DRM_CLIENT_DEFAULT
>   	depends on DRM_CLIENT
>   	default "fbdev" if DRM_CLIENT_DEFAULT_FBDEV
>   	default "log" if DRM_CLIENT_DEFAULT_LOG
> +	default "splash" if DRM_CLIENT_DEFAULT_SPLASH
>   	default ""
>   
>   endmenu
> diff --git a/drivers/gpu/drm/clients/Makefile b/drivers/gpu/drm/clients/Makefile
> index 1304ff358509..b43b1e86fe8e 100644
> --- a/drivers/gpu/drm/clients/Makefile
> +++ b/drivers/gpu/drm/clients/Makefile
> @@ -6,4 +6,5 @@ drm_client_lib-y := drm_client_setup.o
>   drm_client_lib-$(CONFIG_DRM_CLIENT_LOG) += drm_log.o
>   drm_client_lib-$(CONFIG_DRM_FBDEV_EMULATION) += drm_fbdev_client.o \
>   						drm_fbdev_helper.o
> +drm_client_lib-$(CONFIG_DRM_CLIENT_SPLASH) += drm_splash.o
>   obj-$(CONFIG_DRM_CLIENT_LIB) += drm_client_lib.o
> diff --git a/drivers/gpu/drm/clients/drm_client_internal.h b/drivers/gpu/drm/clients/drm_client_internal.h
> index 6dc078bf6503..48ee0c1c2529 100644
> --- a/drivers/gpu/drm/clients/drm_client_internal.h
> +++ b/drivers/gpu/drm/clients/drm_client_internal.h
> @@ -22,4 +22,13 @@ void drm_log_register(struct drm_device *dev);
>   static inline void drm_log_register(struct drm_device *dev) {}
>   #endif
>   
> +#ifdef CONFIG_DRM_CLIENT_SPLASH
> +void drm_splash_register(struct drm_device *dev,
> +			 const struct drm_format_info *format);
> +#else
> +static inline void drm_splash_register(struct drm_device *dev,
> +				       const struct drm_format_info *format)
> +{}
> +#endif
> +
>   #endif
> diff --git a/drivers/gpu/drm/clients/drm_client_setup.c b/drivers/gpu/drm/clients/drm_client_setup.c
> index 515aceac22b1..c19498938ee3 100644
> --- a/drivers/gpu/drm/clients/drm_client_setup.c
> +++ b/drivers/gpu/drm/clients/drm_client_setup.c
> @@ -56,6 +56,14 @@ void drm_client_setup(struct drm_device *dev, const struct drm_format_info *form
>   		return;
>   	}
>   #endif
> +
> +#ifdef CONFIG_DRM_CLIENT_SPLASH
> +	if (!strcmp(drm_client_default, "splash")) {
> +		drm_splash_register(dev, format);
> +		return;
> +	}
> +#endif
> +
>   	if (strcmp(drm_client_default, ""))
>   		drm_warn(dev, "Unknown DRM client %s\n", drm_client_default);
>   }
> diff --git a/drivers/gpu/drm/clients/drm_splash.c b/drivers/gpu/drm/clients/drm_splash.c
> new file mode 100644
> index 000000000000..337c7160c4a1
> --- /dev/null
> +++ b/drivers/gpu/drm/clients/drm_splash.c
> @@ -0,0 +1,976 @@
> +// SPDX-License-Identifier: GPL-2.0 or MIT
> +/*
> + * Copyright (c) 2025-2026 Francesco Valla <francesco@valla.it>
> + */
> +
> +#include <linux/completion.h>
> +#include <linux/device.h>
> +#include <linux/efi-bgrt.h>
> +#include <linux/firmware.h>
> +#include <linux/init.h>
> +#include <linux/iosys-map.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/overflow.h>
> +#include <linux/slab.h>
> +#include <linux/types.h>
> +#include <linux/unaligned.h>
> +#include <linux/workqueue.h>
> +
> +#include <acpi/actbl1.h>
> +
> +#include <video/bmp.h>
> +
> +#include <drm/drm_client.h>
> +#include <drm/drm_drv.h>
> +#include <drm/drm_fourcc.h>
> +#include <drm/drm_framebuffer.h>
> +#include <drm/drm_plane.h>
> +#include <drm/drm_print.h>
> +
> +#include "drm_client_internal.h"
> +#include "drm_draw_internal.h"
> +#include "drm_internal.h"
> +
> +/**
> + * DOC: overview
> + *
> + * This is a simple graphic bootsplash, able to display either a plain color or
> + * a static image.
> + */
> +
> +struct drm_splash_scanout {
> +	int id;
> +	/* Modesets scanning this buffer out, by position in the list */
> +	u32 modesets;
> +	u32 format;
> +	unsigned int width;
> +	unsigned int height;
> +	struct drm_client_buffer *buffer;
> +	bool bg_drawn;
> +	bool img_drawn;
> +};
> +
> +struct drm_splash {
> +	struct drm_client_dev client;
> +	u32 preferred_format;
> +
> +	/* Draws what is missing and shows it, queued when there is news */
> +	struct work_struct work;
> +
> +	/*
> +	 * Serialises the work against hotplug events, which set the scanouts
> +	 * up again, suspend and resume, and the firmware callback
> +	 */
> +	struct mutex lock;
> +	/* Suspended, and whether the work was held back meanwhile */
> +	bool suspended, work_skipped;
> +	/* The source is picked at the first hotplug that finds an output */
> +	bool source_picked;
> +
> +	u32 n_scanout;
> +	struct drm_splash_scanout *scanout;
> +	/*
> +	 * The scanouts a hotplug replaced, kept on screen until the work has
> +	 * committed the new ones, so that the outputs do not go dark meanwhile
> +	 */
> +	u32 n_old_scanout;
> +	struct drm_splash_scanout *old_scanout;
> +
> +	/* A request was made, and fw_done tells when its callback is over */
> +	bool fw_requested;
> +	struct completion fw_done;
> +	/*
> +	 * The image is kept for as long as the splash is there, so that an
> +	 * output plugged in later gets it too
> +	 */
> +	const struct firmware *fw;
> +	void *map_data;
> +
> +	bool use_bgrt;
> +};
> +
> +static struct drm_splash *client_to_drm_splash(struct drm_client_dev *client)
> +{
> +	return container_of_const(client, struct drm_splash, client);
> +}
> +
> +static struct drm_splash_scanout *
> +get_scanout_from_tile_group(struct drm_splash *splash, int id)
> +{
> +	int j;
> +
> +	for (j = 0; j < splash->n_scanout; j++)
> +		if (splash->scanout[j].id == id)
> +			return &splash->scanout[j];
> +
> +	return NULL;
> +}
> +
> +static void drm_splash_queue(struct drm_splash *splash)
> +{
> +	queue_work(system_power_efficient_wq, &splash->work);
> +}
> +
> +#if IS_ENABLED(CONFIG_DRM_CLIENT_SPLASH_SRC_BMP)
> +static int drm_splash_fw_load(struct drm_splash *splash, const u8 **data,
> +			      size_t *size)
> +{
> +	const struct firmware *fw = splash->fw;
> +
> +	/* Under the lock, which the firmware callback takes to hand it over */
> +	if (!fw)
> +		return -ENOENT;
> +
> +	*data = fw->data;
> +	*size = fw->size;
> +
> +	return 0;
> +}
> +
> +static void drm_splash_fw_callback(const struct firmware *fw, void *context)
> +{
> +	struct drm_splash *splash = context;
> +	struct drm_client_dev *client = &splash->client;
> +
> +	if (!fw || !fw->data) {
> +		/* The firmware loader has said why already */
> +		drm_dbg(client->dev, "splash: no firmware\n");
> +		release_firmware(fw);
> +		fw = NULL;
> +	}
> +
> +	scoped_guard(mutex, &splash->lock)
> +		splash->fw = fw;
> +
> +	/* Even without it: a background that failed to draw gets another go */
> +	drm_splash_queue(splash);
> +
> +	/* Last: once this is seen, unregister may free the splash */
> +	complete(&splash->fw_done);
> +}
> +
> +static int drm_splash_fw_request_bmp(struct drm_splash *splash)
> +{
> +	struct drm_client_dev *client = &splash->client;
> +
> +	drm_dbg(client->dev, "splash: request %s as firmware\n",
> +		CONFIG_DRM_CLIENT_SPLASH_BMP_NAME);
> +
> +	return request_firmware_nowait(THIS_MODULE, FW_ACTION_UEVENT,
> +				       CONFIG_DRM_CLIENT_SPLASH_BMP_NAME,
> +				       client->dev->dev, GFP_KERNEL,
> +				       splash, drm_splash_fw_callback);
> +}
> +#else
> +static int drm_splash_fw_load(struct drm_splash *splash, const u8 **data,
> +			      size_t *size)
> +{
> +	return -EOPNOTSUPP;

In cases like this one, it's better to return 0 as if the function had 
succeeded.  You merely need this for linking, it should not be called at 
all if disabled.


> +}
> +
> +static int drm_splash_fw_request_bmp(struct drm_splash *splash)
> +{
> +	return -EOPNOTSUPP;
> +}
> +#endif // CONFIG_DRM_CLIENT_SPLASH_SRC_BMP
> +
> +static bool drm_splash_bgrt_available(struct drm_splash *splash)
> +{
> +	struct drm_client_dev *client = &splash->client;
> +
> +	if (!IS_ENABLED(CONFIG_DRM_CLIENT_SPLASH_SRC_BGRT))
> +		return false;
> +
> +	if (!efi_bgrt_has_image()) {
> +		drm_dbg(client->dev, "splash: no BGRT found\n");
> +		return false;
> +	}
> +
> +	if (efi_bgrt_status() & ACPI_BGRT_ORIENTATION_OFFSET) {
> +		drm_dbg(client->dev, "splash: BGRT rotation bits set, skipping\n");
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +static int drm_splash_bgrt_load(struct drm_splash *splash, const u8 **data,
> +				size_t *size)
> +{
> +	struct drm_client_dev *client = &splash->client;
> +	phys_addr_t addr = efi_bgrt_image_address();
> +	size_t len = efi_bgrt_image_size();
> +
> +	if (!drm_splash_bgrt_available(splash))
> +		return -ENOENT;
> +
> +	/* Mapped once, and kept for the outputs plugged in later */
> +	if (!splash->map_data) {
> +		drm_dbg(client->dev, "splash: BGRT image is at %pa, size=%zX\n",
> +			&addr, len);
> +
> +		splash->map_data = memremap(addr, len, MEMREMAP_WB);
> +		if (!splash->map_data) {
> +			drm_warn(client->dev,
> +				 "splash: failed to map BGRT image memory\n");
> +			return -ENOMEM;
> +		}
> +	}
> +
> +	*data = splash->map_data;
> +	*size = len;
> +
> +	return 0;
> +}
> +
> +static u32 drm_splash_find_usable_format(struct drm_plane *plane,
> +					 u32 preferred_format)
> +{
> +	unsigned int i;
> +
> +	/* Dumb buffers are linear: the plane must take the format so */
> +	if (drm_draw_can_convert_from_xrgb8888(preferred_format) &&
> +	    drm_plane_has_format(plane, preferred_format, DRM_FORMAT_MOD_LINEAR))
> +		return preferred_format;
> +
> +	/* Otherwise, find the first format that can be converted from XRGB8888 */
> +	for (i = 0; i < plane->format_count; i++) {
> +		u32 format = plane->format_types[i];
> +
> +		if (drm_draw_can_convert_from_xrgb8888(format) &&
> +		    drm_plane_has_format(plane, format, DRM_FORMAT_MOD_LINEAR))
> +			return format;
> +	}
> +
> +	return DRM_FORMAT_INVALID;
> +}
> +
> +static void drm_splash_fill(struct iosys_map *map, unsigned int dst_pitch,
> +			    unsigned int height, unsigned int width,
> +			    const struct drm_format_info *format, u32 color)
> +{
> +	switch (drm_format_info_bpp(format, 0)) {
> +	case 16:
> +		drm_draw_fill16(map, dst_pitch, height, width, color);
> +		break;
> +	case 24:
> +		drm_draw_fill24(map, dst_pitch, height, width, color);
> +		break;
> +	case 32:
> +		drm_draw_fill32(map, dst_pitch, height, width, color);
> +		break;
> +	default:
> +		WARN_ONCE(1, "Can't fill %p4cc\n", &format->format);
> +	}
> +}
> +
> +static int drm_splash_fill_solid_color(struct drm_client_buffer *buffer,
> +				       u32 color)
> +{
> +	struct drm_client_dev *client = buffer->client;
> +	struct drm_framebuffer *fb = buffer->fb;
> +	struct drm_rect r = DRM_RECT_INIT(0, 0, fb->width, fb->height);
> +	struct iosys_map map;
> +	int ret;
> +
> +	ret = drm_client_buffer_vmap_local(buffer, &map);
> +	if (ret) {
> +		drm_err(client->dev, "splash: cannot vmap buffer: %d\n", ret);
> +		return ret;
> +	}
> +
> +	drm_splash_fill(&map, fb->pitches[0], drm_rect_height(&r),
> +			drm_rect_width(&r), fb->format, color);
> +
> +	drm_client_buffer_vunmap_local(buffer);
> +
> +	return drm_client_buffer_flush(buffer, &r);
> +}
> +
> +#if IS_ENABLED(CONFIG_DRM_CLIENT_SPLASH_BMP_SUPPORT)
> +/* The rows of a 24 bpp BMP, bottom up or top down, upright in XRGB8888 */
> +static void drm_splash_bmp_decode(u32 *dst, const u8 *src, unsigned int spitch,
> +				  unsigned int width, unsigned int height,
> +				  bool invert_y)
> +{
> +	unsigned int x, y;
> +
> +	for (y = 0; y < height; y++) {
> +		const u8 *p = src + (invert_y ? height - 1 - y : y) * spitch;
> +
> +		for (x = 0; x < width; x++, p += 3)
> +			*dst++ = get_unaligned_le24(p);
> +	}
> +}
> +
> +/* An XRGB8888 image into a buffer of another format, at x0, y0 */
> +static void drm_splash_blit(struct iosys_map *map, unsigned int dpitch,
> +			    const struct drm_format_info *format,
> +			    unsigned int x0, unsigned int y0, const u32 *src,
> +			    unsigned int width, unsigned int height)
> +{
> +	unsigned int bpp = drm_format_info_bpp(format, 0);
> +	unsigned int x, y, off;
> +	u32 c;
> +
> +	for (y = 0; y < height; y++) {
> +		off = (y0 + y) * dpitch + x0 * bpp / 8;
> +
> +		switch (bpp) {
> +		case 16:
> +			for (x = 0; x < width; x++, off += 2) {
> +				c = drm_draw_color_from_xrgb8888(*src++, format->format);
> +				iosys_map_wr(map, off, u16, c);
> +			}
> +			break;
> +		case 24:
> +			for (x = 0; x < width; x++, off += 3) {
> +				c = drm_draw_color_from_xrgb8888(*src++, format->format);
> +				iosys_map_wr(map, off, u8, c & 0xff);
> +				iosys_map_wr(map, off + 1, u8, (c >> 8) & 0xff);
> +				iosys_map_wr(map, off + 2, u8, (c >> 16) & 0xff);
> +			}
> +			break;
> +		case 32:
> +			for (x = 0; x < width; x++, off += 4) {
> +				c = drm_draw_color_from_xrgb8888(*src++, format->format);
> +				iosys_map_wr(map, off, u32, c);
> +			}
> +			break;
> +		}
> +	}
> +}
> +
> +static int drm_splash_bmp_to_scanout(struct drm_splash *splash,
> +				     struct drm_splash_scanout *scanout,
> +				     const u8 *data, size_t data_len)
> +
> +{
> +	struct drm_client_buffer *buffer = scanout->buffer;
> +	struct drm_client_dev *client = buffer->client;
> +	struct drm_framebuffer *fb = buffer->fb;
> +	const struct bmp_file_header *file_header;
> +	const struct bmp_dib_header *dib_header;
> +	u32 dib_header_size;
> +	u16 bmp_id, bmp_bpp, bmp_planes;
> +	u32 bmp_compression, bmp_pitch;
> +	s32 bmp_width, bmp_height;
> +	bool bmp_invert_y;
> +	u32 bitmap_offset;
> +	size_t row_len, pixels_len, end;
> +	unsigned int x_pad, y_pad;
> +	const u8 *image_data;
> +	struct iosys_map map;
> +	struct drm_rect r;
> +	u32 *img;
> +	int ret;
> +
> +	if (data_len < (sizeof(*file_header) + sizeof(*dib_header))) {
> +		drm_err(client->dev, "splash: BMP file too short\n");
> +		return -EINVAL;
> +	}
> +
> +	file_header = (const struct bmp_file_header *)data;
> +
> +	bmp_id = get_unaligned_le16(&file_header->id);
> +	if (bmp_id != BMP_FILE_MAGIC_ID) {
> +		drm_err(client->dev, "splash: invalid BMP magic 0x%04X\n", bmp_id);
> +		return -EINVAL;
> +	}
> +
> +	bitmap_offset = get_unaligned_le32(&file_header->bitmap_offset);
> +
> +	dib_header = (const struct bmp_dib_header *)(data + sizeof(*file_header));
> +
> +	dib_header_size = get_unaligned_le32(&dib_header->dib_header_size);
> +
> +	bmp_width = (s32)get_unaligned_le32(&dib_header->width);
> +	bmp_height = (s32)get_unaligned_le32(&dib_header->height);
> +	bmp_planes = get_unaligned_le16(&dib_header->planes);
> +	bmp_bpp = get_unaligned_le16(&dib_header->bpp);
> +	bmp_compression = get_unaligned_le32(&dib_header->compression);
> +
> +	/*
> +	 * Restrict supported format to uncompressed, 24bit RGB888. The V4 and
> +	 * V5 headers only add fields after these, and bitmap_offset finds the
> +	 * pixels.
> +	 */
> +	if (dib_header_size < 40 || bmp_width <= 0 || bmp_height == 0 ||
> +	    bmp_height == S32_MIN || bmp_planes != 1 ||
> +	    bmp_compression != 0 || bmp_bpp != 24) {
> +		drm_err(client->dev, "splash: invalid BMP format\n");
> +		return -EINVAL;
> +	}
> +
> +	/* A positive height means bottom-to-top scan direction */
> +	bmp_invert_y = (bmp_height > 0);
> +	bmp_height = abs(bmp_height);
> +
> +	/*
> +	 * Every field comes from the image, which the firmware or the device
> +	 * tree supplied, so check the arithmetic before trusting the result:
> +	 * rows are padded to four bytes, and the pixels must end within the
> +	 * data.
> +	 */
> +	if (check_mul_overflow((size_t)bmp_width, (size_t)3, &row_len) ||
> +	    check_add_overflow(row_len, (size_t)3, &row_len) ||
> +	    check_mul_overflow(row_len & ~(size_t)3, (size_t)bmp_height,
> +			       &pixels_len) ||
> +	    check_add_overflow((size_t)bitmap_offset, pixels_len, &end) ||
> +	    end > data_len) {
> +		drm_err(client->dev, "splash: invalid BMP size\n");
> +		return -EINVAL;
> +	}
> +	bmp_pitch = row_len & ~(size_t)3;
> +
> +	if (bmp_width > scanout->width || bmp_height > scanout->height) {
> +		drm_err(client->dev, "splash: BMP image is too big for the screen\n");
> +		return -EINVAL;
> +	}
> +
> +	if (splash->use_bgrt) {
> +		x_pad = efi_bgrt_image_offset_x();
> +		y_pad = efi_bgrt_image_offset_y();
> +
> +		if (x_pad > scanout->width - bmp_width ||
> +		    y_pad > scanout->height - bmp_height) {
> +			drm_err(client->dev, "splash: BGRT image would overflow\n");
> +			return -EINVAL;
> +		}
> +
> +#ifdef CONFIG_X86

Is this really x86 specific? I wonder if we shouldn't test it on all 
architectures or drop the test.

Best regards
Thomas

> +		/*
> +		 * BGRT sanity check, taken from efifb.c:
> +		 *
> +		 * Some firmware on x86 uses a non-native resolution for the
> +		 * display if it has shown some text messages, while the BGRT
> +		 * still describes the image for the native resolution. If
> +		 * that image still fits, it ends up very close to the right
> +		 * edge of the display, looking quite bad.
> +		 */
> +
> +		if (x_pad != (scanout->width - bmp_width) / 2) {
> +			drm_err(client->dev, "splash: BGRT sanity check failed\n");
> +			return -EINVAL;
> +		}
> +#endif
> +	} else {
> +		/* Center X and Y */
> +		x_pad = (scanout->width - bmp_width) / 2;
> +		y_pad = (scanout->height - bmp_height) / 2;
> +	}
> +
> +	image_data = data + bitmap_offset;
> +
> +	/* First the image upright in XRGB8888, then into the buffer's format */
> +	img = kvmalloc_array(bmp_width, bmp_height * sizeof(*img), GFP_KERNEL);
> +	if (!img)
> +		return -ENOMEM;
> +	drm_splash_bmp_decode(img, image_data, bmp_pitch, bmp_width, bmp_height,
> +			      bmp_invert_y);
> +
> +	ret = drm_client_buffer_vmap_local(buffer, &map);
> +	if (ret) {
> +		drm_err(client->dev, "splash: cannot vmap buffer: %d\n", ret);
> +		kvfree(img);
> +		return ret;
> +	}
> +
> +	r = DRM_RECT_INIT(x_pad, y_pad, bmp_width, bmp_height);
> +	drm_splash_blit(&map, fb->pitches[0], fb->format, x_pad, y_pad, img,
> +			bmp_width, bmp_height);
> +
> +	kvfree(img);
> +	drm_client_buffer_vunmap_local(buffer);
> +
> +	return drm_client_buffer_flush(buffer, &r);
> +}
> +#else
> +static int drm_splash_bmp_to_scanout(struct drm_splash *splash,
> +				     struct drm_splash_scanout *scanout,
> +				     const u8 *data, size_t data_len)
> +{
> +	return -EOPNOTSUPP;
> +}
> +#endif
> +
> +static int drm_splash_image_load(struct drm_splash *splash, const u8 **img_data,
> +				 size_t *img_data_len)
> +{
> +	if (splash->use_bgrt)
> +		return drm_splash_bgrt_load(splash, img_data, img_data_len);
> +
> +	return drm_splash_fw_load(splash, img_data, img_data_len);
> +}
> +
> +/* At unregister, once nothing else can use the image */
> +static void drm_splash_image_cleanup(struct drm_splash *splash)
> +{
> +	memunmap(splash->map_data);
> +	splash->map_data = NULL;
> +	release_firmware(splash->fw);
> +	splash->fw = NULL;
> +}
> +
> +/* Delete the buffers of an array of scanouts, and the array */
> +static void drm_splash_delete_scanouts(struct drm_splash_scanout **scanout,
> +				       u32 *n_scanout)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < *n_scanout; i++)
> +		drm_client_buffer_delete((*scanout)[i].buffer);
> +
> +	kfree(*scanout);
> +	*scanout = NULL;
> +	*n_scanout = 0;
> +}
> +
> +static void drm_splash_work(struct work_struct *work)
> +{
> +	struct drm_splash *splash = container_of(work, struct drm_splash, work);
> +	struct drm_client_dev *client = &splash->client;
> +	const u8 *img_data = NULL;
> +	size_t img_data_len = 0;
> +	bool img_loaded;
> +	unsigned int i;
> +	int ret;
> +
> +	guard(mutex)(&splash->lock);
> +
> +	/*
> +	 * Not while the device sleeps, not even drawing, which flushes the
> +	 * buffers to the hardware: resume queues the work again
> +	 */
> +	if (splash->suspended) {
> +		splash->work_skipped = true;
> +		return;
> +	}
> +
> +	if (!splash->n_scanout)
> +		return;
> +
> +	/* A BMP loaded as firmware may not be there yet: its callback requeues */
> +	img_loaded = !drm_splash_image_load(splash, &img_data, &img_data_len);
> +
> +	for (i = 0; i < splash->n_scanout; i++) {
> +		struct drm_splash_scanout *scanout = &splash->scanout[i];
> +
> +		/* Its outputs are off: init_client could not create it */
> +		if (!scanout->buffer)
> +			continue;
> +
> +		if (!scanout->bg_drawn) {
> +			u32 rgb = CONFIG_DRM_CLIENT_SPLASH_BACKGROUND_COLOR;
> +			u32 color = drm_draw_color_from_xrgb8888(rgb, scanout->format);
> +
> +			/* Only success marks it done: a later pass retries */
> +			ret = drm_splash_fill_solid_color(scanout->buffer, color);
> +			scanout->bg_drawn = !ret;
> +			/* The fill covers the image too */
> +			scanout->img_drawn = false;
> +		}
> +
> +		if (img_loaded && !scanout->img_drawn) {
> +			/* A failure leaves the background alone */
> +			ret = drm_splash_bmp_to_scanout(splash, scanout, img_data,
> +							img_data_len);
> +			scanout->img_drawn = !ret;
> +		}
> +	}
> +
> +	/*
> +	 * With another master, the display is not the splash's to show; the
> +	 * buffers stay drawn for when restore hands it back.
> +	 */
> +	ret = drm_client_modeset_commit(client);
> +	if (ret) {
> +		/* What a hotplug replaced is still on screen: it stays */
> +		drm_dbg(client->dev, "splash: commit: %d\n", ret);
> +		return;
> +	}
> +
> +	/* Whatever a hotplug replaced is no longer on screen */
> +	drm_splash_delete_scanouts(&splash->old_scanout, &splash->n_old_scanout);
> +}
> +
> +/* No mode and no connectors: a commit switches the output off */
> +static void drm_splash_modeset_off(struct drm_device *dev,
> +				   struct drm_mode_set *modeset)
> +{
> +	unsigned int k;
> +
> +	for (k = 0; k < modeset->num_connectors; k++) {
> +		drm_connector_put(modeset->connectors[k]);
> +		modeset->connectors[k] = NULL;
> +	}
> +	modeset->num_connectors = 0;
> +	drm_mode_destroy(dev, modeset->mode);
> +	modeset->mode = NULL;
> +	modeset->fb = NULL;
> +}
> +
> +static int drm_splash_init_client(struct drm_splash *splash)
> +{
> +	struct drm_client_dev *client = &splash->client;
> +	struct drm_mode_set *modeset;
> +	unsigned int fb_count = 0;
> +	unsigned int i, k;
> +	int err = -ENODEV;
> +
> +	if (drm_client_modeset_probe(client, 0, 0))
> +		return -EIO;
> +
> +	mutex_lock(&client->modeset_mutex);
> +
> +	/*
> +	 * Collect one scanout per usable modeset, or per tile group. Each
> +	 * scanout records the modesets it feeds by their position in the
> +	 * list, so that the second pass below can find them again whatever
> +	 * was skipped in between.
> +	 */
> +	i = 0;
> +	drm_client_for_each_modeset(modeset, client) {
> +		struct drm_splash_scanout *tmp;
> +		struct drm_splash_scanout *scanout;
> +		unsigned int idx = i++;
> +		u32 format;
> +		int id = -1;
> +
> +		if (WARN_ON_ONCE(idx >= 32))
> +			break;
> +
> +		/* Skip modesets without a mode */
> +		if (!modeset->mode)
> +			continue;
> +
> +		if (modeset->connectors[0]->has_tile) {
> +			struct drm_splash_scanout *tiled;
> +			int new_id = modeset->connectors[0]->tile_group->id;
> +
> +			/*
> +			 * Tiled modesets contribute to a single framebuffer,
> +			 * which reaches the far edge of the last tile, whatever
> +			 * order the tiles come in.
> +			 */
> +			tiled = get_scanout_from_tile_group(splash, new_id);
> +			if (tiled) {
> +				/* Left off unless its plane takes the group's format */
> +				if (!drm_plane_has_format(modeset->crtc->primary,
> +							  tiled->format,
> +							  DRM_FORMAT_MOD_LINEAR)) {
> +					drm_warn(client->dev,
> +						 "splash: tile plane can't take %p4cc\n",
> +						 &tiled->format);
> +					continue;
> +				}
> +				tiled->width = max(tiled->width, modeset->x +
> +						   modeset->mode->hdisplay);
> +				tiled->height = max(tiled->height, modeset->y +
> +						    modeset->mode->vdisplay);
> +				tiled->modesets |= BIT(idx);
> +				continue;
> +			}
> +
> +			/* New tile group, save its ID for later */
> +			id = new_id;
> +		}
> +
> +		format = drm_splash_find_usable_format(modeset->crtc->primary,
> +						       splash->preferred_format);
> +		if (format == DRM_FORMAT_INVALID) {
> +			drm_warn(client->dev,
> +				 "splash: can't find a usable format for modeset\n");
> +			continue;
> +		}
> +
> +		tmp = krealloc(splash->scanout,
> +			       (splash->n_scanout + 1) * sizeof(*splash->scanout),
> +			       GFP_KERNEL);
> +		if (!tmp) {
> +			drm_warn(client->dev,
> +				 "splash: can't reallocate the scanout array\n");
> +			break;
> +		}
> +
> +		splash->scanout = tmp;
> +		scanout = &splash->scanout[splash->n_scanout];
> +		splash->n_scanout++;
> +
> +		memset(scanout, 0, sizeof(*scanout));
> +		scanout->id = id;
> +		scanout->modesets = BIT(idx);
> +		scanout->format = format;
> +		scanout->width = modeset->x + modeset->mode->hdisplay;
> +		scanout->height = modeset->y + modeset->mode->vdisplay;
> +	}
> +
> +	/* Now that the sizes are known, allocate one buffer per scanout */
> +	for (k = 0; k < splash->n_scanout; k++) {
> +		struct drm_splash_scanout *scanout = &splash->scanout[k];
> +		struct drm_client_buffer *buffer;
> +
> +		buffer = drm_client_buffer_create_dumb(client, scanout->width,
> +						       scanout->height,
> +						       scanout->format);
> +		if (IS_ERR(buffer)) {
> +			err = PTR_ERR(buffer);
> +			drm_warn(client->dev,
> +				 "splash: can't create dumb buffer %d %d %p4cc: %pe\n",
> +				 scanout->width, scanout->height, &scanout->format,
> +				 buffer);
> +			continue;
> +		}
> +
> +		drm_dbg(client->dev, "splash: created dumb buffer %d %d %p4cc\n",
> +			scanout->width, scanout->height, &scanout->format);
> +
> +		scanout->buffer = buffer;
> +		fb_count++;
> +	}
> +
> +	/*
> +	 * And point every modeset at the buffer of its scanout. One left
> +	 * without, whatever the reason, is switched off: a mode without a
> +	 * framebuffer fails the commit, and with it every other output.
> +	 * Never the old one: a probe without connectors leaves it there.
> +	 */
> +	i = 0;
> +	drm_client_for_each_modeset(modeset, client) {
> +		unsigned int idx = i++;
> +
> +		modeset->fb = NULL;
> +		for (k = 0; idx < 32 && k < splash->n_scanout; k++) {
> +			struct drm_splash_scanout *scanout = &splash->scanout[k];
> +
> +			if (scanout->buffer && (scanout->modesets & BIT(idx))) {
> +				modeset->fb = scanout->buffer->fb;
> +				break;
> +			}
> +		}
> +
> +		if (!modeset->fb)
> +			drm_splash_modeset_off(client->dev, modeset);
> +	}
> +
> +	mutex_unlock(&client->modeset_mutex);
> +
> +	/* No scanout at all is not an error; scanouts without buffers are */
> +	return fb_count ? 0 : err;
> +}
> +
> +static void drm_splash_free_scanout(struct drm_client_dev *client)
> +{
> +	struct drm_splash *splash = client_to_drm_splash(client);
> +	struct drm_mode_set *modeset;
> +
> +	/*
> +	 * The modesets must not point at the framebuffers freed below, nor
> +	 * keep a mode without one, which would fail every later commit
> +	 */
> +	mutex_lock(&client->modeset_mutex);
> +	drm_client_for_each_modeset(modeset, client)
> +		drm_splash_modeset_off(client->dev, modeset);
> +	mutex_unlock(&client->modeset_mutex);
> +
> +	drm_splash_delete_scanouts(&splash->scanout, &splash->n_scanout);
> +}
> +
> +static int drm_splash_client_hotplug(struct drm_client_dev *client)
> +{
> +	struct drm_splash *splash = client_to_drm_splash(client);
> +	int ret;
> +
> +	guard(mutex)(&splash->lock);
> +
> +	/*
> +	 * Every hotplug starts over, with the outputs there are now. The
> +	 * scanouts on screen stay there until the work or restore has
> +	 * committed the new ones; with some still waiting for that, the
> +	 * current ones were never committed and can go.
> +	 */
> +	if (splash->old_scanout) {
> +		drm_splash_free_scanout(client);
> +	} else {
> +		splash->old_scanout = splash->scanout;
> +		splash->n_old_scanout = splash->n_scanout;
> +		splash->scanout = NULL;
> +		splash->n_scanout = 0;
> +	}
> +
> +	ret = drm_splash_init_client(splash);
> +	if (ret) {
> +		/*
> +		 * It may have set up scanouts before failing to get buffers.
> +		 * Those on screen stay there, for the next hotplug to replace.
> +		 */
> +		drm_splash_free_scanout(client);
> +		if (ret == -ENODEV)
> +			drm_dbg(client->dev, "splash: no usable modeset\n");
> +		else
> +			drm_err(client->dev,
> +				"splash: failed to init client: %d\n", ret);
> +
> +		/* An error would stop the hotplug events: let the next one retry */
> +		return 0;
> +	}
> +
> +	if (!splash->source_picked) {
> +		splash->source_picked = true;
> +		splash->use_bgrt = drm_splash_bgrt_available(splash);
> +
> +		/* If no other image has been loaded, try to load a BMP as firmware */
> +		if (IS_ENABLED(CONFIG_DRM_CLIENT_SPLASH_SRC_BMP) && !splash->use_bgrt) {
> +			ret = drm_splash_fw_request_bmp(splash);
> +			splash->fw_requested = !ret;
> +			if (ret)
> +				drm_err(client->dev,
> +					"splash: failed to kick image load: %d\n", ret);
> +		}
> +	}
> +
> +	drm_splash_queue(splash);
> +
> +	return 0;
> +}
> +
> +/* An output without a buffer has no mode either: the commit switches it off */
> +static int drm_splash_client_restore(struct drm_client_dev *client, bool force)
> +{
> +	struct drm_splash *splash = client_to_drm_splash(client);
> +	int ret;
> +
> +	guard(mutex)(&splash->lock);
> +
> +	/* Not while the device sleeps: resume runs the work, which commits */
> +	if (splash->suspended) {
> +		splash->work_skipped = true;
> +		return 0;
> +	}
> +
> +	if (force)
> +		ret = drm_client_modeset_commit_locked(client);
> +	else
> +		ret = drm_client_modeset_commit(client);
> +
> +	/* Whatever a hotplug replaced is no longer on screen */
> +	if (!ret)
> +		drm_splash_delete_scanouts(&splash->old_scanout,
> +					   &splash->n_old_scanout);
> +
> +	return ret;
> +}
> +
> +static void drm_splash_client_unregister(struct drm_client_dev *client)
> +{
> +	struct drm_splash *splash = client_to_drm_splash(client);
> +
> +	/*
> +	 * A firmware request cannot be cancelled, and its callback uses the
> +	 * splash and queues the work: let it finish first. It is usually over
> +	 * already; at worst this waits for the firmware fallback timeout.
> +	 */
> +	if (splash->fw_requested)
> +		wait_for_completion(&splash->fw_done);
> +
> +	/* Hotplug events no longer come, so nothing queues the work again */
> +	cancel_work_sync(&splash->work);
> +	drm_splash_free_scanout(client);
> +	drm_splash_delete_scanouts(&splash->old_scanout, &splash->n_old_scanout);
> +	drm_splash_image_cleanup(splash);
> +	mutex_destroy(&splash->lock);
> +
> +	/* Last: it ends up in drm_splash_client_free(), which frees splash */
> +	drm_client_release(client);
> +}
> +
> +static void drm_splash_client_free(struct drm_client_dev *client)
> +{
> +	struct drm_splash *splash = client_to_drm_splash(client);
> +	struct drm_device *dev = client->dev;
> +
> +	kfree(splash);
> +
> +	drm_dbg(dev, "Freed drm splash\n");
> +}
> +
> +static int drm_splash_client_suspend(struct drm_client_dev *client)
> +{
> +	struct drm_splash *splash = client_to_drm_splash(client);
> +
> +	guard(mutex)(&splash->lock);
> +	splash->suspended = true;
> +
> +	return 0;
> +}
> +
> +static int drm_splash_client_resume(struct drm_client_dev *client)
> +{
> +	struct drm_splash *splash = client_to_drm_splash(client);
> +
> +	guard(mutex)(&splash->lock);
> +	splash->suspended = false;
> +	if (splash->work_skipped) {
> +		splash->work_skipped = false;
> +		drm_splash_queue(splash);
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct drm_client_funcs drm_splash_client_funcs = {
> +	.owner		= THIS_MODULE,
> +	.hotplug	= drm_splash_client_hotplug,
> +	.restore	= drm_splash_client_restore,
> +	.unregister	= drm_splash_client_unregister,
> +	.free		= drm_splash_client_free,
> +	.suspend	= drm_splash_client_suspend,
> +	.resume		= drm_splash_client_resume,
> +};
> +
> +/**
> + * drm_splash_register() - Register a drm device to drm_splash
> + * @dev: the drm device to register.
> + * @format: drm device preferred format.
> + */
> +void drm_splash_register(struct drm_device *dev,
> +			 const struct drm_format_info *format)
> +{
> +	struct drm_splash *splash;
> +
> +	splash = kzalloc_obj(*splash);
> +	if (!splash)
> +		goto err_warn;
> +
> +	INIT_WORK(&splash->work, drm_splash_work);
> +	mutex_init(&splash->lock);
> +	init_completion(&splash->fw_done);
> +
> +	if (format && format->num_planes == 1) {
> +		splash->preferred_format = format->format;
> +	} else {
> +		unsigned int mode = dev->mode_config.preferred_depth;
> +
> +		/* As fbdev: 32 bits per pixel, unless the driver wants fewer */
> +		if (!mode || mode == 24)
> +			mode = 32;
> +		splash->preferred_format =
> +			drm_driver_color_mode_format(dev, mode);
> +	}
> +
> +	if (drm_client_init(dev, &splash->client, "drm_splash",
> +			    &drm_splash_client_funcs))
> +		goto err_free;
> +
> +	drm_client_register(&splash->client);
> +	drm_dbg(dev, "Registered with drm splash\n");
> +
> +	return;
> +
> +err_free:
> +	mutex_destroy(&splash->lock);
> +	kfree(splash);
> +err_warn:
> +	drm_warn(dev, "Failed to register with drm splash\n");
> +}

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Stefan Gaiser, Jochen Jaser, Abhinav Puri, (HRB 36809, AG Nürnberg)


