Received: from mta1.migadu.com (out-24.mta1.migadu.com [95.215.58.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E88480974
	for <linux-efi@vger.kernel.org>; Tue, 25 Aug 2026 14:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787669928; cv=none; b=Bwn8CjB/FREbtKB4dvJvBJH0ZbQREFj8PVg4uWFlcTotomRw9XoJegHo/P4hknEHcnhrcVc4nUA3O+kyHLxlHIbpZX1bKcs4K90P3rR/Y/061NLS3R9AFfgsUvDmJqDGAMzuqdmQ26qFcfxO5MbXgLF7gIgLyO5f0CX1c4Zqkv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787669928; c=relaxed/simple;
	bh=KnZDcMWRn7Zu+bLe9Q7f+sdXJDlECr099EG30SIifxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XtD9Qtj7/hIBE3zKMr+V3sFRaxTDpH/SnhP49QK0YlaUZI6dasRuHgAUWcPjnWtaQknyBFB5kezuHjeoh3TzRGWWn6lQshgdmesRvZ84naVIy12vPZksB0D7RZlYSyRfztx1IOn56N3lT/GgYLxW0OQHHokUy4wvgRA+vOAM2Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=F4kThCqO; arc=none smtp.client-ip=95.215.58.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="F4kThCqO"
X-Envelope-To: linux-efi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=KnZDcMWRn7Zu+bLe9Q7f+sdXJDlECr099EG30SIifxc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787669919; v=1; x=1788274719;
 b=F4kThCqOBaNlN/UYZuYK0Se+MWi+0EkemxC+9Yomr66iwmnsmUzAClw2RzORsPWPqAlaXbWU
 AT5qe6O34aMkIDXsezO//O0cSnODIxYPLi2d0JQpO6pMcWhC/TAgXoiisyFTf7Ditz/o55JgQ9U
 3B/Il/ZBfs/eO5cV/2BMcKz4=
X-Envelope-To: linux-efi@vger.kernel.org
Received: from localhost (223.70.159.239)
	by smtp.migadu.com with ESMTPS id e23b80d205abac2c;
	Tue, 25 Aug 2026 14:58:39 +0000
X-Mizu-Trace-ID: e23b80d205abac2c
X-Migadu-Flow: FLOW_OUT
From: George Guo <dongtai.guo@linux.dev>
To: chenhuacai@kernel.org
Cc: rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	shuah@kernel.org,
	ardb@kernel.org,
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
Subject: Re: [PATCH v4 4/4] selftests/kho: add LoongArch vmtest support
Date: Tue, 25 Aug 2026 22:58:33 +0800
Message-ID: <20260825145834.14244-1-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAAhV-H7XKFj93fSPcKAR9AR6Z4O28pC9va243hVccvPNOxH3qg@mail.gmail.com>
References: <CAAhV-H7XKFj93fSPcKAR9AR6Z4O28pC9va243hVccvPNOxH3qg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Huacai,

> You nearly answered nothing.
>
> Does your employer use different kernels for host and guest in KylinOS?

No. Host and guests run the same distro kernel in KylinOS, and guests
boot with edk2 firmware, so ACPI is delivered and i8042 bails out
through the PNP path. That is the normal case and it never panics.

I have since finished the investigation, also for the firmware-less
case. The same QEMU command with two kernels gives two different
results, and the difference is the kernel configuration:

- A distro kernel (CONFIG_PCI_HOST_GENERIC=y) maps the PCI_IOBASE I/O
  window through DT PCIe host enumeration, so even without firmware the
  i8042 probe reads garbage and fails cleanly ("No controller found").
- The selftest's minimal kernel maps nothing there, so the same read
  takes a page fault in i8042_flush() and panics before userspace.

So the panic needs three conditions together: a firmware-less boot,
SERIO_I8042=y (the Kconfig default), and no registered PIO range --
which is only the selftest-style kernel. I agree the mainline fix is
not necessary. For the selftest I will enable
CONFIG_PCI_HOST_GENERIC=y in loongarch.conf instead of disabling i8042,
so the selftest kernel stays closer to a normal one; the standalone
patch will not be sent.

Thanks,
George
