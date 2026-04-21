Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394D4359A66
	for <linux-efi@vger.kernel.org>; Tue, 21 Apr 2026 09:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776763513; cv=none; b=MJmImIaXRMd59smTgGI1iVB8Q1BhPhDtz3m6jHPXq4YgRv0Jmbiyis+K3hguPZD3mA9EZykaanJ8qBMW8wOxe679oWcDzbrT1yoGoqyr1Wq3b4cU7NPsq8mxq4Bg0m7FaLG7sMbWgnYScfjdZboJw6QG3iRJd9nlRwfnPfiHlmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776763513; c=relaxed/simple;
	bh=nJwiGFl4TjH5C8Mw3Fm+cxT0UutDEaY57xKcpUJmn84=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=MTz44ZogII4gxlfLssfhPoARKLN/TDotFgRoLOQ+ItKGt9nYVf9Dbj4o7ekDnF0A8E+fRHAxEcf/9bVkq/AHecy91qP0OZoBzMUTBuD2GTMoEZ0SRJinrbvEmjjTFnsvHWfO1+mB1iOwb8xiNM727m4hji6Oxq+L1WTAAolfknQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=i6GdwEp0; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="i6GdwEp0"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2b45cb89f7eso28890615ad.0
        for <linux-efi@vger.kernel.org>; Tue, 21 Apr 2026 02:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776763510; x=1777368310; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=TYfKwapVQTASKc189TeQO1FVNxhT1wLsuvJTPgVY/gk=;
        b=i6GdwEp0vkUVEscd8KRSDlOwXOjiFOF2TFeYYt5FO74sRtwInYg6o6LmbhrhF/d2XW
         ytf0l7BycADWJ97Cs5AuPLQTp0GJaX9Fgtgz8lSDrkoAGIecUe1RTzuHl0s/gG+yOohh
         sgjSYikWwR31bJNO3ivBjXF6DGfT0Mg+ejNl3pQRDUFTnt5adQh5ehqiIytsfwIUJroI
         nMjoYIYa/XDLYI+uZQKklKWzBhGfNksYLIybZw/JRwL0K/87J0sjOAfV392KsVbfTGQV
         L9nXbwokqZFrkI9TAF1Tu6m4RLy/PwMtGjb3v51Icy5LH/r4sRTbe3cV2G1B2xVC2gij
         nhsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776763510; x=1777368310;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TYfKwapVQTASKc189TeQO1FVNxhT1wLsuvJTPgVY/gk=;
        b=XilhBHe/CECRXHwH5TUCoJ2pxPhxFbI1xM/4DA9E9z1dZ5+hkcxuMMzX2KYNSNzk8j
         Ojh4/ywYAV7zGE7jYd+1Z84Zc1V4WsNXFqB97lw7jCKiqw3xFSuD1h3RbBeZpbkOYRS0
         cWPuhEKj4KBZTL7INNKepOn7nb8fvQugh2NygA24yA5RhjfGRoi1eyWwvAZ0mHa+J7hf
         3HcCC5Fzegu1TNLvU8VF1rRdSi0R4bxMBwuX1WPe87FjjMnQ2WQ+LW0PIplcNMWitnO+
         krXjk9k46meMISnF1PttXmmLKev3rYOfBB5VkUi6uugUeVeKGxGhULpx4cZu6BGNIvJ4
         P9bQ==
X-Forwarded-Encrypted: i=1; AFNElJ+FM/1Cesx+p9d/pFUudEMF8hFDvKgsMy6CCDPGJaf3pABpYOFBQZ5u20Sm5TuDScHCXhSQq6P/9+c=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVVvkxXPBKUgGB8Hxs8L3NgTQXxPAIkbyRF53Ln0T093+guyZo
	6vrPJSskdb2b9/IufPFiBhPXFJyUXM6P0jyoPKzEmU/QiR+Aex4Yk+yUiEuaivKv1tY=
X-Gm-Gg: AeBDiesx6TvxyajSMG2PFsJVzBpTih6k7FD1C9FSY4OwvmnC7ZSmz6vv8b+N0xfhJAd
	tIorPpsOPf1MuRzqs8sZwycLS2Qic1SNQehws4nNn4Ct+/YlDV8uzsCaz6/3tKvlI2S4Jhgcn4S
	rOVcyLgIeaHdtlV+jwDeuoBFFlZDke4MyXcFd96UaRG0XRHNwliW1G7b5m/4AFyWzgmxh6HQ/NB
	LmZcKO8iJ8utdkB/5d/YNM68rZbE4OE5mEQej+iRkOfPLRYeEqe4sk+E7FN2T5SpKoqIJN0Ih8i
	DLV1N+0kpAcgYq/Oot5IqOpeNlfSIrl2lgHz1PKubI+JAlYsZ0KlxEjXH6B7S/s1dCtZTS0eCUv
	FPU2g6/V7swFNfpq22PglYqNBrKV2X1lHi8wNSp01SKq83BIjXR1L+uI/y97gBwelW2D5XUgHt+
	B3Ft1oWyMeSddo2GNs8DhDrTpDGSS7+R2Nr9JPyat9I+AcyUHzLIZp42OJRZtc26NCth6+BVaey
	RkWF4A=
X-Received: by 2002:a17:903:1ac8:b0:2b0:70c8:ccea with SMTP id d9443c01a7336-2b5f9eaeba2mr175964215ad.13.1776763510266;
        Tue, 21 Apr 2026 02:25:10 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fa9ff39csm131965105ad.4.2026.04.21.02.25.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 21 Apr 2026 02:25:09 -0700 (PDT)
From: Yunhui Cui <cuiyunhui@bytedance.com>
To: akpm@linux-foundation.org,
	alex@ghiti.fr,
	andrew+kernel@donnellan.id.au,
	andreyknvl@gmail.com,
	anup@brainfault.org,
	aou@eecs.berkeley.edu,
	apopple@nvidia.com,
	ardb@kernel.org,
	atish.patra@linux.dev,
	baolin.wang@linux.alibaba.com,
	cuiyunhui@bytedance.com,
	david@kernel.org,
	debug@rivosinc.com,
	djordje.todorovic@htecgroup.com,
	dvyukov@google.com,
	elver@google.com,
	glider@google.com,
	ilias.apalodimas@linaro.org,
	junhui.liu@pigmoral.tech,
	kasan-dev@googlegroups.com,
	kees@kernel.org,
	kevin.brodsky@arm.com,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	liu.xuemei1@zte.com.cn,
	ljs@kernel.org,
	namcao@linutronix.de,
	osalvador@suse.de,
	palmer@dabbelt.com,
	pjw@kernel.org,
	rmclure@linux.ibm.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryabinin.a.a@gmail.com,
	surenb@google.com,
	vincenzo.frascino@arm.com,
	vishal.moola@gmail.com,
	wangruikang@iscas.ac.cn,
	zhangchunyan@iscas.ac.cn
Subject: [PATCH v1 0/7] riscv: add Svnapot-based contiguous PTE support
Date: Tue, 21 Apr 2026 17:24:50 +0800
Message-Id: <20260421092457.37649-1-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

First of all, thanks to Ryan Roberts for the work on mTHP and
Contiguous PTE support on arm64. That work provides a very useful
reference for reducing page fault overhead and TLB pressure for
large but still PTE-mapped memory ranges.

This series adds Svnapot-based contiguous PTE support for RISC-V.

To achieve similar benefits on RISC-V, this series introduces a
Contiguous-PTE-like mechanism built on top of the Svnapot extension.
The intent is to preserve the core-MM PTE semantics while allowing
RISC-V to transparently fold eligible base-page mappings into
Svnapot-encoded contiguous mappings when possible.

The series splits the low-level raw PTE helpers from the public
core-MM-facing PTE helpers, so that:

-the __xxx helpers expose the raw hardware PTE encoding,
-the xxx helpers provide the semantic view expected by core MM,
-and Svnapot-aware handling is centralized in the public wrapper layer.

Performance results:

-Compared with the native 4K base-page setup, the mTHP + PTE fold
scheme improves overall SPEC CPU performance by about 2%.
-The native 4K page setup shows higher memory access latency, and its
memory read latency is about 12% higher than this scheme.

Yunhui Cui (7):
  riscv: mm: split raw and public PTE helpers
  riscv/kvm: use raw PTE helpers for G-stage leaf PTEs
  riscv: mm: add Svnapot-aware contiguous PTE wrappers
  riscv: hugetlb: switch NAPOT mappings to raw PTE helpers
  riscv: add contiguous PTE range clearing helpers
  riscv: batch write-protect contiguous PTE ranges
  riscv: add Svnapot-aware pte_batch_hint support

 arch/riscv/include/asm/kfence.h  |   4 +-
 arch/riscv/include/asm/pgtable.h | 455 +++++++++++++++++++++-
 arch/riscv/kernel/efi.c          |   4 +-
 arch/riscv/kernel/hibernate.c    |   2 +-
 arch/riscv/kvm/gstage.c          |  48 +--
 arch/riscv/kvm/mmu.c             |   4 +-
 arch/riscv/mm/Makefile           |   1 +
 arch/riscv/mm/contpte.c          | 650 +++++++++++++++++++++++++++++++
 arch/riscv/mm/fault.c            |   4 +-
 arch/riscv/mm/hugetlbpage.c      |  55 ++-
 arch/riscv/mm/init.c             |   8 +-
 arch/riscv/mm/kasan_init.c       |  14 +-
 arch/riscv/mm/pageattr.c         |  12 +-
 arch/riscv/mm/pgtable.c          |  58 ++-
 14 files changed, 1222 insertions(+), 97 deletions(-)
 create mode 100644 arch/riscv/mm/contpte.c

-- 
2.39.5

