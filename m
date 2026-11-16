Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794839240;
	b=uMhpr5GSucLzfG3R8WZpx9zVHwY7nYjzIwd5be/vLmxTqmU+ohLuH93lFceL1XK9tzEj
	 DA41O0BSaakgwSUlHeD7LWs76CGHYCDqxfNjRPmSf083Fl1psR18gUA5pqjbXYQ6Y7dm6
	 C/63nzXFpXOYnPYmvPGa5Li1UBwqlcqxpEOKK0fGGvujWqmeh1IkT7C/GPkPDCnCXIsNb
	 GdJKa1iKWo9DUGVJFclzIAKkudwFuTnhVQD+zL8NzgZIOUs5jshyyQZmPp3bnF3jkvY31
	 JE9m7s/ZYtVWD6JApy8CsnfVKbIfeL5ACa1lQOjPyY0dXp84r+l0vRnwfpPBI7zGYCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794839240;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=c/NQHRNe6l6YOGUDkv9ZNGcgPj475MvlcuYl9auZYJY=;
	b=s03KzSTYFFFpTUHz5giwqnE4mAJsF2Qz8mbCuuFIapSwcWYDXaGXBlbIJ83i5fzLV/dr
	 Q9XhyMIaNWCsfDVRuGPxokRlw2XwtXQWZdGrDC3bHCiXUH3H7yqVoDjilnaT7weakC77b
	 kTQ39q/jzaBRW+H7lV+NH2LeC2bPYebUnGFzXyFVAfDLipgBFqeWBBEnO+Pa48jJw2R+Y
	 f3JvLFrb1Yk6DX7GN1ve/zGwuDokkcQv4cClFdYk3a16XG8fxop0HczwW9/eW3Enu78ev
	 ekYaN5mZqXnRJ0hQb5E4AoamB+wSgORoClprV/Bo4umY5j2e3ElZsgj2id+BNoUh2Pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Gv+TuZdy;
	arc=none smtp.remote-ip=209.85.128.70
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EBF606A337
	for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 14:27:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79EBF606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Gv+TuZdy
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a20e41008cso21826845e9.1
        for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 06:27:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794839239; x=1795444039; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c/NQHRNe6l6YOGUDkv9ZNGcgPj475MvlcuYl9auZYJY=;
        b=Gv+TuZdyi5hcF4Ktwm5shXyAxicp0LqA4t3FB43v8Ez563tT9KW4N3JotCjDHPvyPL
         3Zzjz2u7Ivintan/o+/x50+ppPYNzDSU85ZGw7779PCCdra9p6QeUgfi8dQl5wfIykvI
         kmOq6zuvV/lp9k/HD4Rx0KvdfIhXfFWYNN16qvmduTa2DUyggWJ9V70n29zHQ2/RSV64
         fk27Jw7ASCcAcRBhPq0ErQiLIzoGPPmGrxsrsLOk9pQ+DW2v3WGKVLqofhndNBjoBSJH
         a2ofUdWrzcqiososDbnWj6ZSHbovW/3ld8/rkl5wALDwo6kLXbrNWS80fhVLaCtudhzy
         iC/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794839239; x=1795444039;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c/NQHRNe6l6YOGUDkv9ZNGcgPj475MvlcuYl9auZYJY=;
        b=Ybr4wf97oi0z+YuLOeme/U7+l3LbDmqx60Ou6nPIO6GOWnkOuSw11R/ZJ8pYRFKK8+
         1L8gOlbxbLHuLnqyxMbMx3JNEbaX6Gnys/MKqKea4Y8+ems2m/et6JXriVb9YNdCURmJ
         G/FldSV9ZP0x/YKLJeeo2xOez00LtWKbNyYQUq3Gl5xLY1B4GHKUGpXC0v0IL90iox2v
         FRHNNPfSKn1bw/3r0EvOouCt91ossZqlSJUN5Fajk0L+ixvpFUC9D9DbT1Sm/7w+MpIS
         +61mzSuCYZiACRl69SXp0gd85/to/TjDsp2VrXhn98T0OvVPPEGb//oIA6BKlJ6cjCC/
         086A==
X-Gm-Message-State: APuU4Z+3cjl/JdLXsAOflkw+iUoFnk3v9gpohv1RcLPh3lCkiVggRyjj
	wYzGqMotskIsREQ/gBWFZt5PKeETeCXM3IzXx2x7Qv9i796E15OgPnmCVTypd4TfTVUFf6ROykw
	HCygqYu4LTV/cx9+k9jtL9ZJcSRcVWp2ztrau+pOLw4Td9H/Sl3BMPZADAAPJ8OSBBBEIxaFHxz
	LPpVhvO8WRW4FMfc2YJcCYAILOHdVZMA==
X-Received: from wmbjj17.prod.google.com ([2002:a05:600c:6a11:b0:4a3:5d5b:9ad9])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:6286:b0:49f:e8bf:8f9b
 with SMTP id 5b1f17b1804b1-4bb55a23b4emr228382165e9.4.1794839238088; Mon, 16
 Nov 2026 06:27:18 -0800 (PST)
Date: Mon, 16 Nov 2026 15:26:24 +0100
In-Reply-To: <20261116142618.1687025-17-ardb+git@google.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261116142618.1687025-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1222; i=ardb@kernel.org;
 h=from:subject; bh=gNFwqEvRPin0drZTY8vZ8X80jlSMfocbKk0VdpmbVRA=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIeu30KSg3fcv87JE2Vwx2/OUl40vW2RrsPb6oCrlHnF1u
 dmyb9M6SlkYxLgYZMUUWQRm/3238/REqVrnWbIwc1iZQIYwcHEKwER6PzEyrM+807hgHuvh1S8n
 7DDjYHotYHn95jar+8ULlgkKbOBwnMPIcDTjw5LJIe92RiypnXv/9FrZ3E0/bCS3WkXYaqwq8vY LYwUA
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
Message-ID: <20261116142618.1687025-22-ardb+git@google.com>
Subject: [PATCH v3 05/15] efi/libstub: Avoid _end section marker in library code
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
2.56.0.611.g1030f0b940-goog

