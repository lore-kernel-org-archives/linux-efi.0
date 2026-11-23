Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795453857;
	b=Hol0sRT+U59bmtVJHpQbLjFSJ8k38wxR+eqlsOzrnE7L9mBjo5Rz5plcWWX3apTSrx8F
	 ZbngVhoJFue8sqKa1PIcqh3M8cfdDa67d1lkxnXZ8Fa10N1ZkOIiderryjDViUIwOJvdf
	 nCHJwQnguRTZbVbsrhYEwdmmnnAdi3Fu50kFMwKRW3qy6ZKGMTo1PRo1dmR23flq7bLpX
	 Ax/r6uErm0BE/LoCZ2LIeOU1K7swMKRzcnRF0geCDcdogKHeOqEXJ+WzWa2rD26P7JPhU
	 Q7+Pmmr+75C8C7XeZ//YBUtPJKnyKmwW2n072dHMG0RObmoFAFL/j9oBBw/FMZJc1WQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795453857;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:X-Developer-Signature:X-Developer-Key:
	 Content-Transfer-Encoding;
	bh=Kwx0VXdkr2Ncnce+Ox5d4a5W8uY1VyIrstkwXcVxIkM=;
	b=XypnhKibXcoHK68PQg6edc+G80CGb+MyySX7pPPbCiJsqsKt8p9qjZ/406RyiBV4f5qG
	 HxFeZijFF1vKbgsIwUURoDVALVQEuveIT9PGupyonGV4x+JNcEEOUuIPMPErY+yMaqRNx
	 R8T3WTFyixtGUoqWRFxonJ97Pp9pZHGFnSZXSoBStOyoOn9WrROvkpm7shsrNLtA/w/zW
	 vB6GpT6ePr/hxTLije0T+5W02m2iq13APf+VxWx0tAcDIT78HweR8mG3Q9mta15HKzr7s
	 x8fbe2klsmc4oMBcNIREsqOpPWz9DN0v0jhl7gaKN3q0lqbaNArba9MTPOZXV31FWGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=djIihdE9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1295F606A695;
	Mon, 23 Nov 2026 17:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=djIihdE9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E2C1F0093C;
	Mon, 23 Nov 2026 17:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795453856;
	bh=Kwx0VXdkr2Ncnce+Ox5d4a5W8uY1VyIrstkwXcVxIkM=;
	h=From:To:Cc:Subject:Date;
	b=djIihdE9fRJMZbKvtP/Xqld10gioAqiqRazO4OCdDMy/EDZkF/5cVaAWhnXz7fHi8
	 KAiYDXMP0VwfMwZ0Z2RDKP08UxC7sjwPkusXPjnP3JuOkMD71YfyKRUugskp0Ehlzb
	 osoTMG/OnvpENnsb4DZ2azT2iBc1Z6OdoQlD8++03bNLEXlDvCLfrp3a6tFJ/BjYje
	 Z99K6IN8blCcEcJaRQZ8JTAkOD1oNPtp/IZ4B+6Z1unQiDZjaqDZa6zZL1efhFM+/v
	 2Wu386SjXlbhPEDcCaM9wMpFQAtyr0MZ71Nld6Q6fIEDRd+RD3SLuxZIFgXhzj+fhc
	 VksD/GahymhUw==
From: Ard Biesheuvel <ardb@kernel.org>
To: rust-for-linux@vger.kernel.org
Cc: linux-efi@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] rust: Omit visibility pragma when calling bindgen
Date: Mon, 23 Nov 2026 18:10:43 +0100
Message-ID: <20261123171042.62348-2-ardb@kernel.org>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1416; i=ardb@kernel.org; h=from:subject; bh=R6ZPj22CGeB8MKN1Eesn21O2k+b5u1uwMnmJdf+gFxE=; b=owGbwMvMwCn83sBh/rljoYmMp9WSGLJZiid5c1+W2PtVtEV62x7b3wwuATNMRCd95e1Y86jR6 KSlCtf0jqksDMKcDLJiiiw7lXO6X7uIvtNXqMyBmcPKBDKEgYtTACYS48TYsIVTblF/Xxbr+uI/ T5qOfrA8FMc438+6gqc6/Luovkf5xG6dlTPs5J6vNnm15tMZjolHGOsdA9Zy6y6rVJ6VoNjZvmX FMeMt7JOXSAlHGSW+kz/CocS6ax+fyfUfQZfahI+b7BDYfhIA
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit

bindgen is used to create Rust FFI definitions from Linux kernel
headers, so that Rust code can call into C code.

bindgen is a generic tool that is typically used on C library headers in
user space, where hidden ELF symbols are never part of the public
library API, and therefore ignored.

The situation in the kernel is different: hidden visibility is used when
using PIC codegen, to force the compiler to omit GOT slots for
references to symbols with global linkage (and to allow the "i" inline
asm constraint to be used with global objects).

So withhold the #pragma when __BINDGEN__ is defined, so that bindgen
does not disregard the kernel's hidden symbols.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 include/linux/hidden.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/hidden.h b/include/linux/hidden.h
index 49a17b6b5962..e8d2844047d2 100644
--- a/include/linux/hidden.h
+++ b/include/linux/hidden.h
@@ -14,6 +14,11 @@
  * Fortunately, there is a way to inform the compiler that such symbol
  * references will be satisfied at link time rather than at load time, by
  * giving them 'hidden' visibility.
+ *
+ * Hidden symbols are ignored by bindgen, on the basis that they are never part
+ * of a public API, but this is not the case for the kernel.
  */
 
+#ifndef __BINDGEN__
 #pragma GCC visibility push(hidden)
+#endif
-- 
2.53.0

