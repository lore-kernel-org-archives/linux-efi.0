Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792536617;
	b=f2Ebhbyz7QX0f8kmUYAGkvJCizN+eeiHC9vaQak3b0d7tUcECF5wEJWSb+8kcl7mPYdz
	 qFMZ/QvonfRTVcvaC+6MBVHo93A6N+jM/2Mbv8gBKLlYtw21JUKeHS7Fh6CAHu7NcqxGH
	 rzoIZNU0YpJccC/BRJdWBv89zsQRfJ7fqLV38xSKebKY1Vuv8vKzjOrL5i5tnHc5+i3mP
	 4im31bDXZ3v1BWjeTK/4AEl8dyD/uEDoaC3Y59lDJZ4bhXvIwKDFAhP+bymDDEcMVVbH4
	 62xGjqjihHqKkMCbBdWDspZsu33Hxu+u6KXZpfMti2vNBJvDqntobl0ugButAaXx9ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792536617;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ux8U6EoVJ4/TwWYPZhWrag3dDFgz75/l4fo+qRdZwqQ=;
	b=VvE7xpREt1OQpJ/57Mp3PsEaJ2AFvbB5okJgrvFnO+wIjWyN3IqmkYExn8GAWFsuGH/E
	 oIV5GuYoKNkgh42QAgqpf2prW25VOgMBdBEcqswSoS1JJ4OtiL63wnVwyZLXb/KSoJOIY
	 zxHcZbX8YFsPyD7xdiCSSib7+XDARNt3qsGDW8RprosGbrGpTsgPDF/Xe6+Ksil4TXwmT
	 Xq9dNz+KRC1ME16XVhDeDUwpz0h5/a8Gb7EcgDOaUFRl0kE/mJyvI7QA3d2zWptePrA31
	 hL/tSBHdeoeQTSWnyJTx2UtC8uXwK8mPF5VMHof/8BbBh55LclbFT2khU41n5kl/4aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Xgg4e8g9;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F23960A2638
	for <linux-efi@vger.kernel.org>; Tue, 20 Oct 2026 22:50:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3F23960A2638
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Xgg4e8g9
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a1d75f2f11so467615e9.3
        for <linux-efi@vger.kernel.org>; Tue, 20 Oct 2026 15:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792536616; x=1793141416; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ux8U6EoVJ4/TwWYPZhWrag3dDFgz75/l4fo+qRdZwqQ=;
        b=Xgg4e8g9l9wuL+uMK94dlj39wYD58bkokWU6IXHDrEqFjEn1wX0v4SrdzIFkhDzWZS
         8ouLkCKjKUZhm8g3VXnnGB3Etyxv8xCqkfAeJDb0dGKAZP9yAXPMjkQx3/FaJgfIyIOL
         qd5cIi57sU8hx5/MQRqevp6bGulBcsGqthmrkWG2GnRAec+eZ8oaYylyX89FagTpVYMf
         i5XxQ886ba8N3uWHz2nMLm7yRybHqEdszfjY7kRWiInnMb5VAUR3sg/ovWvtn/Ke37lG
         xdVqDCJkXAiksSuvlFGP4vkc3RX2FntaW9vBtB9eEDJQGH/8iYUwbx74DfSSLvJ4SD99
         MFlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792536616; x=1793141416;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ux8U6EoVJ4/TwWYPZhWrag3dDFgz75/l4fo+qRdZwqQ=;
        b=dkLeq25SWv6dVQYG9vzp0mxSLv/moJPhTZ0KCpC4pXwR/OyKtjkFG6Jx8PBw6CH3Lg
         +a6636A+vjx0omRsfvYLsxiAQ8EebEevO0/HJUEY91hKmPcLgkNtbcqaVsgp/4oqNr9+
         fcg5Kuw/P2srh6F4AXV6cjtWkqPZU7rBu8Ogn97UNT15I+dGms9bQt1daLsM0FonMvzj
         5hLhWFq5CjDyEZ0ZYtlZ6N/0BD7EQLjAPbuNDDX6M1duLBvxeRBjH7PZhK5QXF/+VDFI
         sbsYJHOzxXNMICZ9LRrEHShoto57NX4bxGj+iXMkK06odLNZhC9MgYbZQbwHKdJytcCw
         voyQ==
X-Forwarded-Encrypted: i=1; AKwUvBzjLhh0+e1ZhgjYHxeytLdFIKNCcHwRgYLBQL3rKPW2IJ8F/Jh2MqYXqGmtqiN1Ph1myaCOOyIHKXE=@vger.kernel.org
X-Gm-Message-State: AFq9FYKr9x4oOUWVquyLNjRsCKBTz93nd0nao9UJfE1BrBUOFTy/daxz
	eFdt/agqW9nrSlGkKDLB0CO0+JGjzqHmvl7mZ+8CAyVOPTSdk4dGmlM2
X-Gm-Gg: AYBFou00rm0tqjbV2dvbdQUan4zSkTT0beX/jxx3c2x/aJDZ9FIn+fNdK/gP8EqMLco
	YBF7VZRcFzKiaX+iaAm/lK3mST5v3B56hErvRcT5ayAGbq90MY4317ElFvuXfYuprmRUF5TcHWr
	3jnMvvLalqx/NAjg8LX4mnmHgAfoLBSXM6deRau+fbfVfT5FSyp9dh6nHyCk5VDDgOEZRlGzE2R
	y/338Qa2fGg/9HUSwAx+DXRnRzb/Enq0ryFDFR5WdAOkSoAWLv46ihMmtUCZjYffYyQFKLKPflV
	oPTxQW+npLxC6t9erk0QMmRX2Ue47p94NBr1580hUSpEiqh4ath6GBLEwsEKN+Wwh/CngXkwnNS
	CcvMna/G64xqhEj4WiG+cEzX0jOFl060NysxqytSC3mNyvJYTq2IcYr3noIkncQfiNRte8PnotV
	NPjyPa3GumnuR+f/zgfDSnpCYHB57UjMVOlOJc019upWUAmKYkkTHMb/JtqQ4c5jPK3Ib5WRuLN
	DxnV+zCYqbg9ozCYeAZPkif
X-Received: by 2002:a05:600c:3d92:b0:4a1:c646:3edc with SMTP id 5b1f17b1804b1-4a1fdd0b082mr2686075e9.11.1792536615591;
        Tue, 20 Oct 2026 15:50:15 -0700 (PDT)
Received: from ingenieria31.oficinasStQ.local ([79.117.46.175])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1fc0b42bdsm17511805e9.0.2026.10.20.15.50.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 15:50:15 -0700 (PDT)
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
Subject: Re: [PATCH v5 07/13] drm/client: splash: add a device tree image source
Date: Wed, 21 Oct 2026 02:50:03 +0200
Message-Id: <20261021005006.2341200-4-maximpedraza@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <9834b569-935c-484b-befb-b913acead9c1@suse.de>
References: <20261013093243.505776-1-maximpedraza@gmail.com> <20261013093243.505776-8-maximpedraza@gmail.com> <9834b569-935c-484b-befb-b913acead9c1@suse.de>
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

Am 20.10.26 um 13:04 schrieb Thomas Zimmermann:
>> +/* Where the image comes from, in order of preference */
>> +enum drm_splash_source {
> The logic behind this enum deserves a separate patch, I think.

Agreed. In v6 a patch of its own will bring in the enum and the choice
of source for the two the client already has, the BGRT and the BMP
loaded as firmware, and the device tree patch will then only add its
entry.

Best regards,
Màxim
