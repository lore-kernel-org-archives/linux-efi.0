Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90EC72F25F0
	for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 09:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777282168; cv=none; b=mX5m5Kh6TJkV8UQFpzizc5y4WH3EH53peXSxEPf8VJ5zBN1kwkowzngz8P/VVvVhFDvXQr+A8tjRt4c2MY9H67q79sHSx1ycacTfufKyAMZQfRqkirKwSfarowGUV3MUZmp/puCckuK8CCmUX4oLeoQ1D9xJVRdT9ikwQDWsYdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777282168; c=relaxed/simple;
	bh=ZOsDGx6yoV0gkgm1H7hTV3PaKBw7ScWEW+1RhAs5+Eo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pj7BNstNM2AfwpgdM4sZSHspaa4rSorwHp9Ftc/Nk5b2W68Oh2SBmxX33dsqoHhInVgP5N+3l497fS8kXWru7QIJV5M3tBC3Nqk90nS8QjnDwbiIr5T7BUks0lVgmokpuEw5Lx6o/A93/HHcY+Bhcn1FfCZU/BHPsTadPJHHnEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QX00PRVc; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QX00PRVc"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4891c0620bcso67484995e9.1
        for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 02:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777282165; x=1777886965; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qhBsUsRnxGxteXWit32fczP20HqInrjs7pD4raLih9A=;
        b=QX00PRVcrvL4RniLDn0smz2QwrBAv2SiGwmg8tR39QhPrPnCIIk11pF76K+MbkiNHF
         O3fasHkmTdNEXFR73W9tFk0Cj1flUycP0l7ymr/SttW4mhLcaaRsv9RGXsUbqHFu2nrl
         lPekFGZIU5iCuCh2JvqNCwqPFzYmlXi/SaArH2KLA7WMGtJJXh47UXNrAqpYvr+f6K4h
         oJ9H8qghj2izMbmsKQi5fJnADJok2lB3u25Tcb/+XC2lL0yrB69orMsMyFNcGWhlJiTH
         aNdmbnllj0XqstKWjsSqKrfCWi4Y+wFLYnJSicFU22OEuI1VRjX/0PGuDp6/ogcUaTL7
         RWQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777282165; x=1777886965;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qhBsUsRnxGxteXWit32fczP20HqInrjs7pD4raLih9A=;
        b=bkTv8rfQk4NAiqBACZSg4X85hDPLD2WhbuDzXYNDe6WuPb62yb5//B2UmQKV77Vq4Q
         AyluEgxtRVM+NauW2oi/L/HPRvAZ24+2dhg9oJQNsDVR7QLbvLYr3H0JSXssF8jAe/zf
         xClZpnlNUynEx96vEFCYOoVB+llYFIUp7ZQIKB98qJbVxzKAtpqrLt8qiBZXFKxxIauX
         wFmGUZT+JTtEYsmZVRF80UD0gQiG9E743qgkvG0OF9HBYvrG5mOv4ZkRJ+/KrAGIqdNM
         E8AZdNozI2UuF7opugQizZwU+CDE4SjzpaxZr0uw5HD3LoJOff70YBeMeoL+hZUHN0Zt
         UuPA==
X-Forwarded-Encrypted: i=1; AFNElJ+hVdu131nd9J8ApFVFgRJxQunxVkblZlOcAwCrzcvtUKInj6hGGbixeAbDYDUeVEQXZimZMitS7PE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7g/m+17R616hPAUSIekUfkRtnFWlXPlmeAFmBBg6spHcBrr0u
	7fusu1c/UuMQ2h0RvSkUGS7Di0EaUfksYWx0W/MDaDRNicBVl6Rk/lyr
X-Gm-Gg: AeBDieuq/LFfliLUak6xmsKE5HAMuDMUH8syyoMOEZ4gLH088QWUNZkQ7rwlCHz9CNv
	cqQbSIcIqly70no4HMKss8aJJzVe4TprfeZhHl4qEu0jWvj69vwVXprFbdxiHUuiUmr5ijMzzgQ
	5N1faQ0d5AItsuiCEnymixrO9YxyoOg+gPpmrsVUZ6kvB4btuGYmzvamTUUfZ8OtV0SYroMuNej
	VtGjSVbSXymNM2fzXCuuoWllcYyTID/24VHp20pCl9caeXxUNtBTnthzR4GoJoYMNBcUeaObzpk
	DUSsRZMf7S2+cXdf29J/Xb+hMxYMNHMDZeBJMQjps+NML/Pzx8IXYtoWlNlp/3kZoyfea2P0DQh
	cdYuLXcwOtDz4dy8gyuGEsmLUOuZJDkJBnqcV1eHU0SgtHo3MDZdpEnn+C7okCvowvBtYTXV/Sg
	vSa6ginDzJkyg7hZqi+Ugu6+cIZ5dXnu1tephQ6ia21H7xOvyvoe3/vdxmOY6SzbAXmAP7VIclN
	0s=
X-Received: by 2002:a05:600c:c177:b0:486:fb0b:ad79 with SMTP id 5b1f17b1804b1-488fb78129emr534667615e9.20.1777282164670;
        Mon, 27 Apr 2026 02:29:24 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fb7ac6aasm249078295e9.25.2026.04.27.02.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 02:29:24 -0700 (PDT)
Date: Mon, 27 Apr 2026 10:29:22 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Andrew Morton
 <akpm@linux-foundation.org>, Andy Shevchenko <andriy.shevchenko@intel.com>,
 Charlie Jenkins <thecharlesjenkins@gmail.com>, Alexandre Ghiti
 <alex@ghiti.fr>, Ard Biesheuvel <ardb@kernel.org>,
 linux-riscv@lists.infradead.org, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 3/3] riscv: fix building compressed EFI image
Message-ID: <20260427102922.08d0bcda@pumpkin>
In-Reply-To: <20260425185151.477442-4-dmantipov@yandex.ru>
References: <20260425185151.477442-1-dmantipov@yandex.ru>
	<20260425185151.477442-4-dmantipov@yandex.ru>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 25 Apr 2026 21:51:50 +0300
Dmitry Antipov <dmantipov@yandex.ru> wrote:

> When building vmlinuz.efi with CONFIG_EFI_ZBOOT enabled,
> '__lshrdi3()' is also needed to fix yet another link error:
> 
> riscv32-linux-gnu-ld: drivers/firmware/efi/libstub/lib-cmdline.stub.o: in function `__efistub_.L49':
> __efistub_cmdline.c:(.init.text+0x202): undefined reference to `__efistub___lshrdi3'
> 
> And since riscv64 can have CONFIG_EFI_ZBOOT but doesn't need
> these library routines, rely on CONFIG_32BIT to manage linking
> of lib-ashldi3.o and lib-lshrdi3.o on riscv32 only.
> 
> Reported-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
> Closes: https://lore.kernel.org/linux-riscv/20260409050018.GA371560@inky.localdomain
> Tested-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
> Suggested-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> ---
> v6: adjust to match recent upstream changes
> v5: rely on CONFIG_32BIT rather than dedicated Kconfig symbol (Ard)
> v4: use more meaningful CONFIG_EFI_ZBOOT_USE_LIBGCC and adjust tags (Andy)
> v3: initial version to join the series
> ---
>  drivers/firmware/efi/libstub/Makefile | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
> index 983a438e35f3..e1c11d02a5cb 100644
> --- a/drivers/firmware/efi/libstub/Makefile
> +++ b/drivers/firmware/efi/libstub/Makefile
> @@ -95,7 +95,9 @@ CFLAGS_zboot-decompress-gzip.o	+= -I$(srctree)/lib/zlib_inflate
>  zboot-obj-$(CONFIG_KERNEL_ZSTD)	:= zboot-decompress-zstd.o lib-xxhash.o
>  CFLAGS_zboot-decompress-zstd.o	+= -I$(srctree)/lib/zstd
>  
> -zboot-obj-$(CONFIG_RISCV)	+= lib-clz_ctz.o lib-ashldi3.o
> +zboot-obj-$(CONFIG_RISCV)	+= lib-clz_ctz.o
> +zboot-riscv-obj-$(CONFIG_32BIT)	+= lib-ashldi3.o lib-lshrdi3.o
> +zboot-obj-$(CONFIG_RISCV)	+= lib-clz_ctz.o $(zboot-riscv-obj-y)

Doesn't that specify lib-clz_ctz.o twice ?
I think you could also use:
zboot-obj-$(CONFIG_RISCV)	+= lib-clz_ctz.o $(if $(CONFIG_32BIT),lib-ashldi3.o lib-lshrdi3.o)

	David

>  zboot-obj-$(CONFIG_LOONGARCH)	+= lib-clz_ctz.o lib-ashldi3.o
>  lib-$(CONFIG_EFI_ZBOOT)		+= zboot.o $(zboot-obj-y)
>  

