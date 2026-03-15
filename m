Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE54C37CD2C
	for <linux-efi@vger.kernel.org>; Sun, 15 Mar 2026 21:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773611607; cv=none; b=p/3rImJ+nHrYGA27Stdwg74P31jxBZAK+NXWRgxN1wqvQzsLG/5q//WS/RhIuQ93Pk0p6hMwflNIFiyuNHzdKYsuWvQPb1T4SajaXYxkiR5ZaNXxbQ+td52ZfcYnj/RnPfhBUygtSKrRS4xDMwuImTfV3PYJQ55tgGaxGaHHjxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773611607; c=relaxed/simple;
	bh=IBDYUK+3O1y5VL1z6GzT5aRoM2+wTLMn0ghXsNI6iG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NwZ1S5f5unHPfDospRYMowOQ9KR9C2C8JKWEBnsH3SNunYGVprVvv4S0dVSCHkWxiNKn9dw0lWUqRijlcrJhc5pLiyFfPNkRW0qf4YSF8+PTBX+9G/Ja32WXBph/61omPQUixqOFp5RXiOS5ARDRDbKj6lRZeICxQnPeD+59U7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BP1DUyCy; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BP1DUyCy"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-35a09e0dd63so4214778a91.3
        for <linux-efi@vger.kernel.org>; Sun, 15 Mar 2026 14:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773611606; x=1774216406; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cXUioPAqGCi/G7aJUPOn/95wAygcdDsF9zmaY+F6+Nc=;
        b=BP1DUyCy6qjgkEJ3qgba6JOxkZFgdWn3EWp3cyU3eZEMWKES+ljoamOpMNjrcOvTBL
         sHq03gDDtFj3OCdBVJXwNVEqLSigHsWzc45VW+jJb1czsNFvdgkD7x9PsHWG+IJ3JUfD
         iXGsfb4CK72PEZv/syyqg1TFlbOyHw5USbX1qBklhg96V4h7gTupbaO8imu9ej9y0ER9
         YP5zaNvoUN9oVT9WDqCrEKdyhjKspE5wjh67oN6zvOM9Gixb4PBh1lny8duW6pVy0a4L
         zBP6fLU5PasQBdHB2HTxQXKQgAXCsPX4v2yvU3opqMOWumA86yssLCbRzCB27bcP8MUd
         IGSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773611606; x=1774216406;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cXUioPAqGCi/G7aJUPOn/95wAygcdDsF9zmaY+F6+Nc=;
        b=PIUXCxgPmlhIzgQAqfifRYleKK1gEjuA64NBPXwFRUDIkEapBDEdKJFkkxlW9K/Cvb
         p+V1cSBKStux/JuYT4YLAbWx5g+6VkdjaTPrq7Tevphx6iJP1zihGZIQo+ejPJp4LsXO
         7p4XeqO8Z6gO5rV/LYUnOmr7KTP6d/Wip8PmADsW/kQ89jO5+R/nTAD/AYNNHicK+Njj
         67q8j6ZiZo2J4NOJRrjvYmEWwKNMfq/1ShiWSU+gqPbxWy0KDBFgbO5NNOAS3XWgva9J
         9Fo2J/TAIP0FGsOULGoURerpLLVES9XZRCeZeUayX7QA9BuNdpJTYTv4lb2ZVFUXaFP3
         WRTw==
X-Forwarded-Encrypted: i=1; AJvYcCUIQkD4Ygp8Yi8TToA3MyAr5N1WLhXyj/TJnOwSrrM9RkBGSGgq+gOUWy9mtbHLlorbOIaaxrzyxoY=@vger.kernel.org
X-Gm-Message-State: AOJu0YznG0OI6luKI9H2FUmLwRgZ/3mL/kZSp2gpmAWvjeeF7GvVUyUo
	VhwoshcXudnuK7Wyg7DhCztZJDyG8Xvqax2BxUj4miPpYVa+fZ5NywlscYND
X-Gm-Gg: ATEYQzyw/u1zasGFUGx17DgLz63ehI3xMgPp3tcSJdRwOeYtJ70Ad9Zff0daFr5ddAS
	A+84sQoIzErOEOyv7Q3edR0hdqVXdgYwxudjykI4b2QGCiqi0ZEsx0TrV+okvYljWjX1utsbYLn
	UD9GGGPjzq6IARQUq/asxe8oAsBLo6HVZu5R7xinrQBZ/eCzDCZj/2OacRVCUpkBT1L26tbFRZs
	VJnerHWySIsQJT+tYgCk4uPQ+arhg0spxtihIzd9CKYuOOICQfxWEEZweIQCK50Mip+eTPgHNXx
	R5m8Hzw7JkWF6zNRJpLguhPOTBEouPn9fBX2aoNSs8zD5JQdsZ+QxppUrnRuyXtRJP989zPieez
	Iw3MUYzhY6jgjE9X93nTNe+wc3PogsbvU5iag13fb7qO4AnE0Cr0x62LpLop+xKaGL6+KIZKzoi
	/GiKdb/SpcIv+qroqYz9ezPbmdV7b6SNErzFmBnonnXIsSK1D9M6TUouu8WCCyld0=
X-Received: by 2002:a17:90b:1d08:b0:359:409:49bf with SMTP id 98e67ed59e1d1-35a22063fb8mr10339166a91.21.1773611606207;
        Sun, 15 Mar 2026 14:53:26 -0700 (PDT)
Received: from at-Standard-PC-Q35-ICH9-2009.. ([171.61.163.197])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35b9303eb9bsm3074980a91.8.2026.03.15.14.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2026 14:53:25 -0700 (PDT)
From: Atharva Tiwari <atharvatiwarilinuxdev@gmail.com>
To: 
Cc: Atharva Tiwari <atharvatiwarilinuxdev@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Hans de Goede <hansg@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	linux-kernel@vger.kernel.org,
	linux-efi@vger.kernel.org,
	platform-driver-x86@vger.kernel.org
Subject: [PATCH v2 2/2] platform/apple-gmux: use apple_brightness to save brightness to EFI
Date: Mon, 16 Mar 2026 03:22:42 +0530
Message-ID: <20260315215302.24087-3-atharvatiwarilinuxdev@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260315215302.24087-1-atharvatiwarilinuxdev@gmail.com>
References: <20260315215302.24087-1-atharvatiwarilinuxdev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

use apple_brightness to save brightness to EFI.

(tested on iMac20,1)

Signed-off-by: Atharva Tiwari <atharvatiwarilinuxdev@gmail.com>
---
 drivers/platform/x86/apple-gmux.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/platform/x86/apple-gmux.c b/drivers/platform/x86/apple-gmux.c
index 1417e230edbd..5a13c917c496 100644
--- a/drivers/platform/x86/apple-gmux.c
+++ b/drivers/platform/x86/apple-gmux.c
@@ -22,6 +22,7 @@
 #include <linux/pci.h>
 #include <linux/vga_switcheroo.h>
 #include <linux/debugfs.h>
+#include <linux/platform_data/apple-brightness.h>
 #include <acpi/video.h>
 #include <asm/io.h>
 
@@ -78,6 +79,8 @@ struct apple_gmux_data {
 	/* debugfs data */
 	u8 selected_port;
 	struct dentry *debug_dentry;
+
+	bool save_efi;
 };
 
 static struct apple_gmux_data *apple_gmux_data;
@@ -960,6 +963,13 @@ static int gmux_probe(struct pnp_dev *pnp, const struct pnp_device_id *id)
 	}
 
 	gmux_init_debugfs(gmux_data);
+	if (IS_ENABLED(CONFIG_APPLE_BRIGHTNESS)) {
+		ret = apple_brightness_probe(gmux_data->bdev, &gmux_get_brightness);
+		if (ret)
+			pr_warn("Unable to Enable EFI brightness save: %d\n", ret);
+
+		gmux_data->save_efi = true;
+	}
 	return 0;
 
 err_register_handler:
@@ -1012,6 +1022,16 @@ static void gmux_remove(struct pnp_dev *pnp)
 	kfree(gmux_data);
 }
 
+static void gmux_shutdown(struct pnp_dev *pnp)
+{
+	struct apple_gmux_data *gmux_data = pnp_get_drvdata(pnp);
+
+	if (gmux_data->save_efi)
+		apple_brightness_shutdown();
+
+	gmux_remove(pnp);
+}
+
 static const struct pnp_device_id gmux_device_ids[] = {
 	{GMUX_ACPI_HID, 0},
 	{"", 0}
@@ -1026,6 +1046,7 @@ static struct pnp_driver gmux_pnp_driver = {
 	.name		= "apple-gmux",
 	.probe		= gmux_probe,
 	.remove		= gmux_remove,
+	.shutdown	= gmux_shutdown,
 	.id_table	= gmux_device_ids,
 	.driver		= {
 			.pm = &gmux_dev_pm_ops,
-- 
2.43.0

