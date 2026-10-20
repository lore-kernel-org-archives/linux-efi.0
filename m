Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792487647;
	b=5i7p2WYhtAdHvgxOnKmRF6Ri5lpwHmpp+PeY/LNd5y+9ZvCFirMbw+Is3c7pP0dJ5+1w
	 YIglbb/4fxh3kFXM3C/IzFsAUjA0Amukur5uU20aWGmOvB7LkZ3pTRaD4jLwgXPuORHBq
	 jMsR6vgvXL8kMvRAicplfZAq0eGDOmN1lFTLVXVBcd29IyTCoyAwkUDbQvZ0TJxdSyruG
	 kNdZ30WflEWveq7sWYiJhqfsHhTDbayLDEvJHveo1owZWbdfBsfzGnmqen/xsHFgwYDjR
	 dyU4jB8GGzdlsy0y5CdvYX8RKtcHNdO/+poyvDRcdmk5H1jOf2mISMQU8uy0q7v1nVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792487647;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Rspamd-Server:
	 X-Rspamd-Queue-Id:X-Rspamd-Action:X-Spam-Level:X-Spamd-Result:
	 X-Spam-Flag:X-Spam-Score;
	bh=RQmY0M9tjegDMEezsQ5hlFkCwb+QHN9rMXnNEMTbaII=;
	b=VwcZvtLY2/zNG5r4KDPRNK2VeI0nzl0Hbibx5a2yomb5J7Apf+kvup3Wty8i0toJlGxk
	 cYdoboZKNaJG9VRqDCNM5H15hgDEUjdRZgK60pt38MOLtLEPwYHXcQwUt4k3UQeF35281
	 rtdjFe49d2Cd5F1K1Tr5M4/KJ0jFOf94X49pckGO2ficpqpmypgVqsmOiBhPToqxbFwhq
	 KDXyHGKU1qM1yqzWb+wdmN2TO4xoNtEMvPmZZO5nhO2w9VQju1h2TiZrfVdKqcmIpQZRp
	 IWyaT0E4iEeQl4qY2R0m7/W4WOtYF9II7gP9ZbibFVjfMzfsNcQQaq1N/pqi3fKzWmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=FabIPXEb;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=qz5T1yBj;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=FabIPXEb;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=qz5T1yBj;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B67F606A31D;
	Tue, 20 Oct 2026 09:14:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B67F606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=FabIPXEb;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=qz5T1yBj;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=FabIPXEb;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=qz5T1yBj
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B8EE91F44E;
	Tue, 20 Oct 2026 09:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792487637; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RQmY0M9tjegDMEezsQ5hlFkCwb+QHN9rMXnNEMTbaII=;
	b=FabIPXEbdQj8PnsJLgzWdOf0WlEkKJ31RrCT4zjm8/5VkwE1fDv9WOtYbaxqB1TqxZ3vry
	RjRYv+jx0Zo6P6GqGNjq/Kj1H/GNol08e6Wl/FbloYUJayPGz3HC9Z+EOQ3EHBZc33F2CI
	IDqAktxOkzYlACENhzTuztADxpMNaOA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792487637;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RQmY0M9tjegDMEezsQ5hlFkCwb+QHN9rMXnNEMTbaII=;
	b=qz5T1yBjGy5qGXamBQRVTNpt+TV9+BJ51Dqbcj8/GhO2kTgQNcw6X8xHiwAn0iLcc7lbld
	W5qJSMBDztjCC6DA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FabIPXEb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qz5T1yBj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792487637; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RQmY0M9tjegDMEezsQ5hlFkCwb+QHN9rMXnNEMTbaII=;
	b=FabIPXEbdQj8PnsJLgzWdOf0WlEkKJ31RrCT4zjm8/5VkwE1fDv9WOtYbaxqB1TqxZ3vry
	RjRYv+jx0Zo6P6GqGNjq/Kj1H/GNol08e6Wl/FbloYUJayPGz3HC9Z+EOQ3EHBZc33F2CI
	IDqAktxOkzYlACENhzTuztADxpMNaOA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792487637;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RQmY0M9tjegDMEezsQ5hlFkCwb+QHN9rMXnNEMTbaII=;
	b=qz5T1yBjGy5qGXamBQRVTNpt+TV9+BJ51Dqbcj8/GhO2kTgQNcw6X8xHiwAn0iLcc7lbld
	W5qJSMBDztjCC6DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 12F0D136C6;
	Tue, 20 Oct 2026 09:13:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +OANMNQw12rebAAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Tue, 20 Oct 2026 09:13:56 +0000
Message-ID: <1d3aecdb-2537-4f08-a4d2-22c81ebaca03@suse.de>
Date: Tue, 20 Oct 2026 11:13:56 +0200
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
Subject: Re: [PATCH v5 02/13] efi: bgrt: add accessors for the boot graphics
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
 <20261013093243.505776-3-maximpedraza@gmail.com>
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
In-Reply-To: <20261013093243.505776-3-maximpedraza@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: B8EE91F44E
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-3.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,linux.intel.com,kernel.org,ffwll.ch,lwn.net];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[25];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[dt];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.com:url,intel.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Flag: NO
X-Spam-Score: -3.00



Am 13.10.26 um 11:32 schrieb Màxim Pedraza Padilla:
> The DRM splash client shows the boot graphics the firmware left behind,
> and needs the image address and size, its offsets and the status bits.
> Reading them from bgrt_tab and bgrt_image_size works with drm_client_lib
> built in, but it can be a module, and neither is exported:
>
>    ERROR: modpost: drivers/gpu/drm/clients/drm_client_lib.ko: symbol 'bgrt_tab' undefined!
>    ERROR: modpost: drivers/gpu/drm/clients/drm_client_lib.ko: symbol 'bgrt_image_size' undefined!
>
> Rather than export the data, add an accessor for each of them, exported
> GPL only, with stubs in efi-bgrt.h for CONFIG_ACPI_BGRT=n so that users
> need no #ifdef of their own. The variables stay global for
> drivers/acpi/bgrt.c, and are only written by efi_bgrt_init(): mark them
> __ro_after_init.
>
> Reported-by: Mario Limonciello <mario.limonciello@amd.com>
> Closes: https://lore.kernel.org/dri-devel/5d7067de-97b7-4232-9cf6-e4b978696482@amd.com/
> Suggested-by: Jani Nikula <jani.nikula@linux.intel.com>
> Assisted-by: Claude:claude-opus-5-5
> Signed-off-by: Màxim Pedraza Padilla <maximpedraza@gmail.com>

Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>

> ---
>   drivers/firmware/efi/efi-bgrt.c | 74 ++++++++++++++++++++++++++++++++-
>   include/linux/efi-bgrt.h        | 39 ++++++++++++++++-
>   2 files changed, 110 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/firmware/efi/efi-bgrt.c b/drivers/firmware/efi/efi-bgrt.c
> index 1da451582812..01425c4d2e70 100644
> --- a/drivers/firmware/efi/efi-bgrt.c
> +++ b/drivers/firmware/efi/efi-bgrt.c
> @@ -16,8 +16,8 @@
>   #include <linux/efi.h>
>   #include <linux/efi-bgrt.h>
>   
> -struct acpi_table_bgrt bgrt_tab;
> -size_t bgrt_image_size;
> +struct acpi_table_bgrt bgrt_tab __ro_after_init;
> +size_t bgrt_image_size __ro_after_init;
>   
>   struct bmp_header {
>   	u16 id;
> @@ -89,3 +89,73 @@ void __init efi_bgrt_init(struct acpi_table_header *table)
>   out:
>   	memset(bgrt, 0, sizeof(bgrt_tab));
>   }
> +
> +/**
> + * efi_bgrt_has_image() - Whether the firmware left a boot graphic
> + *
> + * Return: true if the BGRT points at a BMP image, which efi_bgrt_init()
> + * checked and reserved.
> + */
> +bool efi_bgrt_has_image(void)
> +{
> +	return bgrt_tab.image_address != 0;
> +}
> +EXPORT_SYMBOL_GPL(efi_bgrt_has_image);
> +
> +/**
> + * efi_bgrt_image_address() - Physical address of the boot graphic
> + *
> + * Return: the address of the BMP image, or 0 if there is none.
> + */
> +phys_addr_t efi_bgrt_image_address(void)
> +{
> +	return bgrt_tab.image_address;
> +}
> +EXPORT_SYMBOL_GPL(efi_bgrt_image_address);
> +
> +/**
> + * efi_bgrt_image_size() - Size of the boot graphic
> + *
> + * Return: the size of the BMP image, as its header gives it, or 0 if there
> + * is none.
> + */
> +size_t efi_bgrt_image_size(void)
> +{
> +	return bgrt_image_size;
> +}
> +EXPORT_SYMBOL_GPL(efi_bgrt_image_size);
> +
> +/**
> + * efi_bgrt_status() - Status field of the BGRT
> + *
> + * Return: the status byte. Bit 0 tells whether the image is still on
> + * screen and, since ACPI 6.2, bits 1-2 how far it has to be turned to show
> + * upright (ACPI_BGRT_ORIENTATION_OFFSET).
> + */
> +u8 efi_bgrt_status(void)
> +{
> +	return bgrt_tab.status;
> +}
> +EXPORT_SYMBOL_GPL(efi_bgrt_status);
> +
> +/**
> + * efi_bgrt_image_offset_x() - Horizontal position of the boot graphic
> + *
> + * Return: the X offset, in pixels, at which the firmware drew the image.
> + */
> +u32 efi_bgrt_image_offset_x(void)
> +{
> +	return bgrt_tab.image_offset_x;
> +}
> +EXPORT_SYMBOL_GPL(efi_bgrt_image_offset_x);
> +
> +/**
> + * efi_bgrt_image_offset_y() - Vertical position of the boot graphic
> + *
> + * Return: the Y offset, in pixels, at which the firmware drew the image.
> + */
> +u32 efi_bgrt_image_offset_y(void)
> +{
> +	return bgrt_tab.image_offset_y;
> +}
> +EXPORT_SYMBOL_GPL(efi_bgrt_image_offset_y);
> diff --git a/include/linux/efi-bgrt.h b/include/linux/efi-bgrt.h
> index e6cd51005633..1c287e5fd388 100644
> --- a/include/linux/efi-bgrt.h
> +++ b/include/linux/efi-bgrt.h
> @@ -9,7 +9,14 @@
>   void efi_bgrt_init(struct acpi_table_header *table);
>   int __init acpi_parse_bgrt(struct acpi_table_header *table);
>   
> -/* The BGRT data itself; only valid if bgrt_image != NULL. */
> +bool efi_bgrt_has_image(void);
> +phys_addr_t efi_bgrt_image_address(void);
> +size_t efi_bgrt_image_size(void);
> +u8 efi_bgrt_status(void);
> +u32 efi_bgrt_image_offset_x(void);
> +u32 efi_bgrt_image_offset_y(void);
> +
> +/* The BGRT data itself; only valid if efi_bgrt_has_image(). */
>   extern size_t bgrt_image_size;
>   extern struct acpi_table_bgrt bgrt_tab;
>   
> @@ -21,6 +28,36 @@ static inline int __init acpi_parse_bgrt(struct acpi_table_header *table)
>   	return 0;
>   }
>   
> +static inline bool efi_bgrt_has_image(void)
> +{
> +	return false;
> +}
> +
> +static inline phys_addr_t efi_bgrt_image_address(void)
> +{
> +	return 0;
> +}
> +
> +static inline size_t efi_bgrt_image_size(void)
> +{
> +	return 0;
> +}
> +
> +static inline u8 efi_bgrt_status(void)
> +{
> +	return 0;
> +}
> +
> +static inline u32 efi_bgrt_image_offset_x(void)
> +{
> +	return 0;
> +}
> +
> +static inline u32 efi_bgrt_image_offset_y(void)
> +{
> +	return 0;
> +}
> +
>   #endif /* !CONFIG_ACPI_BGRT */
>   
>   #endif /* _LINUX_EFI_BGRT_H */

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Stefan Gaiser, Jochen Jaser, Abhinav Puri, (HRB 36809, AG Nürnberg)


