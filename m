Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794839233;
	b=N+bmGTdleTzFELdRE6YSqZawthrbQUFsHgeLYCmDL9Z+0KQIBNfRmxcLSs4n9gUT3h/U
	 t+6PW1/P0H0Ptux5r6YFD2P1wY7vaAZiKqiaNe/FkEzFSxf5evTZlXkuZ8y/kEyhEh+00
	 x293VEqh0tp08FUUjoFv4Ag1CPT1JwMBNXzIg3Ar3TZ4AsC9BT9BGnQAvL1gsT63TWjKf
	 4AHvAOgnUM6a5lB5BAKqawGjo8JX3RbvyIiIlLbMIAjJO+NNC4oAOjQy6TyKKxY//Gng8
	 YcFTYrbLB88nmHYOImAvCaEuYaSaz3cpNMYBg2CEU2Ov1b0AoOb9OkwWYT7rq08XgLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794839233;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Developer-Key:
	 X-Developer-Signature:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=NqHB2bqFPRhr2sa2L1nGYaDpYxg62blVD/y+oKNndDs=;
	b=X7eF6yMfdidosRjt71Z1h5rycd3OnmK5/6XnweZKZW4Pbh7z5Z0JYV2Nl304sEOwAhqW
	 wTpa/r+qFZUq6nvrcjmgPvT+fEyJTkjQQxZyeuFUDxX1pVCSHqFaazwdJR9IIx7WyzoOY
	 /vQWBuqJvdbOmrexEbzUT1dObPfUlwPGPo8M6B9MZ5hf8SERtXcOXUZ5QHD3+E3QCe+iw
	 1mTvjGEa7leJhiKcjDW0gHwz7c3imx2EdD0H8xrSEsTgt2ntrBss+N22c+3nSlGVAxff0
	 eKfLGFgcpg+J1nk84V2bnOyuwzTrsSgVl9kEwijxFhqEawqg3hnKvSI9DhztKvs11/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="fI27o+/y";
	arc=none smtp.remote-ip=209.85.221.71
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2B9606A329
	for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 14:27:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C2B9606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=fI27o+/y
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4931c89d228so1939942f8f.2
        for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 06:27:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794839232; x=1795444032; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NqHB2bqFPRhr2sa2L1nGYaDpYxg62blVD/y+oKNndDs=;
        b=fI27o+/y8OTriQIJ8qfZtqjIC4txLAb7Ladspp1x0MFUNbnQpu3aNPQroWX6859aYJ
         pVhyj3amLXh3A3g6UrZbOZF8VLLJLHWTBOLM/Oii/0DNl8+AMxYgS7DgFgxSWHzX/iQT
         Fut60QAxSRaktw1ZOBbtwoYgIxyMKqdsqEjrauG8fMf7EF4AiEaKsY/Sb/pR5hh3slSE
         EL+yUrdsX8NrjLGyNbLU9/vjBpgO2WTAIjIaSbmd1ZZObyJSsA6GJt7Iai/6kSzD9NuD
         oGtkmbuqC2SoGy8HrDZQ40FG1hRF6rXoqJRSwoGXnhaDi019FACRFHcNmkfHLkeRXuf9
         yLHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794839232; x=1795444032;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NqHB2bqFPRhr2sa2L1nGYaDpYxg62blVD/y+oKNndDs=;
        b=A1QOJkeq2/g9o34Gh41zeeguO/HAlzYw5EH6V+ANA7r0/oMKqqw4GSIFg7dixWIZw5
         16Szp2tnYS3lzVZqC9p4LlYl0KJdsCgQXMWyq6x0ToCHmsduH6Rh/CM3WV1n0dvZNmhb
         s0I4yS1vSra0hKVJPweSPk7sn5QknaiG46+PkE/16iuO86xFTK/rYPwNMWIoKNUReuWZ
         OYWaUGa0uLgj1TZRoCxGy3zfdJ1wIOGh4u8o8ziJtxMqTylAiUCe1WItNisz9dxDWjE0
         j5a98sXZL3Ugc5Tuxiu9nVWeRbJjPTC/Um7ClN+R9UwipRTtwINgesWhZ6k2YESyp1NL
         E0Kg==
X-Gm-Message-State: APuU4Z+MMHAmqaoki2+yz5DbYvCI1dPyTfWy8WvzKVnbdutF8qONk6bf
	gY6MDUrRxrYSrKTU5NTGHkWxJ0f03OkfYXRuoIybFXBprwzvgmoad8Dbty6La/xa4xooZyflF/0
	920CAmSUpEn9AELakpYVKulpLm+Sp1md5dqnGAYOxNM6GZfNt9b+yPaWziN+Fm0nhD0CHpRzqm0
	ECxiHL9QegkPlUnS5S7Bt/4jdvi+oRgw==
X-Received: from wrrz7.prod.google.com ([2002:a5d:44c7:0:b0:499:de0a:f0c0])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:4697:b0:492:c53e:2ea8
 with SMTP id ffacd0b85a97d-49c7458620emr17115499f8f.49.1794839231620; Mon, 16
 Nov 2026 06:27:11 -0800 (PST)
Date: Mon, 16 Nov 2026 15:26:19 +0100
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5815; i=ardb@kernel.org;
 h=from:subject; bh=4h21oJbzpY+BN/Rm4SjBto+DpUA56NZXutkaqN//M8I=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIeu3UHfE+Yl3K9tdjnM7qv3X3/Y3o8bm9OVjhrkhc8I7l
 z+Wuva5o5SFQYyLQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAEwk6wQjw8U9/tcXhZy979/0
 Y5/C4daVgblvWiN1bOU0jmzvTFYKiWRkeP3llMaKY5OuXJFo/3ekoKP96aaJnfa3U+tz5Sz25P7 awwcA
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
Message-ID: <20261116142618.1687025-17-ardb+git@google.com>
Subject: [PATCH v3 00/15] efi: Expose loaded image properties via info struct
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ardb@kernel.org>, 
	Jason Gunthorpe <jgg@nvidia.com>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Clean up the arm64 build script and linker hacks that zboot uses to
obtain properties of the loaded image (which it cannot access directly
via a relative reference like the ordinary EFI stub).

Instead, define a generic struct efi_image_info, and expose its offset
in the loaded image in a similar manner, but without relying on explicit
linker script exports.

Populate the struct with section markers that all architecture use for
loading the kernel image at boot, so that all the linker exports can be
dropped for them.

Changes since v2:
- Add some additional fixes for RISC-V, which deviates from other
  architectures wrt its section markers. These patches have been sent
  out separately as well [0] as they will likely be taken through the
  RISC-V tree.
- Pass an efi_image_pointer to efi_stub_common() that points to the
  version inside the loaded image, so that its relative references
  accurately describe vmlinux in memory before boot.
- Avoid weak linkage hacks to derive the kernel entrypoint, and instead,
  always use the entrypoint passed via efi_image_info
- Use efi_image_info for sysfb_display_info so that efifb earlycon works
  much earlier on zboot
- Drop changes related to the previous bullet that are now no longer
  needed
- Add acks from Jason

Changes since v1:
- drop arm64 image header changes
- move efi_image_info out of __efistub_ scope so it can access vmlinux
  symbols directly
- implement in a generic manner for all architectures that support zboot
- address Sashiko comments

[0] https://lore.kernel.org/all/20261111164345.4059964-5-ardb+git@google.com/

Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: loongarch@lists.linux.dev
Cc: linux-riscv@lists.infradead.org
Link: https://lore.kernel.org/all/0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com/


Ard Biesheuvel (15):
  efi/zboot: arm64: Add missing barrier after cache maintenance
  riscv: Use _stext not _text to denote the start of kernel code
  riscv: Make _text point to the start of the kernel image
  efi/riscv: Rename __init_text_end to __inittext_end like other archs
  efi/libstub: Avoid _end section marker in library code
  efi/libstub: Capture loaded image information in struct efi_image_info
  efi/libstub: Pass kernel entrypoint down to efi_enter_kernel()
  efi/libstub: arm64: Use struct efi_image_info to access image
    properties
  efi/libstub: loongarch: Use struct efi_image_info to access image
    properties
  efi/libstub: riscv: Use struct efi_image_info to access image
    properties
  efi/libstub: Make efi_remap_image() return efi_status_t
  efi/zboot: Disentangle efi_remap_image() from efi_cache_sync_image()
  efi/libstub: arm64: Drop zboot code_size hack
  efi: Make config table based primary display handover ARM-only again
  Revert "efi: earlycon: Reprobe after parsing config tables"

 arch/arm/boot/compressed/head.S                      |  2 +-
 arch/arm/kernel/efi.c                                | 27 ++++++++
 arch/arm64/boot/Makefile                             |  3 -
 arch/arm64/kernel/efi-header.S                       |  2 +
 arch/arm64/kernel/image-vars.h                       | 14 ----
 arch/loongarch/kernel/efi.c                          | 20 +-----
 arch/loongarch/kernel/head.S                         |  1 +
 arch/loongarch/kernel/image-vars.h                   |  4 --
 arch/riscv/include/asm/sections.h                    |  2 +-
 arch/riscv/kernel/head.S                             |  1 +
 arch/riscv/kernel/image-vars.h                       |  8 ---
 arch/riscv/kernel/setup.c                            |  2 +-
 arch/riscv/kernel/vmlinux.lds.S                      |  6 +-
 drivers/firmware/efi/earlycon.c                      | 16 +----
 drivers/firmware/efi/efi-init.c                      | 24 ++-----
 drivers/firmware/efi/efi.c                           |  5 --
 drivers/firmware/efi/libstub/Makefile                |  3 +-
 drivers/firmware/efi/libstub/Makefile.zboot          | 11 ++-
 drivers/firmware/efi/libstub/arm32-stub.c            | 48 ++++++++++++-
 drivers/firmware/efi/libstub/arm64-stub.c            | 44 ++++++------
 drivers/firmware/efi/libstub/arm64.c                 | 23 ++-----
 drivers/firmware/efi/libstub/efi-stub-entry.c        | 27 ++------
 drivers/firmware/efi/libstub/efi-stub-helper.c       | 15 +++--
 drivers/firmware/efi/libstub/efi-stub.c              | 26 +++++--
 drivers/firmware/efi/libstub/efistub.h               | 71 +++++++++++++++++---
 drivers/firmware/efi/libstub/fdt.c                   |  5 +-
 drivers/firmware/efi/libstub/image_info.S            | 19 ++++++
 drivers/firmware/efi/libstub/kaslr.c                 |  2 +-
 drivers/firmware/efi/libstub/loongarch-stub.c        | 12 +---
 drivers/firmware/efi/libstub/loongarch.c             | 10 +--
 drivers/firmware/efi/libstub/primary_display.c       | 56 ---------------
 drivers/firmware/efi/libstub/riscv-stub.c            | 27 +++-----
 drivers/firmware/efi/libstub/riscv.c                 | 16 +----
 drivers/firmware/efi/libstub/zboot-decompress-gzip.c |  2 -
 drivers/firmware/efi/libstub/zboot-decompress-zstd.c |  2 -
 drivers/firmware/efi/libstub/zboot.c                 | 28 ++++++--
 drivers/firmware/efi/libstub/zboot.lds               |  6 +-
 include/linux/efi.h                                  |  1 -
 38 files changed, 289 insertions(+), 302 deletions(-)
 create mode 100644 drivers/firmware/efi/libstub/image_info.S
 delete mode 100644 drivers/firmware/efi/libstub/primary_display.c


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.56.0.611.g1030f0b940-goog

