Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F75831326B;
	Fri, 17 Jul 2026 14:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784297011; cv=none; b=p6mkhZakE5bvxVHsyY3dglThsL/f/4qfmjI6wmDFUrVCUYlVFbpfhrcAUfOz0HMO4z0DSClQXI50nkRCg23AJj/geq5qB3/708859fa6gyDGfDccR4Vfybggy5oqX8JGLx+vGSnyU3spDf9iDf26O2xh6kJuvGdQNLqIcq/2PE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784297011; c=relaxed/simple;
	bh=XSYaytETWUdAdf6C/jUyr/nUG+SgDUBzJpLAb/bKjnk=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=smEbv0lqbdZsjH3BoZro51cSFkcQSlUwQrswwA/nFT8oT0ZA2MHcc19XOqCnKOqdHQLkok1cD+6S1nkFKa/tC5//zWnZWy8iPkFZqgJyh4BmjFJWTIIHk9i+lX2NFv/7wvIUCQVEqIgcvFKkDOjK7uuOX0JK8jHEn/No9d3c6/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=jA2jDJdD; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="jA2jDJdD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=t+JK6YXp0UMipFPe2YB9TujwLOUTMqDZAmncSyxaQVE=; b=jA2jDJdDP5c5Jo5AgHdG3VfDFs
	JoaMhrqz/zugeJQqgtQHsKJuZyGzrfbRTrrWuXwt9BGD6/Nm+E3o+9evOkadB4r/Z+kQUZHDZl9nr
	d6DViDDIJKSQ3lJw+q3EyBWcQxRzMfb/bVvyZMUM1Dv0J6lBmoAJQB2TA3lVSlqdanwygx0U2EXTE
	/OoBoF2UwcdlJLfN9bE2Dlfja0WQBW1ph2J+DeGVYj7D9rlFV+Dvox6VLfLjiVuLk3IG+qHUcXaLD
	i9ZFfwhLwSK1Erqj6dSIaXs3oK6cpdwRx8SPVCJ+l7hclZFBAqsU0u5qDMrH4vWKMWDj9nR3jCoqr
	tPRkwCcA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wkj9s-004eBv-0y;
	Fri, 17 Jul 2026 14:03:20 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH RFC 0/3] efi: mm/memory-failure: keep hardware-poisoned
 pages out of the next kexec
Date: Fri, 17 Jul 2026 07:03:02 -0700
Message-Id: <20260717-hwpoison-kho-v1-0-9c5eda551998@debian.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABY2WmoC/6tWKk4tykwtVrJSqFYqSi3LLM7Mz1OyUjDUUVBKz
 kjMS0/VzUxRslJQMjIwMjMwMzLSzSgvyM8szs/Tzc7I101LtkxJMkpMSbRISlTSUVAqKEpNy6w
 AGxetFOTmrBRbWwsAIf78fmMAAAA=
X-Change-ID: 20260622-hwpoison-kho-fc9db2ada8ba
To: kas@kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, rneu@meta.com, riel@surriel.com, caggio@meta.com, 
 anilagrawal@meta.com, rmikey@meta.com, linux-mm@kvack.org, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=3334; i=leitao@debian.org;
 h=from:subject:message-id; bh=XSYaytETWUdAdf6C/jUyr/nUG+SgDUBzJpLAb/bKjnk=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqWjYj/ZImjUuBxzZ5Tbo8rqgjgA+6KHsOLgMCm
 fhVmBp2eHmJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCalo2IwAKCRA1o5Of/Hh3
 bYa2D/9KnqtaoYgK3CwxF9r5fp/EPaSxnA0CteU+zY96Dx9AMq5/y28TItCWs+yHYR+YfprELfF
 tQzVtWly31TwLgYYOq2keOtVbh1aLShGMXsJQkFXEgcjXuh5wJffeQqmfN710UKbXu4afI8lnyX
 BPTZoNQCJTWKTdFetEmrTnYfHS9IfG3Q0m76rYBtupdoo6zXT87c/UeBhE5SK2ARbjO1WQy8jmB
 bT13Zr+VFwptXT40idq6grx5imSPxAwKfbcDbttE5jH2eaFN0EFJPG+bNf75GPIgqPUbi5+TZwR
 bxmB0WPfVavd6A/8cU4MSdSCDrw4bipNazDI9iku3pSaGcPukXQSbXrU8qehSkf2a9a4HEMLYcG
 sQtHt1xG/4gqq+gQ/zw7mR0M9wBJHZe+2dV6pwnaq6gB27dv2BXlVaMuLe7XC38yxSvQhGG9Mbd
 Yxu40Zyq4rs3mzsMdlhUXQmcRaVpgzO+nbpTPo09XJ6AwtwiwYA7j3/R+cS05GG2alwtpGrC0RH
 gV5KpvMBkzCBvUVKiSAqPfRSKXfMV0oGk86KI8o6A2uDBCHffQPV8WA/dh/lrDtIxwVwZOd9vZH
 UoMKWESkiSzDxhCZc4cab+d0q0slGkFTo+K3x134d8gHbYFncet5PQinMT4P+k5k6eG5b7FC4jb
 Eu1AlYRmThGrc7A==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

Problem:
========

When a page is hard-offlined due to an uncorrectable memory error (multi
bit ECC), memory_failure() sets PG_hwpoison, unmaps it, removes it from
the buddy allocator. This information is not carried to the next kernel
that is kexeced. The new kernel kexecs and trip over that bad memory
bank _again_.

Why now:
========

Several industry trends make this increasingly important:

    1) DRAM is getting more expensive
    2) soldered / on-package memory (LPDDR, HBM) is becoming more common, so a
       failing part can no longer simply be swapped;
    3) memory is kept in service far longer (at Meta, DRAM lifetime is being
       drastically extended).
    4) It is more and more common to kexec instead of full reboot
    5) Increase of memory per system with CXL

Proposed Solution:
==================

Carry the poisoned frames to the next kernel in a new EFI configuration
table, LINUX_EFI_POISONED_MEMORY, modeled on the existing
LINUX_EFI_MEMRESERVE table.

EFI configuration tables already survive kexec: firmware hands the EFI
system table to every kernel in the chain, so a table installed once is
seen by all successors without a new handover channel.

The mechanism is architecture independent, so x86 and arm64 use the same
code.

The EFI stub installs an empty table while EFI boot service is up. A
configuration table can only be created there; the running kernel can only
append to it.

Each hard-offlined frame is appended; an unpoison "removes" its entry
so a frame that is good again is not carried forward.

The next kernel walks the inherited table early in
efi_config_parse_tables(), before memblock and the buddy allocator are
up, and memblock_reserve()s every recorded frame. The bad RAM is never
handed out.

The series is three patches:

    1) add the LINUX_EFI_POISONED_MEMORY table and install it from the stub
    2) record poisoned frames into the table from the memory_failure() path
    3) reserve the inherited frames before the allocator comes up

This was initially discussed at
https://lore.kernel.org/all/ajut_LDQGYCShApx@gmail.com/

A special thanks to Kiryl Shutsemau, for feedbacks and suggestions.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
Breno Leitao (3):
      efi: add the LINUX_EFI_POISONED_MEMORY configuration table
      efi: record hardware-poisoned frames into the poisoned-memory table
      efi: reserve inherited poisoned frames before the allocator comes up

 drivers/firmware/efi/Kconfig                   |  10 ++
 drivers/firmware/efi/Makefile                  |   1 +
 drivers/firmware/efi/efi.c                     |   5 +
 drivers/firmware/efi/libstub/efi-stub-helper.c |  30 +++++
 drivers/firmware/efi/libstub/efi-stub.c        |   1 +
 drivers/firmware/efi/libstub/efistub.h         |   6 +
 drivers/firmware/efi/libstub/x86-stub.c        |   2 +
 drivers/firmware/efi/poison.c                  | 180 +++++++++++++++++++++++++
 include/linux/efi.h                            |  31 +++++
 mm/memory-failure.c                            |   6 +-
 10 files changed, 271 insertions(+), 1 deletion(-)
---
base-commit: b8809969e1d7a591e0f49dd464a5d04b3cf02ab1
change-id: 20260622-hwpoison-kho-fc9db2ada8ba

Best regards,
--  
Breno Leitao <leitao@debian.org>

