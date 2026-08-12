Received: from mta0.migadu.com (out-214.mta0.migadu.com [91.218.175.214])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD9A423EB0
	for <linux-efi@vger.kernel.org>; Wed, 12 Aug 2026 10:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.214
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786530353; cv=none; b=Pi86FGchNV7JsBNLRMYKfBC2qaFSovLmXBXUTBPIUI2Vn6sUtPqtfgO2K1thH+ZYp/ArFjQlTLCZbepp89fpCHgc07YpTYqFdsFTrflWLPH0SmzckMpbTSoyHrUJ1hOJM5B7q8GqYdJ8kNGujPzsPSJNEYBqrAwNOtPYFespmac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786530353; c=relaxed/simple;
	bh=q5MYyeCMd7o+EpTB61t9PlYNh3ovoXInblTdWVqkpxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jGwRAL/7WFU5fxqLnlwsGO0KOzI6O93VhYdwAqX0m1NEL5wG9asdEe4s58fTWR2+PnzeMkQDiIw0EAM6jZiy+ZPP9Ao496qSiQMexmB38TdTOrn6vGRl+gkdtA3MMVj1aObgUFSLULhOFBx/HHJwDBecLoZDZYZFn79CUdDnhoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aegPKZyQ; arc=none smtp.client-ip=91.218.175.214
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aegPKZyQ"
X-Envelope-To: linux-efi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=q5MYyeCMd7o+EpTB61t9PlYNh3ovoXInblTdWVqkpxw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786530344; v=1; x=1787135144;
 b=aegPKZyQC3yD3GZxw+b0myQk6Io7ghNqSOkWfkMn54+5yDFtxrH1J9lFWIqSSknnKlUQe/ZP
 lKNrVW1u2YhfDDbJ4mWtFWqvOubD7pELATkTOBYi0OInJFnEHXXF961jmSvhMf+i17O0Xt3EdF3
 /IR44tVNmdMzcz0b8GnF1d4Q=
X-Envelope-To: linux-efi@vger.kernel.org
Received: from localhost (223.70.160.239)
	by smtp.migadu.com with ESMTPS id 1b4a02814f740c27;
	Wed, 12 Aug 2026 10:25:44 +0000
X-Migadu-Scanner: mta11.migadu.com
Authentication-Results: mta11.migadu.com;
	none
From: George Guo <dongtai.guo@linux.dev>
To: pratyush@kernel.org
Cc: rppt@kernel.org,
	pasha.tatashin@soleen.com,
	shuah@kernel.org,
	ardb@kernel.org,
	chenhuacai@kernel.org,
	guodongtai@kylinos.cn,
	kernel@xen0n.name,
	graf@amazon.com,
	liukexin@kylinos.cn,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: Re: [PATCH v4 3/4] liveupdate: luo_session: include linux/mm.h for virt/phys translation
Date: Wed, 12 Aug 2026 18:25:32 +0800
Message-ID: <20260812102532.32673-1-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2vxzfr0l6fam.fsf@kernel.org>
References: <2vxzfr0l6fam.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Pratyush,

You are right: the current luo_session.c does not call virt_to_phys() or
phys_to_virt(). I failed to update the target of this fix when rebasing the
patch. The calls that trigger the current failure are in
kernel/liveupdate/kho_block.c. Sorry about that.

I also checked the include chain. asm/kfence.h is not included by this
translation unit. include/linux/slab.h does not include linux/kfence.h; that
inclusion is in the MM-private mm/slab.h. Moreover, asm/kfence.h itself
includes linux/kfence.h, which includes linux/mm.h, so
arch_kfence_init_pool() already has the required declarations.

The actual failure is:

  kernel/liveupdate/kho_block.c: In function 'kho_block_set_is_cyclic':
  ./arch/loongarch/include/asm/io.h:81:9: error: implicit declaration of function 'page_address'
  kernel/liveupdate/kho_block.c:210:16: note: in expansion of macro 'phys_to_virt'

The underlying issue is that LoongArch's CONFIG_KFENCE version of
phys_to_virt() uses page_address(), which is provided by linux/mm.h.

Your broader point about fixing this at the architecture level is valid. I
previously tried including linux/mm.h from asm/io.h [1], but that introduces a
circular include through:

  linux/slab.h -> linux/kasan.h -> asm/kasan.h -> asm/io.h
  -> linux/mm.h -> linux/slab.h

As reported by the kernel test robot [2], this leaves kfree() undeclared while
linux/mm.h is being parsed. A proper architecture-wide fix therefore requires
refactoring the address conversion helpers rather than adding that include to
asm/io.h.

For this series I will move the linux/mm.h include from luo_session.c to the
actual user, kho_block.c, and consider the architecture-wide cleanup
separately.

[1] https://lore.kernel.org/r/20260521063310.52926-1-dongtai.guo@linux.dev/
[2] https://lore.kernel.org/r/202605211925.DbDvQ6ii-lkp@intel.com/

Thanks,
George
