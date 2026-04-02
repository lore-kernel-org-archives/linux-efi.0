Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B53C3E63B5
	for <linux-efi@vger.kernel.org>; Thu,  2 Apr 2026 14:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775139045; cv=none; b=GaAowBN6ZE+qgQc3IrLzpj4Hmge4NjDFh80iXEi4g42/o7WCELrivqADwLWSxSgRDechMTEIG2U0L6QUhP+mjU09hMYjRQPjGgrp07e4eDVypYW3ZuMbVcNYoyVfmniyQtfLDjvBL3cI6YOoQH/LO6rFd5u123kPSYFRHnuKFFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775139045; c=relaxed/simple;
	bh=sh7adPjoKuBw0rYrtOtbsT1hgquzG5sX30f2Pt2JEoo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lylx9sI5OAx8T+0uffQh4SSVbzd2NMiuZEEfs0dObdG1rbMNP3GVTNXf8a8XDxZMtlMCtXjVwi35bLSszz9rThTdPHZRGucH+ULBF+r+iAt4T4nUsPWIAIqlJl0DoSfJ6XpHowXDOqhbHqPwmFqfxT7o1QDNadYcvEUw+KwztnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ghmTCk2l; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AdSg+hiN; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ghmTCk2l; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AdSg+hiN; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ghmTCk2l";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AdSg+hiN";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ghmTCk2l";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AdSg+hiN"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C9A994D34D;
	Thu,  2 Apr 2026 14:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775139041; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ATIJ2JvCqHvnjxC2zyn8h0bvReSf5DUv55srIKdqy/4=;
	b=ghmTCk2lxbNH98lYvz6tJH1dU3F3OuYSLO4M53l2lcvJjYjE9T+DydC+s7tDr0jsLsFz8a
	6JBS04HYJcWpK7ShUP3ZXyXt0SvnEQOzCyINVRi7RMOQH/p2mmD0V89ks5MZ91hVHIy6sr
	dKnnxR/gk5tFxNMkKRY+2YfECcgSd4w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775139041;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ATIJ2JvCqHvnjxC2zyn8h0bvReSf5DUv55srIKdqy/4=;
	b=AdSg+hiNNCy/NCHR9ueIRcJIk0qYOYToQKtIbfNFJX05e3E4ijc4tznQTYASBbTyTjZCp2
	mV3qUgSp+3LOOqBw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ghmTCk2l;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=AdSg+hiN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775139041; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ATIJ2JvCqHvnjxC2zyn8h0bvReSf5DUv55srIKdqy/4=;
	b=ghmTCk2lxbNH98lYvz6tJH1dU3F3OuYSLO4M53l2lcvJjYjE9T+DydC+s7tDr0jsLsFz8a
	6JBS04HYJcWpK7ShUP3ZXyXt0SvnEQOzCyINVRi7RMOQH/p2mmD0V89ks5MZ91hVHIy6sr
	dKnnxR/gk5tFxNMkKRY+2YfECcgSd4w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775139041;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ATIJ2JvCqHvnjxC2zyn8h0bvReSf5DUv55srIKdqy/4=;
	b=AdSg+hiNNCy/NCHR9ueIRcJIk0qYOYToQKtIbfNFJX05e3E4ijc4tznQTYASBbTyTjZCp2
	mV3qUgSp+3LOOqBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 31D374A0B0;
	Thu,  2 Apr 2026 14:10:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7zb4CuF4zmlFBgAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Thu, 02 Apr 2026 14:10:41 +0000
Message-ID: <3e466158-c2e5-4e23-934f-dcdbb71ad41f@suse.de>
Date: Thu, 2 Apr 2026 16:10:40 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/8] firmware: sysfb: Make CONFIG_SYSFB a user-selectable
 option
To: Arnd Bergmann <arnd@arndb.de>,
 Javier Martinez Canillas <javierm@redhat.com>,
 Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Dave Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, longli@microsoft.com,
 Helge Deller <deller@gmx.de>
Cc: linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 linux-efi@vger.kernel.org, linux-riscv@lists.infradead.org,
 dri-devel@lists.freedesktop.org, linux-hyperv@vger.kernel.org,
 linux-fbdev@vger.kernel.org
References: <20260402092305.208728-1-tzimmermann@suse.de>
 <20260402092305.208728-4-tzimmermann@suse.de>
 <78f76717-8f1e-41d6-92f7-261df96b84b6@app.fastmail.com>
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
In-Reply-To: <78f76717-8f1e-41d6-92f7-261df96b84b6@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[arndb.de,redhat.com,kernel.org,linaro.org,xen0n.name,linux.intel.com,gmail.com,ffwll.ch,microsoft.com,gmx.de];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[23];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,gmx.de];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Queue-Id: C9A994D34D
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

Hi

Am 02.04.26 um 15:08 schrieb Arnd Bergmann:
> On Thu, Apr 2, 2026, at 11:09, Thomas Zimmermann wrote:
>> Add a descriptive string and help text to CONFIG_SYSFB, so that users
>> can modify it. Flip all implicit selects in the Kconfig options into
>> dependencies. This avoids cyclic dependencies in the config.
>>
>> Enabling CONFIG_SYSFB makes the kernel provide a device for the firmware
>> framebuffer. As this can (slightly) affect system behavior, having a
>> user-facing option seems preferable. Some users might also want to set
>> every detail of their kernel config.
>>
>> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> I don't really like this part of the series and would prefer
> to keep CONFIG_SYSFB hidden as much as possible as an x86
> (and EFI) specific implementation detail, with the hope
> of eventually seperating out the x86 bits from the EFI ones.

You mean, you want to use the EFI-provided framebuffers without the 
intermediate step of going through sysfb_primary_display?

In that case, CONFIG_SYSFB would become an x86-internal thing, right?

>
> In general, I am always in favor of properly using Kconfig
> dependencies over 'select' statements, for the same reasons
> you describe, but I don't want the the x86 logic for
> the legacy VESA and VGA console handling to leak into more
> architectures than necessary.
>
> Do you think we could instead move the sysfb_init()
> function into the same two places that contain the
> sysfb_primary_display definition (arch/x86/kernel/setup.c,
> drivers/firmware/efi/efi-init.c) and simplify the efi version
> to take out the x86 bits? That would reduce the rest
> of sysfb-primary.c to the logic to unregister the device,
> and that could then be selected by both x86 and EFI.

No, I'm more than happy that sysfb finally consolidates all the 
init-framebuffer setup and detection that floated around in the kernel. 
I would not want it to be duplicated again.

For now, we could certainly keep CONFIG_SYSFB hidden and autoselected. 
Although I think this will require soem sort of solution at a later point.

Best regards
Thomas

>
>        Arnd

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Jochen Jaser, Andrew McDonald, Werner Knoblich, (HRB 36809, AG Nürnberg)


