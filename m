Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2B9487BE
	for <linux-efi@vger.kernel.org>; Sun, 24 May 2026 22:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779662122; cv=none; b=sRz8uMMxPAaOBqIvsw4Tr3kj5JIx9gJ/8Wtmbrx1s07oSOdVjv/6Zj+nAP/la7waIq9QBQ6wi1ZWlytS/yjVx8C4YeYsdXOAb1Ah51E5j4ZhmdpYwGkSHvnomkUZs0sh6nwH0wE7hCBfBewtHou1e8vbqTZsFSrXcfjOvxO9I5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779662122; c=relaxed/simple;
	bh=ta40DydIkpKQkbnEOOwwxMzoZ7VpoaQ6vannkqkmbsI=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=HAo/JNupE4OK30sT8f/7nPe+gWcKoKckFBYxnciuG++LHEa+6GtBVmIg182RQwiPrTzBEX/e/pNPpTtdp77T5xNba99r9yzPUjSQtLfogT+pZwNOOybp2GaNGyQfHeUzTNGT9lO9gAXSrHS46XMms0Ns/mJavAhY0Y2lYd3Z2gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de; spf=pass smtp.mailfrom=posteo.de; dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b=A46OvNCU; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b="A46OvNCU"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id F0EF1240101
	for <linux-efi@vger.kernel.org>; Mon, 25 May 2026 00:35:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.de; s=2017;
	t=1779662112; bh=aaWqE4Cw//Mk2WSIHD/fp8fmdq7KyHNN461lpMIINRE=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:To:Cc:Autocrypt:OpenPGP:From;
	b=A46OvNCU99uTGn7i3ff1RZ8J8yFjOSsZB63yT+kbwu3HVlBo/FianmLutscbL4p1u
	 y196dZ7vDmAi9ZAZD/xrC2onUCKuGHV9PTgZ3Hwp1RsAkrMS0g5wIrno1TAr8HWu1O
	 He17fC11PvdfomejSUg+F6LFX/uAmhjimzH+ycKQbBy0rVAXZcIMNfbzK9yx89Xsti
	 ZEMWun+Qy4ACl8ag/4fKhoK78lS3445zp4Vh+qZ6hJwHbCKkklgQQy1ScuRXjlVHy/
	 fPq6YPpPW3W1i3aYMTyjN9uIYwzq1Em+R31zYg/IMGrZuiZXyySWkBk656Nff658aV
	 XRohQZcdXui0Q==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4gNv3L0cxbz6twQ;
	Mon, 25 May 2026 00:35:09 +0200 (CEST)
From: Markus Probst <markus.probst@posteo.de>
Subject: [PATCH v2 0/2] ACPI: SPCR: Support UART clock frequency field
Date: Sun, 24 May 2026 22:35:12 +0000
Message-Id: <20260525-acpi_spcr-v2-0-c042089d73ca@posteo.de>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAM18E2oC/02Oyw6CMBBFf4XM2pK2PAyu/A9DDLRTqQm0dgrRE
 P5dHi5cnuTMnTMDYbBIcElmCDhZsm5YQZ4SUF0zPJBZvTJILkueZ5w1yts7eRVYKSouja5kZiS
 svg9o7HvfutUH09g+UcVt4GcEfI3rk3ho0DaETLm+t/GSTOdUsKBy2K47S9GFzx42iV3eGwpe/
 DVMgglmdN6q0uTYFtnVO4roUo1QL8vyBSs+4KfgAAAA
X-Change-ID: 20260430-acpi_spcr-61902fd923f2
To: "Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Jiri Slaby <jirislaby@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
 linux-efi@vger.kernel.org, linux-serial@vger.kernel.org, 
 Markus Probst <markus.probst@posteo.de>
X-Developer-Signature: v=1; a=openpgp-sha256; l=896;
 i=markus.probst@posteo.de; h=from:subject:message-id;
 bh=ta40DydIkpKQkbnEOOwwxMzoZ7VpoaQ6vannkqkmbsI=;
 b=owEBiQJ2/ZANAwAIATR2H/jnrUPSAcsmYgBqE30dpYKuWtlLWzAoUN/rzc7r36W1yjWFnrHz+
 oEiVqDtT26JAk8EAAEIADkWIQSCdBjE9KxY53IwxHM0dh/4561D0gUCahN9HRsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDIACgkQNHYf+OetQ9LFTA//bAC4aKfm7qlohabURf56jW5A5LBwRnV
 2+o4Yhemmqf73LEK9/g/7V/5WqniToid49WWnzh7EBBfE2swQZ6Fu/kIkgToCF3QQSTC0Ym03b1
 r6YofQ58abSOcbBj6Xw+SpdSRZqw3sdB37NQQ/HWB7GLn8FBF/qWhJLbHDDOieFZQ2C27EtcqFT
 yfBonXRR6OugC4bK6lsMAnMl01NP5Yy46VEzUUV5OGIwb+DL1jRljU0xtff9b9SWtwvB2J/qYzm
 QxKDxFZHHX5Frdm7hE/IWcIxhuaKdjGmXVFPqNMFBEZPkrypXRVAQplJc1XfIKgIp01umZZ08YV
 GKyPfD+9FndgsnVNSsKLZpljZ44gMa01GrWqgyFzXHbdYnT51Feowsrt776HzfU15/Wrm40wyhg
 rt3AbFLkoYhJpMICA/3dPuHAOPYr6RhPny+WiLX0m3eebcv19VyZY5sT3YPfMDkpBjjQJ1bl0sx
 UYrmqXQOB6HTBDkMYxsNcikQF6Jw9stUzPVCSah82M/pg3C7WmfkvJaS1ZDMZtdjEv//kg0yLRE
 eZ638ecjZod/n3DFgcaZogR3QVnsTreKAErhgwqEkWlPPK2fnzZWBevIvVxHQQTDCRzpWErdFv9
 iA+lBn/yabDyJIdQ9VIMmV0G1NT9hSLBMzaWJ0Im8BXNKUp4CT04=
X-Developer-Key: i=markus.probst@posteo.de; a=openpgp;
 fpr=827418C4F4AC58E77230C47334761FF8E7AD43D2
Autocrypt: addr=markus.probst@posteo.de; prefer-encrypt=mutual;
  keydata=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
  aBeNN4ijKZchBXHPgVx+YtWRHfcm4l8=
OpenPGP: url=https://posteo.de/keys/markus.probst@posteo.de.asc; preference=encrypt

Support the uart clock frequency in the SPCR table.
See the commit messages for details.

Signed-off-by: Markus Probst <markus.probst@posteo.de>
---
Changes in v2:
- fix uart_clk_freq possibly being interpreted as parity/bits/flow
- Link to v1: https://patch.msgid.link/20260505-acpi_spcr-v1-1-fd4bc6f4eb53@posteo.de

---
Markus Probst (2):
      serial: earlycon: add uart_clk_freq parameter
      ACPI: SPCR: Support UART clock frequency field

 arch/m68k/virt/config.c          |  2 +-
 arch/mips/mti-malta/malta-init.c |  2 +-
 drivers/acpi/spcr.c              |  2 +-
 drivers/firmware/efi/earlycon.c  |  2 +-
 drivers/tty/serial/earlycon.c    | 17 ++++++++++++-----
 include/linux/serial_core.h      |  7 +++++--
 6 files changed, 21 insertions(+), 11 deletions(-)
---
base-commit: aa61612ab641d7d62b0b6889f2c7c9251489f6e3
change-id: 20260430-acpi_spcr-61902fd923f2

