Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36E736F41C
	for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 21:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777325980; cv=none; b=Sgxspn9RU/hXWThTbQozWZN3vmJJxcoKOc2FrTRsjdGxHpm8m5b1E4zDCaQbrY/xa1tRHSpVXQHYuzzB13vk62Qs1hSRQu5Zo1PVW95QoLPB8UTx9smobylG0qCcpt9qwiNKtFMpztYDMXvgLBoXrQ9MghOFRUuNHRT3rdCHZMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777325980; c=relaxed/simple;
	bh=i/k46YQbNxc6jmDhpSrBTZQploRe2hY24KQV/uGHVj8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pDwC/x22qrWdaes+hfeAhyE5WwduuXCz0FctB7K3kKq5WTyorAHcnWEea1Mg6+xJ3pGsND6NRmxckNygwzf12QjLHtBeJror/eY7MC0rvSfcZDXuhTesfvSAskVqOpEuxhxhN7di/bbjW2LS9l4+4ma0xTfikr2YMRGKURIX3Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YikOQpWJ; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YikOQpWJ"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b886fc047d5so1920278466b.3
        for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 14:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1777325977; x=1777930777; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DjF1Jdn4Kp6xFyaBmAP2391GfFF2q7kuOVlruTChM90=;
        b=YikOQpWJdmOW+SS9CVxF3IPBnJwQ1mV9i4FjFSwhEn3FpvoLQLvicbjtgLB3tb9MSe
         dAluK9Kdd6kbQbLOun6/evQqYwPoVPDc9OLP1gQ5IwLM3ShJTzviqyWp4bCDgN8TOx2x
         VPVLDyBtEWe57vcTlEuoGNXgfHNBaenUI5chM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777325977; x=1777930777;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DjF1Jdn4Kp6xFyaBmAP2391GfFF2q7kuOVlruTChM90=;
        b=j6aGlmLrYmPyVcTICbyOxtrRSRvCL1u2T8occ1MgYYAShzNXHa2OcdT8MBcC4hbqhc
         yl68lT72xEo5akBJsU6kpk8eqJPlYMi4MgRqKiZ3z6abpCdrkbg2JH7nw90BeEq1+Yfo
         tGWOyAuiVx024iQvJEcMT/Qrr5mOv5g49pd9d0vQ+S2KnXkDTzrOvo7WtzOyvtfrm2Bn
         aO9SIZuiFefBNnD1uWXsBNzUW4Sdac+9mxUQ9t5fD3HS4fCdBT+oF0u5Gl7Q4mc3yNwe
         BgknxUVioSArGd3AIjVvQTXhcBgPEj44pH0E50DE4zcJBvfiqZ7823gPtXWEIjBRP/M6
         2kJQ==
X-Forwarded-Encrypted: i=1; AFNElJ/obdgw0i5IlRnwJemzhzpG0tPVsVVpicuG5Ivvnf5iz11gk682BtN0dz04B0xeYJQW7LQU3sa/Jd4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxfg0uqEsQhyZDHG+6ZZvvspYkyCSK38Jzt44F/50GO+K0WYUEa
	iWEne42/YpgITHkzA7+JocfyyQe4WQaH7dPTu9TEy3sBL1ee69HTbOeNfpIgegzCpL4Zh/PtbrU
	UxCaNr6axLQ==
X-Gm-Gg: AeBDievm7aT1ced+rztE1wpknLsQi16c+awxGxzI2B6Iyye1meWvza2L21HM05FaTh9
	WeO1FNe80wsD/OtflM2Jl2Jhkh/megaBFbkRgHRLbV4CVEjtTQ6azcTo1o3XFO6qWG1OJKwONqJ
	5+qiO7EgZEYQexBZX/S7rft568Wz/dnl8FTj4MGDIpPlef3P/VPMONSw1K0SkxqAWODFJ9w6LQX
	mtmeIwvkIFAv85CD+CQL6wIiCALzcUTXM9gukckGdJyRYDPWPYgoGnyEzx+at29R8x66ONG+L/l
	bVFrOHNUoQCzED3GtpjSAyj3itynuf2AsISGQ1xGBNfCVkhTp6xdush6ZqZz4p/ImpPVwfmA/dW
	8s3GUO7uZZZMQuqwjzodHXIhJOnXCkb0WZioLf3Yz/ow8UWypBfcT6moP1FSlb8IFaCFdIr/4dM
	lT9FSIPyKdKlt0aIGAELrSmDPW3HZE4LtBcb7HQWoJvWouOmtTi1+s1d7gEd82DaPyl9OiA1lcw
	WHe/ObQr6mKgzyuUjncjg==
X-Received: by 2002:a17:906:ef05:b0:bad:8491:85f3 with SMTP id a640c23a62f3a-bb804c32754mr23088466b.34.1777325977220;
        Mon, 27 Apr 2026 14:39:37 -0700 (PDT)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com. [209.85.208.45])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bb80853ebfbsm9600766b.3.2026.04.27.14.39.37
        for <linux-efi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2026 14:39:37 -0700 (PDT)
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-67389cf78b0so18821360a12.2
        for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 14:39:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+V0TC+YVthWUwb8OxOLuxzbY7E7MUWVMcPfMorCTuEW4Xe6wEwWtD13/TCdAU/4ALDrrx21bfrWJI=@vger.kernel.org
X-Received: by 2002:a05:6402:5216:b0:679:1f4f:9d30 with SMTP id
 4fb4d7f45d1cf-679bb04c1a2mr179970a12.4.1777325976937; Mon, 27 Apr 2026
 14:39:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1777306795.git.chleroy@kernel.org> <289b424e243ba2c4139ea04009cf8b9c448a87ff.1777306795.git.chleroy@kernel.org>
 <CAHk-=whC1DZojwdMB1=sJWG2=dsCdfyU8N6tDE1qx50HRZ-WJQ@mail.gmail.com> <20260427222914.1cb2dd3b@pumpkin>
In-Reply-To: <20260427222914.1cb2dd3b@pumpkin>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 27 Apr 2026 14:39:20 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg0SGbRYhdZ1kvJUTv1HEvmRJyQauFtBGV_fMcZVF8UpQ@mail.gmail.com>
X-Gm-Features: AVHnY4I-AxqvQRk42MegvhKMp_z4sSEpEzhzpgw2GyV2bV8dezSPoI0JTlwB18Y
Message-ID: <CAHk-=wg0SGbRYhdZ1kvJUTv1HEvmRJyQauFtBGV_fMcZVF8UpQ@mail.gmail.com>
Subject: Re: [RFC PATCH v1 5/9] uaccess: Switch to copy_{to/from}_user_partial()
 when relevant
To: David Laight <david.laight.linux@gmail.com>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Yury Norov <ynorov@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, 
	linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
	linux-um@lists.infradead.org, dmaengine@vger.kernel.org, 
	linux-efi@vger.kernel.org, linux-fsi@lists.ozlabs.org, 
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	intel-gfx@lists.freedesktop.org, linux-wpan@vger.kernel.org, 
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org, 
	linux-spi@vger.kernel.org, linux-media@vger.kernel.org, 
	linux-staging@lists.linux.dev, linux-serial@vger.kernel.org, 
	linux-usb@vger.kernel.org, xen-devel@lists.xenproject.org, 
	linux-fsdevel@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	bpf@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-x25@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-sound@vger.kernel.org, sound-open-firmware@alsa-project.org, 
	linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org, 
	linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linux-sh@vger.kernel.org, linux-arch@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 27 Apr 2026 at 14:29, David Laight <david.laight.linux@gmail.com> wrote:
>
> I think there is a slight difference in that the normal copy_to_user()
> will determine the exact offset of the error by retrying with byte copies.

I have this dim memory that we decided that you can't reply on byte
exactness anyway, because not all architectures gave that guarantee
for the user copies.

But that thing came up many years ago, I might mis-remember.

            Linus
