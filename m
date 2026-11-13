Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794556065;
	b=f10aMfAZsAasvB12694tndSKi+SR6a3xydAgA25cb5sJqlE2J000pBPVbQbGyaAoXqUR
	 Ejk+mPMxdTXRnvTsODZZOPwIw6Ouzgvyz9SjR+bF8QK1FcUbNjcFCZndMeewHop4QaDp/
	 LAhUXzILf/TmLa21/tzrd+GSv3RRKdAjeE6XGf9GzgYRWtgh8TlX84j4HEU/+i6D7+yht
	 wpZAllU1mQj216nfNY2bLMBB+x9k6Q1ve6B+zNn+rV1uEIrtSymr66ohU0g0UmuolWDGn
	 Gzar6VDfMstyklPFCxRdols3TIlquwtWTfVwt1sISAsbuQC+jAInXNxchV8wPBxuWDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794556065;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Spam-Flag:
	 X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=MwHir3QZIwd0vNmCrmrnyvlzq75jfEeSONQTA2qpmu4=;
	b=M060158Tj4utyznJ6pevtbiK8giaOqu0gVvBzdMXWEnckd6lRxK6EHYCZM3gTpq00X6a
	 uqIKLA8gwjm4CLgtcliVAgfjfTvD6Mt6o6Q4hph/kXkIR7p+cAHIV+JUIjO/eJ+wYrN6+
	 8QoCnOX15UqPy0FGz/GWR9HcMb9VKy1ipw+mkNpZ3CfR1QaFrdMjOOPFCK/cx2NJLgeoF
	 cCj5a5YGd/LJufh9yWt+8r1UqNWzOzOzz7UD3Zg4KIuZKYHtx2Vvtr/SEDGYI5JrGGZSt
	 XXvVPLhJZ5wPU4uj8O/SmDa5XSCxzYSv9R+dEmi7c9W1mKgf5OwaDB4JR+xvtO4inzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=VVLCARYy;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=AuKjDqxq;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=RIhze3kx;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ThgE3kc8;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0BB606A321;
	Fri, 13 Nov 2026 07:47:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1A0BB606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=VVLCARYy;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=AuKjDqxq;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=RIhze3kx;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ThgE3kc8
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C55142209D;
	Fri, 13 Nov 2026 07:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794556055; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MwHir3QZIwd0vNmCrmrnyvlzq75jfEeSONQTA2qpmu4=;
	b=VVLCARYyo0bCvIfrwYne7U1sTXl5bYA269Hw8idWkxZ5Nhd0n2fiZQ9pboHC1yK8Fqb4C4
	yGBteyDaNNJeI2VOF+nIsCxCkr6qOBTgK/xiRCebqVWWtwF2hyA8lhXU5UhE1gCOVxu8XY
	NsVUuCIe25yt22tpUwRwYxsREOeYmJs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794556055;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MwHir3QZIwd0vNmCrmrnyvlzq75jfEeSONQTA2qpmu4=;
	b=AuKjDqxqLWlUqYZZQsTiQvCrZzelI18U2BIstuTn2g9VCwkZ9sPDnP5/WVZOVMAOF4C8Io
	XxEuhRAZLZvddkAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794556053; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MwHir3QZIwd0vNmCrmrnyvlzq75jfEeSONQTA2qpmu4=;
	b=RIhze3kxPI60X8X7VYkDCKyK78xXuJqZQ/266urt/Ck9kJXQAZDit61DPwvbeqLr02sWyP
	NeOyUmAB+OtO+ZY2SndJTN/hSuMKknj2bW2+DiWRrKgw+a41KaV8JEvhho+MsH85uTCoYR
	lTlremIWvSp9XYpGsctQo2aLBBU6B/4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794556053;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MwHir3QZIwd0vNmCrmrnyvlzq75jfEeSONQTA2qpmu4=;
	b=ThgE3kc8SuI4Yo1gFiiNBYAPIZ2dxebG2HgFF6H6hJfy7lGAvrKBTFPAWAJgVKYHASJbkR
	GrURjvN2Yf1Fw5AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BDD381344A;
	Fri, 13 Nov 2026 07:47:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mo9QHJTA9mruVgAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Fri, 13 Nov 2026 07:47:32 +0000
Message-ID: <4762a951-5b37-4e7a-8569-f55a4683c912@suse.de>
Date: Fri, 13 Nov 2026 08:47:32 +0100
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
Subject: Re: [PATCH v6 00/15] Add splash DRM client
To: =?UTF-8?Q?M=C3=A0xim_Pedraza_Padilla?= <maximpedraza@gmail.com>
Cc: Javier Martinez Canillas <javierm@redhat.com>,
 Francesco Valla <francesco@valla.it>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Helge Deller <deller@gmx.de>,
 Peter Jones <pjones@redhat.com>, Jani Nikula <jani.nikula@linux.intel.com>,
 Mario Limonciello <mario.limonciello@amd.com>,
 Jocelyn Falempe <jfalempe@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, dri-devel@lists.freedesktop.org,
 devicetree@vger.kernel.org, linux-efi@vger.kernel.org,
 linux-fbdev@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261027135342.2003632-1-maximpedraza@gmail.com>
 <066197a1-aa2b-455b-84d8-4e2215fad764@suse.de>
 <20261112152209.3297409-1-maximpedraza@gmail.com>
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
In-Reply-To: <20261112152209.3297409-1-maximpedraza@gmail.com>
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
	RCVD_TLS_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[suse.com:url,imap1.dmz-prg2.suse.org:helo];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,gmx.de];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[28];
	TAGGED_RCPT(0.00)[dt];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[redhat.com,valla.it,linux.intel.com,kernel.org,gmail.com,ffwll.ch,lwn.net,gmx.de,amd.com,ravnborg.org,linaro.org,linuxfoundation.org,infradead.org,lists.freedesktop.org,vger.kernel.org];
	FREEMAIL_TO(0.00)[gmail.com];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:url]
X-Spam-Score: -11.79

Hi

Am 12.11.26 um 16:22 schrieb Màxim Pedraza Padilla:
> Hi Thomas, Javier, Francesco,
>
> Thanks a lot for the reviews. I'm answering everything here in one go.
>
> On 11/11/26 14:52, Thomas Zimmermann wrote:
>> So shall we merge patches 1 to 6 and 8 first? You'd have something in
>> upstream already and not chase a moving target. From there, we can merge
>> the other features in the coming weeks.
> Yes, that sounds great. v7 is ready and holds just those: patches 1 to 4,
> 6 and 8 of v6, with the MAINTAINERS entry squashed into the patch that
> adds drm_splash.c, so six patches in all. The DT binding, the placement
> and rotation, and the connector orientation will follow as a separate
> series once this one is in.
>
> What changes in v7 from your comments:
>
> - the Assisted-by tags are gone from every patch (Javier)
> - MAINTAINERS: I'm listed as M: and Francesco as R: (thanks, Francesco),
>    in the same patch as drm_splash.c
> - the firmware source is now DRM_SPLASH_SRC_FW, and the Kconfig options
>    DRM_CLIENT_SPLASH_SRC_FW and DRM_CLIENT_SPLASH_FW_NAME; the BMP decoder
>    keeps its name, since the BGRT goes through it too
> - the drm_splash_fw_load() stub returns 0
>
> On the CONFIG_X86 around the BGRT check in patch 4: it comes from efifb,
> where efifb_bgrt_sanity_check() is x86 only too, and its comment says
> that all x86 firmwares centre the image horizontally. I haven't found
> that promised for other architectures, and there the check could reject
> a logo that is fine, so I'd rather keep it as efifb does. If you prefer
> it on every architecture, or gone, I'll change it.
>
> The issue Sashiko found on v6 (a restore deferred while the device was
> suspended) is fixed in v7, together with a few more that a later Sashiko
> run found; the changelog of patch 4 lists them.
>
> About your Reviewed-by on patch 4: since v6 the work has changed quite a
> bit. Restore now leaves the commit to the work, a hotplug while userspace
> holds the display waits for the next restore as fbdev does, and
> unregister waits for the work before it looks for a pending firmware
> request. Shall I keep your tag, or drop it so you can look at the new
> version first? Whichever you prefer.

Keep the R-b. I intend to merge the next iteration. Any issues can then 
still be sorted out. The splash screen has been waiting out of tree for 
far too long.

Best regards
Thomas

>
> I'll send v7 shortly.
>
> Best regards,
> Màxim

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Stefan Gaiser, Jochen Jaser, Abhinav Puri, (HRB 36809, AG Nürnberg)


