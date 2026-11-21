Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795272537;
	b=G1Au5zFjp5ZN9zB0mVdTyenOhPjo0mMkmT9NU4fvBh6GAwZbjYTZNGFkXlWgBxnVkwB1
	 oaGoVqqH7fSCFoL78NRqf28Jg0a+eZZrH2lbw/el8S9sG1ssSvC70Oi4XsIRbgCkxRPsH
	 66rqZFQr8rnKdinBYbK92pQRDsnuUbJNmF6oY8/3RICB8kdEp/RAcr/u+/TUzlLxWvUKv
	 rt04xnKWWEGyaU/FC71WKYNDKWoKOLjev8ZH/r0uOAosWEgty83IuI/uVsEY3pvnzmsNL
	 B4U0GnseI7ONuISFws7MgeQopggLvCPk4MFs8U2DNl7IeIfr+0CjK4dLMsE9vvTu91A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795272537;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EdCe+8kSe9PjEo1XndTkJdrgn2vsntTF1WvbXrRZYxs=;
	b=ZpKRr2ee4kVCgZ8owdzmKfdttDdcyjWN1Lmjjz81JwMzcMpdg3WyPe2HpUchxbXb/9pH
	 ncpap1H1BgONBKI89qTsbIC9dGVlEWy3uXIInC6GYDwbxepRQo+tOp4x5IzpzXQSvaxlD
	 z9DHJ+Xg3qzb4HP0itCL9IvJYNU/Iral/TEDN2nC16bm3PrU4uQhiYJrHAbXtTSLDu8sc
	 iKBIgWiyI1d9JaIfQ6TIv7VlGJAPIGCDpMaHCoDB9aAEorJYtMtXJstrGx3/3INoauZko
	 aeLk7z4mCQMjQG3DhB+vpn3FZTVZvisILesq+50ClhZhZkhjgBXk4Fz3dfINHlOit0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ddZnEjuz;
	arc=none smtp.remote-ip=209.85.210.175
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FAF606A32C
	for <linux-efi@vger.kernel.org>; Sat, 21 Nov 2026 14:48:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51FAF606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ddZnEjuz
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8a06e79e152so919331b3a.0
        for <linux-efi@vger.kernel.org>; Sat, 21 Nov 2026 06:48:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795272536; x=1795877336; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EdCe+8kSe9PjEo1XndTkJdrgn2vsntTF1WvbXrRZYxs=;
        b=ddZnEjuzbdWoUoW/4tbAOHS9vp1GkI8ol1D1jOZqCCmgvyVZuD/hITyx40rje6PmnO
         L2bKPzDMD1Y8Rgl7HDxTiNdXliZI/LkEzkZxbz8gCfvYDsXS5OfUccZFb5s9VYhEeRKW
         GpMoMHTzRtaI5orPzWEmwmbkvaVBKELWc9GPKYfta9p7ae7hj7N4G/kgB6LK6Q7zDtEt
         IT6Ytp739R+9fTxXrl6VigiUBnTrvpJeu7GkmKvN7qB05yqbUi/NqOk6O7Onzq/u1Y7i
         r63ag27vpXzFc7VRoLZeoob8+B1l7g0iEr02eR6Qb/I7NlWsfX79hPyYlXSHbYbW+ULb
         80zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795272536; x=1795877336;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EdCe+8kSe9PjEo1XndTkJdrgn2vsntTF1WvbXrRZYxs=;
        b=ZxR8UuvZCMrqbsXO5nZwFPcH0UxFA+YiRuCdiFfgb3FN5RrXmM13WLnc2Mlmt9AOjP
         moRxwbXBk1lFGmXGvwN5e4B39o2O7hIsZfFHUA6f31FHw+2uv1FB5nfXMiWWKjV2UpQX
         G5gL+ljmI1vev11eYfverIeViKJnyZlHUh0HOZyWqlYXDp7snNkGwUMlXH7mwKYpS7Kk
         4PBwZVS6pgk9cmznO5EtEPkvzbewgAP49q+H8vVAbB0DoJYHbqp8BBkZWB2hwgq/ewgf
         UF3RLBS0wJKuf/vJpczXRfEX0HtaKRzN4dkGqYk0/zvRARXi88BBJ5svZd4GlYBvY+NG
         zclA==
X-Forwarded-Encrypted: i=1; AL+hErE0HJXVNIkS/zXpAx5oNEu6xP+92d7gUjXk8EYn1Du1FEJy7aVcUHb5jjwesjeYfXV8lf31D0PwYmE=@vger.kernel.org
X-Gm-Message-State: APuU4Z/DkmAJw/e9ug7b1hdWyh9Pxk9frwUEyx9I8H9BqKwfGGkOhj5T
	QIJqt2NKbIgzacE46OiPCFBT4dn2TusYUsZ0qmgpC1B+QEZWVKbw7e01WoGboBvGziavog==
X-Gm-Gg: AZFdTZd69xPuDL7AUHQryYRw+2TettTWXaFEEQUa0T0jFOcFtH35sEFZ5h5wHcMn4Kc
	UoC79MBRAsplcQ+xu14GNbeuhkXTxQVe3MqfAk+E+k74VA7pGkkZRi74UV9q4qaRrHPcOHVxudb
	evTH4OObgjz6gJIroKIZVS1W0Wh/OOnBEG0juxq9xyTPLQrMGvEAL9FYKaDQg09njr++kh06gQ8
	gG4qJynRgPDJjjCT6ONnGyqLvHPhVTzLKgEr0geAHtVmmHcGlzpfl/Ry1XKz+srW0DSNEyBAhHa
	nRzN6XNe5tC5p30d2dSHUykeaYM4MG1Gh5VgorctkBuDJD6xM6ceeG7tJUmlYqoQfLtrmNhvoaz
	XYkm8s3wrfU+hquMlhxquD7RiP1G/pEr5gCeUpUlZkqgfiTLVHrArqvfZS+A0hXtiPLJBSBERh/
	gcy0qfrMISs5sVU4/CT0nJa5eaEFR9sJV2X3d59tdpJOBgmXXjwTzetVlQ56DD8Zw3rsblkiqwU
	rAUkSbZDRJUVacNLl9Oqn9Wu5jGWCNHW1kmtTqxyjDfHePNDtgFO3e0tY5t7UTzK1Up3H2x4uZU
	ryMhCPgHGQ3d1rkcEJX000mi0JVlh+YpVP7zluR/qSkNxl0pdsaj5aDL7g==
X-Received: by 2002:a05:6a20:244b:b0:3ed:bbab:9386 with SMTP id adf61e73a8af0-4014d35ab9cmr6017467637.42.1795272536129;
        Sat, 21 Nov 2026 06:48:56 -0800 (PST)
Received: from localhost ([2.27.148.107])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87343f726sm3048343b3a.36.2026.11.21.06.48.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 06:48:55 -0800 (PST)
From: Han Gao <rabenda.cn@gmail.com>
To: "Ard Biesheuvel" <ardb@kernel.org>
Cc: Han Gao <rabenda.cn@gmail.com>,
	gaohan@iscas.ac.cn,
	"Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
	"Paul Walmsley" <pjw@kernel.org>,
	"Palmer Dabbelt" <palmer@dabbelt.com>,
	"Albert Ou" <aou@eecs.berkeley.edu>,
	"Alexandre Ghiti" <alex@ghiti.fr>,
	"Atish Patra" <atish.patra@linux.dev>,
	"Stephen Boyd" <sboyd@kernel.org>,
	"Brian Masney" <bmasney+clk@redhat.com>,
	"Jerome Brunet" <jbrunet+clk@baylibre.com>,
	"Chen Wang" <chen.wang@linux.dev>,
	"Inochi Amaoto" <inochiama@gmail.com>,
	linux-efi@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org,
	sophgo@lists.linux.dev
Subject: Re: [PATCH 1/2] riscv: efi: Map runtime MMIO with device attributes
Date: Sat, 21 Nov 2026 22:48:45 +0800
Message-ID: <20261121144848.1277368-1-rabenda.cn@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <bb39f961-0589-4a3e-b649-888cf5edd3a1@app.fastmail.com>
References: 
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 21 Nov 2026 13:42:20 +0100 "Ard Biesheuvel" <ardb@kernel.org> wrote:

> 
> 
> On Sat, 21 Nov 2026, at 11:38, Han Gao via B4 Relay wrote:
> > From: Han Gao <gaohan@iscas.ac.cn>
> >
> > EFI_MEMORY_MAPPED_IO regions are mapped with PAGE_KERNEL, so device
> > registers end up mapped as normal memory.
> >
> > On Milk-V Pioneer, GetTime() reads the clock controller registers and
> > faults:
> >
> >   Oops - load access fault [#1]
> >   Workqueue: efi_runtime efi_call_rts
> >   status: 0000000200000120 badaddr: 0000007030012000 cause: 0000000000000005
> >
> > Use PAGE_KERNEL_IO for these regions.
> >
> > Fixes: b91540d52a08 ("RISC-V: Add EFI runtime services")
> > Signed-off-by: Han Gao <gaohan@iscas.ac.cn>
> > ---
> >  arch/riscv/kernel/efi.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> 
> Acked-by: Ard Biesheuvel <ardb@kernel.org>
> 
> I can take this as a fix via the EFI tree if you like.

Yes, please take it through the EFI tree. Thanks!

> 
> 
> > diff --git a/arch/riscv/kernel/efi.c b/arch/riscv/kernel/efi.c
> > index 2d3cc57b4535..11e85d0ebc91 100644
> > --- a/arch/riscv/kernel/efi.c
> > +++ b/arch/riscv/kernel/efi.c
> > @@ -22,7 +22,7 @@ static __init pgprot_t 
> > efimem_to_pgprot_map(efi_memory_desc_t *md)
> >  	u32 type = md->type;
> > 
> >  	if (type == EFI_MEMORY_MAPPED_IO)
> > -		return PAGE_KERNEL;
> > +		return PAGE_KERNEL_IO;
> > 
> >  	/* R-- */
> >  	if ((attr & (EFI_MEMORY_XP | EFI_MEMORY_RO)) ==
> >
> > -- 
> > 2.55.0
> 
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

Sent using hkml (https://github.com/sjp38/hackermail)
