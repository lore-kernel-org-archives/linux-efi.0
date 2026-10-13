Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3C23D8100
	for <linux-efi@vger.kernel.org>; Tue, 13 Oct 2026 09:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791883982; cv=none; b=aCjzMVIgXX+0eKTsNvMZNBTTjsnChQXeCXy0Ij+lPoONxJaZWkw2osoPjtAmaBnVh9mugLP41oG9sDFkCnOrErXNgroiHKkybwYqTEJ+81rHMqZVXOzDi/T1zx6l+YQVqa1D422COUgP8RuX4BdBvIncaGFWLCfxwLsuTEFWFEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791883982; c=relaxed/simple;
	bh=aRtwvMv9yIklUEfwA2tgF7gNewrgncEQ/GN8vn8QiY4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l34mfljgQydi9U9Owsh0H4H8JSWu5xvx5mvZSSJ2f5g5YSEw6vCiyCb7DLEonqqb+vmSzTXy6bkKTEX2IXMc6TQbhfpqmpAEEfXYF2VmL0uHRTXXkihb8ZafPjEHE8Ge5RRDXjxUiS3emr5jTx6ay0g1/DlNfBRqQ1CnHG6WEcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=r83duQ7n; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r83duQ7n"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48c02782159so1645648f8f.0
        for <linux-efi@vger.kernel.org>; Tue, 13 Oct 2026 02:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791883978; x=1792488778; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6FMp4bmsFYk3mzSCH1/ElOs2cwgfyNFSJhXfclhOUCc=;
        b=r83duQ7nXCBb1NxgMViTUYQnb/tZDDGslK4TR5GAYdQxkBIPuLZNmr5Z166cduMhx0
         2VUQCwLEbbuJ6RSNG50hn3BZ60PZmFOcs9+Fh7PQEqS+tq+ow54LyDJE/J8hxjz3RTIa
         9Vk56WZKCvpihlA/fyZ1ZUYXQqIck02WKZDlUhjyV1VF2kcWZgt0lkKUtWbeCGhf/4Z3
         QJJqkUXHLJcELfmudn2bOKjvkKLOndN3/Uzl+m1YAXMvTaOU60JTtqill6b2LVgBU3Kf
         343TU7z3DQa6zu+u8474OAY6oZpI6GDJU12nGIsEntUZnGXDxbocZcoFJC042EryN4PH
         iu/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791883978; x=1792488778;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6FMp4bmsFYk3mzSCH1/ElOs2cwgfyNFSJhXfclhOUCc=;
        b=ucZtKN6w9PXwydOIqUmfRvdAR9MMHjy4A2JXbcHV4e9ee6J/3lpJpMk8xAs3YPCkFP
         qg5UIj45b6l61PbX9HZFEbHXjO+c7w/1wNt+uZnxB+g5ap9l52zsciQOpNPgg0gOCgZN
         Vr7WuOn0YEQ929ZmYTeeUPj8VfAm78MLTUFBYmnZj7rgJZXLjWtEQWwIG6BP86Glx6fc
         AtSM32UlkG/3UutlUuhzMvCvhk5PgfpZAURExsrfsohf63mzxKmhjBOQdCxGoJT4D01m
         pvMdxmXLmMNRHnSV4MX+bA71U3+Fg6q26hYuFnVdHkIDg1bG09V+BRYd1QxS1DrfGXNt
         z5Tw==
X-Forwarded-Encrypted: i=1; AKwUvBxrTtJHdiU4oIxOxmciqsGdgqw2jTmWi+hkd0X6j7pquLbAmx/dipKVgF/typ9m2hH7Er+ebNcGpzo=@vger.kernel.org
X-Gm-Message-State: AFq9FYIIk0Y5IxW7N5ZIuZXmX46EMTOK686h8mA3l3TuUmCoFkvVE5jF
	GPRnsJPFWE2cOT/NHxErDTNLMWdpN64ND+IJnFn4eIBr5fC3P0rChgvK
X-Gm-Gg: AYBFou0ZRvRzhjLSS75iM+TgXdXaKPVZBM/W1UIKp6AoskUq5clwbkxVl3c3hLZVKia
	WTc5RSGDKaQWg4WvtKb8p3ADVgbJ4cWnWzcH7hAVKGeZqjIrZenEYxeZNGV7Ah6f40geZVxiTr5
	LTWMXo5bL7u+ScxqxQJ+9Udwb3LW7aY/rJnsr4PxOmthcKfT2unA8Z5A+xQA5WjeuAKso9HHhCU
	k6jkCj9cinewVaD7jpzyVxFxdH8UdIq0zlPSbT8pYYpOb3So8jT+mErH94Eu8ZLdNUkSR3i0Ren
	PQ0R0m3BoYbDKBtiJGIHp4d7XciOJAmwjjPa+H4KnuUcPTFNoWJFaEjHbfHfQLVAJRQuwTp1F0J
	CzWN5xwEcHEQEiocBLfm0BTm11/Z9K7rnMeX5vsygasqc0Y7dDRcwDBHP7VEbDRckYcUBWbUh5L
	cUpydQdj2c6y+YT/b4iMrWl7tIhBSIwVEcyQrGU5uakmM/8FvCrsKrvRl/RuPJd6ehGMDDO9JzJ
	0QeRemFHoHofGkK1LupjMkO
X-Received: by 2002:a05:6000:4313:b0:48c:77e3:6c8e with SMTP id ffacd0b85a97d-48dbacf4700mr22504037f8f.49.1791883978432;
        Tue, 13 Oct 2026 02:32:58 -0700 (PDT)
Received: from ingenieria31.oficinasStQ.local ([79.112.15.218])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0bc4ec6sm3986774f8f.48.2026.10.13.02.32.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 02:32:58 -0700 (PDT)
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
Subject: [PATCH v5 04/13] MAINTAINERS: add entry for DRM splash client
Date: Tue, 13 Oct 2026 11:32:34 +0200
Message-Id: <20261013093243.505776-5-maximpedraza@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261013093243.505776-1-maximpedraza@gmail.com>
References: <20261013093243.505776-1-maximpedraza@gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Francesco Valla <francesco@valla.it>

Add myself as maintainer for the DRM splash client.

Signed-off-by: Francesco Valla <francesco@valla.it>
[Màxim: add myself as co-maintainer]
Signed-off-by: Màxim Pedraza Padilla <maximpedraza@gmail.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index a08087fb6e67..321ecb9f5b5b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9168,6 +9168,14 @@ F:	Documentation/gpu/drm-ras.rst
 F:	drivers/gpu/drm/drm_ras*
 F:	include/drm/drm_ras*
 
+DRM SPLASH
+M:	Francesco Valla <francesco@valla.it>
+M:	Màxim Pedraza Padilla <maximpedraza@gmail.com>
+L:	dri-devel@lists.freedesktop.org
+S:	Maintained
+T:	git https://gitlab.freedesktop.org/drm/misc/kernel.git
+F:	drivers/gpu/drm/clients/drm_splash.c
+
 DRM TTM SUBSYSTEM
 M:	Natalie Vock <nat@pixelcluster.dev>
 M:	Arun Pravin <arunpravin.paneerselvam@amd.com>
-- 
2.39.5

