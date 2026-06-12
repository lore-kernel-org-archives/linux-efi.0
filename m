Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67C83812C8;
	Fri, 12 Jun 2026 11:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781262134; cv=none; b=Im135vY5K4YdQByLjLMxRfOohzvLWncwbwGWXSRqIR0Nio+5nhSBiK7SLbyZJh8RWu6tnO0MSbxueYn+I55rwUrSXcsIr3DZteuyW2+3fxP+PoGAwltEeSEaf19Dwki3d2MeGrabMgsiupZjeNh6SncFFPqmqUbStYBLIyKLecc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781262134; c=relaxed/simple;
	bh=fRGtotrTms2PKa4N3Tmc153MSWNcO/MNUc7fBosIp18=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=uURWlZ5RJdjw90r/UeqWSx0/Mfx7Grav//uMOZGcLLFZoXFUmZsI1xPEt4yq9JWzlxkxpJfGvAg/WtjUdvFbV72V8b+YfcRUICUy9a1EaKR7xxgmuX3j2ko44Si2dPErOKJd1UJMwv8LqXyALxEmypR8Aj/a0Cs5tKsPXvG0bgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=iyiAz1I7; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="iyiAz1I7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=7UF2lklj2j1k/23uQNZD3bWtpVBTGSmckOACnV8XxVg=; b=iyiAz1I7eJk2XVjJkjIXhFhl/w
	GjmY8JnHgolVGK+3NK9X5lZw6ecKlM+67XQksT//0EjcK8d192M4zktlUcSO+Ogp3LkmOk8KzUOtD
	XUsCt+rGYuRMFNEcVDyOq8+Z6JE270TDMwm8h5VoTPOcHkjarWSXWl/gRNv3Af7j6m8JhnYy2XemL
	1xm7x4wjcvdDXbh9VeQyQ0Uki6/N4lbURtwC31PHWGBzrPySfd4nfhw+K44P2rCYucEvTW1qOVcZl
	857ojhgt8vA6JF/rTLGfQcY7aS/LWYcUl6YXZn82EQib0SQlxUOz5JxLkyKKmJjlO/nwQsjcVjOhN
	K7nOHwSA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wXze6-00Aggz-1U;
	Fri, 12 Jun 2026 11:01:54 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 12 Jun 2026 04:01:29 -0700
Subject: [PATCH v2 2/6] efi/runtime-wrappers: handle queue_work() failure
 with goto exit
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260612-efi_timeout-v2-2-f714bb016df6@debian.org>
References: <20260612-efi_timeout-v2-0-f714bb016df6@debian.org>
In-Reply-To: <20260612-efi_timeout-v2-0-f714bb016df6@debian.org>
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
 h=from:subject:message-id; bh=fRGtotrTms2PKa4N3Tmc153MSWNcO/MNUc7fBosIp18=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqK+cTrgDheevMvWPv4YqwaO36DiwaG0p6HUsVK
 Sp363TpfHSJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaivnEwAKCRA1o5Of/Hh3
 bU9XD/0Qd1vBDhU2J06AhkGtiOGHxrvzwslD60fXzWsws0uF8BbitDN+/GF5eX7ttxCr4leUrQ0
 9bw05graYHNAKVAYHttlBlwZ9hBSBZo+EO26IKzixh/PpgSO4O1+YS1n34tkRjo0a+F33t/vSIv
 qJFc46fP9T/57Af8qX/GpQFUK2/aootYaDpMNBrStRXvGrOmC8ZVFgXjO5wdO80IFNlsURqdJua
 6WumflOzvbZA7vimy6ONDOFpBVbYrjss6R1NiK+OmuWKcGEWXBxzFfNQeIzxxJIMUkXI3ObK2KB
 stRFZqJxssq9RPK3wDdxXzcLHWawLrOsAGBt5YrS2+CTC59o/vv/3iuKzq15GCyG2C+hYizGXGx
 Z3ZN6NZAwTeulSt8t5Lglz7yasiLFETt+ZotC/qrITyaMBTd0rYIJxaaoMJ1I5hP6/5NiEH9QuN
 j442fbpo7l865ufZ2Pg3rdaVCIqTpfohKHiw0IyNOOiugmYmBWbKY97ucxn0dw8ZPogbaG30j4o
 sHVxn/Xs0VaImHdzz6AcEHMNEKeUUUU8BIEx7bsCR5skixyEAyflfB7zW9K+hgtnCYiWeVHNdVB
 JCTzlqDToJOv44f7AfOodEJ7vidquer5Z3mwj9mixwl3T4nvVNkYeG3jOqECpqAtdga6e8kdwT4
 +DV+YoQ3H/+42rQ==
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
index da8d296216441..ebeec87ed0b0a 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -338,10 +338,12 @@ static efi_status_t __efi_queue_work(enum efi_rts_ids id,
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

