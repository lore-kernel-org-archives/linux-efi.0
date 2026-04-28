Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D10C25A2A2
	for <linux-efi@vger.kernel.org>; Tue, 28 Apr 2026 04:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777348950; cv=none; b=qZ45wB5omB2/nKtbmGgezh177WuXUCI0ryz3laSba1Ly7/7O8dX9TIEFkKegB/6mGclWEqwk/T572O61OZM9gmwFDD9TVs2sxF7cw7qnQ13DhjGLMkK3HFIoafbkqqw9oQC3NNi47Ku0oHkZYAKQbuRVxYybwu8YjmS4Rl0Ok3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777348950; c=relaxed/simple;
	bh=Hhiz7YXIt0m1DU+IaREY7k8p2d/aCJr7MC1uza7rXvo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z13SQNNFR4zwzoZAxLXdsodEFC6xNf5rDxEfYvNEnuX5RfmE7JO+vAhClkpzExFYaEIcHymbw7ggA0gB/2Zr5hVfFt616hOi/84Jis87Yu3Ee6kCjwjyFDa2Qjt45Fa0Xj+Hw/OhSPk6MJY0RZZOxvY6qbrrlI7y+m9UQfeP9D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b=TD4ak5lx; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b="TD4ak5lx"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2ab46931cf1so81249815ad.0
        for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 21:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20251104.gappssmtp.com; s=20251104; t=1777348947; x=1777953747; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bd1hgbTBVVdcDcX9ve5H/qCUgL6eJ7XhwuWBwZRmwfQ=;
        b=TD4ak5lxfxPdg+ktqkjeZCCmgE4LqBjqyWG5hV+L+WzTNeZ2PrbsCg6m/upZZf6DkH
         0itwVBPXc7VMLPfk9fP3JbpQK5NhR4fS45fvj4C3FVQ25kByPbdx8cfT49ao51ctEDZ1
         DJtZMtCI6yxp3nH4f90yb7hw6sfljVMexb+QecREziVSmB145KzD+1WQjoefGbX/YybJ
         jN4Poc9IhvWn9rG7+f5KOs3o3YU6ytXnP/IoQPIdVPBH/Ub27NbP6/qe/DwsjpW9b5Yw
         qL27/tOSW8byqMMvmEfJ6w/SyeMUmjmZlvohRgAdoNs9Uvbur1V6p/aDmVnzENxNu8bv
         i4fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777348947; x=1777953747;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bd1hgbTBVVdcDcX9ve5H/qCUgL6eJ7XhwuWBwZRmwfQ=;
        b=fLfhMx3cRIGNyoQ0Qqk8vvuESO/gKfrkChf34D6OE1ip2mKJb3Ma05dClt+2Zz3Dx3
         46W+aRQfLw82aVtVY2gmJEWHdPGnYyOJODp17mJa4E4uxQRbi0KcqCe7v9K8Nh/sK+pu
         7ZL+pxYNyOfRWKmXSSd9zJSnxtLtstv4+1UC+KqMzefTZN6WUwufHcPUrQuVwDqNTGWE
         QigkBMxrCAn+zoZyOPGLCTQsnHvutVprjmEygYWXqUWMBJ/2qzYHew+W9+pMEu46cTXy
         I2NMEoNXECkTfrzu2UZRfjLWd1wPMOV/DTvDP07pLd8wFxtYQ0iTGDyfZ7UtmJfrQgFK
         x6cg==
X-Forwarded-Encrypted: i=1; AFNElJ/SAhfsoF43RTB7/4bdwBXOMXf8/HcDrT97q4nIbHWfBjnPWPGB9Qz5ESPRnndgppJGM2WWvqSozuo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyL4Ic+0yju/NwFF//Zzesm7EoKzQyvIYx81fSi6K22QoCqPWNL
	cOojpotEX9ZSUpdPIJrRJ2Qkk7XbeQni7GT11HCBG9qp51BFXXWPbJl9ACxmEtz2Qmc=
X-Gm-Gg: AeBDieuUJOyJBeOARVtYPaGztpMWbIglfFBlBQ78FuzYXbv2ta+PrliZsLwmxgc6R8/
	VVJpeDI3bNYraGN5thvGcHdbl9yQeOQX+MGb3KYLDQ+4WXZ7oYX/QHgOvQp2jBY19RxCjYhdCe/
	M6yo/eHUp+T7qzRvjMmQNcpcCBQV6tusFzDdjONTRDpr0HcJmeMO5GeCl7kencD4a2yXKM1i/Dx
	4JvpD2MPrn0JF2ve2JxDDXxTBJWqla6zItsCX6dYtq/UBOCFMGlevpqa6V2+uX/0YPMoArd4uM0
	mdQ+sKyuBVX80odLeF0QuXcb8+O2M4w9pXhDsePlDLXzfnedX9Nw96NCJlSxf7LJQyNBGgRr+EH
	rhG9HnlWhRF+xTcxPxdR1n+LFz7In7eh9hIOS/E9meAm/oFjkcBaKnCkE+reDn0exi6wWRqvV8X
	6nmxmiIgDSEc3aThk3lI5fVxrHuqLL
X-Received: by 2002:a17:902:f542:b0:2b2:53f5:461f with SMTP id d9443c01a7336-2b97be3deeemr12458925ad.25.1777348947328;
        Mon, 27 Apr 2026 21:02:27 -0700 (PDT)
Received: from localhost ([2400:8902:e002:de33:3dbd:69cf:4a22:309])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b97ac8cd29sm10131365ad.61.2026.04.27.21.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 21:02:26 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: Huacai Chen <chenhuacai@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Lisa Robinson <lisa@bytefly.space>,
	loongarch@lists.linux.dev,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	WANG Rui <r@hev.cc>
Subject: [PATCH v2 0/2] LoongArch: Move KASLR to EFI stub to avoid initrd overlap
Date: Tue, 28 Apr 2026 12:01:57 +0800
Message-ID: <20260428040159.1065822-1-r@hev.cc>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes since [v1]:
  * Drop the patch "LoongArch: Allow rdtime_h() and rdtime_l() in 64-bit builds".
  * Use random_get_entropy() instead of rdtime_l().

This series addresses a potential overlap issue between the kernel
image and the initrd when KASLR is enabled.

In the normal boot flow, the bootloader is responsible for loading
both vmlinux and the initrd, and it can guarantee that the two do
not overlap in memory. However, this assumption only holds as long
as neither image changes its location afterwards.

The in-kernel KASLR implementation breaks that assumption. When the
initrd is placed close to the kernel image, randomizing the kernel
location at runtime may move it into the initrd region, leading to
memory corruption early during boot.

To fix this, this series moves the KASLR logic out of the kernel
proper and into the EFI stub. With this change, the final placement
of both the kernel image and the initrd is determined by the EFI
memory allocator. This ensures that the two allocations are
coordinated and cannot overlap.

Functionally, the kernel still supports KASLR as before, but the
randomization now happens before the kernel is entered, rather than
during early kernel relocation.

[v1]: https://lore.kernel.org/loongarch/20260427104721.47724-1-r@hev.cc

WANG Rui (2):
  efi/loongarch: Randomize kernel preferred address for KASLR
  LoongArch: Skip relocation-time KASLR if it has already been applied

 arch/loongarch/Kconfig                   |  2 +-
 arch/loongarch/include/asm/efi.h         |  4 +++-
 arch/loongarch/kernel/relocate.c         |  4 ++++
 drivers/firmware/efi/libstub/loongarch.c | 16 ++++++++++++++++
 4 files changed, 24 insertions(+), 2 deletions(-)

-- 
2.54.0

