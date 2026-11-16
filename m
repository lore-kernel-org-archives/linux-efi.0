Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794839239;
	b=ZW83klMZiJwGMEHW2dMBlE2Fu9XyrhymDFo/TFotBex9BRscqWKf3f9Zk2e8OypcwmL4
	 RCpVAsHMRWfWj7OImaD5vqAdalc3Cu9mRakabiAX9MdFomxTxaf5xRqKlUCIGT5cwRTVs
	 k2Es3MGNjXsvFjL0+jTjPOS0jQ89nJgkVBHbXmJSCmcWdAERvl2jk7OHfP5m+55kFfcDC
	 zTyGDOj7hbNRQhmsr61Vv6SLbPZ7wAXvT9fHTAsA6P8YllI/PQJMoURNEHQR/lb4AoX1b
	 gSpNpSlTin4FIYoxTPx7OzJcac/4H5FUNxIxiu9cl9hBr5R8BLswna6sh4NzoilGBhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794839239;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=5R2g9UB0W7Cq1TglUi5KIOs/VyvT4iQcIBDMlZHHNJ4=;
	b=BjI6UMMoxJtj/pQ1RB2xfZUurPIc4KUE92nCgpwHiQgGuxbmR3ArheYfPqcT7ToQhwzt
	 JESxgLH/4gxHMawqD3n8uZCfLTWkVEcIduUSeVVEhy/2JXGzyWQJjE57VfA1z2Lgba67w
	 0lxHVJME6e90dGMF4LYt6DV5gZDmAxFTLzV4pRwgwk7xnvm7vJkSluNBh0hVfVH3zXNzS
	 QMBF0JB2GjgQmABGsO8Lux+F+lXVrV94jfvfXvajHB3z+HSieSICQw5DHjgo30R+sdVzq
	 O6UmheN7q0pIe1kj6NZ/aOfIj2BelxqTac7Q8/KdgDv3xHD971TZqQh6wTgbGyznEHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Aw1kPzc6;
	arc=none smtp.remote-ip=209.85.221.71
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E79F606A330
	for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 14:27:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E79F606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Aw1kPzc6
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-48e1d839ddaso2209597f8f.3
        for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 06:27:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794839238; x=1795444038; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5R2g9UB0W7Cq1TglUi5KIOs/VyvT4iQcIBDMlZHHNJ4=;
        b=Aw1kPzc6P76xO71TVsH17eEyC8uvRJ64z6q0NBZSDrtT79jum/eV0rb9jD391FAlK7
         chA5j4ORLpt1m9AcdgdSUOhnrvr2hzqFddy4UxT5IobTt9ECpSNghbhQMwwMrPvUGOvX
         mF+iLxlafn0LP4gJ3XMnx81cGNazVRcgnSZ6TvarznCWU0O/h6c+KcH7nec3NTboUa8d
         Qs6dqMfNKQI0nDSpeZiEJy7ingOrnnQu64JQwn3xZ48rQVEEvyAJq64+ooUIkGbcGzQi
         Ud7HeNHa+4uHB0qM9EUfySpQ5KtyY8rrXNb8Iq1qzJY384CotkqhSW5Zg5/trQu9srqa
         JTCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794839238; x=1795444038;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5R2g9UB0W7Cq1TglUi5KIOs/VyvT4iQcIBDMlZHHNJ4=;
        b=ADvjh9QlUuPIoRR8Q7kJ4F0fkrHHNwfGDjH8z5Yr/sTvkwi+QZliZin9gndr0NuvuW
         fwlZvwrKxanZHhfnLft1MupaZVxEnykVf+aSq6Udcz4N501QYEbNXNV+s3DQdrnVqjmM
         vOyIkIf65Dk1Oflt6G5pEIKDANLJQu8c4yHtf/+jL3Z1MkFMgMOZqasS9O1l02ZzYvpL
         MBr+evBIvxL1e0P21GfO3jFdjM79CTCOfflw9J5Fxx46RYk8ACZ3HX6DbFDWEEL51Ij1
         IvGyyqXOXL9LHzZbOcY3LEg/yM0DXacUT+hP0vz4uFJMmZF7JzrM/x/pnx7ceCRTOQT5
         xxZg==
X-Gm-Message-State: APuU4Z8LppHjIJ5U+q5LOLdViIG8ZJgmCs5dXrnb/A7eBlEGyYYyrRWw
	BzMk9CPH2gdkM9SY4KNUCAkpI9yj9ZAlavIvyebq05wj1KCigrLOzONMuT4L2/asNOzlwD67bTi
	7aJs3zWXqmMvpE2LIiqyppBHXLEN0pgySOdN5d7aw6rzm67CRrc8ajJZ0eTE2lubWOAAvfckvlh
	G9PZGuaBaf3PLUuwT7ZWY//QOJJ4tBDw==
X-Received: from wrok6.prod.google.com ([2002:adf:f286:0:b0:493:d441:be7f])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:584b:0:b0:490:71a7:6f51
 with SMTP id ffacd0b85a97d-49c72ba6509mr22449676f8f.45.1794839236764; Mon, 16
 Nov 2026 06:27:16 -0800 (PST)
Date: Mon, 16 Nov 2026 15:26:23 +0100
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2981; i=ardb@kernel.org;
 h=from:subject; bh=8ndYJWrl5/5wY4uh6dzMJ+7YlbAJMHVUNmS0W0hi37A=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIeu30MSrTJ27pkw5q/E2uejHnms/n2+SWLfg1plna36U6
 s4Uyfxi1FHKwiDGxSArpsgiMPvvu52nJ0rVOs+ShZnDygQyhIGLUwAmsquFkeGL/Zr2F/FRRtFF
 3L9sW+7N3qJ1/c1Dg9yKmY+eR046/1uJkeHT1Pev7Cpzzr93SnY6G7djx68ll3oyj09f9z0v/fi 9U8cYAA==
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
Message-ID: <20261116142618.1687025-21-ardb+git@google.com>
Subject: [PATCH v3 04/15] efi/riscv: Rename __init_text_end to __inittext_end
 like other archs
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ardb@kernel.org>, 
	Jason Gunthorpe <jgg@nvidia.com>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Align RISC-V with arm64, LoongArch and x86, and drop the underscore
between 'init' and 'text' in the section markers. This allows the value
to be captured by generic EFI stub code that can be shared between all
those architectures.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/riscv/include/asm/sections.h         | 2 +-
 arch/riscv/kernel/image-vars.h            | 2 +-
 arch/riscv/kernel/vmlinux.lds.S           | 4 ++--
 drivers/firmware/efi/libstub/riscv-stub.c | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/include/asm/sections.h b/arch/riscv/include/asm/sections.h
index a393d5035c54..4a882a28f414 100644
--- a/arch/riscv/include/asm/sections.h
+++ b/arch/riscv/include/asm/sections.h
@@ -11,7 +11,7 @@
 extern char _start[];
 extern char _start_kernel[];
 extern char __init_data_begin[], __init_data_end[];
-extern char __init_text_begin[], __init_text_end[];
+extern char __inittext_begin[], __inittext_end[];
 extern char __alt_start[], __alt_end[];
 extern char __exittext_begin[], __exittext_end[];
 
diff --git a/arch/riscv/kernel/image-vars.h b/arch/riscv/kernel/image-vars.h
index 7b44b94f1283..bf703eba3fa5 100644
--- a/arch/riscv/kernel/image-vars.h
+++ b/arch/riscv/kernel/image-vars.h
@@ -27,7 +27,7 @@ __efistub__start		= _start;
 __efistub__start_kernel		= _start_kernel;
 __efistub__end			= _end;
 __efistub__edata		= _edata;
-__efistub___init_text_end	= __init_text_end;
+__efistub___inittext_end	= __inittext_end;
 #if defined(CONFIG_EFI_EARLYCON) || defined(CONFIG_SYSFB)
 __efistub_sysfb_primary_display	= sysfb_primary_display;
 #endif
diff --git a/arch/riscv/kernel/vmlinux.lds.S b/arch/riscv/kernel/vmlinux.lds.S
index 9849a3e4d102..ba939c7365b2 100644
--- a/arch/riscv/kernel/vmlinux.lds.S
+++ b/arch/riscv/kernel/vmlinux.lds.S
@@ -46,7 +46,7 @@ SECTIONS
 
 	. = ALIGN(SECTION_ALIGN);
 	__init_begin = .;
-	__init_text_begin = .;
+	__inittext_begin = .;
 	.init.text : AT(ADDR(.init.text) - LOAD_OFFSET) ALIGN(SECTION_ALIGN) { \
 		_sinittext = .;						\
 		INIT_TEXT						\
@@ -72,7 +72,7 @@ SECTIONS
 	}
 	__exittext_end = .;
 
-	__init_text_end = .;
+	__inittext_end = .;
 	. = ALIGN(SECTION_ALIGN);
 #ifdef CONFIG_EFI
 	. = ALIGN(PECOFF_SECTION_ALIGNMENT);
diff --git a/drivers/firmware/efi/libstub/riscv-stub.c b/drivers/firmware/efi/libstub/riscv-stub.c
index 725b634c5179..5cbc50a814e1 100644
--- a/drivers/firmware/efi/libstub/riscv-stub.c
+++ b/drivers/firmware/efi/libstub/riscv-stub.c
@@ -34,7 +34,7 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 	efi_status_t status;
 
 	kernel_size = _edata - _start;
-	kernel_codesize = __init_text_end - _start;
+	kernel_codesize = __inittext_end - _start;
 	kernel_memsize = kernel_size + (_end - _edata);
 	*image_addr = (unsigned long)_start;
 	*reserve_size = kernel_memsize;
-- 
2.56.0.611.g1030f0b940-goog

