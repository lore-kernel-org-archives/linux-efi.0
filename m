Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792536623;
	b=gvbYtFV0ZUHM5ycKBnkopIQk/lWNNcYuvkqQsstlv3lXfG3kbkY5nZpiA1y449GX4Id7
	 tYsl8D7mI5opj4ILU1S3c5icv9fnUUZx/kBo6om55HeHJJSljDxhBtp/+JPsa18sbfHXg
	 Glf4vCkKOjw6Q5jTZaqtzD15zrCkCRUyCUDtmKYkfHwSNot99kejdGqgPQs6UVl0Bg7ta
	 /ZzEXf6oTSpkTxJKQ8Zu83VebfNmcfCP9WzLCgVGZV/Z3fFcZ/H0Ny28qf31vKcjFsUfW
	 1YtNlJELPYClwKfeq5AZdHh7pE7iIMCACJLIhaLEReHrbrcKfwx9sP4hrfsfLhtFQug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792536623;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=s0sFZviiuD58KoKuefE1C//igVvTgzZQdIYejlrorjA=;
	b=szWzdV0aB+uUNfy9eBsc1kFKxW6pQtCs2npPbRvwwaPNF3+1CEvtGLIO8lXAK1WnvECA
	 DfL95+Sk9JatU+t++4TteYLPlW6NT/gOGLyKlz4VNwS+u4dG7GZO6UDRQQHyT50m+KbIt
	 v3Qp4HA8ZrRJHVUqujf5ifw159TxC/Avbzx6rc6/wlqSjS7U3D1x7DqZWouZ5FhkceGs5
	 oKVaR1ROhqUtgoaaXFXlZ48g3mp0pioyEkBwFkcI726QvocEQWs2aNZlmSFJ3Po3bDbEz
	 +B28BQdDwHCbbku7+gKUyk4wCy8VSmSIiNoo+yTlH0krAKf2b3PbEmUoDD8mhaidNGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=fuL01yBC;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C40F60A3828
	for <linux-efi@vger.kernel.org>; Tue, 20 Oct 2026 22:50:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C40F60A3828
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=fuL01yBC
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a1dede3c2cso1064685e9.2
        for <linux-efi@vger.kernel.org>; Tue, 20 Oct 2026 15:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792536622; x=1793141422; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=s0sFZviiuD58KoKuefE1C//igVvTgzZQdIYejlrorjA=;
        b=fuL01yBCCOgff8Fcjtg40uzwGWns4yu2K79aOgLmuvLPTIqIq6xfOwGY+eNrV9NxYB
         NuLHXc6OKmZrjivF7l9UL8tnxGToPClQgFvUmKZMSX9ccJDpurVRWobpNkBCtnmcNdUB
         aQBh1L8VU/HjBgiGcJVCFs8z60tJMgw0CIfCS3TebzUjoMpedcSRCxPnL46oPTfekM/r
         EAtK3JGq6+2HquC1sETYjEiKdU2nyybu/oRxBP5t5d+kfuC6EVRuAOXmVBxFkmGmxVXv
         ZKdQvz79m7F99pOrPsWabv9/wRorRrzeQu6l+DP8GgJvbkNo/joMAomOB14jA7mMTEOo
         rlPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792536622; x=1793141422;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s0sFZviiuD58KoKuefE1C//igVvTgzZQdIYejlrorjA=;
        b=Q6NTg1go+nsxwwZw1I3yIT/RYFl4o3BvY7Gxz7fGTPYtEw+eRsNYN2WkzA4vvoCk5g
         UVpANUSISJz2Y+JtCTXAO3PCxbfuLUug00z6VfZILewo2dWH2zMgtOGmnepYq/7W63Zk
         FMsswazbqtnvOd1Z/JDjDhyd40f+95JoLbBRor9WiVioQHH8WxxXGL+LG9MRQk35mEII
         2FQJKSoOCeGxiNvTSThyKtibjlijEFpubHuZsbpOQevOhmNP3/8JySVWCR6hJr36NWeE
         8rF2aT6jGLP9d2kAUNvp90KwUWGDOfBZ67X04amxFDrvneJmQGl2gemg2vED0IxyMC6e
         rCvw==
X-Forwarded-Encrypted: i=1; AKwUvBxNMwrnHFfB7zBR2OBupiGYeZo83W4VxRvlJXcu5j5TGEZKro0c0Rhw7iFwZ3EJlb9KLsCn5lATQjc=@vger.kernel.org
X-Gm-Message-State: AFq9FYK2DJ7kLR9xyVrypX2AD+ecVu0DNHaiWUTwvSsUm6ydGghH5Hpi
	tzr0vWQjLf/nBapvo9acH74zqiISkdVPm1Q9DBYMGroflwL6MIw2I7Oy
X-Gm-Gg: AYBFou3ayTtelYj3Ax4LniHusQg5FjqliLs7GWMFUmC8CrYA1px/qbRiBiBeUUTwbmz
	G9DJZMa3c+vw88u49Zj6lgH0htUqXn8noLVw+G9BsnyY5YGPjWfQjVEYBXKcjc9WnECZjQ2b7Wn
	lFT8YFd4G9DQgKG9Ox9NpF/XuJK33MHDfSC3eUZOsI5U8+q8wk/juHD7IaEO2ISzKuuWGUXQmsi
	hW8NOIoFU5lXErgnw+VXdCM7pQyKYhpUyj9dQF2AeG7u8QhEanYqwEgmQiDYDjpzRg4xTxPUqHq
	72/asPxc4jgRuGBkYTj54RCttPjj4GHIbbFP7tyRjGd1KCR+H5+Su6oWh0zlqd6S2xti4IHdt4v
	87VHxeYPoOTc7U88V8EpPy7Lum97VSJjnx/f4rpC7mHK/BlI2THwuF1lcObBSf/N3c9fCa7TFHT
	r21WNmGP4jfPT4p2f2XQ2VfPkM5VoFubb9sgn1pllMJ6CnRapVEIaMmRI/dFqcW46sshuLkw5xj
	OxbDD1y/PFCe6/2u8KxT3k5
X-Received: by 2002:a05:600d:8646:20b0:49f:bd3c:bc24 with SMTP id 5b1f17b1804b1-4a1fdd5b101mr1644285e9.31.1792536621644;
        Tue, 20 Oct 2026 15:50:21 -0700 (PDT)
Received: from ingenieria31.oficinasStQ.local ([79.117.46.175])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1fc0b42bdsm17511805e9.0.2026.10.20.15.50.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 15:50:21 -0700 (PDT)
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
Subject: Re: [PATCH v5 12/13] drm/client: splash: prefer what the command line asks for
Date: Wed, 21 Oct 2026 02:50:06 +0200
Message-Id: <20261021005006.2341200-7-maximpedraza@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <45b55f94-0cd2-425b-b985-ba3958502b06@suse.de>
References: <20261013093243.505776-1-maximpedraza@gmail.com> <20261013093243.505776-13-maximpedraza@gmail.com> <45b55f94-0cd2-425b-b985-ba3958502b06@suse.de>
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

Am 20.10.26 um 13:26 schrieb Thomas Zimmermann:
> Please see my earlier comments on module parameters.

Same here: my reasons for keeping these are in my reply on patch 3. If
the command line is not wanted, this patch goes away in v6.

Best regards,
Màxim
