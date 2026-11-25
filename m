Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=93.77.172.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626230;
	b=k6HKtzi8HwxtImYUKRVeCDRc/PS6egOKsQA3Nt2GHX1BD1zHhlo69XLLdFvAXgCLNjK4
	 Uw8UjGTodhU9QQ+1D5aTP8j/f6tuTZpsS+1bAnI3cx7gs4D5AoJS2LOXECgq0QMeSKjyb
	 ClcSzcEumby4RIX1heoW7aVBum3IxdbfOJyn+0HXoMbTOQNRDpcO/wna1MNmz8K5dNEpf
	 Hy0iPYDMgedAqJ37gyaHtI96MDzY8opeM9+LzK0zNO5Qq2resOmCvYNWQzp6Yh0S2NzMP
	 fDluLnTgCBasgYSPmhszwSP6L6B31XbdKX1OfP+phUB3z0QvobgLWQxrLeuiuMsg1Uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626230;
	h=DMARC-Filter:Received:Received:X-Yandex-Fwd:DKIM-Signature:From:
	 Subject:Date:Message-Id:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer;
	bh=5fyibea5xsAv0DxgVuzf78dNLQbsIr/IVZ3YzJ6A8X0=;
	b=dBq2rWsjshCu+ePQAcPt11YNDrIqF0rZKZthQ/v6wuCLTYNrcx8KfRuOuxF5NC8jccJh
	 iwQ3b/cXT4T01auXCHC0WCymGca85DCveEApbtqBz+gREezTbiWqQLGC+NuvzCvVx56aH
	 D85paL/oUJwQQwdMllESaJoXraB1YmlR4k3SCaASvCF1TD+6wSlC07+aUpJPpJMgyyCXt
	 BwjogJJoogDxaivAxpvo8mEx6d0cnivxrKXuDkCpy7nLmyPafIzLE1NyFz4lMXJfhcQiV
	 JSHioftdC7j4hWLWCo+F1RzNW4CNdRpTvL+1YPvRU1mahHLOiFmizTRTxvIhiw5/5PQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=yandex-team.ru;
	spf=pass smtp.mailfrom=yandex-team.ru;
	dkim=pass header.d=yandex-team.ru header.i=@yandex-team.ru header.a=rsa-sha256 header.s=default header.b=aKmJIWCR;
	arc=none smtp.remote-ip=93.77.172.5
Received: from forwardcorp2e.mail.yandex.net (forwardcorp2e.mail.yandex.net [93.77.172.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53977606A31E;
	Wed, 25 Nov 2026 17:03:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 53977606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=yandex-team.ru header.i=@yandex-team.ru header.a=rsa-sha256 header.s=default header.b=aKmJIWCR
Received: from mail-nwsmtp-smtp-corp-main-80 (mail-nwsmtp-smtp-corp-main-80.yp-c.yandex.net)
	by forwardcorp2e.mail.yandex.net (postfix) with ESMTPS id BDD10C02AF;
	Wed, 25 Nov 2026 20:03:39 +0300 (MSK)
Received: from [127.0.1.1]
	by mail-nwsmtp-smtp-corp-main-80 with ESMTPSA id a3lrP22Zo8c0-42NguKdy;
	Wed, 25 Nov 2026 20:03:39 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1795626219;
	bh=5fyibea5xsAv0DxgVuzf78dNLQbsIr/IVZ3YzJ6A8X0=;
	h=Cc:To:Message-Id:Date:Subject:From;
	b=aKmJIWCRFpLJGwyIXhwL4qDqJkPOWvlFxpoxvA7QEnoOKlkJVev9qiCttoz75Zteg
	 +d4EUsuZmhd0Rg/y1xuane2A+gLvyZrCJ4Czbd3aYSSnxNj6WrIdb6g6m/lJ+cmn1n
	 GOAGkFjoRZTu+pswm7r6h5p2Yf8m1pwa2WbgZ+oY=
Authentication-Results: mail-nwsmtp-smtp-corp-main-80; dkim=pass header.i=@yandex-team.ru
From: Mikhail Rudenko <xyzzy@yandex-team.ru>
Subject: [PATCH 0/3] Implement handoff for EFI earlycon
Date: Wed, 25 Nov 2026 20:03:24 +0300
Message-Id: <20261125-efi-earlycon-v1-0-49ac2c0a430b@yandex-team.ru>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDQyNT3dS0TN3UxKKcyuT8PF1Tw+QUk6RUk1SLFGMloJaCIqB0Bdi46Fg
 Iv7g0KSs1uQRkhlJtLQCwffS9cAAAAA==
X-Change-ID: 20261125-efi-earlycon-51cd4be4e8d3
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Thomas Zimmermann <tzimmermann@suse.de>, 
 Javier Martinez Canillas <javierm@redhat.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, Peter Jones <pjones@redhat.com>, 
 Helge Deller <deller@gmx.de>, Hans de Goede <hansg@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org, 
 linux-doc@vger.kernel.org, Mikhail Rudenko <xyzzy@yandex-team.ru>
X-Mailer: b4 0.15.2

This small series aims at making EFI earlycon a better debugging
tool. Currently, when earlycon=efifb us requested, there are two
options. (1) By default, earlycon is unregistered as soon as real
console comes up, before devices init. Sometimes, "real" device is VT
with dummycon, resulting in no console output untile framebuffer/drm
console takes over. (2) When keep_bootcon option is used, earlycon
never unregisters. This solves the issue of (1), but results in
display corruption when both EFI earlycon and framebuffer/drm drivers
write to the same aperture.

The approach here is to take the best from (1) and (2): EFI earlycon
unregisters exactly when the frambuffer/drm driver claims
aperture. This new behavior is gated with 'earlycon=efifb,handoff'
option, so the default case does not change.

Patch 1 aligns EFI earlycon framebuffer unmapping time with actual
console unregistration.

Patch 2 moves aperture ackquisition in efifb and simplefb before
mapping the framebuffer. Also it moves resource size checks before
aperture ackquisition in simpledrm.

Finally, patch 3 implements "handoff" option for efifb, and wires
conditional EFI earlycon unregistration to
devm_aperture_acquire_for_platform_device(),
aperture_remove_conflicting_devices() and
aperture_remove_conflicting_pci_devices().

Signed-off-by: Mikhail Rudenko <xyzzy@yandex-team.ru>
---
Mikhail Rudenko (3):
      efi: earlycon: unmap framebuffer when the console is unregistered
      video: acquire firmware framebuffer apertures before mapping
      video: aperture: hand off EFI earlycon on aperture ackquisition

 Documentation/admin-guide/kernel-parameters.txt |  5 ++-
 drivers/firmware/efi/earlycon.c                 | 49 ++++++++++++++++++++++---
 drivers/gpu/drm/sysfb/simpledrm.c               | 28 +++++++-------
 drivers/video/aperture.c                        | 13 ++++++-
 drivers/video/fbdev/efifb.c                     | 12 +++---
 drivers/video/fbdev/simplefb.c                  | 11 +++---
 include/linux/efi.h                             |  7 ++++
 7 files changed, 93 insertions(+), 32 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261125-efi-earlycon-51cd4be4e8d3

Best regards,
--  
Mikhail Rudenko <xyzzy@yandex-team.ru>

