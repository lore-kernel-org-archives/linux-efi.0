Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6392936C0DE
	for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 09:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773911168; cv=none; b=e1IIBa+3Jf+Jb6ncWmmfrouwABsEfLInx2NVYLmumaIyG1G6iFlHZJa2+Fpeit8CyjSQC3A6h2nqTtvVa4/BPRiaVmp+RiIcKzufDnQmDb70yE6eYc8j0EvhkPxOKD3pxfVBKA9zWPmGl/ltPpjQ9Z8s4xxy/VZZZT+LeiHdIHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773911168; c=relaxed/simple;
	bh=SnsylKaR6XKsL6r4nGeFPuFvYgu+US9QjRHnBUE+4rc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dH2YqDCkUqDYPHma1Hv54v7YgdDGqiWioty5MbKRHX0UuIiirZU1BSxHVWvLnmVr3ajLRTybpdObTpCWng51/DOLPn+D6AlFmTBaTZmnEiGQKy7W1ivTdpWI8pD36HpH3M4prnayJUgvfUDBiQP9P0EiW6tm7unDNsFuOZPihyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g+JloLkZ; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g+JloLkZ"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-486fcc05b20so909025e9.3
        for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 02:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773911165; x=1774515965; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cN0DSOT4FMFHSpYhHh0KxRkDumLq71iDg3aOibYQgUs=;
        b=g+JloLkZnfVRXXdjfHQVG4MYYYRXgsGdeD1vQrkDP+5yc5xsAeQIhmix8fYr4VbfDv
         MSLc7jUeRDo5kj4FNRQHWPdzmPSjdyQLhBgdySGuFUHG0Wck2d5ihLJUTBYrzxV5ACSo
         1R8X7Vd4Zkj7DWE4wBT5H0t6A9PnYFBzA7fV06t6eKO756dGZ7jayaNg+6E/rer11BH1
         BGE5e4HSZCtowx6LVddKHhIseAZwI1z1EOhyTmyyfdj/N8WlUbQZxO+TP0GeeU6E4Z4A
         RmThAoynODf0978rSSTqTv2TtLGL2vdXMNvwe2svx6ZBnku7yh9MrQyLIRNmj7RtoLQ+
         A0CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773911165; x=1774515965;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cN0DSOT4FMFHSpYhHh0KxRkDumLq71iDg3aOibYQgUs=;
        b=qYCvntb9gg6h/ra/NFFwjuQYiRehzlJ3uaHLVvi4qhk7zVn+HMvnSc2YaOJ7mWI5If
         QX9YlxFgy/NmW3uMwTJFe2tmBLm8qlmlU0O0aK9dA3gjMxI438ybxPlf8ZhURq6upeqK
         cP11o4r/ZjCWZmVFwcH1Ro3poSM8uy8tlE8MHyA95k3VXzVFuVqT0ON5rgB6FZJjrwHH
         B/QhfwGPgEkESuxR7Ak8RTv4cJ6g29oQVlwWjP3POu9xuSahxYMMabznYPnoeVFT+Ca7
         0i1RXdHgL7QwExmZnSa1EO5k15LXVTNjxNAvnOkMIw1lq3AePNV1FHjy1JMPuqYQaxtt
         3qhA==
X-Gm-Message-State: AOJu0YwdWNQwHCRdc8/1n1UY41B4RyZxR75f7P30Xk374t6cGtUb6QIG
	XcQnb0LNAPaEfYZgLAhd0Y3qfWdVZ75N/+cF0Cze02bHHAOOQkdYkseLHgYmE0s1u6w31ztYMw=
	=
X-Received: from wmlu26.prod.google.com ([2002:a05:600c:211a:b0:486:f89b:7f11])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4e49:b0:485:4136:99a8
 with SMTP id 5b1f17b1804b1-486f4441072mr95249125e9.22.1773911164511; Thu, 19
 Mar 2026 02:06:04 -0700 (PDT)
Date: Thu, 19 Mar 2026 10:05:33 +0100
In-Reply-To: <20260319090529.1091660-21-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260319090529.1091660-21-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1532; i=ardb@kernel.org;
 h=from:subject; bh=JO9hOFF5DJXI3o8vMSXVUdCxa1qCtfQllbLj7lJACi8=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIXP3ntgl865zO81VqV1yL3TyltBDlcfiFzrvC58rtMM7p
 uWkaPqyjlIWBjEuBlkxRRaB2X/f7Tw9UarWeZYszBxWJpAhDFycAjCRk1sZ/qnf1H3sV7+s+ahI
 UOeTy5sZLjgs6TojF8GyQ2PPwzNSL5oZfjE1PlD65qXyb10jR/dfiQ2z/Q3muL9WKPfS3vA1X+g kHwMA
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260319090529.1091660-24-ardb+git@google.com>
Subject: [PATCH v2 03/19] x86/efi: Unmap kernel-reserved boot regions from EFI
 page tables
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
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
index 35caa5746115..30b8012eafaa 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -442,12 +442,6 @@ void __init efi_unmap_boot_services(void)
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
@@ -455,6 +449,12 @@ void __init efi_unmap_boot_services(void)
 		 */
 		efi_unmap_pages(md);
 
+		/* Do not free, someone else owns it: */
+		if (md->attribute & EFI_MEMORY_RUNTIME) {
+			num_entries++;
+			continue;
+		}
+
 		/*
 		 * Nasty quirk: if all sub-1MB memory is used for boot
 		 * services, we can get here without having allocated the
-- 
2.53.0.851.ga537e3e6e9-goog

