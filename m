Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793109229;
	b=TinTzmW0Mb+QOmwHSiZwcPaySM9PubijVnHp4N8rv0v5tumhri1Fa7gTFjXxmW9UfjSC
	 1Iy8B6dZncoqlfMVw4Kh7fw6hmUIRSQ6DbYSFyopSlRuxORAWAhtaZ/lRVwJzM0EoPKhr
	 Jyg2PJViRyzQ6Jxa91+UMKjCOlN+MVzKL3MhjrGDXWzTXKg2rYLnRhxKMxYMgi0gSs+qo
	 JFWl5ZRiW+rZdY0VTik4gn8XFGAG16wSG9rbwbsctCEplS3asazVOOoHvdJcYzlQXdJh3
	 puJA9/D1RxEk1OmeU/PVke8YE1+nynSapsgJjr8sWD0PGCd5gKSJHTQL7YUjlwuyYbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793109229;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=/ggIeAF8ymqQPticOc6wmD/qoAjkwXyVLKkCNBrapmc=;
	b=uE+Y9js/7nxTZ6ZjEwZcFKA6ZxzSfxavRwCVd5gEd7fdbxOKtpcScTtrAWkIKKhANxzG
	 a1j5M8K8tXfCJLu3fkLc45VV7W0r1tMO/zy8rdmNeyEKUjfCZgw0jh7gJcsoe/Uri9wzq
	 +bWbB7I0n5kKweRMqKNbaVNxbaAPZA6DDilUFnenDNINGd80PwDTSO5ib6SaKFJB/Fq7h
	 dUG24HvWdAcU/zntvghVLvz/ysWjLXOMG4ScTRRYoaS3x4GXZWBcMidiafhURjQ4me3b7
	 R6iY1fIxVZNakQyaDPza/0EEOfd9B+ve8lfBHBUCq7hB2Z02CDFu8vJKiXHvK891Cbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=J9EdSbtg;
	arc=none smtp.remote-ip=209.85.221.51
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A71606A334
	for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 13:53:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5A71606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=J9EdSbtg
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-48e00eee27dso2712374f8f.0
        for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 06:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793109227; x=1793714027; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/ggIeAF8ymqQPticOc6wmD/qoAjkwXyVLKkCNBrapmc=;
        b=J9EdSbtgiLFlXq27G6BCfiLyCUmgTmamz/0X4sPuWGR7PI4baQHTwUqiGYuOjNv+Zw
         1+lFWIFT+YbazTtQ73hJYOUYzJ3Z4g1NZE2eOsEyEZytb/i4LPOqbzR0IbSPSNEytzDz
         1hHhw/E32QerKbf6y9ivfV/PqizTxvtDena7LjediVrmbjhB5EjOWBkPv/tNqmWrG319
         Ql3I/u4j6qJosxpMmd/ho6YxJ26kxYdNzdxIqPRZcfKDqva/aEjEcEyumDsrF2yfWlTf
         74MjiDyd35Jl7TGIWolX3bWIaH1dYsBJ625xdzWOV1luCLOkhS12QU6RQOgcVXRjuHtC
         2PGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793109227; x=1793714027;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/ggIeAF8ymqQPticOc6wmD/qoAjkwXyVLKkCNBrapmc=;
        b=iRcJPvy3AKRJC+Cs40SSKuYCACUeKX3jjK/v9ivNHU7PpEAGKE/qvfn/KMd8rD27L0
         h9QPZvR1V9XekO6IrrB+dzuiiPOGSWTrFmuX+ScUTGns9UiKt6ez6imdhQJkx2I0k2s6
         9qfmAsKdJjH3WfVETcC8ClLZ5V8zhkTkIWpbJlVwaZc58kkKhF+DSY8ak02Kg1nxGOWR
         TliXmfFev63kRlyfEtyuS0puZ2scpAfKGPMUZWSLx2PPA8p2Dp0MasytQcU5xExqeb/1
         PZQJzHIuhnUxd+fHxwLPVLlNefdj36JlndeTHFOOCwec7tcyK+XUCQekcHO6aVHlLKW7
         VGvw==
X-Forwarded-Encrypted: i=1; AKwUvByNMk7AYS7RJ+tiRPbJxQd1HlpLlLSiFLg4AaYmlFhbYFJSqUG9WCHqZDINtKJqDE81gx9tJKCDw1o=@vger.kernel.org
X-Gm-Message-State: AFq9FYKKtXu3vazcLq/rfFcdoNhEBNcI1+cdDxaop7FmKU5bWAx46RQR
	ZqqHAQtZwsFboIdjTh3sBSecvTw8EJKfmKHyOGVcyFr0G4SDcUWNoRKq
X-Gm-Gg: AYBFou3+ijhOR0LVKCs6llXHGEVO6uqrh9MtURK8rEJQm1Lgq38SzuRWUHzhgMhXVBj
	lX/o7RU1N/gqfu97y+iqFIimMNUJtL/C9ExHcaPzN1uaBy7qJxmfYBQY7V2qWuZZ/LnAR6YEzwa
	0hakhp6Lo7PpRPHITE0sXsw28KVeyrxyKIY5hl3A9cb8mslHPVYNqbgQrNX8/L97PNsDnnszZnG
	HOhBIwGR1YAOMHYhtayy8duUuZv3Lt5VhlwAfwnNEbNtrIJKDdz7CFfdwHPAE/Ik9Pxjr9mtVXr
	p26gAXmB9xnViUOCGQzgVWG262ZuKHmMgkOlRQbJfWbngMmBNud8oZ+5iNOaK3UUwNl568AJurN
	zlobjyhf47JZqwkCHZf8R3VRDTSUB22p/AEFvA97JJpM4OMOet50+W4fiP11ghtKWxZUsp/vAR1
	bcDYey+J2pspgszNzsNUFk0jOJ6xbmtXi4349pCaJDCBYaytuSAVYqNL6B1m7Ln6xtzB+03vTTJ
	51U/aWmdi1nyilZRRe9XybDcvRpFxI+Ud4c7kFS+wcbr1zoHgJycn4M9SZ2tz1J9J+5Ltda/kNu
	3h9ja5cpbJyJJQWFz5Dm14KLFtY8
X-Received: by 2002:a05:6000:43d4:10b0:48c:77e3:6c8e with SMTP id ffacd0b85a97d-48e3eba1660mr15009254f8f.49.1793109227175;
        Tue, 27 Oct 2026 06:53:47 -0700 (PDT)
Received: from ingenieria31.oficinasStQ.local ([79.117.46.175])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebcb846sm23128058f8f.25.2026.10.27.06.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 06:53:46 -0700 (PDT)
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
	devicetree@vger.kernel.org,
	linux-efi@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-embedded@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 01/15] drm/clients: Kconfig: indent DRM_CLIENT_DEFAULT with tabs
Date: Tue, 27 Oct 2026 14:53:28 +0100
Message-Id: <20261027135342.2003632-2-maximpedraza@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261027135342.2003632-1-maximpedraza@gmail.com>
References: <20261027135342.2003632-1-maximpedraza@gmail.com>
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

The body of DRM_CLIENT_DEFAULT is indented with spaces, unlike every
other entry in the file. Use tabs, so that the next client added to the
list does not have to pick one or the other.

No functional change.

Assisted-by: Claude:claude-opus-5-5
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Màxim Pedraza Padilla <maximpedraza@gmail.com>
---
 drivers/gpu/drm/clients/Kconfig | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/clients/Kconfig b/drivers/gpu/drm/clients/Kconfig
index 6096c623d9d5..8d8bc37ec9f2 100644
--- a/drivers/gpu/drm/clients/Kconfig
+++ b/drivers/gpu/drm/clients/Kconfig
@@ -114,10 +114,10 @@ config DRM_CLIENT_DEFAULT_LOG
 endchoice
 
 config DRM_CLIENT_DEFAULT
-       string
-       depends on DRM_CLIENT
-       default "fbdev" if DRM_CLIENT_DEFAULT_FBDEV
-       default "log" if DRM_CLIENT_DEFAULT_LOG
-       default ""
+	string
+	depends on DRM_CLIENT
+	default "fbdev" if DRM_CLIENT_DEFAULT_FBDEV
+	default "log" if DRM_CLIENT_DEFAULT_LOG
+	default ""
 
 endmenu
-- 
2.39.5

