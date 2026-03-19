Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349603B6C15
	for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 09:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773911179; cv=none; b=pQt1v+OTO53vf0ju/d7ML0PWuCeCN1u2rKGetboHDgypV3/VK+DYccwD5t9UIJdQZ0wSsjrQcp+HiMbqzgFMFqJNW4lukZml0vMdPIWD5wlJC4fzwHJsF+qmysVe/vfOPb5dlaAmeAU+6SFnuzyMWIpsI7NRfsFxT21MF8sNdwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773911179; c=relaxed/simple;
	bh=cbbspSu/En8wMoIk09xHoGHLe/eK50A9ypzP7V+nnys=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dVvtWiLpsZKLxW4zrvFMMuzxcN+qGYtK3dazBex/Su2xBWePd5kLl3bdLjthMzOlBcGje+jWIqcpyq3xFIV+FqZdI1gfVO7GzareMrQTC25GFu0L6MzGbBKhHmI4Z3ZwyoCH+TGFeL8kf1XWn3cf7Vg2SkEVq6KVsUoh3WxQdG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KQZzCSv3; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KQZzCSv3"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4853b5b0fafso4226435e9.3
        for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 02:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773911175; x=1774515975; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GGWJD/oSO/zqs1fjiBr8BSE5CyULnCYZrvaP5HxSasQ=;
        b=KQZzCSv3A+xXYFayxyEfmhVS5Vh/lzlG8XubQcqIz1ujPWar0XaIrJeRi+pwz/sVdc
         S194nS9po67KDezqO0Nw6VmTBUGzY2d76YZoDUNT/B2dfNKAO2WGEtPvxAJ31NQq63Gq
         z6Lkpb0KzpNu4432z2rZfROnpaU5xi8q+EBFfdyVLrg3mIQz7/T39GCp+vEYY78hTcB7
         kJmQP4oa8X2Fad/v7YWgjT4cSGh4ussyhV9amOnFH+QOARtSmmAiIZVHbcMtq+gHpOF1
         7y/HIcIzLfJ3JE7rMSUSF9q0cb5ralpRuJBSJgDd4DCU1Ryne8PxtFG532Z59rzR7TVy
         q9Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773911175; x=1774515975;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GGWJD/oSO/zqs1fjiBr8BSE5CyULnCYZrvaP5HxSasQ=;
        b=fS5hKT/m3+AyTjowjzkbKuuOmliAEnFMaAQFT6vfaH6Z7e78Yviz+67MDehZN43J3M
         xAqNBp8gVDjkB6n67zIprJvoEwyi7TLJqAqP56qG28AKCrGNe8O0JJvlNeGb9rXw8VVh
         dr9DzWRa74BxIsZ0R5I3MbnQSlFUu4XQbklSB9sCgWL4I9umYAENGazgFdR8+f0tljg7
         hJZ5dlzI+vger65PyHcwDFEq28mqqz/TuhZW0vRPzGry1PBYFUn380862/AkddO0glxn
         zkxKDuXoSFSj2GFsSNFewOCQ6LqNMMerPHBqvxUZEAyPy8yke5v+u4r1H8FsOsPHt+zt
         2pZA==
X-Gm-Message-State: AOJu0YytRWoX6ukKNKf8BXm6mM910Rbkzv0pJC9MaQlyiN+kGEf/EOiq
	YjI08Ojo/q2yuqlpfUxNtlkhdagp4iekSyfSD7ezuOsG5WgVo9SRGm7WY46XfXHpuknNRqHtqg=
	=
X-Received: from wmlz10.prod.google.com ([2002:a05:600c:220a:b0:485:32b2:6b8d])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1c2a:b0:485:2c61:9457
 with SMTP id 5b1f17b1804b1-486f44379a6mr102042845e9.10.1773911174993; Thu, 19
 Mar 2026 02:06:14 -0700 (PDT)
Date: Thu, 19 Mar 2026 10:05:42 +0100
In-Reply-To: <20260319090529.1091660-21-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260319090529.1091660-21-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=4144; i=ardb@kernel.org;
 h=from:subject; bh=MRuY0aJg5kwsKdStVH+fBQF2uFes8p/NfZYMA6nA7UM=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIXP3nsxfJaU2qo+XFZ7qXemwsXv/0+q2Spbyy0kb5Pwzl
 JXPBU3sKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABMJKmVkuGy7Wvf3x+uaGy4x
 Zz97LLJh65PFQn8vZew5Jzn/yuQMc2dGhks8HrYabPrfmVbYe34NLDAsCwu2yJo2J+OHnn2/yYY EbgA=
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260319090529.1091660-33-ardb+git@google.com>
Subject: [PATCH v2 12/19] x86/efi: Only merge EFI memory map entries on 32-bit systems
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
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
index b01dd639bf62..44cdd3c1055e 100644
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
index 183cca8fe4a6..a6081e3f1b88 100644
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
2.53.0.851.ga537e3e6e9-goog

