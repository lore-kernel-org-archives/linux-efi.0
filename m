Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F722277C9E
	for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 05:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777266485; cv=none; b=DMg7MQgZ83Pd2+LGlMk9i/xQqr3kOTljWZpx1ShJcfc5khvFrK4DtdwlSy9YhM4ndfbN5iFLoL4Au/bkowOZSg1rMiRJfRXIlRQIgq4LjwglpUb6sLEKTLy8fcGyIulhjAJRxfWRSySBZi1Zz7L0CklgEXf1RXwqXsTd+4LR+uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777266485; c=relaxed/simple;
	bh=Ii5NbXhUOQjRzp2VMCJFnmnZXxbX4WVN0w5DvDdGOSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jRQ3dcZC9PRgyYp6sRYKMGqf/EBjygsAF4cKWDuKe878Z+FyooOYAuICBRuESkKnKXendQIO3pq565e806pn3pJKb4OEca8iVc3rvrpcD24i2zIUsNUFGTH1t0Bv2MuRThIbD5AUOiaAw6O9yXbxM6gVGSeval6lyRhypKMRJBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bytefly.space; spf=pass smtp.mailfrom=bytefly.space; dkim=pass (2048-bit key) header.d=bytefly-space.20251104.gappssmtp.com header.i=@bytefly-space.20251104.gappssmtp.com header.b=Z3TiSOz1; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bytefly.space
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytefly.space
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytefly-space.20251104.gappssmtp.com header.i=@bytefly-space.20251104.gappssmtp.com header.b="Z3TiSOz1"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c7971d0d97dso5842275a12.1
        for <linux-efi@vger.kernel.org>; Sun, 26 Apr 2026 22:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytefly-space.20251104.gappssmtp.com; s=20251104; t=1777266484; x=1777871284; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uwuwd6uQq2G2p2tYzSTcZy6RNVRfyJhVgbCJbdY0nXA=;
        b=Z3TiSOz1JT3aO0wN1vqSYSTvTnwLvHcCw2Kkmps2ObQSCmqM5BfpLYUpCV47LuHExs
         v7GzeFx1bJlD4fgLPNkjYsCZeU9vppT/3mxO8SuGMVZyABAeX2sXoscXlz+MFyPj2hWv
         5nPj6QNG8g5W+zcRLtgQXQYVEKK8SxiNdAnP9KFkBCVZf7kcALZotifsj6lJY1ovAr1G
         l4P//OGPjj688dmA8zvDJ74zOumQiY0LS6XFTcL/fkSASPitFqpEmzluWkdaWpv9RFtu
         gr3r3oa+jjKxWDFRaLVhI+susK213RtxnL6sWFlnYvhI/nOU8hHJKB/Yfyt4sU4i3705
         7Qrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777266484; x=1777871284;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uwuwd6uQq2G2p2tYzSTcZy6RNVRfyJhVgbCJbdY0nXA=;
        b=XHV9QqNUaEllDW6aA6hucizeGodHvPFQZSNNCTnhs+Awz5UflvbNnJ3m4wlYhgsHnN
         0BBinkstZJxjqT3oreHCJm5tp3aGp+8tgiS/gX/2VP5Naee4BV1xBWOYyIPv3dTNRLWY
         CF+GyIwOiD8mzXWoqgL3GYNqHwNyugybwuUb4+Tw7xEejO54mPy7lSvR1ld5/nXiz6BQ
         UZ6Pb/k6eemRbV8LJ9b7sbjQzypEJ4PTk79X18GU+/Nx+CV97LCxbVrl/VU1L70bCx0c
         5IkG2kWVzpawN2RhD3JUm+lQDyrFiP0oPmX4lXk45lcsbTGOuH6CoqOwVXU/8G6swEqU
         0bdA==
X-Forwarded-Encrypted: i=1; AFNElJ+Pr3Sqt/YqkSYsNwC0NVrn48AR2MQspm6bDTbMDnFnLaHngER3k29VEB6l6cjE5g0avqxo9aIxkCY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxHKSvF7tN66KosizenAF4hgNVZ1HYm0xCgVx5cDntLB8qeFVs
	rXBDQTXN7ySaQdlaGUskMpEICN7dpZF/SZDfc/n+vbNHjLQb1Ge2HcBrybpO1bGk63k=
X-Gm-Gg: AeBDietHy+mEnob3hlCJBnHb2S/tMfA0SsQku4Cde7BorB6ELGrJQP9KWkBtNP21wGW
	u8DFzwX7R45Eb/YWUx+6tCwS27AGQYmdERO/YmebLqu3FTLxxtU7Wue+u53AUw0eo32DwmokWuO
	ylbEhast9NLu3gIk1NjMqiTI5dD5p9XGSJsagAQ/sXlkhSt73ciSVBn6iHebLQc7RyAT+CK+rYj
	XLqlvdWTPU7wJ1qT/9aUT/RuzqehTotKiG5UK3fYzMD6wQoA7IJohO1tFmpGHFXyBzT9Cxc6Rum
	889ogdX/WQx70L+gx86L3QgeFB+RjtoBJs6ja+8DYws/7sYptitb8+aBBOUNAlRp8iKbD7LjFeo
	TuDMk6CXwa9G1oQu6yKfEjfI6+G4/0b1KFrkIWqXmIz+dm65WI0h7bIWmlbFg81WwIIN/ZIRYHd
	tcloXYNoK2myR8noJR0ohB5KiEMw0DdK8F9k4OTstCz7XduxoHL2KD+RmX8iFhhQMb2WF9N7k/
X-Received: by 2002:a05:6a21:339a:b0:3a2:f2b1:1aa with SMTP id adf61e73a8af0-3a2f2b12e24mr31389145637.42.1777266483815;
        Sun, 26 Apr 2026 22:08:03 -0700 (PDT)
Received: from bytefly.. (139-162-71-225.ip.linodeusercontent.com. [139.162.71.225])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7976f8f3e5sm24293048a12.5.2026.04.26.22.08.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 22:08:03 -0700 (PDT)
From: Lisa Robinson <lisa@bytefly.space>
To: r@hev.cc
Cc: ardb@kernel.org,
	chenhuacai@kernel.org,
	ilias.apalodimas@linaro.org,
	kernel@xen0n.name,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	Lisa Robinson <lisa@bytefly.space>
Subject: Re: [RFC PATCH 2/3] efi/loongarch: Randomize kernel preferred address for KASLR
Date: Mon, 27 Apr 2026 05:07:35 +0000
Message-ID: <20260427050735.3410-1-lisa@bytefly.space>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260426120231.532644-3-r@hev.cc>
References: <20260426120231.532644-3-r@hev.cc>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Rui

> diff --git a/drivers/firmware/efi/libstub/loongarch.c b/drivers/firmware/efi/libstub/loongarch.c
> index 9825f5218137..80ba7d69e1b3 100644
> --- a/drivers/firmware/efi/libstub/loongarch.c
> +++ b/drivers/firmware/efi/libstub/loongarch.c
> @@ -38,6 +38,21 @@ static efi_status_t exit_boot_func(struct efi_boot_memmap *map, void *priv)
>  	return EFI_SUCCESS;
>  }
>  
> +unsigned long efi_get_kimg_kaslr_address(void)
> +{
> +	unsigned int random_offset = 0;
> +
> +#ifdef CONFIG_RANDOMIZE_BASE
> +	if (!efi_nokaslr) {
> +		efi_get_random_bytes(sizeof(random_offset), (u8 *)&random_offset);
> +		random_offset ^= (rdtime_l() << 16);

random_offset &= ~(efi_get_kimg_min_align() - 1);

> +		random_offset &= (CONFIG_RANDOMIZE_BASE_MAX_OFFSET - 1);
> +	}
> +#endif
> +
> +	return PHYSADDR(VMLINUX_LOAD_ADDRESS) + random_offset;
> +}
> +
>  unsigned long __weak kernel_entry_address(unsigned long kernel_addr,
>  		efi_loaded_image_t *image)
>  {

--
Lisa
