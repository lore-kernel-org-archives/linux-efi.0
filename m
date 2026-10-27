Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.161.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793069807;
	b=vlX0/hcxHWosPJEI3KzMn/lAZlqZGnlrtukA7q3XLwsQv1W84NvgEz1ric3Q3sjckpVt
	 LGKqc2VHBsUCEwwIaX5cVPGVDkC/7HEmAgaICfC+aLm+WapbQMsEJuGXQGIBAi+rLUoXD
	 vaAEdIMvWOCxXzq28cnTQK5JGNw1+RugbsR5+GPGLQuj8exF42gdXpeRokSG4UdmyraAR
	 fCA1g9XsuVaYWd2FkvG+e6I+BHSLBBo1pHKHms+5apCveW8tsNx4pjbNEWMCXdEUA7oJZ
	 LDyvALtho+kfE9k/AsQBNz9iYydHemQ1pWrL5Eed7BL5+iwDe413sPHnqpiQB9J3kaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793069807;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=nTmoe18Cl/4sVBSCzKT2MKtNZE6Kiks6IBw/3aH90Qo=;
	b=3g4ZhBGBxeOWQxDA9/b8Qenbr3yVrymNH6GBYTS60UxpGXF1NdGXFg6JUH1uX6cY2sfE
	 UOGWqHoG09q1XKYLJvU3OcJIIHUPsnKZzfBhBNUKf3yn9y0RVPWkzsOhnXiGIJJHwI631
	 UQzPi+lO7UDLA1ToBw1O35G8lg2P+9/izRbFkwSK5vQuCVG5Kk1bPXPPK8tIMcGJmTBw4
	 hYd3z4p6K3+3zwe3U//eW+YFSBMmjPjomJkjQi0kiNMOIuFqOVBxKBaSpw9iB3hcbJHZe
	 O4DND6ha17A3vxMI8aOEYuXOFguP4Nxs0sksjA0wK8LDnA5EzNyYN6uMBBV/KFmGOlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=Z62pXTP9;
	arc=none smtp.remote-ip=209.85.161.70
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D48606A327
	for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 02:56:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 40D48606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=Z62pXTP9
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-704a881f959so4365410eaf.2
        for <linux-efi@vger.kernel.org>; Mon, 26 Oct 2026 19:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793069805; x=1793674605; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nTmoe18Cl/4sVBSCzKT2MKtNZE6Kiks6IBw/3aH90Qo=;
        b=Z62pXTP9xfa3gTQxIGNoVXsy7duoq/uH7iqChJqgs30TMgADpDXAmA9S82vLp2oRE3
         5wt/Ko8E3RdUqvtjnwFDsI7l+rVT1Et/15PCRyAsE4mH91ws0QxpiE7p6SpFgARwTHgW
         SxSA/cQeNsBA5wr/7Al7NECagdmqb3FLzwI0ZuBQZXS/7tddFUKzIRZaOJJxMac81ZX5
         krShLH65S4N1/6bXrK6ZUftZkp+xO4gySYOailHgxJ+hCf1HmCxds1P0qvowL3WW4rMi
         bDEJM1dDoSzx/2W0w9+7OIPHu1uSWatpe4AD/8CHqO2f1Y6fZH3PCDKURD/Gebd1T6qM
         POkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793069805; x=1793674605;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nTmoe18Cl/4sVBSCzKT2MKtNZE6Kiks6IBw/3aH90Qo=;
        b=ttyJiqMMtkhtC2NQhFSLWMcRRmfYvgM++1/dl2BGFe9IXgmB5KXjYFeCJAUWRnuEgK
         WnPD6HGfq6579SWJuIsFHShAUDixPSBtFdB362fUBVGotBV2IQAFElk9QkgWdY0A/FjR
         SySqRhreSGslNG40mO0PivkYGT406lGsg1Xgv66mOD3PycXy4Ybpe3ZKdJPtMqcPC+tO
         woIPzPoQjAoQUaa7J8dLgLtQghG8OC5jbHPnEhTCaFZ/ThxmHGhmclSFhOL1JxfxcF95
         RVLpGyDd+WmteBBSLErSZRotZCVrOt7+Lkc4ZPEsSS7l9KD9fiBrHAjZoUlKY2KgTY1S
         Kt9w==
X-Forwarded-Encrypted: i=1; AKwUvByL3nF7OplKUFp3kRz2/EmM9UQYMqpkylPX6bg4T3LPziIFTYLLpZpNU86sSfka1WlfrnceLIegZ70=@vger.kernel.org
X-Gm-Message-State: AFq9FYK39OewvZloCPI1CZ6ixo8W2+aJifCMJkJrZeeY+o9j1vyoqFXS
	LVXwkKhPbMeQJbe3A0ZZJYIrhHEyNmp+js84vTdEZmlaGp4Xh7r/n93dFVbIBmNl769mBLtd+cP
	6gkRdfxGMg6glhALsNvB3TyOCFWmRFkU9jw==
X-Received: from ila5-n1.prod.google.com ([2002:a05:6e02:5205:10b0:50d:41bd:b30])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:c0cc:10b0:6dc:6e90:f650 with SMTP id 006d021491bc7-70ba0e0f19cmr3730965eaf.15.1793069804982;
 Mon, 26 Oct 2026 19:56:44 -0700 (PDT)
Date: Tue, 27 Oct 2026 02:56:06 +0000
In-Reply-To: <20261027025616.1632690-1-kevinloughlin@google.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261027025616.1632690-1-kevinloughlin@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261027025616.1632690-4-kevinloughlin@google.com>
Subject: [PATCH 03/13] x86/coco/sev: add snp_unaccept_memory()
From: Kevin Loughlin <kevinloughlin@google.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, David Hildenbrand <david@kernel.org>, Jason Wang <jasowangio@gmail.com>, 
	"=?UTF-8?q?Eugenio=20P=C3=A9rez?=" <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Alexander Duyck <alexanderduyck@fb.com>
Cc: virtualization@lists.linux.dev, linux-coco@lists.linux.dev, 
	linux-efi@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Sidharth Telang <sidtelang@google.com>, Punit Salian <psalian@google.com>, 
	Peter Gonda <pgonda@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Jacky Li <jackyli@google.com>, Steve Rutherford <srutherford@google.com>, 
	David Skidmore <davidskidmore@google.com>, Kevin Loughlin <kevinloughlin@google.com>
Content-Type: text/plain; charset="UTF-8"

Add snp_unaccept_memory() and wire it up to arch_unaccept_memory() and
arch_has_unaccept_memory() on AMD SEV-SNP guests.

When memory ranges are dynamically unaccepted (such as during
virtio-balloon inflation or free page reporting), snp_unaccept_memory()
invokes set_pages_state(..., SNP_PAGE_STATE_SHARED). This call rescinds
guest RMP validation via PVALIDATE(..., validate=false), handling 2MB
PMD pages with automatic fallback to 4KB pages on RMP size mismatch.
snp_unaccept_memory() -> set_pages_state() also issues a GHCB Page State
Change request so the hypervisor transitions the range from private to
shared symmetrically with snp_accept_memory().

Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
---
 arch/x86/coco/sev/core.c                 | 13 +++++++++++++
 arch/x86/include/asm/sev.h               |  2 ++
 arch/x86/include/asm/unaccepted_memory.h | 14 ++++++++++++++
 3 files changed, 29 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index eb2e853e950a..3f8809bae14a 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -432,6 +432,19 @@ void snp_accept_memory(phys_addr_t start, phys_addr_t end)
 	set_pages_state(vaddr, npages, SNP_PAGE_STATE_PRIVATE);
 }
 
+void snp_unaccept_memory(phys_addr_t start, phys_addr_t end)
+{
+	unsigned long vaddr, npages;
+
+	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
+		return;
+
+	vaddr = (unsigned long)__va(start);
+	npages = (end - start) >> PAGE_SHIFT;
+
+	set_pages_state(vaddr, npages, SNP_PAGE_STATE_SHARED);
+}
+
 static int vmgexit_ap_control(u64 event, struct sev_es_save_area *vmsa, u32 apic_id)
 {
 	bool create = event != SVM_VMGEXIT_AP_DESTROY;
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index c7ea9845351e..464a721f8889 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -514,6 +514,7 @@ bool snp_init(struct boot_params *bp);
 void snp_dmi_setup(void);
 int snp_issue_svsm_attest_req(u64 call_id, struct svsm_call *call, struct svsm_attest_call *input);
 void snp_accept_memory(phys_addr_t start, phys_addr_t end);
+void snp_unaccept_memory(phys_addr_t start, phys_addr_t end);
 u64 snp_get_unsupported_features(u64 status);
 u64 sev_get_status(void);
 void sev_show_status(void);
@@ -624,6 +625,7 @@ static inline int snp_issue_svsm_attest_req(u64 call_id, struct svsm_call *call,
 	return -ENOTTY;
 }
 static inline void snp_accept_memory(phys_addr_t start, phys_addr_t end) { }
+static inline void snp_unaccept_memory(phys_addr_t start, phys_addr_t end) { }
 static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
 static inline u64 sev_get_status(void) { return 0; }
 static inline void sev_show_status(void) { }
diff --git a/arch/x86/include/asm/unaccepted_memory.h b/arch/x86/include/asm/unaccepted_memory.h
index f5937e9866ac..931d1388973e 100644
--- a/arch/x86/include/asm/unaccepted_memory.h
+++ b/arch/x86/include/asm/unaccepted_memory.h
@@ -18,6 +18,20 @@ static inline void arch_accept_memory(phys_addr_t start, phys_addr_t end)
 	}
 }
 
+static inline bool arch_has_unaccept_memory(void)
+{
+	return cc_platform_has(CC_ATTR_GUEST_SEV_SNP);
+}
+
+static inline void arch_unaccept_memory(phys_addr_t start, phys_addr_t end)
+{
+	/* Platform-specific memory-unacceptance call goes here */
+	if (cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
+		snp_unaccept_memory(start, end);
+	else
+		WARN_ONCE(1, "Cannot unaccept memory: unsupported platform\n");
+}
+
 static inline struct efi_unaccepted_memory *efi_get_unaccepted_table(void)
 {
 	if (efi.unaccepted == EFI_INVALID_TABLE_ADDR)
-- 
2.56.0.307.g5fe7bd680c-goog

