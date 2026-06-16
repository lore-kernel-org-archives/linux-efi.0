Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA3B438FF3;
	Tue, 16 Jun 2026 12:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781611812; cv=none; b=KgIvfhSFNQ42FxU/EruA/RsAH4071/KofACPwKqi3gCHlGg3EFjvxjuFUygJFqCj6ICqvXhQiwvUqTopSpuLaj3y9AvvyZAjiEmWaA59BvrgtVzeoUPFJSTctYjMcTnlawn9jJY1LsbTnHZ52ucWoesyYm34zyI4NJJxSamBAUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781611812; c=relaxed/simple;
	bh=2/JDbVYjZLfh4w3eb77yc0BEWQEQY7/ob0SR2p63vK0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KEnQkn09ltlbDzeH9caPPgroCQVRQAgXhgmcaLHDkDnhyG3kIRpigM/JzK2LAP+2n+Ckt0MlloZ3+9xK8QlgmSSNGTaxlMVlxddQ0TN9KUaKotIBzAcKWifYlp9OpTGO0w3JMCqZnfgxqVro03R8AbIe+1BDbiplYXzrU87EzAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=SOjnoYij; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="SOjnoYij"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=5JWJq9JumuQbJPB3n4t4VMloAqIKcm6OV0k+9iGlBXE=; b=SOjnoYij1+N5CAH76YMoa/Aq3m
	27EXwCrxCAYyzHBAcmnwqEUhfDGFZ0qGKAfvGm4SZzRyPib7Ul1+OXNv9i8ZUSMQIhCE8g3QIeqX8
	/F9qJfdHrsK1kfXdANiSr525d0UFYFbEiWudREva/H9vSnC3T+KbIRQXjZ/pdpMzjEWmTi3Uwv2Kr
	LIpMFJx5+As+IwJZkjTZ50wDaajiouXfxIMzfoXxSF9sg0/RZS34NPRY2cLI6mXEX/AHeRu3rA0E+
	MvD5pzvIoY+AGy9QVA4lr52uUEC+hk1Z13n7pHy1L2okQbk/3DwUspF4OCOQnS1Rh/vj1zzIOOJyR
	vTFtD2+Q==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wZScF-00Dpsq-2P;
	Tue, 16 Jun 2026 12:10:03 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 16 Jun 2026 05:09:36 -0700
Subject: [PATCH v3 3/7] efi/runtime-wrappers: handle queue_work() failure
 with goto exit
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260616-efi_timeout-v3-3-76dd1d26657b@debian.org>
References: <20260616-efi_timeout-v3-0-76dd1d26657b@debian.org>
In-Reply-To: <20260616-efi_timeout-v3-0-76dd1d26657b@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, 
 Kees Cook <kees@kernel.org>, Tony Luck <tony.luck@intel.com>, 
 "Guilherme G. Piccoli" <gpiccoli@igalia.com>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1449; i=leitao@debian.org;
 h=from:subject:message-id; bh=2/JDbVYjZLfh4w3eb77yc0BEWQEQY7/ob0SR2p63vK0=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqMT0GlwKWvzA0UGIYMTbF8WZsHh70vclTFQ7/H
 TPJWYVLRVKJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCajE9BgAKCRA1o5Of/Hh3
 bRiFD/4gsD85ee/SvHMY42IWn48Ru1k+fYtctt1ZT7eDJE/S0ckeT5sqjmtJaUHfHNCg7i1/V62
 7hfEaDrslYhFK9aeThnI8BKQzO7HReAKxZSLM/imm1vE9qHr4rTwVGdCwhpfq/j9PTRBgzKz7fP
 uttQkwB2wl+9wKpkuo0ityIc24mXdk9qSoKGKKgzFCWohCdooH+tvG8pZMru3gaPswLk1KJZ6C+
 I51EsnJlP1hZcpQ3AUFdwY1uHlxTDChxyjltyNdZrikRDL6K4Q682rasp1KGXE7gNYEkyWJ8ivm
 OnGAX0tPBdqTk7WqsoojG7Kf0Eks+DAeRBStbsQwUggam4rFi1bz2edBQwlpvDYZyNTU/8KZdYN
 OreAplBlRZbhapwZrpI6LpzWyTSwv3LtAtP7GjvSTHC08kYrWMD95+Mtz87DS+v1z2DXKBKJoQ+
 1IkGRZSELKkDPvUeiXdnzC1iYW/WR6qY1Qp3W4l8BfKGutz02tSEYfZVRQicxEA1wNpYbXyf1h/
 bQTlYyE0JXVMgrBb1WW7NHDjQUF28+Ll5tnh1VErWSQlZgE5DzM85IeaORbleyCr+aSW/syMpEj
 uqCjGHN+c0hMcbkHbOowWaJvHzy4wZfkcJPezDnFSfEVax9wGPV/xvoq31IggGOSFHK1SeQlpfM
 Q6XIl4JLbc6fM4g==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

Convert the queue_work() failure path in __efi_queue_work() to a
goto exit instead of falling through to the wait and the
WARN_ON_ONCE(status == EFI_ABORTED) below it. A failed queue_work()
leaves the status at its initial EFI_ABORTED, so that warning would
fire even though no call ran; it is meant for a completed call that
returned EFI_ABORTED.

No change for the common (successful enqueue) path. This also prepares
__efi_queue_work() for the timeout handling added later.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/firmware/efi/runtime-wrappers.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index a1e46ab003668..13857e5291b91 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -351,10 +351,12 @@ static efi_status_t __efi_queue_work(enum efi_rts_ids id,
 	 * queue_work() returns 0 if work was already on queue,
 	 * _ideally_ this should never happen.
 	 */
-	if (queue_work(efi_rts_wq, &efi_rts_work.work))
-		wait_for_completion(&efi_rts_work.efi_rts_comp);
-	else
+	if (!queue_work(efi_rts_wq, &efi_rts_work.work)) {
 		pr_err("Failed to queue work to efi_rts_wq.\n");
+		goto exit;
+	}
+
+	wait_for_completion(&efi_rts_work.efi_rts_comp);
 
 	WARN_ON_ONCE(efi_rts_work.status == EFI_ABORTED);
 exit:

-- 
2.53.0-Meta

