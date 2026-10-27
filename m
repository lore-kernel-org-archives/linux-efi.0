Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793109240;
	b=I9yDBtLjN4HuonaE0PhZKAddikFjKEHQgzFRnyVD0I/JHpj/3SOhwqRYJhQZ5zZxOwcl
	 zA4ezF1SAT4Pw5IFzSrRUpQJv9yslbd++8suDNUdTDkUqmKKcQa4fFhusDJV9Fng30iTh
	 tcxEkjiQUnxPNRVlUtG1HT4tevazTqk9yjqbFQeQy+3QFEesgAxV6xsQ9dD3mLXGsj2U7
	 L3b9z9vjb3Gh4ymHI0NXkZCQelc7GpfG2pySfM4L1IDQg3wrcG/IN2R/B5YHoohUQOqO7
	 0UyzDFNmQygXEYcYWjVVzRTPReCfRh6GLAv+jyJeqdzWSmr3WhI9w8a4SvOh6tgFjvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793109240;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=6FMp4bmsFYk3mzSCH1/ElOs2cwgfyNFSJhXfclhOUCc=;
	b=wJmXdFdzuTbYvdWpHvdqNIxmxl5pCVRKLHhBVnXq4kuXHQDFv3vIlNGnVFRSgLtKjNYJ
	 c/WSJ4pvkKtuh0e6AgQuPPNtk+zu3m+fe2tf7GHEhoknmn5AOtBvgZ/LkNaaMjtZvIh+5
	 MvuQdEoR5XqaoQv6C7i3wVH64k8TrOi3xUPxybNL9XN+rV1cmFlNZQHFkzHJJqi2SDKay
	 ophU4Q4tEe8+oItmaTFmOhsFhSfrcK4bXcnKNrWfGUs32gGSvJXrqBqAGsbf21dFN2UKd
	 4AooL1GNVCE5l8Xz4sUr8cDnF0ybzRSAELm2fgByOCcVXC1rh0svDPpJ2SIzFgSn/Qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EBF0TdNK;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5C9606A337
	for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 13:53:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF5C9606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EBF0TdNK
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a7992e2f7dso11259935e9.3
        for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 06:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793109238; x=1793714038; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6FMp4bmsFYk3mzSCH1/ElOs2cwgfyNFSJhXfclhOUCc=;
        b=EBF0TdNKiZev92JTXZUKMNM+bikjTpnl6F+xtg1lO25YQMK6ahE6FtSlVFxjBHIfIJ
         2tDrWqG50yvBgr1XKRETOm6kWMHgVeuJM7lBibOyLXXDYgMKX1OPJwSjhZhLALr5KYEc
         Q1SCgLNw6BDYwmvXk5af0SJUgK8tAcDbAMVyUsW6eeK4lI9ZJ/zeaLnLSL3QXyaOHP9c
         3LAIk0jo9oQzD/MXMTG9cVzn0VCwjdkQ/RQrhNaRSRhrf7RTxJJ4NNApmMPopv82MM0Q
         ZP99MlLYSNoqXjI22Xh68F20Jf0avL8oolZjogdrqlkKurBxko1tjvuPerYh9ooefJAS
         w38w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793109238; x=1793714038;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6FMp4bmsFYk3mzSCH1/ElOs2cwgfyNFSJhXfclhOUCc=;
        b=FHhIIZhN2VC59IL8EkRf82yq1ar2z1pVYJkToYW6CQdZUFEWd/nC5USSnpARJ1cOok
         gb9Re4F3U2zTE8o9pvNJ/gtUU0sVAyQ+sbDPGy7RiV225sA9HezOArGsPskEKE182+ka
         avWnF2GnzLBI1P1i6b7nldbfsqkrEfQTTcF9KlCKxY4CO+LX+J5FW0G2duB+TyiPITC8
         h3DzHMBxkg3I9N6uLt+Vv/7h+jlXUsyMEfQnybHmfis4pKcnBtjwQwG9gjigmRSde6+E
         jWQ7CYF1mpI+BzkUJEyApQ6B/Ddeiir5V5bXqhKmNTYALdYLW9DT3/ePLFM+SaB+H5uh
         b35A==
X-Forwarded-Encrypted: i=1; AKwUvBxE5hMXUwAxRUXUqP+MpVKh/xAa6EwpRvwRjaqoVXuqquMSuq/P3bzwSQfl8j45c5F/hqky0TidUV8=@vger.kernel.org
X-Gm-Message-State: AFq9FYJ8qScHIunUptwo3XGvCtx1AAshVmCuAF0s/T6F/5nWLYypSVSX
	4N/b+6rcOF/2y9nkFqSftz/Fzi38uveI+XzXh3yhdNbarNFN7zFDUR/P
X-Gm-Gg: AYBFou1iuzHw2FTcdnZjze+byjtVBTpJ50yIPVAOaxOvtB1vAjZahov8k16acVIBg2L
	es5ovJx+cDP1TN5eQxY8HGH3J8eCh2JcSMajGhaTJI2ooEauRKAr3KMZm+OIXR1pV4Xw3vlh+eJ
	ekR/QqHp7LWZ9MqXDbVyn6niWLw1VGmkipM80eBa7OOErPcdhMG5qlzrV7rpOnRIlCG2d1JWywc
	Ts1UcewskVQH4gpQ4x5Ybbpzn8w6+U6GvXjhJXZsDElBp1P1mCLLIjrISaX/cf9y8qUP9bhXbK2
	eJf6mLWVF8fyuYI3bjC7MKRBPVcrx3x83GEnvpLstWjalyZRYK3m2nzDO1BHhqjMknVp4Z+NFmp
	mKgtKv4TCeDbfmWhRgYj4xPZpqyd158YMofu1M9XjafDOP4z6UCfpVwJiXRrVZ83AFCe7F1g8uG
	YPrCzhIHCXxqLbeKuOxZWLD5VNS8UGajvaI4t3k4bqQHaw3/n939tlrKUY+Qih8z0oLDMDee9nm
	QZNf9OsFG6eOiNrkz2fWNlEQvUURWxSFKbxWN+IIgP0gSDFYf/ryXypGBhjhnfdlHXA81NXDLvO
	TIJ/PQA=
X-Received: by 2002:a05:600c:524c:b0:4a0:1c94:7042 with SMTP id 5b1f17b1804b1-4a35ac8bdc6mr188823805e9.8.1793109237982;
        Tue, 27 Oct 2026 06:53:57 -0700 (PDT)
Received: from ingenieria31.oficinasStQ.local ([79.117.46.175])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebcb846sm23128058f8f.25.2026.10.27.06.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 06:53:57 -0700 (PDT)
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
Subject: [PATCH v6 05/15] MAINTAINERS: add entry for DRM splash client
Date: Tue, 27 Oct 2026 14:53:32 +0100
Message-Id: <20261027135342.2003632-6-maximpedraza@gmail.com>
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

