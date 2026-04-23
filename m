Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EAA1344D85
	for <linux-efi@vger.kernel.org>; Thu, 23 Apr 2026 15:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776957669; cv=none; b=RvyVDWt06v6M1QEUVjRd12UyjmnIwGEOwgCw2uPTOnPAd07K/8DHur7NpPpnx36hy05kqLT9YXSom73rO+UKubnFJcgRT+YoN7LoB4AoSOJFHFMav5kxSnkks8dfcgrnBMwckxAPmxkrKCpbN4WA0DRTq8EIFhEYWnfhbT6we9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776957669; c=relaxed/simple;
	bh=yXlZQvg17gY3fAUY4jJcduAUEt6ZwFpw/pQ46EpXddg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OcIOkqw6e0DZVwxQ5p9cI4MLNdDc+Rqiwt0zSbR9JUks0j/ORTwVKYLOFunU1etrmkowTNJ6+YVpLiguZoMkTyM98ek3caKmzO3odS13k7ZAVZ3vsT3kqU5Mja2o2GzScQaL4FWkASK5CoTzhU61VRWxCtRMdYM0fKI+HsN8cNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vrV9AF+1; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vrV9AF+1"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43d103e46c3so4876344f8f.3
        for <linux-efi@vger.kernel.org>; Thu, 23 Apr 2026 08:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776957667; x=1777562467; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LbAiKGuplKRxB5rqKcaYbo7jdF2aTV0smrny3EZRzJE=;
        b=vrV9AF+1EpsRxvHSq5PDdUKdVYYh3rCGQM1murUeAp0SNAi+4S7u04fNcG/C5jITMZ
         whHtdY+QSDfPurWaQ7j6BhMMhClmZUPnidoYUfr0s9MGca8M3PfbQAV59hhBQEfzZYw4
         zYlS+kKGimCoKLHDnhko+gmuNmBjOQUemDFyR+uEq1dwpjJRKNALFkGaJ4+TfchjWjtt
         eo0i6d3tj1xmBhpOVQ/DsB+/DoRhwjT6vtR/EtmIOXidBk6YMVnCWAjhPPBsixELd01t
         Muvw04hcw2Y3q1I4LrOShyB5mfVo0DFedRZ+LkNq6jDdJHVIblRdVP/S9+22St1ZBNZM
         Y9Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776957667; x=1777562467;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LbAiKGuplKRxB5rqKcaYbo7jdF2aTV0smrny3EZRzJE=;
        b=RwvtaQPbWxA4xpnu/TVSX8tnqADkcii7T97aZ3tMXr1gTjo1dEBqJqioUMaipHjP+D
         LsvNqZ26dIlG4pd/Qhz8Hrxiiol7GCrQMMQnYyKq1qh322aUQbNqJ69sNQW+wcPGQa//
         t4O84mIQmEbilcF038g2eW9JtLLWfFu3cdJGO0JB0tzbSFIWBMRnv7aXGZkqMUobiNNW
         Nscx4S3MhpUvTS3hc3jQJaZ5zxeHzqZOvURUAN62zqhu/3HlzVEXnoMrd0mKAkAPNw9B
         1EQqS7TGr4knJ/yG1RFoEZQQfyJqwM5fe8yGCPKF0fPeuKiVGlemzDumPyQ3me/6rgTg
         prsA==
X-Gm-Message-State: AOJu0Yy8CBkO6U7wX+7oZul30JPHJhVnWyzX39+ikTWXQbR7W0tkhDrd
	MSsarQs0k+Y0gD5wNx80Ate4vKLJoxiryB7u8cCx94lwcIgh/DaGH+a76iZ9kV2H54nFpJhqbA=
	=
X-Received: from wrqu15.prod.google.com ([2002:a5d:468f:0:b0:43d:70b2:d29a])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2c0c:b0:43e:b0f7:9ce9
 with SMTP id ffacd0b85a97d-43fe3dc49c6mr44414203f8f.14.1776957666460; Thu, 23
 Apr 2026 08:21:06 -0700 (PDT)
Date: Thu, 23 Apr 2026 17:20:31 +0200
In-Reply-To: <20260423152024.1098465-19-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260423152024.1098465-19-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1544; i=ardb@kernel.org;
 h=from:subject; bh=XoOv4APS7l/c88gRUS9wFyxalKNkl5Mjj1u3QN7wgaI=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfOVxaEZ3lvnpK04VMAe7/nMeiLrMlV1tnBzzr01P+cK+
 s7/43aio5SFQYyLQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAExk7SRGhp1HRe167uYzSW7W
 5tD/Itw6LelaWUZh/cM5NSW1gsJdzAz/q+KSi8pq1586pDCryCI/2fK0pfj1rRIL/t26yJv05kk 5HwA=
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260423152024.1098465-25-ardb+git@google.com>
Subject: [PATCH v3 06/17] x86/efi: Unmap kernel-reserved boot regions from EFI
 page tables
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dave Young <ruirui.yang@linux.dev>, 
	Gregory Price <gourry@gourry.net>
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
index e79fb94c1bf6..1d10277796b7 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -433,12 +433,6 @@ void __init efi_unmap_boot_services(void)
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
@@ -446,6 +440,12 @@ void __init efi_unmap_boot_services(void)
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
2.54.0.rc2.544.gc7ae2d5bb8-goog

