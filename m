Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB2037BE74
	for <linux-efi@vger.kernel.org>; Sun, 24 May 2026 22:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779662433; cv=none; b=ANcTTnoscmbCpy7Nr6qK/fRXpdiuvukM6Qoiz7B2eLFubNPuXEs/u5RVEQvw2wRp7pNO1pg5JtsvOCUzDWJTSRiGIJoj3owe7QtLmTsCjIabTDWQp6255IBegG39hssKBGl3NSDM0YJAz12DEaaQal7jTlYIlKDWzG9yCIcGkzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779662433; c=relaxed/simple;
	bh=r1UOA6QDMVbLt10TpU5riUnUKzso2VHkTZeHu02qA0E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=buTa0c/Wbf3/cd61F5k/Un/ZRLejcDh4mQ3Zv2zk7AzgM7laJXba5jYlZYXuelcmsLTLVN0LeUx+vs/zsiODFhi/ZXmdUN7jtNNDYZuZJro8Jsw6ornRNhtzB0gH0lgEUy7npmctVrcfCoyxkk6kkBSmnjIvXQyZFQ9Q9WKE8so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de; spf=pass smtp.mailfrom=posteo.de; dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b=kmKKGbl7; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b="kmKKGbl7"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id C035424002B
	for <linux-efi@vger.kernel.org>; Mon, 25 May 2026 00:35:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.de; s=2017;
	t=1779662115; bh=21o/xwwmDVfuFXFMoGsY/mGvvY5gAZ5X0zqmGuYe3QU=;
	h=From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:To:Cc:Autocrypt:OpenPGP:From;
	b=kmKKGbl796le6XQKyxazsuiiu46rwE10xlWpl3DAbc6jpMR5UEQ5GnQiwDqRoPXhJ
	 xdXs+FNoRuMzAMpeAw51+B6fIw2MA7TOlR6foJtKRmwDffNWApcE/h3l/gTBZeyVS4
	 yM54Zb4NF+XfVITMuOhKAe1uAsP+Xgxbaxpve1w/rcZKjLAOR2q5VKuOdb+HZy8wT7
	 cS1pIa0xiRI3LeoCEYaJKHd8nB7AaDyiL2UnuOnyVDC9w3zGEUMiVtvA+payODE0oF
	 aUyj0vr6T0OMjkYz0wk1/mUbzrJ3C0Cmp5B//+Ur4I+NOlUH73KQXgxFVKGxaly0Tw
	 Mv47bYzokYqLQ==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4gNv3P53smz6twQ;
	Mon, 25 May 2026 00:35:13 +0200 (CEST)
From: Markus Probst <markus.probst@posteo.de>
Date: Sun, 24 May 2026 22:35:15 +0000
Subject: [PATCH v2 2/2] ACPI: SPCR: Support UART clock frequency field
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260525-acpi_spcr-v2-2-c042089d73ca@posteo.de>
References: <20260525-acpi_spcr-v2-0-c042089d73ca@posteo.de>
In-Reply-To: <20260525-acpi_spcr-v2-0-c042089d73ca@posteo.de>
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
 b=owEBiQJ2/ZANAwAIATR2H/jnrUPSAcsmYgBqE30d/Ky535kkEs+jKKn8OQQkNdVumjA0gDnkP
 gQRdkNXGcOJAk8EAAEIADkWIQSCdBjE9KxY53IwxHM0dh/4561D0gUCahN9HRsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDIACgkQNHYf+OetQ9LWgRAAvdrM4XZHCaojJl1n3pJlb87437N7Ysl
 cNkiSgsUT45gB6Eh9s+7sx02CKP4udH4Xd4oUHA1y4qPfoEsoaULCTmr7xhB9GxUQrxdjumhQpv
 0P5dh8/m2fOEDanPTKIabSUOB8dwywtABfg8AoZMQLN1XMrwgh7HrFZqOVjYmwv0pcWzDY9KqkQ
 iZ7e3pW6P2ZNmo2KMbGAYVVSRUIn+u0+qx2r4opkHThg/UCLXQxyhPtudXlMLW0lMByUd9XlmVz
 fsnaNuro4fWVZiRiuqeEL5BJ7OmYiK/LjJchgX2WJZJUJDEwbSG99IDP+86735QCcLZtc0HRrs0
 6jPy0YzCL6BznKvT30IvuK3o+cz036XXCa7dgfkPt5pUBD0Az/Q5vDCWnidSh9uYm0RM2p/yBAp
 WzEfolY0wxFGjJui5maHYcac91qgVEmJDJDH0iXltBe9VoTerHKmSUl+dU7fecJ1n/x+YWcFNRC
 aeTlXwnseN7mCc76bxLnc7IuJHf0BoWgb7b9Yw+C/+59u5qb7ejArucymV7sF8cJX6ZHixQjPSQ
 QS02GYsjcWWWsK5PeJISbt+Tceu5OiQ0lSVMntbLzlti6x3OfQ2qaLtAymEtMtMx57a+YNcRdWB
 fzBf1iHIImPl8CZ2ZX96MVW2VsWVsLR3RghguBCp1Bm0BGyDYODM=
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

