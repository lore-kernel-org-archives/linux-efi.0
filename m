Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319733AB263
	for <linux-efi@vger.kernel.org>; Fri, 10 Apr 2026 08:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775808035; cv=none; b=fJF4MDXW5daxYcXb0JFGRqbd/Izs9mLRLQ0CpVJLtbUeVkIaFEJ+S57KONaff6Wx4XUt4jyC49kbH5qfqXHJMsIfeklHNT8gbxjxT8TAHYCfxWOl0tfsJOXdyXgL04xWB9qZeZTw0egKtDS4Jfjgn4Ekye+VxP9gLrqtgz69IyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775808035; c=relaxed/simple;
	bh=lU3bZHXBTGkw7+BD61qLmq3Q/hsggbp8heSCEgprnFU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ba+ym1BKExPI3QvR7a4VG1sHQgydNGJ1TveS9OvrSoL9SyRlL1iWDOR//VqJ4wIzglUOOAKz0UJzRUwbs1Cbrk0a5OXd0H89mU4ErrxSEX8BVT0c1/0Zna2FkzO6Biaj2Y0VitEXBG9h35+8PafIFX6i4HUtGGYMIfBg6nQ9k5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XIlKbKeR; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XIlKbKeR"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43d0de4bfb7so2033278f8f.3
        for <linux-efi@vger.kernel.org>; Fri, 10 Apr 2026 01:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775808031; x=1776412831; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lyrlB4WzYxChX1lupcLvEn8b3bwfY9ejggIuX50+pQE=;
        b=XIlKbKeRd03koDGTtbGdoRaoPVaXem24jqxNx4Fw23eRj19wA4gXCqi+oPN/xRCfvO
         RSsaAtZk5/7Qh6eZEQl6+oPmDBi52ueBxurqj2KOTUjGzflQCnWSba9a4pCcp6se8Lqi
         ftoKUZ6NUt6kyXurhuBTUnyTMLKMeKm6ITMwIgYJcp+mFFsrHvyNeoV/dvlpJqorGQTk
         ez4mDfmVyfnNDZdcitzUnlIMpbNJcUQBeFw7B24NmWgYn2LveLudhPADNLCWLl3YOjwo
         vSTs9806cTzckmX93PE1xiqs+iP4i+qXPQ0riuUTsPAMITNdrFdQM8+iwdq9/7tS0JLR
         8EpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775808031; x=1776412831;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lyrlB4WzYxChX1lupcLvEn8b3bwfY9ejggIuX50+pQE=;
        b=JUW+ge9JXcOYVBAxCjfFLgqWgD3KPmoqzUD7WuwblS7DG188kj3VjdsNQAf9q2WVsf
         km+EvF6si/AGyGDy4AOWBMnIYMG6ue7sDtvLXZ7qMIF1s1O9xGNZwq9RvplUNPe1JNgK
         Igouy/rupoQ8G+HE+DStqxOm2rd8ygYPLs46sXI/uvxZaZAWMM3NfdWw6qCXI9qVT4yH
         Pa0mmHA462bK/ubXXHzt2cRsXiJx+0tIh6asYHqCBmBojmT7/5ogbBTIDrvvVaP63pJ6
         pXp+sc8qp6QEE738YQfm+4qPRIg68cy1SoBBaiMraaxD1+i1z+TkEy+MFFejnQ/H09qP
         +Tug==
X-Gm-Message-State: AOJu0YxWu5ca6XYm+YA29SF2748hInn2agNooYWN+wpbCCqbNTtZ6TQO
	282jjJg6FKeTNYsMUtOBawiFrzLDN9f5+WRaqSFWmcjnqhFBbGNxe57kediQ6zJsIpef0V8xmMy
	IMaUnY8qvJCMHIaU+oYasyOpXpQ5jYgSJqSNrMLcIUdANlhrgSLTftD34Egyw1S0YNZXlOsTefr
	og872z8fKRlO57818g7tWrcW9eSHm3hA==
X-Received: from wrxp1.prod.google.com ([2002:a05:6000:181:b0:43c:f8f1:8e8])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:5f94:0:b0:439:c62a:6dc2
 with SMTP id ffacd0b85a97d-43d642b1920mr3246794f8f.41.1775808030771; Fri, 10
 Apr 2026 01:00:30 -0700 (PDT)
Date: Fri, 10 Apr 2026 09:59:53 +0200
In-Reply-To: <20260410075950.1687350-9-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260410075950.1687350-9-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=4145; i=ardb@kernel.org;
 h=from:subject; bh=Agc4UCTg/xwUx4YQxdagTJIbedCrqSRRvBngGubFfFM=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfPG2j/NQd9vF4lKVB/0afPRm8Eg8XWd5MFqXpYUtzlZk
 /JPM3l3lLIwiHExyIopsgjM/vtu5+mJUrXOs2Rh5rAygQxh4OIUgIk8dGVkWKlcLm4z71i+5mLG
 HfGBgZdKDZ3dPkrIxkurNP2euEq+neF/wIeckKbk9FXrpYN3a/Fx6FWFH0zzvjaLI2CpSrSR2G0 +AA==
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
Message-ID: <20260410075950.1687350-12-ardb+git@google.com>
Subject: [PATCH 3/7] x86/efi: Only merge EFI memory map entries on 32-bit systems
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Commit

  202f9d0a4180 ("x86, efi: Merge contiguous memory regions of the same type and attribute")

introduced a pass over the EFI memory map, ensuring that contiguous
regions of the same type and attribute are coalesced into a single
entry. This was needed because relative references may exist between
those regions, and so the virtual remapping needs to preserve the
relative placement of these regions. This virtual remapping was based on
ioremap() at the time, which does not guarantee that adjacent physical
addresses are mapped adjacently in the virtual space.

Commit

  d2f7cbe7b26a ("x86/efi: Runtime services virtual mapping")

introduced a new strategy for virtually remapping the EFI runtime
services, which is now the only remaining one, and commit

  a5caa209ba9c ("x86/efi: Fix boot crash by mapping EFI memmap entries bottom-up at runtime, instead of top-down")

tweaked the logic to ensure that the relative offset of adjacent regions
of any type is preserved on 64-bit systems, by reversing the order in
which the EFI memory map is traversed when choosing the virtual
placement.

This means that merging regions is no longer needed on 64-bit, given
that the relative placement of adjacent regions is guaranteed to be
preserved in the virtual space. So make this hack 32-bit only.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/include/asm/efi.h     |  6 ++++
 arch/x86/platform/efi/efi.c    | 31 --------------------
 arch/x86/platform/efi/efi_32.c | 31 ++++++++++++++++++++
 3 files changed, 37 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 51b4cdbea061..e397ea61c9f8 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -143,6 +143,12 @@ extern void efi_unmap_boot_services(void);
 void arch_efi_call_virt_setup(void);
 void arch_efi_call_virt_teardown(void);
 
+#ifdef CONFIG_X86_32
+void efi_merge_regions(void);
+#else
+static inline void efi_merge_regions(void) {}
+#endif
+
 extern u64 efi_setup;
 
 #ifdef CONFIG_EFI
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index b60f8454a1ec..2330d028a889 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -502,37 +502,6 @@ void __init efi_init(void)
 		efi_print_memmap();
 }
 
-/* Merge contiguous regions of the same type and attribute */
-static void __init efi_merge_regions(void)
-{
-	efi_memory_desc_t *md, *prev_md = NULL;
-
-	for_each_efi_memory_desc(md) {
-		u64 prev_size;
-
-		if (!prev_md) {
-			prev_md = md;
-			continue;
-		}
-
-		if (prev_md->type != md->type ||
-		    prev_md->attribute != md->attribute) {
-			prev_md = md;
-			continue;
-		}
-
-		prev_size = prev_md->num_pages << EFI_PAGE_SHIFT;
-
-		if (md->phys_addr == (prev_md->phys_addr + prev_size)) {
-			prev_md->num_pages += md->num_pages;
-			md->type = EFI_RESERVED_TYPE;
-			md->attribute = 0;
-			continue;
-		}
-		prev_md = md;
-	}
-}
-
 static void *realloc_pages(void *old_memmap, int old_shift)
 {
 	void *ret;
diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
index b2cc7b4552a1..886ede4117b5 100644
--- a/arch/x86/platform/efi/efi_32.c
+++ b/arch/x86/platform/efi/efi_32.c
@@ -152,3 +152,34 @@ void arch_efi_call_virt_teardown(void)
 	firmware_restrict_branch_speculation_end();
 	efi_fpu_end();
 }
+
+/* Merge contiguous regions of the same type and attribute */
+void __init efi_merge_regions(void)
+{
+	efi_memory_desc_t *md, *prev_md = NULL;
+
+	for_each_efi_memory_desc(md) {
+		u64 prev_size;
+
+		if (!prev_md) {
+			prev_md = md;
+			continue;
+		}
+
+		if (prev_md->type != md->type ||
+		    prev_md->attribute != md->attribute) {
+			prev_md = md;
+			continue;
+		}
+
+		prev_size = prev_md->num_pages << EFI_PAGE_SHIFT;
+
+		if (md->phys_addr == (prev_md->phys_addr + prev_size)) {
+			prev_md->num_pages += md->num_pages;
+			md->type = EFI_RESERVED_TYPE;
+			md->attribute = 0;
+			continue;
+		}
+		prev_md = md;
+	}
+}
-- 
2.53.0.1213.gd9a14994de-goog

