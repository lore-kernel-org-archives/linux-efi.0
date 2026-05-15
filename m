Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781B4245019;
	Fri, 15 May 2026 17:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778865014; cv=none; b=UccLdabY7jBUkmbqdyVAdPipckUh4KEKoCkGOL2HzvjpOV+GUREmC+TfgyVvPf2cu79gz4WeTHQwUVD+ekv0gNsbzsqU0Hvvdb49+NSAdnrmpF/fpA0qFAyYfSevoG9NTfzMt5pc5rDEy2b7xn8gG1Gd6rcDNV5TboLezLthDtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778865014; c=relaxed/simple;
	bh=+i0USv30+prXYPsb8xROhrFTFF7OzfqSJF6Ez2jlk1k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=f/MMqJSEbmeQ5ZvOz6zTlgpA5cVtlxf3pUoQFhtXObDHzT96JzyoDas2bnVpWaECX53b7seHj4MTJIDkw1U4BWkBPHbzzXE0JDSrVzzM8az6a4mUN0o6Ilf9GOimy/tpALc5w4euXzoCWhhHqgvK/wibM3vDwoMHG9D4m3909hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KKqcn1vv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KKqcn1vv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF74C2BCB0;
	Fri, 15 May 2026 17:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778865014;
	bh=+i0USv30+prXYPsb8xROhrFTFF7OzfqSJF6Ez2jlk1k=;
	h=From:To:Cc:Subject:Date:From;
	b=KKqcn1vvvMv+9A3/ADHPL6IYhPhi6AAz2asusD1Y2A2jz8vzg32R/6wmOZB0AnIph
	 JUJpZJDRYM+5aOKu/C89ACagFKuIpBhTAxJAlJoNR0HE8hgM7KVFh4QDhh9luuTiCX
	 KD2pBSSG4/MRspr21qxTOwujzXW3E38erAgsJngQ1rsVqto7QmBdU7SXrTC5zs901v
	 4goiQaAWD9x2bOm8Loq9c+i28Dbrii+AUjV9HqjSXg1/q1Tg9lN+d8kxFx5QZys75D
	 ToQiZDqgx/8ekMfkqEyd6Q26KM10fqQxOwTkhVNltPYP6sSkTiG1SL5Bs5pifms616
	 o5Q/+5lkTxzzQ==
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org,
 Linux ACPI <linux-acpi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject:
 [PATCH v1] efi/runtime-wrappers: Avoid crashing on early PRM code invocations
Date: Fri, 15 May 2026 19:10:10 +0200
Message-ID: <2415513.ElGaqSPkdT@rafael.j.wysocki>
Organization: Linux Kernel Development
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

There is a dependency between EFI and ACPI PRM that the latter cannot
run until the former is ready and PRM can be invoked from AML early
through acpi_platformrt_space_handler().  If that happens before
initializing efi_rts_wq, it leads to a NULL pointer dereference.

Avoid that by adding an efi_rts_wq check against NULL to
efi_call_acpi_prm_handler().

Fixes: 5894cf571e14 ("acpi/prmt: Use EFI runtime sandbox to invoke PRM handlers")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: 6.6+ <stable@vger.kernel.org> # 6.6+
---

An alternative would be to somehow ensure that efisubsys_init() will always
run before acpi_init(), but moving any of them to another initcall level is
not an option AFAICS.

---
 drivers/firmware/efi/runtime-wrappers.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -590,6 +590,8 @@ efi_call_acpi_prm_handler(efi_status_t (
 
 	if (down_interruptible(&efi_runtime_lock))
 		return EFI_ABORTED;
+	if (!efi_rts_wq)
+		return EFI_NOT_READY;
 	status = efi_queue_work(ACPI_PRM_HANDLER, handler_addr,
 				param_buffer_addr, context);
 	up(&efi_runtime_lock);



