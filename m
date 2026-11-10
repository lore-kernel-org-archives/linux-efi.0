Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794322008;
	b=BBzO37faRxvaWSxLgwL7fz+AymGCHtcpgw8QnGvTXzLMO+V/esYAVFlfiEplWUFy+UME
	 /mLig7rstleG4BYfPlkIAYJ0uF4L7dymE/IgukbhEf4TJZxiHwhJKjPLfRO65PfxJTZ4n
	 VmOVCorSuMTLELL+mhacUXZm2atF9HQQkuXmm5Wk8SUAOhVUJKU+kzZDX2FoscHkll3xS
	 t00DtOUQNQ5nk0bbe3eP56nEC/dDjS6k4QvTdeoNwUbY/qn86ZEc858zRqfYC3hBAVgpk
	 SHaI1Th1maxKk+hLHwYR0szNSaRmM8oePqNWLaTARVxGh1ZHOg63hW4Pgq2fNbV5WWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794322008;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=3fpw5vkQV00MZzYQ5OK3lZxe4BbABKYr3Pz4v+FktUg=;
	b=XDbNWKnWSUCfxC1J21eYEp5zRUi8M96S4w4XOvWgz/MqepGo8rTN6o+gQvFOaWTyTTH2
	 LJ4sghQ1/uhApgRozWr7yl3Tvuj3YphWM1ZrI9jA942o5TFmXf/9GYaA+zJ1n9gMqrVcv
	 J942LXhdERPrkQtXVl/OQZNG2uqwYGuZi27LzfwwW9ll3V0pzDG/MHCg4pjjok9qkWcLH
	 cMENNy9dfxBme2J+aY5Xlzsi9aq+dJZj0COtSe6v07r/2V3SD56Vl1QXw7nn4ryQokGOt
	 nGrLyytzXiNg11emxRr/J76dIHT+B3ccSfpOWMLItnJyFq+c8+27c2rsMurghyFXqvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=vGXUB5CM;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="5vwS/Kh1";
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=vGXUB5CM;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="5vwS/Kh1";
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE57606A336;
	Tue, 10 Nov 2026 14:46:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6BE57606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=vGXUB5CM;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=5vwS/Kh1;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=vGXUB5CM;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=5vwS/Kh1
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 74A6121F09;
	Tue, 10 Nov 2026 14:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794322005; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3fpw5vkQV00MZzYQ5OK3lZxe4BbABKYr3Pz4v+FktUg=;
	b=vGXUB5CMFdvnAKPLlYK1zWAQuk/FiBryrNG327MvzaMIDpJzZzfPBVkRGlnt9oyVwbtOIO
	nnZPHGMWffgmh1tPmMhTPKB8lg4In8N339yacvLbiXGmIv6WZ5kSHLZBePOy9B9h74/NeV
	HA6fDdfsBf9k3YSGKrPyMdc4pkaC5XE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794322005;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3fpw5vkQV00MZzYQ5OK3lZxe4BbABKYr3Pz4v+FktUg=;
	b=5vwS/Kh1ntJmKOvwdlC32GY7RBrN5Z8bSngFoKazMeGR1LlCBEKsxMH+AoxIbo2MjY+jrO
	AdDZrTNYuBOqvtAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vGXUB5CM;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="5vwS/Kh1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794322005; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3fpw5vkQV00MZzYQ5OK3lZxe4BbABKYr3Pz4v+FktUg=;
	b=vGXUB5CMFdvnAKPLlYK1zWAQuk/FiBryrNG327MvzaMIDpJzZzfPBVkRGlnt9oyVwbtOIO
	nnZPHGMWffgmh1tPmMhTPKB8lg4In8N339yacvLbiXGmIv6WZ5kSHLZBePOy9B9h74/NeV
	HA6fDdfsBf9k3YSGKrPyMdc4pkaC5XE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794322005;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3fpw5vkQV00MZzYQ5OK3lZxe4BbABKYr3Pz4v+FktUg=;
	b=5vwS/Kh1ntJmKOvwdlC32GY7RBrN5Z8bSngFoKazMeGR1LlCBEKsxMH+AoxIbo2MjY+jrO
	AdDZrTNYuBOqvtAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EDA1A1339F;
	Tue, 10 Nov 2026 14:46:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HNSjMFQu82rQNwAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Tue, 10 Nov 2026 14:46:44 +0000
Message-ID: <ad517faa-3c8d-43a5-a3d6-8cd6f046f757@suse.de>
Date: Tue, 10 Nov 2026 15:46:44 +0100
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
Subject: Re: [PATCH v3 2/6] LoongArch/PCI: Refresh screen_info after resource
 assignment
To: wuqianhai@loongson.cn, chenhuacai@kernel.org, kernel@xen0n.name,
 deller@gmx.de, bhelgaas@google.com
Cc: ardb@kernel.org, ilias.apalodimas@linaro.org, javierm@redhat.com,
 loongarch@lists.linux.dev, linux-pci@vger.kernel.org,
 linux-efi@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261029033440.973077-1-wuqianhai@loongson.cn>
 <20261110085617.2626835-1-wuqianhai@loongson.cn>
 <20261110085617.2626835-3-wuqianhai@loongson.cn>
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
In-Reply-To: <20261110085617.2626835-3-wuqianhai@loongson.cn>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:url,loongson.cn:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -13.50
X-Spam-Level: 
X-Rspamd-Queue-Id: 74A6121F09

Hi

Am 10.11.26 um 09:56 schrieb wuqianhai@loongson.cn:
> From: wuqianhai <wuqianhai@loongson.cn>
>
> PCI resource assignment runs from acpi_init() at subsys_initcall time.
> The firmware framebuffer BAR can be relocated, leaving screen_info's
> lfb_base stale.  vga_arb_device_init() runs later at subsys_initcall_sync
> time and reads screen_info to identify the firmware default VGA device.
>
> Update screen_info through the generic screen_info_apply_fixups() helper
> right after the root bus resources have been assigned, so both the VGA
> arbiter and sysfb_init() observe the final framebuffer address.

I don't know much about the internals of the PCI subsystem.  But I would 
assume that there's a common function that sets up PCI resources on all 
architectures. And this is the place where we'd want to call 
screen_info_apply_fixups().

Best regards
Thomas


>
> Signed-off-by: wuqianhai <wuqianhai@loongson.cn>
> ---
>   arch/loongarch/pci/acpi.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/arch/loongarch/pci/acpi.c b/arch/loongarch/pci/acpi.c
> index ccbcea61fcd9..cb313ff67f7e 100644
> --- a/arch/loongarch/pci/acpi.c
> +++ b/arch/loongarch/pci/acpi.c
> @@ -9,6 +9,7 @@
>   #include <linux/slab.h>
>   #include <linux/pci-acpi.h>
>   #include <linux/pci-ecam.h>
> +#include <linux/screen_info.h>
>   
>   #include <asm/pci.h>
>   #include <asm/numa.h>
> @@ -256,6 +257,9 @@ struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
>   		 */
>   		pci_assign_unassigned_root_bus_resources(bus);
>   
> +		if (IS_ENABLED(CONFIG_SCREEN_INFO))
> +			screen_info_apply_fixups();
> +
>   		list_for_each_entry(child, &bus->children, node)
>   			pcie_bus_configure_settings(child);
>   	}

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Stefan Gaiser, Jochen Jaser, Abhinav Puri, (HRB 36809, AG Nürnberg)


