Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C00F433BB8
	for <linux-efi@vger.kernel.org>; Mon,  6 Jul 2026 16:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783355924; cv=none; b=Jg3zAwjfQSp4O1YNb8O8jmLcnGSFmvMGfytulBa5ruYId8YQew4594/4HobFRACtupH987I5Ae82Q6lGvP/YKbcX+HRq5u1zN2JC77DZHTrkdmyZtTssv+GAJUBUXGo2OtcmHBXDjbsIXbbxcwKrnEjB1gvoWIJMmjXzRmfA740=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783355924; c=relaxed/simple;
	bh=LXXrq3WMYH21RRXwHJAbth6NPDMWCz6wLIPT6J2ldC4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S4x0H4qfyq+BvfJZi8R7f6qGItcIQOtMscuv1kQwPoLwEf+RfheBlsEz/y8yqk9A2E4/BeQhJvD3vDyvlc3Y93kZNMbf9xjsOmR2NzUyo8xMvaHkPiVAguriVCkNaWoS9vIF+OwtJGFZK5Atr/3erhSsfAaWiTszu+e8ZQULhBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O9VRxS/1; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O9VRxS/1"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2cca0c5799eso11476985ad.0
        for <linux-efi@vger.kernel.org>; Mon, 06 Jul 2026 09:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783355923; x=1783960723; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=q3YBRTaja8Io8T+OBzHFe+6+gYpexbpRi1HdwVacSuQ=;
        b=O9VRxS/1r2n68dwwwl5HiLbZmhRXu1QgFeMCRXvycDeqR4/D0UMp40vfjuqj8CsS+i
         cs2trHxfoCtLb0D4tTQ99uNwqMTDq750BNFry1d1VMhHEeiJSPYdYRsBXDsH+4ZEVVoe
         iuvcQiP9R4Y+HvhqzsZOjmO6PUmfkq41YebMPn11ipcSujYRS5ChntitjdNP8MisI7wC
         eJDsIpFwAj//Euks/1b0arbQDn+yitFaHhwxqGOHch0RHJvst0Ys6HUYfwV68Q977E8s
         dd5R0gTOaIBU4cgcxEoVpsPCXeQDEUSyS0hZz8yvHWbQTMyK9HLdTehvDML65DCWw1H7
         lXSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783355923; x=1783960723;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q3YBRTaja8Io8T+OBzHFe+6+gYpexbpRi1HdwVacSuQ=;
        b=cNe3MWE4UVZPVfyDA2WgjWk6ajmQAdujvhWaqSnFanzlYvJE6D30vY/X0PLHPOuJ+x
         5rib/GjqUE1WVi4pzlvE8CHFy1CKtw3CJjzzOkK+/6VT8nPOqybT1+lVKBTALbj3cazB
         3EEnO7b5FMJVJRnPcHHplv2QhqLyl3zZBakgRiLj4caH1qk9yQi3h589IM8DsuJeq0dE
         BQQ18Kkk9AXhCJYPdccdgteCzNhXtVHee5F5k3xnorxj32dCn9Y2HCp5pQqkOkYYsLl4
         rf5+Wn5ZkZXqDVe+9fE6jw+mw2mHsXd7g1O6JbIqYRZ6inBmOHapoXSkpX/oAyfbMCfw
         nPtQ==
X-Forwarded-Encrypted: i=1; AHgh+RqOAKbOqFRQannEndOsSP7KZWdcH5sh+tQZ4H1/VO53ij3jPsdA8BLt+eMCcPij5M22kbzhTTU1tYw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzsPVdOOjpS02BZTkHN+PASPtGwuWh5rMX9HViJ54yOPlJ5I7Cq
	6gtmzTAhFCNU1r8Stbb6/68TehWvHaFJv/vkMfXxX290Svkd2KIl3FsK
X-Gm-Gg: AfdE7cmEx2C+BsVRvkTThx1sVBHBhdfk97kvSRNjWDW4Hg7vW2Sr2RlF0xg3gbpnXPd
	lugQTTjJBk4VD3cGzXjet/xUXcnvFNAgx5tJnGRSaIPknN/bzC44qXQQGHIfDTNy6FJH0fUT5lM
	NY9B6J5QeBmz+M9SRA/MYfkehOtAIrOiV4MsaJxLD+eqAFN+LXgK5xEZJWQ4NzNlQYUyM3TkW2d
	NyVFnr0WPk1fZUcnfIXqZe8xCjjSkK4nKcv8X97GI5y1TO/96CAz2Eb722ClnZtfbna9DdqzrLL
	F1BgkJ/j8gIO0KrgxTiszN/3m8cNtW0u5/3Pq2woQqvSwY3f01vivhnh7OnOPvT+NSVPSgOM2e7
	fPR5mQVi7z3mWTRGNIju7fmW7fskzakzHIprzsSsbCSZbPCWKJE+bwKr3Ny5FqStrzogyVeqmpJ
	AWHnPqwWs=
X-Received: by 2002:a17:902:daca:b0:2bf:27b2:4b80 with SMTP id d9443c01a7336-2ccbe729635mr13347365ad.14.1783355922667;
        Mon, 06 Jul 2026 09:38:42 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cad7893a8dsm53103305ad.73.2026.07.06.09.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 09:38:42 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: rppt@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Chris Zankel <chris@zankel.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Rich Felker <dalias@libc.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-sh@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	x86@kernel.org
Subject: [PATCH v2 0/5] treewide: remove unreachable memblock_reserve() return value checks in early boot
Date: Tue,  7 Jul 2026 01:37:48 +0900
Message-ID: <20260706163753.193875-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

memblock_reserve() can only return an error after memblock_allow_resize()
has been called. Before that it either succeeds or panics, never returning
an error.

Before memblock_allow_resize() is called, the return value checks of
memblock_reserve() are unreachable and can be removed.

All the call sites are in different trees, so I split the change into one
patch per arch/subsystem. The patches are independent and can be applied
separately.

---
Changes from v1 [1]
- add reviewed-by tag
- rebased onto latest memblock for-next

[1] https://lore.kernel.org/all/20260616182959.2429774-1-ekffu200098@gmail.com/
---
Hello Mike,

Like the previous memblock cleanup series, could you review and take this patch series to the memblock tree?

Thank you for taking valuable time.

Best Regards,
Sang-Heon Jeon
---

Sang-Heon Jeon (5):
  x86/setup: remove unreachable memblock_reserve() return value check
  sh: remove unreachable memblock_reserve() return value check
  powerpc/fadump: remove unreachable memblock_reserve() return value
    checks
  xtensa: remove unreachable memblock_reserve() return value checks
  Revert "tpm: do not ignore memblock_reserve return value"

 arch/powerpc/kernel/fadump.c   | 14 +++-----------
 arch/sh/kernel/machine_kexec.c |  7 +------
 arch/x86/kernel/setup.c        |  7 ++-----
 arch/xtensa/kernel/setup.c     | 13 +++++++------
 drivers/firmware/efi/tpm.c     |  7 +------
 5 files changed, 14 insertions(+), 34 deletions(-)

-- 
2.43.0

