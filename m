Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794402265;
	b=wEwT6526htIEVwYcv2Z3MslNEr0EXR8jQrdOjHK0lzgugSsIfwshQRQ9v4NOXFZvSItJ
	 87ujcqgAvsROeHoYkDanrrbshs5SdH925sZG253qlL0IYvAbOtM8YeXw9V2CzmtL74Jcs
	 8oGp63NrV4LN1of3WDOIe8KjuJHjz8FdYWedRuAkE714iy6UVGoWtqnGIdC1XZYRzMSjc
	 bvKUE5EchDFn4/0feOGwRQo6PODgrzVZlWVMNPpJhQYJbKqOr9yeyZS3OP+BkZplkOF3l
	 N9XtCl5cepH5uIResqGMWR2v/g8Aakh3yiMbYk6HOUigouoVkLIVI2oZizzc1neRnqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794402265;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Spam-Flag:
	 X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=hXIi1oTzxmzik4fQEkb2sT89bv5gy4wFQ0vSFZHeTvU=;
	b=XL9uxpKznqf9KHzNkxYtmnLBdSFQtHLjIsm4sK0Or7FEfvboRt+7QX+nUr0dfKnRnQat
	 4nEgKv5ivaeWVTKIUbiyJ4sxtNslG28TP1nTY9GK9U89Qr5bDDBlb/w1vVnElo31ZcCgp
	 NQdXXMhVA1KEz70WJSpkVn9fDwGNDHx4fko7e5HlNTNJTAn5o6XV9JePHfHfMw9qt3YDs
	 PVsCyYRTZ0DeN2sqTd1jc4FFo0PjpeXbTcdjhQBXT03XrD4aCuZMCZCMoPXM5cEayDP2d
	 IbUZmzCBXd1Ok2OT3Dfp7rcZaoDoS9THTOVY2kFz2Hqc9lBVoW9tCo84fmprRpUdW1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=DtZI6Reu;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=B99jS6Jf;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=DtZI6Reu;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=B99jS6Jf;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA27606A326;
	Wed, 11 Nov 2026 13:04:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DAA27606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=DtZI6Reu;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=B99jS6Jf;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=DtZI6Reu;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=B99jS6Jf
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4A70F5C4E0;
	Wed, 11 Nov 2026 13:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794402255; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hXIi1oTzxmzik4fQEkb2sT89bv5gy4wFQ0vSFZHeTvU=;
	b=DtZI6Reur2+aCCjHwohRzTX/jLFEtllaTu/GZ3Wb7fb5a0KCUQplnUpIsIy4XOZeS3mgmF
	SJdeMdV2GkgeSvy25qEK8DxAk/SQAq/AkgH9r2+XFb/HL86bVD35DJQn+uonwCCtC4fU10
	yjP+aq+CEMk2AnA6kNTAn6PhmDxihq8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794402255;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hXIi1oTzxmzik4fQEkb2sT89bv5gy4wFQ0vSFZHeTvU=;
	b=B99jS6Jf/Ym/k/J5HtVXOw06J0NYUWt1DlgTasENiCFMSag9Sbp2dZcPkTVPmrf7mfK/77
	I01KAjdzSWPUBjAA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794402255; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hXIi1oTzxmzik4fQEkb2sT89bv5gy4wFQ0vSFZHeTvU=;
	b=DtZI6Reur2+aCCjHwohRzTX/jLFEtllaTu/GZ3Wb7fb5a0KCUQplnUpIsIy4XOZeS3mgmF
	SJdeMdV2GkgeSvy25qEK8DxAk/SQAq/AkgH9r2+XFb/HL86bVD35DJQn+uonwCCtC4fU10
	yjP+aq+CEMk2AnA6kNTAn6PhmDxihq8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794402255;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hXIi1oTzxmzik4fQEkb2sT89bv5gy4wFQ0vSFZHeTvU=;
	b=B99jS6Jf/Ym/k/J5HtVXOw06J0NYUWt1DlgTasENiCFMSag9Sbp2dZcPkTVPmrf7mfK/77
	I01KAjdzSWPUBjAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 566151339F;
	Wed, 11 Nov 2026 13:04:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uVx7A81n9GoAOAAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Wed, 11 Nov 2026 13:04:13 +0000
Message-ID: <a23d9d70-a2e1-49a9-a590-3a3c035d5f1b@suse.de>
Date: Wed, 11 Nov 2026 14:04:12 +0100
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
Subject: Re: [PATCH v6 03/15] fbdev: efifb: move the BMP headers to
 <video/bmp.h>
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
 <20261027135342.2003632-4-maximpedraza@gmail.com>
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
In-Reply-To: <20261027135342.2003632-4-maximpedraza@gmail.com>
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
	TAGGED_RCPT(0.00)[dt];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[28];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com,linux.intel.com,kernel.org,ffwll.ch,lwn.net,gmx.de,redhat.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,gmx.de];
	R_RATELIMIT(0.00)[to_ip_from(RL9smr3mp78sgfo6am5n6ykess)];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.com:url,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -11.79



Am 27.10.26 um 14:53 schrieb Màxim Pedraza Padilla:
> The DRM splash client parses the same BMP headers as efifb. Rather than
> keep a second copy of the structures, move them to include/video/bmp.h
> with the magic number.
>
> BMP is little endian whatever the CPU, so the header gives the fields
> as __le16 and __le32, and efifb now reads them with
> get_unaligned_le16() and get_unaligned_le32(). Width and height are
> read signed, as the format has them. No change on the little endian
> systems EFI runs on.
>
> Suggested-by: Thomas Zimmermann <tzimmermann@suse.de>
> Assisted-by: Claude:claude-opus-5-5
> Signed-off-by: Màxim Pedraza Padilla <maximpedraza@gmail.com>

Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>

> ---
>
> Notes:
>      TODO for the efifb maintainers, not changed here so that this patch
>      only moves the headers: the bound check
>      
>      	if ((bitmap_offset + bmp_pitch * bmp_height) > bgrt_image_size)
>      
>      is done in u32 and can wrap with a crafted BGRT image, for instance
>      with a bitmap_offset close to 4 GiB, and so can round_up(3 * bmp_width,
>      4) and the product with a huge width; image_offset_x + bmp_width against
>      lfb_width is a u32 sum too. efifb_copy_bmp() would then read outside the
>      mapped image. The DRM splash client checks the same headers with
>      check_add_overflow() and check_mul_overflow(). I can send a separate fix
>      if wanted.
>
>   drivers/video/fbdev/efifb.c | 49 ++++++++++++++-----------------------
>   include/video/bmp.h         | 40 ++++++++++++++++++++++++++++++
>   2 files changed, 58 insertions(+), 31 deletions(-)
>   create mode 100644 include/video/bmp.h
>
> diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
> index 3411be06d3e6..fd348a72f780 100644
> --- a/drivers/video/fbdev/efifb.c
> +++ b/drivers/video/fbdev/efifb.c
> @@ -16,32 +16,13 @@
>   #include <linux/platform_device.h>
>   #include <linux/printk.h>
>   #include <linux/sysfb.h>
> +#include <linux/unaligned.h>
> +#include <video/bmp.h>
>   #include <video/vga.h>
>   #include <asm/efi.h>
>   #include <drm/drm_connector.h>  /* For DRM_MODE_PANEL_ORIENTATION_* */
>   #include <drm/drm_panel_quirks.h> /* For drm_get_panel_orientation_quirk */
>   
> -struct bmp_file_header {
> -	u16 id;
> -	u32 file_size;
> -	u32 reserved;
> -	u32 bitmap_offset;
> -} __packed;
> -
> -struct bmp_dib_header {
> -	u32 dib_header_size;
> -	s32 width;
> -	s32 height;
> -	u16 planes;
> -	u16 bpp;
> -	u32 compression;
> -	u32 bitmap_size;
> -	u32 horz_resolution;
> -	u32 vert_resolution;
> -	u32 colors_used;
> -	u32 colors_important;
> -} __packed;
> -
>   static bool use_bgrt = true;
>   static bool request_mem_succeeded = false;
>   static u64 mem_flags = EFI_MEMORY_WC | EFI_MEMORY_UC;
> @@ -145,9 +126,10 @@ static bool efifb_bgrt_sanity_check(const struct screen_info *si, u32 bmp_width)
>   
>   static void efifb_show_boot_graphics(struct fb_info *info, const struct screen_info *si)
>   {
> -	u32 bmp_width, bmp_height, bmp_pitch, dst_x, y, src_y;
> +	u32 bmp_width, bmp_height, bmp_pitch, bitmap_offset, dst_x, y, src_y;
>   	struct bmp_file_header *file_header;
>   	struct bmp_dib_header *dib_header;
> +	s32 width, height;
>   	void *bgrt_image = NULL;
>   	u8 *dst = info->screen_base;
>   
> @@ -186,20 +168,25 @@ static void efifb_show_boot_graphics(struct fb_info *info, const struct screen_i
>   		goto error;
>   
>   	file_header = bgrt_image;
> -	if (file_header->id != 0x4d42 || file_header->reserved != 0)
> +	if (get_unaligned_le16(&file_header->id) != BMP_FILE_MAGIC_ID ||
> +	    get_unaligned_le32(&file_header->reserved) != 0)
>   		goto error;
> +	bitmap_offset = get_unaligned_le32(&file_header->bitmap_offset);
>   
>   	dib_header = bgrt_image + sizeof(*file_header);
> -	if (dib_header->dib_header_size != 40 || dib_header->width < 0 ||
> -	    dib_header->planes != 1 || dib_header->bpp != 24 ||
> -	    dib_header->compression != 0)
> +	width = get_unaligned_le32(&dib_header->width);
> +	height = get_unaligned_le32(&dib_header->height);
> +	if (get_unaligned_le32(&dib_header->dib_header_size) != 40 ||
> +	    width < 0 || get_unaligned_le16(&dib_header->planes) != 1 ||
> +	    get_unaligned_le16(&dib_header->bpp) != 24 ||
> +	    get_unaligned_le32(&dib_header->compression) != 0)
>   		goto error;
>   
> -	bmp_width = dib_header->width;
> -	bmp_height = abs(dib_header->height);
> +	bmp_width = width;
> +	bmp_height = abs(height);
>   	bmp_pitch = round_up(3 * bmp_width, 4);
>   
> -	if ((file_header->bitmap_offset + bmp_pitch * bmp_height) >
> +	if ((bitmap_offset + bmp_pitch * bmp_height) >
>   				bgrt_image_size)
>   		goto error;
>   
> @@ -222,12 +209,12 @@ static void efifb_show_boot_graphics(struct fb_info *info, const struct screen_i
>   
>   		src_y = y - bgrt_tab.image_offset_y;
>   		/* Positive header height means upside down row order */
> -		if (dib_header->height > 0)
> +		if (height > 0)
>   			src_y = (bmp_height - 1) - src_y;
>   
>   		memset(dst, 0, bgrt_tab.image_offset_x * 4);
>   		dst_x = bgrt_tab.image_offset_x;
> -		efifb_copy_bmp(bgrt_image + file_header->bitmap_offset +
> +		efifb_copy_bmp(bgrt_image + bitmap_offset +
>   					    src_y * bmp_pitch,
>   			       (u32 *)dst + dst_x, bmp_width, si);
>   		dst_x += bmp_width;
> diff --git a/include/video/bmp.h b/include/video/bmp.h
> new file mode 100644
> index 000000000000..8aa249f2302f
> --- /dev/null
> +++ b/include/video/bmp.h
> @@ -0,0 +1,40 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _VIDEO_BMP_H
> +#define _VIDEO_BMP_H
> +
> +#include <linux/types.h>
> +
> +/* "BM", the first two bytes of a BMP file */
> +#define BMP_FILE_MAGIC_ID 0x4d42
> +
> +/*
> + * The headers at the start of a BMP file. Every field is little endian,
> + * whatever the CPU, and the headers need not be aligned in memory: read them
> + * with get_unaligned_le16() and get_unaligned_le32().
> + */
> +struct bmp_file_header {
> +	__le16 id;
> +	__le32 file_size;
> +	__le32 reserved;
> +	__le32 bitmap_offset;
> +} __packed;
> +
> +/*
> + * BITMAPINFOHEADER. Width and height are signed: a negative width means
> + * nothing, and a negative height that the rows go top to bottom.
> + */
> +struct bmp_dib_header {
> +	__le32 dib_header_size;
> +	__le32 width;
> +	__le32 height;
> +	__le16 planes;
> +	__le16 bpp;
> +	__le32 compression;
> +	__le32 bitmap_size;
> +	__le32 horz_resolution;
> +	__le32 vert_resolution;
> +	__le32 colors_used;
> +	__le32 colors_important;
> +} __packed;
> +
> +#endif /* _VIDEO_BMP_H */

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Stefan Gaiser, Jochen Jaser, Abhinav Puri, (HRB 36809, AG Nürnberg)


