Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB853EFD29
	for <linux-efi@vger.kernel.org>; Fri,  6 Mar 2026 15:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772812651; cv=none; b=j5l1sK3pZnO5nSTuqIcZ6CniRIUyH4P/kEX//B9hbTVHQ0hPcSpY3RyolQseCSdixLg9/ykkpAvEe1hyk2qtvO5NDX/jVaDOoVmc5vLjGVCKv0Zd1cMzoqRtsgPFzDdpjmVQw7vv8KX51TbvBMXs1fXdjLFi3eWTV9Qtj/E9OuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772812651; c=relaxed/simple;
	bh=NTukV1lib8v+vpZCsopNIIYxXpLwfNJUh7xyQcr+uoA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XUv5qOac/292cBFmqq8fRA2ql9gLljpLP2t8F1Q17zwHSH83wQziCd16K5QODPJOh77ajlAW0v3ATTPZmON+2asgKetIWy9mxF2f2UCySD5z385gsa+nazZ5LcEok9xU45EclUS1i07zeNFTXGszbO833Tc6zcioVPQ50l4vzi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sNnDzOAM; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sNnDzOAM"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4836c819456so72083455e9.3
        for <linux-efi@vger.kernel.org>; Fri, 06 Mar 2026 07:57:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772812649; x=1773417449; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kVq6C3tTKNfvUg57fXa3zcUeuZQjjjP6B3JtLdaXvj4=;
        b=sNnDzOAMagM07YDByKVoth8d3PyOJbwZAEkQC35xuKWbRJgThhT1ZoDjxqTI6ARFmA
         JfwvqEk65RuSVCZ/jNV82GDWtIVI0vJPOZbomtYV10+Cx/DKrGof/HA2HJ6tRYNHfqfv
         wzY+SK0amvyR2x6ITZ+KsuaRK+4xdwBMJ0RMfin5xT96z70MA+WnQwkXnMOYC0pzirWP
         fRrvd22eXOq+kGen9l1tX5nSXcCNVKzbXM9qCRvcrh6cOQX4U9j5IvRZ1En1H2Q8fT60
         oYEYQCz7REUQWnhoQQbxB0Iu5alk3fuhyMFyZK1ByOO7oHGkq/dRDSsnfYX3hlxJMrwW
         Xs3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772812649; x=1773417449;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kVq6C3tTKNfvUg57fXa3zcUeuZQjjjP6B3JtLdaXvj4=;
        b=qCZDMNXcjvBNt6Unf/PkEYK0vwiKGvpUTiY0ppyON+alRkTEBKbv2YQEcxba84XfKB
         9QTjkhUXD+OAzwc6h6o1YWWask4WzS+JsAusHJQXcy4KpKbZUEhSt42TX/OYHeqZai7V
         oIjHs40FsY8X7ApICeTMjyTSRHLVUwHmmNmNEn7EichASt6Url/gJNTSwiI9yYCamzjL
         5Ox/bEESwNMQj9kPQicORUm9VdgRQzI4x9Q1V6CV74BIyHNs0H2H9PHWTWiqqX8l1peq
         5iYuva/CcmRP6DHmDQc19sOy7QT+PGGnOuighGDmn6lJSBryUWAtaxT0pL3td3kC0mRF
         7hTw==
X-Gm-Message-State: AOJu0YydTOUZwv542H8tze4lEhOvK32FndR1kQlKlvlUwRItbPuyj2q1
	MYD3JDsSv4Xv1t0gNCvZ3hpG3//KgX6cZHPaVOXrlN9owMxbv++dICWS8jmp3mgMefP9guXw1w=
	=
X-Received: from wmqn1.prod.google.com ([2002:a05:600c:4f81:b0:480:4a03:7b7a])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:c16d:b0:477:afc5:fb02
 with SMTP id 5b1f17b1804b1-485269581camr47830975e9.21.1772812648681; Fri, 06
 Mar 2026 07:57:28 -0800 (PST)
Date: Fri,  6 Mar 2026 16:57:14 +0100
In-Reply-To: <20260306155703.815272-12-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260306155703.815272-12-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=967; i=ardb@kernel.org;
 h=from:subject; bh=cmG4a34xlBm+ipBeX0cGGT+ZotSRXaNsY5p36e9IOq4=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIXPVz9BvnuuYPXdYXp5e/+PHv7bVAoEd25fXSMyf+p659
 d3hfR19HSUsDGJcDLJiiiwCs/++23l6olSt8yxZmDmsTCBDGLg4BWAi624x/Gh9cf3PldovajMT
 g7wMVqqc2yIRsWqWyMmoKwsND7yx12L4Z2y/xkGjsEzxttNV6ZPdXn8Zrh50/33StqxZvcZjiZI LAwA=
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260306155703.815272-22-ardb+git@google.com>
Subject: [RFC PATCH 9/9] x86/efi: Free unused tail of the EFI memory map
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

After moving the relevant entries to the start of the map, the remainder
can be handed back to the page allocator.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/quirks.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index d7a64b404bea..4d94b1e82c28 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -475,10 +475,15 @@ static int __init efi_free_boot_services(void)
 	}
 
 	data.size = new_md - efi.memmap.map;
+	md = efi.memmap.map_end;
 
 	if (efi_memmap_install(&data) != 0)
 		pr_err("Could not install new EFI memmap\n");
 
+	/* Free the part of the memory map allocation that has become unused */
+	free_reserved_area(new_md, md, -1, NULL);
+	freed += (void *)md - new_md;
+
 	if (freed)
 		pr_info("Freeing EFI boot services memory: %ldK\n", freed / SZ_1K);
 
-- 
2.53.0.473.g4a7958ca14-goog

