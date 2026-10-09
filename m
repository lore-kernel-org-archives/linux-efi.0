Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BFDE33987E
	for <linux-efi@vger.kernel.org>; Fri,  9 Oct 2026 15:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791558967; cv=none; b=dPIYA0au7BfQupjdEA4NulHSvreIbCmnbJY+pfaukH1/sfxNSin61cEe9DmE+veju1BxS5iNFuCc/3EPieYAGXU/kVIj1rcSjvJKOiYHYAA5SoGBYmup47FYC7vwtCcJtc7RaZknSLDomoxz5+JYyBkkQxyrUe+xWqxEQi1gfQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791558967; c=relaxed/simple;
	bh=dQsifwyyig8YpGKxzBzm59+Ftc6+jRRMixF5I9e5kvA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ZK+tuuJSzD8FSuaVJaHiP3zKP/IyX/VSfobwuknlYE4ueT/8Lj7E17hPxg5+nXOxo44lZS9pxARWlEiJHLZ3sfQyQZYxQzxTmj06d1cmnIkuTtzotMU+NCXOl4nCfw2gEDxCkIbfor3lu3Nglw9bSsBRtoQI+PHer2WbSHR0iWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kIRlvsAj; arc=none smtp.client-ip=209.85.208.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kIRlvsAj"
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6a9caf60126so6766847a12.1
        for <linux-efi@vger.kernel.org>; Fri, 09 Oct 2026 08:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791558963; x=1792163763; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Elt82oVIJIDR2UH2RaIC/yk8bP6X4zNjSmosDoHpGoA=;
        b=kIRlvsAj8rrGC27TTKFY8+cBhi/MzSA8y2c1WVz0878mj3+faHrTFoo8YmLMar8QFw
         nXbkzhzqwiOjy8b9pIfXEV8s6JUizXtDv4xC1OLhIH/0SyH9r551FA/XRl/T6gyBvysn
         qBX2qPkavlNrP7icdegaK1S5ynHM1r6hVF9Hbga3ooo/MHioX7gtJuGuVp/SmbGXx5hY
         z738YFvR+Oo/J7XLWZZKTdQJm4qdQ+cs4gVJzl/10Yn64fg2AdCPrSBSlwdput63eVP7
         7p01liDlw4i2Q1OXxVWlwOZrvLE7hKVlJjXtRNXt/YLkkO/7bDWmRH/CVjIDlcgRRUwI
         KQtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791558963; x=1792163763;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Elt82oVIJIDR2UH2RaIC/yk8bP6X4zNjSmosDoHpGoA=;
        b=zDxqMHOnLvYlKBSDar8Qp3tIXEJqeA60Tl48MsREG/7NcNiM5dVsPCWgDt7UsSJiZt
         5mp/CucXeVqGYlm84+k0QS+wGp54eB/sf7lUq2NXmOcpIhUns9sZ7O9C0DWo+VgwC5/Y
         fLr8O+J5hlG5USSejSCdzbCJjqL3JIlawCD9JJrkeR2ho6qqkxuCMZNUbYWhA5agq+Zm
         8tZ3834YeTWi/MgWJIcuYFJ4AKZt3TpDSj3P4kUQj3WD3amUJDuj3OgV0T7KpBiMqUx8
         diNod/rnGDd8omQHpICgpZXUGnwrCu0KRjPWni5NYm5EEXnYTihgRStEJSDsV1z7TGdD
         TrWQ==
X-Gm-Message-State: AFq9FYII3ErhNcYfTT0tVRwlwFK7JkOdfXOrz337XSOEzqXjTgQJwV8c
	efHpXMDcqRbDEPB0urH2OktPPtDfYZV2s0GlZpX9BaR10wr4J3QnwP+3UXafd5j2W1skEA9oNKD
	j2PttjThh/jieC9LU/Zt+D/4tTLUCkiMmUwfiPUzHtOZAhhUnZsuFTGM4absxe2NKLiXacuKQCf
	iQJMkFXXpcN2JhNNsfOJTVK4OXmn1S0w==
X-Received: from edxs24.prod.google.com ([2002:a05:6402:1658:b0:6ac:c30e:4ee2])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:4582:b0:6af:dc52:3639
 with SMTP id 4fb4d7f45d1cf-6b17c27f1a8mr1833622a12.40.1791558963095; Fri, 09
 Oct 2026 08:16:03 -0700 (PDT)
Date: Fri,  9 Oct 2026 17:16:01 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261009151600.351766-2-ardb+git@google.com>
Subject: [PATCH] arm64/efi: Clear PTE_WRITE when applying EFI_MEMORY_RO
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, 
	will@kernel.org, catalin.marinas@arm.com, Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

set_permissions() sets PTE_RDONLY for regions that the Memory Attributes
Table describes as read-only, but leaves PTE_WRITE set.  PTE_WRITE is
the DBM bit, so when hardware dirty state management is enabled
(TCR_EL1.HD), such a descriptor is writable-clean rather than read-only,
and a write by the firmware will be permitted by the hardware (which
marks the entry dirty) instead of faulting.

Clear PTE_WRITE as well, as pte_wrprotect() does.

Cc: <stable@vger.kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/kernel/efi.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 0ec90fd1754e..6f34aef3d04e 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -117,8 +117,14 @@ static int __init set_permissions(pte_t *ptep, unsigned long addr, void *data)
 	const efi_memory_desc_t *md = spd->md;
 	pte_t pte = __ptep_get(ptep);
 
+	/*
+	 * Clear PTE_WRITE as well: it doubles as the DBM bit, and leaving it
+	 * set would permit the hardware to make the mapping writable again
+	 * when TCR_EL1.HD is set.
+	 */
 	if (md->attribute & EFI_MEMORY_RO)
-		pte = set_pte_bit(pte, __pgprot(PTE_RDONLY));
+		pte = set_pte_bit(clear_pte_bit(pte, __pgprot(PTE_WRITE)),
+				  __pgprot(PTE_RDONLY));
 	if (md->attribute & EFI_MEMORY_XP)
 		pte = set_pte_bit(pte, __pgprot(PTE_PXN));
 	else if (system_supports_bti_kernel() && spd->has_bti)
-- 
2.56.0.385.gd3acb90ef8-goog

