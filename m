Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793069808;
	b=DKbyUX+h0P4//PRWZBSxYgQk3hhuJ9z+NR7yLRQKuTNqYXgMGbCloU7UqVBzzEQaBQeW
	 uVGr5hu2aFvKkvFOMGbBBI3tPYxMmiyEvwe0RKdqSWKRtSoRYtJ0CDv6l9Bz5A5fJZOZh
	 ESaGK0hRzxJAEce7Hwl/IMx/LK8ept/GogzDgHtfqcIp2QIVsDAh1lHYUPnmDwRBaQkxt
	 sCyBTOs9GLEINpdR1o8cmlzp4bKs83VgDJGF9bns+772TMxmzf6fDfMcT5nEFqkeDQ2e1
	 zCrQEgWpLdd0Z/Bowisqa4nxlasal07+BKUTfPfp7ywPNnPDImuSNM8cXYS6E4UrH+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793069808;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=U1tHH5Mqf99jycLltqjXTRn5xKYAyrIr2aHOwRziEw8=;
	b=lY1myVDrSdxKwRYtMRAnOAMjvuEbI4AYLfCErx3dxK6dm7KopPg4F7JCFYAm07xA08SQ
	 liZP37q6wAS6LT9kNJFiT3nZyRjYdhedx9m4tWXcCqYZ2qQhwZQAJFbIBLE70c6zuxqlW
	 pUk8QtpqcHFX1wTBhBh+NYatbcLgj2zpFEBJ5iVsgc3gvyjRiki2lJxGcZ5xoJTPUr/2T
	 dIIo0iPPL4202lYTpD0BRclEoMIifq1aP4waDtSbL+aX4gLntH+TycGkji2vawbh1UUsh
	 zsmnvEZQF6TCf9Mu5oFqL6PMP5PC+iAlIjpIFJNwDpp31jZpHOYaYtJe+qER5okHZTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=eRnTUYtx;
	arc=none smtp.remote-ip=209.85.210.70
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9AA4606A31E
	for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 02:56:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9AA4606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=eRnTUYtx
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-84478a97bfbso6844724a34.0
        for <linux-efi@vger.kernel.org>; Mon, 26 Oct 2026 19:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793069807; x=1793674607; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U1tHH5Mqf99jycLltqjXTRn5xKYAyrIr2aHOwRziEw8=;
        b=eRnTUYtxl2WJIZYJwL4u+CpIv3e0gmonfQevqXojOEcHwoYASWEfe19L3x4iMJ3rqh
         I8oGhMkA++aQemckBDM/JQIrbEpSAN3QnwouM0VC6TnWfW8CjzIJGJvAv+V4tJATSqia
         +gHiIqXRbmQBZPjiqqlQVwmNZVyKryXUAy9jBK/JnOM+X+DDeIfIfnUP8zYzGcDQVK52
         EEqrOqwQe8bLr3aYoyYL4SI/+IbyW6F9nWEON11RuuwOlzmSVoMY9MFD1y+qHy6nJDo9
         jnVSPMi8H/ZvWrlP49Rbn138vbNg2y01j7TsRNDlq0INZit+Cd0qu1QvEFrX5+p94jzy
         FGgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793069807; x=1793674607;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U1tHH5Mqf99jycLltqjXTRn5xKYAyrIr2aHOwRziEw8=;
        b=K+Os7LAhfwDArqqPyxoqNp4lQRsDSEk43FdVpcmonsZYuT4iSPZ3NK8+TfG3pAv5tO
         xtgB342OoBgR48lRs/KWs13TC2YiEcjqbQLnG8BSq2bIIoqiHGWajpo5C5KYDEzkc1vF
         z28AOh4vscrYWCdgK94KYMVM0tZmuLTJu+MP5nY5A+B/qzmqcUiUeohdgLd25Jc7vw62
         7TGg1afqC6GjZjTyvBndVQPBZ+KIRVKGbIyP/Y/NxjsFsJ2uw+UVKCJ5A9/nbTIAKzZ4
         R3gEscBhoefzrl+8g/nlB7t+fxXMnDaCTCMtAAKVE4fK4vdVPoKWuKRzJtgsqalMa+UY
         IeQw==
X-Forwarded-Encrypted: i=1; AKwUvByHvrCeN93VnwmQkGwTYPda1Swa1kl4L5azLSU+6ZRC5G1nWYNqIehnaOBdsGdbP0jAzfL9MhrmZAU=@vger.kernel.org
X-Gm-Message-State: AFq9FYLoDWP08hqzDEOsG2hznzFjVhX1s5j8h7v9l6gGA6JNH2zIPilj
	yQYuvemB07jo21PbT0Poo/ctU2x3t6P3SldqDBTBcJW2VtGvUkx7nNXybKRecYMEoRrVeADNuvc
	8CUbiv8W/YcD5Dv0Cqbi/ScleWeNoiFCoMw==
X-Received: from ilbeu28-n2.prod.google.com ([2002:a05:6e02:2f1c:20b0:516:ba98:55b6])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6870:3929:b0:494:396:1205 with SMTP id 586e51a60fabf-4a83f49fec6mr6444601fac.14.1793069806655;
 Mon, 26 Oct 2026 19:56:46 -0700 (PDT)
Date: Tue, 27 Oct 2026 02:56:07 +0000
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
Message-ID: <20261027025616.1632690-5-kevinloughlin@google.com>
Subject: [PATCH 04/13] x86/coco/sev: fix zeropad #VC on unaccepted memory
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

When dynamic memory unacceptance is active on AMD SEV-SNP, an accepted
4KB page may sit immediately adjacent to a 2MB block that has been
unaccepted via PVALIDATE(validate=false). Speculative unaligned loads
across the page boundary via load_unaligned_zeropad() (such as in
dentry path walk) trigger a hardware #VC exception with error code
SVM_EXIT_PAGE_NOT_VALIDATED (0x404) or SVM_EXIT_NPF (0x400) on the
unvalidated neighbor page.

Define SVM_EXIT_PAGE_NOT_VALIDATED (0x404) and invoke fixup_exception()
in vc_raw_handle_exception() when an SVM_EXIT_PAGE_NOT_VALIDATED or
SVM_EXIT_NPF #VC exception occurs in kernel mode at an EX_TYPE_ZEROPAD
instruction before dispatching to vc_handle_exitcode(), matching the
existing EX_TYPE_ZEROPAD handling in the Intel TDX #VE handler
(ve_raise_fault()).

Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
---
 arch/x86/coco/sev/vc-handle.c   | 29 +++++++++++++++++++++++++++++
 arch/x86/include/uapi/asm/svm.h |  2 ++
 2 files changed, 31 insertions(+)

diff --git a/arch/x86/coco/sev/vc-handle.c b/arch/x86/coco/sev/vc-handle.c
index f25d302efceb..1ed00771d87d 100644
--- a/arch/x86/coco/sev/vc-handle.c
+++ b/arch/x86/coco/sev/vc-handle.c
@@ -18,6 +18,7 @@
 #include <linux/io.h>
 #include <linux/psp-sev.h>
 #include <linux/efi.h>
+#include <linux/extable.h>
 #include <uapi/linux/sev-guest.h>
 
 #include <asm/init.h>
@@ -872,6 +873,29 @@ static __always_inline bool vc_from_invalid_context(struct pt_regs *regs)
 	return is_vc2_stack(sp) && !is_vc2_stack(prev_sp);
 }
 
+static bool vc_try_fixup_zeropad(struct es_em_ctxt *ctxt, struct pt_regs *regs,
+				 unsigned long error_code)
+{
+	unsigned long addr, fault_addr;
+
+	if ((error_code != SVM_EXIT_PAGE_NOT_VALIDATED &&
+	     error_code != SVM_EXIT_NPF) ||
+	    user_mode(regs) ||
+	    ex_get_fixup_type(regs->ip) != EX_TYPE_ZEROPAD)
+		return false;
+
+	addr = (unsigned long)insn_get_addr_ref(&ctxt->insn, regs);
+	if (addr == ~0ul)
+		return false;
+
+	/*
+	 * load_unaligned_zeropad() faults when an unaligned word load crosses
+	 * into an unaccepted page; round up to the crossed page boundary.
+	 */
+	fault_addr = (addr + sizeof(long) - 1) & PAGE_MASK;
+	return fixup_exception(regs, X86_TRAP_VC, error_code, fault_addr);
+}
+
 static bool vc_raw_handle_exception(struct pt_regs *regs, unsigned long error_code)
 {
 	struct ghcb_state state;
@@ -885,6 +909,11 @@ static bool vc_raw_handle_exception(struct pt_regs *regs, unsigned long error_co
 	vc_ghcb_invalidate(ghcb);
 	result = vc_init_em_ctxt(&ctxt, regs, error_code);
 
+	if (result == ES_OK && vc_try_fixup_zeropad(&ctxt, regs, error_code)) {
+		__sev_put_ghcb(&state);
+		return true;
+	}
+
 	if (result == ES_OK)
 		result = vc_handle_exitcode(&ctxt, ghcb, error_code);
 
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index e80676185092..38b8e0c2f5e2 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -101,6 +101,7 @@
 #define SVM_EXIT_AVIC_INCOMPLETE_IPI		0x401
 #define SVM_EXIT_AVIC_UNACCELERATED_ACCESS	0x402
 #define SVM_EXIT_VMGEXIT       0x403
+#define SVM_EXIT_PAGE_NOT_VALIDATED	0x404
 #define SVM_EXIT_PML_FULL	0x407
 
 /* SEV-ES software-defined VMGEXIT events */
@@ -237,6 +238,7 @@
 	{ SVM_EXIT_AVIC_INCOMPLETE_IPI,		"avic_incomplete_ipi" }, \
 	{ SVM_EXIT_AVIC_UNACCELERATED_ACCESS,   "avic_unaccelerated_access" }, \
 	{ SVM_EXIT_VMGEXIT,		"vmgexit" }, \
+	{ SVM_EXIT_PAGE_NOT_VALIDATED,	"page_not_validated" }, \
 	{ SVM_EXIT_PML_FULL,		"pml_full" }, \
 	{ SVM_VMGEXIT_MMIO_READ,	"vmgexit_mmio_read" }, \
 	{ SVM_VMGEXIT_MMIO_WRITE,	"vmgexit_mmio_write" }, \
-- 
2.56.0.307.g5fe7bd680c-goog

