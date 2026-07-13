Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF8441C2F1;
	Mon, 13 Jul 2026 13:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783948027; cv=none; b=Y/4plWuMNJ5ut/A21CHTT3LlGMeRLchGB38Vaw+KRwNPDAiO0fPouk352WRBo1YMhI21J+CfijZ2yEToWRYN9K0JI4nBWJKnFInLJup4gpu2cQOCtij8yKrskxJurD303IIY2uTQcnypSFV2nYlBNUx8o+0hSE3a/PT5ckIfPgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783948027; c=relaxed/simple;
	bh=gZbnO7MzerKWMFc9cRUVSqmME+GWUc5YF2pZAyuoIRc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=TO0WU7RYnfPsN1Gwcxcb7lmrQJIJTDdvd+u7dgQ36ioXOaB5yWQj/l/vPZ+hWfpxNQvzJhczx+Sodb0Uz9TugB9hAfRRwoRvmbnmQbYfc1xEYqC2Jh3x81sMk8o7NXLlDMgzuVWwjDeuroFaqoVKUJEoW+NEtJAdwwrpg10izLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=Fezl5PI3; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="Fezl5PI3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=gLrWpjMTf6gk2f8xe6C5lIQ5phzJvbeI/kdBCN1AD4Y=; b=Fezl5PI3trtW9vcw3VxI6/s4VV
	X3G06UHAoDn4vCT8zEgjwIzN0kQ8Q7h7twisEIVFKdAgSahfyDh5oe/AIRrZrI5kHxRirkOu6bedY
	ylvzifggcpMXqpv1AW7FNNA7bz0vuwV4SEUxk0oereTN46lgDkx1M5gkan7ZSAM2BNnauiq9I8AFu
	K+D9+qddGRh/fbia6y3Y8BJ73NLojVXJHzGXogF2Fr5Y0tMMM7GyATrAXtkIm5SC71DkTgkuq+CDD
	cPyM6PzqjejIiehBcAT04d96Oi7dKdvWfRW7twW3L8c1IJTvrwaqm3Z+Ynw24AG62pZOwVpAx/6mJ
	sDtYtpww==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wjGNC-001WJW-0T;
	Mon, 13 Jul 2026 13:07:02 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 13 Jul 2026 06:06:48 -0700
Subject: [PATCH 2/2] efi/runtime-wrappers: mark efi_runtime_lock_owner as
 __used
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260713-efi_fixes-v1-2-cdde378d9df9@debian.org>
References: <20260713-efi_fixes-v1-0-cdde378d9df9@debian.org>
In-Reply-To: <20260713-efi_fixes-v1-0-cdde378d9df9@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Josh Poimboeuf <jpoimboe@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com, 
 kernel test robot <lkp@intel.com>
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=1561; i=leitao@debian.org;
 h=from:subject:message-id; bh=gZbnO7MzerKWMFc9cRUVSqmME+GWUc5YF2pZAyuoIRc=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqVOLquS7bLYsnaMTh/vMNC+nOAiubt1hkqoegK
 TsUg3JWmduJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCalTi6gAKCRA1o5Of/Hh3
 bVgVEACVZKKDD5n054zH1dNUWvLlfOWjoUz6f9pJUXGet0u7jOGiCNiAym5eG2TvF4g2xZgWZJF
 x/SkD3ol0/rsOocjUXgA/zcZ9RPIo4psYzQriqa1TJ8bZl4Zb1XAvcYclknEHeC3qK6Ip6vHlsJ
 SUQGS6U6hvtDcTd1PD37mrKyaQdpjXZ6FkRTppJtXfFCILk9GkDNyl9gU/LT4Azj3VXKa6umBMA
 J1SdcWqCPkWaaZA1BhJHoTYFM1GH1ZApiEm9pn7kyKQaVmp06lVK8r2NRmyeswzy0FjkOXOkcCx
 W3BCLp5pGDiUKH2HktYMlF9VdeQjpdfb8DnBA5OTJf6NAjyZsuhLBS2bnSiLfPQcAL6hpksHMhJ
 52hPr1mAq5C17xIaJIpbulQVAkPFLcT3FZsb1frbM4h+fwNbvS9zf87oigP3yHAC5FW0oA7Kw/V
 xy+T8Ya+gbI7LlvwUziIUdAiHQ8uQRXH/ET8+fEsdRn4XgZH5E7DdSUe/FemcW2AD8qpduTng++
 pC5GvPmG/b9+5RyURSMoiP7h1JQvj849GnK2UBvPRLuFpG72PDNc4a96WPNlix4g3zpAEjldYW0
 CHixMs5MUtwEcX8DDl6+m24gCXMlMFZOSWYFfCyG5nK+kGU/ZQSufJ22X6dPm2Q6O1f8h/ncR8s
 Jp3c2MRilI/WDVQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

efi_runtime_lock_owner is only ever read by efi_runtime_assert_lock_held().
When CONFIG_BUG=n, WARN_ON() collapses to a statement that discards its
condition, so the compiler drops that read, treats the variable as
write-only and eliminates it. Debug info still references the symbol, so a
build carrying it (e.g. CONFIG_DEBUG_INFO_SPLIT) fails to link:

  ld: drivers/firmware/efi/runtime-wrappers.o:(.debug_addr+0x104): undefined reference to `efi_runtime_lock_owner'

Mark the variable __used so its storage is always emitted. This seems to
be better than alternatives (READ_ONCE/__maybe_unused).

Fixes: a2860501203c ("efi/runtime-wrappers: Keep track of the efi_runtime_lock owner")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202607100518.uMJJPDfP-lkp@intel.com/
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/firmware/efi/runtime-wrappers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index 6f42da11a9178..2344b9d1e81f8 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -210,7 +210,7 @@ void efi_call_virt_check_flags(unsigned long flags, const void *caller)
  */
 static DEFINE_SEMAPHORE(efi_runtime_lock, 1);
 
-static struct task_struct *efi_runtime_lock_owner;
+static struct task_struct *efi_runtime_lock_owner __used;
 
 /*
  * Expose the EFI runtime lock to the UV platform

-- 
2.53.0-Meta

