Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026105;
	b=t7YENa0hONQ9zaES0oDd/gROsMLET4qqSAyp66N98j5NWb3f6+a9O833PsHKn09dy7zz
	 dHwCDBPKBwGkMd7tI0jcOnr9BomXMgUQDnc8Dbc78KUBbO0hqf+wCEtRpINn3+VHCksq5
	 ly9iyUV6gNt38XQQA972K77xZQ50pQdKZWTLLLxaig3i1/NemJ2rsdhgMK1r1b+OySa/p
	 dgHLWX9U4IUAHNSRaX06AI4HZz4/3KNQlbafeR2vhwca3JqkkHb3/2sz4N3buaaVfD0X3
	 yt+QnPgDABD2lLDVg1uyot+ZqTjub9KZfdZzA/YQQGnfEOYHc0j1ycyEt5vVaAVTTUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026105;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Developer-Key:
	 X-Developer-Signature:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=ltwMOlHQb7KXQHw1z5VBs+MReZmVIy0Qa1qSs/vHRAk=;
	b=Xrq0MSwcfcA0wbkQbDHmlaxh0YX3nrRinfdFW8sZ8544oEe56pYQMC25rTJ2IdDaxDB+
	 KPsicEqlYsv2yHaxdSKR7w8h3WfZYEkS6ZxYwDP1JDzFm2+9n1xVxqNrdV3DsxTiapok2
	 51IGNa/Hm7VD6OoRbgIIce9hajyWSzMJCSlzAl3+37FqYQKFyqSP8Zey1oXmMUJuqZsvT
	 7TmHZrwcgL98KDRaKJyeEcg/YzNNRk1GhIJpIyp2Rnr2EMO31ghQlxRn7ICEhnDHp3OFF
	 6kg4tQlYey3jWhelC/KG7jxJIhkqe0sPQnOsCI6eCKrSj9zyssaWwoqzm5yxiAsYoQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Dm0a7Sgf;
	arc=none smtp.remote-ip=209.85.128.72
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C861E606A320
	for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 18:21:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C861E606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Dm0a7Sgf
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4bb6bac1e84so9896975e9.0
        for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 10:21:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795026103; x=1795630903; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ltwMOlHQb7KXQHw1z5VBs+MReZmVIy0Qa1qSs/vHRAk=;
        b=Dm0a7SgfjpNt9Ym8ORCApkVK467Bjg3KHwvOTpHAC586Y8ylWsEEJrKbXdZUJzfdl7
         RQlfigTJBNkDp7WOSwxdqN4dN/5/80acHzIPT2t8jdENLDOB3ZeFYyBD5ZQxpYp/4SyC
         739IS/EzY/ShL7nsP6tKskT58DsVkBXqtX6dY64H8Fi5fzSwHgbiO5HdtLTyAIf5fWXS
         IWqnP8EaMyipv0bTqYM8p04LYKwv8pAF3YeWVoN29Jpn0UR9K/BNYRNWpWT4lJt2zMgj
         vzGy/ZE2Fhdy+/MewLx300PtASkI5irXeI2l7lfvO5l8LJxDmUY37/K3TWA4FESZc8qy
         t0Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795026103; x=1795630903;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ltwMOlHQb7KXQHw1z5VBs+MReZmVIy0Qa1qSs/vHRAk=;
        b=M92K/Qgw8V2SGBsi2OlmnotNTbmJIncdPLssP5YNP9/gPEd3YHFr+FiO4g/r4J3YvH
         zf9ocJ+P9yhiLu8hoROHOw0vl4ztks2K9twYnWb1JfBb2fyAjkHMRPn19tlAbnZ/5004
         FCiT+nTzhpTn2dsidh7GLzOvhwI/heLoZp5CT1hdh4lu2tZ/dfMGNxVIY7Tvq7in10iB
         A+E3XohJNx/0+KJHeJVyxk6jSxg921JGLkOiuKslpETJnXdhVQqdwIJGbDQKWXu9+PTm
         DnQqDizTMQkttdg9uOl/zpl2gQLmk7OK+FpJ13MZNCnHK8qfO0YIJzHtV7S1Jd5Q0Awr
         KqOQ==
X-Gm-Message-State: APuU4Z+1fiU8dtOugcoSlPcR+eUUunae8yKXcvrk7zS8FEruR5FyrgtH
	Znz19Rd4t1bnzG5v2vdWFe2xxg5JG51OC8fXcmm+8//AvWsg593WCzVcgjMbRJey1nUgNVaIzU2
	AUYfFbtLctIW8EiEl5BunfRY3AM67Gt5D3tQma6kMp4P3UtBObT4vfnpRyPYyu8VG11AMdOHU6D
	HW7jqP6H+gYvCv9N7Jov0+3OKui0UcZA==
X-Received: from wrws4.prod.google.com ([2002:a5d:69c4:0:b0:48e:a88:307b])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:b99:b0:4ba:6d8:dfad
 with SMTP id 5b1f17b1804b1-4bb7da1aa22mr67684765e9.14.1795026102835; Wed, 18
 Nov 2026 10:21:42 -0800 (PST)
Date: Wed, 18 Nov 2026 19:21:06 +0100
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6816; i=ardb@kernel.org;
 h=from:subject; bh=ROU61ckYiXxQPdXaEdC2Y85DXEPZDxapPOtwOwcXvJE=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIevvm0n3E/PsF5oJSmaZ7zQ7bb12mbfH3ITECuZlP6fs8
 rqX7G/SUcrCIMbFICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACayt53hf3pgxFmdszM57y/e
 kn9woU3P23jXKe295fNV4zvfrnqxpIzhf36HyiuW8xZpxfw58kdKSiYo7tr7RvHDjatuUjax75Z U8gIA
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261118182105.1633603-21-ardb+git@google.com>
Subject: [PATCH v4 00/19] efi: Expose loaded image properties via info struct
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

Changes since v3:
- Populate efi_image_info for ARM correctly
- Fix a pre-existing issue in the ARM allocation logic
- Simplify the prototype of handle_kernel_image()
- Pass image_info pointer down to efi_kaslr_relocate_kernel() and
  simplify the callers
- Align RISC-V's __inittext_end correctly so it can be remapped.
- Add some more acks from Jason

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

Ard Biesheuvel (19):
  efi/zboot: arm64: Add missing barrier after cache maintenance
  riscv: Use _stext not _text to denote the start of kernel code
  riscv: Make _text point to the start of the kernel image
  efi/riscv: Rename __init_text_end to __inittext_end like other archs
  efi/libstub: Avoid _end section marker in library code
  efi/libstub: arm: Size the decompressed kernel allocation precisely
  efi/libstub: Avoid reserve_addr/_size in efi_kaslr_relocate_kernel()
  efi/libstub: Capture loaded image information in struct efi_image_info
  efi/libstub: Pass kernel entrypoint down to efi_enter_kernel()
  efi/libstub: arm: Simplify handle_kernel_image()
  efi/libstub: Drop reserve_addr/_size params from handle_kernel_image()
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

 arch/arm/boot/compressed/head.S                      |  3 +-
 arch/arm/include/asm/efi.h                           | 15 +---
 arch/arm/kernel/efi.c                                | 27 ++++++
 arch/arm64/boot/Makefile                             |  3 -
 arch/arm64/include/asm/efi.h                         |  2 -
 arch/arm64/kernel/efi-header.S                       |  2 +
 arch/arm64/kernel/image-vars.h                       | 14 ---
 arch/loongarch/kernel/efi.c                          | 20 +----
 arch/loongarch/kernel/head.S                         |  4 +-
 arch/loongarch/kernel/image-vars.h                   |  6 --
 arch/loongarch/kernel/vmlinux.lds.S                  |  1 -
 arch/riscv/include/asm/efi.h                         |  2 -
 arch/riscv/include/asm/sections.h                    |  2 +-
 arch/riscv/kernel/head.S                             |  1 +
 arch/riscv/kernel/image-vars.h                       |  8 --
 arch/riscv/kernel/setup.c                            |  2 +-
 arch/riscv/kernel/vmlinux.lds.S                      |  6 +-
 drivers/firmware/efi/earlycon.c                      | 16 +---
 drivers/firmware/efi/efi-init.c                      | 24 +-----
 drivers/firmware/efi/efi.c                           |  5 --
 drivers/firmware/efi/libstub/Makefile                |  3 +-
 drivers/firmware/efi/libstub/Makefile.zboot          | 11 ++-
 drivers/firmware/efi/libstub/arm32-stub.c            | 90 +++++++++++++++-----
 drivers/firmware/efi/libstub/arm64-stub.c            | 37 ++------
 drivers/firmware/efi/libstub/arm64.c                 | 23 +----
 drivers/firmware/efi/libstub/efi-stub-entry.c        | 33 +------
 drivers/firmware/efi/libstub/efi-stub-helper.c       | 15 ++--
 drivers/firmware/efi/libstub/efi-stub.c              | 26 ++++--
 drivers/firmware/efi/libstub/efistub.h               | 84 +++++++++++++-----
 drivers/firmware/efi/libstub/fdt.c                   |  5 +-
 drivers/firmware/efi/libstub/image_info.S            | 19 +++++
 drivers/firmware/efi/libstub/kaslr.c                 | 45 +++++-----
 drivers/firmware/efi/libstub/loongarch-stub.c        | 21 ++---
 drivers/firmware/efi/libstub/loongarch-stub.h        |  4 -
 drivers/firmware/efi/libstub/loongarch.c             | 11 +--
 drivers/firmware/efi/libstub/primary_display.c       | 56 ------------
 drivers/firmware/efi/libstub/riscv-stub.c            | 29 +------
 drivers/firmware/efi/libstub/riscv.c                 | 16 +---
 drivers/firmware/efi/libstub/zboot-decompress-gzip.c |  2 -
 drivers/firmware/efi/libstub/zboot-decompress-zstd.c |  2 -
 drivers/firmware/efi/libstub/zboot.c                 | 28 +++++-
 drivers/firmware/efi/libstub/zboot.lds               |  6 +-
 include/linux/efi.h                                  |  1 -
 43 files changed, 324 insertions(+), 406 deletions(-)
 create mode 100644 drivers/firmware/efi/libstub/image_info.S
 delete mode 100644 drivers/firmware/efi/libstub/loongarch-stub.h
 delete mode 100644 drivers/firmware/efi/libstub/primary_display.c


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.56.1.708.g77570a6a1d-goog

