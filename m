Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D80A304976
	for <linux-efi@vger.kernel.org>; Mon, 31 Aug 2026 10:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788172495; cv=none; b=E4JDbusbRnmCafEfFXCxM4Rgu4bxFUWbDPqOZDEPTu22VH0tZsr+muYxZEpvmPZpOIRnUVmeCum2Gpse2loq1JTOX977YWu6YXCHc7B3jKZThXE6hSG5a72n5gLl8cumS42xYbh8Hy1NWsyiJAjK+k6UbyIcIR0PG1Xs7JDgmro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788172495; c=relaxed/simple;
	bh=CLLsnLIum5WCxVAklsCNgE1+4Hz+aP/bsEccy1Rn9bY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WJQKXqf3kIDkNnUZfHatF6WBYjHCz80OeIw6zT1MC0lErOwcuWo3DDMMod/xZ19OhW1Ql7Qbyw0LDdsZclqs8b7i/FaqckWAag0YtZxnD9EyIiCmzBSr9nZL1PmfJmxN6Ul1S2n0lrCogFSh380UtL7a+EGU+CjtOcc3o4Ivsxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tnaxwRdv; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=SyiJ4uzs; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MI8emGWn; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yuQjlVim; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tnaxwRdv";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="SyiJ4uzs";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MI8emGWn";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yuQjlVim"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5FDA622605;
	Mon, 31 Aug 2026 10:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788172487; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Phv0ZebiZfK+29VSYNMS4Vd8RhCPIJFdfiNAqlZZrGY=;
	b=tnaxwRdv/5j3nK7Gd2aAUwPqiyVOs5ArI039YSDgAoC54UpFtPVIGS3VUdpNyTdALI/0OP
	F6Tm4OttKrN8zZ4zL3/VgaX+Oud62AaF8VWi8TdH3opkQbaFEMIrUO2aPTDHQ9qD6/QT9d
	INA9O1bEQhOGL6B44Z4ZgeKkI2nqYak=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788172487;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Phv0ZebiZfK+29VSYNMS4Vd8RhCPIJFdfiNAqlZZrGY=;
	b=SyiJ4uzspc7Jym8wwbzgAtLZBPbBrgpnVLJLqWDgJNavPFYP9xkbPL/J8uFtEP+qFud6+t
	PmhSprbE6WRFwYAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788172481; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Phv0ZebiZfK+29VSYNMS4Vd8RhCPIJFdfiNAqlZZrGY=;
	b=MI8emGWnpKBjTS5/k+LxWZFbPlhw6p8+oAiqQF3p53TtwecICqnL5n1U7JqD2gfWWSrOH6
	tWRxITmbwWHS5W5t+MyTgg2kOx5DuLxlh7cvhUptgWk/QDggXS9+XKzbbZXivsvzzHwkiM
	v7kBMoFJ3q0t89XJQE9jhmgDWngYXm8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788172481;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Phv0ZebiZfK+29VSYNMS4Vd8RhCPIJFdfiNAqlZZrGY=;
	b=yuQjlVimRqK7Oy6UzL8qJOirq0NwUaZg9AaspkNZ33NolC8QidRDudt037ib9NptiejeGU
	aVX8MueE/T8r0sBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 96BBE13515;
	Mon, 31 Aug 2026 10:34:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2tOOI71YlWpeFAAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Mon, 31 Aug 2026 10:34:37 +0000
Message-ID: <efaaeafb-2fb3-452b-a18f-cbcde3183fd4@suse.de>
Date: Mon, 31 Aug 2026 12:34:37 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] sysfb: Fix display output on Lenovo D330 (and others)
To: Ard Biesheuvel <ardb@kernel.org>,
 Javier Martinez Canillas <javierm@redhat.com>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org,
 Simona Vetter <simona@ffwll.ch>, David Airlie <airlied@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-efi@vger.kernel.org,
 sashiko-reviews@lists.linux.dev
References: <20260827140726.420734-1-tzimmermann@suse.de>
 <6b778c42-577b-4df1-a364-d4123f45080a@app.fastmail.com>
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
In-Reply-To: <6b778c42-577b-4df1-a364-d4123f45080a@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[kernel.org,redhat.com,linaro.org,linux.intel.com,ffwll.ch,gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.com:url,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO

Hi Ard

Am 27.08.26 um 18:56 schrieb Ard Biesheuvel:
> Hello Thomas,
>
> On Thu, 27 Aug 2026, at 16:01, Thomas Zimmermann wrote:
>> The kernel mis-interprets the display geometry given by the Lenovo
>> D330 as incorrect. The values are correct, but the display output
>> is rotated by 90°. With the kernel's firmware quirk applied the output
>> is garbled.
>>
>> Remove the firmware quirk for the Lenovo D330 and let DRM's sysfb
>> drivers set the correct panel orientation instead. To make this work
>> for any display mode, use the panel size for looking up the correct
>> orientation.
>>
>> Tested on a Lenovo D330-10IGM IdeaPad.
>>
>> Thomas Zimmermann (3):
>>    drm/edid: Add drm_edid_get_preferred_size()
>>    drm/sysfb: Use preferred panel size for panel orientation quirks
>>    firmware/sysfb: Remove rotation quirk for Lenovo D330
>>
> Acked-by: Ard Biesheuvel <ardb@kernel.org>

The Sashiko bot warns that the quirk is required on the device's older 
UEFI firmware revisions.  I can confirm that the quirk breaks display 
output for the latest firmware (ver 8NCN43WW).  How is this usually 
being handled? Can I expect affected users to update their firmware?

Best regards
Thomas


-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Jochen Jaser, Andrew McDonald, (HRB 36809, AG Nürnberg)


