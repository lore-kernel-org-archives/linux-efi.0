Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794313069;
	b=aU1jMfVBkrec+uH1ivOB/G5qsofFH1KNX0BxcdAKhuz/6nT3AjMGnEoR8miBgyccb2GI
	 mgxp1GjrU745Ll7du6BNkCEusuUO3Nm+M6wsk77aaBL3a360/6iziCPjvHstkaQRK6ou7
	 8wVzP6MDQBTC8EFnZ+z8WpU51JgIaKG/eroZsoeBs6SQ/VaTrXhxoTLaFQrm4Yeef+ZKm
	 aLWTfhV5HJXgxzS5BPcpnog1WMRGIEseKhc72MvBZmTsJPhbs7SpOrx29L/ff715EuF7C
	 1N81ljGy2bcNt/p1YUbV8rmn7hkhzvu2jZ5LmZlg7w9U1XLgZfOGbpLjSSRxvPp4Myw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794313069;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=7NfbOn3Kflbxnh3F008n5JJpxbmKMRJyc/lu3FOPZxo=;
	b=Ft6OP1iJRjsOQ7xnSNCxSRTmhE+EOwWz7G+xgQU4Sp6MdWaVprrRJWB1VDLvYZaRtO+y
	 uVmnUtGR7yWG9FH/TQRuZ4KLcPOYiWBiv9pY8yG9FiKNS6h1FXNNAxXnYesFhXkdxfHxg
	 9MbwZ0/IIegurZhD/MQlCiGfc2hQis+Wlm4bRCZdCnG4mCofWrDIRR6t4z/64bOxgu+xV
	 7cBVwEbNoua8p5t1XhauS7BQl6A8GbZAzygNRLiDEkR+yI6EqhU9pNTdBL8cr1XAMTZDN
	 YFg3YpzKdbeyfJw75U3LEVyYEUV0tshqKohll4k1MY4KVVDEr/jhu3jZAnnaCfkpnkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=MNKY15zl;
	arc=none smtp.remote-ip=209.85.128.70
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37872606A32A
	for <linux-efi@vger.kernel.org>; Tue, 10 Nov 2026 12:17:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 37872606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=MNKY15zl
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a17741243eso11417355e9.0
        for <linux-efi@vger.kernel.org>; Tue, 10 Nov 2026 04:17:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794313068; x=1794917868; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7NfbOn3Kflbxnh3F008n5JJpxbmKMRJyc/lu3FOPZxo=;
        b=MNKY15zl3ICMsu+JD7TQvIjiH5dtz6R1/7D4mJNCIuN3hOXfD9Ddgo80aARQgKyJb1
         aBUPVPqV0KWaZwROVfJTYCByTU8+k9SHCHglU4xOkLywBiAulVbpds7mkLj43KA/wegN
         T9jFvvUnKsCYckV+DKykMffSOn6tvopmX/U5ogTiDqTwiA5Mkvj9/wbyZHI2UEWlJ9aq
         w7n/ieBo/z8ulH+9QAT9bV854mBHxxkGSXbxxKNCZaqMiemhnHBm5eI1sz7xtz4KiqeP
         ZRXwjm7XaTvn5nxd3EP8EW6fOKMAC4z08ai42gZ2/hRvx8osD+q454vAN7TJcYRaOTBZ
         IEmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794313068; x=1794917868;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7NfbOn3Kflbxnh3F008n5JJpxbmKMRJyc/lu3FOPZxo=;
        b=D3D4ERgYK8Q4HXcRkq3HUgkSVOm+fRVfVChre57YJPLckqhb3RFkdLOC7h2BBNnlT6
         OWJYwMZLkZmrv046TABy8LqeCw8slObr4Cz73mUo+89SfiHbb8xWTCCAq6FCTIslZaP+
         iVE1qXABnsICUJ/Wdg/FBogBIeeWWM8+F9gy+kMa3NOhIIJsb7uXa2pGpPFWmtB/brDX
         +GDvLYTIf86aw1vtocFhWXZgD5RAUxn/0UKF7Ke8+7df1AbwO1mWqKuKpO2IrfsyoboW
         bvSb86EEjEo8/wrDO5opqjuJZPad9OWFafi4rJ8/nfqbZwXQDjGvq89/4rKzGElvpYRd
         5SoA==
X-Gm-Message-State: APuU4Z9VAU6flZ9lSn446WiJqDWmfWacWcfg8YYaTb9xA9a8LyNt4s0s
	0NdOyPR+xBfvEdL54POcPZJD186Bz4O9Pq+6VrjUdUTvMj2Tr7CnJAZqVwSB4tqVbc5qUxxVst3
	+/pK8NngpCymnO3rY5WtPmZ+vXXiCP4E0xVSDgNj+2zq+R15t2UCyzPOi0+GPn8zu8j7tF12IIH
	N2ioxjdsLnFZTu6mtC0GbahrFe16VOlg==
X-Received: from wrnj18.prod.google.com ([2002:adf:ea52:0:b0:48c:4566:c9eb])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:34d3:b0:4a1:e6c5:e44c
 with SMTP id 5b1f17b1804b1-4ba0233e7f5mr39656725e9.10.1794313067235; Tue, 10
 Nov 2026 04:17:47 -0800 (PST)
Date: Tue, 10 Nov 2026 13:17:39 +0100
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
Message-ID: <20261110121731.2728824-19-ardb+git@google.com>
Subject: [PATCH v2 07/10] efi/libstub: riscv: Use struct efi_image_info to
 access image properties
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ardb@kernel.org>, 
	Jason Gunthorpe <jgg@nvidia.com>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Instead of exposing individual symbols to the EFI stub explicitly via
the linker script, use the generic struct efi_image_info, which accesses
the original symbols via PC-relative references from the stub itself.

This improves code reuse across architectures, and makes it easier to
add new references in a generic manner.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/riscv/kernel/image-vars.h            |  5 -----
 drivers/firmware/efi/libstub/riscv-stub.c | 14 +++++++-------
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/riscv/kernel/image-vars.h b/arch/riscv/kernel/image-vars.h
index bf703eba3fa5..27efb990da43 100644
--- a/arch/riscv/kernel/image-vars.h
+++ b/arch/riscv/kernel/image-vars.h
@@ -23,11 +23,6 @@
  * linked at. The routines below are all implemented in assembler in a
  * position independent manner
  */
-__efistub__start		= _start;
-__efistub__start_kernel		= _start_kernel;
-__efistub__end			= _end;
-__efistub__edata		= _edata;
-__efistub___inittext_end	= __inittext_end;
 #if defined(CONFIG_EFI_EARLYCON) || defined(CONFIG_SYSFB)
 __efistub_sysfb_primary_display	= sysfb_primary_display;
 #endif
diff --git a/drivers/firmware/efi/libstub/riscv-stub.c b/drivers/firmware/efi/libstub/riscv-stub.c
index 5cbc50a814e1..e8d66f6fe8e0 100644
--- a/drivers/firmware/efi/libstub/riscv-stub.c
+++ b/drivers/firmware/efi/libstub/riscv-stub.c
@@ -6,7 +6,6 @@
 #include <linux/efi.h>
 
 #include <asm/efi.h>
-#include <asm/sections.h>
 #include <linux/unaligned.h>
 
 #include "efistub.h"
@@ -20,7 +19,7 @@ unsigned long stext_offset(void)
 	 * of the file representation. So instead, we need to jump to the
 	 * actual entrypoint in the .text region of the image.
 	 */
-	return _start_kernel - _start;
+	return efistub_kernel_entry_offset(efistub_get_image_info());
 }
 
 efi_status_t handle_kernel_image(unsigned long *image_addr,
@@ -30,13 +29,14 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 				 efi_loaded_image_t *image,
 				 efi_handle_t image_handle)
 {
-	unsigned long kernel_size, kernel_codesize, kernel_memsize;
+	auto image_info			= efistub_get_image_info();
+	unsigned long kernel_base	= efistub_kernel_base(image_info);
+	unsigned long kernel_size	= efistub_kernel_size(image_info);
+	unsigned long kernel_codesize	= efistub_kernel_codesize(image_info);
+	unsigned long kernel_memsize	= efistub_kernel_memsize(image_info);
 	efi_status_t status;
 
-	kernel_size = _edata - _start;
-	kernel_codesize = __inittext_end - _start;
-	kernel_memsize = kernel_size + (_end - _edata);
-	*image_addr = (unsigned long)_start;
+	*image_addr = kernel_base;
 	*reserve_size = kernel_memsize;
 
 	status = efi_kaslr_relocate_kernel(image_addr,
-- 
2.56.0.542.g3ef89b7020-goog

