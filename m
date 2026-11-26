Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795708233;
	b=vxlHJVgu7+gB4y9uu83XPTxeSg5uG7Nt9P9kg/M5xWTQPe0noYG+K/pSm4VBvpYoyXLR
	 H9zwIDn/ebBRxDNH6BQGaoId4uOuCcv1urZq6MRCMhOyDPhpI0z+H9DsPND21x71tcTyI
	 qRGZARnA0cf6IkZy/Zzu0BOz6l8KpP3UpwmL3H9pXHsl0ytJ2DA/ES2KNRmiigng/WDgu
	 UmQuxoWGcdUjTQj7yqRW/M3clLXdzfs2lBBm7gyv+sBK4/6rbGf62TWRt8taHoSJxr4ZI
	 py/4hUqv1KUcXkqTYax6cvucM5qCmF2jAnfPXOzKQvg6j0ZdUQ+BKH21RuJsFN9QeeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795708233;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=z4dyIj8lQ1FXo9z1autS4mIIcUIyGZfOl4YwmKn/wug=;
	b=rOvsNKr7dQHjZSVkt+w9UzpQAaU1O4FI4TigjNYd3ejCMybaJ4Jag2gaoKoJiw5J5sQo
	 Z7J7MVotfgHoUGuMom0Oc38QHc47Ba18AxyaZEVnlMO46YhVq+6s3LOJQKzwVKMaj573/
	 fSTFyMycGrAe14vG0HUwHxbGl5lZPz4z2NCpkwnr6J/nLa+gjNnyfDjVeMnLwc2MTnxLj
	 L2wnjjeXCLbQ9vR5sMvIYdKztNRXk0kSN4wp/mDcfscW3baSlDolsBSgQujxNFlTxo/do
	 fF7BiqXb7jlPIYizhZv0ApRKJXPSjaXGNmP4Su8+balS9yHYnopbm11MBVZsAJRztqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=bpE0DBC0;
	arc=none smtp.remote-ip=209.85.128.71
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F30606A329
	for <linux-efi@vger.kernel.org>; Thu, 26 Nov 2026 15:50:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36F30606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=bpE0DBC0
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4994d67d0e3so44032095e9.2
        for <linux-efi@vger.kernel.org>; Thu, 26 Nov 2026 07:50:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795708231; x=1796313031; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z4dyIj8lQ1FXo9z1autS4mIIcUIyGZfOl4YwmKn/wug=;
        b=bpE0DBC0vJ8K/mzCs1uwgsl32nmVI0UP9heVkMbBqKmlOyHgwEe4NpwInvrb363fY2
         jWV4QH+Zfd7dDwX2e7yszVeMQrQBEYhjmEvd+BpZcgWkI56wbM2buD22zJJxXeXXL8VX
         03DRKKYtBtl1Y47V0S0pr4uS30SFm5AzkkOM+c6AnwpzzEbI49eqO0lh4OstdJ+4fqNC
         x4y3kA10tESD1PV1UNgs014MhWIWz1ti4Py51nwmhhx0JyqPBY76CRTDD1hN2XvCInJ7
         0th1Wl6V23VvStih9A1z7FhYrX9I2WABBVp3FlVbaLs19q0JegQ86Ew4ZdVAnX9TPaB0
         6zxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795708231; x=1796313031;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=z4dyIj8lQ1FXo9z1autS4mIIcUIyGZfOl4YwmKn/wug=;
        b=ODnvUcYCWFQMsBIdq3RUHsEJ1jgb71Pkjjxz6H74eeKA59rL+tvTk0tXxR9S7soPYR
         ttJnXIq1JCflLOUvr6SgIBrg01XRZayru199LgbVLLnbCLdbNiOq0gWXPE0b7KJRJEh7
         fxzpbEaXNhavIGO1XvtIMd4bNxsJ3kp5k407/o5ivarcmxaWJacq21Qm+WMe0snQ/vkK
         DjGH9cmOPgGT8//+P+PAt2lUW6NqRQZUkb6Skkru/UIcCWfJo8nZlTTdOHz3S7Yd/MaT
         GJMpeJPxd/Z/uKWcbeFMhHMBq2GkOUNJywb62B+dRSXg4bML8pIVgHR2Ht3+oCuI0BqA
         puWQ==
X-Gm-Message-State: APuU4Z8d8yVlxK4rreKhbVk/MB+GKJ9rzcdN08D+shgNlDdNR8clEovU
	Vogj7R0z9QHHEjA3Andz4KEQu+JTyjCXnpXTopXBO+F1cjfFQiQAcHoDlM2ts3taUSmt89EZc1Z
	caGPKRoxi1WmqBB+8dLrgLER0G3Xvk9brRL0+XwA/qnwdCz0pXpHV93/T8mX+Bgak9bw79hGe+4
	HdLdfG+iIrVsEQ0ZRe1du8VnKA7it+qg==
X-Received: from wmbh9.prod.google.com ([2002:a05:600c:a109:b0:4ae:2747:b6c5])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3f0a:b0:4a5:75d2:c104
 with SMTP id 5b1f17b1804b1-4bb8880cde7mr417033825e9.22.1795708231180; Thu, 26
 Nov 2026 07:50:31 -0800 (PST)
Date: Thu, 26 Nov 2026 16:50:21 +0100
In-Reply-To: <20261126155017.2401147-5-ardb+git@google.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261126155017.2401147-5-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1662; i=ardb@kernel.org;
 h=from:subject; bh=tUTiqC5KpzNWid0nLDW0ngCatAa0zIED+GzI+E9BPdQ=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIZsj1I5drriv+I8Dp7GR7CMf1zvVEp4Xw+VfNJzc8fDR1
 TCdXWkdpSwMYlwMsmKKLAKz/77beXqiVK3zLFmYOaxMIEMYuDgFYCIMZQz/XXp271E8x8fIF13C
 NbHrtePU1VaucVpdd21/rzFr7elQYWR4FvKxKs3xEt/neXtv+3if/3/xr7f4i+n3MucdY+f0fLK WFQA=
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
Message-ID: <20261126155017.2401147-8-ardb+git@google.com>
Subject: [PATCH 3/3] efi/libstub: Provide library helpers only where needed
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: loongarch@lists.linux.dev, Ard Biesheuvel <ardb@kernel.org>, 
	Dmitry Antipov <dmantipov@yandex.ru>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Now that dead stub code is being eliminated by the linker, the only
remaining user of the 64-bit left shift and clz/ctz helper routines is
ZSTD compression, and only in some cases:

- the 64-bit left shift is only needed on 32-bit architectures
- the clz/ctz helper is needed on all RISC-V and 32-bit reduced
  LoongArch

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/Makefile | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 20b5b77956d1..ba6d67e5cd78 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -98,14 +98,15 @@ CFLAGS_arm32-stub.o		:= -DTEXT_OFFSET=$(TEXT_OFFSET)
 
 zboot-obj-y			:= zboot-decompress-gzip.o
 CFLAGS_zboot-decompress-gzip.o	+= -I$(srctree)/lib/zlib_inflate
-zboot-obj-$(CONFIG_KERNEL_ZSTD)	:= zboot-decompress-zstd.o lib-xxhash.o
+
+zstd-obj-$(CONFIG_32BIT)	:= lib-ashldi3.o
+zstd-obj-$(CONFIG_RISCV)	+= lib-clz_ctz.o
+zstd-obj-$(CONFIG_32BIT_REDUCED) += lib-clz_ctz.o # loongarch
+zboot-obj-$(CONFIG_KERNEL_ZSTD)	:= zboot-decompress-zstd.o lib-xxhash.o \
+				   $(zstd-obj-y)
 CFLAGS_zboot-decompress-zstd.o	+= -I$(srctree)/lib/zstd
 
-zboot-riscv-obj-$(CONFIG_32BIT)	:= lib-ashldi3.o lib-lshrdi3.o
-zboot-obj-$(CONFIG_RISCV)	+= lib-clz_ctz.o $(zboot-riscv-obj-y)
-zboot-obj-$(CONFIG_LOONGARCH)	+= lib-clz_ctz.o
 lib-$(CONFIG_EFI_ZBOOT)		+= zboot.o $(zboot-obj-y)
-
 lib-$(CONFIG_UNACCEPTED_MEMORY) += unaccepted_memory.o bitmap.o find.o
 
 targets				:= $(lib-y)
-- 
2.56.1.839.g22a8290db9-goog

