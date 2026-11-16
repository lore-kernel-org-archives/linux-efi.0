Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794826774;
	b=ehUqnkmKoVD92mVVRlT57DTHbgeOg2EyCozPoEC5As2uJLyuUBlhSEFiMCcyFC0K5COG
	 NDVe6eL6hwqfO3/VyGKLaSPgE5/14BiRI3W3tNgd+81pQsGkO8kDrLrLwzMg1Vy38vYeN
	 0yfwt49Em/CuXfY6tQCijkN9wMEsIi0UtAbZjPh52d4x4rh/d58BAyOfyEV1ah0AGNzY/
	 thOrFCqj3hl8BxpBQ+50cHXTYsNRIa/obJqjBz0mKU3165wys6jEKVRwlsn8DJrcf2w/8
	 WO1Rtqg/pOLx/ggYdBaYPqUYW4Ot7DfJ8BudNRyRn6h9ketqcijTS+QIOWE0+CLCKOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794826774;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:
	 Subject:In-Reply-To:References:Date:Message-ID:MIME-Version:
	 Content-Type;
	bh=mJaN0b3PvIpi2y0OVrA15M2BP9AXuuHR0w2trP7Mx30=;
	b=xodKNzfY5qKEqTZRPPN3JHNK8yrcjtpXgGph9eqQFZ45ADeUF1OrgBT8A2Bj1R6xlY63
	 Tx4sCwuXUEX40kU1okcwOzyGJNkw1whdNYUDu1+h3e5Dbd/UQcF0p2mQJKUyuovZzG6dB
	 kmzNEHSgNfYRS+dFf92Nib2YJd/chD5TMDQTML42vdnZox4pyOWpHP97OMjqCLnZpoMqP
	 wes9HUxyIGFBEJBJsuSBQZ8KH2TOLy8xpEqm4r8kmPXDnWlPI/ZbDpyOih6XMr6uyfcFY
	 InM3M5auO016opRc6wt8l2anWwPKehTEO6kkdeWaJmH13WSFs5fLbvbFrJeSO0rREgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YAGjUNnc;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=dE9pU4lL;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDB6606A329
	for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 10:59:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8FDB6606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YAGjUNnc;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=dE9pU4lL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794826772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mJaN0b3PvIpi2y0OVrA15M2BP9AXuuHR0w2trP7Mx30=;
	b=YAGjUNncY3EDisBpWlxLEQsHYg3T7VMwzQpVc4S4grk78OS9qLzyt0GsAzCdRkuJqyuMuI
	1I1FgizGndwYUuWbTMS0N1CaWlkwO5zpS4zXhvEburi5P/wNBHWLcNXi7rYwlU7/VHZ+nh
	YMBPqePg2bWB/sVd42/pAgRkq5ROrhA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-ZXc86cHzPyWcPga3LpplgQ-1; Mon, 16 Nov 2026 05:59:31 -0500
X-MC-Unique: ZXc86cHzPyWcPga3LpplgQ-1
X-Mimecast-MFC-AGG-ID: ZXc86cHzPyWcPga3LpplgQ_1794826770
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-48e0461e040so2907113f8f.0
        for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 02:59:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794826770; x=1795431570; darn=vger.kernel.org;
        h=content-type:mime-version:message-id:date:references:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mJaN0b3PvIpi2y0OVrA15M2BP9AXuuHR0w2trP7Mx30=;
        b=dE9pU4lLn+uj6JDxjwu2uledLA1yRp98d8PVwi78uar4h0XfPCiW2fPnvVjvIHEu5o
         OBGF/awNMYRBwv9S5FywKBG0xzkQmb5vDmMU8uV2z/c0LflBpQsIyhBz4X9eJCm7R2tO
         765xVe2Vc2TyZXfFqf6jYaCUUj4XIyTDqTVTcpU1CL0Qjrfq/Zi6csQmA0WfqIygIQmu
         LNew0tgk0rKAGRuZ/jt8iHGdOugmCzuVxLsbptgJyzi3ECPudXnItUib/A4B9/JltMCm
         Gn38qa0L9b9SdJOBfJDtBHNE9s6Af5vmM14WxBxb1rDCo8Sa8mH/VjRRRDjfjRbonOEh
         Hgxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794826770; x=1795431570;
        h=content-type:mime-version:message-id:date:references:in-reply-to
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mJaN0b3PvIpi2y0OVrA15M2BP9AXuuHR0w2trP7Mx30=;
        b=oiOd8ydxt7KoccgiHIyGiMkWkWyiToFU0xjtaVWYDvyN7vZD+wLeNcyxurJS/nl0X7
         y8DslwwMjpSKUcWyWalXqSnOUAQ0iXHz0uo/AqQSxjNkVJB5AjKCp8jmbvzOcSkt+Z6c
         Ai+RTNE0gMxTe6VIlsp6cOT/y4ow7/LKOHvpLqgiSSqziMFxZDWHQJQkIBL69iZT2xmA
         tIyLwcjHJ61U2JKqkRC+b86oyfOvoR5SENzWbbhRbttFpPWdPt3cws7PpjgSNUzuwZk5
         k+R0/0dDab3JsE2GpAqEVMXWRJadYeZ6GuOkN+3U1wBk0jLnTT3qLxapjffWB2Az9xpA
         QcWA==
X-Gm-Message-State: APuU4Z+7p/3XzTW4OloJfOWrHVNo/ig6/OoeV+JwJZlmEFoKM4xUUIis
	yZCojFMcjGBYoapWzk9paevsNTZLSjFszv/U9n9ofFx7X2CUDigiHa8uIvnaHNSjgnREBOkW/6U
	bVQmJXovuHhFSEtUswEqdHbbsmrHLKPR8yytD/maaYQ1VVCsrGBRiRecmPhBzjA==
X-Gm-Gg: AZFdTZfUFuv2AvtdS8mpWUM73HUGlAeClr2KCCkLDwdG4oV8s+FPe7dpnGuRDflSDoe
	Ex3xub858vbRrz5Tomq+jqSR0FyREACrvk9Q6FYxHz6k7ci7RNSyibhXo69p+CDmR7Ke0ijcRrd
	wYylneqb1mG7U5JcHIWV8yXdMI4W9lAaOoSFSBhiKxs9vTAoOuNfK2OFV5qpsMbXcody7EzVj4P
	yVjfDYtaXUb5kC0ZMKpVubM1AAvdFZ8sh0PLJEnWP5oYGadjbZZFtQT6HoPNJqVdm23USuajW64
	bsnK60rssNs/NaACis/70/DkrTbpFWpD19eeda4voCav0KrUpnWwY71H072hRzBhZ1eD/wCsK6C
	YonWWYOZ1iGn14eQD7LSXLrAe+hdK1goA13bhO7hk285KBIri8Fy4OS5CO72iLEIy2tf0CIvbst
	+fj17E6919qp+QiyK/9CNUkVE/9EHUbgfi67tXBJY=
X-Received: by 2002:a05:6000:1614:b0:48e:7b12:aca5 with SMTP id ffacd0b85a97d-49c72e85eadmr15496734f8f.46.1794826769919;
        Mon, 16 Nov 2026 02:59:29 -0800 (PST)
X-Received: by 2002:a05:6000:1614:b0:48e:7b12:aca5 with SMTP id ffacd0b85a97d-49c72e85eadmr15496699f8f.46.1794826769302;
        Mon, 16 Nov 2026 02:59:29 -0800 (PST)
Received: from localhost (62-151-111-63.jazzfree.ya.com. [62.151.111.63])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c6020bb0fsm20381961f8f.34.2026.11.16.02.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 02:59:28 -0800 (PST)
From: Javier Martinez Canillas <javierm@redhat.com>
To: Han Gao via B4 Relay <devnull+gaohan.iscas.ac.cn@kernel.org>, Ard
 Biesheuvel <ardb@kernel.org>, Ilias Apalodimas
 <ilias.apalodimas@linaro.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 Borislav Petkov <bp@suse.de>, Simona Vetter <simona.vetter@ffwll.ch>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-riscv@lists.infradead.org, Han Gao
 <rabenda.cn@gmail.com>, stable@vger.kernel.org, Han Gao
 <gaohan@iscas.ac.cn>
Subject: Re: [PATCH] firmware/sysfb: Avoid simple-framebuffer behind DT PCI
 host bridges
In-Reply-To: <20261107-sysfb-dt-pci-efifb-v1-1-86d6c598671a@iscas.ac.cn>
References: <20261107-sysfb-dt-pci-efifb-v1-1-86d6c598671a@iscas.ac.cn>
Date: Mon, 16 Nov 2026 11:59:27 +0100
Message-ID: <xlv1fqx1rqi8.fsf@fmartine-thinkpadx1carbongen12.rmtes.csb>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Han Gao via B4 Relay <devnull+gaohan.iscas.ac.cn@kernel.org> writes:

Hello Han Gao,

> From: Han Gao <gaohan@iscas.ac.cn>
>
> With SYSFB_SIMPLEFB, sysfb registers a simple-framebuffer device that
> claims the framebuffer memory when it is added. On DT systems, the PCI
> host bridge may probe later and then fails to claim its memory window.
> On QEMU RISC-V virt with EDK2, a bochs-display and pci-host-generic
> built as a module:
>
>   [    0.703813] pci-host-generic 30000000.pci: resource collision: [mem 0x40000000-0x7fffffff] conflicts with BOOTFB [mem 0x40000000-0x403e7fff]
>
> In that case, register an efi-framebuffer device instead. It claims no
> memory before it probes, and commit 64c8a0cd0a53 ("efi/arm: Defer probe
> of PCIe backed efifb on DT systems") makes it wait for the host bridge.
>

I think this is a workaround and it just works because sysfb does not add
a resource (using the platform_device_add_resources() helper) when adding
the platform data for the device.

> Tested on a HiFive Unmatched with EDK2 and a PCIe graphics card, and on
> QEMU.
>
> Fixes: 8633ef82f101 ("drivers/firmware: consolidate EFI framebuffer setup for all arches")
> Cc: stable@vger.kernel.org
> Signed-off-by: Han Gao <gaohan@iscas.ac.cn>
> ---
> In QEMU, efifb takes over with SYSFB_SIMPLEFB and efidrm without it.
> With pci-host-generic built in, simpledrm is still used.
> ---
>  drivers/firmware/efi/sysfb_efi.c | 16 ++++++++++++++++
>  drivers/firmware/sysfb.c         |  8 +++++++-
>  include/linux/sysfb.h            |  6 ++++++
>  3 files changed, 29 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/firmware/efi/sysfb_efi.c b/drivers/firmware/efi/sysfb_efi.c
> index 2338de73c62c..5c2cb87178ff 100644
> --- a/drivers/firmware/efi/sysfb_efi.c
> +++ b/drivers/firmware/efi/sysfb_efi.c
> @@ -421,6 +421,22 @@ __init void sysfb_apply_efi_quirks(struct screen_info *si)
>  		dmi_check_system(efifb_dmi_swap_width_height);
>  }
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

I don't think this that much. I feel that is adding DT + PCI logic that is
platform specific. Instead, maybe what can be done instead is make the sysfb 
logic consistent between "efi-framebuffer" and "simple-framebuffer" platform
data setup.

That is, not add a IORESOURCE_MEM to prevent platform_device_add() to add it
to the global memory resource list. Instead, the framebuffer address + size
could be passed to the simpledrm driver through the simplefb_platform_data.

The simpledrm driver then could claim the memory at probe time, which is what
efidrm does as well.

-- 
Best regards,

Javier Martinez Canillas
Core Platforms
Red Hat

