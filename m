Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792933467;
	b=tE1zCinLM4YOY+K19bpIn7qCLXaJzEp+gwe86tRILkpQ/LbNuEk6LGO2JgGk3TVrSAt5
	 UDi4/Mxxt5psLPKmZ53wC0cpgd1IK2/BmAZRp8gPv65Rzo8iFpd1K50ub0XnXwItbHGqL
	 Ii0ojbmCbfD4r8WlBzdUDwuF4590lC9fgIFnX95LjBKX29Q7nq2tNGETBAx7lYbR12kZd
	 2WLeRqxknz0WBc66IoeSdiy3FA+kPY3HjEx7/8af4RvcS1zJuk9DY8vzMVcTfTalPm5Mz
	 I9LHmuTzMv02Fvbg1LsTOrGa7UOrEbPTSJojEy6T359xSCMryt/DGZIFH4QofjzWu/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792933467;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=TNR3QyZox0r/fJ2wVHjrtOCTI/dF/TfZ30YXVGFlwoE=;
	b=D2xqvHwisnbAfBnjZHqqUCihuFBOhOeoS+wb2hQC0Aediim/QrY827KeGAgw5noZTHAF
	 RCpN4xSUUeSyb1EHaGolUiapR7r6Fc0tViJfbMvqry4boNuv/c+yL7URdBT9XBAlTCHDf
	 ocw28CSaIQNztPbjyIm2IZmpMHnK5ryY/04LirV2Xl2ctEfDBh60CT3fMmzsKh0k0ebJb
	 wuITeyu5ZOpl4d5vAa+3hBSdiCag5eMUDXa7Rgxn1pbmRapQ2AVxCCZgPL5gFHyJlkk9v
	 7h5CZZQLKhOFnui7XoU79RSTlr3QA6FdsssWlyI6DduYjmaUKbyMX+8lFMn4RZRrO1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cIjEZC+O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCCE606A323;
	Sun, 25 Oct 2026 13:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cIjEZC+O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027121F01828;
	Sun, 25 Oct 2026 13:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792933466;
	bh=TNR3QyZox0r/fJ2wVHjrtOCTI/dF/TfZ30YXVGFlwoE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=cIjEZC+OCPC2Wr6ndWbRyr7RXVOGhE68iHGq6209kkvJmrqLReoyrSySDzdQ+YvZ1
	 B64FCiBq2xw0p6ZLghEAnyHNRo7kWRPhfSziwxUbCrINn+7+d1abzibqgKqEVMzC5b
	 0lsGvFH5PL5JJqePfXvFRCVg7/qNlng3n0Eg/pwPiqsDCTVPgxjkT4C4e56DPu+eZs
	 VLDfAxuojlsGnYv5UER/Bcc/LbS+F5UVFhYidzoWfrq1eYl4aZrcYjUcDm6f1/Pob5
	 iEIGdbIAL0hs9GMirxuHj3NjsthgYk9/Ck74wBwchzTu7Qt8PU0VKw/fKDo9zgH7zP
	 eOa33FUKqNH3w==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Sun, 25 Oct 2026 14:03:16 +0100
Subject: [PATCH v2 6/7] init: add secondary DPS root partition type UUID
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261025-discoverable-root_partitions-v2-6-fb77d0821fab@kernel.org>
References: <20261025-discoverable-root_partitions-v2-0-fb77d0821fab@kernel.org>
In-Reply-To: <20261025-discoverable-root_partitions-v2-0-fb77d0821fab@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Davidlohr Bueso <dave@stgolabs.net>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Dave Hansen <dave.hansen@intel.com>, 
 James Bottomley <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, Matthew Wilcox <willy@infradead.org>, 
 Vincent Mailhol <mailhol@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1918; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=50iQTJ22lCeoNYCHsmpuAZTJ2KztVLfpy4GaSdwH4b8=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFl3/9l4tvp5Kzt9+2t6Z+++zfxu1SHPqlzV6nQ/H5cP4
 dry5Pn6joksDGJcDJZiiizLyjm5FToKvcMO/bWEmcPKBDJEWqSBAQhYGPhyE/NKjXSM9Ey1DfUM
 gQwdIwYuTgGYap7ZDP+TjiS+f3/y+bf4qQuUYp4rOjO8eWw1IdDw9wy3G3K3br2ezvDPpFoqhyf
 Tp+LHvQzLZ03pWzacbZt/8pZ9TUCQv0fR/R18AA==
X-Developer-Key: i=mailhol@kernel.org; a=openpgp;
 fpr=ED8F700574E67F20E574E8E2AB5FEB886DBB99C2

Some 64-bit architectures can run 32-bit user space. For those
configurations, also allow DPS root discovery to use the compatible
32-bit root partition type UUID as a fallback.

Add a secondary root partition type UUID Kconfig symbol and include it
in the DPS root lookup when it is defined.

Try the secondary UUID only when the native lookup returns -ENODEV.

Suggested-by: Dave Hansen <dave.hansen@intel.com>
Link: https://lore.kernel.org/r/03be57ae-0e41-4b8a-adc5-bdd85ccce951@intel.com
Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
---
 block/early-lookup.c | 3 +++
 init/Kconfig         | 7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/block/early-lookup.c b/block/early-lookup.c
index 6c9664eeeb1b..b37daa105619 100644
--- a/block/early-lookup.c
+++ b/block/early-lookup.c
@@ -338,6 +338,9 @@ int __init early_lookup_dps_root(dev_t *dev)
 {
 	static const char root_type_uuids[][UUID_STRING_LEN + 1] __initconst = {
 		CONFIG_DPS_ROOT_PARTITION_TYPE_UUID,
+#ifdef CONFIG_DPS_ROOT_PARTITION_TYPE_UUID_SECONDARY
+		CONFIG_DPS_ROOT_PARTITION_TYPE_UUID_SECONDARY,
+#endif
 	};
 	static char esp_partuuid[UUID_STRING_LEN + 1] __initdata;
 	int err;
diff --git a/init/Kconfig b/init/Kconfig
index 133854355697..b605e2e1f94c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -2177,6 +2177,13 @@ config DPS_ROOT_PARTITION_TYPE_UUID
 	default "4f68bce3-e8cd-4db1-96e7-fbcaf984b709" if X86_64
 	default "44479540-f297-41b2-9af7-d131d5f0458a" if X86
 
+config DPS_ROOT_PARTITION_TYPE_UUID_SECONDARY
+	depends on DPS_ROOT_PARTITION_TYPE_UUID != "" && COMPAT
+	string
+	default "69dad710-2ce4-4e3c-b16c-21a1d49abed3" if ARM64
+	default "60d5a7fe-8e7d-435c-b714-3dd8162144e1" if RISCV
+	default "44479540-f297-41b2-9af7-d131d5f0458a" if X86_64 && IA32_EMULATION
+
 config DPS_ROOT_AUTO_DISCOVERY
 	def_bool DPS_ROOT_PARTITION_TYPE_UUID != ""
 

-- 
2.55.0

