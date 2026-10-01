Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E88476079
	for <linux-efi@vger.kernel.org>; Thu,  1 Oct 2026 19:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790884745; cv=none; b=q2jN/d0D5F6EtwhgwrZFXM5vriqNthSRB7U2Wb0OQPgARbpoNPXcRq8bFPZf1n8JPSJHzwmLExk2EsWJu8ASV7pq7/O4aWluLL+0bJa5+BsvCRFtzZY9Sgl09zgkicu87LPRqBvegYR3u7bROm0Zc9nwTa2EhuScLJnRgyjTWPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790884745; c=relaxed/simple;
	bh=ZcbqbnyKp/n0WpB7iv3NE32Z90PzMJn0VzjmrHwzo7E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=udpAkcCjNPnQeQ/D5Af4qZKYSllLN+HUrnFLk815UHcXtL8sJOGUWp3XnIJaIL2wN3DOnHIRpdajWxVpxhJuYLTCfdsxIMGFiujCuTne08zYrWd0v1ax4AukWbvzV7P554mbyMYskxS9se9rnag2WPGk87r1VniSrgfNVLcsoiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PvBIhhns; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PvBIhhns"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e6b885ef8so41492625e9.1
        for <linux-efi@vger.kernel.org>; Thu, 01 Oct 2026 12:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790884740; x=1791489540; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=j79G9x93qm3T0R3P1TfLErsNrxHPzMPCo5TuV1Ni39U=;
        b=PvBIhhnsEit6xcQz0XNs2cpZv1N21PkUONjbI1P+8mRsKy6OcD3FC0PISN5I9dHOl+
         pd18maols5p/q6fKps/RuzzWaqBQGo0B6mscIa2dBZ0kaoeTdUoNKLuHQbl1Wa8RaG96
         jvLPkTdtMx5oJPg8zh7ccRKjQyUeTXPYWHA4NMgYn3Wm0Jib+yrNxtn7nEjNLQRJIueP
         YjoxXs7A0ac8lCHeY75vwOrYKSzU9Gl3HbTR84Pw4iX00Ulmd7S7byDfYDnEiEGdq15t
         lr4cczp8ExRlIPK5EDgFIH7Q4jDMCVVdZ/+5ngF+OpB0kyEJYQpQtSGdX8js0XTORvhW
         /xKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790884740; x=1791489540;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j79G9x93qm3T0R3P1TfLErsNrxHPzMPCo5TuV1Ni39U=;
        b=AOsF59sEn4QilWJdayayFAk79N6aOx9bKpCbQAiF4X2JvpYrnOt2qb6VDyu+oHUDed
         YQLWi4A1kMpvT5VJdLLfdSDEyS/RDO130q7FdcYFOJshJ5n5dxWDlZbT+c9KuUqDlt69
         S3e0lGBspap4zDxRfsha+mV2vnUJHS9GCD/yXUS7Z3UTXRaSG9NVfza3+0nXtrzO2MiW
         NM90pfCQerDQJaU3dsXsaDAZOpczIQk6z7D4YbFc97sL4MYjcDtI4bL3R/W4Fu6m6ZPK
         OItnAQCIqS7Yekf2/fs38nUHRpjTjKieQVr0JZJlhg0+PH6eJWDgTQ04/VxiiKL83B0q
         NVjA==
X-Forwarded-Encrypted: i=1; AKwUvBxlPdsWA5wQGNeIKWJ2+WFNQklDv9tTd76lDRRSy8n2FBM1FpwqjbwixBB5CIlKp7dg4OAUe9ukR70=@vger.kernel.org
X-Gm-Message-State: AFuF++ldN8kclIYdJDTUFnZUSh8bBAd1SRxs38C9V2KdLCq9jaC4yHvi
	ihs/amfusnXgqXSqTBjHR0MIfQIXZCwowD0oTIVdlSK9nM3HI8h4XK+m
X-Gm-Gg: AYBFou1iqpU6+I4QjV0PH1JuFDcxxKXOmNjzvC4oGijjmpy2xUWirNmKZdKexGaE1/r
	TTiZRgbu9l32oCraaXstNzoOiQ6x4CCGJ7+B1LC8Y7rFaU4ze+tz9/2zTIOgljrfeRSTAUXXY2Y
	+4+YJbx0xVLzOd6HkXFhPavux2oWUJr8T9If/YVfidUIGah+7FiiPvWbTj4HIuld4jfnK+E38Ob
	TqMw3ilAMHcwTJIOvktrYzVXq6XXpAl7stLDCgk4Q2Or241mwAFdkw4N63h0Q5zYG8E3UTKJ7aE
	/yFs0A6XQYHQ3Y0l5aE0+Iw7Kgp37O7dj66w0s7DrnVkf8Ey7/wqNGepBvomJM+ci1YKaNsHvPx
	avn4R3PPYMaZ/h6Yrxppg547c2OhzXFeGujzu5GtsvZgQqTk6qHkLCvBdEzMOnNJG2bWPP4KclM
	cUbPfokJHZ/mKFXn1HxLIjx4UZmIgMGsuXbj4UlGHLG191us8OOt5YYQnh7fVb7qrTST6KGkwfP
	I2uxyoRMWOfOUFYXNKrXLMreA==
X-Received: by 2002:a05:600c:3501:b0:4a0:1723:2d8e with SMTP id 5b1f17b1804b1-4a0274f3bcdmr12096855e9.2.1790884740123;
        Thu, 01 Oct 2026 12:59:00 -0700 (PDT)
Received: from ingenieria31.oficinasStQ.local ([79.112.15.218])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a0276f92d9sm15031045e9.4.2026.10.01.12.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 12:58:59 -0700 (PDT)
From: =?UTF-8?q?M=C3=A0xim=20Pedraza=20Padilla?= <maximpedraza@gmail.com>
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Francesco Valla <francesco@valla.it>,
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
Subject: [PATCH RFC v4 05/13] drm: docs: remove bootsplash from TODO
Date: Thu,  1 Oct 2026 21:58:39 +0200
Message-Id: <20261001195847.141192-6-maximpedraza@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261001195847.141192-1-maximpedraza@gmail.com>
References: <20261001195847.141192-1-maximpedraza@gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Francesco Valla <francesco@valla.it>

Now that a splash client exists, remove the bootsplash task from the
TODO list for the DRM subsystem.

Signed-off-by: Francesco Valla <francesco@valla.it>
Signed-off-by: Màxim Pedraza Padilla <maximpedraza@gmail.com>
---
 Documentation/gpu/todo.rst | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/Documentation/gpu/todo.rst b/Documentation/gpu/todo.rst
index a437ae5c71f4..e77de5e2a24f 100644
--- a/Documentation/gpu/todo.rst
+++ b/Documentation/gpu/todo.rst
@@ -773,23 +773,6 @@ See drivers/gpu/drm/amd/display/TODO for tasks.
 
 Contact: Harry Wentland, Alex Deucher
 
-Bootsplash
-==========
-
-There is support in place now for writing internal DRM clients making it
-possible to pick up the bootsplash work that was rejected because it was written
-for fbdev.
-
-- [v6,8/8] drm/client: Hack: Add bootsplash example
-  https://patchwork.freedesktop.org/patch/306579/
-
-- [RFC PATCH v2 00/13] Kernel based bootsplash
-  https://lore.kernel.org/r/20171213194755.3409-1-mstaudt@suse.de
-
-Contact: Sam Ravnborg
-
-Level: Advanced
-
 Brightness handling on devices with multiple internal panels
 ============================================================
 
-- 
2.39.5

