Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C563B3895
	for <linux-efi@vger.kernel.org>; Mon,  8 Jun 2026 22:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780958433; cv=none; b=fom41SKXDZUDwQJZdK2id8Q2Rmfhe1aeUhlLPo28xd2q3sYumMFiuf/9JRRDdpbbCEhp9puFak+58vq5XcdJ4XoDi3ExVZykYEZiOGY4a0ozV8/9M1gA+NyornAwvxDkx+4Hc0L8PdaTSVanV3EJTh5FV2EKTwerzEJHhesRRYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780958433; c=relaxed/simple;
	bh=r1UOA6QDMVbLt10TpU5riUnUKzso2VHkTZeHu02qA0E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AwoluDqEkyVsf3GFyPJGHly3IGOSL6ODaqXdbygNYE5pq8rHc0kcb/rU7U9pLt6DGBZJNP3WQzxbm7K/xqjTUJQA/MsAl5HiYJC2e4UUCvxbK0Aij0LMKv7XsRSijcwxePBOlZA7suASfOtJF3UTSPNJEWZAND2+oXUnTV03PL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de; spf=pass smtp.mailfrom=posteo.de; dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b=F3kaJ++X; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b="F3kaJ++X"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id 9FAB3240029
	for <linux-efi@vger.kernel.org>; Tue,  9 Jun 2026 00:40:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.de; s=2017;
	t=1780958423; bh=21o/xwwmDVfuFXFMoGsY/mGvvY5gAZ5X0zqmGuYe3QU=;
	h=From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:To:Cc:Autocrypt:OpenPGP:From;
	b=F3kaJ++XJ3Z/wO8LrsqYHiFY02PcURGmv0OsP1bs4KqfYwQR0ANJ7QAumg5b5SR0J
	 Y75Qj6pCx2ItT3l877DadM5ugCJzysVoKkLUVV4Kawtox5RG3LyRdCtKjnDUiSxAqb
	 /ziycv9VvLd49bF2k2HUC/zazs6S2cPNJvc/vSyJUz1i8NDdGYUM66pkQc6W9HweTk
	 djyRhYFn66b1JrjsqRffzGlTJjNKHxM7ChL1s6ErTZW5mUnTubb2WqG62dOkB09V49
	 QOWea3yudSvYqRxaFoJ4lflJxdONHr9ytgY4X3HJ1DWkxTlN/xUIj/ztXnjIAoK+HV
	 CxgOQxLIwe2Cw==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4gZ6SP2Ngkz6tyc;
	Tue,  9 Jun 2026 00:40:21 +0200 (CEST)
From: Markus Probst <markus.probst@posteo.de>
Date: Mon, 08 Jun 2026 22:40:22 +0000
Subject: [PATCH RESEND v2 2/2] ACPI: SPCR: Support UART clock frequency
 field
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-acpi_spcr-v2-2-3cd9a3bda727@posteo.de>
References: <20260609-acpi_spcr-v2-0-3cd9a3bda727@posteo.de>
In-Reply-To: <20260609-acpi_spcr-v2-0-3cd9a3bda727@posteo.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=994;
 i=markus.probst@posteo.de; h=from:subject:message-id;
 bh=r1UOA6QDMVbLt10TpU5riUnUKzso2VHkTZeHu02qA0E=;
 b=owEBiQJ2/ZANAwAIATR2H/jnrUPSAcsmYgBqJ0TRxNIQZSfEXZRNLWK35PMyBmlqEuLt1D3II
 anTYC2Y8tOJAk8EAAEIADkWIQSCdBjE9KxY53IwxHM0dh/4561D0gUCaidE0RsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDIACgkQNHYf+OetQ9LgzQ//QREw0+754Nn9BQNWibuhrhWZFYTxOGY
 FxTQVSEaw7B9NtX2pmML6nywzUy3Uiv7aI3JORIbFzAk7Vx7x8oFhSvwdNxgQyEMDrcz2u1XmKP
 feZT/ZV0b/shqNUjeZ3dcKh5NZsqgqclAs3H0+7JhESFnkRLVjTF6WxWY2c1l63sjFJAeACBfxa
 eqg0Vf7trrjQBh5X0dPKJASmqWOXOS3U8nIiQUJCmUj9W3jWuZU1sHO/QywJf0ccbVyusE2sRIX
 XDZuvu3m+uhZaqsMzfApYxuVuM4yEHqB8H7Eok5pTWMlRNQOKE4/Q9VbuwrIUA8/owMGzmoNk/X
 PYxeOoAjJDxsIH7BtmbcafX4oXFl0+zcZ7chwgLNQapDoimxo/sFo2MtesnNUeD6wp7emrDC+N+
 LZOcpo1qjHvFbK0VLpMKEao6skhAEEqz+5eZRmFZufDXAPBN0QNgbaC5DRa93v/qpmIaKszcFh9
 nsQ4xSs7/Ky4LxuIAGqCSH/hiBBsHpgOi3k7Xo7wMXzZmbn3ByWqaLWpjKGGky3WcaU5fxPX+sc
 waVGVn7GK33Ms+pquSjjMcyZcAUqVPdJWb2/bX4jXmoebmoi4y3Uofcr1cfd3+LyeK18p0OZ0W9
 kVo2aysaDqhxeyv2QdPI9phGzoJbTPJnSbDcrMHA0tblPZcoSlwU=
X-Developer-Key: i=markus.probst@posteo.de; a=openpgp;
 fpr=827418C4F4AC58E77230C47334761FF8E7AD43D2
Autocrypt: addr=markus.probst@posteo.de; prefer-encrypt=mutual;
  keydata=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
  aBeNN4ijKZchBXHPgVx+YtWRHfcm4l8=
OpenPGP: url=https://posteo.de/keys/markus.probst@posteo.de.asc; preference=encrypt

The Microsoft Serial Port Console Redirection (SPCR) specification
revision 1.08 comprises additional field: UART Clock Frequency [1].

It contains a non-zero value indicating the UART clock frequency in Hz.

Link: https://learn.microsoft.com/en-us/windows-hardware/drivers/serports/serial-port-console-redirection-table [1]
Signed-off-by: Markus Probst <markus.probst@posteo.de>
---
 drivers/acpi/spcr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/spcr.c b/drivers/acpi/spcr.c
index cfacbe53f279..16f94073fde6 100644
--- a/drivers/acpi/spcr.c
+++ b/drivers/acpi/spcr.c
@@ -228,7 +228,7 @@ int __init acpi_parse_spcr(bool enable_earlycon, bool enable_console)
 	pr_info("console: %s\n", opts);
 
 	if (enable_earlycon)
-		setup_earlycon(opts, 0);
+		setup_earlycon(opts, table->header.revision >= 3 ? table->uart_clk_freq : 0);
 
 	if (enable_console)
 		err = add_preferred_console(uart, 0, opts + strlen(uart) + 1);

-- 
2.53.0

