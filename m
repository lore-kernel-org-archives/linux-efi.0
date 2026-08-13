Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A786E37755D;
	Thu, 13 Aug 2026 07:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786607120; cv=none; b=ZicrkGP4dQIcEzGrbJ8Eq8PHoSZrpZlcVvz/+o6qRG8PRbtzt/36YLbFCBIdd/gYPev/YJ7k3je9cD8iUqw46in6Q+7CCMNr8793X0/f4Tev4wOcZSQ8fbDdYbL723VCRSEWDaOuq2N6NFE0EyZPZ7BxxdZYUHR2757s20BUNMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786607120; c=relaxed/simple;
	bh=ObemBNiXAA9fc6eSrHBLJHvN6r7CgsJHYV6Qi819ZeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DiCErsaTl0hj+QhrbK5rn5Jz6YWVYQVcHzhdPvEhwuClZQbPtr07uy8g5KUHPjyiOXgy7gXr9b77dFnIfLF15A579fpNp7uJfEAJgXevMh1dpb0DLwmLGB4Yf5sB6a9etT3om0/vqH36VMBVxG+v4xwxDZ2jemoDFsa7Jhzd3BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UzXHBoEt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UzXHBoEt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A6D1F00A3E;
	Thu, 13 Aug 2026 07:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786607119;
	bh=zS2zqdJiOa2sx/kU92rSbkJMqQaAm8Zcb70/3tDfkeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UzXHBoEtBmMuNPGP+xwLE1aylKAxP5rBEFJAQ8trqq5BFqfukBkOCLQojb1/JPoGO
	 orcuJu7Yka3GMipr9Pl5sZrfMW0wI+6JFJcwejOAjCZePi72Dlx95O3vVhZYCPRA8N
	 1JaIbuiwoZllFqQrNXNNxbwJ04C47Zk64L7oXjVR/I5brCpBhGUD9myMSzwAzBIXYu
	 sMfYXEK55jy2BICdpaP/TY44ZK5D5uUjcZ5nLRi/nYvzBV+YMMuYwHW6MAFdxdcaEx
	 hK7KY0fDAwVTW+Ph42zsSTjxzr5lsqzx9ky62bptLlTmsmI+D7X4pEQX2E4r5C36L7
	 atEGGqiO3lXrA==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	loongarch@lists.linux.dev
Subject: [PATCH 1/3] efi: Turn boot memmap handling into shared code
Date: Thu, 13 Aug 2026 09:45:08 +0200
Message-ID: <20260813074506.643472-6-ardb@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260813074506.643472-5-ardb@kernel.org>
References: <20260813074506.643472-5-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3647; i=ardb@kernel.org; h=from:subject; bh=ObemBNiXAA9fc6eSrHBLJHvN6r7CgsJHYV6Qi819ZeU=; b=owGbwMvMwCVmkMcZplerG8N4Wi2JIau2jOW3XHWU/8OtfRdnPWQ7x5u/IYtrn2xCQ4Wb18+D1 89WbMzoKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABNZ18PwT0l5v757oceh7bOZ vZMVpq2NmrEqjX07/+6Zp2NPRSfmHGP4w3UgfY0aS+/HgPIVFz48t4w4EKC6+tJmbt0LbP+vzJg 1lxUA
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit

Move the handling of the boot memmap config table from loongarch
specific code to code that is shared between all architectures that
select EFI_GENERIC_STUB (all EFI archs except x86).

This will be used in a subsequent patch to replace the clunky FDT based
passing of the memmap parameters.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/loongarch/kernel/efi.c | 10 ++++------
 drivers/firmware/efi/efi.c  |  4 ++++
 include/linux/efi.h         |  3 +++
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/loongarch/kernel/efi.c b/arch/loongarch/kernel/efi.c
index 69dd83f8082f..089378856bab 100644
--- a/arch/loongarch/kernel/efi.c
+++ b/arch/loongarch/kernel/efi.c
@@ -28,12 +28,10 @@
 static unsigned long efi_nr_tables;
 static unsigned long efi_config_table;
 
-static unsigned long __initdata boot_memmap = EFI_INVALID_TABLE_ADDR;
 static unsigned long __initdata fdt_pointer = EFI_INVALID_TABLE_ADDR;
 
 static efi_system_table_t *efi_systab;
 static efi_config_table_type_t arch_tables[] __initdata = {
-	{LINUX_EFI_BOOT_MEMMAP_GUID,	&boot_memmap,	"MEMMAP" },
 	{DEVICE_TREE_GUID,		&fdt_pointer,	"FDTPTR" },
 	{},
 };
@@ -132,14 +130,14 @@ void __init efi_init(void)
 	if (IS_ENABLED(CONFIG_EFI_EARLYCON) || IS_ENABLED(CONFIG_SYSFB))
 		init_primary_display();
 
-	if (boot_memmap == EFI_INVALID_TABLE_ADDR)
+	if (efi.boot_memmap == EFI_INVALID_TABLE_ADDR)
 		return;
 
-	tbl = early_memremap_ro(boot_memmap, sizeof(*tbl));
+	tbl = early_memremap_ro(efi.boot_memmap, sizeof(*tbl));
 	if (tbl) {
 		struct efi_memory_map_data data;
 
-		data.phys_map		= boot_memmap + sizeof(*tbl);
+		data.phys_map		= efi.boot_memmap + sizeof(*tbl);
 		data.size		= tbl->map_size;
 		data.desc_size		= tbl->desc_size;
 		data.desc_version	= tbl->desc_ver;
@@ -156,7 +154,7 @@ void __init efi_init(void)
 		 * Also, set the EFI_PRESERVE_BS_REGIONS flag to indicate that
 		 * critical boot services code/data regions like this are preserved.
 		 */
-		memblock_reserve((phys_addr_t)boot_memmap, sizeof(*tbl) + data.size);
+		memblock_reserve((phys_addr_t)efi.boot_memmap, sizeof(*tbl) + data.size);
 		set_bit(EFI_PRESERVE_BS_REGIONS, &efi.flags);
 
 		early_memunmap(tbl, sizeof(*tbl));
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 0327a39d31fa..d33760d6a527 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -55,6 +55,9 @@ struct efi __read_mostly efi = {
 #ifdef CONFIG_UNACCEPTED_MEMORY
 	.unaccepted		= EFI_INVALID_TABLE_ADDR,
 #endif
+#ifdef CONFIG_EFI_GENERIC_STUB
+	.boot_memmap		= EFI_INVALID_TABLE_ADDR,
+#endif
 };
 EXPORT_SYMBOL(efi);
 
@@ -647,6 +650,7 @@ static const efi_config_table_type_t common_tables[] __initconst = {
 	{LINUX_EFI_UNACCEPTED_MEM_TABLE_GUID,	&efi.unaccepted,	"Unaccepted"	},
 #endif
 #ifdef CONFIG_EFI_GENERIC_STUB
+	{LINUX_EFI_BOOT_MEMMAP_GUID,		&efi.boot_memmap,	"MEMMAP"	},
 	{LINUX_EFI_PRIMARY_DISPLAY_TABLE_GUID,	&primary_display_table			},
 #endif
 	{},
diff --git a/include/linux/efi.h b/include/linux/efi.h
index aa15ff88539b..bc1cd005ca0f 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -650,6 +650,9 @@ extern struct efi {
 	unsigned long			mokvar_table;		/* MOK variable config table */
 	unsigned long			coco_secret;		/* Confidential computing secret table */
 	unsigned long			unaccepted;		/* Unaccepted memory table */
+#ifdef CONFIG_EFI_GENERIC_STUB
+	unsigned long			boot_memmap;		/* The EFI memory map captured by the stub */
+#endif
 
 	efi_get_time_t			*get_time;
 	efi_set_time_t			*set_time;
-- 
2.47.3

