Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53225476DF
	for <linux-efi@vger.kernel.org>; Wed,  9 Sep 2026 11:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788954958; cv=none; b=AukblKi/KlzSugU8W6NwMUyMweWRE2bSU+Tj76cRXcPn750yA217PM7sGFlstw+k6BqrVMNBKCYyIKzNG4zVrpT614rPibOV6z69/LCy1DVuXuSfM+u6h1TGxK7BkbiYTGrzvvUa/g4BaCXd/JTXP4OZCwRt2EH//BDDw7/Q3KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788954958; c=relaxed/simple;
	bh=+s6urL61TI3QuNQQQm3SsKlhTUTTfyRdv4trL2AMgH8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=bFyAe3URDPql3JKMxifEhaKo5qaY1olEMX8hxCPeERUCV1K9EHiKw1cIDv7fae3ZZH011LaBnMrROHI9BK0xQAYTIKsXq86FVuLbRY9j2bzhysZCcDFOYR2LCixYN1h8KmEeKK0QvtBWaV09FSxOz5fGHYdnJGxKRNMcf+NzShQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C7M1Krbo; arc=none smtp.client-ip=209.85.128.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C7M1Krbo"
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-490a767b782so46034575e9.2
        for <linux-efi@vger.kernel.org>; Wed, 09 Sep 2026 04:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788954955; x=1789559755; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dsT4MeBzNzxyKb8kQsFfPkCd78D7/G9jUBv70WOR9oo=;
        b=C7M1Krbor1pRqx6bvcfkNT7ZtAM4pwAfJy+yMDaoqelH5/Way8/xj+uhH3LWZxU8oV
         H/T9I61ukqvzR+/ZkbaG/C3yxM2cw/R8b89SdAmjv5877i8B+mEdpfWTknr9DzVjG5Ba
         0Nsa/5fTw8ATXbhUfzPmRkbVzfZqHBdpIEJZ3meRR8ViX1zNTsYdAK33fBIjuZ7Wh3GW
         5Ouhfi8womRB/ABTyol8bGnTyYTVDpevjVkg2rkg50/M/vD8oDYGaR5shZLXeJWL5q5V
         4Dkqd0m1Dv4fsSlxsAGZsr4ShhjaQMktwRmiXIGemdgAzRReZaK5kJjGKvkXkwIXuAiM
         yKZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788954955; x=1789559755;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dsT4MeBzNzxyKb8kQsFfPkCd78D7/G9jUBv70WOR9oo=;
        b=seh9Vw2UdtC2YMtc0RDlPym8aqYSY0byi49yjFCaGX19qquLTqF9gGz+UjFe7roGpU
         QmSU1lubVjEAbVV6h14ZCh8AuIW1RhQXEGQ6P6kDPfPz0dX/Q+UHMX2b2bdX0EByh3nf
         g4nuj2Q0omxBFpfzSy8bi+UINz9wADxXb7Mb4AKwyTKerPc4IrHYJQpnp6nJwIj6tDVH
         mr/fYDRVrIURmOhy5StRn6VmUDb+NmPxvGmA883ecTBr1FJQV15KqZREc9PHyzvRmkiw
         +uvT4gvkmW0d4DMKy6JQ2Nk+6pg4iIt/C/+SI4g+xEWgi/6SyIDLEVeP+r77SSMY+43E
         h/HA==
X-Gm-Message-State: AFuF++lHtFi4j+FNw9T8xpkDW2BWvLdrzYYrDFm3TscuG0Qu/iXCxCYm
	8Z6nVR384etslPc2nFrftL1HRaG0swVs/i7HVLJAXpKNLZIJKWujuWzzt0eJTkEtWvLNdMF5/lZ
	2xB3eqt9QkLDylo6/q0YtP62uLUBOGjcPS8FRV9FwaVZ1XlomfqoqbaSDfpwVkqrLniQOmNDkw5
	mSfCow7rZdK4tkVq9chQpM/1DrrUWwmA==
X-Received: from wmpo40.prod.google.com ([2002:a05:600c:33a8:b0:49b:9117:59e6])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:548d:b0:49d:15b9:2a2a
 with SMTP id 5b1f17b1804b1-49d15b92b2bmr138733315e9.10.1788954954931; Wed, 09
 Sep 2026 04:55:54 -0700 (PDT)
Date: Wed,  9 Sep 2026 13:55:31 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2969; i=ardb@kernel.org;
 h=from:subject; bh=95TEXlWKF0+ARGLoRCunFRPLtfVwZQVfFlqKtvTcQnw=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIWuhpzEv95ENe069uSD96m/H5zkxUxbFMt44oZ27/rxW1
 YcnG9P9O0pZGMS4GGTFFFkEZv99t/P0RKla51myMHNYmUCGMHBxCsBEPpQx/NNb8fZeac997YPG
 1UfXKaeITQmYLpJsFNfXGLD37/GQixIM/8P2ngycPXFR6fEJZWb3lKQmPetg3vzrj6RiRH3EwdM CTIwA
X-Mailer: git-send-email 2.55.0.1003.g10538fe699-goog
Message-ID: <20260909115530.1924665-12-ardb+git@google.com>
Subject: [PATCH v2 00/10] efi/libstub: Avoid UTF-16 conversion busywork
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	Vincent Mailhol <mailhol@kernel.org>, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The EFI libstub performs some redundant conversions between UTF-16 and
UTF-8 and back again, which includes dealing with surrogate pairs, which
UEFI implementations themselves simply ignore.

So drop all the homegrown code, and use the existing UCS-2 (== UTF-16
without surrogate pairs) library code where conversion to UTF-8 is
actually needed (the kernel command line).

The remaining handling involves the EFI console, which supports wide
characters natively, so just use those directly.

Changes since v1 [0]:
- drop size limit from ucs2_strscpy() instead of just the WARN()
- suppress modinfo sections from ucs2_string when __DISABLE_EXPORTS is
  defined
- allow the input limit and max output size to be passed separately to
  ucs2_to_utf8()
- reimplement efi_convert_cmdline() to optimize the common case, and
  only process the input character by character if its size exceeds
  COMMAND_LINE_SIZE
- use memcpy() to avoid strscpy() semantics in handling of %ls
- incorporate Vincent's patch (which inspired this work) for
  completeness
	
Cc: Vincent Mailhol <mailhol@kernel.org>
Cc: x86@kernel.org

[0] https://lore.kernel.org/all/20260906130817.1151961-9-ardb@kernel.org

Ard Biesheuvel (9):
  x86/boot: Drop pointless re-implementation of panic()
  lib/ucs2_string: Drop arbitrary input size limit and associated WARN()
  lib/ucs2_string: Suppress modinfo when __DISABLE_EXPORTS is set
  lib/ucs2_string: Split out ucs2_as_utf8_l() taking a separate limit
  efi/libstub: Use ucs2_string library for UTF-16 to UTF-8 conversion
  efi/libstub: Avoid efi_puts() for compile time constant strings
  efi/libstub: Output UTF-16 directly from vsnprintf()
  efi/libstub: Add support for printing human readable GUIDs
  efi/libstub: Add efi_snprintf() to construct wide strings

Vincent Mailhol (1):
  efi/libstub: add initial Boot Loader Interface support

 arch/x86/boot/compressed/error.c               |  19 ---
 arch/x86/boot/compressed/error.h               |   1 -
 arch/x86/boot/compressed/mem.c                 |   2 +-
 drivers/firmware/efi/libstub/Makefile          |   3 +-
 drivers/firmware/efi/libstub/bli.c             |  87 ++++++++++++
 drivers/firmware/efi/libstub/efi-stub-helper.c | 100 +++++--------
 drivers/firmware/efi/libstub/efi-stub.c        |   1 +
 drivers/firmware/efi/libstub/efistub.h         |   8 +-
 drivers/firmware/efi/libstub/gop.c             |   6 +-
 drivers/firmware/efi/libstub/printk.c          |  95 ++-----------
 drivers/firmware/efi/libstub/vsprintf.c        | 150 +++++++-------------
 drivers/firmware/efi/libstub/x86-stub.c        |   1 +
 include/linux/efi.h                            |  22 +++
 include/linux/ucs2_string.h                    |  11 +-
 lib/ucs2_string.c                              |  10 +-
 15 files changed, 241 insertions(+), 275 deletions(-)
 create mode 100644 drivers/firmware/efi/libstub/bli.c

-- 
2.55.0.1003.g10538fe699-goog

