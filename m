Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E5B3AF674
	for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 09:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773911167; cv=none; b=VFeAmK6Ri4nn2Qj2zDq7EnGA5Pz3h4q8ItIgjlpFmGaMUpl1zxiXFvM7v3fDJHa8kQcV2ZSwHFZuqI2Uq1BGtuHofMEBcbF0TfWpo6S99Yg6if+zCF83l9v8nAJeDwcQuPRowIaL1xj1sn8yGt44aYxATmoZ6PEScghFlkIW1Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773911167; c=relaxed/simple;
	bh=K7LzeW+1GNQObLL0mpttPEC6ObCBqOhm8uDhYnRS0oQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hLdtnGUleKdM10I6GvG7g5479F+G5+BKb2qPNPSdFzCIZuumeE5+hczHRiFRs1PBvS6gyC28hpabmXKpANerRp412z5Vzgzh05WUikqqVfb3ZbB0XGqZxY68iqsDRJtaxpP3WSTwx1MGx6WHasL7B2cpahghAq1oFTAC+Gyput0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jsiFOTtG; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jsiFOTtG"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-485397788b3so3467745e9.2
        for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 02:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773911162; x=1774515962; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VsWNL3bo4KHMv0mdy45EiTzsJhVneOBuPnWT5ACRpoE=;
        b=jsiFOTtGp8q4u400w/Qr6v8soCLI7YXIspFv4Cc4UtmBv9NTDcN+0nrnzV8wc0lV/a
         J7EtYcyOikuHo4H56Mc10VqKIbJl4GiMsCM/oPf3VtFBfUkUdOBcQ5X9OyIXBgUmXEUO
         cQ+1vXvSKjZBvj4DQtTxlGSWT4gfbd3QnWjEmA1iQgvdALWCtmiiAOHsgbakWMWOK2gu
         c4HwZaDvu6+Wi3xRHFBzH5zkXwENmsfnCHSssN5SJ+1xZ4r0l+tuqL6OfJumAMgy4co3
         5gwDVmaa6dlMzb5cziNkbdbwhqDClvYlfX+l8PfFtzhYGSIuhSTxtpxzEfg3SSuDMJib
         cInA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773911162; x=1774515962;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VsWNL3bo4KHMv0mdy45EiTzsJhVneOBuPnWT5ACRpoE=;
        b=XzrXnLTlXpWYDpWnwkc4pew8jJg8ffrdJQ/mRPJrVkFRDXy7VN2LbQm9U5cbjMrjmt
         tnV3Y/0m2jl61p9elLCtxNZPk4FvCtc6jnyU55ZcmHtSNImxrWiRoqW/gk2JUAuW/pTy
         aojZECLyitGHUXjMFVG9iiZQr9o94Q8reMsA4URm9owHmMM7ak0pguUAA/fmfl6sJt5m
         I8dYgI81gbAnC2soXc6ounbnYDUz7QVGznmOpyhrm/5+vUQ5MeMS0i5KuZRRAAkeeQKW
         1UmtmRTjcByxdRA0XQ3tGil8wGNCc07NqFa+f1v6KWPw/o/BNSZ4V+oosXYxvGo1CuFy
         G88w==
X-Gm-Message-State: AOJu0Yw9iWDvmMORZfGC00XRPuToVH7yIcPg9L043jQhTMtHFkJeiNdG
	GckuCwvz2ULEuvXQwu0iyZVmMoqxxz9yZ3fS9a8DP4mwa6MEsii1PFz3UsYOYLMWDzJxc/vmJQ=
	=
X-Received: from wmro18.prod.google.com ([2002:a05:600c:3792:b0:485:3f57:3523])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1d10:b0:483:a27e:6706
 with SMTP id 5b1f17b1804b1-486f442647bmr110126145e9.9.1773911162159; Thu, 19
 Mar 2026 02:06:02 -0700 (PDT)
Date: Thu, 19 Mar 2026 10:05:31 +0100
In-Reply-To: <20260319090529.1091660-21-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260319090529.1091660-21-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2068; i=ardb@kernel.org;
 h=from:subject; bh=p/YATWOCB2qrU14En0xTPnxEAeYpYsyvR5e6jBr/J4s=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIXP3nmit/rWqL44+ntaztsZOhY0/z03H3OZumPCXWU/CD
 fp2m4h3lLIwiHExyIopsgjM/vtu5+mJUrXOs2Rh5rAygQxh4OIUgImIbmT4nzJ3kfBnE5kNvPZf
 484G73UR5WNYuWfTT+PbVVe643IzlBgZDtY3aPkr7mjf0LNE3E3p3PTdN95fcbJ7mXVs8ol3f6K 9OAE=
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260319090529.1091660-22-ardb+git@google.com>
Subject: [PATCH v2 01/19] memblock: Permit existing reserved regions to be
 marked RSRV_KERN
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Permit existing memblock reservations to be marked as RSRV_KERN. This
will be used by the EFI code on x86 to distinguish between reservations
of boot services data regions that have actual significance to the
kernel and regions that are reserved temporarily to work around buggy
firmware.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 include/linux/memblock.h |  1 +
 mm/memblock.c            | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 6ec5e9ac0699..9eac4f268359 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -155,6 +155,7 @@ int memblock_mark_mirror(phys_addr_t base, phys_addr_t size);
 int memblock_mark_nomap(phys_addr_t base, phys_addr_t size);
 int memblock_clear_nomap(phys_addr_t base, phys_addr_t size);
 int memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t size);
+int memblock_reserved_mark_kern(phys_addr_t base, phys_addr_t size);
 int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size);
 int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size);
 
diff --git a/mm/memblock.c b/mm/memblock.c
index b3ddfdec7a80..2505ce8b319c 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1115,6 +1115,21 @@ int __init_memblock memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t
 				    MEMBLOCK_RSRV_NOINIT);
 }
 
+/**
+ * memblock_reserved_mark_kern - Mark a reserved memory region with flag
+ * MEMBLOCK_RSRV_KERN
+ *
+ * @base: the base phys addr of the region
+ * @size: the size of the region
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+int __init_memblock memblock_reserved_mark_kern(phys_addr_t base, phys_addr_t size)
+{
+	return memblock_setclr_flag(&memblock.reserved, base, size, 1,
+				    MEMBLOCK_RSRV_KERN);
+}
+
 /**
  * memblock_mark_kho_scratch - Mark a memory region as MEMBLOCK_KHO_SCRATCH.
  * @base: the base phys addr of the region
-- 
2.53.0.851.ga537e3e6e9-goog

