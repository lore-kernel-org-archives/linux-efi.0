Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793109242;
	b=ZV/SqwnyY+gArZPiUf5/+vdFTC4Bdyet/GKtlnFPLLe0MwqSRsMERuhaych35ayYoiap
	 MaHrhAifigCwH1awoK7QASiMFLYFbkt/eRIHvAybzPT2s5zTdtE8QJPzfu48m03U9TWZZ
	 4fHF/WBMzjt4vahcBmF9h0IbiZdl2ZM+70wU1w5VLxm49ruRWKEpAxFHZorh8Vm4tf2r7
	 VKsUrAA474kJYrYyNxBEvsJbewdje5pzL4T3UyTWopt+e4PXewbO4xMF+zf6Y0WAOyKUe
	 hTipaSppIDb5EaG3vLEWHvbMtIh7bYrN1cU9slA+rLODN1LibarBAwAwYZIsPQCPWeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793109242;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=udMEtEpdximcj4tmN6XEoXZYcbf6JGtTIKRmg964qrM=;
	b=uoT/pIn1QhNuoT6vmIB+HV0adzsETK9ndRarJvTmXuhxQqwrvq2L1CSQNEVuGBDQ+AIK
	 ZmMRPtFh/x2gs5pcWWvRkQW/+ECO/OTUep6eC2c0bgaEDgHE3BsTuGNYYEWcIDNWT4hxR
	 2K3qzn5w0TEzwsjFe41UQhs0RPdAszoL/zLIrcTlDPHXN7GFp0pJ2FjtxJTegypRgf6eO
	 n+ZfRyqcGrhOkHaL7tyNs1laj/+xNHshwkQItemzKBSM7K50mwVXxVJ7Yud18Dva4nAjX
	 bwIxoT4NBQB/BqWaZNKSnRHctp2lf4PfDnV3N1N9a+jZacXo3e9U5hYI93Vyf64kp4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oimiZnio;
	arc=none smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AC360A260B
	for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 13:54:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A0AC360A260B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oimiZnio
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48af4d4e61fso2666250f8f.2
        for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 06:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793109240; x=1793714040; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=udMEtEpdximcj4tmN6XEoXZYcbf6JGtTIKRmg964qrM=;
        b=oimiZnioitMUEnEBSrenFhRbAKwenXYmVyqgKmWsRYCXK/JKGbsa6e1hchO+K8E4AP
         aKqtDi+/aJJxJ/ZpulCQo0A0FFLFB/P4ruAZvVuMg/2UK5Qi5nmFDuEhOUZtyGtwcLe2
         Cy+j4nHDSbUeCVSFCVw+TcY43hi62SLj4fCqzF/nem7rtyWJ28BtO6lO/RiZua4Xss0f
         IIxPsaHdtd5IKWoq+iFATJQSwz14z2HjyaC167tn5z93TbWRuy2QukEXN6vuiDh6h7kH
         IjmyOEcbEQ6slNZxbs92lcTHtMkLRShklgeyiQ3bXndapKr3p3emUgxr1TirGAYeVUY0
         6x/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793109240; x=1793714040;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=udMEtEpdximcj4tmN6XEoXZYcbf6JGtTIKRmg964qrM=;
        b=kunmR75mS4lNxWA/Pl3fymdzGxnUqaZBh10AiDWAkVl3ad3ciCXVyFhPvkNNucgUzC
         0AaPE/BrdB7Zk0hDcjatpmexMfahQxrpd1O95GDZYOpqUbPUi6udw2I8ni2k9vO5/efW
         mf4owowFj9+Vh4jtFA7mHmEpmzs+CAvU651gJyMh44z9+GL42Ayy4Q4BuxsDDuGQJs2L
         puJRdqhBsyUbghpJj5Itni+L0xW4rr2ifu4lTY3jIKIzWVUyLOAQDpX3dPLSV+tbAxwB
         60Julme8C2c0nUhfQGm2svHY5LrFQ3JhJjBW/982eRLBNpwr8MPN8Wnnj4HbkDLRrKco
         cepQ==
X-Forwarded-Encrypted: i=1; AKwUvBx8S5Lyc+JO7uCO1NBO48l6JAVIGthqbGBcTUnMyk++Ln25OYwthTMZalJ0EkPW8qeCjdZhwrgy/AU=@vger.kernel.org
X-Gm-Message-State: AFq9FYJi+ug+5MwfHZjm0oQ8Rl25TY5ew062ZlOKPQ98L0xZNuDvwgKx
	Z4BNnzKd8wDiqym1oZHytUIn3oDJ9cdlXCWGtP2kEJwq9nKdFeBrh8VA
X-Gm-Gg: AYBFou34f3VEKlUWmJMI+Vz2jpRieQ2swIrV8lRzdaPHUsVvoY24Vw+gD4NFutXegVw
	BIKnSQxe3IchR8/wZUfx1+juMr5NYGm+Vw6IqzCXvwyn3xzF51+xLN/I6+5qp2+ApeP/vabY6DP
	CIII9ZwFZ/hzEKy48FJKQsRdkrsNGzMcLmdAeKir3me5E3d+SR7Vgggr5A2qLoKcmbmjniOSg+E
	fdPbqQRPjKBmWOcDEyCO0EAlxjgPmtU1f3wXrqyUD6zzx8o3KP42VuCIAZVhTpV9y9n/IfWPQsw
	eMrQTtIPSqdE/5zyB+/GphRRIOMCM9JzTQfypCbSGvc3NWzm8x4hfnK9dSpj+F7eFD+8UbutIbf
	jxC1admet5Kxknk29bmlY0V0J3LcmjM84E0QM8k1+2Ro5RP+vMsAsdstfFirniPPHLB9qQHFovH
	NRnyv4O8fuS+HLQdrfIfettQsu8urL+VidgXLETYxpMWIkzE3nKCaFEhlb4AG6wQIP7FMmh5fVQ
	r1ybKDfTkm5aNGDV+e1g+FqDaqcWX8gT1fzIH39Tj2e6fXbNKgItofv54QeN1TV9eZqToVzH5JE
	MklUHJoGPJ6Yt8k5itPybDZylBpA
X-Received: by 2002:a5d:5e8a:0:b0:48d:f56d:be56 with SMTP id ffacd0b85a97d-48e3eb7642cmr19483905f8f.13.1793109240024;
        Tue, 27 Oct 2026 06:54:00 -0700 (PDT)
Received: from ingenieria31.oficinasStQ.local ([79.117.46.175])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebcb846sm23128058f8f.25.2026.10.27.06.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 06:53:59 -0700 (PDT)
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
Subject: [PATCH v6 06/15] drm: docs: remove bootsplash from TODO
Date: Tue, 27 Oct 2026 14:53:33 +0100
Message-Id: <20261027135342.2003632-7-maximpedraza@gmail.com>
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

Now that a splash client exists, remove the bootsplash task from the
TODO list for the DRM subsystem.

Signed-off-by: Francesco Valla <francesco@valla.it>
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

