Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E82E3769FF
	for <linux-efi@vger.kernel.org>; Thu, 10 Sep 2026 03:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789010348; cv=none; b=C7OUbCQJH80oezTP7lt6oRHQE+MGpQsLuFW022KH1Ry73q5nG5AFsY6F5KFztMf6WVr6VuBNcbyEDuwGGtkEyHSJpxOC5sBIa86eipvJh/Lm83urSpHx2SiT556pU5XMkJj+PAfnCxmoGIvrI3pHPTP49M0iaOH/C8aqSz3Moy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789010348; c=relaxed/simple;
	bh=CZCZphFtwnyR9V4pnluF5ZaUb2LNgvX6iqLOQ9kTly4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=clVYADaosDmLnRSpni4irEtkAetPTzoB6ilBY3dC9cFrKMrcfbCXpnJ83GlKPq4NItBoeaYZqfPWSHISa2p4g7auYqeJV9Ukp3xZhLli6vToGWGfTFHgTgSi5hCmR1Z+FVAJXAuxGPGygmTazA07c1oJgzU4MN/lDcUHcrp/loM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=tJC7HJN5; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tJC7HJN5"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-499ac87c92bso69555945e9.1
        for <linux-efi@vger.kernel.org>; Wed, 09 Sep 2026 20:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789010344; x=1789615144; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7h5a++gvjff2+ABbxAEfyPjYnS85ALwwS0YaPZ1LMBg=;
        b=tJC7HJN5+6oiu1emA7TkYcrvA+9lATR1TwaEGFVxZVZCkyf47Ua8ryD8xu2pK6RH5E
         U3jIS/X3iGhEKcXs3bNtq+JRhh7idZ2lQF0690/hvCoIfIeLsY9ni2w9o6iPgHoet+TP
         dgrYa4olGaYn5UsBOb1nZayAYikfqWb0cXbt3LuwkIWWQwUJCNFJ45mwAXdTBTXgIA2E
         y8JQLzqy6CHl4mWfexIVuOxZidXJYWAbiqgxF27NmmGsRz2/XV78GA2x1PcQtzGCLQrx
         r66FLIA+Sx8eFI4UU+2MrouK3v/cgLCtvENa/iD7zct8j19mzQrS083rSjU3xNNtwJsy
         7uRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789010344; x=1789615144;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7h5a++gvjff2+ABbxAEfyPjYnS85ALwwS0YaPZ1LMBg=;
        b=RzMe5pQDb7IjQWD4Ph2HvGM06e/LrnutWGhbFR7O7GgbY35b7wW2Ppuweavg8hiVMD
         DRRpThwmammRFUX61+O5qcApXXDW+A3Iu5OUlBIgGInkdGKFcdn870Xpq6UyK97lNhRy
         YFpwLYzXXqCSIc6e8Hf0xJHMToST99dZwdxMVZo5SRqBUoU2Ejk3UA0Q1BUV2i5TZLI2
         RgvwUBE8ya8vqZ/O7brxOGxRhiJBvwfQodYPZ/j3uQtNrW0XnCf5/cYi75N2PNY1pO/P
         xQpFwGRCGb9liRr2SxO43gBj2QDyBaA7zhPeKJXFflrbb1cs98JT13jz6WSyrGD/cByD
         EflA==
X-Forwarded-Encrypted: i=1; AKwUvBwPavcIvon922vnVikl25E+e33r924NxL/gBayMZE28b4KeACviWgQxNoMf/diqVUGoKe+wNvon/j8=@vger.kernel.org
X-Gm-Message-State: AFuF++lNWWAOS3dtQfjATb2givgYLd14q4evDr4eVv+UDejRKX/9nRDs
	zcwKfHn0D8RWf7tUJtCB6EWlF41UZjqoDPbZfnpgBj0YhHC380UPz9SQ
X-Gm-Gg: AYBFou2XM/py7nTTMsGTWDLzIxAP9do4SbxNh5yYlkQLrKNVCU9MqpT6QV6yDdjm1px
	GPz29qabYFOVVKUZHDG/asmSvYV4ho9VQckcEcsCBixnafc/pElnZ0P+Hopaqt4Mhh87B7+2X8N
	4wDajkhoiX6kixgdwUn7lKMCgEkiFgAlFWbqkmWUWeTcgYHRX2bZQI4rsSHopNvQwzjo7QtHG/c
	RAjk/sI0oC8jXY9am/ecOtoDU7f2+PXuEMfjH6nQ1M9T8rmHVGRRa3jHwxnNU0KVrYvmwa052UT
	GMnOtkej+dlI4to5T5RO+HCs57k+KbvIu9KbvanGxCObbtDRRwccF98cYuzQbd9xT34S2HCTJum
	1Y4ye+JYEqKTz5HzFw14FsQTUwM/wnlKFM7b7NHJT63+1RjX6NYyVeRHhOnMXVHPZJ8eXuRcMSR
	KJviZurdQXBQApE0Sw5Bt3Fd1nnP/rgfJn/Clz7UpB4YmdHoNI251K6oRpsHvFL150BlRh/3cm/
	EBj09c6KDmcLEMOEtcsZylahTJ1prB/4b51FFn3YlGHfe1XxDd9k6JD0MAiKWy7mDBBAKGiDmTZ
	cqLXd7Ku+KrNc4hhlJAprFirdjOG7gYHdhchAuRdUF+Js87T2ku9M01uHQo/zgvYVeItFh7HZQk
	=
X-Received: by 2002:a05:600c:154f:b0:49c:fc6e:8cb5 with SMTP id 5b1f17b1804b1-49cfc6e8ee3mr393723595e9.25.1789010344521;
        Wed, 09 Sep 2026 20:19:04 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-b3d9-b901-0402-5aad-0ef4-88ac.310.pool.telefonica.de. [2a02:3100:b3d9:b901:402:5aad:ef4:88ac])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d1fb1e60bsm90976765e9.0.2026.09.09.20.19.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 09 Sep 2026 20:19:04 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Heinrich Schuchardt <xypron.glpk@gmx.de>,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] efi/libstub: Fix efi_set_event_at() parameter documentation
Date: Thu, 10 Sep 2026 05:18:53 +0200
Message-Id: <20260910031853.15236-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

efi_set_event_at() documents ids although its array index argument is
named idx. This produces missing and excess parameter warnings.

Match the argument name and fix the adjacent spelling of array.

Fixes: 8c0a839c2bcc ("efi/libstub: Descriptions for stub helper functions")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 drivers/firmware/efi/libstub/efistub.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index fd91fc15ec81..049263a541ae 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -224,8 +224,8 @@ typedef void (__efiapi *efi_event_notify_t)(efi_event_t, void *);
  * efi_set_event_at() - add event to events array
  *
  * @events:	array of UEFI events
- * @ids:	index where to put the event in the array
- * @event:	event to add to the aray
+ * @idx:	index where to put the event in the array
+ * @event:	event to add to the array
  *
  * boottime->wait_for_event() takes an array of events as input.
  * Provide a helper to set it up correctly for mixed mode.

base-commit: 50d05c7c76c96b90462f24debacca971d2e86713
-- 
2.39.5 (Apple Git-154)

