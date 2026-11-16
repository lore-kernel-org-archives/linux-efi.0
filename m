Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794830579;
	b=tXNo40uA+wthF5tzsjZ7/HWLiwt+qpGkCE395mT6QOWlsiSFMn51AOFH1efqSMa3VTh4
	 foZSQXwhrfWqAYmeO3JXLWv+S8zmTquJo4OevJyVyLHJzczNPHFiH1toc2CmwjxxtltpN
	 daEI5vj8y3Dy7cIwV+rSa93DfTLjCF3tKLFA1LoCeuwKzgxxjuhbGdHEfU5vY8Dbfg4lx
	 HVtzoqgyyvbefs5Jzy3GrJvjh+j+SL0kuV5dYkB4l8dFacwLEbgnFU8XXxZT/WJGbUWLB
	 rdeNUMYNCkg5A4sO9oC0yZT46BhKc+sEgdjEjd+mrAXYByVIwOV0GFAU3bF8fRnzTbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794830579;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=XakR3HwaA61RTSRKXiY8u1VTW14yNDhbXxD2aqPLa0k=;
	b=ZzbwQaaSGQJlEdiIYhA5I6WnVH5/01CP9SYoSqCw2V+SrC5ijQ1JR8+CcFF+G3L5vwmZ
	 tQRsxiNcfy4VcuKT7ZTXbYkSGeKVfg7C06cQJ14FNU+dPBbgiGVLKRXiKORgcMKZ9DQzk
	 7NJQ7ih+zlJtIqsKRH2Dx/A5imMwYYe1liPs3g99EMNP9CKXvZK+qcmJCCwBoS3oLnazd
	 8u7OWLxDnDipt2aZvFMIENyetGlmwbkzcfZL11o2XKm85wWERZyx03c+mgZso7tHDmnZ5
	 6ps3acA1evEpI90mqk9cI78i2g8ekeYn2gyHdx135ry62RXh+6BiVSMbZ7vi08aNVow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=FtaKOs8h;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=GBSuIaQU;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=P3S+S1W2;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=m4uH2vq2;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6003606A333;
	Mon, 16 Nov 2026 12:02:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E6003606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=FtaKOs8h;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=GBSuIaQU;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=P3S+S1W2;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=m4uH2vq2
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A1ECF1FCCE;
	Mon, 16 Nov 2026 12:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794830577; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XakR3HwaA61RTSRKXiY8u1VTW14yNDhbXxD2aqPLa0k=;
	b=FtaKOs8hvk+CE2ZxqchRuwfNwjPCWOBBQ7CutkK26oUGD1gNrt9zVCb5PxXoOHJehzZ/Z5
	cggkNuBcYvs3rGBzd7/dpG1/zj2f5AUOd8HJp6r8II4mpLiQJGmtdem/U3WtuhAwJfOKI1
	/Ip0wxIpQAp71btrl2gqKRbO+CqbI3M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794830577;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XakR3HwaA61RTSRKXiY8u1VTW14yNDhbXxD2aqPLa0k=;
	b=GBSuIaQU5ThIrz/oluo1RR3cm1bwZBjvuXHvh0e46+prp8sjlDlRUuzXMaZHYO+wNvAmyb
	sdTKkl+a2sWfp7Bg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=P3S+S1W2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=m4uH2vq2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794830575; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XakR3HwaA61RTSRKXiY8u1VTW14yNDhbXxD2aqPLa0k=;
	b=P3S+S1W2B+8RBnkjAEiL/iW91tFQ/ddvGRD6L3uZ6KiJo/PVj2r51SkeB04ijTsMedfDPT
	RAkeYQ0mLgH7tAWyTQkdFvsuXYq6NsMtBJRCBeuz7WDuE3PCpg+oLHljOFwJdQ3eZSsm8Y
	82//XxnPTT2sARbLGOgN+bP4EUoJyps=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794830575;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XakR3HwaA61RTSRKXiY8u1VTW14yNDhbXxD2aqPLa0k=;
	b=m4uH2vq2lFTxM0W0B60ZOnueb9UoU+DZG+208VhICmOcB1wdjf1w/1b0vY41UpHocz4kDd
	7VzlEY1J8gAqgaCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2CD4F1334C;
	Mon, 16 Nov 2026 12:02:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QYP5Au/w+moNTQAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Mon, 16 Nov 2026 12:02:55 +0000
Message-ID: <41d20d93-9961-4695-a9d1-cf80be0ec640@suse.de>
Date: Mon, 16 Nov 2026 13:02:54 +0100
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
Subject: Re: [PATCH] firmware/sysfb: Avoid simple-framebuffer behind DT PCI
 host bridges
To: gaohan@iscas.ac.cn, Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Javier Martinez Canillas <javierm@redhat.com>, Borislav Petkov <bp@suse.de>,
 Simona Vetter <simona.vetter@ffwll.ch>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-riscv@lists.infradead.org,
 Han Gao <rabenda.cn@gmail.com>, stable@vger.kernel.org
References: <20261107-sysfb-dt-pci-efifb-v1-1-86d6c598671a@iscas.ac.cn>
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
In-Reply-To: <20261107-sysfb-dt-pci-efifb-v1-1-86d6c598671a@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-12.00 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.freedesktop.org,lists.infradead.org,gmail.com];
	DKIM_TRACE(0.00)[suse.de:+];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:url,suse.de:dkim,iscas.ac.cn:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.00
X-Spam-Level: 
X-Rspamd-Queue-Id: A1ECF1FCCE

Hi

Am 07.11.26 um 09:46 schrieb Han Gao via B4 Relay:
> From: Han Gao <gaohan@iscas.ac.cn>
>
> With SYSFB_SIMPLEFB, sysfb registers a simple-framebuffer device that
> claims the framebuffer memory when it is added. On DT systems, the PCI
> host bridge may probe later and then fails to claim its memory window.
> On QEMU RISC-V virt with EDK2, a bochs-display and pci-host-generic
> built as a module:
>
>    [    0.703813] pci-host-generic 30000000.pci: resource collision: [mem 0x40000000-0x7fffffff] conflicts with BOOTFB [mem 0x40000000-0x403e7fff]
>
> In that case, register an efi-framebuffer device instead. It claims no
> memory before it probes, and commit 64c8a0cd0a53 ("efi/arm: Defer probe

But it should claim the memory exactly for detecting these collisions.


> of PCIe backed efifb on DT systems") makes it wait for the host bridge.
>
> Tested on a HiFive Unmatched with EDK2 and a PCIe graphics card, and on
> QEMU.
>
> Fixes: 8633ef82f101 ("drivers/firmware: consolidate EFI framebuffer setup for all arches")
> Cc: stable@vger.kernel.org
> Signed-off-by: Han Gao <gaohan@iscas.ac.cn>
> ---
> In QEMU, efifb takes over with SYSFB_SIMPLEFB and efidrm without it.

It's either efifb or efidrm. And the latter is strongly preferred.

> With pci-host-generic built in, simpledrm is still used.

And that would be your workaround.

I discussed with Javier a bit. We agreed that a real solution would run 
the sysfb code as part of the PCI initialization. That would fix a few 
other problems, I think.

Best regards
Thomas


> ---
>   drivers/firmware/efi/sysfb_efi.c | 16 ++++++++++++++++
>   drivers/firmware/sysfb.c         |  8 +++++++-
>   include/linux/sysfb.h            |  6 ++++++
>   3 files changed, 29 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/firmware/efi/sysfb_efi.c b/drivers/firmware/efi/sysfb_efi.c
> index 2338de73c62c..5c2cb87178ff 100644
> --- a/drivers/firmware/efi/sysfb_efi.c
> +++ b/drivers/firmware/efi/sysfb_efi.c
> @@ -421,6 +421,22 @@ __init void sysfb_apply_efi_quirks(struct screen_info *si)
>   		dmi_check_system(efifb_dmi_swap_width_height);
>   }
>   
> +/* Returns true if the EFI framebuffer is in a DT PCI host bridge window */
> +__init bool sysfb_efifb_behind_dt_pci(const struct screen_info *si)
> +{
> +	struct device_node *np;
> +
> +	if (si->orig_video_isVGA != VIDEO_TYPE_EFI || !IS_ENABLED(CONFIG_PCI))
> +		return false;
> +
> +	np = find_pci_overlap_node();
> +	if (!np)
> +		return false;
> +
> +	of_node_put(np);
> +	return true;
> +}
> +
>   __init void sysfb_set_efifb_fwnode(const struct screen_info *si, struct platform_device *pd)
>   {
>   	if (si->orig_video_isVGA == VIDEO_TYPE_EFI && IS_ENABLED(CONFIG_PCI)) {
> diff --git a/drivers/firmware/sysfb.c b/drivers/firmware/sysfb.c
> index 8833582c1883..8853a74560b9 100644
> --- a/drivers/firmware/sysfb.c
> +++ b/drivers/firmware/sysfb.c
> @@ -164,8 +164,14 @@ static __init int sysfb_init(void)
>   		goto unlock_mutex;
>   	}
>   
> -	/* try to create a simple-framebuffer device */
> +	/*
> +	 * Try to create a simple-framebuffer device. It claims the memory
> +	 * when it is added, so a DT PCI host bridge that probes later would
> +	 * fail. Use an efi-framebuffer device there; it waits for the bridge.
> +	 */
>   	compatible = sysfb_parse_mode(si, &mode);
> +	if (compatible && !parent && sysfb_efifb_behind_dt_pci(si))
> +		compatible = false;
>   	if (compatible) {
>   		pd = sysfb_create_simplefb(si, &mode, parent);
>   		if (!IS_ERR(pd))
> diff --git a/include/linux/sysfb.h b/include/linux/sysfb.h
> index ed23d6516223..b136fdebc746 100644
> --- a/include/linux/sysfb.h
> +++ b/include/linux/sysfb.h
> @@ -95,6 +95,7 @@ static inline bool sysfb_handles_screen_info(void)
>   
>   extern struct efifb_dmi_info efifb_dmi_list[];
>   void sysfb_apply_efi_quirks(struct screen_info *si);
> +bool sysfb_efifb_behind_dt_pci(const struct screen_info *si);
>   void sysfb_set_efifb_fwnode(const struct screen_info *si, struct platform_device *pd);
>   
>   #else /* CONFIG_EFI */
> @@ -103,6 +104,11 @@ static inline void sysfb_apply_efi_quirks(struct screen_info *si)
>   {
>   }
>   
> +static inline bool sysfb_efifb_behind_dt_pci(const struct screen_info *si)
> +{
> +	return false;
> +}
> +
>   static inline void sysfb_set_efifb_fwnode(const struct screen_info *si,
>   					  struct platform_device *pd)
>   {
>
> ---
> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
> change-id: 20261107-sysfb-dt-pci-efifb-d73b08ded4b2
>
> Best regards,
> --
> Han Gao <gaohan@iscas.ac.cn>
>
>

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Stefan Gaiser, Jochen Jaser, Abhinav Puri, (HRB 36809, AG Nürnberg)


