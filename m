Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E473B4A3F02
	for <linux-efi@vger.kernel.org>; Thu, 15 Oct 2026 11:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792065257; cv=none; b=rK+TE5XTP7KSPCeB3FBQv4FJw5W+UUg88CUOwvvBkcoRLJNXTEbTBKNWoDEun2S4XtwRCqn7+kAiq8F/6b67YCj1//bM2hBos2kDE2OvwsMBrQ4jXBEhjseUgSg6JEKXz9GQejK9JjTG1PcnQSO8wemxkSgHFf1lojecbCaGJvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792065257; c=relaxed/simple;
	bh=XpZQl1MrTo8GxfEbh5rxDFbPYEeKyGRby6iaYtQc9vw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=rZha7JOAyBB9xlDaftGyrbhRkClyf8mc8wZ9G6+pNWSeFVh4yJC3TmVUINESFKQjV8q5Z+BYcNnaZe2qcJh47A0WNnX5tm8qg0X97FiWCUlNchUP/pCbPykAQ3VNevvBmDUSL4mvdcx2r4J7OlcNPFABSY9tsr66OyGCSQRmSxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ufsxZ+jz; arc=none smtp.client-ip=209.85.208.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ufsxZ+jz"
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6b1c762be1cso3536592a12.3
        for <linux-efi@vger.kernel.org>; Thu, 15 Oct 2026 04:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792065254; x=1792670054; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VaOF3SX9PuP9+mnKSpoQErsfWZIENOxSHEW2HAnjgUc=;
        b=ufsxZ+jzKJmY//pLGE3LxkZuo8phawaWROcRRygMUyUkFfWUTK1FYjfHrOoBv5dkga
         RU/TLT4r/KAAkAKUOaNrzM7qrYZtNSd73G1je8I+etJLxMXgOlLcddiUkRTjtXUffpBY
         HCGDQe1Msx/qrtXktluqiuf8WiPIdpPbQSzVeqDxP9HDD4AD8FOiRD576w3qoVETq5FF
         iIR3ywbyl+2A3iVNVTmKj8y2E/1ol9Rzd8AczxZE+3WR5MXBTY+dmkucUuYzZM9W9HBG
         Tcz1HddxFtuicJ1nRm11/ukzHmjSjLJ4/elbyAQB4OPJx+NoiPsm9gi4mpFCDKh+e05u
         69mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792065254; x=1792670054;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VaOF3SX9PuP9+mnKSpoQErsfWZIENOxSHEW2HAnjgUc=;
        b=EiWT/wMtneTCsySqgAivZBWfRDJNMVGvL+mY7oKk4bOcqdSZACjQNxPXvGh1RTPQnE
         JFmxy2xrfjck2BLzPYKHzoBsBksL/GeTo7qdf6VPJmZ0kzbiUf4u09jnLO61kVGGouY0
         pHjJT0OcVvlA5YxpRepadrzbXCLptwatwTAj018ynFxOacAztISWDElDDpJyAgduaOY9
         YTGUsjc5t19XD9MczZD5fWHKmGbo1o+82/T/KcaOFCm2Kp7X0xPtjaxu40csvWmXm7Zw
         9KVSDSUaKIYlZTJ/LrEH7iv3I/IDdeybS1cb9j6yrjDLqvR2Nc5ghzf+i1jn2GVwQoJ5
         TIzw==
X-Gm-Message-State: AFq9FYLLxhNEXDk91bg1GWtX1vBxwhClyU+9jgxjYd7Ur6kfwq1mAI3Q
	JUvXtuw1CB6h+52a+oDp3N7+pMMRwt8S9J/FK1AtlhrUPJrpZI8r7+8og/dQhUj19jIXPEwGVcT
	UJ2+U5N4SbqP5ZmS52t1VJHGmS+Cwi3S6tO6BI5X4/V4OXmtWh3+8r0bpj9m1Ttha5l8uUJBZr2
	7ZROJW0hwotlyPRk7waR8konTn1/YFDQ==
X-Received: from eddy8.prod.google.com ([2002:a05:6402:2708:b0:6b1:d2d2:f82e])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:2b92:b0:6b1:ef16:1850
 with SMTP id 4fb4d7f45d1cf-6b1ef161c44mr6713554a12.43.1792065253599; Thu, 15
 Oct 2026 04:54:13 -0700 (PDT)
Date: Thu, 15 Oct 2026 13:54:06 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261015115405.212211-2-ardb+git@google.com>
Subject: [PATCH] efi/libstub: arm64: Don't use the platform register x18
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The UEFI specification designates x18, the platform register, as "do not
use" on AArch64, so that UEFI code is compatible both with an OS that
assigns a fixed role to x18, and with one that uses it as a temporary
register.

The arm64 EFI stub and the EFI zboot decompressor only avoid x18 if the
kernel is built with shadow call stacks, as that is the only case where
-ffixed-x18 is added to KBUILD_CFLAGS, which the stub inherits.
Otherwise, the compiler is free to use x18 as a temporary register, and
it does so.

So pass -ffixed-x18 unconditionally when building the stub for arm64,
so that the image can be run by loaders that rely on x18 being left
alone, such as a kernel that uses it for its shadow call stack.

Cc: <stable@vger.kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 564773c89d14..e13d4dfe27c5 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -21,7 +21,7 @@ cflags-$(CONFIG_X86)		+= -m$(BITS) -D__KERNEL__ $(CC_FLAGS_DIALECT) \
 
 # arm64 uses the full KBUILD_CFLAGS so it's necessary to explicitly
 # disable the stackleak plugin
-cflags-$(CONFIG_ARM64)		+= -fpie $(DISABLE_KSTACK_ERASE) \
+cflags-$(CONFIG_ARM64)		+= -fpie $(DISABLE_KSTACK_ERASE) -ffixed-x18 \
 				   -fno-unwind-tables -fno-asynchronous-unwind-tables
 cflags-$(CONFIG_ARM)		+= -DEFI_HAVE_STRLEN -DEFI_HAVE_STRNLEN \
 				   -DEFI_HAVE_MEMCHR -DEFI_HAVE_STRRCHR \
-- 
2.56.0.385.gd3acb90ef8-goog

