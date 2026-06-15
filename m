Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC7B337BAB
	for <linux-efi@vger.kernel.org>; Mon, 15 Jun 2026 23:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781566128; cv=none; b=rX/DXX2fIgdd+pjSePTGbs4l3WbPsm7cwXwEVDx/RtpoT7A2fxZq1Ew8tOeenAw+NJshc2hBQZzR5cRdi2rcBRCK6yDKznXI4GiTstrZ84R4Mwk6gRTCpmSJmU0G1TregD0wHGVCnG1BKktljKUXNpqbzH8zVfABGKBWvyJOJl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781566128; c=relaxed/simple;
	bh=W8ZPnWClI1FOSOffrRXJpJp5is35eKP4cq6LR7fhCs8=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=VcllspIf6T+rWLWPixx17leHMvXNIDA5baQKoa59Ci6t8dxTX8srey8XA6Ps4e0ijsMhbjMs4XZCDRtj+ln/buEJ3b3sdR5RNpkFuL9p3mNXfIDxc2aqu4f8Bf7Kh4HtKeIrvCJsXaVw7WZkF0tcIlcXO7WX+9lz9eveLYwpVNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ISP+HsIX; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ISP+HsIX"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781566115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4xr3tBk+BcbA0Ah+NVqqu2m6gD+J6uNNVuR2VL7WtzI=;
	b=ISP+HsIXpQlsmofH36Ugigwu7YMla5aN6h9djLvy+3PewRaTGPwX1SLAO5LIN80oC5DqfL
	ypMeNdRxv2pa0al8G2cGwjBTeu8iZQNvxdUBH8Jd2um+fIQGe48AgTjGFMiEL55FWE5+NN
	P8rpR0rYGX7GMaMybJhSkG8/4KP3cZ4=
From: Atish Patra <atish.patra@linux.dev>
Subject: [PATCH 0/2] riscv: Use EFI runtime services for poweroff and
 restart
Date: Mon, 15 Jun 2026 16:28:20 -0700
Message-Id: <20260615-efi_reset_shutdown-v1-0-9414edcbbab0@meta.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJSKMGoC/x2MWwqAIBAAryL7naD2sq4SEVFb7o+G2wuiuyd9D
 szMA4yRkKEVD0Q8iSn4BDoTMLnRryhpTgxGmUpVupS40BCRcR/YHfscLi/rxqhCjTZftIUUbjF
 J9z/t+vf9AIeN/SRkAAAA
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
 Atish Patra <atish.patra@linux.dev>
Cc: linux-efi@vger.kernel.org, linux-riscv@lists.infradead.org, 
 linux-kernel@vger.kernel.org, Atish Patra <atishp@meta.com>
X-Migadu-Flow: FLOW_OUT

Today RISC-V always uses the SBI SRST extension for both poweroff and restart,
even when UEFI runtime services are available. This series makes RISC-V prefer
EFI runtime services for both paths when available. The reset via EFI is
required for EFI capsule updates and also documented as a preferred method
in BRS 1.0 spec (e.g. URT_030)[1] 

Behavior on SBI-only (non-EFI) systems is unchanged.

Tested under QEMU 'virt' with EDK2/UEFI firmware exposing runtime
ResetSystem().

[1] https://docs.riscv.org/reference/brs/uefi.html#uefi

Signed-off-by: Atish Patra <atishp@meta.com>
---
Atish Patra (2):
      riscv: efi: Power off via EFI runtime services when available
      riscv: Restart via EFI runtime services when available

 arch/riscv/kernel/efi.c   | 5 +++++
 arch/riscv/kernel/reset.c | 7 +++++++
 2 files changed, 12 insertions(+)
---
base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
change-id: 20260615-efi_reset_shutdown-792040a83f18

Best regards,
-- 
Atish Patra <atishp@meta.com>

