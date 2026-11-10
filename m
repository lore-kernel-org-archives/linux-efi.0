Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794321552;
	b=TKMPcyblQ+kr/Y4ZfHToAWcsVJDd1oObKG/2iokl6wYvweL0Q2+vGh79x+eQIW1VHJ94
	 3YtUaIiRSP3j0CnYXhqhP8fzxM3NoQVhnJLNAqGwnocosIC7tKjt3mpvCZYJHWNeHCgGU
	 vmqy7BCaodMmEuUbhXDfRASCq2mofw92v00gwYM7tKR1HAFWL38YttWHzdv9WeqhGHQMf
	 dW2glp7qbi4G8jc7Md301QJ53DvxtIzvlvQYaWlK0m6PfkYnGijVqrE1fuGDY4GASf5hM
	 zVZVQJdloUu14f4x5mmbBr9oYfgqIb/sIkwp7oGCdCqqYioswpA3gF3dDOLOOJLmRTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794321552;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=ATK+YqeQgXY50uB6ssooNlAaHRhaH0LqEgi3TMhGkNQ=;
	b=s7Lj4xV5l9j5QmMxolwwJ876+y68IJXxFqUokw3/Y8Bn3tfNS0h8ju94HpnQPAKdgFXx
	 v7JbkbT13BMRR5YL9kcDG5nbHUlF7zwsKjXN08Lt72v1ankTrPevX50cSk2ktr6RMPkFR
	 IvhjXUFEpvP6YuTQ9Bu4BHs6lxtxA9ozGaWk3OVFzg76QJ8o3JMTBE2+vqLWD2WJWsNrf
	 cEPMN/5UcsOhM2PA5Zdcp/cHVEAMr+6g2n9laXu/4XmOasO1J9ejRI/jdq69zSPigoiW6
	 Wv31mNfCTYfKHK60qTgr0Y3F1fRW/foQ+nl06gkNCHs56iZdQOwELc5ZeoYVwwAwUaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=QIrFnosC;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="/0cjHZAa";
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=I794gwub;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=IcEaE611;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640C560A2604;
	Tue, 10 Nov 2026 14:39:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 640C560A2604
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=QIrFnosC;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=/0cjHZAa;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=I794gwub;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=IcEaE611
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 580151F769;
	Tue, 10 Nov 2026 14:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794321549; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ATK+YqeQgXY50uB6ssooNlAaHRhaH0LqEgi3TMhGkNQ=;
	b=QIrFnosCkb6jUOCkYdicq2C0FBqBQ1OGT74EBvrguRIZ1dpyREACyPyHPxFO9SHnV5yj+u
	5GzHuhqmxmbhQ+nVWQt3NW+iZFr5lg66nzcdkOCp2XnOEOzWI9AFeXsQgNpGWp0adzHgeN
	WXlAqXsWrYyuWx/xT33zSI1nrrM+1LA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794321549;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ATK+YqeQgXY50uB6ssooNlAaHRhaH0LqEgi3TMhGkNQ=;
	b=/0cjHZAaOG0Zp7HdM2M+ANGzgexsiZerrXSGZnm0GvJhwml2Sib7DLgGKCpBROqYr2Sr0M
	fwANQdAhWg4nA7AA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794321548; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ATK+YqeQgXY50uB6ssooNlAaHRhaH0LqEgi3TMhGkNQ=;
	b=I794gwub6utH3EXKblFpL9IawC35SVVkrTyQvkCx+AJ8x096V00K7d4MjrlX8+z7etU3If
	82laLElU9MBEOXpZqe9asOzS+cay2CVSOnHx+IMfodWGF3U/Lheks/8brSmBkQV1JFnuRz
	9xRb5Y3KEU1tXYKeZbNGQGXshfbfjXk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794321548;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ATK+YqeQgXY50uB6ssooNlAaHRhaH0LqEgi3TMhGkNQ=;
	b=IcEaE611buNt4DKQh0j+tpSQDSCFU4qm0ibGxMvmy6w2ADGeNnP+E5aKLZU2kixD84svTq
	VuNzwVjZqpbR6rBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CF71B1339F;
	Tue, 10 Nov 2026 14:39:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1j5wKYss82prLwAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Tue, 10 Nov 2026 14:39:07 +0000
Message-ID: <352a5960-77a2-4d76-9929-30cebf8f71b3@suse.de>
Date: Tue, 10 Nov 2026 15:39:07 +0100
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
X-Spamd-Result: default: False [-13.29 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_TO(0.00)[loongson.cn,kernel.org,xen0n.name,gmx.de,google.com];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmx.de];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[loongson.cn:email,imap1.dmz-prg2.suse.org:helo,suse.com:url]
X-Spam-Score: -13.29
X-Spam-Level: 
X-Spam-Flag: NO

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

The idea is that you select SYSFB is you're interested in that 
information.  I guess we could make sysfb_primary_display available if 
CONFIG_VGA_ARB=y.

Best regards
Thomas

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


