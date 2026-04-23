Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C9B34FF5B
	for <linux-efi@vger.kernel.org>; Thu, 23 Apr 2026 15:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776957665; cv=none; b=LkVpuLNmainMihqQbG83NwSZRnb8yKSgVEFRbqPEL/gROBXgGmrSB6sP4Ephht3I5zqbrp1U1CL39X4/VFQQMn0Xd44y88pjLLm3Cm/nUV/m/sfXr8VlZdch5QzUvGSVeFi3Dd4wWEEkgyZh5ETugf06t239Yht/S1ooqzr5Ta8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776957665; c=relaxed/simple;
	bh=bUHL//Am2oa5BMc+mwzx9NssfOKaE6GrNTig/ad9cCM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dFlg4tfX5RPMyQwMQcIDMRhl8770oqkQSufPcVyNdJAQqeeGC0bb9YIGuxpR6MurXsXNAp9TgNxiZzjW0LI/wPkk/UTwy6S5CNZE+cA76jW+vZEYcTykz8kcgSuODhlAJK4JvPWU7h2fkn37z1D3STmVv2ffCO+64KLaIyfOPp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XMyK44Xc; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XMyK44Xc"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-488e097a270so48719125e9.1
        for <linux-efi@vger.kernel.org>; Thu, 23 Apr 2026 08:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776957662; x=1777562462; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aUJqvSaANOdDR9L/33SKcbzCGTEvwMTq0jUvoX5ntMM=;
        b=XMyK44Xc4NABCgBW8L8K1Xrdj9q/TSAb2UNzJSe7pQUZCwKHu6RxpPRui0393YHuGv
         jEKuqRUOhvokqSAfITP0tfZreoKjC3yjVkvr6pQmwa5IC6xa8J5l2qXXB129TXM5ZDTb
         Hjbg1Fja5K5dArntwCEqyv5efEytTYX4Es73ICxfc1bVGrjrM4LaXEvZFlzneRkbNK3M
         qaPiua6EcrkOyiiuqGCXhCIHAHUfitHlVe8IJGNC7XLIdncrmzMWiU6s4S/bfQ1kgMnw
         /WQxHc0/7Cc43aoOZvW71Hn3sFRjvM6lYhq6DECHVJ1+7/UMb1AkjcAqZMv8kKPZRzLu
         RWXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776957662; x=1777562462;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aUJqvSaANOdDR9L/33SKcbzCGTEvwMTq0jUvoX5ntMM=;
        b=ghv4zES33gryTfMXCUXiwTRqgdLJM7bFrEuFFugDXnA8zIgZWdvSnwMFxub7SYPrp2
         aFR1FZyLERo1SB4TIqLXJ8rnm5Wfozv8dZQr0dLiD5EtDE79gIZU8vTiiVj/FbQYjHZB
         UY/qgAu5sgNes2gErWdavkUmuM4JNrbqiijXpS8vgZD+lrHuYgLqebXVKSBUjov3/ZlI
         K1HSF+rGynhVz0wPAUZuKSLPqBGXvm2AJzB6XIuD49Pp9NroiUSx8NAMo+m3s8QpIO10
         V3ZyV4BQJzfxQJ4uvHcDSzg8fZo8eUe7u9sjAfPiFKSQEib0d5pABZa99IauLMmS2rYO
         y4Eg==
X-Gm-Message-State: AOJu0Ywu7DrkKOwcTgOkSaK4e1ZOJ4QKiwFx4h86tzogUj9xrTP+VdOD
	EwH1NveNixGESwAYXr8tdorZrf8zlwG9nxArgGosgt95CpDTSZMsNMlDiYiDC85/SYOaeJIcaQ=
	=
X-Received: from wma5.prod.google.com ([2002:a05:600c:8905:b0:485:3aa2:da59])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8b38:b0:487:59c:2bb8
 with SMTP id 5b1f17b1804b1-488fb7925dcmr383448975e9.27.1776957662443; Thu, 23
 Apr 2026 08:21:02 -0700 (PDT)
Date: Thu, 23 Apr 2026 17:20:28 +0200
In-Reply-To: <20260423152024.1098465-19-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260423152024.1098465-19-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=4148; i=ardb@kernel.org;
 h=from:subject; bh=HyyOeSodMSg9BQJay8XzIUTfk5/dlS8V1D5JXM1rIKc=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfOVxV7NotIf/rZvlhwLPnv68pXIQ33PrY5IdDOszpW0e
 bKMt8e5o5SFQYyLQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAEzk1kxGhhu39jrfT/FRyZ91
 efEy5zOrDj3cuEjg6a1Xa4v7fpVJ+jxnZDj8UXjNFYXd+2T+XN0lJ/n/7e0m5f0RqwN73lYEFO5 6/owFAA==
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260423152024.1098465-22-ardb+git@google.com>
Subject: [PATCH v3 03/17] x86/efi: Only merge EFI memory map entries on 32-bit systems
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dave Young <ruirui.yang@linux.dev>, 
	Gregory Price <gourry@gourry.net>
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
index dc8fe1361c18..f291845b403a 100644
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
index 1b7a0cd54d08..c0195b5eab21 100644
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
2.54.0.rc2.544.gc7ae2d5bb8-goog

