Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F65C2517A5
	for <linux-efi@vger.kernel.org>; Sun, 15 Mar 2026 22:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773613246; cv=none; b=FGV1Vgmui/qbwI/OOT94YnQhQ1dsQKnpOdFSkE+NNAi18XD+W9WWSf/xUNFMHd7+8izjhkqo/9stNk2TSACJm8pyzZvgfCfyKJ0VTj6MfW66CywqhYK4RZISFHDDwqnUEffLgYg065SsnmfRrq8kAzkoLdBenzcZ5e+mbdg4Wac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773613246; c=relaxed/simple;
	bh=oOvWfhRkf5OBj5wu+oQpsajq+P1fnPHlOTGZkcFTyGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DEaIoRka16hIgW++cAH0webpQoFigq98eVHLbADuXqFJV7vUuTdrXlKgJYh+ojr7/P7psRCdiDBqI3bOzEWqe25jcj9xyExB5fJLDxHRVbh8cAAeqawcNn3HajRR443K2uEzJoO6H3aQVb2xnR/egkz3QXCFyzlw8uG4+v5HdA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aiGavZC0; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aiGavZC0"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-35b905e9dc0so585809a91.3
        for <linux-efi@vger.kernel.org>; Sun, 15 Mar 2026 15:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773613244; x=1774218044; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=svmo5aWxoEnBP2787XF4CmgcR+jwYxqJJ3ujEK+SovQ=;
        b=aiGavZC0i0mBJJnIkR8/OnHudd2BQJlKMd6ZqUNKEhpenswrdhKP2RDo1RIfkYS5hm
         pGfdiRmuixRkxe7zCZMTHxEqM8Koa3MCOodoHW6MdpQFTmhj8cJT9O7+hmopNC9Vz4SF
         8/i8X7knRuLFmGvH8DacsOs5YoX0Y/ePe0My5O9v46/MkqvSyCEfzlHRBoId4H505Edy
         V2V7QRK1SshdMMuRBvKSW0auBQQFWnUuwDD+q4RB6xeS4YFs1GEOtUCLLphSD59jdB7d
         5BN8DQEt23nQIxRHTPjwv30HbFsu9ysfkcpX8iNVImkgyzpEG0tNilN6p9+dJMwoQ22R
         Gfrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773613244; x=1774218044;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=svmo5aWxoEnBP2787XF4CmgcR+jwYxqJJ3ujEK+SovQ=;
        b=IT5vEiRrfxlfC/Q9g+vvCEAT8pjg9Srcjo3wHzhbulbpkMVXVmQKHkMK036/7UDDGY
         4KQGK3xBa30knZhniD0tNNcLVmqAJUWbqaH5DekcQ1p8rDHfwFDwDb0EtBr++3AEgMm1
         0l9bfS1VL1sGJD7nCb+46O6fPI0idRJKwOGErSJhWX4zxhiJzu8s1+ajuvgbOpgw4S5l
         iRi2N4MeSnNsvhrZWdQo903yMn055NRa5C8/atK6jkSlAyuYZ4FCEBdPs7ictKHb8CJ7
         Bf2ZysLbcyCBtIlRiFyAWD3dfN08XVB4CyRaZcgnmu57zcPH/3MVQUpd8jdbOfKyBWnG
         jzHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVAcJSTeGag+RYLjpNf6ko9QadwYyqRlfTRiLjgLoJk3TS3ygNozb2zCPMI0t09wnKWvMwVzpn5uYE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxIh6JKgUtrO2pVQ5TvneEI4l2Zake0cb4zseanOFmrRhR37hP
	OKjbyBVmUn9MbHEDESMud41iZlDXwWZZbznTNzsxLwMVxtMqThwnp3M=
X-Gm-Gg: ATEYQzy91HK4ey8RZ/mov94R8ODP2w2ftmp54oLds6Nmd8plaQ/xP6Me0AtKXMQTtC7
	/mvAXp0KTphXKZZsKhhmJ4oZXmtiNNI/TR2e3Op+WbDqwsYzEB9wNXjQCNVG1aqsPzPV5cGtr3A
	HNqgkXnNPd+Hh018ZbzlonbvD66JGerqopBCTPwDf5NZlNS1dHgEY9IikAElPS2QG/ONfnRJvsg
	zA7Coa6JjDbT8FVJW/4bKe8qGQUP7bJ+h3wkWXOuimT1BddjIskZ7ctpyMFtmD582nbdB68HFOJ
	gqJYJKFjMGZ00mOHlpdT2Vd8GWj/rJwMurDi+WyO4hYKYAa5bU0vr9mYrnB8EwuqD3lff6CMxEE
	oMl/SgWskqQwg5EKYuiMnSSAV2JYOvwUkswV/WPXvBnhEr8zJs/bW4XReaAhxu4WnCYUnzGFSQe
	/hLhs84q7PwGWaE2tvvu+NCXpusexyrhwBkpt0dzZyF/0PSXLOb07mKypbgceSBdk=
X-Received: by 2002:a17:90b:4e84:b0:35b:9d0c:a2f5 with SMTP id 98e67ed59e1d1-35b9d0cb646mr1425497a91.33.1773613244590;
        Sun, 15 Mar 2026 15:20:44 -0700 (PDT)
Received: from at-Standard-PC-Q35-ICH9-2009.. ([171.61.163.197])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35b98f0e5a6sm2547141a91.5.2026.03.15.15.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2026 15:20:44 -0700 (PDT)
From: Atharva Tiwari <atharvatiwarilinuxdev@gmail.com>
To: 
Cc: Atharva Tiwari <atharvatiwarilinuxdev@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Hans de Goede <hansg@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	linux-kernel@vger.kernel.org (open list),
	linux-efi@vger.kernel.org (open list:EXTENSIBLE FIRMWARE INTERFACE (EFI)),
	platform-driver-x86@vger.kernel.org (open list:X86 PLATFORM DRIVERS)
Subject: [PATCH v3 2/2] platform/apple-gmux: use apple_brightness to save brightness to EFI
Date: Mon, 16 Mar 2026 03:50:00 +0530
Message-ID: <20260315222020.24341-3-atharvatiwarilinuxdev@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260315222020.24341-1-atharvatiwarilinuxdev@gmail.com>
References: <20260315222020.24341-1-atharvatiwarilinuxdev@gmail.com>
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
index 1417e230edbd..3797a0e7ff40 100644
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
+		else
+			gmux_data->save_efi = true;
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

