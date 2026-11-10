Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794313061;
	b=sdOe9Xn3qWlODrWUFMG3AC7CSErTTKFlNV+FolsM/CZ3AB1Q6Rg2I1Ipm73O5ltxaf1f
	 X6n2+H5GOxE6SsQd1esLY/CAnVCyawDoyQdqVBN2wImEXYG9eqKpwHs/TM0PY8KWc6npf
	 RlZEe7msSa1v3D8sBxKiwxeDQVhfjPhTOxftNK/nrJ1jWZw5TQYZmuDLo1cL/inMMBByR
	 l9eC+cKigdef7xp/G3G2IPtNeXfxqfz0tf7Yc6T7L6PGnu6s2N1IncGMia6NKHxuJIrD3
	 ypadSdg0wlZ6qu+fmKZbC/cCaV96DwPkuscNMn7n7MSV2I2CC3kp0G4nZyibV/ySkGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794313061;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=QyX/bokU0mEshftPogmAYinbZSTYIiyRguYJfdW7HHU=;
	b=toA1GZSW+U9/NopMIO1ZhO1pV24AaT3/d6Y8AzQt0kiPjuRtIIc+F/iVebIvCytSAcqS
	 NDeM1Ld7iHeuzHzI6vHZiXoG2dH4CgJfq9317pjje+J7AYjnI9sDPzG3IJtEJh6gyH2hi
	 oZv4bv09VUKCsYR174ZNTZ2FiojziUVne4dlPJpMs8szd8QiaD+jzDungr0TJV5iVcCoz
	 YnXd4sV1Q07j7edR82sqsLxO6F2k26xe94NWJFboMzNznLuzZofgp6dvsL9UNElXbRO7t
	 p5QJe+fmL80uA9PjGThoLa9gkIEhE8S1BrsNJbHZV4xponWdy9GbLsGJW5pe7UWJm0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=JSHSVlfJ;
	arc=none smtp.remote-ip=209.85.221.72
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB68D606A321
	for <linux-efi@vger.kernel.org>; Tue, 10 Nov 2026 12:17:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CB68D606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=JSHSVlfJ
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-490d2ac331bso1699246f8f.0
        for <linux-efi@vger.kernel.org>; Tue, 10 Nov 2026 04:17:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794313059; x=1794917859; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QyX/bokU0mEshftPogmAYinbZSTYIiyRguYJfdW7HHU=;
        b=JSHSVlfJSdHp7SnmHaE/ZkeGSBRJ7k8lTbOCFn9YjaYR/CYPhwGTg7ulWzYSerhNor
         9MhsCEi05woM9PebiwWWbPvjt043giiM9X1+WJ3EzM2rE6YauzAluxAgjiCuIP2zPlCJ
         8VtBrEf2iREuZd/EK8rPoQLL5hR1pfU9FjRrs2v9nCQm8VqFEzXwDOVp7qd5ziARJQSM
         OwTQeM93JSxAogCUOfjqjAJESC/CsUemrYTtlXG7IzjL5fJDD3LmrDyr9cbtlEi0LqUn
         ii81rAQUnYilyJRN8OaH1YhhL/HWGl/F37tZBi0Y1U0AiQRokAs48JM/93dSF+cz3Aev
         kVFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794313059; x=1794917859;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QyX/bokU0mEshftPogmAYinbZSTYIiyRguYJfdW7HHU=;
        b=DDrMPIR2sa9M02uJ8osztKCOAUCbmMjfI12e2GGItuRRdtMlx2k/gtRsGNRaV8DLOg
         qLpugcRRl76YRT6la8mXJxozFQCxnjMpL1Rqmj/blEzND0CcS56x3muz/Fapelk35zkb
         /tQsE/sYc60hYuwKUoGgeYDZ80fFvVunO3g4Uqfo9KPrzmv0Yz9YzQ4CpZlrvDHVYus3
         KUbGHWGXmv++qnrRdkdQIGRfeflVuPF4c6DfG1ZG54FtBPimb+XO1z/Su2MX/kC7Dgf1
         6cPP5gF5fYX4t0IKD+j5QQmLptwMxDn2VujoT9xhAqjSiSBHX/nDmNwmgOVwTETzMY2j
         aapQ==
X-Gm-Message-State: APuU4Z/ir/5Z2CgS5OMzMevJOYrPTHsslkAxJURB1p2tof4m/AZFrLBr
	w2lYzNTqX9mzaalSa5eVbtQHemxdPff+/LUrqN0LaAfv7dyZfjUsQEaqDPOs2rD9AXfOJp7nTop
	z6/K0lHyKCaCjy+azXcwUL3Alp1PwNbp6KS7ixR68JsgknNEhG4mB5ntz6gHynvXl5cXR9wq3bk
	GnZ6ODY3v/eXAW8IPiw+wFTMPUbB9PlQ==
X-Received: from wmcq4.prod.google.com ([2002:a05:600c:c104:b0:4b8:b187:f0cd])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4584:b0:4a2:c2b:a91b
 with SMTP id 5b1f17b1804b1-4ba0233bd35mr40801345e9.10.1794313058867; Tue, 10
 Nov 2026 04:17:38 -0800 (PST)
Date: Tue, 10 Nov 2026 13:17:32 +0100
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261110121731.2728824-12-ardb+git@google.com>
Subject: [PATCH v2 00/10] efi: Expose loaded image properties via info struct
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

Changes since v1:
- drop arm64 image header changes
- move efi_image_info out of __efistub_ scope so it can access vmlinux
  symbols directly
- implement in a generic manner for all architectures that support zboot
- address Sashiko comments

Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: loongarch@lists.linux.dev
Cc: linux-riscv@lists.infradead.org
Link: https://lore.kernel.org/all/0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com/

Ard Biesheuvel (10):
  efi/zboot: arm64: Add missing barrier after cache maintenance
  efi/riscv: Rename __init_text_end to __inittext_end like other archs
  efi/libstub: Avoid _end section marker in library code
  efi/libstub: Capture loaded image information in struct efi_image_info
  efi/libstub: arm64: Use struct efi_image_info to access image
    properties
  efi/libstub: loongarch: Use struct efi_image_info to access image
    properties
  efi/libstub: riscv: Use struct efi_image_info to access image
    properties
  efi/libstub: Make efi_remap_image() return efi_status_t
  efi/zboot: Disentangle efi_remap_image() from efi_cache_sync_image()
  efi/libstub: arm64: Drop zboot code_size hack

 arch/arm64/boot/Makefile                             |  3 --
 arch/arm64/kernel/efi-header.S                       |  2 +
 arch/arm64/kernel/image-vars.h                       | 10 ----
 arch/loongarch/kernel/head.S                         |  1 +
 arch/loongarch/kernel/image-vars.h                   |  1 -
 arch/riscv/include/asm/sections.h                    |  2 +-
 arch/riscv/kernel/head.S                             |  1 +
 arch/riscv/kernel/image-vars.h                       |  5 --
 arch/riscv/kernel/vmlinux.lds.S                      |  4 +-
 drivers/firmware/efi/libstub/Makefile                |  1 +
 drivers/firmware/efi/libstub/Makefile.zboot          | 11 ++++-
 drivers/firmware/efi/libstub/arm32-stub.c            |  3 ++
 drivers/firmware/efi/libstub/arm64-stub.c            | 20 ++++----
 drivers/firmware/efi/libstub/arm64.c                 |  8 ++--
 drivers/firmware/efi/libstub/efi-stub-entry.c        | 10 +++-
 drivers/firmware/efi/libstub/efi-stub-helper.c       | 15 ++++--
 drivers/firmware/efi/libstub/efi-stub.c              |  3 +-
 drivers/firmware/efi/libstub/efistub.h               | 48 ++++++++++++++++++--
 drivers/firmware/efi/libstub/image_info.S            | 12 +++++
 drivers/firmware/efi/libstub/kaslr.c                 |  2 +-
 drivers/firmware/efi/libstub/loongarch-stub.c        |  4 +-
 drivers/firmware/efi/libstub/riscv-stub.c            | 14 +++---
 drivers/firmware/efi/libstub/zboot-decompress-gzip.c |  2 -
 drivers/firmware/efi/libstub/zboot-decompress-zstd.c |  2 -
 drivers/firmware/efi/libstub/zboot.c                 | 29 +++++++++++-
 drivers/firmware/efi/libstub/zboot.lds               |  6 +--
 26 files changed, 150 insertions(+), 69 deletions(-)
 create mode 100644 drivers/firmware/efi/libstub/image_info.S


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.56.0.542.g3ef89b7020-goog

