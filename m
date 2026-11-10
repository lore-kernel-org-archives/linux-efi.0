Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794304717;
	b=qjZht8dMxO0WcD7RmGkjAa/oF5LPHPiOFsCHAeu+8GuHKmn/MmZ52FYQucCva8d8Smcq
	 DATXjsvo49Io3fQqPafPBFKL07IBCE2gNbeI3g1ZJjODZrpGI6PlwRDAmyJSWxn0cbNz3
	 YCyOjvY7+7/l+/81CrS0wd055taF9/TG4E1/TCvCL3Hm3Gsq6AMpPRKUsmAzpi0ExJXP4
	 Xbbonwn/5dgHia38EXDcUrgG77kgmmjs1E/Z3WyA2nEbW6be8YQKOquGsOPwbBRQM0mW1
	 m/FllJgf3HNUB1g11ia7V0VZMgOJzppLzOOlCPLZIF/cR0sAKV1XxV6OvwMLSdFQL0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794304717;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=LjLsTdbykZWYOu2Xqqak4ExujA0ehtqs8pmgzlzZOnw=;
	b=DkjYGxJPQqA1jbejIIn9XqskXrH4Jx94+D7SLlACzANWEtt3IMmgCZhqS0EsH19Mb1i2
	 GsJwnBsjHg03hFUy1/44Xk6SxfQMf+qhY5jQTOtu77TzVOJl1ouBj2KT1YSoNhYEEaQEW
	 T4VoixcYoMudszZBk6C2WDMlI1/92DMQEfMnbbkGNfnFi0YPFOM8xJOOgBKkYOjXmc0BQ
	 pXgIRMsoAYrLg5JIeDKSZ2RpK7Cx/1HVRCA77sR/ZIvoam5qu7B1GUITMl2dGR6lMzYm/
	 HZURCUCsSkMz5QGWYFgyRHMNi3v8U6OmjuE8UwMn+P8S2RudEAdAi5R4l5fS91K0UOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hIko30H9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5864D60A2620;
	Tue, 10 Nov 2026 09:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hIko30H9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CFF01F008AB;
	Tue, 10 Nov 2026 09:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794304717;
	bh=LjLsTdbykZWYOu2Xqqak4ExujA0ehtqs8pmgzlzZOnw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hIko30H9sGqtkr1koKEYyU13EfXnIW4ETy/QPkoOEri+qhUvkqXP6tPjCaaKQjRQD
	 vNON+qHaRuip2bi8ND9IEZFahDUAWQFkd0v3Id+h3ZlAdgoqIobKWO8yR7onvPksvQ
	 sH3usHBcfqt7+ezyCaizlqwPvDFcK324D2NA7A+8+iMmO6Hp23RezAfm6Nd/hiH4Zx
	 Qud6A9Lc/RMOCGdFP6ig+OFqZZroHKGL8CJU6P1LesEGBSwW1OSm96xwC9Kl6ABIlc
	 0K8Mn1B8lJpf34wbTpDaYj7V0DstdQdIaiGAZB3Z0qVV8G98SZQhk8xibmX76x/cr2
	 YBDyewSJohgJw==
Message-ID: <sashiko-outbox-206820@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 4/6] LoongArch: video: Implement primary framebuffer
 device detection
Reply-To: sashiko-reviews@lists.linux.dev
To: wuqianhai@loongson.cn, chenhuacai@kernel.org, kernel@xen0n.name, tzimmermann@suse.de, deller@gmx.de, bhelgaas@google.com
Cc: ardb@kernel.org, ilias.apalodimas@linaro.org, javierm@redhat.com, linux-pci@vger.kernel.org, linux-efi@vger.kernel.org, dri-devel@lists.freedesktop.org
In-Reply-To: <20261110092418.2647821-1-wuqianhai@loongson.cn>
References: <20261110090203.2631481-1-wuqianhai@loongson.cn>
 <20261110092418.2647821-1-wuqianhai@loongson.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 09:58:36 +0000
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] LoongArch: video: missing linux/export.h include in
  video-common.c
--

commit 3e46d96932a555bf0346972f71660950e04f755d
Author: wuqianhai <wuqianhai@loongson.cn>

LoongArch: video: Implement primary framebuffer device detection

This commit implements video_is_primary_device() for LoongArch by checking
whether a PCI display device matches vga_default_device().

> diff --git a/arch/loongarch/video/video-common.c b/arch/loongarch/video/v=
ideo-common.c
> new file mode 100644
> index 0000000000000..6fea46661cb64
> --- /dev/null
> +++ b/arch/loongarch/video/video-common.c
> @@ -0,0 +1,29 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2026 Loongson Technology Corporation Limited
> + */
> +
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/vgaarb.h>
> +
> +#include <asm/video.h>
> +
> +bool video_is_primary_device(struct device *dev)
> +{
> +	struct pci_dev *pdev;
> +
> +	if (!dev_is_pci(dev))
> +		return false;
> +
> +	pdev =3D to_pci_dev(dev);
> +
> +	if (!pci_is_display(pdev))
> +		return false;
> +
> +	return pdev =3D=3D vga_default_device();
> +}
> +EXPORT_SYMBOL(video_is_primary_device);
> +
> +MODULE_DESCRIPTION("LoongArch video helpers");
> +MODULE_LICENSE("GPL");

[Severity: Low]
Should this file include <linux/export.h> instead of <linux/module.h>?

Using EXPORT_SYMBOL() without a direct #include <linux/export.h> triggers
a scripts/misc-check warning when building with W=3D2:

  arch/loongarch/video/video-common.c: warning: EXPORT_SYMBOL() is used, bu=
t #include <linux/export.h> is missing

Since CONFIG_VIDEO is a bool Kconfig symbol, video-common.o is only ever
built-in and does not need <linux/module.h>, MODULE_DESCRIPTION(), or
MODULE_LICENSE().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110090203.2631=
481-1-wuqianhai@loongson.cn?part=3D4
