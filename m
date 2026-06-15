Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7902DF152
	for <linux-efi@vger.kernel.org>; Mon, 15 Jun 2026 23:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781566124; cv=none; b=WI6chBnmNuBXesmHsaNtbhCxBgG9ZsNuMWAodfzWdwb61bihhPvlduG55DXe6rQvNBzlTkTV4i0fmIqi4BONHNHoF+yT5mYjC+z7L0lo2vXsOn9rNuuhCWjy5nod5L51ECWQmD6t117dT6lQ5elarLj65szP3hHTbDREvCxO1O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781566124; c=relaxed/simple;
	bh=NNiG4rqPFC8BQrRXjhTqiLRidsNkTGaUd2xAU0lkm1M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Fb7SaV1hxrI9O4Kp8dmaxP7we2oABDT1y0eRfkG5JaNjX+/gJ7Z1I4SiyFycNvMajOGEKuN46euikj6S32WQvRHrJYOjML7KE30XBYfLB+v2J965k/mvBtzKSeFUVXHlmqlMsHHeucRVw0X3ToTQkYshj82OE7D3bBKroqlx9gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cVG44EW3; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cVG44EW3"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781566121;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bFD7PCYKgMNlQ0jJPMmBIf9JeT90Xg327A7enHcLmAQ=;
	b=cVG44EW3QUCRCgsq2RqyhOsSP+ar7IZtxISVDRqexoye3m3MkwCuL4VwCJZ0tbO9jJUnfL
	sK6MpkXMKSuGR3NQorsVjOFspqTCHgR5OWb9dQobANunc+yi6tch6aA6sL59rHbfm7Vl4J
	OmKN5Y+VsweLxuoBzW/kEX6II7uKs5o=
From: Atish Patra <atish.patra@linux.dev>
Date: Mon, 15 Jun 2026 16:28:21 -0700
Subject: [PATCH 1/2] riscv: efi: Power off via EFI runtime services when
 available
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-efi_reset_shutdown-v1-1-9414edcbbab0@meta.com>
References: <20260615-efi_reset_shutdown-v1-0-9414edcbbab0@meta.com>
In-Reply-To: <20260615-efi_reset_shutdown-v1-0-9414edcbbab0@meta.com>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
 Atish Patra <atish.patra@linux.dev>
Cc: linux-efi@vger.kernel.org, linux-riscv@lists.infradead.org, 
 linux-kernel@vger.kernel.org, Atish Patra <atishp@meta.com>
X-Migadu-Flow: FLOW_OUT

From: Atish Patra <atishp@meta.com>

When booted via UEFI with runtime services enabled, EFI Reset Shutdown is
the firmware-preferred shutdown path: it lets firmware run its own
shutdown hooks which may invoke SBI SRST extension internally. However,
RISC-V always powers off via the SBI SRST extension today and EFI runtime
path is never used even when firmware provides it.

Enable the poweroff via EFI by overriding efi_poweroff_required()

Signed-off-by: Atish Patra <atishp@meta.com>
---
 arch/riscv/kernel/efi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/riscv/kernel/efi.c b/arch/riscv/kernel/efi.c
index b64bf1624a05..2d3cc57b4535 100644
--- a/arch/riscv/kernel/efi.c
+++ b/arch/riscv/kernel/efi.c
@@ -95,3 +95,8 @@ int __init efi_set_mapping_permissions(struct mm_struct *mm,
 				   md->num_pages << EFI_PAGE_SHIFT,
 				   set_permissions, md);
 }
+
+bool efi_poweroff_required(void)
+{
+	return efi_enabled(EFI_RUNTIME_SERVICES);
+}

-- 
2.53.0-Meta

