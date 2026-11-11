Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794403923;
	b=eHWfaCrKNSErOQDjFELFzRSo58cnowTQQKefpbPxKzRn5r915F4rsHcFlhxd7GtL27Sx
	 cbWOBUiknx17rGgbMcbfjjf8gVRS5EgtL6Vo0RF3dHQ6AHVaFwnr581n9OVg3OdiA5gDJ
	 gxE+UEji09A0S1Gtj9MHBOx1iUGexHmVXhbw0vshibbWehQhsC2Hg/B6+3nXgb8IDe52d
	 f56TOVqwi6RudJLp6ayOB7sTjP4j2m5kSN2f1AKxxerMOgblKeNUpsWBuA2wtq3CSOyfQ
	 jg9Q9+0EJik1LiC2p4nX3BekEJUO1zlZEsCIgY6yrXE/av5UEWDqxFCDr2WJPpqY8Mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794403923;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=8P9Gu9qBqcpDxpNjEf0DY5+KTMy2tpOB+o7FIRyeAgI=;
	b=zfi3nS1hFr6yMabm/QELykAy/nAqPo/GcIQrV/ccPnUDQFy8WICEnpZejkocftRY+mDP
	 xTy/1YTxH6m7lVTW+wq45XcLD0ka0svi6cqeugx952NsRg8129SVf3qSIwkEfz8ewXCah
	 ECaljVM0uLYx0pRtAkcztZOZBQ3zkEpUvrN4kRR+7k1p5teBvC4Unp0hThSGkaGEShZRt
	 1olhBISLA+5vTVlppYj0QAUhNfudTVh1PfNBPaTTORX5OUHe8pt/snDNHgNllL8gWsyDG
	 3LKIwZgjj8bsVDMNu890S9hL9nPHezkCMQSzQhzedyjdl9dnOPp2JJWG3wMVENJygZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=rtTrYSlE;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=lmy+uA73;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=rtTrYSlE;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=lmy+uA73;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9AB2606A33B;
	Wed, 11 Nov 2026 13:32:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A9AB2606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=rtTrYSlE;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=lmy+uA73;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=rtTrYSlE;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=lmy+uA73
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 87F915C4AC;
	Wed, 11 Nov 2026 13:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794403913; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8P9Gu9qBqcpDxpNjEf0DY5+KTMy2tpOB+o7FIRyeAgI=;
	b=rtTrYSlElDgrPSs1uSVZcz0+060Gg1y/UDP2E/Nd2GeWP4ZvVADQE6k25qP37Q9UdCcKi2
	h7UM9vNt4O0zjF6OldSUlwVZsTNcsiF/IjNR1xOl3LpT993busznKqIcf0NnVJrYwnM+7A
	wnzJWSuIhciRC51xPy6CGHf3gd+JmXI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794403913;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8P9Gu9qBqcpDxpNjEf0DY5+KTMy2tpOB+o7FIRyeAgI=;
	b=lmy+uA73Aw+ljWQbrLvH3Kv0nCrZHFq7Trnth+h8DtbugolcZNEzmpgG2w5BjsGwZP4mIL
	nocHAK7n7FnQt+Bg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794403913; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8P9Gu9qBqcpDxpNjEf0DY5+KTMy2tpOB+o7FIRyeAgI=;
	b=rtTrYSlElDgrPSs1uSVZcz0+060Gg1y/UDP2E/Nd2GeWP4ZvVADQE6k25qP37Q9UdCcKi2
	h7UM9vNt4O0zjF6OldSUlwVZsTNcsiF/IjNR1xOl3LpT993busznKqIcf0NnVJrYwnM+7A
	wnzJWSuIhciRC51xPy6CGHf3gd+JmXI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794403913;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8P9Gu9qBqcpDxpNjEf0DY5+KTMy2tpOB+o7FIRyeAgI=;
	b=lmy+uA73Aw+ljWQbrLvH3Kv0nCrZHFq7Trnth+h8DtbugolcZNEzmpgG2w5BjsGwZP4mIL
	nocHAK7n7FnQt+Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AA91F1339F;
	Wed, 11 Nov 2026 13:31:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0iPRGEhu9GodVAAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Wed, 11 Nov 2026 13:31:52 +0000
Message-ID: <ed28619d-6ca7-46aa-82c0-c83f30a836e3@suse.de>
Date: Wed, 11 Nov 2026 14:31:51 +0100
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
Subject: Re: [PATCH v6 05/15] MAINTAINERS: add entry for DRM splash client
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
 <20261027135342.2003632-6-maximpedraza@gmail.com>
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
In-Reply-To: <20261027135342.2003632-6-maximpedraza@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-11.79 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	TAGGED_RCPT(0.00)[dt];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,gmx.de];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,linux.intel.com,kernel.org,ffwll.ch,lwn.net,gmx.de,redhat.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_TWELVE(0.00)[28];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[]
X-Spam-Score: -11.79
X-Spam-Level: 
X-Spam-Flag: NO

Hi

Am 27.10.26 um 14:53 schrieb Màxim Pedraza Padilla:
> From: Francesco Valla <francesco@valla.it>
>
> Add myself as maintainer for the DRM splash client.
>
> Signed-off-by: Francesco Valla <francesco@valla.it>
> [Màxim: add myself as co-maintainer]
> Signed-off-by: Màxim Pedraza Padilla <maximpedraza@gmail.com>
> ---
>   MAINTAINERS | 8 ++++++++
>   1 file changed, 8 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a08087fb6e67..321ecb9f5b5b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9168,6 +9168,14 @@ F:	Documentation/gpu/drm-ras.rst
>   F:	drivers/gpu/drm/drm_ras*
>   F:	include/drm/drm_ras*
>   
> +DRM SPLASH
> +M:	Francesco Valla <francesco@valla.it>
> +M:	Màxim Pedraza Padilla <maximpedraza@gmail.com>

I don't think Francesco should be listed here. Although he wrote the 
initial implementation, it's yours now.  Maybe list him as R: if you 
want to.


> +L:	dri-devel@lists.freedesktop.org
> +S:	Maintained
> +T:	git https://gitlab.freedesktop.org/drm/misc/kernel.git
> +F:	drivers/gpu/drm/clients/drm_splash.c

This patch should be merged with the one that added drm_splash.c.

Best regards
Thomas




> +
>   DRM TTM SUBSYSTEM
>   M:	Natalie Vock <nat@pixelcluster.dev>
>   M:	Arun Pravin <arunpravin.paneerselvam@amd.com>

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Stefan Gaiser, Jochen Jaser, Abhinav Puri, (HRB 36809, AG Nürnberg)


