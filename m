Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794839252;
	b=chxTIo5dGROhv6/lI0g2bJgdk+ZKuoVTax2XdBxy8Lvju71IDIiIn7MQV9us8ZpCawX6
	 Gyn9MqQMAtnlY8gmidF0lM0bjX+dC5IjCPx7+zDZ6pbXtxQO9Z1S1z/6jfirEJdzWBVIm
	 TvWwMdwZR2eZsR3yA+uCQwytWqMv8bvQoguNKnRNPyShqrlfNaqQxKq4jRM6ITJMhQSUr
	 vTdJNrE7Ip8QInMUhMc7HDN5oLCBlPn6TslV257OuTQbYqDEMDLcBjD4Ukkp6n7eL1YAJ
	 /0c4H3ru+DofP4edw9BPlG1bLq+9EChYanulXd/hiw57oEs4kSZ4GrhajR6OLnUxwmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794839252;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=ejZnVuNimtCRP60C5uPXzWOHplpMKFHolsAVCAKw/GY=;
	b=VL7UoIpcv0/Zeebf6Ek1lpyb8r66KmdFLSbCGTLHOP5qT7GNkOu70WhfwsK8yUGBZ55i
	 pQhpOV+IbY2Pz5vAtq6FvSgr8xYQCx7jbZi1mC1Qp4FbYewq4aPln8Tg3F8BbNJGSNkDm
	 DOOWLZa4f09nhFhonwtHTyMSCel3YXuQmoKd6Ts9wcq8vp8d7izHR7yGWSi4TaVWIXKUE
	 53tuw4yaGd74nTlNWc3602OYqLvT0eIhzgUjmK8l9ueDAmTV6NqGQHEKBC13oShtBezcZ
	 Pop2BW0/RWCORdLldWmPkSaOO+kwFGqfTTLYBN0d5DRkyCtI8V/pPgOgFd1q2RBVF5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="p/a705Ym";
	arc=none smtp.remote-ip=209.85.128.72
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7FC606A323
	for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 14:27:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB7FC606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=p/a705Ym
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a16dc2323cso27105455e9.3
        for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 06:27:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794839250; x=1795444050; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ejZnVuNimtCRP60C5uPXzWOHplpMKFHolsAVCAKw/GY=;
        b=p/a705YmySAeKqwIJJc/g869l4Rk2b01p8J8gSEFwThaDJ0CESVcjT41ccFxKTSc5+
         NlymxyqAuxM9FJ6vUaOTCOfzUHqB9FxQoI+YSw3K7R5o1X4+h8xszuqaDnKBwRlGtp2q
         gUzY4kcqE5CAGeTcAYKW+G5nXMbAGxhkdVGcahFMCJycjYyN7bqGXWhDHJvFXDbBVQgF
         JGmi87DXODhozqYfcSrLj4g6f67yPArCrB7IWzUx0dLtdYojx4QwVBkaZEMtZaN70EDl
         yFQqhPmTBsI+wxnkYRCfqQGvB1LLPfEU2mzTj73MnmqmNCctKPqzQKgYuUOfs1mTOvU6
         MAWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794839250; x=1795444050;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ejZnVuNimtCRP60C5uPXzWOHplpMKFHolsAVCAKw/GY=;
        b=Y/ZIBxNmKa/O8SVX0trU0lV8z2Elb8SQQQ/NJ1SnX5eBStdKMqzAq51NEgXCI4cnZo
         ZOR06fcNO9N+TDIvYPuk2aXDPahShzWy9vz3ddI/f9x68IhXAMilP7O10PKtWDenLhrO
         IganBar6JnuZ/fxv2hGOyM4uO3qIn/7U/TpGDRa7aMfTLjetrt08Jp6qy/ODzH5ULlXj
         WoiA9+I8E/2Kbh7TAd+G6zGyetqvR0SmTFtz/Ln9yhpXBAV8i5+JJxWrlEct2TKSZll6
         NoIUbd2rlE+n7HmOhSIqeIIpxLfnd0OAvjXMCgP4oYvLV7oNTl/d8AJbtoeoNsF23072
         Wlbw==
X-Gm-Message-State: APuU4Z9FMhiuLDMcy84iEk5XEr/BUbmugCKbeA/qKBlZ/J9pSzmtF5IC
	imnhREokpARNSY4BPtBEfvbOvkSaP96XnGpcB9pjkcIHGGV5QRUbR2Zc7tXz6ssnU2yBKERYmCK
	yn9HFa+W2sMZtoVgTPYzMPCUmZNeI4ItG5KtYXWChyQ67MELGGukEpqPeOiKsJy2IHmOyIO4ebB
	6gFmXWRpNDO6Fq0HNCZHsQ49xrbeFedQ==
X-Received: from wrvi15.prod.google.com ([2002:a5d:558f:0:b0:49e:3982:e207])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:428c:b0:4a1:9661:14b5
 with SMTP id 5b1f17b1804b1-4bb55aabd53mr146589725e9.29.1794839249781; Mon, 16
 Nov 2026 06:27:29 -0800 (PST)
Date: Mon, 16 Nov 2026 15:26:33 +0100
In-Reply-To: <20261116142618.1687025-17-ardb+git@google.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261116142618.1687025-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=15020; i=ardb@kernel.org;
 h=from:subject; bh=VTBYBWRInBkK5quxaQIoA7yuidxjsODZKTnWVxzwDAg=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIeu30Ly+I48OpGvfr6l/8bBEztO7lzHB3rDn/B7N+w/jn
 TL+LXvTUcrCIMbFICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACZyhZvhr+yTbyu+q6S3ZHRe
 sY5p4Z606N3nozv2vdloX9cpfGjBrPsMv9llns0TFn/wo+57vNjUqMrSt9qzfZZXuKSftL4Z/HL aZg4A
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
Message-ID: <20261116142618.1687025-31-ardb+git@google.com>
Subject: [PATCH v3 14/15] efi: Make config table based primary display
 handover ARM-only again
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ardb@kernel.org>, 
	Jason Gunthorpe <jgg@nvidia.com>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

This reverts the effect of commit 732ea9db9d8a ("efi: libstub: Move
screen_info handling to common code"), taking into account the changes
that were made to the code since.

That commit moved all architectures to the ARM approach of passing the
primary display information (formerly struct screen_info) from the EFI
stub to the core kernel via an EFI configuration table, so that the zboot
decompressor, which is not linked into the core kernel image, could pass
this information as well.

Now that the EFI stub and the zboot decompressor both have access to the
location of sysfb_primary_display inside the loaded kernel image via
struct efi_image_info, they can populate it directly, and the
configuration table is only needed on ARM, whose decompressor has no
such information.

So make the configuration table based handover ARM-only again:
- move the config table based alloc/free routines into the ARM stub,
  and provide __weak defaults in the generic stub that return a pointer
  to the kernel image's copy of sysfb_primary_display;
- drop the primary display table from the common config table list,
  and move the code that copies it into sysfb_primary_display into the
  ARM arch code;
- on the other architectures, revert to simply reserving the
  framebuffer memory if the stub populated sysfb_primary_display.

This makes the EFI framebuffer earlycon available right away when booting
via zboot, rather than only after the EFI config tables have been parsed.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/kernel/efi.c                          | 27 ++++++++++
 arch/loongarch/kernel/efi.c                    | 20 ++-----
 drivers/firmware/efi/efi-init.c                | 24 ++-------
 drivers/firmware/efi/efi.c                     |  5 --
 drivers/firmware/efi/libstub/Makefile          |  2 +-
 drivers/firmware/efi/libstub/arm32-stub.c      | 41 ++++++++++++++
 drivers/firmware/efi/libstub/efi-stub-entry.c  | 13 -----
 drivers/firmware/efi/libstub/efi-stub.c        | 14 +++++
 drivers/firmware/efi/libstub/efistub.h         |  1 -
 drivers/firmware/efi/libstub/primary_display.c | 56 --------------------
 drivers/firmware/efi/libstub/zboot.c           |  6 ---
 11 files changed, 90 insertions(+), 119 deletions(-)

diff --git a/arch/arm/kernel/efi.c b/arch/arm/kernel/efi.c
index c14275257a8a..84d516b84848 100644
--- a/arch/arm/kernel/efi.c
+++ b/arch/arm/kernel/efi.c
@@ -7,6 +7,7 @@
 #include <linux/memblock.h>
 #include <linux/screen_info.h>
 #include <linux/sizes.h>
+#include <linux/sysfb.h>
 
 #include <asm/efi.h>
 #include <asm/mach/map.h>
@@ -91,13 +92,36 @@ int __init efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md)
 	return 0;
 }
 
+static unsigned long __initdata primary_display_table = EFI_INVALID_TABLE_ADDR;
 static unsigned long __initdata cpu_state_table = EFI_INVALID_TABLE_ADDR;
 
 const efi_config_table_type_t efi_arch_tables[] __initconst = {
+	{LINUX_EFI_PRIMARY_DISPLAY_TABLE_GUID, &primary_display_table},
 	{LINUX_EFI_ARM_CPU_STATE_TABLE_GUID, &cpu_state_table},
 	{}
 };
 
+static void __init load_primary_display_table(void)
+{
+	struct sysfb_display_info *dpy;
+
+	if (primary_display_table == EFI_INVALID_TABLE_ADDR)
+		return;
+
+	dpy = early_memremap(primary_display_table, sizeof(*dpy));
+	if (!dpy) {
+		pr_err("Could not map primary_display config table\n");
+		return;
+	}
+	sysfb_primary_display = *dpy;
+	memset(dpy, 0, sizeof(*dpy));
+	early_memunmap(dpy, sizeof(*dpy));
+
+	if (memblock_is_map_memory(sysfb_primary_display.screen.lfb_base))
+		memblock_mark_nomap(sysfb_primary_display.screen.lfb_base,
+				    sysfb_primary_display.screen.lfb_size);
+}
+
 static void __init load_cpu_state_table(void)
 {
 	if (cpu_state_table != EFI_INVALID_TABLE_ADDR) {
@@ -136,6 +160,9 @@ void __init arm_efi_init(void)
 {
 	efi_init();
 
+	if (IS_ENABLED(CONFIG_SYSFB) || IS_ENABLED(CONFIG_FIRMWARE_EDID))
+		load_primary_display_table();
+
 	/* ARM does not permit early mappings to persist across paging_init() */
 	efi_memmap_unmap();
 
diff --git a/arch/loongarch/kernel/efi.c b/arch/loongarch/kernel/efi.c
index 69dd83f8082f..c914aabcd282 100644
--- a/arch/loongarch/kernel/efi.c
+++ b/arch/loongarch/kernel/efi.c
@@ -72,8 +72,6 @@ bool efi_poweroff_required(void)
 		(acpi_gbl_reduced_hardware || acpi_no_s5);
 }
 
-unsigned long __initdata primary_display_table = EFI_INVALID_TABLE_ADDR;
-
 #if defined(CONFIG_SYSFB) || defined(CONFIG_EFI_EARLYCON)
 struct sysfb_display_info sysfb_primary_display __section(".data");
 EXPORT_SYMBOL_GPL(sysfb_primary_display);
@@ -81,22 +79,10 @@ EXPORT_SYMBOL_GPL(sysfb_primary_display);
 
 static void __init init_primary_display(void)
 {
-	struct sysfb_display_info *dpy;
-
-	if (primary_display_table == EFI_INVALID_TABLE_ADDR)
-		return;
-
-	dpy = early_memremap(primary_display_table, sizeof(*dpy));
-	if (!dpy) {
-		pr_err("Could not map primary_display config table\n");
-		return;
-	}
-	sysfb_primary_display = *dpy;
-	memset(dpy, 0, sizeof(*dpy));
-	early_memunmap(dpy, sizeof(*dpy));
+	struct screen_info *si = &sysfb_primary_display.screen;
 
-	memblock_reserve(__screen_info_lfb_base(&sysfb_primary_display.screen),
-			 sysfb_primary_display.screen.lfb_size);
+	if (si->orig_video_isVGA == VIDEO_TYPE_EFI)
+		memblock_reserve(__screen_info_lfb_base(si), si->lfb_size);
 }
 
 void __init efi_init(void)
diff --git a/drivers/firmware/efi/efi-init.c b/drivers/firmware/efi/efi-init.c
index 9f09b0d2daa0..25a5497ebb2e 100644
--- a/drivers/firmware/efi/efi-init.c
+++ b/drivers/firmware/efi/efi-init.c
@@ -23,8 +23,6 @@
 
 #include <asm/efi.h>
 
-unsigned long __initdata primary_display_table = EFI_INVALID_TABLE_ADDR;
-
 static int __init is_memory(efi_memory_desc_t *md)
 {
 	if (md->attribute & (EFI_MEMORY_WB|EFI_MEMORY_WT|EFI_MEMORY_WC))
@@ -67,25 +65,11 @@ EXPORT_SYMBOL_GPL(sysfb_primary_display);
 
 static void __init init_primary_display(void)
 {
-	struct sysfb_display_info *dpy;
-
-	if (primary_display_table != EFI_INVALID_TABLE_ADDR) {
-		dpy = early_memremap(primary_display_table, sizeof(*dpy));
-		if (!dpy) {
-			pr_err("Could not map primary_display config table\n");
-			return;
-		}
-		sysfb_primary_display = *dpy;
-		memset(dpy, 0, sizeof(*dpy));
-		early_memunmap(dpy, sizeof(*dpy));
+	struct screen_info *si = &sysfb_primary_display.screen;
 
-		if (memblock_is_map_memory(sysfb_primary_display.screen.lfb_base))
-			memblock_mark_nomap(sysfb_primary_display.screen.lfb_base,
-					    sysfb_primary_display.screen.lfb_size);
-
-		if (IS_ENABLED(CONFIG_EFI_EARLYCON))
-			efi_earlycon_reprobe();
-	}
+	if (si->orig_video_isVGA == VIDEO_TYPE_EFI &&
+	    memblock_is_map_memory(si->lfb_base))
+		memblock_mark_nomap(si->lfb_base, si->lfb_size);
 }
 
 static int __init uefi_init(u64 efi_system_table)
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 9bc22de0d67e..90c421211ddc 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -57,8 +57,6 @@ unsigned long __ro_after_init efi_rng_seed = EFI_INVALID_TABLE_ADDR;
 static unsigned long __initdata rt_prop = EFI_INVALID_TABLE_ADDR;
 static unsigned long __initdata initrd = EFI_INVALID_TABLE_ADDR;
 
-extern unsigned long primary_display_table;
-
 struct mm_struct efi_mm = {
 	.mm_mt			= MTREE_INIT_EXT(mm_mt, MM_MT_FLAGS, efi_mm.mmap_lock),
 	.mm_users		= ATOMIC_INIT(2),
@@ -674,9 +672,6 @@ static const efi_config_table_type_t common_tables[] __initconst = {
 #endif
 #ifdef CONFIG_UNACCEPTED_MEMORY
 	{LINUX_EFI_UNACCEPTED_MEM_TABLE_GUID,	&efi.unaccepted,	"Unaccepted"	},
-#endif
-#ifdef CONFIG_EFI_GENERIC_STUB
-	{LINUX_EFI_PRIMARY_DISPLAY_TABLE_GUID,	&primary_display_table			},
 #endif
 	{},
 };
diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 9dc6a707fd79..0c5fbc21d2a2 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -81,7 +81,7 @@ $(obj)/lib-%.o: $(srctree)/lib/%.c FORCE
 	$(call if_changed_rule,cc_o_c)
 
 lib-$(CONFIG_EFI_GENERIC_STUB)	+= efi-stub.o string.o intrinsics.o systable.o \
-				   primary_display.o efi-stub-entry.o
+				   efi-stub-entry.o
 
 lib-$(CONFIG_ARM)		+= arm32-stub.o
 lib-$(CONFIG_ARM64)		+= kaslr.o arm64.o arm64-stub.o smbios.o
diff --git a/drivers/firmware/efi/libstub/arm32-stub.c b/drivers/firmware/efi/libstub/arm32-stub.c
index b73a0b4fcd10..5e6c0de168f4 100644
--- a/drivers/firmware/efi/libstub/arm32-stub.c
+++ b/drivers/firmware/efi/libstub/arm32-stub.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2013 Linaro Ltd;  <roy.franz@linaro.org>
  */
 #include <linux/efi.h>
+#include <linux/sysfb.h>
 #include <asm/efi.h>
 
 #include "efistub.h"
@@ -76,6 +77,46 @@ void efi_handle_post_ebs_state(void)
 		      &efi_entry_state->sctlr_after_ebs);
 }
 
+static efi_guid_t primary_display_guid = LINUX_EFI_PRIMARY_DISPLAY_TABLE_GUID;
+
+struct sysfb_display_info *
+alloc_primary_display(const struct efi_image_info *image_info)
+{
+	struct sysfb_display_info *dpy;
+	efi_status_t status;
+
+	/*
+	 * Unlike on other architectures, where we can directly fill out the
+	 * sysfb_primary_display structure in the loaded kernel image, we need
+	 * to allocate a buffer to hold its contents while we hand over to the
+	 * kernel proper from the decompressor.
+	 */
+	status = efi_bs_call(allocate_pool, EFI_ACPI_RECLAIM_MEMORY,
+			     sizeof(*dpy), (void **)&dpy);
+
+	if (status != EFI_SUCCESS)
+		return NULL;
+
+	memset(dpy, 0, sizeof(*dpy));
+
+	status = efi_bs_call(install_configuration_table,
+			     &primary_display_guid, dpy);
+	if (status == EFI_SUCCESS)
+		return dpy;
+
+	efi_bs_call(free_pool, dpy);
+	return NULL;
+}
+
+void free_primary_display(struct sysfb_display_info *dpy)
+{
+	if (!dpy)
+		return;
+
+	efi_bs_call(install_configuration_table, &primary_display_guid, NULL);
+	efi_bs_call(free_pool, dpy);
+}
+
 struct efi_image_info efistub_image_info = {};
 
 efi_status_t handle_kernel_image(unsigned long *image_addr,
diff --git a/drivers/firmware/efi/libstub/efi-stub-entry.c b/drivers/firmware/efi/libstub/efi-stub-entry.c
index 36ea6aa2cfcc..fb1a4a175717 100644
--- a/drivers/firmware/efi/libstub/efi-stub-entry.c
+++ b/drivers/firmware/efi/libstub/efi-stub-entry.c
@@ -9,19 +9,6 @@
 
 extern const struct efi_image_info efistub_image_info;
 
-struct sysfb_display_info *
-alloc_primary_display(const struct efi_image_info *image_info)
-{
-	if (IS_ENABLED(CONFIG_ARM))
-		return __alloc_primary_display();
-
-	if (IS_ENABLED(CONFIG_EFI_EARLYCON) ||
-	    IS_ENABLED(CONFIG_SYSFB))
-		return efistub_sysfb_display_info(image_info);
-
-	return NULL;
-}
-
 /*
  * EFI entry point for the generic EFI stub used by ARM, arm64, RISC-V and
  * LoongArch. This is the entrypoint that is described in the PE/COFF header
diff --git a/drivers/firmware/efi/libstub/efi-stub.c b/drivers/firmware/efi/libstub/efi-stub.c
index 55bf7ed50c81..a824b2ba3026 100644
--- a/drivers/firmware/efi/libstub/efi-stub.c
+++ b/drivers/firmware/efi/libstub/efi-stub.c
@@ -48,6 +48,20 @@
 static u64 virtmap_base = EFI_RT_VIRTUAL_BASE;
 static bool flat_va_mapping = (EFI_RT_VIRTUAL_OFFSET != 0);
 
+/*
+ * By default, populate the core kernel's copy of sysfb_primary_display
+ * directly. This works for both the EFI stub that is incorporated into the
+ * core kernel and for the zboot decompressor, as both have access to the
+ * location of the variable inside the loaded kernel image via image_info.
+ *
+ * ARM overrides these, as it uses a configuration table instead.
+ */
+struct sysfb_display_info * __weak
+alloc_primary_display(const struct efi_image_info *image_info)
+{
+	return efistub_sysfb_display_info(image_info);
+}
+
 void __weak free_primary_display(struct sysfb_display_info *dpy)
 { }
 
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index 634e52aa6dcc..082ce2961dda 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -1226,7 +1226,6 @@ void efi_retrieve_eventlog(void);
 struct sysfb_display_info *
 alloc_primary_display(const struct efi_image_info *image_info);
 
-struct sysfb_display_info *__alloc_primary_display(void);
 void free_primary_display(struct sysfb_display_info *dpy);
 
 void efi_cache_sync_image(unsigned long image_base,
diff --git a/drivers/firmware/efi/libstub/primary_display.c b/drivers/firmware/efi/libstub/primary_display.c
deleted file mode 100644
index cdaebab26514..000000000000
--- a/drivers/firmware/efi/libstub/primary_display.c
+++ /dev/null
@@ -1,56 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-
-#include <linux/efi.h>
-#include <linux/sysfb.h>
-
-#include <asm/efi.h>
-
-#include "efistub.h"
-
-/*
- * There are two ways of populating the core kernel's sysfb_primary_display
- * via the stub:
- *
- *   - using a configuration table, which relies on the EFI init code to
- *     locate the table and copy the contents; or
- *
- *   - by linking directly to the core kernel's copy of the global symbol.
- *
- * The latter is preferred because it makes the EFIFB earlycon available very
- * early, but it only works if the EFI stub is part of the core kernel image
- * itself. The zboot decompressor can only use the configuration table
- * approach.
- */
-
-static efi_guid_t primary_display_guid = LINUX_EFI_PRIMARY_DISPLAY_TABLE_GUID;
-
-struct sysfb_display_info *__alloc_primary_display(void)
-{
-	struct sysfb_display_info *dpy;
-	efi_status_t status;
-
-	status = efi_bs_call(allocate_pool, EFI_ACPI_RECLAIM_MEMORY,
-			     sizeof(*dpy), (void **)&dpy);
-
-	if (status != EFI_SUCCESS)
-		return NULL;
-
-	memset(dpy, 0, sizeof(*dpy));
-
-	status = efi_bs_call(install_configuration_table,
-			     &primary_display_guid, dpy);
-	if (status == EFI_SUCCESS)
-		return dpy;
-
-	efi_bs_call(free_pool, dpy);
-	return NULL;
-}
-
-void free_primary_display(struct sysfb_display_info *dpy)
-{
-	if (!dpy)
-		return;
-
-	efi_bs_call(install_configuration_table, &primary_display_guid, NULL);
-	efi_bs_call(free_pool, dpy);
-}
diff --git a/drivers/firmware/efi/libstub/zboot.c b/drivers/firmware/efi/libstub/zboot.c
index 9c7de225b39e..4089a29068ca 100644
--- a/drivers/firmware/efi/libstub/zboot.c
+++ b/drivers/firmware/efi/libstub/zboot.c
@@ -26,12 +26,6 @@ void __weak efi_cache_sync_image(unsigned long image_base,
 	// executable code loaded into memory to be safe for execution.
 }
 
-struct sysfb_display_info *
-alloc_primary_display(const struct efi_image_info *image_info)
-{
-	return efistub_sysfb_display_info(image_info);
-}
-
 static
 const struct efi_image_info *zboot_get_image_info(unsigned long image_base)
 {
-- 
2.56.0.611.g1030f0b940-goog

