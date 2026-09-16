Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D57D2E7BD9
	for <linux-efi@vger.kernel.org>; Wed, 16 Sep 2026 14:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789570050; cv=none; b=d/GwDr0pCxbOYjMy2Z4GNTdYAhq6IVHlwDbZy76jpUtqls4LnE5zFyFJ1/Y1P6OWtRwMBPiTFYTFRX643vU5vIwFMLaQ1Rbpf6gOwfM0uRIXmtTs3sJ+8G3M1yIfE5p7qJjyB84hSLqLiTNp05KQnBdN1e7EO/DR/mjIJERA8s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789570050; c=relaxed/simple;
	bh=qfqJRVx0qRIe/cIj/FEe5qp5EZejFBPmZ7p2+iqBpus=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=r7dB8xy/JJ86vu6kzRA2nBy2e6xEUx6jKlc8FD3VpVSAOLVx+QmbqlQRMB9GsyIVPSeZ9RKjCMT1lyZ2DtdfXHQSgzt9fAAkkk9FJzSB7GqLL5Um4ewp2/2PJJC/mofE02zxERQdreslArM2v9NMgCmsTptV1Bthaze2Ev77+9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NJgpYLMz; arc=none smtp.client-ip=209.85.221.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NJgpYLMz"
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-486f77056cfso3789005f8f.2
        for <linux-efi@vger.kernel.org>; Wed, 16 Sep 2026 07:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789570046; x=1790174846; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2ZOHOvowM8dbCq8/NqSkPXbtI2xme9ytyB46uLhDq60=;
        b=NJgpYLMz/2TnSMa+cIyVT3xJZv7VgoTnkEFrxwyLWBfInCI6rg0pNw114gLnQ05AlS
         WFYb6Hf7fpaNZgCrOhV7Ekf4NC9NCC3vC/upGYAf6o99ZHRmYW+1c+5YoKxavR34B3EB
         K4l/QfgDRleWPlfHJk7YML4ZJgLr/ugJPuFeGmKGS9lMAXBU+8YuQmSr49kx5/fLJ3w0
         37tPOqmkvUAEB/I8VxVa9g2xv5enVEOl/jpN3CGVVY4brfVoD30Nfke3oF6AK3tK6S6g
         pYNYpQC6Mn+pEQAJiOqw6+YbiWulckVvAdDMsToIsMMzob2I72KCuv7FMAHKCdYPl93O
         y9tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789570046; x=1790174846;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2ZOHOvowM8dbCq8/NqSkPXbtI2xme9ytyB46uLhDq60=;
        b=nW+0In6IOdF3RAY5efyrcqdrUzsnng6nVHUhc12YF8viuVYqGNWvrrqxWnUfd4cEow
         gQnWK2cNEGf3yNpOhm9qQu6atVDoXfAtrGKGk2DyVu0ujnqw/kSmIHDBKidp5yOKyueD
         cn6XFUupS1Cl8EIRgBvhgg9zthXIqXkEWVo2iUnT+1oYeFLe6JCLBVOsRAblYf+LaYtL
         7pwFDv9elkGFY/dpaNj0JiPNlnY44bJ7gcLYtZaJOf8yN2sg5lv0fT2GmmWvA/dvH6U6
         2j4ZUw7fBJ/Tdp1GInHfkT1VduG6Y8/1UVSbgxDa1JnIznxjav0vD6KUMwy7nNrADdjR
         hHbw==
X-Gm-Message-State: AFuF++mbz6N9ONq700pzI1Tmd5r7S9P8hzZeiNasMsqeYzx9Tb6kXux2
	WZ6HBjreJP9o3A36LW55scC+1+d9Qw7FGlyJM1+2Gnkur9WHvcvp/dH3r5kRyfCbMTkc0Y/umxS
	+lQhQhemPrsBDEBSDmIfOH4J9JsnMY/CTMghK7085TeDly3dJIffrcXAOSq2LlFkllA0uDf18Ib
	7x5ygtC/V9MJUFmfpt7XiQUN94uvNYkw==
X-Received: from wrbgx24.prod.google.com ([2002:a05:6000:4718:b0:486:ed6c:1749])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:4711:b0:487:fb0:a55
 with SMTP id ffacd0b85a97d-4870fb00cbcmr2667774f8f.24.1789570046021; Wed, 16
 Sep 2026 07:47:26 -0700 (PDT)
Date: Wed, 16 Sep 2026 16:46:48 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3135; i=ardb@kernel.org;
 h=from:subject; bh=NpUActtl36RpBYI8LXKBqA4W1/quvyhnCoUKaScrRj4=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIWvV6hssZsa5Kff5TsT4b65d2H7yTWDo1CyeTbUvNCWeC
 Pl1Pq/rKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABN5bsHIsFx33ctoVm9tht/n
 1E++r7NtOMog6e93WlN3YeJXH1UOX4Z/9u7nnVbf0L+/MkTk4aHD3/YLJynwaPo4Ox9JO+8vnOL HCwA=
X-Mailer: git-send-email 2.55.0.1032.g73a4cd73de-goog
Message-ID: <20260916144647.2651379-11-ardb+git@google.com>
Subject: [PATCH v3 0/9] efi/libstub: Avoid UTF-16 conversion busywork
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	Vincent Mailhol <mailhol@kernel.org>
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

Changes since v2 [1]:
- drop x86 specific patch, it has been split out into a separate series
  [2]
- handle truncated output of ucs2_as_utf8() in the middle of a multibyte
  character correctly
- improve ucs2_as_utf8() documentation
- tweaks to the commit logs

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

[0] https://lore.kernel.org/all/20260906130817.1151961-9-ardb@kernel.org
[1] http://lore.kernel.org/r/20260909115530.1924665-12-ardb+git@google.com
[2] http://lore.kernel.org/r/20260914183745.37538-5-ardb@kernel.org

Ard Biesheuvel (8):
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

 drivers/firmware/efi/libstub/Makefile          |   3 +-
 drivers/firmware/efi/libstub/bli.c             |  87 ++++++++++++
 drivers/firmware/efi/libstub/efi-stub-helper.c |  98 +++++--------
 drivers/firmware/efi/libstub/efi-stub.c        |   1 +
 drivers/firmware/efi/libstub/efistub.h         |   8 +-
 drivers/firmware/efi/libstub/gop.c             |   6 +-
 drivers/firmware/efi/libstub/printk.c          |  95 ++-----------
 drivers/firmware/efi/libstub/vsprintf.c        | 149 +++++++-------------
 drivers/firmware/efi/libstub/x86-stub.c        |   1 +
 include/linux/efi.h                            |  22 +++
 include/linux/ucs2_string.h                    |  11 +-
 lib/ucs2_string.c                              |  19 +--
 12 files changed, 242 insertions(+), 258 deletions(-)
 create mode 100644 drivers/firmware/efi/libstub/bli.c

-- 
2.55.0.1032.g73a4cd73de-goog

