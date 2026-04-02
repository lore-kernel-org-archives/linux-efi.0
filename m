Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0514738D6BA
	for <linux-efi@vger.kernel.org>; Thu,  2 Apr 2026 09:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775121822; cv=none; b=HVXpkETdyCsGlVTPg8Uov/o3nopFEQlpdj2aQvuQ9g+Q7ULWjdCRfZQndWYQN95XkSV3Jg95EvpdtbaeO5pfFtBj/fp7w4sGmx7DKCiH4omH1JHORM+ZYsFwJ+/VJrvh8k0PC5tsa/myoyqjyCtdnC0fl23gTkZgjefKvnM3n4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775121822; c=relaxed/simple;
	bh=JkJPwWLIYV8toDRaNAt4TvmkdF8oDTNenYKJL3mBPmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DqAy90y2lnqQ0EUWoS65eLv8d1n/swU4wRiq6o0ZpXVnsXkqnLtyxqUdaqhGbrUgXVZ2FdE19+f9VOhaGrnsKvHvWxFqsuKV2WdvUc4XJy3rpcj1IDhdKPunXaeugscv2YRRg6q9F986FpP9205IHZ+87Q+aatp4jq3qP1hS2Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E71FA4D320;
	Thu,  2 Apr 2026 09:23:14 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5DBBA4A0B1;
	Thu,  2 Apr 2026 09:23:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KHStFYI1zmlVYAAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Thu, 02 Apr 2026 09:23:14 +0000
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
Subject: [PATCH 7/8] firmware: efi: Make CONFIG_EFI_EARLYCON depend on CONFIG_SYSFB; clean up
Date: Thu,  2 Apr 2026 11:09:21 +0200
Message-ID: <20260402092305.208728-8-tzimmermann@suse.de>
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
X-Rspamd-Queue-Id: E71FA4D320
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

Efi-earlycon uses sysfb_primary_display. Therefore make it depend on
the corresponding config symbol. With this in place, go through the
source files and reduce tests to CONFIG_SYSFB. Efi-earlycon is now
just another regular user of sysfb.

This also enables the screen_info relocation feature for efi-earlycon.
Systems might move the framebuffer aperture while booting the kernel. PCI
bridges sometimes do this as part of relocating the sub-bus aperture.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
---
 arch/arm64/kernel/image-vars.h                | 2 +-
 arch/loongarch/kernel/efi.c                   | 4 ++--
 arch/loongarch/kernel/image-vars.h            | 2 +-
 arch/riscv/kernel/image-vars.h                | 2 +-
 drivers/firmware/efi/Kconfig                  | 3 ++-
 drivers/firmware/efi/efi-init.c               | 6 ++----
 drivers/firmware/efi/libstub/efi-stub-entry.c | 4 +---
 7 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index d7b0d12b1015..7e0e61385286 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -37,7 +37,7 @@ PROVIDE(__efistub__text			= _text);
 PROVIDE(__efistub__end			= _end);
 PROVIDE(__efistub___inittext_end       	= __inittext_end);
 PROVIDE(__efistub__edata		= _edata);
-#if defined(CONFIG_EFI_EARLYCON) || defined(CONFIG_SYSFB)
+#if defined(CONFIG_SYSFB)
 PROVIDE(__efistub_sysfb_primary_display	= sysfb_primary_display);
 #endif
 PROVIDE(__efistub__ctype		= _ctype);
diff --git a/arch/loongarch/kernel/efi.c b/arch/loongarch/kernel/efi.c
index 69dd83f8082f..6c25e2ecf45f 100644
--- a/arch/loongarch/kernel/efi.c
+++ b/arch/loongarch/kernel/efi.c
@@ -74,7 +74,7 @@ bool efi_poweroff_required(void)
 
 unsigned long __initdata primary_display_table = EFI_INVALID_TABLE_ADDR;
 
-#if defined(CONFIG_SYSFB) || defined(CONFIG_EFI_EARLYCON)
+#if defined(CONFIG_SYSFB)
 struct sysfb_display_info sysfb_primary_display __section(".data");
 EXPORT_SYMBOL_GPL(sysfb_primary_display);
 #endif
@@ -129,7 +129,7 @@ void __init efi_init(void)
 
 	set_bit(EFI_CONFIG_TABLES, &efi.flags);
 
-	if (IS_ENABLED(CONFIG_EFI_EARLYCON) || IS_ENABLED(CONFIG_SYSFB))
+	if (IS_ENABLED(CONFIG_SYSFB))
 		init_primary_display();
 
 	if (boot_memmap == EFI_INVALID_TABLE_ADDR)
diff --git a/arch/loongarch/kernel/image-vars.h b/arch/loongarch/kernel/image-vars.h
index e557ebd46c2b..c43f9326f344 100644
--- a/arch/loongarch/kernel/image-vars.h
+++ b/arch/loongarch/kernel/image-vars.h
@@ -11,7 +11,7 @@ __efistub_strcmp		= strcmp;
 __efistub_kernel_entry		= kernel_entry;
 __efistub_kernel_asize		= kernel_asize;
 __efistub_kernel_fsize		= kernel_fsize;
-#if defined(CONFIG_EFI_EARLYCON) || defined(CONFIG_SYSFB)
+#if defined(CONFIG_SYSFB)
 __efistub_sysfb_primary_display	= sysfb_primary_display;
 #endif
 
diff --git a/arch/riscv/kernel/image-vars.h b/arch/riscv/kernel/image-vars.h
index 3bd9d06a8b8f..3ab2529c4154 100644
--- a/arch/riscv/kernel/image-vars.h
+++ b/arch/riscv/kernel/image-vars.h
@@ -28,7 +28,7 @@ __efistub__start_kernel		= _start_kernel;
 __efistub__end			= _end;
 __efistub__edata		= _edata;
 __efistub___init_text_end	= __init_text_end;
-#if defined(CONFIG_EFI_EARLYCON) || defined(CONFIG_SYSFB)
+#if defined(CONFIG_SYSFB)
 __efistub_sysfb_primary_display	= sysfb_primary_display;
 #endif
 
diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 29e0729299f5..925ded080eb4 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -219,8 +219,9 @@ config EFI_DISABLE_PCI_DMA
 config EFI_EARLYCON
 	def_bool y
 	depends on SERIAL_EARLYCON && !ARM
-	select FONT_SUPPORT
+	depends on SYSFB
 	select ARCH_USE_MEMREMAP_PROT
+	select FONT_SUPPORT
 
 config EFI_CUSTOM_SSDT_OVERLAYS
 	bool "Load custom ACPI SSDT overlay from an EFI variable"
diff --git a/drivers/firmware/efi/efi-init.c b/drivers/firmware/efi/efi-init.c
index 6103b1a082d2..002518b642ed 100644
--- a/drivers/firmware/efi/efi-init.c
+++ b/drivers/firmware/efi/efi-init.c
@@ -60,7 +60,7 @@ extern __weak const efi_config_table_type_t efi_arch_tables[];
  * x86 defines its own instance of sysfb_primary_display and uses
  * it even without EFI, everything else can get them from here.
  */
-#if !defined(CONFIG_X86) && (defined(CONFIG_SYSFB) || defined(CONFIG_EFI_EARLYCON) || defined(CONFIG_FIRMWARE_EDID))
+#if !defined(CONFIG_X86) && (defined(CONFIG_SYSFB) || defined(CONFIG_FIRMWARE_EDID))
 struct sysfb_display_info sysfb_primary_display __section(".data");
 EXPORT_SYMBOL_GPL(sysfb_primary_display);
 #endif
@@ -271,8 +271,6 @@ void __init efi_init(void)
 	memblock_reserve(data.phys_map & PAGE_MASK,
 			 PAGE_ALIGN(data.size + (data.phys_map & ~PAGE_MASK)));
 
-	if (IS_ENABLED(CONFIG_X86) ||
-	    IS_ENABLED(CONFIG_SYSFB) ||
-	    IS_ENABLED(CONFIG_EFI_EARLYCON))
+	if (IS_ENABLED(CONFIG_X86) || IS_ENABLED(CONFIG_SYSFB))
 		init_primary_display();
 }
diff --git a/drivers/firmware/efi/libstub/efi-stub-entry.c b/drivers/firmware/efi/libstub/efi-stub-entry.c
index aa85e910fe59..214fa4d84df0 100644
--- a/drivers/firmware/efi/libstub/efi-stub-entry.c
+++ b/drivers/firmware/efi/libstub/efi-stub-entry.c
@@ -19,9 +19,7 @@ struct sysfb_display_info *alloc_primary_display(void)
 	if (IS_ENABLED(CONFIG_ARM))
 		return __alloc_primary_display();
 
-	if (IS_ENABLED(CONFIG_X86) ||
-	    IS_ENABLED(CONFIG_EFI_EARLYCON) ||
-	    IS_ENABLED(CONFIG_SYSFB))
+	if (IS_ENABLED(CONFIG_X86) || IS_ENABLED(CONFIG_SYSFB))
 		return kernel_image_addr(&sysfb_primary_display);
 
 	return NULL;
-- 
2.53.0

