Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794784935;
	b=bhwB3Z2Xf+oxCgZ65JWbQz3BKrz/3TRQUN5g8DdcP/oGlmQBLuzj1Hz9+LyBAUDraTnG
	 hSu8Hkf00knQERflPgyypOeLjHFEbOUx/PxLdo6/F30hofaAtIsuJM0A+zUcrMAdTnz34
	 mVFK9yLOPPGZ0+VOxpiv59ZFO3OtstvjTKy3jUWEBVWU9UNR+NodDaDo/fTCA1qnXnLeb
	 +g8t8kazfVwxR7WsgP/CCB9Btum7nG0vr4W64aDb78MxyHYRWffBf7m9IYlUThckWMEmN
	 +xIQrN2lXiqJDpdJCPQqn1AN99sF+kqGLO443xl5lNNdr4FYffRNyOBDjnk7fp8hHCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794784935;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=uREsKIEDczdDVdj720bXK/T41S+3ar5PxkrrHsI/TEM=;
	b=UAzHwD41HRKYnYqtbJTWTmBft0B3rCDdp2e5hiDrlCFtKaQes03EMi45Ojs77wm0i7Pw
	 gkN99eYj9neXyUydEjgY1Town/ckBvCrNUvUYYviTfYeSDMluXpzm7oOluMy+IF+8H90A
	 /OYTATrkom7v7m+AKEWXnsTvW4d27TkxebRoxSfk4oP9HsZ8AAqHr6ZJn/r1PXx1g6QeV
	 F9WnMVQcRmXUvdm2B8LsA3rAMEQ/rHvgJBuXkAjKiVcUiGV/kWbrQN874Ubb/oAB6ApTE
	 Gn89J+OENknrSYL40HpSnT+7rPEefGqeg3mwMtUUUTO32wmQ/2P956yfgDTR6LWiz4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jQkNrinm;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5AE8606A8A5
	for <linux-efi@vger.kernel.org>; Sun, 15 Nov 2026 23:22:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5AE8606A8A5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jQkNrinm
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4b79502c27aso21144315e9.1
        for <linux-efi@vger.kernel.org>; Sun, 15 Nov 2026 15:22:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794784933; x=1795389733; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uREsKIEDczdDVdj720bXK/T41S+3ar5PxkrrHsI/TEM=;
        b=jQkNrinmnyiH3DT7YlgTu03VUyhi7q9DOquQaVlWG2jLJQvITuOTfMsr31WXFI+y8G
         +Ms42TCNfD1X8Dl6ARmdwurW4X+BahBcgVm8UHxkrzd8kxbab0jv+ZArjfC5id5O4hdm
         GzWp+0uOyvdUhTypeyVI95yeEE2pWqOZXxXXhi8gCTsDd6ZjFC3cyM4MtwGcv3j1c2E/
         I84JM9NZjz4EQwQzv7fYTqHIxRyZ1rZX8ReX7qzYdCxIqdLajnu0wbev3sqsM13aXYpO
         PG+kJApuGBCqeDWtl3PDAywcNnmBGGlKcyWUwatKPfe9hZBUeNTrDbGmpnHeB+Dymb9V
         upkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794784933; x=1795389733;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uREsKIEDczdDVdj720bXK/T41S+3ar5PxkrrHsI/TEM=;
        b=gwj/Cu89Qp3INZde4O8dqYMYvwgWigtq5S8jZIJ8e2BOJF9RZY51gl245YGDNhmdBc
         QlwDnqBO6y8CmAHaCvvXhv99bjmJzT6Bg1tNNgzd3vIctPQ4KM5+OWMsfNg3VM7Ktf6Z
         j4v2WG4ZLGWoejsTNAkIgQULeFG8sSRZ7+EQGx2cCj2f87uQjpq9D9URY0L56YYPtwBk
         w5KglaTHW3CW4IjUOd4KyxqA42y/B2ohu2v6jpDICNWK+/XVz+W5qCGk0rzjf2vYjjHX
         VErRNveSRWZN+td8qtIGPJoCz2ulEVGOAQd30n4G2JK5TioJ6RGH8giqcCsl8jI1DoQr
         N9vg==
X-Forwarded-Encrypted: i=1; AL+hErGEKt1ADd4oeJKkx49uPt9qHqd0B4CgBLfP2nas01jpshSXLKEDvhhhgHQrxekd7NpQR2iE+oYqBPc=@vger.kernel.org
X-Gm-Message-State: APuU4Z+gdplGuEMtNFQ6j6v7mYI2UKkw7RywyWz0QW2t5y7oUA55Wdkx
	L1DT1eHhhsE93Ib56MVMufqQhPz/Qa61aamqVC6m28Qn2xjFStcsU+xs
X-Gm-Gg: AYBFou08sQ3wxF+LP/pExrYNYSgDSTtLyOYLjkXVn4KL6xcDe8N5xa8DaPqGQ1iQfEP
	HOGcGuXKlQQMFHACBHYGUL9CC/AFvjo5MwsPq0t9OBh2sVO+7DBVuqbASpWG/lusMyIwwfRwb2j
	Tx2UeDLcDZvQSr+zeP59j3ncCe2PeZW+XbK++t2RQ1NMMYaBYP5zk82w8oUOpV7stSuqhpAui+b
	U6YuA06HoUdqhVOHsyWXRwUskMTsSxA1BuIJp+OfeK8JX91+iwh38M7YWQInq1e5fhQTOVPWfEg
	z37hQhfjtf8WXhiabWX73E2qK+JWPdvyX+ZmbHxGkAW6wRKiASiDFKzuKtiOrcQ/Y7TRe9j+y/O
	EqTyIZACOwg3Wi325RbFrESLdZORiXnZFLOuAugOJfCfaBucMpzXmtnmuMuRrgrfhB47DALKHld
	C0mSxHplJGbV0frgLtrD7jqfB98Rx4FH7D3jWcnwup533Pjys5kT8o8Q9RxhGKxkpra0c70tmL6
	OjYogfZXkvqkaX/oHXfYmtSh+G+IAllTAiaLDICmCBgs4Xse4OUHV+uKX2FuId6PEPXkcZ7/3ID
	XUpYlQbxP/MpZ10e+Kf0JCSe1Fr3s2oJ7z6VXlBlDiPB9KqjWHjEz88=
X-Received: by 2002:a05:600c:34d5:b0:4b7:6942:39bd with SMTP id 5b1f17b1804b1-4bb55ab1610mr175771075e9.26.1794784932986;
        Sun, 15 Nov 2026 15:22:12 -0800 (PST)
Received: from ingenieria31.oficinasStQ.local ([79.117.0.220])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb571f976esm127920955e9.3.2026.11.15.15.22.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 15:22:12 -0800 (PST)
From: =?UTF-8?q?M=C3=A0xim=20Pedraza=20Padilla?= <maximpedraza@gmail.com>
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Ard Biesheuvel <ardb@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Helge Deller <deller@gmx.de>,
	Peter Jones <pjones@redhat.com>
Cc: Francesco Valla <francesco@valla.it>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Sam Ravnborg <sam@ravnborg.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	dri-devel@lists.freedesktop.org,
	linux-efi@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-embedded@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 5/6] drm: docs: remove bootsplash from TODO
Date: Mon, 16 Nov 2026 01:21:55 +0100
Message-Id: <20261116002156.1027726-6-maximpedraza@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261116002156.1027726-1-maximpedraza@gmail.com>
References: <20261116002156.1027726-1-maximpedraza@gmail.com>
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

From: Francesco Valla <francesco@valla.it>

Now that a splash client exists, remove the bootsplash task from the
TODO list for the DRM subsystem.

Signed-off-by: Francesco Valla <francesco@valla.it>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Màxim Pedraza Padilla <maximpedraza@gmail.com>
---
 Documentation/gpu/todo.rst | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/Documentation/gpu/todo.rst b/Documentation/gpu/todo.rst
index e6d36f8da086..5e987e18bfcd 100644
--- a/Documentation/gpu/todo.rst
+++ b/Documentation/gpu/todo.rst
@@ -756,23 +756,6 @@ See drivers/gpu/drm/amd/display/TODO for tasks.
 
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

