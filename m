Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795708229;
	b=kZh8ApRn7nxr4BW0VEl44SULPXbnwDV2iqw+esiRMVgPO66IIk7hJNQaukl8JGmOcCfy
	 K3C+POFq4b/DxvB1eiGi6Yjct2xwkopDVHvTxC+lzfyBLe20W4doevyO4Gp0xrgo0iAS6
	 99aIq5qRFhwdwqdJ0pGYNI1kocGjryweBqVG18lJgkN1U2JyjVHDnJwI9I5k6ckSkIDwv
	 t0rnLOuFtpjQtsM1Tx5eZdrarJD0bAnxUGbBiV/9cyo9MHAaLYj8cZsY9sb+wvOLrOhnj
	 H1KtlWKnTbnkk+VDDM51kWWQyaCoCAjsvW3cC1ix26QWh81GmagL8xQF7AXL+ZSoscQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795708229;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Developer-Key:
	 X-Developer-Signature:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=rC/Xx94cadzkuHniLHfGoo8rPcnI5K0Jk9viyXYTTZs=;
	b=2qvrmzepPeydRhxcCAyTQgxObGvEly/Dr7IKE5pKiERRDw+bKJMZl3gcl5svhSfGsfsM
	 Wt40ZQxaduhxyMi4zFjB7XLqnhV2qGRBdVZJ/PRJCGW3PnLVOt39tJB3bDBX5VsrG16HD
	 Aq7XboCC11ONuwywSz+U2RQaNw+DhpBZ3mDyoO/GxdRHQyqk9w6m/pf53tDo8QhwKV/a/
	 J3ruWgsR9zm6hR3hxVEtfCEZZvrHcSGjsFTnz86eBiUlFOdagxStSAZfLfXX0aQIS757S
	 K5+G5izIES6STn/Qtbl/evGnwJM7aqlHmzJoB/m6FA5ogMJ9Elpsog556ugl91BiAVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=VoetQoO8;
	arc=none smtp.remote-ip=209.85.128.71
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597E8606A321
	for <linux-efi@vger.kernel.org>; Thu, 26 Nov 2026 15:50:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 597E8606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=VoetQoO8
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4bb69d84053so52704595e9.0
        for <linux-efi@vger.kernel.org>; Thu, 26 Nov 2026 07:50:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795708228; x=1796313028; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rC/Xx94cadzkuHniLHfGoo8rPcnI5K0Jk9viyXYTTZs=;
        b=VoetQoO8XdJWcDgJSf4zVp9CEJ/7dlkaKrtANZGkdiV2ofM0OkVQCgVPyuVJDzW+fb
         KT+CoEFozbepnpmin4VZ3a5Fd/4kjykNdIyIRAMKUi2RvpAB2Rm83WQdDci10HebhaJg
         LbKBUCN5xBe9omK2i3xWS1J/S8QglB60hXWUW8RvpqT+cj/5II0biVJhjw9wV1TczAPo
         MtOuuqwZENZzOHOFFzEJrMxdVVvfWP+kSNQGghTExHdbkjk5zoHlumq3PO6ipdbzmqOq
         iQBqPq38So24ZdXjyAYac4SAb2Ripj5eMODhT9GOEFgXoR0PWDm8xWJM0/MaMDSN5l8y
         pTwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795708228; x=1796313028;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rC/Xx94cadzkuHniLHfGoo8rPcnI5K0Jk9viyXYTTZs=;
        b=Fz4qR38jyz0GgAkuRR9OLbuzd88GQm6f9Tgq8cbdDbifWC9+xTNOXL6xURpwaJKhxd
         upIql15Ai/f8GxOIR+zEq3aR7yABamMRTYXz4pmS+542zOonaByvstqzmZE0dUQo7MWe
         cwXSj2nkF6Cmp+P6S0QOUojbooh6DgCsxQyWww7x0VOG6rar+4manwYXFBnou370Ahdb
         zhCUxVfvehKrGAkfHIIpHaC/f6PBaaZeWXXrdxbAosogc7XZitXkt9zN8gEqCOtlkVDI
         6JUNpYtB6KkpeGKbeIdKlhWAJ0fyarlnEE2HK1S8SRKrUvKs4L0VS2bKjllGiBVE4JqH
         uWLA==
X-Gm-Message-State: APuU4Z+VYjfb6Wtb+5oMxTj6pbrtIZi/HBjgA7o98wzupHJs5q+ZqTIS
	SjNZ/RKhYXFK/fuqEqo47mB/pES18bFcPNhR206OxVA2vVnBX7iYEbpQA9igvAgmj+vylLr1dlb
	WN/yb0lEgLrBzRdKYKZhimhzzNaPLA+GjR8+yYzC9LvJhI1V34ur1amY/M6eIS2orRisXYkBbXo
	eE5eWbcMu2TJGTI08Rks4AnYkXORC84A==
X-Received: from wmg25.prod.google.com ([2002:a05:600c:22d9:b0:4b6:4096:72ad])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:64c7:b0:4bb:68c4:2044
 with SMTP id 5b1f17b1804b1-4bb887fe725mr408015875e9.11.1795708227448; Thu, 26
 Nov 2026 07:50:27 -0800 (PST)
Date: Thu, 26 Nov 2026 16:50:18 +0100
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=864; i=ardb@kernel.org;
 h=from:subject; bh=qsOZv8x2/phFMLuJ3s1xBSZujyHeWPP7wpnTP7C+N2Q=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIZsj1Kr+6FJeu4J2lx1HXCVWNadGK26aHedg/LP0X2rep
 byMu7IdpSwMYlwMsmKKLAKz/77beXqiVK3zLFmYOaxMIEMYuDgF4CY7MDKcOW8sFGHmJVPts+7W
 sjmnWNMSF0/39Qi+yfdI1vLz28cVDP8U1cIcZr9WbXI8UHRYKlKTbWLSBrYX2aFqh5jEFa96ZbA DAA==
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
Message-ID: <20261126155017.2401147-5-ardb+git@google.com>
Subject: [PATCH 0/3] efi/libstub: Fix library dependencies
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: loongarch@lists.linux.dev, Ard Biesheuvel <ardb@kernel.org>, 
	Dmitry Antipov <dmantipov@yandex.ru>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Dmitry reports that 32-bit LoongArch builds with EFI_ZBOOT disabled fail
to link, due to missing helpers for 64-bit integer shifts.

Fix this, and while at it, tweak the build so some of these dependencies
can be dropped for the zboot build.

Cc: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>

Ard Biesheuvel (3):
  efi/libstub: loongarch: Provide 64-bit integer shift helpers for
    32-bit
  efi/zboot: Eliminate unused code from the zboot executable
  efi/libstub: Provide library helpers only where needed

 drivers/firmware/efi/libstub/Makefile       | 18 +++++++++++-------
 drivers/firmware/efi/libstub/Makefile.zboot |  3 ++-
 drivers/firmware/efi/libstub/zboot.lds      |  4 ++--
 3 files changed, 15 insertions(+), 10 deletions(-)

-- 
2.56.1.839.g22a8290db9-goog

