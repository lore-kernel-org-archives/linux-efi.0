Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF3D3E1213
	for <linux-efi@vger.kernel.org>; Wed,  1 Apr 2026 12:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775046248; cv=none; b=oVqrzGM0/+Narc2AEBxMmQDXmvecH4WMwYkFvIOz8CEQf7nCKUI7r1zYYf2HOwEbIGlhNC4nGw5slphNwiQVNEmJf7fTIz0/zf3qlgzO+HkHlECGe/1MTFZOMn3M32g2cNw3gXw8IA0990eXl1TbTHXebxFxMQvgP0Vd1ltUJm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775046248; c=relaxed/simple;
	bh=WuqgWm4tRRJ/HF1ruEzlW086PxFxDAs+CB8zrINGCMc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=LJB1neKW1o+UbzMrWeEdFumcDDx/u+poxP8cy8S+ODOFGV6uB8VsNvtDHL8ePO/cVNJGFIz4qHk7sm8YYgF+WML6xH+0UjR3TybntTiP+zzp5vRJU6nW0z1kxh3uNbLQNN3mV33UhBz4f0Xk0udLpvfSSuU9LzyL04KGA/xPOEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=khA5pFVH; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="khA5pFVH"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4887f8a8df3so9567205e9.0
        for <linux-efi@vger.kernel.org>; Wed, 01 Apr 2026 05:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775046245; x=1775651045; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uJnlNfF4DL5QOFNkv/8qBSM0QCh2jsjugcRVmCaUg4g=;
        b=khA5pFVHaLArYzlWXu54VFbH8xhc1AWKCGHnDhT3ebbtULsw1qy9fOfq98pOEocwJs
         0Vd40/UHnNHqgr7cI//XWgf48zIemFhnGpl3YNEWqacFvyku8K6R7iHLBPNBRggxizEP
         K6N1kLcunULzqQmHgssRS4jNu8kbPPpt4yh7zGzUaScBQ81n6RY7nt4kRnoKS33K0fMH
         8q/+b1on7oeaqRVleeIIv+85SrBp5QWD0UqQ+X/LHp529vqOi8aEVkQ/qwxLRes3++/k
         RWLAV5KuWOMC88Pmh6Fvz1/RSvUBzAQdrI+XouRO29LqzUELvL8UkEebj9FctJjRsZOr
         mEPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775046245; x=1775651045;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uJnlNfF4DL5QOFNkv/8qBSM0QCh2jsjugcRVmCaUg4g=;
        b=ooZz/F/r/GW0EhrjicilARo3C/gMY3GDd24c3ONU8go1QeGRpbFl6D5B5X0XR/5ogP
         7idDj66cK86vx1dDx5Hlk4tFYXi0xdKlJj4Frxaiy4x5Xf3TXigcyASfxUzy8Qlef35U
         B6QIR/KSsmouudGmVCzyediOS0XtE5Ndfb07yhHpq6IzcVqqqCZNfuQt/JnyDueF+gzB
         rguNPmN1n4Zm2Kigxhfph5/a/c7YDT3RSy9rMmWJEcdfgxtDxEwM57ep2aiOdfH/Dpi9
         A4ILbqryMoo2qL/XbnUjmUCbGu0rY1xhZMuMQROIwe5doLnmN7wkFq5qw9SSynUHnHE5
         hHJQ==
X-Gm-Message-State: AOJu0YzF8dWvf9hhaOqvv8cTB2G8pfcCqRg0iZHWLyMShV32G0uLVqSh
	XDAvWd9Wr9xw/xSLNdMyJDvXv/Y0OsV1TebSipQnuRkrveLmZuhpWRSvC+GTOxAcYuY9ZyVni5C
	GgsuyTWulOEQ48hg19X/GRePPVeok7z5Wq8dshNKWt7vDH9njJdKmZMB0DtgzSLfvGztomXZ2NN
	Lm6uGZugnLUzZwgyTE2JEBOGkW9J0Cgg==
X-Received: from wrwp15.prod.google.com ([2002:a5d:68cf:0:b0:439:f5bc:2087])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1d0f:b0:485:3d3e:167b
 with SMTP id 5b1f17b1804b1-4888355ec9bmr53692675e9.5.1775046244729; Wed, 01
 Apr 2026 05:24:04 -0700 (PDT)
Date: Wed,  1 Apr 2026 14:23:52 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2230; i=ardb@kernel.org;
 h=from:subject; bh=va67uiHDdkHMSmpZ0o0Av6Eknku8i4k9On556G319i8=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfMsX8RUbvm7c+wXG24KfldipKDE3R3V37X4vP6hM9/MN
 ISsl7zvKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABMpzWL4HyL/O//Me6Gvl4zs
 5Ze1/lJ89SVd7O3hO/znNnhULbz/OpKR4ebFWUpa3+uULNbFL7xYLnOjz3zZojsiU789+2YX2x/ lwgAA
X-Mailer: git-send-email 2.53.0.1118.gaef5881109-goog
Message-ID: <20260401122351.2058145-7-ardb+git@google.com>
Subject: [PATCH v2 0/5] x86/efi: Re-enable memory attributes table for kexec
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

Changes since v1:
- Sanity check the descriptor size and entry count individually: this
  prevents integer overflow, and avoid noisy diagnostics when using
  kexec_load(), which reconstructs the EFI memory map using a different
  descriptor size.
- Apply Gregory's Rb to patch #1 (but not patch #1)

I'd like to take this through the EFI tree as a whole, or take the
first patch now (which is a fix) and leave the rest for -tip during the
next cycle. (Patches #3 and #4 should be queued together in any case)

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

 arch/x86/include/asm/efi.h     |  5 +--
 arch/x86/kernel/setup.c        | 11 +-----
 arch/x86/platform/efi/efi.c    | 15 ++++++++
 arch/x86/platform/efi/quirks.c |  4 --
 drivers/firmware/efi/efi.c     |  2 +-
 drivers/firmware/efi/memattr.c | 39 +++++++++++++++-----
 6 files changed, 49 insertions(+), 27 deletions(-)


base-commit: d0c3bcd5b8976159d835a897254048e078f447e6
-- 
2.53.0.1118.gaef5881109-goog

