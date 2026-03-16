Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3ADA3A1D01
	for <linux-efi@vger.kernel.org>; Mon, 16 Mar 2026 15:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773675273; cv=none; b=QcwSYeCCDCpo3U2y2ktVksbWrtDoYqws2zvBQBFLVmxZRGp2NQepL9FqnY6H62BIWZpX6S6yGFPatIkk0F9Hk1qSBeeyZXhXgbsVfi8kujvGY0cHHTXKFRfkGoDDo6VG7qAcnhoxV0zJI59ZW/KqF8viOi3oDW9nXOYBk4Ycpdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773675273; c=relaxed/simple;
	bh=0jF/Skpappl8e6rE9BFwQF2Uw2riMyYj60IKPk3xg88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K2X0Cw26KS8YyvruhWtyHzFCwTU18HuvecByBBNE33SXSYSJrDVNdf1TIZCpTzUvBNQ6vSDkpdigy2+ymtWKRc3rlYce2u/E67/FRmGq6g5ovaPXL7fsZy7CIfsgbyV8cQQVdXP/KST/vRryjI6n7/HNKevgntM+vKrbcklf9TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mw+LfReC; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mw+LfReC"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-35b9d29480aso860910a91.1
        for <linux-efi@vger.kernel.org>; Mon, 16 Mar 2026 08:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773675272; x=1774280072; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D3HNVJWbjalr4X65+4J0/1uR1SNrklyVdLh0q57Y2MA=;
        b=mw+LfReCM1NkM1ZStYqvyX6Cju5EHMOnR3HZqoLOrxmRcvimxpy/0oRtOgaZZxxgNM
         EnFJDex88yUACc5vKaxgl+FD5pcNjuOW6R/3/ubiAaIIl9z29uaeKA4yO0YjH/psU26a
         nB1HTjzjDgUxa/TpoJ9hBiA72rJ+Owh0jZlITtPOFLYq/tOcoEIvkCuqFI3pSrzd4oTd
         31JdgmHV+F/kQGa7RWOFOy8iHBHLIj9emvsG+FS5xeOqQUk7g1cWl2khnLuF6p/uynuY
         Tgxwt6i7pYo8WtIjHOIsVOqXlB1I63/mgDCPTQx7YF+tDciQ7L3KNKXajFiM181j8OJf
         Ct3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773675272; x=1774280072;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D3HNVJWbjalr4X65+4J0/1uR1SNrklyVdLh0q57Y2MA=;
        b=RfvzadORO3+vQNYXpP/cKhycdvkvL6fGbE9bWPscR14fEgAmFxbLmnskGJIW1ITFUe
         9JnNRTLdgqpa0yjHUtEeq3BM+IRi3WqgR4xgJDhXxx+PPOx0BsXy8J3gNV81J8pX27kY
         ymMuYHH7ZXuBJj86qZQsE0hbhBg0D3HnDgcxcrayLk2z8J1NuHv0rOHkIDc4aBCGZADR
         f0JMojGQX65IftNzQxZ28Z1b98LqHEp1dI30ovj272NiCLYUizphtOqsbRyOQtFbjRn6
         Vcju79UWysyhXSFVS47jcW0eguXET17huD1g/LC105j+9OJsDx/GNH8vz7uFUz+AC5+8
         We9A==
X-Forwarded-Encrypted: i=1; AJvYcCVTVsHs+ZCT6xyCifSHZ3n8HIq/7cGMjM2jyBc4bjFVF2YVxuWOwwWarj0I+mP3FEiGWQMIA9NHZas=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtwTQM/R0cIMO6pG024bcX0ae2mbgZDNLOnVFNSfhIIQgNrS/5
	RTKjXVDmbnRG+TQD3cMsIfCQwEJ6OkZRa9CffgQq8iaYjYH+EQDhlbc=
X-Gm-Gg: ATEYQzyF+SsG6E/NTLxxElAtB7Nq92NIPPLD0YM0i0Hzey0E5b4f8N7ztE3x5mAqJju
	L/X6zvpBSLyXvVO6uEJQvHmrywZKTSQfccghLfuHN3CngCDdo+b14z2oFEGeARj+O6sMsgVgax7
	813iJOMt8RmfewthxifTjz14nN+JWB4BZDGqzElfaz5RRCsZdnxoR6kRfzcmOiL/vnQVX15zaGZ
	co5VBlrGvacZG6lO/2bxlabeCvVmWnoDDqTNc4HWIO3KxaNkyaDTBfLdmdBEDq3vbGM/fGwh1G1
	zqiambshRAibYMUv7ILQz+cqZm2ay6F1FwBLP2repLXrt1r9z9YMGnCGgUYicb2R7LWFYLHEm4g
	Y1e3NiZ49Br2cPqsr6yolIEt90n6mka5ZmSW7l3Q71W9ADI4XDwwoqcxXkANMKpFg4COLvbv4i5
	1PfqQohYOgZxP4v6Xgr/LtVx6aRP95Jcw1A/GOqSkPw1VHRj03qZylK8+fdExha9c=
X-Received: by 2002:a17:90b:1d88:b0:35b:9c13:30cc with SMTP id 98e67ed59e1d1-35b9c133309mr4190158a91.23.1773675271990;
        Mon, 16 Mar 2026 08:34:31 -0700 (PDT)
Received: from at-Standard-PC-Q35-ICH9-2009.. ([171.61.163.197])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35badb906c6sm2685a91.9.2026.03.16.08.34.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 08:34:31 -0700 (PDT)
From: Atharva Tiwari <atharvatiwarilinuxdev@gmail.com>
To: 
Cc: Atharva Tiwari <atharvatiwarilinuxdev@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Hans de Goede <hansg@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	linux-kernel@vger.kernel.org,
	linux-efi@vger.kernel.org,
	platform-driver-x86@vger.kernel.org
Subject: [PATCH v4 2/2] platform/apple-gmux: use apple_brightness to save brightness to EFI
Date: Mon, 16 Mar 2026 21:03:47 +0530
Message-ID: <20260316153407.1781-3-atharvatiwarilinuxdev@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260316153407.1781-1-atharvatiwarilinuxdev@gmail.com>
References: <20260316153407.1781-1-atharvatiwarilinuxdev@gmail.com>
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
index 1417e230edbd..cab3122c1a86 100644
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
+	if (IS_ENABLED(CONFIG_APPLE_BRIGHTNESS) && gmux_data->save_efi)
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

