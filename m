Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794784926;
	b=bKGZsSmksUWJ1EtiegH+k8BGk8lTRuJUl6/ToGY5Wz0G5UwAu7UdzJry+JQGYmMBGi4n
	 2W/63bizyQn1DyraOGiu7ic5AMiLNuA3gRqFB8J0ltkvNvldW8XZqKZkflHbk0gpRSPLr
	 GdGLc0Xy/t1VeWAvFBBoyk8aXAem26V20bGTxZG5lFaEHwMuKO3ZMQfANnmRiO8o8QCyR
	 nxLMnTdsgPfKYpf0N66G2UM7OzpvAFiryXAjuP2309SLIXBIWoNhm4jz0rs20MQxrxH7M
	 pO/VFRB8LSDRnwYvluzlKz0pJoO7CZFTdVRqfDBQdGozsxaHnzN2EOmiYNNHJ7GK1sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794784926;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=2M6HoHkTeVcJIWfMAzqJ94aeV/R3TSw3Z3JZl8kxSXI=;
	b=MtIdh8BKarcfgpS3co60mFNAvYnQ3VEVcBANPTksstd/sMU4qLYuBKue/bhJVMFmRCj8
	 r17+2rqYZgWCQFgpHSyVBNfAGcNXEYsXX73YfBKsy1GKKQqo1oFWS1fSqwikTFII5uG4i
	 RnqeQZWRi2D+WXwM7vJLqzGeIc4TptB3/uwQEi1rVk2eG+B8y6dUXPXHDvI0JFXTv1XYG
	 3GNWZrW+X1dEk7bqUzGa5/VwILQQcZ4Wrs+Zk7iBGKI70iVhIneVGOXXJQbIa+ujVWS8X
	 NwVTfRhc5PEAzG6lIo5KLDu3HIjruZkoFMajFfHLd9XHNPBNaVC6nCzDtwMyqZmdImA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ASbX8W3B;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100BD606A889
	for <linux-efi@vger.kernel.org>; Sun, 15 Nov 2026 23:22:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 100BD606A889
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ASbX8W3B
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a35d5d4a20so36361445e9.2
        for <linux-efi@vger.kernel.org>; Sun, 15 Nov 2026 15:22:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794784924; x=1795389724; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2M6HoHkTeVcJIWfMAzqJ94aeV/R3TSw3Z3JZl8kxSXI=;
        b=ASbX8W3ByAyt5NTODXjPhDEF/llLXL3T+KSc4VFkXSFgOapFIsx89vR4EdHZKzpZ0d
         9OM0B6CkzCWrddXddFfz01PXzxCoLgXIaBSau/cqNSaG/CksiioPlexZ00OVV9do2ufn
         16+eH+ODzHnZBHfhjCxkG7ZJOv2pbKYZ1BXXuP2CqJh+nz+aI2HpkBudQNFKQX1ILj0g
         S78ThpG5NCzY5IsLhI7Mlr+GrpbtjobJHvFRpPTSwjND4M78iyD+2cqOZBLJGEhz23sr
         oZwZWmS23kYNaRtQX44IMSquUhVG6e15QCQOy4AfKBDm+rsn0onfwkmRoyd26KDKjpwt
         a2Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794784924; x=1795389724;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2M6HoHkTeVcJIWfMAzqJ94aeV/R3TSw3Z3JZl8kxSXI=;
        b=VHj3kQiMJPS+eKVHd6mpETL5FcbM8B5lJN19Uv7u668nMuT5RJrfZda5jHMuTeVnt1
         sOBYZOw0JS1kDXnRp54wzqan/53qBqlNusEdK3kZzXgGeHpTGVxklwoFWGD6sCmXaxfg
         7MqzV1BCTlAWvr2Uu7plGUqud5RppayzwSAfur2k5zqJVR1x+yHml9u1y7CiKJU+T1ZJ
         eQzGGAqCObVinOAwMSamh0LZVLqpKtpAYQwLvel3X0sU7lTywOimf9YCxMak3q9RCddM
         hAHTHv+o7JL2Cz+uDvGd/dl7YViBBBZ06aqfYuvEjuKChYRfDuaRSlHLspdK4ijiDtTA
         SBBQ==
X-Forwarded-Encrypted: i=1; AL+hErFJZMdU/20Pdn+PAfJgqe0E9piQ6BsIypdYmaIbkdsVC/IJG6mFPivZBF7YscqFy9HMtI6i8oPT090=@vger.kernel.org
X-Gm-Message-State: APuU4Z++Nc3RwUJGLgHfQ4JTT+Xyv/KkE2sZ1X7vM11JI191vshjwQOT
	RTcU0AOT4jJ8t9BEjEQPX8iMC94Zv1ZkXXLZpZuepVJi2mDfL/sE06qx
X-Gm-Gg: AYBFou2S+5xzPEjHC+s4ipBdsLim19uQHQFMOLq4apRDfDMtGMtIC1uZDblolgeP1fl
	9+86EYbXA8NdUvTvkclghSAeZLRve0Jelh3qNC3Khjt7JS4YYuq9ulzfSWTOHzgy1kKvcR5HN+i
	ecSKYn/Dh63EhsOuSirxHiBbA/pxT/NqdkyfiX4LKhvGy/NpL5SVph3G44urjEvKbEEbV3AEluR
	P/8UD29wb1qKvC57krjLbpCYJZB5ffhgkoBqBYB55jj1ux3DA0O93D+v7Wp8VKRdh/bTSLEg3uk
	gpfO8H2VvSBaR3VFbRl/EPA2g5Aay1vsi9PiGsA44b9UAFQv1K3KHLBat0Gnjwi6F8SEjQv3jEr
	+nz/yi9yZwbZZnDoFH5p6+9J8w165RlgZCu99OJ2eQjXhkuoKeD4qylARs/uwwKGPyG2g5u4TFZ
	wtEj3TjYtyMJaBCnfUVx4BEw6eqJZVUr9XluW33ZICovDp2RKM4AuRTaKSu2jKfWf3SyOCahBLR
	Wj/z4Ej+YKKOGnkJB5gNuI7I/6YAWlX+3kIrNSyYxPiDb8acWktVb7urA3B/7In6IJ6PG4shmzw
	MkitfyJm/1/iIphqySh1aarSSgN8P53iNmnxMYBpAbF6z6Zv76s9TrE=
X-Received: by 2002:a05:600c:482:b0:4a5:75d2:c104 with SMTP id 5b1f17b1804b1-4bb55a59c9dmr137490185e9.22.1794784924398;
        Sun, 15 Nov 2026 15:22:04 -0800 (PST)
Received: from ingenieria31.oficinasStQ.local ([79.117.0.220])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb571f976esm127920955e9.3.2026.11.15.15.22.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 15:22:04 -0800 (PST)
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
Subject: [PATCH v7 1/6] drm/clients: Kconfig: indent DRM_CLIENT_DEFAULT with tabs
Date: Mon, 16 Nov 2026 01:21:51 +0100
Message-Id: <20261116002156.1027726-2-maximpedraza@gmail.com>
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

The body of DRM_CLIENT_DEFAULT is indented with spaces, unlike every
other entry in the file. Use tabs, so that the next client added to the
list does not have to pick one or the other.

No functional change.

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

