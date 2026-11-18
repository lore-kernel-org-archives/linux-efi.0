Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026133;
	b=E8OSNummIG1Sju5Esd2KcW0GgwBwc4MN+Nz70PDnM5t8LHHZuelxWSkpdxWG0moHjIln
	 lhDY6JGqKy0JCGU6Rugb3yh/CmAk4JfJWPQJExKNklgDCUg1MgTk7q2h5aLhmP3nFi3v/
	 ellv4e1Y/Q2/uMVYZ5IVezaTOG55O2c71HZA9TGAkRq4okWXn7xTQx4tAfTg+Xr/rUoRK
	 56FiESc3l6nVBIIajKqZ6W7qg983d8gGNFiiXKIg/lgxGqP9r7edjdARSHef95YiaSMJ6
	 8VKqaXhLCeHBRHzFxVIZW1W3tZucBsuYuKZEy0/xDu9+Byph5rFX4K2smxPcJ542NAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026133;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=ufXRKDkvqGZ7V1E+zy+j379v8X/+jc3iv3T/Ea9AhuA=;
	b=cSUls8TNmrXh5etAJvxfs8jh8rHO3LVkQti30x1IYFmsM1DPVXn0D7qGN2evHHPBm4+p
	 arvX8zOFbv3UCBkbc+skgGdDHqvxyEnmlponWlinpBRUgSDgHMtoa/2PKOvHHqzZkeBcK
	 R7OwpAN2y42gWP3NlUkkDbmHNM8t99BHfhUnyVr28uIygl/k27foOJ63mk+jgYwUFefuA
	 gMijuJpCzlCvrvQEoQkQ3h5HhOiROPRBTJ2icA310KjBHJ/E9eiIfrOzPp0j8aouNHC6E
	 TcU/vFggunOuNeAOFbjvcL1JziLiAr+i+fYVfxq2R7Dgo0Tvo97rBkKjxFPL+iS13CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=f0QfiDPQ;
	arc=none smtp.remote-ip=209.85.221.72
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6CC606A331
	for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 18:22:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D6CC606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=f0QfiDPQ
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-499ca65ae87so37110f8f.1
        for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 10:22:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795026132; x=1795630932; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ufXRKDkvqGZ7V1E+zy+j379v8X/+jc3iv3T/Ea9AhuA=;
        b=f0QfiDPQ3V3yAy5fKH4KuSh3oU9LCTTc7aV8jlv3fNVW8FaoOSpvQq9aP7vgkfG873
         nj2LEhtAUZFqGxyLJamu1vjIFibDDNJ0CDqVmCnWiiwtpYrURB5L34MLZ4IGdZioiHrK
         cMZQsebT0xIQqgs+UVa93AJCWKuNxgOvSGWclfeBkWO+u/IrRgO5biIMjvXKuaS6OM1I
         QPF2Aqm5yMLPDZQqtiFRWCsiJBkmIOAWSgdh4Hm6CPn5ZY/ziBnAuqrj//9zXeTQRAcd
         jzIwk2FgJ6fjxgTrpq1Wd0fMRuGXj/7LQWXHs2e6tzdVI1M+4u8oHu//PXp22AOLOcDq
         nk/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795026132; x=1795630932;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ufXRKDkvqGZ7V1E+zy+j379v8X/+jc3iv3T/Ea9AhuA=;
        b=DW7r4qT5U+OzsQ4f5SGlIQCjjkvZSuyP8obAHcXEsMhAqZpjOX4mLyP/iuCGSfh7KE
         hGhy6JiI341R8mdm0SRR64T0IA7GoLxpFZ1+Dtbl1Gd0eipncAx5San6n2J5Ti7bhTBY
         ps8yQtnpBGYu0CmgKffWovSgy/as323rhVvj9L4oG/RqpneN996MSkWk3B1fGEorVZe+
         RrEckDtXBdLU+R0t8TY58PYWYj3uP5i7f9MeagvXjW/Amr2DU67DQ9loezQ7INqEp1el
         NM2Lfha7vuVUj4mORxAmhEfox3U/dvUYgsdgO4bY3xfJnWmFMUVWrANlGttg9P3HYtwH
         pokQ==
X-Gm-Message-State: APuU4Z8cMM2lAn79pv4hF/WOstXIuzfjGzmZ1tJrONdA8jTSKD9ci7fO
	qh53WCyUmi04+6Zr9w0+QfPH/2yfiF6w/oHZU9uoQaWWClkcxUAKE428tjrM4RpMfRpqaSR5n+g
	5o6SYGEAFfz52hxh4L2bz/+UULCzeGLT2Jwt/7senWLPqHqjenIRCpNwdstldAF8575ZzbYaP+k
	swdjemP406txSs8UW3/4OEmpUQLh2TLQ==
X-Received: from wrbdh5.prod.google.com ([2002:a05:6000:a85:b0:48a:f5b5:2f71])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:41dd:b0:492:b1c5:6db6
 with SMTP id ffacd0b85a97d-4a8e3f70001mr836395f8f.6.1795026131432; Wed, 18
 Nov 2026 10:22:11 -0800 (PST)
Date: Wed, 18 Nov 2026 19:21:20 +0100
In-Reply-To: <20261118182105.1633603-21-ardb+git@google.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261118182105.1633603-21-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1259; i=ardb@kernel.org;
 h=from:subject; bh=2JP+cT9iihC5uYGXzSyzWCniO925ZMwvqz8a7g9Ari0=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIevvm6WGnSc5J+WcVbnAJc433bqPOze3x3t/lFj+ivTJ9
 1IurmjvKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABOxXMrwz2xaQsuyS1zrH/yb
 dOxUcZ7zBe4/av8WMjnc3BUXcZ6ldALDP4s91ycxG6wzmBcq1hDzZc3ikPLX4te+xBasDvn43ri fgxEA
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261118182105.1633603-35-ardb+git@google.com>
Subject: [PATCH v4 14/19] efi/libstub: riscv: Use struct efi_image_info to
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

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/riscv/kernel/image-vars.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/riscv/kernel/image-vars.h b/arch/riscv/kernel/image-vars.h
index bf703eba3fa5..c18b24792a29 100644
--- a/arch/riscv/kernel/image-vars.h
+++ b/arch/riscv/kernel/image-vars.h
@@ -23,14 +23,6 @@
  * linked at. The routines below are all implemented in assembler in a
  * position independent manner
  */
-__efistub__start		= _start;
-__efistub__start_kernel		= _start_kernel;
-__efistub__end			= _end;
-__efistub__edata		= _edata;
-__efistub___inittext_end	= __inittext_end;
-#if defined(CONFIG_EFI_EARLYCON) || defined(CONFIG_SYSFB)
-__efistub_sysfb_primary_display	= sysfb_primary_display;
-#endif
 
 /*
  * These double-word integer shifts are used by the library code, and
-- 
2.56.1.708.g77570a6a1d-goog

