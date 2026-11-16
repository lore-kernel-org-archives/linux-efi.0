Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794839237;
	b=q0x+U7RAnt/tshC1tZeDA7pU7bVio337DHGlQHOr0nxHr1yfQ3bUmhAdpHSlCEdRW7us
	 JHKXwyglrGNC7bFW5UTxk9qmeuHQOznxFqug1Cf1cJzgr6MuTL/7MDEWkTj/XenCUBCu5
	 VrxJ2OFsTFKVkoMqUDzlSfYLwbSZ/f87JoWqVAQCJelXKTPi15XZXPRAvkr2+B26+WIvL
	 MKXMy24KLOfMeq0QjXBny9oHmCyU/pSL4uHjx5N8f81TFZo/KX+qMw7sK4+r+2cSc3pnX
	 XhHb8KWt1eTXYVdffatdmoOkN4EsAP4wPln7R7KEtQsHy0f6sXtfB/Drlex9ZrOHNjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794839237;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=Pus6Zon9bBsFufoopNpQt/nFtp2HWtzZyOc0mElYIXI=;
	b=yaq17Xl/bVUuTRLgo2hQhu/J/tHDxeW3VdAXWg7X1ul35I7j/mAHhUUrSG6k+DjHA6HT
	 GcG0T3Le11lG5VOaYHIH6fBhWJcQsqYIQ3a2ofFfj7bSsKisG7TfhCdlbETWW0WmbidFU
	 mI7PWUFirg9Sdfz/BevgV9wVrq5k3IWx5JIMljj5Gb2pLSp0PYuTxsBXhEO7Ld0+sy0YB
	 BaBK9haptOruYtP3eFq5tar6OMBmiSJt5kEGYBLUfpb0VnjL9c8Ky9OKwAsj9Sc6lnZdl
	 kuJxZJ4nu8Ws/QjUOfoJkFVvrTU2yJTMisMxo82ejhGMTSU4jVVDfWd6nnlhh1Ma4Xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=oJoz5tPx;
	arc=none smtp.remote-ip=209.85.128.72
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E2C606A32C
	for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 14:27:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 61E2C606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=oJoz5tPx
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4bb680f0ac4so10913045e9.0
        for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 06:27:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794839236; x=1795444036; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Pus6Zon9bBsFufoopNpQt/nFtp2HWtzZyOc0mElYIXI=;
        b=oJoz5tPxqHdOMB25G27o0DL1P7kfSLRNrIRBCt+MKyI1wkxdXOFLNl+Y2lwFhs8siU
         +SN26vtYihCQWfZurlNnz272KyPyznq8co5MYErJ38la/1uktH17EDI+ykc6FL+Rg4yk
         5mSoBTqFIIzjD9lyG+bCCwTZC4nkZrQ51XB7Q7iAq5dSFYyRop09moVvv+RpwbLDcdKt
         XRIeFo2N7c3By2Iutz/Wt55KsCZpqTM1cd97YdF2qYSyKKvvmZuGv9OwJlWlIBUlXU5T
         qhPkMk0Lyf+IbVyRpcAg21gsYv075ZRZDC6LIuDTBZS7dIyIXXDJlJIorCVBIH9GRs/p
         9HdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794839236; x=1795444036;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Pus6Zon9bBsFufoopNpQt/nFtp2HWtzZyOc0mElYIXI=;
        b=1IJWtqpRolkr88v3PDWuR18urfgmAbFDtAnmy6dGHAA9jPwrJxMASinBqYeOrIFJKp
         G83bgzwl9w9uGYTnp57gmJE4bC+4IuY4DimwUexBClUJ/cnYh5Vef58Swsf6Hld1T5pX
         WYOzo9+F0C+mJx5gSLJxP0l+qI6Rxi4Dk+NUqewECuQ3JhHtkmeJraMrDUgcr/hQBvyB
         6a8ma/y4/Ig/cCR6xPNJaR6cloH/mHojJi3j9bbA1Ltvn6ujGGoCkeBxj23PRETUGr2+
         /vRGyA0/EgWnh/QxPW/tj5+gZE5+kokInja7v5m+PryXqFfYxlehNmryKPN9bbRd1eS9
         vHpg==
X-Gm-Message-State: APuU4Z/5mvrPB5XuLIJj2cLTS0vzfF9yPCizhngoMsYy9NtHm+swWOw5
	YyImaIq6/5Sl9CJk1TPq+J6I5xQTPe/2h2VAijRCPo2CjkUZ5u9MnwsWDvNB8zW/E60GpG2CBNZ
	skfwciRmbVc0cWdeEAGp3TuVenMZBT5SE/Xb9DlSu8VAjCRKoQw1ZdPlD+LmVOJJHEpmBN+hcAO
	GE9o5I5x0lBh4fBngMrfCdaiwxky3lEg==
X-Received: from wmbjj17.prod.google.com ([2002:a05:600c:6a11:b0:4a3:5d5b:9ad9])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f81:b0:4a7:a5db:a93e
 with SMTP id 5b1f17b1804b1-4bb5f3f7efdmr165201905e9.4.1794839235418; Mon, 16
 Nov 2026 06:27:15 -0800 (PST)
Date: Mon, 16 Nov 2026 15:26:22 +0100
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1529; i=ardb@kernel.org;
 h=from:subject; bh=A8MzxjCVv4eM6mkH8sNsgPFkx7gf3UVeNfnQwzNCuhw=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIeu3UH+bU9CjRLa86aIH37lv1jSRj5ac/GX6sgW335eei
 XnJtiS4o5SFQYyLQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAExkww9GhpVnbigaHjHPy5/x
 T+3HCq6Lcfahm4w+9y/uK7/85oP80ccMf0Uu3/pS4j2j8IbsHeN/EQ3LQp32pvoesD+jcquOmev MfjYA
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
Message-ID: <20261116142618.1687025-20-ardb+git@google.com>
Subject: [PATCH v3 03/15] riscv: Make _text point to the start of the kernel image
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ardb@kernel.org>, 
	Jason Gunthorpe <jgg@nvidia.com>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

On RISC-V, _text currently refers to the start of the .text output
section, which is placed after the image header (.head.text), and is
therefore equal to _stext. On other architectures such as arm64, _text
refers to the start of the image, and is used as such by generic code,
e.g., to describe the kernel mapping in /proc/kcore and in the ELF
headers of the vmcore, and by the EFI stub.

Now that arch/riscv no longer uses _text to refer to the start of the
kernel code, move it to the start of the image so that it is equal to
_start, and the distinction between _text and _stext is the same as on
other architectures.

This also means that the image header is no longer omitted from the
/proc/kcore and vmcore kernel text mappings. Other users of _text, such
as kallsyms and ftrace, only use it as a reference point to calculate
relative offsets, and are not affected by this change.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/riscv/kernel/vmlinux.lds.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/vmlinux.lds.S b/arch/riscv/kernel/vmlinux.lds.S
index 1f4f8496941a..9849a3e4d102 100644
--- a/arch/riscv/kernel/vmlinux.lds.S
+++ b/arch/riscv/kernel/vmlinux.lds.S
@@ -28,11 +28,11 @@ SECTIONS
 	/* Beginning of code and text segment */
 	. = LOAD_OFFSET;
 	_start = .;
+	_text = .;
 	HEAD_TEXT_SECTION
 	. = ALIGN(PAGE_SIZE);
 
 	.text : {
-		_text = .;
 		_stext = .;
 		TEXT_TEXT
 		SCHED_TEXT
-- 
2.56.0.611.g1030f0b940-goog

