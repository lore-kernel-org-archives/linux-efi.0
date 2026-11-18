Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026117;
	b=5O9/QrOhw9j5TcBqNxOuc0Umq+6G0YJPkbVk8dH5tIyWoYQMFHu9BGrAUyyG2r3TwWsn
	 OEbJy+IJszrsBTjAN+Hb2OOlpRgcZS0sF1Mwcll4oh5mZITDuXgw55ftBeQ8N2uq3yfau
	 tYQMuEvVADJUKY5B1MKIiCQCuQsGcF7Dv0FeZ7Ps4y0Wuc7RZzhTPIYGLNBEYrLZYKLqQ
	 DyC4Occ4SSyWIp5Ct9Vfd5PfwPxAcT28/KltMvQJBBkU9txiRr6ckTFozvuWFpLwnWFkv
	 G4gT8CtS1ReRlm7vjJccpw94nPPZpE3nOlHh1msfEwmgbNi6Os88DwhsILEwRVtQdPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026117;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=AHVLK8gN3JGtLR47/Vi3zFfCL1k2jq913taY3VtB1LY=;
	b=hUZkpqWhSqsooCBs8tY3bMJ+0144afVkgYYnfhlMkJugRId+sDQ5CsNrBL0tNXVOZMjx
	 W+DRYwJMBjYOyLhYh+56/0XCAWTeiB456U8eabNpSFw9bkT/hXkjOHffaEy5fRgGtVPoy
	 DxCpwLeiSIdOqMggb9W2lVvnHmL0FU4yCaKx+kj1Cf7Kpo7RFoJP0BiPKin6aC6lAGus7
	 hmLXD8gnq0a1Wz29maCtgn+wb5gihcGq7RPcwOwu2cXTW9tn0ys35tNihHtzZx5FAP/tD
	 XKq1zh4YopeAZNW1Mt77tfENIJReRL40g1Kops9CqVhPtkW7/Tgza4mJYvHdTJMQIHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=hZNFjYYP;
	arc=none smtp.remote-ip=209.85.167.70
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com [209.85.167.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C2F606A32C
	for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 18:21:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99C2F606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=hZNFjYYP
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5be3e0d9c34so517645e87.3
        for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 10:21:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795026115; x=1795630915; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AHVLK8gN3JGtLR47/Vi3zFfCL1k2jq913taY3VtB1LY=;
        b=hZNFjYYPu9gdViKK48yVel383u//hok2udJ4BxpnRkcTGok+v8KFC3k/imVFcoy3uM
         E4WujpF9MHoCW5yJX25LOT7nBJt+2JwEFmGSiMInAQwxydXjs678pbCmHSd66t73FN+S
         CemkAPTFfH2cIiIxaX7ZzN7OGIDfVu6B+iZIub5KQvPNk3EZf3z4026FJv3SCUiRHOLT
         lIA7zI9uZV/fFNrrqt947fMyRO1qE56DFFXSARjOiTOaL95dyfT8UoMuu7DkxMrLfP5j
         B3PLB7o0dnYycPg6E5xREFF9UThj9M4xqRS96vJns58jaTNw2TytY58x0dpjssBLl3/Q
         fGZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795026115; x=1795630915;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AHVLK8gN3JGtLR47/Vi3zFfCL1k2jq913taY3VtB1LY=;
        b=DxzO9VBYxuSgsEwubLaJaKLXGsCM7USLWFl7OJmthH5D86PndO+/5ElgQfWN+clWLO
         Acs2Czo8SGSgmZj+TV11ktTyk/dLfKNMDPgcIYCiOua6JUF0XenQ4Vp6ZitwPHIcdq8S
         fZVvW7MqRJyjUNRYpbNpw3XBue9PO237TNQdD8fhrpGA9pQtYAFl1IHgKRZKcPHKzN1P
         sLHJwgrLt9GSYTAc7iv0CBM/HPZx2kov1IPeDJWQm3yGnJW3Pdqt6UCQsCKLZVF3EiBH
         SXZYgT1lDxeZDIgBTGUFMgmLNgZ0IfX5+GzdvgkbesFJl9uX5bJbisJGNoSUgDGMtELr
         aoWg==
X-Gm-Message-State: APuU4Z+vbfqjSFaarR22KUyBZhvFuCgPETtLXGvlxrNV/ynjIxT0qqlp
	WpY+sj2mg1HCpbZ8vTgxEWexgOnxwNYT7MDo1ZBw9MzKXJIkRyRTisrpK9lWcTYMaDfuXSyHIh5
	S8pOnJ21IkcbO9maorOesmprXKSnVoeUsJFcCeu1cLZv4P8ppC7q/IOQhOhKgpVBQINkAx+zEBv
	pOrdAZ8e7MQ2bZRvm4XzNYGdQPUT6FuA==
X-Received: from lfbey12.prod.google.com ([2002:a05:6512:678c:b0:5c0:343:63d0])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6512:1322:b0:5be:516f:1b4b
 with SMTP id 2adb3069b0e04-5c1a9bfbef6mr1173325e87.28.1795026114420; Wed, 18
 Nov 2026 10:21:54 -0800 (PST)
Date: Wed, 18 Nov 2026 19:21:11 +0100
In-Reply-To: <20261118182105.1633603-21-ardb+git@google.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261118182105.1633603-21-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1269; i=ardb@kernel.org;
 h=from:subject; bh=tASZvRhKDOWjZ60RkT+IntWFeW/Kh2vWRn/QEfDreKI=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIevvm5msC79deuT9dVvP9cSTiye5ZGrz/fDZqu98+9iRb
 UvzA0OTOkpZGMS4GGTFFFkEZv99t/P0RKla51myMHNYmUCGMHBxCsBEFrAwMrz4aNTAevTAi5Xn
 a25PrLxmp6L9PXJNuGF4uKXwH+9Qzj6Gf7Zph5fNXC5YYXDQuCF/wTRJzW9dDzv6xZuPvubr3b+ ngQ8A
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261118182105.1633603-26-ardb+git@google.com>
Subject: [PATCH v4 05/19] efi/libstub: Avoid _end section marker in library code
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ardb@kernel.org>, 
	Jason Gunthorpe <jgg@nvidia.com>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The _end marker could point to the end of the kernel image being loaded,
or to the _end of the zboot decompressor image, and so it should only be
used in code that is obviously only intended for the former case.

So instead, use kernel_memsize and the image address to obtain the same
quantity.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/kaslr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/kaslr.c b/drivers/firmware/efi/libstub/kaslr.c
index 8f8dc335b3b3..b34e4599f0f6 100644
--- a/drivers/firmware/efi/libstub/kaslr.c
+++ b/drivers/firmware/efi/libstub/kaslr.c
@@ -125,7 +125,7 @@ efi_status_t efi_kaslr_relocate_kernel(unsigned long *image_addr,
 		if (!check_image_region(*image_addr, kernel_memsize)) {
 			efi_err("FIRMWARE BUG: Image BSS overlaps adjacent EFI memory region\n");
 		} else if (IS_ALIGNED(*image_addr, min_kimg_align) &&
-			   (unsigned long)_end < EFI_ALLOC_LIMIT) {
+			   (*image_addr + kernel_memsize) < EFI_ALLOC_LIMIT) {
 			/*
 			 * Just execute from wherever we were loaded by the
 			 * UEFI PE/COFF loader if the placement is suitable.
-- 
2.56.1.708.g77570a6a1d-goog

