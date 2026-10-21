Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792536612;
	b=bmaPZzApRhbMOJaLixh6Sh8HFSZAWrZ3/fu6HOzUtQ3Hzz4J71Ea6xnIos59rKW/iWBg
	 VCeHrWdnMZwGi9Mzi2CFOaJVGbrr2CmC7hryIm/UxWILS1rmfjbcL1Jg/K3Eci8g/wjUm
	 BnOPZJ2pZj7YaZ3BClW5ihG2DBaCShATtbSSWPAXRsTVfbl9bW1jX6aNZGEtTHCCpNFEg
	 dHlrUO40HZkFF+NScPF+KfzEunEeBzQ9pCUXUmA9KFYZ5DOG451rlXtRRWPkMf4b4W9kG
	 ek1Dz8jceXmy782hejnmvsBCJZNiyISqlpZn8hJJMlPfH3AqLsfNeWrs9s93B1IplxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792536612;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=fTuhXEhm4uQNNaPcVdFpwpAupMps3PVyoq78rLHpKEo=;
	b=GKMxWBXT0ZFFnndq3fd5VxWiASS8CkJ9AO5wqyvLLvfli2ki4SIwQJQB0oCIgtctJ9p/
	 t6lI3XofQqrrBw+gOjF6lP4PCh8UrnnIk2+s1wE+jdAaaG12CeV1pb7KfkU6o0A6vto1v
	 i6j33Jtjr2tbEPX/qm/6ZMw6lfWpa7P308esUMNvqbhZaUDWBIOsf/WwnpcxShi76ed6i
	 imSRNBNUs6/3nYCD+LNJ6x9oCJIQB64AkePY4SY+451CGl2H7tYuq/BmwTc1f7VERg7Xk
	 DXg5ERpErSUMb+k+EfQw5WJhE69Sm8obhG+mbEH24w38FpMIotiytTa2EOgPNnH+9Zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=oMGtStFf;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF42606A31D
	for <linux-efi@vger.kernel.org>; Tue, 20 Oct 2026 22:50:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9FF42606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=oMGtStFf
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a018dc1f98so715605e9.3
        for <linux-efi@vger.kernel.org>; Tue, 20 Oct 2026 15:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792536610; x=1793141410; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fTuhXEhm4uQNNaPcVdFpwpAupMps3PVyoq78rLHpKEo=;
        b=oMGtStFfhGsL+mBjIIOXSVYiVGOUixhfa02bRsi991TkgCyk0GIcCTt75OwAWONrt3
         XyxUVpHQ6hS5K1bIte6yGRRfPJrwKq/BdNHY4/MKwW98pomtO8eR32TcUmg5eRs3vT0j
         4vfj4Qati0/E+qbSKz2TDX3+AUdBzroKUb9HFKxqMw8GIyTxIZfMV18nnUmzSg5hXoWw
         By4JWTOxBRV/qp54N78Use+YIBtMTyBYI2FcGlVPxD5AjWw10AE1hZ7OeZPBF9JSBynK
         LIMboApvT8TOGuMsl/r9aUKdQNAAF7XKW/RY7q74qIswfthHsRlqDyb2ZzjsqPp/ZYRr
         s8Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792536610; x=1793141410;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fTuhXEhm4uQNNaPcVdFpwpAupMps3PVyoq78rLHpKEo=;
        b=deZu5iC8GIYcg748Mq7pf0UwhGZL5BswzUhR0ArM18AOc5F1epgM9dV8VavZuvSuld
         oHH+jwFs9q2AtpLD0uPhwvmY0gXRGElsLyBo7bb3WJh1ymRE6zjwU/Lt55GHIp3H2oiZ
         VL/d+7AoD5wKQh7vFrKq5y2TkQgpiIAOOOthMltKWKl4cyX8BKeZMvcOASXCTacGEs5i
         dXoxbjBArKhKtgguLlLFN+IDzRQFHkBz0hLXAAxpwzJRfAn5yVizJXaSrEEsU7ZMaZnV
         tQPKUoKLRxTxwCfk3hAAQeoq1IaHDvql+YWL9rINmJOItZHgyAB+E887gBUKiOcwjHpN
         WHyA==
X-Forwarded-Encrypted: i=1; AKwUvBw3VtOuhWqVXuW12l/cnq3uCDe3K2V7WqimMrT04j+2fwXWMU6VGhKRqVlnzk/pJx7fGhDZMmOVvQU=@vger.kernel.org
X-Gm-Message-State: AFq9FYL4V43NUVrtKfMchM4Uch0Qb7Ofy41IYLrZ3jGi2G2efZwSwqft
	KM2+9yRTWLmztUQUA17W9R5NOpVvBdXldu4o8fTkgyUWvvaGUl3IAJZf
X-Gm-Gg: AYBFou14A/hpc+b2L64T3c2IxGnSrRGxLR/5TNQ4VQKmub4U5CjNXBOB5mUkc6c5Izt
	pWm/HvoLiCVXNXkQqP7O1eTA62NuRNlAmmgNgr4SKxaRZfgxIf0qSTMq8K1GvvIrMMpHyAMMSDb
	EfrnqGzc0/XQANPMLLqVTnT1ZAJUgB5i78xBrxZ1lu755PJwsVLT0Fz+PoDh3tNZbzrPb/YFmE5
	+sXbOz2YbAS4p8LeRbmLmajfT1vRnWlD3fT7+TR0Ewr1g0sHmj/V3VTHbpkjS4TjQZVlR5rm7c7
	bpRqLeuhHZ2UqKu3Rnng/doiRDiAzCOzkM/+4yZSBnhnMOikYdef71MmCPp1m02H8bu088FaKMb
	lqwV6BKS9hLCh8YvtfmbfW8goBiPg1hFoN0gHKm3JbAZOeHhBor4tqS9g5RaQY+y0xh7zzdy88V
	TiimNfErZvP6IfQwtAQ94gGqBj5Tcg34q8pvj0XGt0YuqTiQaeMogpNvRjfn+0PqdLbzTpAt04W
	+OL5NVWYZ0E4Ci4xOnGOviF
X-Received: by 2002:a05:600d:82c1:b0:4a1:811c:8069 with SMTP id 5b1f17b1804b1-4a1fdd20c2amr2908965e9.8.1792536609700;
        Tue, 20 Oct 2026 15:50:09 -0700 (PDT)
Received: from ingenieria31.oficinasStQ.local ([79.117.46.175])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1fc0b42bdsm17511805e9.0.2026.10.20.15.50.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 15:50:09 -0700 (PDT)
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
Subject: Re: [PATCH v5 02/13] efi: bgrt: add accessors for the boot graphics
Date: Wed, 21 Oct 2026 02:50:00 +0200
Message-Id: <20261021005006.2341200-1-maximpedraza@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <1d3aecdb-2537-4f08-a4d2-22c81ebaca03@suse.de>
References: <20261013093243.505776-1-maximpedraza@gmail.com> <20261013093243.505776-3-maximpedraza@gmail.com> <1d3aecdb-2537-4f08-a4d2-22c81ebaca03@suse.de>
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

Am 20.10.26 um 11:13 schrieb Thomas Zimmermann:
> Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>

Thanks! One change since v5, so you know before I carry the tag:
efi_bgrt_has_image() now also checks that the image address, a u64 in
the table, fits in phys_addr_t. On 32-bit kernels without PAE an image
above 4 GiB would otherwise be reported as there, and
efi_bgrt_image_address() would return the truncated address. I'll keep
your Reviewed-by unless you object.

Best regards,
Màxim
