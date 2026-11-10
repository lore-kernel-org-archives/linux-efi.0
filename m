Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794321263;
	b=VcTKC/M2UMPSrKA+Z0eL5c/eQr8utlMsfvDz0HB6EOFOZJN5OiwG8RBQuNMeoMQeqMV2
	 OHdvuy3KOSo3+j2j/6ilE+osz8v5qOQVfpC4ons2ltK43uVg/ZFfRgkK2drU4nb8P6ZXe
	 lGtzoTH08a6kqDjmpBdgTKd4skFgctJc2oR1Ouiu98xfrLkAIr1264J7/Ii7/QZFiyuPH
	 V8gGmF/KLFtxKBNrio/SDSDD8p4nHLAEOgVomO+cgpRRClSRPb/yQPAjk/xnafU4hWn0Q
	 1iu3CxMnAh455fgDLr3QUpGYMEDsm3MGU/+beVU5IBy8LUDaZrhTBD0onhXtxbBnykg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794321263;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=zhlfAbU+RkEaMeHpJ5g5gZDOhJEWeCavfCtrrHQ9BPY=;
	b=YeT14AwL+mD2xxV+K/aIet/U2hUT0qiqqUwlWqISdIysJUpFNnI/3NFIz9iBiFFCT6Za
	 gVNSxNNYQWRH4r9ZZK3QCCwLc0PLWhowgw2j7zD4lkwuopMcwrvEClrfvhZFM5V+S+eWB
	 bb/VxI0jg7XANlj67AzfVwrPe2T4lthSiSzy35BM0WLAJY9VJMpGJOKH36VFufsaZPBwa
	 LV/GR2Qg5ApkzBqDCdyCWFEMNi9siQbof3aPIcreqD9EzO1SGjj3FagD/5aoOLBb7NPNs
	 VxVto08e474OsiEK/sauWKLjLFeQKbvAvSzv11j32JYS/gyssLdwisRlPdX3o/Sm+zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=ZTh445E5;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=VahZZXHk;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=ZTh445E5;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=VahZZXHk;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5A0606A33C;
	Tue, 10 Nov 2026 14:34:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9B5A0606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=ZTh445E5;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=VahZZXHk;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=ZTh445E5;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=VahZZXHk
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8F8C11F7E9;
	Tue, 10 Nov 2026 14:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794321260; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zhlfAbU+RkEaMeHpJ5g5gZDOhJEWeCavfCtrrHQ9BPY=;
	b=ZTh445E5L8KNoOq+Qvu1Aisct4dn10+ORt/gcCxSxPobkymCZc6RldE0RkDkyNhqD6g2iW
	Ukv+o4aAzW9aoHEIzDZVa+TjS+/urb7FM2OJSj/1KKmofcUqvXgjQBc0uzqHgzRYOm7y8r
	dbDkG/ZXHvuiSkbuivgyuVbEbogSsXI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794321260;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zhlfAbU+RkEaMeHpJ5g5gZDOhJEWeCavfCtrrHQ9BPY=;
	b=VahZZXHk35FogwG7kQFefrHnrVzAqos3dckwYxXUAUfKLYoJRnIf+FpkquPbWofZScNfIN
	wVDt6/SlAWj+d+DQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZTh445E5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=VahZZXHk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794321260; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zhlfAbU+RkEaMeHpJ5g5gZDOhJEWeCavfCtrrHQ9BPY=;
	b=ZTh445E5L8KNoOq+Qvu1Aisct4dn10+ORt/gcCxSxPobkymCZc6RldE0RkDkyNhqD6g2iW
	Ukv+o4aAzW9aoHEIzDZVa+TjS+/urb7FM2OJSj/1KKmofcUqvXgjQBc0uzqHgzRYOm7y8r
	dbDkG/ZXHvuiSkbuivgyuVbEbogSsXI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794321260;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zhlfAbU+RkEaMeHpJ5g5gZDOhJEWeCavfCtrrHQ9BPY=;
	b=VahZZXHk35FogwG7kQFefrHnrVzAqos3dckwYxXUAUfKLYoJRnIf+FpkquPbWofZScNfIN
	wVDt6/SlAWj+d+DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 62FF91339F;
	Tue, 10 Nov 2026 14:34:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PicADmsr82qQKgAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Tue, 10 Nov 2026 14:34:19 +0000
Message-ID: <9667af1e-4ad1-4d98-bd8d-38a548899a0a@suse.de>
Date: Tue, 10 Nov 2026 15:34:18 +0100
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
Subject: Re: [PATCH v3 1/6] LoongArch: efi: Provide sysfb_primary_display for
 screen_info users
To: wuqianhai@loongson.cn, chenhuacai@kernel.org, kernel@xen0n.name,
 deller@gmx.de, bhelgaas@google.com
Cc: ardb@kernel.org, ilias.apalodimas@linaro.org, javierm@redhat.com,
 loongarch@lists.linux.dev, linux-pci@vger.kernel.org,
 linux-efi@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261029033440.973077-1-wuqianhai@loongson.cn>
 <20261110085617.2626835-1-wuqianhai@loongson.cn>
 <20261110085617.2626835-2-wuqianhai@loongson.cn>
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
In-Reply-To: <20261110085617.2626835-2-wuqianhai@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-13.50 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[loongson.cn,kernel.org,xen0n.name,gmx.de,google.com];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmx.de];
	DKIM_TRACE(0.00)[suse.de:+];
	RCPT_COUNT_TWELVE(0.00)[14];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:url,suse.de:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -13.50
X-Spam-Level: 
X-Rspamd-Queue-Id: 8F8C11F7E9

Hi

Am 10.11.26 um 09:56 schrieb wuqianhai@loongson.cn:
> From: wuqianhai <wuqianhai@loongson.cn>
>
> LoongArch defines and initializes sysfb_primary_display only when
> CONFIG_SYSFB or CONFIG_EFI_EARLYCON is enabled.  The PCI VGA arbiter and
> the framebuffer console need the firmware framebuffer information through
> screen_info whenever CONFIG_SCREEN_INFO is enabled, even if neither of
> those options is set.
>
> Drop the guards so sysfb_primary_display is always defined and
> initialized, and its EFI stub alias is always provided, mirroring x86.
> This avoids selecting SYSFB just to obtain the symbol.
>
> Signed-off-by: wuqianhai <wuqianhai@loongson.cn>
> ---
>   arch/loongarch/kernel/efi.c        | 5 +----
>   arch/loongarch/kernel/image-vars.h | 2 --
>   2 files changed, 1 insertion(+), 6 deletions(-)
>
> diff --git a/arch/loongarch/kernel/efi.c b/arch/loongarch/kernel/efi.c
> index 69dd83f8082f..e491a82b2e0d 100644
> --- a/arch/loongarch/kernel/efi.c
> +++ b/arch/loongarch/kernel/efi.c
> @@ -74,10 +74,8 @@ bool efi_poweroff_required(void)
>   
>   unsigned long __initdata primary_display_table = EFI_INVALID_TABLE_ADDR;
>   
> -#if defined(CONFIG_SYSFB) || defined(CONFIG_EFI_EARLYCON)
>   struct sysfb_display_info sysfb_primary_display __section(".data");
>   EXPORT_SYMBOL_GPL(sysfb_primary_display);
> -#endif

I never understood how linking works. I would assume that this symbol 
interferes with the shared one at [1]. Can't loongarch use that as well?

[1] 
https://elixir.bootlin.com/linux/v7.3.1/source/drivers/firmware/efi/efi-init.c#L64

Best regards
Thomas

>   
>   static void __init init_primary_display(void)
>   {
> @@ -129,8 +127,7 @@ void __init efi_init(void)
>   
>   	set_bit(EFI_CONFIG_TABLES, &efi.flags);
>   
> -	if (IS_ENABLED(CONFIG_EFI_EARLYCON) || IS_ENABLED(CONFIG_SYSFB))
> -		init_primary_display();
> +	init_primary_display();
>   
>   	if (boot_memmap == EFI_INVALID_TABLE_ADDR)
>   		return;
> diff --git a/arch/loongarch/kernel/image-vars.h b/arch/loongarch/kernel/image-vars.h
> index e557ebd46c2b..4d1d7978553a 100644
> --- a/arch/loongarch/kernel/image-vars.h
> +++ b/arch/loongarch/kernel/image-vars.h
> @@ -11,9 +11,7 @@ __efistub_strcmp		= strcmp;
>   __efistub_kernel_entry		= kernel_entry;
>   __efistub_kernel_asize		= kernel_asize;
>   __efistub_kernel_fsize		= kernel_fsize;
> -#if defined(CONFIG_EFI_EARLYCON) || defined(CONFIG_SYSFB)
>   __efistub_sysfb_primary_display	= sysfb_primary_display;
> -#endif
>   
>   #endif
>   

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Stefan Gaiser, Jochen Jaser, Abhinav Puri, (HRB 36809, AG Nürnberg)


