Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E7E2FE074;
	Sun, 17 May 2026 19:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779045949; cv=none; b=UHXAe5mWDZmWexL4RPEK5k9mzwq4P1SJ9fJGeNnYz0hLDERRNU68DnoGS6HXiZEud39eFKwhdAY2ALN7j5hfEVMSsCl+0+5eVMIk0nqnxU0bJJtA582haFr39ETYmF1CJTcH2bnIkB9t25PF65+cyDfsYRQvzXrxv9dlGdFM6V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779045949; c=relaxed/simple;
	bh=VdIzxQg7InhzT5WRZQIIeph4xb8gbW2GRbRiAPPIuFc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lsAug71CYU8u0kqBtI0z2rFX500N68hZL28sHE13RdUvXd4qhmhwbD4f2278uRJEWZYunGkDlatGt3tbEJnRrwSbVVxOTAq7xO1XsHX1k8bgMXrG8L2Braf2pzgfTgBFT/qMiDnnuwxb2cTnLJSSXWIqUqhzd+TN2BfkODGRL0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mariushoch.de; spf=pass smtp.mailfrom=mariushoch.de; dkim=pass (2048-bit key) header.d=mariushoch.de header.i=@mariushoch.de header.b=E4CD2HKN; arc=none smtp.client-ip=80.241.56.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mariushoch.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mariushoch.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mariushoch.de header.i=@mariushoch.de header.b="E4CD2HKN"
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4gJW9s4Sgrz9v7p;
	Sun, 17 May 2026 21:25:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mariushoch.de;
	s=MBO0001; t=1779045937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=k6cDqxu89FFLtV6+c4F6Z/Dp11EyFCta+LCBtkQHxjY=;
	b=E4CD2HKNVa+ryjOQ676ojB4pd/aT2vNkolpEvocrA65yajWp9BjKom8vUlt+UO3dyPdJ9i
	bxdmMbj2iOz+jk7TTTT8GO7xj35gHMjba9e8Me5h5wXUKIqVtGjMktiSSpnyI22e4hVp0u
	ADeOIF0I/pjbpHDlL+Y18ArXXvZKWAMOME+d3+v1tgEFp2zR6xFJpeze3fEN/TOoIMVlMs
	lyzB+6U9/eFD9+dlFCOKivC6nQh/rYPFeQuIupyEZx7raKqZT+Qst//tSIIGx/CtY2r2y7
	YT3DZood2am3+Nf4FaZMfyLq28baZl031Ygitkjaf+6r+X1Q8cJ9W1dX2JiCFg==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of mail@mariushoch.de designates 2001:67c:2050:b231:465::102 as permitted sender) smtp.mailfrom=mail@mariushoch.de
From: Marius Hoch <mail@mariushoch.de>
To: linux-kernel@vger.kernel.org
Cc: Marius Hoch <mail@mariushoch.de>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-efi@vger.kernel.org
Subject: [PATCH] efi: sysfb_efi: Extend quirk to cover IdeaPad Duet 3 10IGL5-LTE
Date: Sun, 17 May 2026 21:23:40 +0200
Message-ID: <20260517192346.1739732-2-mail@mariushoch.de>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4gJW9s4Sgrz9v7p

The LTE enabled version of the IdeaPad Duet 3 10IGL5 needs the
same quirk as the non-LTE version. As these are the only two
IdeaPad Duet 3 10IGL5 versions, we can safely use non exact matching.

Tested on a IdeaPad Duet 3 10IGL5-LTE.

Signed-off-by: Marius Hoch <mail@mariushoch.de>
---
 drivers/firmware/efi/sysfb_efi.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/sysfb_efi.c b/drivers/firmware/efi/sysfb_efi.c
index 4c3986ddcd54..685283bb7327 100644
--- a/drivers/firmware/efi/sysfb_efi.c
+++ b/drivers/firmware/efi/sysfb_efi.c
@@ -311,11 +311,14 @@ static const struct dmi_system_id efifb_dmi_swap_width_height[] __initconst = {
 		.callback = efifb_swap_width_height,
 	},
 	{
-		/* Lenovo IdeaPad Duet 3 10IGL5 with 1200x1920 portrait screen */
+		/*
+		 * Lenovo IdeaPad Duet 3 10IGL5 and 10IGL5-LTE with
+		 * 1200x1920 portrait screen
+		 */
 		.matches = {
 			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_EXACT_MATCH(DMI_PRODUCT_VERSION,
-					"IdeaPad Duet 3 10IGL5"),
+			/* Non exact match to also match the LTE version */
+			DMI_MATCH(DMI_PRODUCT_VERSION, "IdeaPad Duet 3 10IGL5"),
 		},
 		.callback = efifb_swap_width_height,
 	},
-- 
2.54.0

