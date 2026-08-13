Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054A53E5A09;
	Thu, 13 Aug 2026 07:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786607124; cv=none; b=bk2CKZZeyH4uBPSFtpLkL5L5CBIDay3NXZBAd4EjeNCpfYfF+zQos3JQTTxzRrWrQ5IvMsAk9M7JAGV+Vg07P0ZBaP4LafZUXY6JrBTgiyqBo396NCadlr38MUrLQDa8s2xikRWd1mM7k1e2xYix3/T5fRa9bCQ1j7u9zeTlrrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786607124; c=relaxed/simple;
	bh=nzmEqWgig/8uve8+0Y/RZPjKgq7imO33lTZpARev920=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UvugvwypXhmP7qDpwYwEx0+8TQp/kS/cR9S8jZ3tJoAtDH5OuvJ9h8fNukMLK9BxRL8laaXuyHA0OK3bo3Mv8cK08xkOEnJBKe3fT/rlXIHazEH8XGbJHAGx6lS2/B8kDH91MG8DchYkNAWaOtxPcmlxSed/gIwRUj4p4fAfSpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hXZEz0Cq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hXZEz0Cq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846A31F000E9;
	Thu, 13 Aug 2026 07:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786607122;
	bh=200+BjYXiK26SNAL0SOvp1TouAoOBZeEW1FAjxntMk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hXZEz0CqrDI/4sLy2u8OnIwe/9ZXHWKuUkJ6hi5R2sGlWchj2bRCQEqfO+DuXmImp
	 yiw47kZHd5Pi2dWMjAUALl3JzNLHZ/43N3lfPSeqsKPuqFKen7qPjBYxz9li2z3tHD
	 SVR0d1xdCqopX0L8HoT8VKJpUQVzTE0RVk+n92KHuZET5AbiK0mbELb0wr7dy1ID9j
	 J0Fn4bULVRAQt9yAsIocR8Zkyx8GIdv0nu+WFyNW2yCU1dYKqTo5Hv7kYeZ5c9qCwv
	 jfBa4QMNZ/5YxTWW2rdWCLhNV57ekATyzxEGziaso/vCWX+8CaH7QYKDaVNeES6OgA
	 7WKEOPdSbbE5Q==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	loongarch@lists.linux.dev
Subject: [PATCH 3/3] efi: Make the 'linux,uefi-boot-memmap' DT property optional
Date: Thu, 13 Aug 2026 09:45:10 +0200
Message-ID: <20260813074506.643472-8-ardb@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260813074506.643472-5-ardb@kernel.org>
References: <20260813074506.643472-5-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3173; i=ardb@kernel.org; h=from:subject; bh=nzmEqWgig/8uve8+0Y/RZPjKgq7imO33lTZpARev920=; b=owGbwMvMwCVmkMcZplerG8N4Wi2JIau2jD1dSS7Kz93ahic8+m74LSu1woPcLJnpM47G9z2Y/ aZgx4OOUhYGMS4GWTFFFoHZf9/tPD1RqtZ5lizMHFYmkCEMXJwCMJF9Oxj+aavEL241u9ghv7Ey b+Pl2QrqTUKFC5WebF7J+CawqIz9AyPDhnUhZzYwCyxPO/fTLfSK3XGnT6pRAg/eGx3ZHWYRdX4 VKwA=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit

The 'linux,uefi-boot-memmap DT property' is redundant in principle,
given that it carries a physical address that is also passed via a EFI
config table entry.

However, if SetVirtualAddressMap() has been called, the address of the
config table array has been translated to virtual, and so the memory map
is needed to translate it back to physical before it can be located.

This means that passing the linux,uefi-boot-memmap DT property is only
needed if SetVirtualAddressMap() has been called, which is a terrible
idea anyway, and if it has not been called, the config table array can
simply be parsed to look for LINUX_EFI_BOOT_MEMMAP_TABLE_GUID, and the
address taken from there.

So permit this, and make the boot memmap property optional.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/fdtparams.c | 42 ++++++++++++++++++--
 1 file changed, 38 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/fdtparams.c b/drivers/firmware/efi/fdtparams.c
index a54a76a6aaeb..89ffccf35fd7 100644
--- a/drivers/firmware/efi/fdtparams.c
+++ b/drivers/firmware/efi/fdtparams.c
@@ -89,14 +89,15 @@ static int __init efi_get_fdt_prop(const void *fdt, int node, const char *pname,
 u64 __init efi_get_fdt_params(struct efi_memory_map_data *mm)
 {
 	const void *fdt = initial_boot_params;
-	unsigned long systab, memmap;
+	unsigned long systab, memmap = 0;
 	int i, j, node;
 	struct {
 		void	*var;
 		int	size;
+		int	optional;
 	} target[] = {
 		[SYSTAB] = { &systab,		sizeof(systab) },
-		[MEMMAP] = { &memmap,		sizeof(memmap) },
+		[MEMMAP] = { &memmap,		sizeof(memmap), 1 },
 #ifdef CONFIG_XEN
 		[MMBASE] = { &mm->phys_map,	sizeof(mm->phys_map) },
 		[MMSIZE] = { &mm->size,		sizeof(mm->size) },
@@ -131,14 +132,47 @@ u64 __init efi_get_fdt_params(struct efi_memory_map_data *mm)
 				continue;
 			if (!j)
 				goto notfound;
-			pr_err("Can't find property '%s' in DT!\n", pname);
-			return 0;
+			if (!target[j].optional) {
+				pr_err("Can't find property '%s' in DT!\n", pname);
+				return 0;
+			}
 		}
 		if (IS_ENABLED(CONFIG_XEN) && dt_params[i].paravirt) {
 			set_bit(EFI_PARAVIRT, &efi.flags);
 		} else {
 			struct efi_boot_memmap *bm;
 
+			if (!memmap) {
+				unsigned long tables, nr_tables;
+				efi_system_table_t *st;
+				efi_config_table_t *tbl;
+
+				st = early_memremap_ro(systab, sizeof(*st));
+				if (!st) {
+					pr_err("Cannot remap EFI system table\n");
+					return 0;
+				}
+
+				tables		= st->tables;
+				nr_tables	= st->nr_tables;
+
+				early_memunmap(st, sizeof(*st));
+
+				tbl = early_memremap_ro(tables, sizeof(*tbl) * nr_tables);
+				if (!tbl) {
+					pr_err("Cannot remap EFI config table array\n");
+					return 0;
+				}
+
+				for (int i = 0; i < nr_tables; i++) {
+					if (!efi_guidcmp(tbl[i].guid, LINUX_EFI_BOOT_MEMMAP_GUID)) {
+						memmap = (unsigned long)tbl[i].table;
+						break;
+					}
+				}
+				early_memunmap(tbl, sizeof(*tbl) * nr_tables);
+			}
+
 			bm = early_memremap_ro(memmap, sizeof(*bm));
 			if (!bm) {
 				pr_err("Cannot remap EFI boot memory map\n");
-- 
2.47.3

