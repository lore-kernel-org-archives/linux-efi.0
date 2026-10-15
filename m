Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3252C08BB
	for <linux-efi@vger.kernel.org>; Thu, 15 Oct 2026 06:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792047092; cv=none; b=j3j5qqm4OSBPbG/C5pDM789JnLc4oagjB0KqbJGpCMpcLCjX6nIO/zyte/76eZKTjcFOUk/t8p/SCklLdk+ponSaSS2S1M4EH+3GWqgpV0WrAAuLdauiUDs9kccZl5c98pBoREpZBzdqqLB5p5UHBsqAIAgWPfPEth9CZTmv/O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792047092; c=relaxed/simple;
	bh=v9FWiBQyex4yMdGMFqwXZycre1xINDX1f0rFme2RGK0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eXJ/gtEt/5KokRV7jCPPpvtgE8NGuPn6u6M3RmN13aX/Vi5UQS1YL8ndWX8q9rV3VYNVVnzWyFaXUGlSWZmtWsz1yrOMuL1+A50r2Fgq9AOawF20wKSbrQ9V45Rd7k72ju5pliTFzn8ekY/Ahkoz+dxggZUVDupnOabdeE9gmB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RZH//eOS; arc=none smtp.client-ip=209.85.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RZH//eOS"
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a1895ffc83so37690185e9.3
        for <linux-efi@vger.kernel.org>; Wed, 14 Oct 2026 23:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792047086; x=1792651886; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZTiqboVndDEbmLd8LVG+Pz+y8XQQsMVuAnnOvtiYq+A=;
        b=RZH//eOS5xUpbncqrlCmMvytMj2yrIPBIywRGbIqi/m2oBKueowgbD/kiVaHwEZezH
         70Qvf8pKF1Zu34jnlFJiAcaM3oCOJ9FYEcvLgaD13ze42sfBvYccm6orY9HSEd/5vhty
         eMU/bc4nSJ7APjWSI3fYVk8L7YRdcb6sdt2/YsT0m/iX5RWsknsHMsHSnmpXq3K32oH9
         C1S+VLAwdPA32WPqnpsEcNd2nCchtPg534Hf6NrTT3aGoXkId741j7cM4v3c+RY81B5v
         EyqTX9oZXQIWGKTtXUGLoEgaEVSp50YWjDEWtILcVXEPQFORbCDEvj4PeyAxAvHmjIam
         XddQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792047086; x=1792651886;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZTiqboVndDEbmLd8LVG+Pz+y8XQQsMVuAnnOvtiYq+A=;
        b=AYyXYSdHi8rfCrEX5aiKX3lWRR8uAm52MEvsMaGTvMf5WUXuZVD8XWCpbWxM4BlETo
         cZsvMvysGWrb14Ujf7te65Om2jnTuA3o9NYqiEM9FN2fHwyxTcys2mOZAbmlb/+r/DRt
         N9Ogjfk1O0KOvvhgI2dKiIooMPRho04jP/mdvScuVFWMsKrxDfQ/hzvoC+2/NwRE39Fa
         TiKuxq0JAQAXx43/baeZ3J6ax3lBUni3H/7pScxST4t7tKRTMjecFr6zzg94AL5lr6WQ
         jj5pOmOLLncLTX5i/qaCxQDQHbS4YZ5J8e89UXCDmOkzX2rcAbBTW8LVQJpsotT7RYwA
         te2Q==
X-Gm-Message-State: AFq9FYLERLcUs8osejdnRa4Mz9loQk5nyxsZWudb8CmGG0Uk7eznk0NJ
	8PJ3mSpJbBA2EXOFjuwiS0eruWfGCG7OQn1aatQRX/qIgCOIrfhPFwoiJZPS44MQGujrhCw5zdc
	nlIAPrYdRRYLlxKey9QUPWeKEg/h0PK8IqC2IiAbeL72ppu7d/rNxfvN/g44gwKrc3NUdIHP9G4
	WCZqu/gofTxt/oMm2uJCKj4JGQwdpd5Q==
X-Received: from wrmh14.prod.google.com ([2002:adf:e98e:0:b0:48d:f7ef:7219])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:6994:b0:49c:dada:30b7
 with SMTP id 5b1f17b1804b1-4a18e446f3bmr358870095e9.2.1792047085661; Wed, 14
 Oct 2026 23:51:25 -0700 (PDT)
Date: Thu, 15 Oct 2026 08:51:19 +0200
In-Reply-To: <20261015065116.3365029-5-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261015065116.3365029-5-ardb+git@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261015065116.3365029-7-ardb+git@google.com>
Subject: [PATCH 2/3] efi: Retain the address of the LINUX_EFI_MEMRESERVE table
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The physical address of the LINUX_EFI_MEMRESERVE configuration table is
only kept in __initdata, but a kexec loader that runs the incoming
kernel's EFI stub needs it in order to pass the table on, so that the
persistent memory reservations made by this kernel and its predecessors
(e.g., for the GICv3 LPI tables) are carried over.

So move it into struct efi, alongside the addresses of the other EFI
configuration tables that may be passed on in this way.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/efi.c | 12 ++++++------
 include/linux/efi.h        |  1 +
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index b4504542cb2c..14b9c7ebb5df 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -46,6 +46,7 @@ struct efi __read_mostly efi = {
 	.tpm_log		= EFI_INVALID_TABLE_ADDR,
 	.tpm_final_log		= EFI_INVALID_TABLE_ADDR,
 	.ovmf_debug_log         = EFI_INVALID_TABLE_ADDR,
+	.mem_reserve		= EFI_INVALID_TABLE_ADDR,
 #ifdef CONFIG_LOAD_UEFI_KEYS
 	.mokvar_table		= EFI_INVALID_TABLE_ADDR,
 #endif
@@ -59,7 +60,6 @@ struct efi __read_mostly efi = {
 EXPORT_SYMBOL(efi);
 
 unsigned long __ro_after_init efi_rng_seed = EFI_INVALID_TABLE_ADDR;
-static unsigned long __initdata mem_reserve = EFI_INVALID_TABLE_ADDR;
 static unsigned long __initdata rt_prop = EFI_INVALID_TABLE_ADDR;
 static unsigned long __initdata initrd = EFI_INVALID_TABLE_ADDR;
 
@@ -663,7 +663,7 @@ static const efi_config_table_type_t common_tables[] __initconst = {
 	{LINUX_EFI_TPM_EVENT_LOG_GUID,		&efi.tpm_log,		"TPMEventLog"	},
 	{EFI_TCG2_FINAL_EVENTS_TABLE_GUID,	&efi.tpm_final_log,	"TPMFinalLog"	},
 	{EFI_CC_FINAL_EVENTS_TABLE_GUID,	&efi.tpm_final_log,	"CCFinalLog"	},
-	{LINUX_EFI_MEMRESERVE_TABLE_GUID,	&mem_reserve,		"MEMRESERVE"	},
+	{LINUX_EFI_MEMRESERVE_TABLE_GUID,	&efi.mem_reserve,	"MEMRESERVE"	},
 	{LINUX_EFI_INITRD_MEDIA_GUID,		&initrd,		"INITRD"	},
 	{EFI_RT_PROPERTIES_TABLE_GUID,		&rt_prop,		"RTPROP"	},
 #ifdef CONFIG_OVMF_DEBUG_LOG
@@ -806,8 +806,8 @@ int __init efi_config_parse_tables(const efi_config_table_t *config_tables,
 
 	efi_tpm_eventlog_init();
 
-	if (mem_reserve != EFI_INVALID_TABLE_ADDR) {
-		unsigned long prsv = mem_reserve;
+	if (efi.mem_reserve != EFI_INVALID_TABLE_ADDR) {
+		unsigned long prsv = efi.mem_reserve;
 
 		while (prsv) {
 			struct linux_efi_memreserve *rsv;
@@ -1094,10 +1094,10 @@ static struct linux_efi_memreserve *efi_memreserve_root __ro_after_init;
 
 static int __init efi_memreserve_map_root(void)
 {
-	if (mem_reserve == EFI_INVALID_TABLE_ADDR)
+	if (efi.mem_reserve == EFI_INVALID_TABLE_ADDR)
 		return -ENODEV;
 
-	efi_memreserve_root = memremap(mem_reserve,
+	efi_memreserve_root = memremap(efi.mem_reserve,
 				       sizeof(*efi_memreserve_root),
 				       MEMREMAP_WB);
 	if (WARN_ON_ONCE(!efi_memreserve_root))
diff --git a/include/linux/efi.h b/include/linux/efi.h
index fda81d7c4850..cd8728702e93 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -650,6 +650,7 @@ extern struct efi {
 	unsigned long			mokvar_table;		/* MOK variable config table */
 	unsigned long			coco_secret;		/* Confidential computing secret table */
 	unsigned long			unaccepted;		/* Unaccepted memory table */
+	unsigned long			mem_reserve;		/* Persistent memory reservations */
 
 	efi_get_time_t			*get_time;
 	efi_set_time_t			*set_time;
-- 
2.56.0.385.gd3acb90ef8-goog

