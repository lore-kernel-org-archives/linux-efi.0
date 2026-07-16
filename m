Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A44420491
	for <linux-efi@vger.kernel.org>; Thu, 16 Jul 2026 12:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784205846; cv=none; b=dK+IKyIp9IhsT9Wc/2AUDdB+oBTHEgOrSkIgtosH4pgNucmOcSnj4uheWtKc9jFpEQYqfo8LPd0Wk2R+ytXRPI1GnFg3mllf82VWfUHLOk7qbpcvCWDBxQb1di5+v+J2rFBF0ePkaJkhoQJ2r4fxDYmhyYxcQsxA4fOCQvmVvO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784205846; c=relaxed/simple;
	bh=1jB7gIqPJlL2X3fTP78amNRlL24ELpsJZv6OaAlT5aE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BBXSYcmjPCs47jtBrX74BO8wQfrmHtAgwp8UDDrK9eHTM1Gy4CT0JulUVw0u3M+5f/R3us2mWC0f++dr6g/5LmLgflUHvgbdXmzA6qjRxrlAz9ipNfQmkN9TIkhruDKxXW57a6bVtbT+wKx2tSFFy8ZWcdSaP6x8pMDrCj5qlJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=eo10wiwM; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="eo10wiwM"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-c96b08cdd1cso4440158a12.0
        for <linux-efi@vger.kernel.org>; Thu, 16 Jul 2026 05:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1784205844; x=1784810644; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RVEhlrHEVqIN0Ar3D+s2eFCiOScwlS1S3mz2hTaXKkY=;
        b=eo10wiwMJQKMiTLy6l++isI9WnaIKsrmIMX98HY/aWNRTseylUp9wXtVLd48pDhNVv
         w8Prp7kvIZcZAwIkecfTumAPfcs9aF5hn/PVmZIL9gXKvpO5wgwoVZG7GdshGTRAVXxv
         zl1KJ13PB5ybYnl9+YYLN6JmdfLRPq7XvZMSBFUvgHiIs2Uub+7PhboAACzDXZ78iz3k
         59NCleD1Im9lQyKT1IpSC9aFZE/8vf090gL1weV2QdydCYdAp51EDhNb/HRXDUpC5Ukc
         052I1oev5G6ieXJ/r+oosCFIZ8lQfQgo2KfkidFSMZ9Ene/usGtZIv4E4m6a5aZARB4K
         F/aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784205844; x=1784810644;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RVEhlrHEVqIN0Ar3D+s2eFCiOScwlS1S3mz2hTaXKkY=;
        b=Sxojl6NgWxSXe4GU53jvZ1Qo+z8+OvnKQr/NjR8M9j3DDAIYMGd+biCupivCJpVOyq
         almLvdG4UHJPLcDAuj6uJmW+X/igUKUnwNDAzG63eFMmzRfuBHcYZukZfAcgSX5aYaEH
         7u24YZBdDxiHjmyw65I9MD7Z1pdMJ1p3ERuE4MAPGtBuDY7Hrv51zdl/lyKBfrWYNtrk
         lJRvUMgaAkrCI0D2d9SnuhDqpqOWfTra0TD5shf2CWkkdmRKUPCkLWpqF3uNcWiXtkG1
         bAUoi7rvSYtRUY8pSVEH4tAW4TYefE0ShA/dM1wHv+B8mTshS3hQXcpvR10pfFaKqP6d
         4E9Q==
X-Forwarded-Encrypted: i=1; AHgh+RqJtXq34vTOVtv9twCxZIMke+mz8CMSnWbhbW8noIorcesl5akoHcrWx21CNgCmuqVJJErSfjc7bIc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9J8//LSANWbKpdTFsI0nTYB4vD/HG5OUr8H22Fjh+DJFeHnBy
	Cfqm+dxgKqmXBIKUK8NBI+kPbrmwv55mux/XHQzyF2pRQYxoS5WEwBW1yz4XsoxGpN4=
X-Gm-Gg: AfdE7clcqD/GFCGlrnEFm5X1zybko5sKDWWiQQpvnRrLof1TPPv2vmXmWFSddd9ZpTk
	QL2W7QR9pd+M5/uQnyIDTzM6PzFcQqZe1wYe7gn1S6tZxY+pvjO1zAzm/cCgp0iij5JsW6snbz6
	1T7V5JzpvPJwbctZPtm9GN86SIBZ1RM696YzK7b69jn2+xyhRvYdf37PqZ7wk9IlDlhE703T4I/
	p9p9hLUVDJAXXGKI7ZI0VnEihG8ulLO4XQQvsDuGdNPeB0addH15l6x3PBkf2kklxG30uptQo2H
	ZM6Cr3Gqu3N75cZFIqmWlgEf2Oe3kIvCKoy04O4SIXPBQlX1OUcp+g5nLD9+jUNJILGvPK3/5mn
	lkoL3MsNtb22ZDemR8uhnClt4+SPX4wOirnn2DupkFgAxO2QGEqDdtm3HiIH+1eUsAX5LcXUUWI
	95+9eoJATak6VzlojQsxl9LQQ=
X-Received: by 2002:a05:6a20:4308:b0:3ba:cd5b:3dc8 with SMTP id adf61e73a8af0-3c36c1f1e9dmr7530059637.31.1784205844222;
        Thu, 16 Jul 2026 05:44:04 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([2408:8606:1800:501::2:f])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cb258eeaba2sm1730793a12.12.2026.07.16.05.43.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 16 Jul 2026 05:44:03 -0700 (PDT)
From: Yunhui Cui <cuiyunhui@bytedance.com>
To: linux-riscv@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	kasan-dev@googlegroups.com,
	Yunhui Cui <cuiyunhui@bytedance.com>
Subject: [PATCH v2 09/15] riscv/mm: avoid Svnapot consistency checks in ptep_get()
Date: Thu, 16 Jul 2026 20:41:44 +0800
Message-Id: <687dadf430c49a840e24976e37ba09f991bc3222.1784201104.git.cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <cover.1784201104.git.cuiyunhui@bytedance.com>
References: <cover.1784201104.git.cuiyunhui@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

napotpte_ptep_get() builds the returned logical sub-PTE from the
initial PTE observed at the target address. Neighbouring entries in the
NAPOT block are only scanned to gather accessed and dirty state, so they
cannot contribute PFN, permission, present or writable state to the
returned PTE.

Drop the range consistency checks from this ptep_get() path. Callers
that rely on the block-wide A/D view are expected to hold the PTL. There
are generic lockless ptep_get() users, such as userfaultfd_must_wait()
and HMM walks after pte_offset_map(), but those paths use the present,
marker, write and PFN state and do not consume the gathered A/D bits.

Keep the consistency checks in napotpte_ptep_get_lockless(). That API
must return a self-consistent PTE snapshot to lockless walkers and fault
retry paths. napotpte_is_consistent() verifies that every scanned entry
still belongs to the same NAPOT mapping, ignoring A/D bits, and retries
if a concurrent unfold, rewrite or refold tears the range while A/D
state is being gathered.

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/include/asm/pgtable.h |  3 +++
 arch/riscv/mm/contpte.c          | 19 +++++++++++++------
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index e4b9c05014c00..dd56c20a817bb 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -930,6 +930,9 @@ static __always_inline void napotpte_try_unfold(struct mm_struct *mm,
 /*
  * Public PTE helpers may transparently handle Svnapot-encoded mappings.
  * NAPOT-aware arch users should stick to the private/raw __pte* helpers.
+ * Callers relying on the block-wide A/D view from ptep_get() are
+ * expected to hold the PTL. Lockless callers that require a
+ * self-consistent Svnapot range must use ptep_get_lockless().
  */
 #define ptep_get ptep_get
 static inline pte_t ptep_get(pte_t *ptep)
diff --git a/arch/riscv/mm/contpte.c b/arch/riscv/mm/contpte.c
index 70f9a0668b50c..0f66426b0ecfd 100644
--- a/arch/riscv/mm/contpte.c
+++ b/arch/riscv/mm/contpte.c
@@ -294,6 +294,13 @@ EXPORT_SYMBOL(__napotpte_try_unfold);
 
 pte_t napotpte_ptep_get(pte_t *ptep, pte_t orig_pte)
 {
+	/*
+	 * Gather access/dirty bits from the whole NAPOT range for the
+	 * ptep_get() view. The returned sub-PTE is built from orig_pte;
+	 * neighbouring entries only contribute A/D state. Lockless callers
+	 * requiring a self-consistent range must use ptep_get_lockless().
+	 */
+
 	pte_t pte, cur;
 	pte_t *start;
 	unsigned int i, nr;
@@ -307,14 +314,10 @@ pte_t napotpte_ptep_get(pte_t *ptep, pte_t orig_pte)
 
 	for (i = 0; i < nr; i++) {
 		cur = READ_ONCE(start[i]);
-		if (!napotpte_is_consistent(cur, orig_pte))
-			return napotpte_subpte(ptep, orig_pte);
 		if (pte_dirty(cur)) {
 			pte = riscv_pte_mkhwdirty(pte);
 			for (; i < nr; i++) {
 				cur = READ_ONCE(start[i]);
-				if (!napotpte_is_consistent(cur, orig_pte))
-					return napotpte_subpte(ptep, orig_pte);
 				if (pte_young(cur)) {
 					pte = pte_mkyoung(pte);
 					break;
@@ -328,8 +331,6 @@ pte_t napotpte_ptep_get(pte_t *ptep, pte_t orig_pte)
 			i++;
 			for (; i < nr; i++) {
 				cur = READ_ONCE(start[i]);
-				if (!napotpte_is_consistent(cur, orig_pte))
-					return napotpte_subpte(ptep, orig_pte);
 				if (pte_dirty(cur)) {
 					pte = riscv_pte_mkhwdirty(pte);
 					break;
@@ -345,6 +346,12 @@ EXPORT_SYMBOL(napotpte_ptep_get);
 
 pte_t napotpte_ptep_get_lockless(pte_t *orig_ptep)
 {
+	/*
+	 * ptep_get_lockless() must return a self-consistent PTE without the
+	 * PTL. Recheck that the whole NAPOT range still describes the same
+	 * mapping, ignoring A/D bits, and retry if a concurrent update tears
+	 * the range while A/D state is being gathered.
+	 */
 	pte_t orig_pte, pte;
 	pte_t *ptep;
 	unsigned int i, nr;
-- 
2.39.5

