Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A686C428470
	for <linux-efi@vger.kernel.org>; Mon, 31 Aug 2026 13:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788182653; cv=none; b=RpXdYRzX/CrtOUN/cQqtRKlvSfMIsBAAx3CinFFUjW2c13lQ5z+qA857DZa0DYUPcBoMuZbqCkekOKVpjQTqihAuyu8TDfuKe4bwUcTBFLzBxtx4+VeloGA37U0mrhZorL1Nydm8FLSRWXV6SaXCulWq5a7RV3UAa90aCfWrULI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788182653; c=relaxed/simple;
	bh=2AIb0VXPIMnJJ9KAzblAJKmUuTP2XIdJYpku62qv3WA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AsMQey6qRI4PE3DEK60Sxq498KkEmi/+fplM2Jk3cl8LyVpo3ptaezolqyc9E8rHmVPgZil7AnZPgpjBVoW1V3d+KDlShwkXEWYn9ZiK4ZDqU7B6k3SJNo2nFH3K/JJ+NlUvlvD0YZLyRaZj+OnU01ZvWWc0h2fRL2G9bY3eca0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nDUKDu6N; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=25K9tZOi; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vh5uzUZd; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=EyYF7WXn; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nDUKDu6N";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="25K9tZOi";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vh5uzUZd";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="EyYF7WXn"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1700B21B1C;
	Mon, 31 Aug 2026 13:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788182644; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qr1OOG3pV3cPnqTGHd6czCB+q6fXVL6kJmDhZjfC1cA=;
	b=nDUKDu6Ne+tRRgKlGxV3rsTZDBM/9YssDD9aej91NZtgfvOSiPupZOHJ9D3isOndYpxcFp
	gOC0uqsYtB5aQaQkls2YCvT0TxadYwWcVByEQIH2H9m1xm/AVr24Yv/2opztxNUhNTDRtl
	INYVFNdbzCSy8WxjrJN95d7rCxJXhHs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788182644;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qr1OOG3pV3cPnqTGHd6czCB+q6fXVL6kJmDhZjfC1cA=;
	b=25K9tZOiMseCp9Mt4BmAB1D+erChwE+jM9s9okFsUBhEsxoZ3HiTWhe+wKN6u2OdoAw+fa
	FFrTzbjssNGf01Dw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vh5uzUZd;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EyYF7WXn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788182640; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qr1OOG3pV3cPnqTGHd6czCB+q6fXVL6kJmDhZjfC1cA=;
	b=vh5uzUZd8hYQo1Y6q1dn0/GzSNn9Fz/9N5xD62s+siWitSEMDBv67Nk1ad7kAlZK4lpTfG
	xfNxPFN/222v8ImOwcYw8+tkERTqdEbUohpCjclTZTjCG0Zz8ZtuGpSQ6e6XtNFgz0R5yT
	OmgMco0h3/45AYCypaZUqCeDoicQfDI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788182640;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qr1OOG3pV3cPnqTGHd6czCB+q6fXVL6kJmDhZjfC1cA=;
	b=EyYF7WXn+WgRLjUaVrRSfJ1sdpdV6le7Eu4NU3yIy/5aCPwgVbxmyf/U89OjK7nkBOKYiV
	AvbL4prE0jgv1YCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A96BF13515;
	Mon, 31 Aug 2026 13:23:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mSQJKG+AlWoSPAAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Mon, 31 Aug 2026 13:23:59 +0000
Message-ID: <88e53706-d237-46e3-afc3-deff5e372725@suse.de>
Date: Mon, 31 Aug 2026 15:23:59 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] firmware/sysfb: Remove rotation quirk for Lenovo
 D330
To: Jani Nikula <jani.nikula@linux.intel.com>, javierm@redhat.com,
 ardb@kernel.org, ilias.apalodimas@linaro.org,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, simona@ffwll.ch,
 airlied@gmail.com
Cc: dri-devel@lists.freedesktop.org, linux-efi@vger.kernel.org,
 sashiko-reviews@lists.linux.dev
References: <20260831093020.494701-1-tzimmermann@suse.de>
 <20260831093020.494701-2-tzimmermann@suse.de>
 <5f8aceb5b36607877509995550d6dbbfad675ba7@intel.com>
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
In-Reply-To: <5f8aceb5b36607877509995550d6dbbfad675ba7@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: 1700B21B1C
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_TO(0.00)[linux.intel.com,redhat.com,kernel.org,linaro.org,ffwll.ch,gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:url,suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO



Am 31.08.26 um 14:49 schrieb Jani Nikula:
> On Mon, 31 Aug 2026, Thomas Zimmermann <tzimmermann@suse.de> wrote:
>> The Lenovo D330 is a notebook with unmountable display. The display
> Please elaborate on what you mean by "unmountable display".
>
> No comments on the patch itself, I just haven't heard that before.

Sorry, that word doesn't exist; maybe "mountable".  I think "detachable" 
is the correct word.  The notebook's display can be removed from the 
keyboard to act like a tablet.

Best regards
Thomas

>
>> is installed in landscape orientation, but the display mode is in
>> portrait orientation. By default, the display output is rotated to
>> the left by 90°.
>>
>> The sysfb quirk breaks the display by swapping display width and
>> height; and thus mixing up the display geometry. Fix this by keeping
>> the display as-is. The sysfb DRM drivers, usually efidrm, will pick
>> the correct panel orientation for the display.
>>
>> Tested on a Lenovo D330-10IGM IdeaPad.
>>
>> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
>> Acked-by: Ard Biesheuvel <ardb@kernel.org>
>> ---
>>   drivers/firmware/efi/sysfb_efi.c | 9 ---------
>>   1 file changed, 9 deletions(-)
>>
>> diff --git a/drivers/firmware/efi/sysfb_efi.c b/drivers/firmware/efi/sysfb_efi.c
>> index 685283bb7327..2338de73c62c 100644
>> --- a/drivers/firmware/efi/sysfb_efi.c
>> +++ b/drivers/firmware/efi/sysfb_efi.c
>> @@ -301,15 +301,6 @@ static const struct dmi_system_id efifb_dmi_swap_width_height[] __initconst = {
>>   		},
>>   		.callback = efifb_swap_width_height,
>>   	},
>> -	{
>> -		/* Lenovo D330 with 800x1280 or 1200x1920 portrait screen */
>> -		.matches = {
>> -			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "LENOVO"),
>> -			DMI_EXACT_MATCH(DMI_PRODUCT_VERSION,
>> -					"Lenovo ideapad D330-10IGM"),
>> -		},
>> -		.callback = efifb_swap_width_height,
>> -	},
>>   	{
>>   		/*
>>   		 * Lenovo IdeaPad Duet 3 10IGL5 and 10IGL5-LTE with

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Jochen Jaser, Andrew McDonald, (HRB 36809, AG Nürnberg)


