Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794313064;
	b=uFq8fn+iRm2eHVs69AtNrxa9ewIi8iKxSxPA5cPtXiveQm77+yRSguQ5IhYz2wRU4QVF
	 lXELDWIwO708pi9JyRfKYM+tLA5cKReguO01ymJe7MSh+t/bQc/ctaAw7+g3IMzNcmM5i
	 PSfuchCXBLJYA3agc86KSjr9Tw3QiJOpmNWNoGrwW7m++Fnf20LvHZmkWrq5+Mzyu+g/j
	 uDyzJGd2KAd7rKXWIzDsilhZueI2k57Wsl7HBWKydKG6SUJuk1MB51LsvF0XqMKrGtop6
	 CS5gWddzPUASliTJSxa8TYhefJa5G2TCTJCbV83sOQ60sY7O7+KBMyznPGHwwPb2mjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794313064;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=Gy+owdWhI9aq49SvOXumwy6C5wawdvH/TU7Zgbh6cFQ=;
	b=vctDBqMZuem4rEXCgRRLIw78cZOLkRNXSMhDUnsKv+01MJWGz+G4isFK/MkfryZ0bl6g
	 BVOl7TWGt7wAbM+2QXNM5A51mhtzr1zJG8bu/OsiZDTX5NL28UdTNllmcP215f4jpTlbg
	 M60x3BBm+WykUJbjfiQTd+UlVMa5mK5yriIt6T45S8QbUnK52pTrfE+mbweIRdWXubMvZ
	 hhlPuRalOsgNMSZ78ylap8II7FDF8G9pkA1jdkbh5cyvFubq4x8SZlg1Jl9dM7J6SkQ6i
	 8U5q7nEijPcsC3gF80SxRIRLhNzOs254s9wjaLHTzYDn+N8xZYnNTe5SprkLWHvRCXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=fEir1LAL;
	arc=none smtp.remote-ip=209.85.221.72
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331E5606A337
	for <linux-efi@vger.kernel.org>; Tue, 10 Nov 2026 12:17:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 331E5606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=fEir1LAL
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-49187ad6a72so1391223f8f.0
        for <linux-efi@vger.kernel.org>; Tue, 10 Nov 2026 04:17:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794313062; x=1794917862; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Gy+owdWhI9aq49SvOXumwy6C5wawdvH/TU7Zgbh6cFQ=;
        b=fEir1LALKMuKNlwZMjIN94dfEx8f4aeYgDo/ciR9CyHks99jB3MF0OHzl42OY5Buu0
         RulElpuR0reJHDOeq3SZxcPlgRtV25WiNs6wtniZR+is6WAybrV3UPI3gxhk1Eo0LUgK
         rW3/BEt5d6Hbp6skziT3s8e2n+Ok53/h6ApKeihqc+1N4ByJPg8vniur4QFAjUi3heIe
         4LV/0C5rOYrQL0BBqoNCWZJlGltfJhNe49Mq04RrOa1de6jkz5IVTQSF+Jjir8wVP4qm
         0+vd9VWl+v37WeaL8Q4YFw0X62N+3D8EFYVulmqP/ytkqhsGNgqJZAjcZ9jOSvn3Sy1f
         eP1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794313062; x=1794917862;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Gy+owdWhI9aq49SvOXumwy6C5wawdvH/TU7Zgbh6cFQ=;
        b=ZPLfqCld/BQ1JoqOBn+uFCBVuEsUo2UIy2j3q39UvBM1tzbKuP1eHkD5nxuN6TLa8X
         LCj8nnOuDQhPzk0AYRvqdjMXig1oNyG4RJFM4ztbS9YnzWLpuWA9mxsEe8ltAh1Ft1hn
         gCHrb8H6VIGcyruYwaAme4ybjPJFfGHfGUPI4Bcpvc3BP9zVRUCUcp4Ae8pVRKMJBZFH
         SizneaXgF5JkoU/zm++Y6SzFMe4+xQftg10yKkNbI1ylYp1xwnMVjYnquamhHLaibxhq
         q6TVl110xx0RP4+5x3korn8D4z7G0TxS7MLTR94ctG2z/62qSdtWSUy2iqxzQvI2/giA
         XRvw==
X-Gm-Message-State: APuU4Z8v3DJoDu/Jei/PS0PJKWNvvambYGV+qg+Z+1JkunzT+522q4mz
	6D78AO/IKVdJE2SRbUZ+Pdilhg2vHKGosvHXwvOj6f+TenznI8YpKi4Z9mDJXhPLr48cg2b4gwa
	0g7qk4hbK0XJTyPedZbw0J0DUKrJRZl2HCzUYjGl6Sp+/ELWzKAgPHNXQ7XmvjljaBLFlFIbKAn
	8bZ24Rhjq+i1SepsWooVFjD5GihpTN/A==
X-Received: from wrxp4.prod.google.com ([2002:a05:6000:184:b0:495:feb9:bf43])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:298d:20b0:48e:202:6718
 with SMTP id ffacd0b85a97d-4982ecf6701mr3321662f8f.25.1794313062387; Tue, 10
 Nov 2026 04:17:42 -0800 (PST)
Date: Tue, 10 Nov 2026 13:17:35 +0100
In-Reply-To: <20261110121731.2728824-12-ardb+git@google.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261110121731.2728824-12-ardb+git@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261110121731.2728824-15-ardb+git@google.com>
Subject: [PATCH v2 03/10] efi/libstub: Avoid _end section marker in library code
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
2.56.0.542.g3ef89b7020-goog

