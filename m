Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793091339;
	b=fYemJAx2akD5v3sOrCyBLAJS9wALEWxcI9uZ+zQcB3s1s63NduP3bNh4mdMpIQFaPw6I
	 2cwhRf7sHP6PauSi7NFgdUafvvmv+EemhPpbqFPtCWcDZgwaTy0SnUV2ykKs8U52bp/bg
	 NxmE0KFhv1bjot46KgfCgL//FoG7dtP2pptv10082GCD/Lma6p8zgq+IWZBdr6mYcbyXs
	 bBBYBwpRq6uMPLTS5tgeFoGBbJ06QGWJMlg33t8vSWITyqzfZiBBOZkvbhHSK65neWgCZ
	 cnUs9GKIEY/Wb4QxFc+DzX0Nf4QCBEv5kE1h2BjB0CnbPCbxhR3L803JHD4mUrtaiQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793091339;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ho9s6p1VYtelviR5lwhrV0eO33rHviRLYIfI2vUHdcc=;
	b=zRIa11TcpBkiq4FJ9D9zXqOJzqYfnd+lxWJwN8cvrM7wscUvfMvbbAd/zlb1vBm5iqVn
	 UX3CGJ3H/AFM1nRCeQQNNDL53mZCsxOOI23CHwft7MMFiTyo5QQ9hGACvr5NkpBBeG3W7
	 mVSfkgaEKTt0JfduEDu1GMT4IGcw1zf/eg2JKZ1ZghJgZ2ey/5kQiLseMfoatQyJj87mw
	 otTCuSAVJK+gxlawS1xmadP/T3ek/+y2OovVjJlZ9uC6ocUqfBoV6fzKT8uqr0F9NXGaU
	 +PBog7f87TNPpZCv1P1LbPs6g71t4EiTAAxI1y9U+csFh5BtFcB7zHbhDVCuaHfLNEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="b/So7K6S";
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC29606A31F
	for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 08:55:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DEC29606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=b/So7K6S
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a210470b49so31525425e9.2
        for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 01:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793091337; x=1793696137; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ho9s6p1VYtelviR5lwhrV0eO33rHviRLYIfI2vUHdcc=;
        b=b/So7K6SlEFKsKvpppdb0hN7X3ShpUHrDkEGpm+hdOpeXxye9etaE6J4sCSorRx3kM
         czfbxf05jtinPI2aiL8CJUaJjly9emI8ccsoyRnDlB0y/utbspCSYppB1MNcHPV9jGyh
         FUJyQwkeHy7tPIlYCOPYwSwuqAcKiYnb9p8e4vO6DoqVrdAoCSc8LHdqe5Fz5/Ajdid0
         HHXRDz1KMi6u1gdWUd1XyLiRq7erydGtwKm5Bus73oAdaLIEOf6z0IMjI+GLbqBKLZzv
         /pT74T2RTSe8g24UmLOQvAI9UqpdneqrpOjG/H42u4dI8pkQIqf3tFf6jrRXs9jtgNpq
         /q4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793091337; x=1793696137;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ho9s6p1VYtelviR5lwhrV0eO33rHviRLYIfI2vUHdcc=;
        b=sxSu+cCzRi37JRHx1zA4I/j5+rktWRT5hsFxcJiyhtcildkGNUzW5VmDBJz0TYnild
         7QKhwOHRmDzwW8eqA6APiuywpso82hRNa9Le167hsCF6rXrshoArlkQap/rutf8jTcEf
         5SWJv03lmdtVKxE0aJPs/Orwzabl1TE7jj4Y5lHeyypgzwwIYzvYoDl3nIiRwg56JClp
         zmTxKnYqgjB67w4m4ifE5QTWZWLxTNwR+Zt6mIyoj98tE0BwOgvR8ZxRC4mxb17H87vn
         tHwoa2CWXnsPMWZPfXOE1R78fTCcdciiQEgeYGbJ8tZO4a0zM4H0Ji2FyeA5xLfytoIi
         dL9Q==
X-Forwarded-Encrypted: i=1; AKwUvByCIMzLkPHnAWlALgsvizUe7sOEa7G4edXqZFXe2gwqiQyBIH2fG2G63P34/NGZMe4Ufx7+Y9/2nds=@vger.kernel.org
X-Gm-Message-State: AFq9FYJZ8bzxoLyYCZQS8kkRvTReeNC+gKHJgHv/40Zc/lx+wEnnrrYP
	E27fsdaLdpznRr8tSNqq6JafFajmeJrmaR2UVJ3TnviHrsvWQ7laaV48
X-Gm-Gg: AYBFou3/DhIF1ib4cc6vyGC+iGPn/3HGyeSNU2qi25qeykIslTE2ohcDou/BfW/Bers
	6sPIP+r33WMIX4CS5Z7mUdKcUHnewoFvIztNKCFo5OZXCn1b2EoLQhpULE1EiOuqWwveIOK+5g6
	mozuuhmIKUev0w5zDmjheQhYWnAxjroP3nQwQyJokiBrcse40JH9Pz7MRhX/TdUVFZjHCw1S1MZ
	FN/YVl89NPZ81Cuz+kg1hpyXhhL2SgI73Gjbvo3kD/PtDZy8sbSzbaxzk8qP81FdMnsg2CVl8Vd
	UtGPLEP0N6m0GHwgYpGiy3HoU+a2qeHZM3up6QqauC6Ftj0XcOsXutmISK6HUWM4keH42EiXvPp
	Cms2taNqTYQ6fJzc4C5k087VPQSkC8SXoyNvNqotf+uFFTPue55En8ooit493dJP4aN532wmaIl
	OVl/L7KdsqAxhf8aK4MjOHZF1dS3jvAWQ4gYoakq2FWnCluV7jFDm5OUt1RF5W6L32ZC9+rnUp4
	NkzmEmg80Lr04lBGdAVF/05Qy1ciUP/cfEumAE+guvQTKOxFNvR7V+ghQM9yX9t3YrqCciRkGa3
	Cn07kjtW
X-Received: by 2002:a05:600c:3544:b0:49f:fd40:80fa with SMTP id 5b1f17b1804b1-4a35acc6b74mr187900455e9.34.1793091336983;
        Tue, 27 Oct 2026 01:55:36 -0700 (PDT)
Received: from ingenieria31.oficinasStQ.local ([79.117.46.175])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a09434esm249835425e9.0.2026.10.27.01.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 01:55:36 -0700 (PDT)
From: =?UTF-8?q?M=C3=A0xim=20Pedraza=20Padilla?= <maximpedraza@gmail.com>
To: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Francesco Valla <francesco@valla.it>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Sam Ravnborg <sam@ravnborg.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	dri-devel@lists.freedesktop.org,
	devicetree@vger.kernel.org,
	linux-efi@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-embedded@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 03/13] drm: client: add splash client
Date: Tue, 27 Oct 2026 09:55:34 +0100
Message-Id: <20261027085534.1746021-1-maximpedraza@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <645c1c2b-9aa8-44b4-8a67-dcd7bfbe8fbd@suse.de>
References: <20261013093243.505776-1-maximpedraza@gmail.com> <20261013093243.505776-4-maximpedraza@gmail.com> <fafa7327-e624-49f2-98b2-83fd602a0ad7@suse.de> <20261021005006.2341200-2-maximpedraza@gmail.com> <645c1c2b-9aa8-44b4-8a67-dcd7bfbe8fbd@suse.de>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Thomas,

Am 23.10.26 um 13:26 schrieb Thomas Zimmermann:
> Please drop the parameters for now. If we want to give status messages
> from boot loader to kernel, we should first evaluate how to do that
> correctly.

Fair enough. They are all gone in v6: the colour and the BMP's name
are set in Kconfig only, and the patch that let the command line win
over the device tree is dropped.

> Oh, I just noticed that my comment got truncated. I meant to that "i
> should likely by unsigned int as well".

It is in v6.

> At some point I'd like to have a nice, shared drawing interface that all
> the clients can use easily.

The image is drawn in two steps in v6, as you suggested on patch 9:
the BMP into an XRGB8888 buffer, then that into the framebuffer's
format. The second step should move onto such an interface without
much change once there is one.

> It's probably ok to address things in small steps.

Thanks. v6 rebuilds the scanouts on every hotplug and keeps the old
ones on screen until the new ones are committed. I will send it
shortly.

Best regards,
Màxim
