Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FBD3F485D;
	Wed,  8 Jul 2026 07:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783494962; cv=none; b=DRrHKCJO6U5sBsZp4Jt653nZ/2waO8e32IgJ+gFxYiYfGrkMlKZe1ibAfgKsFbKASeM7wSeH0sfnCNxTH0rM5xHJwZSdNW/suPUYv7vKSO7JQ7N5gS5fr6BEaXNh/F1EjZBpiAGlj0tE4fOSMyg7TdgYJaPq+RL4F2iTGFqEaaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783494962; c=relaxed/simple;
	bh=DVNTXLHX1vUyS9zVAhAFUGx9k5ZtrHeeZURle9eN7LM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rAHIsQm9Hxi3KerG1KnloQm4BAFnSM/aFEsC4Lk9hpf36jcE+6letkH1UH06oF6qu7g7Gb2NYanFJnERV5Gqyzxnxj2K7oqFKcWuRH387lXyKex5UAZTlHsCiwyrYUqiStZ9eRVQfZ86yesOOnPT1uslAPeqFc1LRXgoUjcaBPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K6moxY77; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K6moxY77"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C54F8C2BCFD;
	Wed,  8 Jul 2026 07:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783494960;
	bh=DVNTXLHX1vUyS9zVAhAFUGx9k5ZtrHeeZURle9eN7LM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=K6moxY77vczyPzFrIUnAW4/pRuMeYgxE5OdSAsfVjmRH0ZjW0Mf94lvGcjDKd9EIG
	 rcZb3ldeK3HE9kmeSiiqLlHUhRUSEZ6+gGZmSTbqL3FBv72yCZkrRaDNjkZWzDyB2J
	 Hoh3mWE7RKk7131oR06NlLxs+tP591p/2wSxDsOowR3rWjpv0ZzdIgszNjcqpqWDPH
	 cHuL6rq3/fxQR2XZFJlp6cpR93x6eQQDBlUsx5750peUighYmYEbJCxg+7+l/F1Vxh
	 GSnJptvx7K3XFpXgrmT1WFYbAczbm3pMKU3phQqiMyDGUwlWlm/LRU3UcNf3ld/jQQ
	 oG/A7KWzW5MHg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A66B6C44506;
	Wed,  8 Jul 2026 07:16:00 +0000 (UTC)
From: Sven Peter <sven@kernel.org>
Date: Wed, 08 Jul 2026 09:15:39 +0200
Subject: [PATCH RFC 3/6] efi: Add EFI_MEMORY_ISA_{MASK,VALID}
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-efi-psci-v1-3-9efb3abf0e4c@kernel.org>
References: <20260708-efi-psci-v1-0-9efb3abf0e4c@kernel.org>
In-Reply-To: <20260708-efi-psci-v1-0-9efb3abf0e4c@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>, 
 Lorenzo Pieralisi <lpieralisi@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Sudeep Holla <sudeep.holla@kernel.org>, Janne Grunau <j@jannau.net>, 
 Neal Gompa <neal@gompa.dev>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, 
 asahi@lists.linux.dev, Sven Peter <sven@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1258; i=sven@kernel.org;
 h=from:subject:message-id;
 bh=DVNTXLHX1vUyS9zVAhAFUGx9k5ZtrHeeZURle9eN7LM=;
 b=owGbwMvMwCXmIlirolUq95LxtFoSQ5bvTy0vk+B109JP9a57cmSRU0FFcPODuGU3op9wlAkc+
 nx7XpBbRykLgxgXg6yYIsv2/famTx6+EVy66dJ7mDmsTCBDGLg4BWAif68x/GbZ4Jnx49vsfcE3
 NN9sZJhYGCWrrJd+kHFfid3xT0137qowMmxtkvNz41gZJ5MVUrrBNO7Mvf2MfosFnrH/6tz5QmC
 NLxsA
X-Developer-Key: i=sven@kernel.org; a=openpgp;
 fpr=A1E3E34A2B3C820DBC4955E5993B08092F131F93
X-Endpoint-Received: by B4 Relay for sven@kernel.org/default with
 auth_id=407

As defined in UEFI 2.10, Section 7.2.3 [1], if EFI_MEMORY_ISA_VALID is
set the memory region is to be mapped using ISA-specific cacheability
attributes found in EFI_MEMORY_ISA_MASK. On AArch64, these bits are e.g.
defined as the attributes stored in MAIR [2].

[1] https://uefi.org/specs/UEFI/2.10/07_Services_Boot_Services.html#efi-boot-services-getmemorymap
[2] https://uefi.org/specs/UEFI/2.10/02_Overview.html#memory-types

Signed-off-by: Sven Peter <sven@kernel.org>
---
 include/linux/efi.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index f3db3a18b540..882148114068 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -128,6 +128,8 @@ typedef	struct {
 #define EFI_MEMORY_SP			BIT_ULL(18)	/* soft reserved */
 #define EFI_MEMORY_CPU_CRYPTO		BIT_ULL(19)	/* supports encryption */
 #define EFI_MEMORY_HOT_PLUGGABLE	BIT_ULL(20)	/* supports unplugging at runtime */
+#define EFI_MEMORY_ISA_MASK		GENMASK_ULL(59, 44)	/* ISA-specific attributes */
+#define EFI_MEMORY_ISA_VALID		BIT_ULL(62)	/* EFI_MEMORY_ISA_MASK bits are valid */
 #define EFI_MEMORY_RUNTIME		BIT_ULL(63)	/* range requires runtime mapping */
 
 #define EFI_MEMORY_DESCRIPTOR_VERSION	1

-- 
2.55.0


