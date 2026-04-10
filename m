Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF66739A072
	for <linux-efi@vger.kernel.org>; Fri, 10 Apr 2026 08:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775808039; cv=none; b=fi4Q4vLSdbufux1F2Los0MhnayAxVOUA7Cm3JHEqfGdOjxejqemJUH+OfcszpD2Z1GLVkmzEyktoqJl2ksrAcy4PQ98Y2ErVDQXtERnKE/D0x2NlE/Yl6fGoM35r3vel8r4Rzcgu0Nu+F+6TUH0Tlb0AE0PgDGF/jtnTs0BXgpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775808039; c=relaxed/simple;
	bh=xiBwRUwdD7mwCb3k1s6xV78E/2MQKEFPT4F6+ExAwmQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i+jdM9CUdhAU03hJzSEPJGgzu3IVhWHOtyTQhNB/eY16uLvTnoih9M9zY+3oZ0c6kqgWG0GkxI6uxKkarPNtc4/QbUzZHNjcs7FMJGVrKxFHcbXctH+ik6yte69AKI94KjbkmgHQQL9bOln/A3S5oLKScUTKvN7ZSvkV0daYW7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z2YEXOFK; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z2YEXOFK"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-488d1b5bca0so8935305e9.2
        for <linux-efi@vger.kernel.org>; Fri, 10 Apr 2026 01:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775808035; x=1776412835; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uwcAQPDDIrW1cFM9HvdigTfFfqAoQNgDOfizPxofehU=;
        b=Z2YEXOFKj8JUhSB7KyPkVZifrR4UQTSyfsc+9K2N8hwTc7mpqKBXneCZct3LQflKcZ
         Y8PDqu1wsvZAtPFm60V0p4PAdJ8qDQrOhGwrUpF8S1rXNA19z2fZDB8E/0lP6Wt7RMUs
         Ij1w6ktc8uh8EYJeIbErZlDJP6bpA2w0jSuJhTDyAh6e1ZfWEZKiimWidQzrp9A7g/xB
         aQnbcI8KKNNuL4Awlzrg2ZCiS5x7iT6Wvc+xNTTycxTa0FWO6PrEhVrFeg9mMU14BiMW
         yH+VflzcMu4v19mkXO+mGvgFmxRvTFW/YjKr1iVrz8GvmSWJvZlUjRjEwAdSDw458xjG
         Fq6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775808035; x=1776412835;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uwcAQPDDIrW1cFM9HvdigTfFfqAoQNgDOfizPxofehU=;
        b=RuRG+zISH/kGO3JFGia4ennPIxWMdJeD4ycDJyPMbmnW6z7uGosjaBF6dTlM4FBTRO
         tXL2bai8K/aho5duIWPuCT9xEZMpVG03YUgzu2lwXtoFrY2NiyKK00tgKv8PtxwBQWN/
         yeC4WQ+8B6qf7zwDtmWrNV95/0FKUhjJnp92T2XM3/IC//O+I7ryAHrufbCcEnGsHAax
         sQaTUH/gi2DRjgsUUovPcW+1Hh008UYLpjLMASeQStruihgCcgzxL4X7Kl1iH9GU+BEF
         10Fo7r9uhe8OI7LcYtcwo4WEgYzPbUUvNMs8l4TnFmISTsieIAM95gk+u25gSOPs2t3W
         8agA==
X-Gm-Message-State: AOJu0YzpUJO2EE3wj8t7/fZQjwT1wggPaW1RI0BO12sNKyPlWxi6pmJH
	fPxwv+4uiFSyf5ZPjeyOc/5SWr/kShSl7z96MWV4nBDv2chrmY0SHOaum9J3DJAH38F8yY7w7jl
	YoxN1Zj6i0A+2IvQmDLfA4+ZKhnV6JwsACFPe8GtD0al0en7lzsfypXZ86Faa1R/4+j8DiDA7vD
	DlT9XVNTUHcI9MJy7T6MlW95dGV4T5ag==
X-Received: from wrmg2.prod.google.com ([2002:adf:e402:0:b0:43c:fd30:98a9])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:c10d:b0:488:ae4e:51a5
 with SMTP id 5b1f17b1804b1-488d683d633mr16251785e9.15.1775808034928; Fri, 10
 Apr 2026 01:00:34 -0700 (PDT)
Date: Fri, 10 Apr 2026 09:59:56 +0200
In-Reply-To: <20260410075950.1687350-9-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260410075950.1687350-9-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1541; i=ardb@kernel.org;
 h=from:subject; bh=G2RtUAKBQckrIeEWiuJzklUVykG05lXyXKv1jbxIYNI=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfPGOoZHnG67pz06+TN2k0qQ5Ntq92SWB9P98iYWXV1cV
 fc649K7jlIWBjEuBlkxRRaB2X/f7Tw9UarWeZYszBxWJpAhDFycAjCR8hJGhkk68+dx1BasXttt
 Y73a6eIl0dYP/gUmnSe+KM7YI38ywpqR4Z3j3OoL8etuLTh8naFLz2i96R6juJuiP8LtWlrvztu bzg4A
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
Message-ID: <20260410075950.1687350-15-ardb+git@google.com>
Subject: [PATCH 6/7] x86/efi: Unmap kernel-reserved boot regions from EFI page tables
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Currently, the logic that unmaps boot services code and data regions
that were mapped temporarily to work around firmware bugs disregards
regions that have been marked as EFI_MEMORY_RUNTIME. However, such
regions only have significance to the OS, and there is no reason to
retain the mapping in the EFI page tables, given that the runtime
firmware must never touch those regions.

So pull the unmap forward.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/quirks.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index ee906c0c46c1..929ee71a140c 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -438,12 +438,6 @@ void __init efi_unmap_boot_services(void)
 			continue;
 		}
 
-		/* Do not free, someone else owns it: */
-		if (md->attribute & EFI_MEMORY_RUNTIME) {
-			num_entries++;
-			continue;
-		}
-
 		/*
 		 * Before calling set_virtual_address_map(), EFI boot services
 		 * code/data regions were mapped as a quirk for buggy firmware.
@@ -451,6 +445,12 @@ void __init efi_unmap_boot_services(void)
 		 */
 		efi_unmap_pages(md);
 
+		/* Do not free, someone else owns it: */
+		if (md->attribute & EFI_MEMORY_RUNTIME) {
+			num_entries++;
+			continue;
+		}
+
 		/*
 		 * With CONFIG_DEFERRED_STRUCT_PAGE_INIT parts of the memory
 		 * map are still not initialized and we can't reliably free
-- 
2.53.0.1213.gd9a14994de-goog

