Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993502BE7CD
	for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 09:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773911168; cv=none; b=Arw41MXKLUoH0Zo0FluYTs/C879chIxATTG8G8i0yQL/ZQ5+fXqcw5I7W5Cm+8OCAVbSCBTeho+LyUJ6TU4jrN6Tb4Gb1aRPzIrX+dSXKKTx+MEU5Qb2tqznUO1fMebMb8S9arEuUWIQUZFEeiyUKqa6kwGPiLD81HDpbpUjzCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773911168; c=relaxed/simple;
	bh=r9Vz9NqghlFORjUZYdo1Ptfh1K/PtuFgYpapuy/P9kM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nH2HUQgquAWvXnEsKcQEfI6F1+S4elrv9M/24zTwbZFw4RyfJXHLwioNpFNTN5ubRPY73uMTaNy+nzll0BZ6ogZLb2thhTuo9KmBnAvlHz3Tu9VStyPGm57Hi5QetESFTPF6d7+/q4Ab4pN35gqG5sftkKw0GN/efP2lg7J3j6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SSHxAAo6; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SSHxAAo6"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48532df52c5so7166175e9.1
        for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 02:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773911164; x=1774515964; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E1s5SdGot5lUTMBrHwcD4YZ4DKEFwdicOeXDJpxhF+0=;
        b=SSHxAAo61vpVdjF7yGxOrrqe7JvAw6Ub5PtQ7tH4btvDRy61HydXzaG0Xmgihw7nL1
         xYJu4In3ZHI1Koebo2NP2xBvTCveSlV2liw3oShiYC8Y1hY6CEcVoPVhly1AAfA7qIAu
         eguAtVhFrTAc2YOtFIi3tgw1utFlu4ipSKxKy1WFfkRTq/bDWf+XpZVGutsmRQMClFnl
         m4Bm5DBwRBH0NgKlce5wAo+dSNx5T5530RrFAAMyK8VdH1MpRwHp5S/sSh9Ka9hXfzTM
         9Bky71FmigjwHOUX443LM2N7BtbSXfgLmlJWOGdAzN+PP/IRWZ1VGkuyZbOAlieBkUfU
         RV2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773911164; x=1774515964;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E1s5SdGot5lUTMBrHwcD4YZ4DKEFwdicOeXDJpxhF+0=;
        b=NUyLODiMmk0ZVTWRzBqoJorurmXd7lctnhD3rpgYSyjS9eMUhGFWs5ksT2EfZCyxeQ
         EBtmBs199sDhjMJ3m0SLZ113+zH8t6cPNPG9IqpkIIfWU3V+vl82vLpBFzS3iVVVR7IK
         6Ck5fJZTxGhOEOgCo4X01OODIAra0t6BGBzdsbBUJCtgIVoMuB1wukz0ht5oUA/IPsKE
         /2ZLDiOLOVm8cc67o97zWev4XWXFLAFB32blRQw49vrID53/39DJOSJA3w9XzL7XbajB
         ChKBUBR+5s1XsQE5YDuUO/ACTXOYKAxq2PgSjuLrRujT0C1txzLfbPqsj9fxGWiZHyxx
         k53w==
X-Gm-Message-State: AOJu0Yy8Cph3WiGsXy0uNxQaAshr6cDaElBxiNdeTR6lz9+oD5nHSQkw
	RZcPVAJIVZiHdhWGaiXh1TLmWgFYWtSJpbVps+Oh1OkkgIONprH71E5frW/VRBj8fsYJbZUlXA=
	=
X-Received: from wmma23.prod.google.com ([2002:a05:600c:2257:b0:485:7f49:ccc1])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a7b:cd95:0:b0:483:71f7:2782
 with SMTP id 5b1f17b1804b1-486f44462d6mr74588345e9.12.1773911163415; Thu, 19
 Mar 2026 02:06:03 -0700 (PDT)
Date: Thu, 19 Mar 2026 10:05:32 +0100
In-Reply-To: <20260319090529.1091660-21-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260319090529.1091660-21-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1630; i=ardb@kernel.org;
 h=from:subject; bh=nZezo0cCrAQqX5A/WjlHKfqCVN4vt8TmOwEAeiC7jRc=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIXP3npgUw2jm3yzx3nkNP3avXZWxsf24iPP35vJY/vzlc
 n48Ig86SlkYxLgYZMUUWQRm/3238/REqVrnWbIwc1iZQIYwcHEKwEQWKTIybLvO/HDT6Zu5B/en
 Pv5Zc1eq7ZPkznu/EqV5X2QdnPY0ZyEjw4ZPF/InJmTzJHkqzLg74/DidHaPksWVspelq89IrL1 4ghsA
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260319090529.1091660-23-ardb+git@google.com>
Subject: [PATCH v2 02/19] efi: Tag memblock reservations of boot services
 regions as RSRV_KERN
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

By definition, EFI memory regions of type boot services code or data
have no special significance to the firmware at runtime, only to the OS.
In some cases, the firmware will allocate tables and other assets that
are passed in memory in regions of this type, and leave it up to the OS
to decide whether or not to treat the allocation as special, or simply
consume the contents at boot and recycle the RAM for ordinary use. The
reason for this approach is that it avoids needless memory reservations
for assets that the OS knows nothing about, and therefore doesn't know
how to free either.

This means that any memblock reservations covering such regions can be
marked as MEMBLOCK_RSRV_KERN - this is a better match semantically, and
is useful on x86 to distinguish true reservations from temporary
reservations that are only needed to work around firmware bugs.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/efi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index b2fb92a4bbd1..e4ab7481bbf6 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -600,7 +600,9 @@ void __init efi_mem_reserve(phys_addr_t addr, u64 size)
 		return;
 
 	if (!memblock_is_region_reserved(addr, size))
-		memblock_reserve(addr, size);
+		memblock_reserve_kern(addr, size);
+	else
+		memblock_reserved_mark_kern(addr, size);
 
 	/*
 	 * Some architectures (x86) reserve all boot services ranges
-- 
2.53.0.851.ga537e3e6e9-goog

