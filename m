Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339953B38B1
	for <linux-efi@vger.kernel.org>; Mon,  8 Jun 2026 22:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780958430; cv=none; b=n9ZGmtmgi88I1839KvBQTukO3sMMWFwONhn55vBgqG38LzZt1EuDPfFM0w36jD1R2kSwO2aQGap0juRtgzB8PIXie5QXX3wMEfpUvhDGBX36kmgB40f7Yf/a2oQzhOK/jacSa8Lqjbks4T45vJtQgDQpHHcJPlMDSrjmUIYVM3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780958430; c=relaxed/simple;
	bh=gEPVrds7gEFEphX/SOjUp9gfWo9lcAIcZ3iOZ4q4VtY=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=AqLmaS47S+Jc2QpEaNg9hA0vdHGtT2i+hakAh9beuVS1TPic+apX90u42RnfnARdbfB8k74Oyd2Q4oHrkUFDy7K8dqYtuIfzbSEf25pK5kkolySVz+Q0jOhK1LopF6OKJ21MedOMdylsjptY8BLfUrrqvD5Y/A0V8KNvJGOJB3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de; spf=pass smtp.mailfrom=posteo.de; dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b=Mtf0VsGG; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b="Mtf0VsGG"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id 7A1F8240027
	for <linux-efi@vger.kernel.org>; Tue,  9 Jun 2026 00:40:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.de; s=2017;
	t=1780958420; bh=hxGcOhFq9zW6pO8J0EHOVLLdkeJxAjYoFEDoPUqkzwM=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:To:Cc:Autocrypt:OpenPGP:From;
	b=Mtf0VsGG0ht0VJVYlrFD6J8Jizmmkc3tfYvj9owBDmZpej6WRO1eQ5hhWURXJGNkW
	 RXTbfsIEuzW5t87sLIEP/4VC4w8mf3ePSeGy4ybtwUYntuMxuwJfBkUUNYKWb4QDjG
	 gxHqMw5tMxlpeKYMKo+zsfKh5Pbtyvc25yE4GDI0I0qqVqCU9hFdSvWEH/GRwpgH6A
	 Z3fTYhzIMCSkLrkzyHXKDe645yMbYUQ2Pb50jfjRFK9H/IiuJGUVplxlDdxt1HoI8r
	 ey99tQFsiWgtuw03MbhNKtVJF1qzessL8QJ67T+QSIKoDmmjWrEmOodBfoGEx+LMnN
	 NHhY/G5YrsE1Q==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4gZ6SK5Scvz6twP;
	Tue,  9 Jun 2026 00:40:17 +0200 (CEST)
From: Markus Probst <markus.probst@posteo.de>
Subject: [PATCH RESEND v2 0/2] ACPI: SPCR: Support UART clock frequency
 field
Date: Mon, 08 Jun 2026 22:40:19 +0000
Message-Id: <20260609-acpi_spcr-v2-0-3cd9a3bda727@posteo.de>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1829;
 i=markus.probst@posteo.de; h=from:subject:message-id;
 bh=gEPVrds7gEFEphX/SOjUp9gfWo9lcAIcZ3iOZ4q4VtY=;
 b=owEBiQJ2/ZANAwAIATR2H/jnrUPSAcsmYgBqJ0TRWmlvS+iDS4RaSZNSpOZsbtyV/w/di3ow9
 7LoRPNRVoyJAk8EAAEIADkWIQSCdBjE9KxY53IwxHM0dh/4561D0gUCaidE0RsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDIACgkQNHYf+OetQ9ICTxAAoLF2wHMzEaFxFyLVErT+NGnWvAUTc2h
 XoJw9ab7gk1Htg3Ym3idaaIHSd/8f4H2377uAiHwRNNTu1BgexGnCNr3eOqfgy/BuS8AgfWHCtF
 StUFpYLqx+h6ic/aTkGBQ0Fu9ytfX9Cnk1J6XL3fhYtuV93WcYxHm0RACxhYG9WNA/Z58MnBnS+
 xxyxYlIP8vbXcB5v190h1SEsz3D6xtWECj5Bwh4aoGgOP4GIdO2dVec/fxwrHdzt6NobClJ0rbq
 0+OYSIaq54cmOgjvDauZRkwCDbkmWBHX2N3UWApOImMd2JcGm92wzfmjpPNaM+AIPiLkpPlaiMZ
 eIwQEVhz4xY0UkuvDMF2fjXLVDcIiPQhR1263QBTe7O+grzbRzRsaWg1SKkgqarKqkbLtKrh4n/
 qnaS2yjhIM9qR4TqZ+0fDXn0/b0HZw8PCUxZUbB3TMlufX4LQHFq4ax3qn8G4eKjTIecg6ELir0
 E+jsxVqBu8JSLWc0QatoCnLM7OhPPA59KjDecJjACciUbqoMdbFqu1EJA4te4njJzLJySlVZlJa
 cztayl0PSF2qPeBHA7lnBqgXYwkZ2IBbXSC6bLSSmZiHF9IWw67EjwaVIcqlRQ5mdNnjmeclPfx
 QNHUd8P9HcgIgKvcfWx8baOAZQtajiYneBxguKLYQE3V1avqdjPE=
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
-----BEGIN PGP SIGNATURE-----

iQJPBAABCAA5FiEEgnQYxPSsWOdyMMRzNHYf+OetQ9IFAmoTfSQbFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyAAoJEDR2H/jnrUPS9e4P/3ObHEJDC0UywwA9xj1z
kzoUrs/iZrus7ROb6ri7MzHVY8riTrzHZrvMOkdWBAxuMXrnzdLwDx96qnQuiaHm
GJBDNBAxoRzBxVkkQJi9Osa+zr8DOEC3+gsv3dCqNqI4DT1wXsBEMi4zgg5dJ5Ye
oFFjEXN/EAiFVa6DHeNMaoJ69sLbYjvWUxAvU74Zpa6zjQMc1n9oCcJFc5D6cvkx
9/WozDV7rTNjmqDy9kcmyb3geeEMd14/y3j8adIe6qB0kkIJQwQr671eIWzGA7pg
353gxRmbLaT9YCKJvHsP32N7Z2EUhrp/o3U6Od/Q0I+qDz13RBSuDLUTogi/mhAw
U7i9a2WHaD2LvwQdt5azLjuo7etx5si84E/cT5G2xJBwUeC2ftYjZulJZs8BMKZp
Oac3Ln/qWCEVw52DWOcxPPIkxlGfjEZOqWBajkRI4NdY3+d0o0/nBK+RYfOt30sf
L3+yLnMmqBjF1RkF1Lm3kTZ589K2KSxGOKMGoYKZqyvV4Ato4w4EoIwL+MQJw7SD
De/BNNpFpTDqJxqgnl4HuELZRzmiKAQCGMwDq285I0Ng1r7xlxFCDYBJnyjnm2Qd
LbD/ZH5yl0beq/S1qZla+JIRjYdbRNQlLUSh3MqBxgll0Xg5GYLk2qeeF+xJJDCq
LkXKR59axau1efToWKWn7CBZ
=EGzU
-----END PGP SIGNATURE-----
-- 
Markus Probst <markus.probst@posteo.de>

