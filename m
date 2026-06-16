Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523B4369965;
	Tue, 16 Jun 2026 12:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781611828; cv=none; b=J4bZxlLI0ZJ55EJGOVYPcqF0mX6RmVJYMXW6fw5Sa/BJqj9S7PVl1zn4H91MRu6PqY7ZqjCNtCVVYArDc6xKlLP6S1n35nAy03nNW6N/u2wto8oYzv5p43+Hgfd2VVQUqHdYkU0E6cqplwwcFRwk4tc5KXX9KX5+u8qFvI3db+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781611828; c=relaxed/simple;
	bh=xQ5bXp9B+TfTU8pj9N5odhFoRN2WAMOO0MhkICaYDt0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tpfbQ1AsK0dFOPmhAEKj4E9EfqJld6zbVOQ8M0O8bIysS4l1hqCU1LyhfSxwGLfNGGcVHRKNPd3YaOJukQB20UzYMq4ZOoQU0nR7pWADJ+KnTJJJh7P9lUyVJDSPwlE0FlmwYwRma5NVrcacJqQezBEAe0BrLU7Oampxj9JpU84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=h/n5bdgU; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="h/n5bdgU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=HsKe4koDsujp+QOJl/JeTuPpSQOPTrtgkyf6GTNBAWI=; b=h/n5bdgUhjiTVWEvdWSSaP3Qgq
	W+6vUp97ox82JMlZhF5ZAND+9ThoFZXrNd2svdW/mj7enmaW1LMa91kmAHvrIMswVVdFLRsQYSGIj
	up95cEh+oNo568Cw6nqwc+tyuCYKz84yc1K0O9rV5IERcS/ACj7sLQmVBPErdn6WmdlSD4Vbk1yC3
	ITDCZJoVaaPRWG779ExwLqbSG8gY5JuqqYKnZySi6UhXh1KSovByTCg6cZRU6fd5tQVqj3GK+SqVX
	KTwzyqdn9csma6Tnv/8XgWqa3j46G1z0CiMrvwHGoiE0sGx6FhgobIjC7j5f5h1ECRfVlyKkIQ54+
	e0NFfj8w==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wZScY-00Dpuc-19;
	Tue, 16 Jun 2026 12:10:22 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 16 Jun 2026 05:09:40 -0700
Subject: [PATCH v3 7/7] efi/runtime-wrappers: retire the worker if a wedged
 call ever returns
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260616-efi_timeout-v3-7-76dd1d26657b@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1370; i=leitao@debian.org;
 h=from:subject:message-id; bh=xQ5bXp9B+TfTU8pj9N5odhFoRN2WAMOO0MhkICaYDt0=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqMT0H6AWlNqSLlem4PU9SeOw69ylKmdyH0MB4B
 nG8hiP/SjWJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCajE9BwAKCRA1o5Of/Hh3
 bYm0D/42gywBTlKnAcASsvwavRO7Qo/CqKabdvPp8a3P/EqE+BsP9AeVO0kNplBLwTkd5bHMmtG
 NSPq7NV+HP1d6i9luJrSSQzbSD/UjlmqahgUWDBay6VYWLFFAB+Md3AGqTMQAhaKh91819orkxq
 dkD2AwfX35Buziom+LScPOtdVdKPHwrTyjLIgZcywkNAqwzBsGd+ey/WbdlUMbZbVe74XmBspui
 XQsHSqAPyZZg5gBXbYf8ZACjUoHmlQzL/pJtDsqG3BjgatVgSmSqp7mL0DuwY9I+Rr1QO25VSZ5
 jZ0f66kb8UObQ8zTlXzj3eTdcfpVuyUVuIfszDc9UhITxDq19T/9EyZ+eiRxKgJpE/duvSIZLpn
 TSU/7VdBZap3idhnafhVX3htB6StnHRk5K3SWDWahuc5dSXY5QkJQXJzBdtHzYssjG7r/N/82DX
 LnDdB0o7QQdnvZ6y4BHfHwUfdCT3ZJzxmqXrATfjTzLqBEBDJiI0/JWdc96CZw6FsSHRoV2PQOj
 vA3ngbobG2Ey5aHrCdZwbLseqIyHWZotVdFRhmtalSeRX5Qj7Gc7U5DVbirQt+Z2h7NO0nlj1dv
 j4h0qeyZMsBmVjGMX+IuaRTGswoyDBYmI8wAYaWfLS6kJkDx2sdb1cMBCWW9Sg780Zeb1sXrYlh
 Z/fHdltgnNBNZdA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

When __efi_queue_work() times out it disables runtime services and
returns, but the kworker is still blocked inside firmware. If the
firmware eventually unblocks, efi_call_rts() would run its tail on an
efi_rts_work that the timed-out caller has long abandoned: signalling a
stale completion and clearing efi_runtime_lock_owner that may by then
belong to another caller.

If runtime services have been disabled by the time the call returns,
park the worker with efi_rts_park_worker() instead, so it never touches
efi_rts_work again or returns to the workqueue.

Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/firmware/efi/runtime-wrappers.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index 2b0a7caf90944..591a725b10613 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -336,6 +336,9 @@ static void __nocfi efi_call_rts(struct work_struct *work)
 	efi_call_virt_check_flags(flags, efi_rts_work.caller);
 	arch_efi_call_virt_teardown();
 
+	if (!efi_enabled(EFI_RUNTIME_SERVICES))
+		efi_rts_park_worker();
+
 	efi_rts_work.status = status;
 	complete(&efi_rts_work.efi_rts_comp);
 	efi_runtime_lock_owner = NULL;

-- 
2.53.0-Meta

