Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E690E383C80;
	Fri, 12 Jun 2026 11:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781262133; cv=none; b=GEkWLy/qBbPCUfkOjNpfdRYC/lK05ntyhl5jorAypRrbvb5hQygUPGO+nHvtJ4i/Pzok2y3AYj9dr985QkvLwrH+5UhDjHoD6lSfaDGc8BMhXrnCCN4+80x7DmkVMmEE4yVngVvRs5Rjbh3OEKSM7xEECdX3dJ479gTF7jHvcGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781262133; c=relaxed/simple;
	bh=FQE7ybV99BMlIVdJ+mmYjaTeQL2S1rRPXQbCjv3P8rY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kHluFekF1eA91a0KNhrCMmu3VnZ20zk6snuA5TJFqQh80ll2kxGhQkbKC9d2hNqPzfdt1OyOfYimECwDw+8bAogn4T8oCZxMMqRR3wpLmXO9rVwZUysfV3sNjyvonxHwHOGemyYXADn9WRRKYgZw8n6wJpQDvvHAhkwJJMggNdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=KJqJdnxE; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="KJqJdnxE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=+L34aHUzNvK03IjgFQ6odD2fLOIPjUENcEEOj7gv7IQ=; b=KJqJdnxEjLgtNJJkDnEZUxMOq3
	W0Ej+6XT7nTbP9b3PpcZ+PAMkh05JnMExCpGmfUSsy1GQP8G/UY21Bkx/aBifFfU0YGZrEv9y8UK+
	sW58MPxt7fa2YAlmF9bgr6t2/ei6fJeHO5eN9bQE3suuf87k0DFphPsWPQk+LW1F3qaYQCcwkctY9
	jsHi1nijoOUJdzwPgfh5IeyUofwnrdo+IiwNyOJDTMiyKf/x6L4DIXmm+/VAtuHLDFY0vnAKnB8Gr
	h3+lyPC55JcsFl0sAUcq9TyZDBJucUXLoMc/Eda1JaFW9bg7XhCvZi9r8KKv9Wo7DyN5nOiV7LVCB
	uG33/52w==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wXze1-00Aggx-3C;
	Fri, 12 Jun 2026 11:01:50 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 12 Jun 2026 04:01:28 -0700
Subject: [PATCH v2 1/6] efi: fix stale reference to
 efi_recover_from_page_fault()
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260612-efi_timeout-v2-1-f714bb016df6@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1036; i=leitao@debian.org;
 h=from:subject:message-id; bh=FQE7ybV99BMlIVdJ+mmYjaTeQL2S1rRPXQbCjv3P8rY=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqK+cS63z3Ozf27S3A2qWioN1jzu97OD9fRs/eB
 TDv/LPabBmJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaivnEgAKCRA1o5Of/Hh3
 bYlJD/9H+J0Cleg74pmfLB6eof/2kiEvIWw0hQAqpH8xQ0FlEp4365x04swh2l0SzleJMk458Km
 Jh4xj6tkzuDMntdEFG/MRuJi0QFknGX5Sd1o8/fqq6j0n4rSaDtf+o3qIxDUbkxY5Xx4al2beFg
 tI8XGhVvkgizqHJeRVuU5s+5aF9IqVyr8KsCgHUvy2ZpU0bWVIh13O6DNwIsd+UwwiVXF0bCe9h
 NBr8SOFErGfqAeEEktsmioSrKdtAvY6mIMZkw/mkqA68q+ZYIh1JIgdwItvG4H/AuYjoYkdsZJQ
 rhKxzdHPUxi9jY+fO6buow8cSUPYo7eC6WTBPihgu9fFsS4LigqbG4FQQDxq2uCjCL1uB6wPGv6
 YjvTidN0noSIWja05/E2yuq5ZtMzh10llXjc/oImnk4nZ/PXO7fWdJUMR5Nl2NNTpy9h6+shyLc
 eRv3jX0yi0QnPZxeB+1TUmUYz+6dNE0+gs/H1BEi1Wvaed8CnTXbIfdKBkA0jo0haPM4+zT3xQE
 HRzrzYoGOxLkbY8QNgRJ0bUBU01t5TzaS8xSfBN5G7lg1Hxdj2YCHJJHEXWZ8DaOhq2xSMhvS+b
 +j4DHZv+yXj7qEajQTywhN0XwKPLzyEpffS/3hmmUpwux2U/9HLjm2Nl8glOt9BCJzomsgOb/Nd
 ZN/LiIUIQwXVATA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

efi_recover_from_page_fault() was renamed to
efi_crash_gracefully_on_page_fault(), but the comment above enum
efi_rts_ids was not updated. Use the current name.

Fixes: c46f52231e79 ("x86/{fault,efi}: Fix and rename efi_recover_from_page_fault()")
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/linux/efi.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index ccbc35479684a..24221a8424121 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1212,8 +1212,8 @@ efi_call_acpi_prm_handler(efi_status_t (__efiapi *handler_addr)(u64, void *),
 
 /*
  * efi_runtime_service() function identifiers.
- * "NONE" is used by efi_recover_from_page_fault() to check if the page
- * fault happened while executing an efi runtime service.
+ * "NONE" is used by efi_crash_gracefully_on_page_fault() to check if the
+ * page fault happened while executing an efi runtime service.
  */
 enum efi_rts_ids {
 	EFI_NONE,

-- 
2.53.0-Meta

