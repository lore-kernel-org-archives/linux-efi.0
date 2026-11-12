Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794496941;
	b=ESQC37br+aA5Ruly9mIlYY6FRUetF38YBs95cRBJJojPslHkwuiIoiF4cYPh24DZdQMm
	 cdiWykf50pz0Glcih07kI8HIZgPnD567cjMsUe3Z5AB2/j0S4T/19Iu4BQrOkj036nEVj
	 gQH7rryadJo7kdGVW6BPRDBE+pJ2AUCuULN1mE7Ua00g4l7ByIO3TdwYx7XP1TnhAAC8m
	 a62cYHD2+4tKDuHNlnVIAOaqiSbtQZTwVNO1EkxtStO1NWxNixzwQl6qW6xtxeQ3xu9Sp
	 nLDyGCyR7pe6e1KhBCgWeH7wkVQrSuQjv9oUYOKaNbcDzYAyYvewfIlLxcLUjtvUN3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794496941;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=E8QRxqca6MPKKmYjqBq9RkAfrZBWcYxQ/ymz9RyAO8Y=;
	b=R8146kR9ayPgjwHrIHgW50pvpRi3v93ifsJl+pFmulFRU3wXA5Ga60JHUJlNtrjXVqnt
	 FuMgBjFtebudydD8c/CH8irs/xAwrYJm+zreIp0SsYZryo7WlfVfRIjvZcLRdNQpoyZBD
	 yTb9sdwe6If63jcO5IuGDyi9IDFsDkGzcHrL9KqRcU6jP4W0HuIsrFcqEa5ytT7Nno01R
	 dFBPRC0iaS8VxIdguAnPIJNAWHSzL/cZYyam68qw+LhCbl0Msu/2qRcaGP2JpPQQiSJlo
	 rO7MRDc9eXmjx6y9/juk6mNqqJ1zpp+Dn2QsWQM1rM9Xlfzs/Mlfb8Azq4/61Ajg50g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CFNCS1RQ;
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF0360A382B
	for <linux-efi@vger.kernel.org>; Thu, 12 Nov 2026 15:22:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6BF0360A382B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CFNCS1RQ
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-4922523d1afso2657730f8f.0
        for <linux-efi@vger.kernel.org>; Thu, 12 Nov 2026 07:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794496940; x=1795101740; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=E8QRxqca6MPKKmYjqBq9RkAfrZBWcYxQ/ymz9RyAO8Y=;
        b=CFNCS1RQhtbSxMwdv4RT7HaDOzw5D755nrRVwkL4k/OwRxOF9nDaPmGgbE6aBTSXWH
         msk1dQ3pVIxMk4yUT4CG9M7TNrpwaoIvNpJ3/pm/e0iSCd4XEBJKI8p9xJEwtSIfutCC
         stsi/5l34qljqB3RcnE4mIfJDNGptsv048CrwnBwOr0aEQYAk0b59wCbdRvQ6o8OL+fb
         cvAtr7bg4Ikai7/soQQ6V0PODVJ4pPFSeLLwUnbQMGtni8xKfY3UKMvp3w+fEstsPVjc
         i5FAdugW53dj2trdg9Fn6RkfhC18gt5RpmdSGsBIKL2h48wr0gH7pQH+a3qJOwITfh9h
         SU1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794496940; x=1795101740;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E8QRxqca6MPKKmYjqBq9RkAfrZBWcYxQ/ymz9RyAO8Y=;
        b=R5WFG+SHdJSRU/eDqMFiIxKnW04bPxWimCp6o0ZWXUY3lsi11Gm8p75S0eOdV+DjpQ
         ryJHulwToeIpyeV+5mrKY15rXcCVY6583/VhLwzQ1FG3QOiWnLM+0TEBj71s76sQHuhN
         2ZvitFy+XZCDpAoKBWZabRByMcp925PhCmD6ZnDUNfqkesWdtxTPYwr9FskyaP/zkDKY
         xN4q98B7IjCky8roi8Q5MyW7YJFaLq+hCkRaIGVtPaPO/R8p6p66zZvtQwlaEiSc6oUm
         bQd5xXA+mMIu37o+5Vlr5kRoRvKsGUnT4qWqHTX6u6XIrW1h+wlJIfLGaVNMwEzzb7J7
         DUsg==
X-Forwarded-Encrypted: i=1; AL+hErFv3je7Ufrc6bbjp3TF/EPHbdJIUMKmX7beEwF3/cOWEMPgrHfFrruBy1CtKmLxu9KN0xyv9h0wCOk=@vger.kernel.org
X-Gm-Message-State: APuU4Z8XBclm8ogp6RJ1RUlgeuBD2DRT7b+4VHZOeYsti1sB3x79kHtV
	sh/IwNw4IjmRWKPUkFage6Jo0owLFB5lqXduw1Qo7dY1fvXBYYYVQ1Hf
X-Gm-Gg: AYBFou2VaWJSkVopX6K1ILeWLanNwxuy22Umx3MW3C+KXnSEwdK+JB70ikmhurenS7q
	QSv6ehNFW0oRmGUyzS6P3897t41gr7i7lKrpNgALa+2+qlT79ZLV03DlmVmQBtk50LcaZvb7Ljg
	kICkjyBD0ekhiAz/gIZbElnj8s9IRhKG9eZPu+wSJhra/JZjuZc0OUWqWMOh9oAq5NtE7608AKE
	z10INrtHzGXRILXKYnZuujy9mcgigGqi82/EsQGDTAmkfJEbRtp3xoshR0zs3snSbuo8yeJ069n
	7V14hdDqypK3lZtha/9kPQ+3AKidZAlsAwD7rlfC4jPLE/ZNL/CItHNL5ee0mmCYPXwK+mtAktp
	eXiM5mgHjgKqm7gZti6Mi3WAA8myLqdtUjC/1wgSEenczM8nzeeWzK9+Vb0jpEWrGYTK24vtspG
	IydOXuGUeJODfMj1Z9jU+GvkQfocgtt9+Mq5ITQg6DyOidd8GQjbIw0eJu5YMfg1RCLj02Qmtg1
	e7XC/Yune4x5prf3MY/SxixuYC8DiBJFN03JjPozpYivROBPFE/AR4WPGQcWeCUX/5QyGkpeK/p
	ACEZ+lkEVTRiiqLeQx9Bs8zbvzBy8cQVL+5O75OU8e53UoJr9nOnTJQ=
X-Received: by 2002:a05:600c:1c0d:b0:4a2:1e1:d55 with SMTP id 5b1f17b1804b1-4ba093a3cf9mr132094285e9.28.1794496939343;
        Thu, 12 Nov 2026 07:22:19 -0800 (PST)
Received: from ingenieria31.oficinasStQ.local ([79.117.0.220])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e252f7fsm84746205e9.2.2026.11.12.07.22.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 07:22:18 -0800 (PST)
From: =?UTF-8?q?M=C3=A0xim=20Pedraza=20Padilla?= <maximpedraza@gmail.com>
To: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Javier Martinez Canillas <javierm@redhat.com>,
	Francesco Valla <francesco@valla.it>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Helge Deller <deller@gmx.de>,
	Peter Jones <pjones@redhat.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
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
Subject: Re: [PATCH v6 00/15] Add splash DRM client
Date: Thu, 12 Nov 2026 16:22:09 +0100
Message-Id: <20261112152209.3297409-1-maximpedraza@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <066197a1-aa2b-455b-84d8-4e2215fad764@suse.de>
References: <20261027135342.2003632-1-maximpedraza@gmail.com> <066197a1-aa2b-455b-84d8-4e2215fad764@suse.de>
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

Hi Thomas, Javier, Francesco,

Thanks a lot for the reviews. I'm answering everything here in one go.

On 11/11/26 14:52, Thomas Zimmermann wrote:
> So shall we merge patches 1 to 6 and 8 first? You'd have something in
> upstream already and not chase a moving target. From there, we can merge
> the other features in the coming weeks.

Yes, that sounds great. v7 is ready and holds just those: patches 1 to 4,
6 and 8 of v6, with the MAINTAINERS entry squashed into the patch that
adds drm_splash.c, so six patches in all. The DT binding, the placement
and rotation, and the connector orientation will follow as a separate
series once this one is in.

What changes in v7 from your comments:

- the Assisted-by tags are gone from every patch (Javier)
- MAINTAINERS: I'm listed as M: and Francesco as R: (thanks, Francesco),
  in the same patch as drm_splash.c
- the firmware source is now DRM_SPLASH_SRC_FW, and the Kconfig options
  DRM_CLIENT_SPLASH_SRC_FW and DRM_CLIENT_SPLASH_FW_NAME; the BMP decoder
  keeps its name, since the BGRT goes through it too
- the drm_splash_fw_load() stub returns 0

On the CONFIG_X86 around the BGRT check in patch 4: it comes from efifb,
where efifb_bgrt_sanity_check() is x86 only too, and its comment says
that all x86 firmwares centre the image horizontally. I haven't found
that promised for other architectures, and there the check could reject
a logo that is fine, so I'd rather keep it as efifb does. If you prefer
it on every architecture, or gone, I'll change it.

The issue Sashiko found on v6 (a restore deferred while the device was
suspended) is fixed in v7, together with a few more that a later Sashiko
run found; the changelog of patch 4 lists them.

About your Reviewed-by on patch 4: since v6 the work has changed quite a
bit. Restore now leaves the commit to the work, a hotplug while userspace
holds the display waits for the next restore as fbdev does, and
unregister waits for the work before it looks for a pending firmware
request. Shall I keep your tag, or drop it so you can look at the new
version first? Whichever you prefer.

I'll send v7 shortly.

Best regards,
Màxim
