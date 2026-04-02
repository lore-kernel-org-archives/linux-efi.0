Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC17138BF7F
	for <linux-efi@vger.kernel.org>; Thu,  2 Apr 2026 09:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775121805; cv=none; b=kHtuewWMKMddl0dhve4JJYQVnk8arYrtldu60OG55b9VcFK2Q/BC1m3OEoc9f17WQYZtUbC0YANlvBcLHAGrY80B9Pfzw44CMEnUfuWMfJ1fd6z4nANdegUbfdOH6ub6AQOMBa2ikdnQqybUR9aqsOOQD+01ZTtIglfYuJp5Twg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775121805; c=relaxed/simple;
	bh=X9slnzcAfbmHpf44HJPK4D517gYRCEaACDmliytblX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZX3nONcH15alD7XK6Q77+Tua6uQJm79F+2ncSNOFSxOB1oxaB/9shJcDaGnnUPBlsRTgSK8yqXJ6vE5sP3GQbwJKZpV3yiGEc8BEe6ZLTry7FMnYUDQd1/nY71Ui3CWaNz8gAeCI3yQjwr89EcYPldH34YDndsgq2iv3vHxYxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jJMW85L6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=TmSta8Q9; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jJMW85L6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=TmSta8Q9; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jJMW85L6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="TmSta8Q9";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jJMW85L6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="TmSta8Q9"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 23A704D31F;
	Thu,  2 Apr 2026 09:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775121793; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9WG64BCLvFHglN0cMHjpmGzzECnyUWzkUCDahFxcSys=;
	b=jJMW85L6Zuev5Ku6PqiWCelDmdhUYO1E19/unEgBVimu5XJ11w3MdDUdyY8w3T4zHgVybb
	wQHFXo2TsJMhAcXylgduml4BV2q3d9AnhKURc/ogQI8rL4Db2Z2TU224mxAoYVFhrQAr8u
	kemRvFL/7JlHR55b/CeShRGrjlkpc4I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775121793;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9WG64BCLvFHglN0cMHjpmGzzECnyUWzkUCDahFxcSys=;
	b=TmSta8Q9xFYRLxcUqOfGPQsjzsshXJq66lZI0DIuTTlaNZJoqfkZ5RaKeKx7GoW8ZgBNmT
	jcX9EUthHQzfltBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775121793; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9WG64BCLvFHglN0cMHjpmGzzECnyUWzkUCDahFxcSys=;
	b=jJMW85L6Zuev5Ku6PqiWCelDmdhUYO1E19/unEgBVimu5XJ11w3MdDUdyY8w3T4zHgVybb
	wQHFXo2TsJMhAcXylgduml4BV2q3d9AnhKURc/ogQI8rL4Db2Z2TU224mxAoYVFhrQAr8u
	kemRvFL/7JlHR55b/CeShRGrjlkpc4I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775121793;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9WG64BCLvFHglN0cMHjpmGzzECnyUWzkUCDahFxcSys=;
	b=TmSta8Q9xFYRLxcUqOfGPQsjzsshXJq66lZI0DIuTTlaNZJoqfkZ5RaKeKx7GoW8ZgBNmT
	jcX9EUthHQzfltBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8A79E4A0B0;
	Thu,  2 Apr 2026 09:23:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +B+kIIA1zmlVYAAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Thu, 02 Apr 2026 09:23:12 +0000
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
Subject: [PATCH 4/8] firmware: sysfb: Split sysfb.c into sysfb_primary.c and sysfb_pci.c
Date: Thu,  2 Apr 2026 11:09:18 +0200
Message-ID: <20260402092305.208728-5-tzimmermann@suse.de>
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
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.994];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email];
	RCPT_COUNT_TWELVE(0.00)[24];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[redhat.com,arndb.de,kernel.org,linaro.org,xen0n.name,linux.intel.com,gmail.com,ffwll.ch,microsoft.com,gmx.de];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLykjg6e7ifkwtw7jmpw7b9yio)];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,gmx.de]
X-Spam-Flag: NO
X-Spam-Score: -6.80
X-Spam-Level: 

Move the init code for the primary graphics device and the PCI-helpers
into separate source files. Only build the PCI helpers if CONFIG_PCI is
set. Prepares sysfb for additional PCI helpers.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
---
 drivers/firmware/Makefile                     |  7 ++++--
 drivers/firmware/sysfb.h                      | 19 ++++++++++++++
 drivers/firmware/sysfb_pci.c                  | 21 ++++++++++++++++
 drivers/firmware/{sysfb.c => sysfb_primary.c} | 25 ++-----------------
 4 files changed, 47 insertions(+), 25 deletions(-)
 create mode 100644 drivers/firmware/sysfb.h
 create mode 100644 drivers/firmware/sysfb_pci.c
 rename drivers/firmware/{sysfb.c => sysfb_primary.c} (92%)

diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
index 4ddec2820c96..5b0592c078df 100644
--- a/drivers/firmware/Makefile
+++ b/drivers/firmware/Makefile
@@ -16,13 +16,16 @@ obj-$(CONFIG_FIRMWARE_MEMMAP)	+= memmap.o
 obj-$(CONFIG_MTK_ADSP_IPC)	+= mtk-adsp-ipc.o
 obj-$(CONFIG_RASPBERRYPI_FIRMWARE) += raspberrypi.o
 obj-$(CONFIG_FW_CFG_SYSFS)	+= qemu_fw_cfg.o
-obj-$(CONFIG_SYSFB)		+= sysfb.o
-obj-$(CONFIG_SYSFB_SIMPLEFB)	+= sysfb_simplefb.o
 obj-$(CONFIG_TH1520_AON_PROTOCOL) += thead,th1520-aon.o
 obj-$(CONFIG_TI_SCI_PROTOCOL)	+= ti_sci.o
 obj-$(CONFIG_TRUSTED_FOUNDATIONS) += trusted_foundations.o
 obj-$(CONFIG_TURRIS_MOX_RWTM)	+= turris-mox-rwtm.o
 
+sysfb-y				:= sysfb_primary.o
+sysfb-$(CONFIG_PCI)		+= sysfb_pci.o
+sysfb-$(CONFIG_SYSFB_SIMPLEFB)	+= sysfb_simplefb.o
+obj-$(CONFIG_SYSFB)		+= sysfb.o
+
 obj-y				+= arm_ffa/
 obj-y				+= arm_scmi/
 obj-y				+= broadcom/
diff --git a/drivers/firmware/sysfb.h b/drivers/firmware/sysfb.h
new file mode 100644
index 000000000000..9f7fe2e03f68
--- /dev/null
+++ b/drivers/firmware/sysfb.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef FIRMWARE_SYSFB_H
+#define FIRMWARE_SYSFB_H
+
+#include <linux/types.h>
+
+struct pci_dev;
+
+#ifdef CONFIG_PCI
+bool sysfb_pci_dev_is_enabled(struct pci_dev *pdev);
+#else
+static inline bool sysfb_pci_dev_is_enabled(struct pci_dev *pdev)
+{
+	return false;
+}
+#endif
+
+#endif
diff --git a/drivers/firmware/sysfb_pci.c b/drivers/firmware/sysfb_pci.c
new file mode 100644
index 000000000000..8f3adeef4fb1
--- /dev/null
+++ b/drivers/firmware/sysfb_pci.c
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <linux/pci.h>
+
+#include "sysfb.h"
+
+bool sysfb_pci_dev_is_enabled(struct pci_dev *pdev)
+{
+	/*
+	 * TODO: Try to integrate this code into the PCI subsystem
+	 */
+	int ret;
+	u16 command;
+
+	ret = pci_read_config_word(pdev, PCI_COMMAND, &command);
+	if (ret != PCIBIOS_SUCCESSFUL)
+		return false;
+	if (!(command & PCI_COMMAND_MEMORY))
+		return false;
+	return true;
+}
diff --git a/drivers/firmware/sysfb.c b/drivers/firmware/sysfb_primary.c
similarity index 92%
rename from drivers/firmware/sysfb.c
rename to drivers/firmware/sysfb_primary.c
index 8833582c1883..ab8d7fc468bb 100644
--- a/drivers/firmware/sysfb.c
+++ b/drivers/firmware/sysfb_primary.c
@@ -35,6 +35,8 @@
 #include <linux/screen_info.h>
 #include <linux/sysfb.h>
 
+#include "sysfb.h"
+
 static struct platform_device *pd;
 static DEFINE_MUTEX(disable_lock);
 static bool disabled;
@@ -98,29 +100,6 @@ bool sysfb_handles_screen_info(void)
 }
 EXPORT_SYMBOL_GPL(sysfb_handles_screen_info);
 
-#if defined(CONFIG_PCI)
-static bool sysfb_pci_dev_is_enabled(struct pci_dev *pdev)
-{
-	/*
-	 * TODO: Try to integrate this code into the PCI subsystem
-	 */
-	int ret;
-	u16 command;
-
-	ret = pci_read_config_word(pdev, PCI_COMMAND, &command);
-	if (ret != PCIBIOS_SUCCESSFUL)
-		return false;
-	if (!(command & PCI_COMMAND_MEMORY))
-		return false;
-	return true;
-}
-#else
-static bool sysfb_pci_dev_is_enabled(struct pci_dev *pdev)
-{
-	return false;
-}
-#endif
-
 static struct device *sysfb_parent_dev(const struct screen_info *si)
 {
 	struct pci_dev *pdev;
-- 
2.53.0

