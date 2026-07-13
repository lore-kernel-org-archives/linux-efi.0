Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDB1417349;
	Mon, 13 Jul 2026 13:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783948021; cv=none; b=mtWd206OxejLN7n1stCM+RwSLvopC+C2QJQ7uUUm8h/GcVqCmvUts/E4ow+lt7u1pkxs4Zmcd5TlCyWj6L9/jraHV73PHUQHoBsR81e63TmJkF5sQG31QPAX8DME294Xr+Pass+kNzxfYqTw0VoJS2k/3bhfTg72XcT+H2NkeKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783948021; c=relaxed/simple;
	bh=SSRipWPCa54nO8beeB8Db+Inb046PwandVWQDaLz5G0=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=tLPwEDjd4z7oVZ+mEQ7f1V/1Py3ZRuNGizg71Cr/za336duse/TCxr6msXpcSKh5lnHl5K/E6v8eIPSLwOp6BGXdjxIjHU0KL20PxCRaE7KbaQ09O9Ug0zdbHCNFLPOqXK6N3Y8OK2xVLMiZkd9yvzoOY4Q+/BVXf5vQ3fhIaS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=fJm3Ge5e; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="fJm3Ge5e"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=ZVh5ylIlsTroaTjjX0OCl2m9pZVSZZw4tk08Xc7ZgTc=; b=fJm3Ge5exW+viFPsA4EaYllbg1
	o0Vxoc7qIXsmIx9LiM4+i+qwhw+3x+J7WQ8OZT2UCfS5YCbaAYMRdFaUw7eC0OeD3ph+OU8YhWYtU
	7MHiAABBpF2jc1rjTEo47YewsFi72MLirvN9MD4+hW4hqIa0pdKxQ8w8s+vGhkFwGOQibITT3Wu2m
	yJtvZHXzzT1wmAYqNSA7T9AYdA7OXevccm2T6bwtrFKtjeO6ZimdhvvHyiVVGIEKBCQiPLHuAFNd/
	bnlO/FJGhC6bxPUkKSWowqvvYRdnJz7u6rlANZNVPo7og9mdN6izaJXw9AeuoXS+xmncuBtF47zJi
	/DPNN1LQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wjGN4-001WJH-0z;
	Mon, 13 Jul 2026 13:06:54 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH 0/2] efi/runtime-wrappers: fix linker warnings
Date: Mon, 13 Jul 2026 06:06:46 -0700
Message-Id: <20260713-efi_fixes-v1-0-cdde378d9df9@debian.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAObiVGoC/yXMQQqDMBBG4asM/9qAMdDQXEWkNMmknS5UMrUI4
 t1Fu3x88DYoV2FFoA2Vf6IyjQhkG0J6P8cXG8kIhK7tbq23znCRR5GV1URv7y5n52MqaAhz5Qs
 QqB/+rUv8cPqeA+z7AXJIeoZtAAAA
X-Change-ID: 20260713-efi_fixes-b7193dd37bcf
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Josh Poimboeuf <jpoimboe@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com, 
 kernel test robot <lkp@intel.com>
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=1194; i=leitao@debian.org;
 h=from:subject:message-id; bh=SSRipWPCa54nO8beeB8Db+Inb046PwandVWQDaLz5G0=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqVOLq5YK0fa82lLHor+8Nqy4GYdkTQC1PhXKcx
 tFo1YwRYzSJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCalTi6gAKCRA1o5Of/Hh3
 bZjVD/0WX0ihGtXOndx3o46l3ybZsM9feCAEDwqX+rmyK2b1xed9MFGAkOktnBebnlirf/QY3gk
 tvinxgvV5KcOBAC3nXlPULFho/S6Blg+eCAw/RJ1+NygwQyXjuKRgGLMCL2WsxP5qC2QRoks6or
 r0nABvSAIkct0joXczVATBPa09MtzKLqo4R6CCA24ShZVsFLGK4jMT/MxSf1giXISnClXV0UG0v
 TXOkb0ESCrxpPlXOzLhJfm3URN1WMq/b8FfkUcPchBaEhPRNBLglEBXhQCwKTijHvrnPY5etFG1
 EqKjR8p6JVfp9zZKh+RgS8NkjjT5NXrU8eVZsDtJihRXp44zj1TnNNMUz8ZmnGFTP5Rdkk+0ozc
 a00mUBFZXUHFzSbb41pycTg7tIoqOST8hmDgmAPoPvp5vTqfMR1yyWx9cIK0Woz5nd4W2XGeTId
 pPD6gOXdX5da4o0TYVpwsU9pjHvJWeRHdcWE4rHi9RZfBCV7XKVO1f3Mhvfj2Xp1ZunB6Q3DGku
 Jh8iT+DX1Q2RAKNdtH+DAd/3JCWSpHNajGGvvvUbQH3L5N6HccVCbQ+6mAx1RTbOJS4Z+E3OfWY
 LTqk8dWyUzJ2QOgAufYdeBF+rIBKZdSAHoBm1CLyjDwom1MLM7XSK0AYpUSvBh/Uzzqmw+a+CDc
 d8YT9wS7PD7grBQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

When I've submitted my last patchset titled "efi/runtime-wrappers: bound
the wait for EFI runtime service calls", I've got two reports

1) efi_rts_park_worker() loops forever and never returns, but wasn't
marked __noreturn, so objtool warns about the unreachable code after
the call.
https://lore.kernel.org/all/202607100848.iWPxdkhX-lkp@intel.com/

2) efi_runtime_lock_owner is optimised away under CONFIG_BUG=n, leaving a
dangling debug-info reference that breaks the link.
https://lore.kernel.org/all/202607100518.uMJJPDfP-lkp@intel.com/

Patch 1 fixes the objtool warning; patch 2 fixes the link error.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
Breno Leitao (2):
      efi/runtime-wrappers: mark efi_rts_park_worker() as __noreturn
      efi/runtime-wrappers: mark efi_runtime_lock_owner as __used

 drivers/firmware/efi/runtime-wrappers.c | 4 ++--
 include/linux/efi.h                     | 2 +-
 tools/objtool/noreturns.h               | 1 +
 3 files changed, 4 insertions(+), 3 deletions(-)
---
base-commit: cf790fdb851867532b9a0f88588dcce648dbffe9
change-id: 20260713-efi_fixes-b7193dd37bcf

Best regards,
--  
Breno Leitao <leitao@debian.org>

