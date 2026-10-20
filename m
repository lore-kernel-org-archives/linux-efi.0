Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792494274;
	b=FV2RdtvUzyuxpMNpHLr1XTpC29gjLIy4YrYk+T10LU/hElTjBxC6RcAttr4D8AYtvXFU
	 xfswfSqWW8eeRPq6sPK2dyNM9ydCnSPPp023kxMPoF+NKQkOp72B2alsKptl+ZCUp957l
	 SCNxdN6s77bdkU0bPu7pq51M4MUjw3Gq39nFYtfWu8akNoTlSNJkQAy+9sJmHQI+PAB2Z
	 WOEfmkZCTDc3qohxBNXLaybBCiq+6dJQ7YhDx3FrXKrxUsSezhJIZ+w2MZbq58/YzAXSa
	 JqhhlAHbJGKVQMo2Ala0rgEl7E/GKQUau12xPfmylw6J7UN1ulLrUBhrlWYcwb9ga2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792494274;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=wpVq8HTF6kp3l3+P+HlqkQvEgOT+i0h0AfpydZ4MNoA=;
	b=3jjUvqHR5D08cPyDz9WOC0W8DT9h8mDMgBLWVcMEdYsWKaX751Y9lKPR14ykmkuHKg+V
	 2Ay7kKWVHQcZjwVs1Yjz8Su9VNADpWIBaBoidJkmPG4ET7ZEzr0PQrY+0m87TrLSHAacF
	 saZ01OyGQgOgarUAzsBz9W3TNF0VDc2eXIOhy6IEHf1o4KA5BDI79E5YPspRJ9tdRR4kA
	 7Q+guPbcvLXZWDqIFh7jIa0QEZsawi9LJmbW3p99f0zW13JLSzTrVmSqbfxmpC2BwMIQL
	 Rmdo7DKJ/un144H0j9UbwjPCSm9k4Dk3rnz/IZRN6rqSfTz6RvEuTM1GKAPtbzoCd+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=LZCVchYP;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=UbP7T0A5;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=LZCVchYP;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=UbP7T0A5;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7980E606A319;
	Tue, 20 Oct 2026 11:04:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7980E606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=LZCVchYP;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=UbP7T0A5;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=LZCVchYP;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=UbP7T0A5
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 49FEC21C99;
	Tue, 20 Oct 2026 11:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792494264; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wpVq8HTF6kp3l3+P+HlqkQvEgOT+i0h0AfpydZ4MNoA=;
	b=LZCVchYPxngjyrTdwP7dDyGwjGeRlfwz6xzaWNSZtF8y3Qgf12SIhyh9Y6Nd0wcT7He1aK
	YWofyhmxglbBVNhGLztczgk2ut0LSAYokiSZEVTLZunTZ4Jh8IVD6VEwHTFDIw5kayF9gZ
	vwrWwtjorhJFX/VTys9hwrEgQyblgzQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792494264;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wpVq8HTF6kp3l3+P+HlqkQvEgOT+i0h0AfpydZ4MNoA=;
	b=UbP7T0A54+niJcsOuJ4B/+AeErov5GjTeJBZVnwBx1FlP4R5goEFKis3ur6UZEwIpgqvEs
	JSlX8AaT2FdapVAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792494264; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wpVq8HTF6kp3l3+P+HlqkQvEgOT+i0h0AfpydZ4MNoA=;
	b=LZCVchYPxngjyrTdwP7dDyGwjGeRlfwz6xzaWNSZtF8y3Qgf12SIhyh9Y6Nd0wcT7He1aK
	YWofyhmxglbBVNhGLztczgk2ut0LSAYokiSZEVTLZunTZ4Jh8IVD6VEwHTFDIw5kayF9gZ
	vwrWwtjorhJFX/VTys9hwrEgQyblgzQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792494264;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wpVq8HTF6kp3l3+P+HlqkQvEgOT+i0h0AfpydZ4MNoA=;
	b=UbP7T0A54+niJcsOuJ4B/+AeErov5GjTeJBZVnwBx1FlP4R5goEFKis3ur6UZEwIpgqvEs
	JSlX8AaT2FdapVAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 90833136CC;
	Tue, 20 Oct 2026 11:04:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dCK0ErdK12o2ZQAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Tue, 20 Oct 2026 11:04:23 +0000
Message-ID: <9834b569-935c-484b-befb-b913acead9c1@suse.de>
Date: Tue, 20 Oct 2026 13:04:22 +0200
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
Subject: Re: [PATCH v5 07/13] drm/client: splash: add a device tree image
 source
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
 <20261013093243.505776-8-maximpedraza@gmail.com>
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
In-Reply-To: <20261013093243.505776-8-maximpedraza@gmail.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:url]
X-Spam-Score: -2.79
X-Spam-Level: 
X-Spam-Flag: NO

Hi

Am 13.10.26 um 11:32 schrieb Màxim Pedraza Padilla:
> Embedded products often share one kernel image and one board support
> package across several models that differ in branding. The splash
> client can show the firmware's BGRT image or a BMP loaded as firmware,
> but a device tree system has no BGRT, and a BMP loaded as firmware is
> either built into the kernel, which means one kernel per logo, or read
> from a filesystem that is not there yet when the display comes up. With
> U-Boot's Falcon mode the SPL starts the kernel directly, and the device
> tree is the only thing that reaches it.
>
> Add a source that takes the image from a "boot-logo" node under /chosen.
> The BMP either sits in the node itself, in an "image" property that dtc
> fills in with /incbin/, or in a reserved memory region the bootloader
> loaded it into, named by "memory-region". Exactly one of the two must be
> present; a node with both or neither is ignored with a warning.
>
> The image in the node is used where it is: the device tree stays in
> memory, so there is nothing to copy or release. The region is mapped
> like the BGRT image, and the BMP header is checked against its size.
>
> A node is only there if someone put it there for that board, so the
> device tree goes first, then the BGRT, then the BMP loaded as firmware.
> The boolean that chose between the latter two becomes an enum naming
> the one source in use.
>
> Assisted-by: Claude:claude-opus-5-5
> Signed-off-by: Màxim Pedraza Padilla <maximpedraza@gmail.com>
> ---
>   drivers/gpu/drm/clients/Kconfig      |  15 +++
>   drivers/gpu/drm/clients/drm_splash.c | 166 ++++++++++++++++++++++++---
>   2 files changed, 165 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/gpu/drm/clients/Kconfig b/drivers/gpu/drm/clients/Kconfig
> index cbe271c3a23f..aef3781cc110 100644
> --- a/drivers/gpu/drm/clients/Kconfig
> +++ b/drivers/gpu/drm/clients/Kconfig
> @@ -108,6 +108,21 @@ config DRM_CLIENT_SPLASH_BACKGROUND_COLOR
>   	  The color can be overridden through the drm_client_lib.splash_color
>   	  kernel command line parameter.
>   
> +config DRM_CLIENT_SPLASH_SRC_DT
> +	bool "Device tree as splash source"
> +	depends on DRM_CLIENT_SPLASH
> +	depends on OF
> +	select DRM_CLIENT_SPLASH_BMP_SUPPORT
> +	help
> +	  Use a BMP image described by a "boot-logo" node under /chosen in
> +	  the device tree, either carried in the node itself or placed by the
> +	  bootloader in a reserved memory region. This lets one kernel image
> +	  show a different logo on each board or product, chosen by the
> +	  device tree it boots with.
> +
> +	  When present, the device tree image is preferred over the other
> +	  sources.
> +
>   config DRM_CLIENT_SPLASH_SRC_BGRT
>   	bool "EFI BGRT as splash source"
>   	depends on DRM_CLIENT_SPLASH
> diff --git a/drivers/gpu/drm/clients/drm_splash.c b/drivers/gpu/drm/clients/drm_splash.c
> index a7d627954158..50842922a7f8 100644
> --- a/drivers/gpu/drm/clients/drm_splash.c
> +++ b/drivers/gpu/drm/clients/drm_splash.c
> @@ -9,9 +9,12 @@
>   #include <linux/efi-bgrt.h>
>   #include <linux/firmware.h>
>   #include <linux/init.h>
> +#include <linux/io.h>
>   #include <linux/iosys-map.h>
>   #include <linux/kthread.h>
>   #include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_reserved_mem.h>
>   #include <linux/overflow.h>
>   #include <linux/types.h>
>   #include <linux/unaligned.h>
> @@ -71,6 +74,14 @@ struct bmp_dib_header {
>   	__le32 colors_important;
>   } __packed;
>   
> +/* Where the image comes from, in order of preference */
> +enum drm_splash_source {
> +	DRM_SPLASH_SRC_NONE,
> +	DRM_SPLASH_SRC_DT,
> +	DRM_SPLASH_SRC_BGRT,
> +	DRM_SPLASH_SRC_BMP,
> +};

The logic behind this enum deserves a separate patch, I think.

Best regards
Thomas

> +
>   struct drm_splash_scanout {
>   	int id;
>   	/* Modesets scanning this buffer out, by position in the list */
> @@ -110,7 +121,7 @@ struct drm_splash {
>   	bool render_done;
>   	void *map_data;
>   
> -	bool use_bgrt;
> +	enum drm_splash_source src;
>   };
>   
>   static struct drm_splash *client_to_drm_splash(struct drm_client_dev *client)
> @@ -212,6 +223,114 @@ static int drm_splash_fw_request_bmp(struct drm_splash *splash)
>   }
>   #endif // CONFIG_DRM_CLIENT_SPLASH_SRC_BMP
>   
> +#if IS_ENABLED(CONFIG_DRM_CLIENT_SPLASH_SRC_DT)
> +#define DRM_SPLASH_DT_COMPATIBLE "boot-logo"
> +
> +/*
> + * The boot logo node, if the device tree has a usable one. Only a child of
> + * /chosen is considered, not anything compatible anywhere in the tree: the
> + * image is configuration handed over by the firmware, not a device.
> + */
> +static struct device_node *drm_splash_dt_node(struct drm_splash *splash)
> +{
> +	struct drm_client_dev *client = &splash->client;
> +	struct device_node *np;
> +	bool image, region;
> +
> +	np = of_get_compatible_child(of_chosen, DRM_SPLASH_DT_COMPATIBLE);
> +	if (!np)
> +		return NULL;
> +
> +	if (!of_device_is_available(np))
> +		goto out_put;
> +
> +	image = of_property_present(np, "image");
> +	region = of_property_present(np, "memory-region");
> +	if (image == region) {
> +		drm_warn(client->dev,
> +			 "splash: %pOF needs exactly one of image or memory-region",
> +			 np);
> +		goto out_put;
> +	}
> +
> +	return np;
> +
> +out_put:
> +	of_node_put(np);
> +	return NULL;
> +}
> +
> +static bool drm_splash_dt_available(struct drm_splash *splash)
> +{
> +	struct device_node *np = drm_splash_dt_node(splash);
> +
> +	of_node_put(np);
> +
> +	return np;
> +}
> +
> +static int drm_splash_dt_load(struct drm_splash *splash, const u8 **data,
> +			      size_t *size)
> +{
> +	struct drm_client_dev *client = &splash->client;
> +	struct device_node *np;
> +	struct resource res;
> +	const void *prop;
> +	int len, ret = 0;
> +
> +	np = drm_splash_dt_node(splash);
> +	if (!np)
> +		return -ENOENT;
> +
> +	/*
> +	 * An image in the node is used in place: the device tree stays in
> +	 * memory for as long as the system runs, so there is nothing to copy
> +	 * and nothing to release.
> +	 */
> +	prop = of_get_property(np, "image", &len);
> +	if (prop) {
> +		*data = prop;
> +		*size = len;
> +		goto out_put;
> +	}
> +
> +	/* Otherwise the bootloader loaded it into a reserved region */
> +	ret = of_reserved_mem_region_to_resource(np, 0, &res);
> +	if (ret) {
> +		drm_warn(client->dev, "splash: %pOF: no usable memory-region: %d",
> +			 np, ret);
> +		goto out_put;
> +	}
> +
> +	splash->map_data = memremap(res.start, resource_size(&res),
> +				    MEMREMAP_WB);
> +	if (!splash->map_data) {
> +		drm_warn(client->dev, "splash: failed to map %pR", &res);
> +		ret = -ENOMEM;
> +		goto out_put;
> +	}
> +
> +	/* The BMP header, checked against this size, says how much is image */
> +	*data = splash->map_data;
> +	*size = resource_size(&res);
> +
> +out_put:
> +	of_node_put(np);
> +	return ret;
> +}
> +#else
> +static bool drm_splash_dt_available(struct drm_splash *splash)
> +{
> +	return false;
> +}
> +
> +static int drm_splash_dt_load(struct drm_splash *splash,
> +			      const u8 **data, size_t *size)
> +{
> +	return -EOPNOTSUPP;
> +}
> +#endif // CONFIG_DRM_CLIENT_SPLASH_SRC_DT
> +
>   static bool drm_splash_bgrt_available(struct drm_splash *splash)
>   {
>   	struct drm_client_dev *client = &splash->client;
> @@ -489,7 +608,7 @@ static int drm_splash_bmp_to_scanout(struct drm_splash *splash,
>   		return -EINVAL;
>   	}
>   
> -	if (splash->use_bgrt) {
> +	if (splash->src == DRM_SPLASH_SRC_BGRT) {
>   		x_pad = efi_bgrt_image_offset_x();
>   		y_pad = efi_bgrt_image_offset_y();
>   
> @@ -582,19 +701,34 @@ static int drm_splash_bmp_to_scanout(struct drm_splash *splash,
>   static int drm_splash_image_load(struct drm_splash *splash, const u8 **img_data,
>   				 size_t *img_data_len)
>   {
> -	int ret = 0;
> -
> -	if (splash->use_bgrt) {
> -		ret = drm_splash_bgrt_load(splash, img_data, img_data_len);
> -		if (ret)
> -			splash->use_bgrt = false;
> +	switch (splash->src) {
> +	case DRM_SPLASH_SRC_DT:
> +		return drm_splash_dt_load(splash, img_data, img_data_len);
> +	case DRM_SPLASH_SRC_BGRT:
> +		return drm_splash_bgrt_load(splash, img_data, img_data_len);
> +	case DRM_SPLASH_SRC_BMP:
> +		return drm_splash_fw_load(splash, img_data, img_data_len);
> +	default:
> +		return -ENOENT;
>   	}
> +}
>   
> -	/* BGRT failed to load */
> -	if (!splash->use_bgrt)
> -		ret = drm_splash_fw_load(splash, img_data, img_data_len);
> -
> -	return ret;
> +/*
> + * Pick the one source the image will come from. A device tree node is only
> + * there if someone put it there for this board, so it goes first; the BGRT
> + * is whatever the firmware shows, and the BMP loaded as firmware is the
> + * fallback. With none of them, only the background colour is drawn.
> + */
> +static enum drm_splash_source drm_splash_pick_source(struct drm_splash *splash)
> +{
> +	if (drm_splash_dt_available(splash))
> +		return DRM_SPLASH_SRC_DT;
> +	if (drm_splash_bgrt_available(splash))
> +		return DRM_SPLASH_SRC_BGRT;
> +	if (IS_ENABLED(CONFIG_DRM_CLIENT_SPLASH_SRC_BMP))
> +		return DRM_SPLASH_SRC_BMP;
> +
> +	return DRM_SPLASH_SRC_NONE;
>   }
>   
>   static void drm_splash_image_cleanup(struct drm_splash *splash)
> @@ -909,10 +1043,10 @@ static int drm_splash_client_hotplug(struct drm_client_dev *client)
>   	get_task_struct(thread);
>   	splash->thread = thread;
>   
> -	splash->use_bgrt = drm_splash_bgrt_available(splash);
> +	splash->src = drm_splash_pick_source(splash);
>   
> -	/* If no other image has been loaded, try to load a BMP as firmware */
> -	if (IS_ENABLED(CONFIG_DRM_CLIENT_SPLASH_SRC_BMP) && !splash->use_bgrt) {
> +	/* The BMP loaded as firmware is the only source that arrives later */
> +	if (splash->src == DRM_SPLASH_SRC_BMP) {
>   		WRITE_ONCE(splash->fw_pending, true);
>   		ret = drm_splash_fw_request_bmp(splash);
>   		splash->fw_requested = !ret;

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Stefan Gaiser, Jochen Jaser, Abhinav Puri, (HRB 36809, AG Nürnberg)


