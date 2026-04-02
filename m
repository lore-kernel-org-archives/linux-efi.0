Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950B438CFEF
	for <linux-efi@vger.kernel.org>; Thu,  2 Apr 2026 09:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775121813; cv=none; b=Z34iSqrpNq7Y/JW1nxXnGw4z9iE7KCXJ0oInms/+Mot/cnqEZnbxROaeaRiKEGcL78CY3SdDM0k0bDOVglKywFzY+puv7TNeCgsysDVCIcHXwaE6wR6O/NN0EC2LiAi7hquJS1ALKafAgwc9Oybqw8LzgtLHFenLGNP1snqpVUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775121813; c=relaxed/simple;
	bh=3/fmNuSAg0tNAaUlz1dcAL+EW3NxRusvodSTFauSPcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dcm3ewULZpf767ByJx3EDkgtUdPLyvT/jDXYtsOWsnF7EtvxJc2/Hv0+qb6qzJfjKXUZU1er3PcAg/tO2Q34Sx1E14oLO+1TBHz21Nxq/+gAZnRls0WyhTz086mtJ7/DxdTHh6cB+qdECaO20aLW7R5lCUHZl7S/cnOj2D41m6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5654A4D321;
	Thu,  2 Apr 2026 09:23:14 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C21D64A0B0;
	Thu,  2 Apr 2026 09:23:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mNc0LoE1zmlVYAAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Thu, 02 Apr 2026 09:23:13 +0000
From: Thomas Zimmermann <tzimmermann@suse.de>
To: javierm@redhat.com,
	arnd@arndb.de,
	ardb@kernel.org,
	ilias.apalodimas@linaro.org,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	longli@microsoft.com,
	deller@gmx.de
Cc: linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev,
	linux-efi@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	dri-devel@lists.freedesktop.org,
	linux-hyperv@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 6/8] firmware: sysfb: Avoid forward-declaring sysfb_parent_dev()
Date: Thu,  2 Apr 2026 11:09:20 +0200
Message-ID: <20260402092305.208728-7-tzimmermann@suse.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260402092305.208728-1-tzimmermann@suse.de>
References: <20260402092305.208728-1-tzimmermann@suse.de>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Rspamd-Queue-Id: 5654A4D321
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 

Move sysfb_parent_dev() to the top of the source file to avoid
the extra declaration. No functional changes.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
---
 drivers/firmware/sysfb_primary.c | 36 +++++++++++++++-----------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/firmware/sysfb_primary.c b/drivers/firmware/sysfb_primary.c
index 298f87a43a7e..a7f8cede60ad 100644
--- a/drivers/firmware/sysfb_primary.c
+++ b/drivers/firmware/sysfb_primary.c
@@ -42,7 +42,23 @@ static struct platform_device *pd;
 static DEFINE_MUTEX(disable_lock);
 static bool disabled;
 
-static struct device *sysfb_parent_dev(const struct screen_info *si);
+static struct device *sysfb_parent_dev(const struct screen_info *si)
+{
+	struct pci_dev *pdev;
+
+	pdev = screen_info_pci_dev(si);
+	if (IS_ERR(pdev)) {
+		return ERR_CAST(pdev);
+	} else if (pdev) {
+		if (!sysfb_pci_dev_is_enabled(pdev)) {
+			pci_dev_put(pdev);
+			return ERR_PTR(-ENODEV);
+		}
+		return &pdev->dev;
+	}
+
+	return NULL;
+}
 
 static bool sysfb_unregister(void)
 {
@@ -101,24 +117,6 @@ bool sysfb_handles_screen_info(void)
 }
 EXPORT_SYMBOL_GPL(sysfb_handles_screen_info);
 
-static struct device *sysfb_parent_dev(const struct screen_info *si)
-{
-	struct pci_dev *pdev;
-
-	pdev = screen_info_pci_dev(si);
-	if (IS_ERR(pdev)) {
-		return ERR_CAST(pdev);
-	} else if (pdev) {
-		if (!sysfb_pci_dev_is_enabled(pdev)) {
-			pci_dev_put(pdev);
-			return ERR_PTR(-ENODEV);
-		}
-		return &pdev->dev;
-	}
-
-	return NULL;
-}
-
 static __init int sysfb_init(void)
 {
 	struct sysfb_display_info *dpy = &sysfb_primary_display;
-- 
2.53.0

