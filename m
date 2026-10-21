Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792536620;
	b=Erq02Qcjkk5uODfL7dg2yYWn1DS0SHTRefDHEhMSYUHcxqI43v5/9zS6VcCGyc5ujoCr
	 6mSMiRMAbxZmVbhkwPVvv5cWh9gAIyDjUaWvrCTjis/Ql5spNO8Ey0rs9TygSGCjuwFeu
	 Pwg+PLHC0igN0EVjeSuXrteYfS3AUs42TntTEO27p3PVEAGrC7ETxxhjgRY/0kCe7LmMA
	 bzhr/awyOU9+lbq1laoZa0C8TDhPoP7hUdmwaECuZMdBHnRFEwxIVTsuPJ+iiXMLSozEd
	 yheB2A4/gSzHQhjnFWHAcYKfySsR8ZareQWc97FmMp3oJjfzetJp3HQfLw8eruXxvAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792536620;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=4zL0S6kvmtkQoYmoWRmufP9rJujsnjUqprK46hj2fn0=;
	b=pc/CApx1aFuedgUVeIido3wJu8vcGwfd6RrIB08DsiIB1XkARK48fGuW89T4FaLIRLX/
	 nMEG9b1gEBPVTEAH8Rl0++Idt+OrZHkq2WEP3NTZpRIHPSes1sFIbgr+ziPRUoEB1AmNU
	 oDtk1E727jz1DnhvILH42HLyfFqLeCZOuaKqxlyyg0lgtui11JTDlxaydlTpFoqUvmOlO
	 oFJ+WPHk39NRO3CzLHjZ2vXxGqsSPlWtVT8MB2ebfRL92IZxQtyCnoApWYfUCLGeomjV0
	 G5kOoIfFMKwxJMfm6/1Uib4/zWvu6G6wVAHQ3jZZoRe/w9nxGLmClFoy1WBUV1yPkAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Y9FIbqDR;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF4160A3803
	for <linux-efi@vger.kernel.org>; Tue, 20 Oct 2026 22:50:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9FF4160A3803
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Y9FIbqDR
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a1ec92f655so1347005e9.0
        for <linux-efi@vger.kernel.org>; Tue, 20 Oct 2026 15:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792536618; x=1793141418; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4zL0S6kvmtkQoYmoWRmufP9rJujsnjUqprK46hj2fn0=;
        b=Y9FIbqDRFsiHCh6wCMx/lGXYMzbEMpcYPExHRKo8kxmfRwSdsbHKcVN6b2o3fsfWmS
         EMfNStvVEXtwQlwGFhTspCN6Iy8LsIslmTQJZArs9croRUFFsg9a0R2Wmowm78fCGk+p
         qoMRAjWrlWyjvmo/cv+QOkjio/QCUym29eIrZxNWbZgTO868C5tZQiYnBcrDy/y+qYxV
         AxXCy+jIbfVSYNWbB6SaV+1+cus75rqPWlO2twcCFTqCAqrzmVEb5SQPuQ0TN5KrYxQd
         MNdNYIr9ltemS55NjRHUaTPPPJnI8hAvgtgmCV7T01bNB3UVCcpT2l7+0a9cI5hk20GK
         EuaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792536618; x=1793141418;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4zL0S6kvmtkQoYmoWRmufP9rJujsnjUqprK46hj2fn0=;
        b=g99mNBowzw/f2Nq+QZGQ6TEk7C8HryEmAfBvVryMPNS6ZmQeCuLukBpPtRLySR1Szy
         6G0VuWmiWYYJSbC153WaLA+ePltooIJwaXMuV1BHKRHW6m9slYNm/j/RMdLWtIwp/4A+
         JJ7qlIa33shb4evVhyybchvN7mywZA/PMCbFP3IaRAdU2RCnB5NHadKSHy7o+AIEYRzK
         rhUW8d7zMdmE8kKbOTPlYI3GR/XLfU1tvKIqw9s+o9s13QHuHFjyH+8R+HSejvicQLX8
         X+Wm4BNwmcZd06FxdWWwHD2hJ0j7oUjt3yNKyJqzl+Ej97Zc/r11TlW+WW9/hiGsY8h9
         MKhQ==
X-Forwarded-Encrypted: i=1; AKwUvBywyfeRXGZ1zf3Q4sL7ziUBOXnYa1eg5XTVYyiakqwO3zvfMpqHSaJ28GEcoP6Dv7hUHU6jtYNGl+I=@vger.kernel.org
X-Gm-Message-State: AFq9FYISK1cdF2upujQdN4R7RS7shZKwIg5XU6THZzODUJGXb+xWXM9g
	pi8yp4R8qgp+ahTnPfdKD4G9eV3uSB6Dqc+vfKJD/jU42VmFboLK9y4f
X-Gm-Gg: AYBFou3FCjEkmdQWUzst266iTXX3dLafIwI9Ewj/ZDjUEQibzXgb/B/c9Oef9wP5RNI
	MAW5mWr5SHvBcQo/IOPddLlFiEb28pMXSOT6xFkLJSJJVo7+DwenLqeMZ/Gr0AswjvSsDQQ9fUt
	rUHpaaMQlJ4nBJPtgGya9TvrYWKm1j8lQZWjONLomx3zJ3mgGEU0tgmClcjoUjdwr1oAA4VdmbD
	Czmi/n9xwKrsEuxTiaDl6PRGQpuQZ0akik4D7kQFrjSvQuJGftthce/+GzJrKVV03JdxMUHiF7o
	D/owlaozIUVqhnPdUfOv+UG9uYN2sUPboOz7MnG3EcKq983Jtx++iMnqO7DV/stJvzJMDGbArQs
	IjIcldar6u0Ba3NdQ5UaAqxxxqZ5hNekvEJp13uv7F4pUarTKVoxDcrrXBYclNzBd1vfoqp+6MG
	vPS5BPfaS3YU7eOAsMc8EtUF7i1MapGcXkcIDLPac1amwRncWHqYc5TnuV6R0Sw6mkVcv7iALdc
	64C1L88Cj5u6Ewjhx+GsYLK
X-Received: by 2002:a05:600c:b8d:b0:49e:65f2:db64 with SMTP id 5b1f17b1804b1-4a1fdb165d8mr2576335e9.5.1792536618009;
        Tue, 20 Oct 2026 15:50:18 -0700 (PDT)
Received: from ingenieria31.oficinasStQ.local ([79.117.46.175])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1fc0b42bdsm17511805e9.0.2026.10.20.15.50.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 15:50:17 -0700 (PDT)
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
Subject: Re: [PATCH v5 09/13] drm/client: splash: turn the device tree image as it asks
Date: Wed, 21 Oct 2026 02:50:04 +0200
Message-Id: <20261021005006.2341200-5-maximpedraza@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <350adc03-dd7f-4120-ac9c-b6d04ff44faf@suse.de>
References: <20261013093243.505776-1-maximpedraza@gmail.com> <20261013093243.505776-10-maximpedraza@gmail.com> <350adc03-dd7f-4120-ac9c-b6d04ff44faf@suse.de>
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

Am 20.10.26 um 13:16 schrieb Thomas Zimmermann:
> Reading the code below, may I suggest to do this in two steps: first
> read the image data into a temporary buffer, invert height and rotate as
> needed.  Second, copy the temporary image into the graphics buffer and
> adjust the color format.
>
> Eventually we want to have a useful and flexible drawing/blitting API
> for the DRM clients. Keeping drawing steps separate will help a lot in
> the long run.

Makes sense. v6 will do it that way: the first step turns and flips
the BMP into an XRGB8888 buffer, and the second converts that into the
framebuffer's format. The buffer is as large as the image in
XRGB8888, up to 8 MB for a full screen 1080p splash, and it goes once
the image is drawn. If there is a helper you would like the second
step to go through, or a shape you have in mind for the API, I am happy
to follow it.

Best regards,
Màxim
