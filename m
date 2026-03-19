Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05F13B0ADC
	for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 09:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773911170; cv=none; b=j9XBlZJbVMVgip8xyinAqtyAQUlkos8jhMbEc6MPcwEN8g1DxitPNSGaprvO+TQSzCMWGRMtrThbw8Q19hN3jCUHi0cpKfkHJRV6foYwXfGaaz6+3EsUjz6TROkNLHdrg8PfNh6YH862gt42ZsmuAmyJoLzeTbTOc9GkW4aMySs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773911170; c=relaxed/simple;
	bh=854LtT0Mit761SGh8E/7U5q38tsJmJYsa8qexFXvjoQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aRY2uDjY+R8M+2OQ1NlA91ejjRGYc6uke9sWV8wJxLWaxHzRX/quQ4WkrbwRnuzCWLnL89eGEJC8JgbdSQwOxiHnfHWs964y2k/RfVC3S045tPsFZAsl4Zg+lSl7OuoY65cYn7MvpPrT0yTR9ZkbuCSl7Y8oRgY9wT+oxVdsepI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FH6Pz+OB; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FH6Pz+OB"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4852d27f473so2292635e9.1
        for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 02:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773911166; x=1774515966; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1rmEEk9Gx/T0XLLjgZJ4axQ0xMTHf7COba7Cc07zn54=;
        b=FH6Pz+OBbjEGiru9jVigRmYuBbKoZAF5LAMzshtqk3qNWqb0t5FbiwKbh34OXmE7MN
         kgSuwHgJMDroWELH1rxPraqk0lGsPgtI50/6VtW9Fa5KqJUCiTCIqS3oh1Jlntdcqqkd
         Lm0iVRPOLFFzhTZss+8s4yX09/M2rvUyvRIIrfq1Vvc6kJwS4jZQXVLYKWcSU/YS3/Xc
         dNOihUwS59sRoxfDz+RayBItZ8P//ctKHbhYq5su+i6kf3kqiD19dlA7sGMsR0w2ocuL
         L7xFexAtasLC/KVpCXk8hEl9AY7iTdeXgvmst3qT3HY+wU5MloLnJdIKSImsTaWU6y/f
         PdbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773911166; x=1774515966;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1rmEEk9Gx/T0XLLjgZJ4axQ0xMTHf7COba7Cc07zn54=;
        b=Gb60TdZhwZbTWdKeLhDrhDij/PeoI70maFrSJ5Q1xb6EL7tTa9knCKTpHU8JTxy04c
         POWIkQXlNcWFDy6nG9I8SeF+11TJnV5Iyo15zYjAJNSatIswym5fv6OVEQkpknzqEEI2
         0qqsGEYOtBRjbHRP9dylUzRE/eVPUWqt0zCmV8EoBol/SaCERb+AKzQ2LapIhXx9nLda
         r2gb6bP1mJVJP1l3SKKBUnKjhFDT4XHK/nRy/fTswP3a8XpDsyz27Flmfnh7uaJzOEPT
         OeggkO7VwzoYPBnZS4qeY6MtGnvhsvyhWxzvELgbU4TL8QH0R8cbHEV1PQq5IbVWUj7J
         jY4Q==
X-Gm-Message-State: AOJu0YyIdornEmUc0YTzxrBKkI3gG5M24hbTfPyZSpILoTtZCcYH9l30
	i15TfPhYa8u5UofWQOE5Q1SVkRYNGV+OOpLyidLk56cJIl22fuGmp6XMCR5OrQAoZiJPy2wxFg=
	=
X-Received: from wmbg28.prod.google.com ([2002:a05:600c:a41c:b0:485:2fba:7a70])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8b31:b0:483:78c5:d743
 with SMTP id 5b1f17b1804b1-486f4460539mr107542135e9.28.1773911165742; Thu, 19
 Mar 2026 02:06:05 -0700 (PDT)
Date: Thu, 19 Mar 2026 10:05:34 +0100
In-Reply-To: <20260319090529.1091660-21-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260319090529.1091660-21-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1981; i=ardb@kernel.org;
 h=from:subject; bh=f/opshs+6rg0pwskhV0dEYjgzCkmUcLDOcw5+/P+l0U=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIXP3nnj2pwuzVmZPejLt++GGvp+mJ9xFnmuKznPq5pIIv
 SDP/ICto5SFQYyLQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAEzkUS8jw4dfExJ2XXpzOKbA
 MPtig7f82gteR+IyJ6wplozfa6Hz35Lhn45gx9UTJh1NhZG2+rcFc2T+T9z61/SZZDjvzj+Hczw W8gMA
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260319090529.1091660-25-ardb+git@google.com>
Subject: [PATCH v2 04/19] x86/efi: Drop EFI_MEMORY_RUNTIME check from __ioremap_check_other()
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>, Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

__ioremap_check_other() is called when memremap() is used on memory that
turns out to be reserved. This may be the case for ESRT or MOK tables
that are reserved via efi_mem_reserve(), in which case they will be
covered by EfiBootServicesData entries in the EFI memory map.

Such entries are created with the EFI_MEMORY_RUNTIME attribute set, to
distinguish them from EfiBootServicesData entries that were reserved
only temporarily, in order to work around firmware bugs.

However, given that
a) __ioremap_check_other() is only called for memory that could not be
   mapped using try_ram_remap(),
b) on x86, the EFI memory map only retains EfiBootServicesData entries that
   cover a permanent reservation,
the EFI_MEMORY_RUNTIME check is redundant, and can be dropped.

This removes the need to set this attribute in the first place, which is
desirable as it results in considerable complexity in managing the EFI
memory map on x86. This is implemented in subsequent patches.

While at it, use switch() rather than if() to avoid multiple calls to
efi_mem_type(), which is backed by a hypervisor call in some cases.

Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/mm/ioremap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 12c8180ca1ba..2d0e1cfb9054 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -124,9 +124,9 @@ static void __ioremap_check_other(resource_size_t addr, struct ioremap_desc *des
 	if (!IS_ENABLED(CONFIG_EFI))
 		return;
 
-	if (efi_mem_type(addr) == EFI_RUNTIME_SERVICES_DATA ||
-	    (efi_mem_type(addr) == EFI_BOOT_SERVICES_DATA &&
-	     efi_mem_attributes(addr) & EFI_MEMORY_RUNTIME))
+	switch (efi_mem_type(addr))
+	case EFI_RUNTIME_SERVICES_DATA:
+	case EFI_BOOT_SERVICES_DATA:
 		desc->flags |= IORES_MAP_ENCRYPTED;
 }
 
-- 
2.53.0.851.ga537e3e6e9-goog

