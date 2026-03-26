Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67062DAFA1
	for <linux-efi@vger.kernel.org>; Thu, 26 Mar 2026 13:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774531639; cv=none; b=UdtKHHx/qY2iUzaTgFmh2dZYuqHZVHpRbPkUb92wjqEUmH/STbFwuIOZhehMlUwLzffMNrfAxAMrH4vwDB9A3DxjkWYKN6PXbkd4BnbFwY69nXql4z8VPHVVYLaR4I8gFfW5nodZtNoFjSJC3jPXR7Q3B2EizTuladBz0p4JC2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774531639; c=relaxed/simple;
	bh=kMilMnVH7WH63mA2tahpjbxjvvgE6D1J4t7g1XbwnbU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=aXmmnfjO0pKniyz5JI4yw878eTMrUqWpaRmOefxXw/my7WrlZmAfSq4sfgNRdNdTgkn+ByX+P93IXgcWqM9SiTAglNbVPivL/u/WU/fKmLD6+QRsorZxAeTaStwexNGnsZmXfnIauTir4PtR7nEAPnKy3GX1V0uizc9Atzveb10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UVhpqN56; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UVhpqN56"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b8fbe7a6f41so63757166b.0
        for <linux-efi@vger.kernel.org>; Thu, 26 Mar 2026 06:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774531636; x=1775136436; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8c+98Lt4N4NkJ/qQq4ErhkjG75Lf1w42r4j1KgSXO/s=;
        b=UVhpqN56NVUuGs+02QY0OLICpFzIpuwjeW8eiqX7ynMp1d2EP8DKWg5jij29H33vBx
         VZ1gNuFJghu1IWE1NpVKqQyZEum78Eclwrk9WhNGzfAt7Ij5wKy74aVbdQYAXT77rSS8
         IcyDHSMjc9nJOcLi0WNMTmHmYlbtKAVK3x2v8pFJUDNmoBvaVTmxOHMnMGLRURiAt3SP
         QljdOYgsOT8YJ2cAThdnbaECbzo8dLBuKD8fa2g1PHIVhuDU6sK0bnYq1QxPuN6W3Tqn
         X/Y+zQTfuaA7gM11tL5VhbDOtmIxmS66nHuNqjrzZeutsBjA9SKeb6/caO29Vdlx2sav
         Ll4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774531636; x=1775136436;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8c+98Lt4N4NkJ/qQq4ErhkjG75Lf1w42r4j1KgSXO/s=;
        b=nAksLDKe4y3Mq8gdBgmstYx1FI+R4GB+JPlpuDvfb9xidgXvwhdBH2Dqg9rfoPBzZD
         9iyGLls9jDabS8/3+vIz5gLFHKUtas8WxpgWp3tqbvHqcuDcv7X2Lj1wYok9OFk5KfP4
         Fh41x1UoXU9Wi8432waebtegxxN0ZZgXw7ZvWHJ0s5sVdrXTnjZZFa587Ud8H2miXs+w
         3BvicSO9WhEQ/cdIkYHvE/ZRwsT2DyuHI/bLBN4rDtlJAmkIEzDLd67wP1EJ6UagQGiE
         wrRNZmkKVGBzlIQL/o91o73zx3VE7XtfxWJsQcvbrQdccrYk441kWdYpOh/pAWRlnAvD
         x1Bw==
X-Gm-Message-State: AOJu0Ywpsw16yWkVC4CQ5jxzpM+WCQRF7ejZ6blX3z/8JfeYZWzIG9Mb
	/bqgCX2jUtKAHRjga5UjT5tObz5B9bvTJO2a6k0LSEbwyWhxy9Q1AF8M9C+l3JxVMHWuDBtWY+R
	9DLafYoQPGVDZioAOcgW/N/izKURUtYXq/wYA0yM62ulde4qPe4mjPpNN67FFM3VYxyTIlBzyBJ
	rofcah2afEuq5GBpc58hpJX/jUnvtCQw==
X-Received: from ejcjs3.prod.google.com ([2002:a17:907:97c3:b0:b97:9df1:ae74])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:d211:b0:b98:cdf:31d1
 with SMTP id a640c23a62f3a-b9a5423dcf8mr530463166b.27.1774531635696; Thu, 26
 Mar 2026 06:27:15 -0700 (PDT)
Date: Thu, 26 Mar 2026 14:26:56 +0100
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1722; i=ardb@kernel.org;
 h=from:subject; bh=AZ6VA0ZTln39ixvGes7THZD0HCK0UmKG6gSdPak2PWQ=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfOoifxeIWPOK9wCrh5iXgqfG3ccuDn3/aecV4c6HwRcE
 V0j+I6vo5SFQYyLQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAEwkr5vhf6ES/+9lfw4cLJLM
 VW1LCGKO/6pcxB4jfDRg86ysg/GKixgZ9kSePOJ/aKrDuYdPnjX8Ejqtvs145/9FlUeKhZZeXCb 1gBsA
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260326132655.1733873-7-ardb+git@google.com>
Subject: [PATCH 0/5] x86/efi: Re-enable memory attributes table for kexec
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Dave Young <dyoung@redhat.com>, Gregory Price <gourry@gourry.net>, 
	Usama Arif <usamaarif642@gmail.com>, Jiri Slaby <jirislaby@kernel.org>, 
	Breno Leitao <leitao@debian.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The EFI memory attributes table augments the EFI memory map, and
provides permission attributes for all runtime code and data regions
that are otherwise mapped read-write-execute in their entirety.

Currently, this table is disregarded when doing kexec boot on x86, for
two reasons:
- the boot services data region that holds the table is not reserved
  correctly, and may contain garbage at kexec time
- a misguided sanity check on the size of the table is likely to trigger
  on kexec, as the EFI memory map has been trimmed down by that time.

Fix both issues, so that the EFI memory attributes table can be taken
into account again at kexec time. Note that this requires that the call
to efi_memattr_init() is moved to a later point for x86.

Cc: Dave Young <dyoung@redhat.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Breno Leitao <leitao@debian.org>

Ard Biesheuvel (5):
  efi/memattr: Fix thinko in table size sanity check
  x86/efi: Gather initial memory reservation and table handling logic
  x86/efi: Defer the call to efi_memattr_init()
  efi: Use efi_mem_reserve() to reserve the memory attribute table
  x86/efi: Drop kexec quirk for the EFI memory attributes table

 arch/x86/include/asm/efi.h     |  5 ++---
 arch/x86/kernel/setup.c        | 11 ++---------
 arch/x86/platform/efi/efi.c    | 15 +++++++++++++++
 arch/x86/platform/efi/quirks.c |  4 ----
 drivers/firmware/efi/efi.c     |  2 +-
 drivers/firmware/efi/memattr.c | 17 ++++++++++-------
 6 files changed, 30 insertions(+), 24 deletions(-)


base-commit: 217c0a5c177a3d4f7c8497950cbf5c36756e8bbb
-- 
2.53.0.1018.g2bb0e51243-goog

