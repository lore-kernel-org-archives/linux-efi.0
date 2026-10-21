Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792536615;
	b=MvGFJfLuLNJevDRLXI+wp6PKHdi84kNAtRwIYCcH3cTRiiU8qidtJJki4Oh5cx/SOSxF
	 BRB7kimKfBqEda1C0A+xSmDk51rPDSXgCrt49x2FjtTO1n1d/sSjnROnUwbvOuyE6mKnO
	 m5LLzVJF8J5uVa9PEISKSOLRG8MzkPPi4ZR4RC4UhMeAg5+JHqSkBZNRgSJGAsgQi4+XC
	 VDtyIxISS3s+a0cAiBIq0MFCyYMLwlJNaORtxk3qTMs1hLdwO1ypbHEScl5zrQ7arJscG
	 Q/tWlfCzUwRNTs+NHAYkVdVV3jUbhUeyiUCQZzHTmcRHBnId57uePpmnwswl2/CYTOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792536615;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=f0vC8nTatz/VfjL47eh+tNgjT4mJh4syjFrv8ctbkr8=;
	b=NprApw/7EHyg5Bn3GxTzHZsCV6xCcjPpCxbzlS66KQjtbEynblLaqsLsdEAb8NeJGrzs
	 JDc3H9cD42SFA2joTY5rdYeFhSHklP9HlHX2Bh8J6Lnctl00Aj8bRBwhu6VOiIIfIrT5y
	 WWC5laBWDj83vh5CPm1fUPrzFNVrLfTCfmw6WAYfR4RvqcQuAHKVw1RdS680A3ay6ovu8
	 ZuE65FHBcXtWo8635/ZB33rZ6jOje+YzPhFp/cnaBHYmqQqvJPJcMdtGLrYdH6d9QCG5C
	 Vt+A/weJXcqrjt26tpDjJXq7Gbtez6ww/rdIkBAhP1UzZOjHgoAqjrYMyudXP66vJMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ngk54pFO;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF1A606A321
	for <linux-efi@vger.kernel.org>; Tue, 20 Oct 2026 22:50:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4EF1A606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ngk54pFO
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a021c809e3so658965e9.0
        for <linux-efi@vger.kernel.org>; Tue, 20 Oct 2026 15:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792536614; x=1793141414; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=f0vC8nTatz/VfjL47eh+tNgjT4mJh4syjFrv8ctbkr8=;
        b=ngk54pFOLWmfm72DmBQbR5ZFvu/68E0HsE/I5p7qjLhDU68EtREzXUUkOe1KdJtoJF
         CO8uj2ApOXtd4ggTGsgelwDkrse81BoWG6/B8j7zHrKz29Y2YVJtiMU8XsQ1V0rAN5ED
         74xyNd7xAR5wHmIF/hEm+j2q+/US/PxSOYg26nizg/eq0n0Qf+hcc88A4bVej//jOAhU
         JIN+3z8//MTou4wGoqrqTvmO519jPRA4rOt6hJlK3RntWR9pJpMGmWggWPbEV0Prwgh9
         KdomzFgOtRvIUay295YGeWpwSdA91x8jdDi30+Wild3BZCh6AF/DiaeZ2Opb6ZO5IZd4
         mehQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792536614; x=1793141414;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f0vC8nTatz/VfjL47eh+tNgjT4mJh4syjFrv8ctbkr8=;
        b=Lcwf8uiv9ocXNEufGVMBHZzTjMC/KRnG/xn/JzuUUAE8iJrEfKuFlgUXwGoW8VrjVs
         rlpWtUz+cIiWMF7icM55LfCwTpcGqEUXb2wP2AQB+9ktv3FZRNmsCHr4FpPaxXnQdjDC
         YkdtgHcz4ksHhZ8ksOV3DRGSs5XKTRhFM8gfvRGGJt8SvLnxzkrH+JPBRTD8pHQfY4pU
         cROHU5qqtOzGp8l4Twb03K8rgL/wyk82vJHjYHYbkh6yi8ghBfLnpqJvOqPuSufpvxZu
         jnP+R4+Wgyfs22GPkYderA03IG7zEhvXWmJYSDODETZXnohrntXYw/FfglUryD7OvNqj
         Snqg==
X-Forwarded-Encrypted: i=1; AKwUvBxvSDQShh9mOx8rcTQAHBdll1ssZfnt3uv6NiixxWBqfzCd+jEJK63CdIdyrMFzkbD5EuPIPGEyPNM=@vger.kernel.org
X-Gm-Message-State: AFq9FYLr1JJiOlyDeTrWNOT81mauZ13DuSnr/9bdRAFNfY0dCzKxQL2D
	ShRgoKk1HgYErjkOds2LghPFKGK+vGgBNGjx7nVXZvRETr79FxELVXqo
X-Gm-Gg: AYBFou27EMDs0c7aDLIV0COlVGqlrO1izDMPmuqWrQ+e2PRFeigpJcvSi3gaXf0fHF1
	1WFudDXTi6z3Khz4pWbGYAPKxjmPv5BTyNBh2jeDspo1VOzrPOuHSWdHiF8+SARTPMjy9eML5O1
	PhAoTPbzFK+1oQyy1joQEemUZluizpEc+w/p3ZudDN9q0Tv/FHN9uaqW+OkXAfI5i8z/CGQneIl
	ttGRbe6FWU5vFG/ncIoHXkBn+MGmsgIZn5/eNacOCpMLjNvM/7yuRMWSX28CoDJxu/sHYuSC2pB
	/2rNSaqPuo6ErDX/n7lIqngSsknatk44gW69JOk+dEjES/9G3UYstJ1zUHmp/L4MKtx1QSk4cuL
	0KpGdaD6c444md/p+fJ25XFxzlSBj4n+DOH4gub3AyKuXaULLYgr2tVIhohwktzK7ATzvWFhXaE
	W1PDagJKX1lFo7njqOoUm50muiFlFhKCSjs+UGshhdAVVLAi97fEobPfOfhwkab9uuyFGVK4ZN0
	tLlll1Nuo4CEHwadt2A2EF9xQ==
X-Received: by 2002:a05:600c:a0b:b0:4a1:7bae:d80a with SMTP id 5b1f17b1804b1-4a1fdd245bcmr2271955e9.9.1792536613728;
        Tue, 20 Oct 2026 15:50:13 -0700 (PDT)
Received: from ingenieria31.oficinasStQ.local ([79.117.46.175])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1fc0b42bdsm17511805e9.0.2026.10.20.15.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 15:50:13 -0700 (PDT)
From: =?UTF-8?q?M=C3=A0xim=20Pedraza=20Padilla?= <maximpedraza@gmail.com>
To: Rob Herring <robh@kernel.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
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
Subject: Re: [PATCH v5 06/13] dt-bindings: display: add a boot logo node under /chosen
Date: Wed, 21 Oct 2026 02:50:02 +0200
Message-Id: <20261021005006.2341200-3-maximpedraza@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261020164651.GA4017884-robh@kernel.org>
References: <20261013093243.505776-1-maximpedraza@gmail.com> <20261013093243.505776-7-maximpedraza@gmail.com> <20261020164651.GA4017884-robh@kernel.org>
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

Hi Rob,

On Tue, Oct 20, 2026 at 11:46:51AM -0500, Rob Herring wrote:
>> +  image:
> A bit too generic for me. How about logo-image for consistency.

Sure, logo-image it is, in line with logo-position and logo-offset.

> This property is already defined in panel-common.yaml, so you need a ref
> to it. You probably don't want everything from there, so just 'rotation:
> true' here. Though keeping the description here is probably worthwhile.

OK, v6 will reference panel-common.yaml and list 'rotation: true',
keeping the description, as it turns the image rather than describe
how a panel is mounted.

Thanks,
Màxim
