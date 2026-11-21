Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795257499;
	b=PeimqByo7B1Mb5Mz0osMqdPOAfKBOABSfOpv9s3g15aYIbyNTyGzu6Av1kqXGRvcJDov
	 b8XKxns5rKTAHAvHT88r9NPxIoLjf3Z598aP2DLHEY6ivmc2TiCmanvyiCM9QR5HvWD9D
	 2QwO9gxsho81nIBgi2OL57dCXtzH8zov4fhTlLOKV5Fj4QCJcj9TJn0ccyxWQ0SdKy2WO
	 9XhI6UJp3/EtqBjk9OzYBWvFyHMuWpSHoFuNWBeSzmaPsfZbB3busdATj/bW3xqo0zaki
	 PJX+8TV1smOpHY0j96tfyVzwme8/iLoD8eW4pOq6d9r7hHC8Sg6qdQDA8V6WGm6UBug==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795257499;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=W/y323rtHI4A6G9EZ6Uz12b8FGYlp7r0b2dLPeWwIb8=;
	b=xMiiaMZAfrom5u4odgch3LZNNxOXcOSEVN7kFO6muhgHUmFxI1aNuEmgbJ0pKJhktw2t
	 afyrzI5TSVkHVgLi9Uswz6K+1OxbtVnl+hlCdeqHOoMy7I7j49Ukzb972O9vnNmnNLfga
	 rg0Kna2osp9zdlDmfYdesAo9FPxP1kpPuVBzPJnDkC0TC9Vx4JOWu2o5Hq8os2MxSCTMY
	 gWD+aQVgcYj3yKtVyT2hi5J0HGqLnGvuNyGcTeNfcnsnnfRvEdlY8iXbxrjJTCwY7urN2
	 LzMY6RWutohVx0Oo+80p0MQxYqIPxDRZHg9/RJOqIJ4PuiZsxMFs/XO9FYnQOAf4ZWQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dykeEpYc;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E637B606A338;
	Sat, 21 Nov 2026 10:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dykeEpYc
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795257498;
	b=bxf6eHYjI/MJW0pI/cloCI7/ShxDTqBblypsvWxvHfgYe/v+lCIqU0CyooLR9vROiIs3
	 9pnKl42WtM6YiVygldUvUjxk49L1r0ocV+r7Lt7nmgQF6u2Uuj/CC6OMCqHVzEzixkHBP
	 mlOeSwa66Uw/6Z42VfaoDvncGe9XnrkGaHu68fEyqQLR1b2FmkHAoF65AqDM3ZLmmDJO3
	 noKfOAi6GTlbdggOXe1K0+gWZhjW9Lnic0UJuWFoaLLhsiJHZ48RmblgQF9Odj+Dd69ng
	 D//cR916LnQ5Xec3tdvWUnbPZlv/3TfmLRFhgWejM6EWPlhl9BFt3ZdS8K9EPTujDkw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795257498;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=W/y323rtHI4A6G9EZ6Uz12b8FGYlp7r0b2dLPeWwIb8=;
	b=kccpPT/vOWQu1Qa/OSmZ06BvbY3xsROUcwDn69sgNfoxFTsF3DhK/5YCvB3KTiwRNVse
	 HdPWyK6FgAS+FgbTgLJ0fFv1onkMUCiGbs8sDluLXFny3EZxU2yajYvonRgQ3n+ZcyH91
	 iFo+FQ14TfNija3G8r13ECKsf7fMXezzSnET2gntQp2Y/dObMUl6g+UakzF7aM7BNdprm
	 rK/jes1SQXxf2Zs/qeYB0d/SB5w81DQktwPJihRS35JW28JxDAWQtJDEAh6vgdNpIpt6w
	 TdUom2tmhYL8qKknL2MgYmfWr2G0hb+yFXhdJGn5Eid3cIkls1MYS2IgucwBFX90mdg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 9065C1F000C4;
	Sat, 21 Nov 2026 10:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795257498;
	bh=W/y323rtHI4A6G9EZ6Uz12b8FGYlp7r0b2dLPeWwIb8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=dykeEpYcROTO59DQEUAkvm+1W5L4T2W957LzpyD79COQ8FYmQvk2WAY1uQJCTDoq5
	 Gu8jGvFqsK3pJHEh4oDGzv1CoHVAJIgRD+utEXQkgRFAPhjiiOImXakY5WS+x8nudX
	 x8smwr8dz1lLYpcm0em4sVbZ/WJZ6hL7uCpkKh98jeENBELfRSDNIHlcTdqovUMeEQ
	 Hw0uV4sB9ZOjJk6rXupSVAZlo43BE1klae57Rhq05LPVFkWUmptyo+mbUj8m+NDeGz
	 VyZ6fSf9Q0Qw6Rm4AjHl1c+amIw5V56vvdEbRwGDTFlXzLsKonK9TVQTobA1epTRGo
	 NINuzfwg6jsGQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 155EC4BBE3;
	Sat, 21 Nov 2026 10:38:17 +0000 (UTC)
From: Han Gao via B4 Relay <devnull+gaohan.iscas.ac.cn@kernel.org>
Date: Sat, 21 Nov 2026 18:38:07 +0800
Subject: [PATCH 1/2] riscv: efi: Map runtime MMIO with device attributes
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
Message-Id: <20261121-b4-sg2042-efi-rtc-v1-1-19898b8ad497@iscas.ac.cn>
References: <20261121-b4-sg2042-efi-rtc-v1-0-19898b8ad497@iscas.ac.cn>
In-Reply-To: <20261121-b4-sg2042-efi-rtc-v1-0-19898b8ad497@iscas.ac.cn>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
 Atish Patra <atish.patra@linux.dev>, Stephen Boyd <sboyd@kernel.org>, 
 Brian Masney <bmasney+clk@redhat.com>, 
 Jerome Brunet <jbrunet+clk@baylibre.com>, Chen Wang <chen.wang@linux.dev>, 
 Inochi Amaoto <inochiama@gmail.com>
Cc: Han Gao <rabenda.cn@gmail.com>, linux-efi@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-clk@vger.kernel.org, sophgo@lists.linux.dev, 
 Han Gao <gaohan@iscas.ac.cn>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795257496; l=1030;
 i=gaohan@iscas.ac.cn; s=20261021; h=from:subject:message-id;
 bh=AXs3CmUyHq0DbOalkM59cymNHEWwCflCrFagmnUXH40=;
 b=+R7iok8HWxtWVdFYvjuL61Ut91D/mbpDWKM53jRhVd4qqn7/sjzLv+Snse+8aZgLqEHJOOeid
 xXeqEtr/y3EDSWZSeiif9VMkcf+BUQn8NS0Qrt/IbRR23abw8rzSlfq
X-Developer-Key: i=gaohan@iscas.ac.cn; a=ed25519;
 pk=J8WHEK3filS86QaCaIHDGafqhxKyQ4K7+vFgRirTIiY=
X-Endpoint-Received: by B4 Relay for gaohan@iscas.ac.cn/20261021 with
 auth_id=1262
X-Original-From: Han Gao <gaohan@iscas.ac.cn>
Reply-To: gaohan@iscas.ac.cn
Content-Transfer-Encoding: 7bit

From: Han Gao <gaohan@iscas.ac.cn>

EFI_MEMORY_MAPPED_IO regions are mapped with PAGE_KERNEL, so device
registers end up mapped as normal memory.

On Milk-V Pioneer, GetTime() reads the clock controller registers and
faults:

  Oops - load access fault [#1]
  Workqueue: efi_runtime efi_call_rts
  status: 0000000200000120 badaddr: 0000007030012000 cause: 0000000000000005

Use PAGE_KERNEL_IO for these regions.

Fixes: b91540d52a08 ("RISC-V: Add EFI runtime services")
Signed-off-by: Han Gao <gaohan@iscas.ac.cn>
---
 arch/riscv/kernel/efi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/efi.c b/arch/riscv/kernel/efi.c
index 2d3cc57b4535..11e85d0ebc91 100644
--- a/arch/riscv/kernel/efi.c
+++ b/arch/riscv/kernel/efi.c
@@ -22,7 +22,7 @@ static __init pgprot_t efimem_to_pgprot_map(efi_memory_desc_t *md)
 	u32 type = md->type;
 
 	if (type == EFI_MEMORY_MAPPED_IO)
-		return PAGE_KERNEL;
+		return PAGE_KERNEL_IO;
 
 	/* R-- */
 	if ((attr & (EFI_MEMORY_XP | EFI_MEMORY_RO)) ==

-- 
2.55.0


