Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794336671;
	b=yWzweht0RYheDWL64wFMqrRMcvYEtzQXMEx50r97f3B+dzgu0BrnIqLCKoAr7/x6/b0X
	 lTRMbY1RAgSZiTZlMO6mnTSC7YMRBs+Q5oIc7Foj38Em61lX2qYYM55O758NbQsFjJSfp
	 wKb8OyLYVvUzM8UYp/Kkwwu5nD9itW4ZnOJ971m5Puh3izoKsMFaUFPir+xs+Rda1NDJt
	 1MG6ruEkusMMrLpCiCUUaeilbLr3COwRcxtCIcJmgiQ2Qk8pEUjbEyKAhfp7+G/vUR+lk
	 U3qlu4oGtkde82LVDyZ2S0ZbUoOgabq7AJC5TWz6By30r+TQDdv3ynbLmoOWZlVsasg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794336671;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Type:X-Change-ID:X-Mailer:
	 Content-Transfer-Encoding;
	bh=1vfm4ZZaCnjKq2IqAi4z4l1jQumIZPUQ3s9gJu6Lb5Y=;
	b=PISxFRq5os2VpczNZDJ5IidNQcXUIOP4ZlzHiKMLt0dJYwG4fZ0SeOm0ybnSBx84B8Dr
	 HJZZxL6V7etmR22Pkf2rQrXR3ZVZ839LKfBC6U1PtdGl5f4ayhq1zpdWOeILkhBTIICN2
	 S70dnUen3TzvYruS6QseB0xviNgBgOaC1bA0UkNxbCcVaC8JLn1OGxlD/GGYoP+dtbnCb
	 gE7wSz2C6qQFMRsRYU9iu8WBhwlmGmNVPhiUH0xrJKPFLvqk4myLwetu44ZGD7ihGLYD1
	 2+n07N9N+Qg+7VHcPiDzHBgHfl1yTg5pOZ/JYZ3nSst25wTpJkn24Ze4p1pfBlRgl8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KfJszO94;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC918606A32A;
	Tue, 10 Nov 2026 18:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KfJszO94
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843861F0089F;
	Tue, 10 Nov 2026 18:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794336670;
	bh=1vfm4ZZaCnjKq2IqAi4z4l1jQumIZPUQ3s9gJu6Lb5Y=;
	h=From:To:Cc:Subject:Date;
	b=KfJszO94/qOIAMY9WRy5Oo6VZG6yFbceM2cOpNaPWLXDRoBWG6Lsm/imBu6xX7fOr
	 CcVy3akt6xk0+FJhPDIGg20aT+9eJISW59VFDruFocZJNOHs6hhVce4DBrFK016PMt
	 Id/J40wbaTdyaMcJu+6o9YRhBAgrWS2h05WWuJm41qrW2WHhMagc77Si+FmA12Thjf
	 a/jdWlWjjr0OJfuR3BYSsXQLbvDfdmtSLC8TWe8UJMlRlt1F47FH1QfW6ILfEoQfAz
	 XJcheTlWLMTxr+I0dc3lP3JRZwf9rv5gJFD5j33zIt6bnpocwMKXgAa69GQ4Vfuyt7
	 D6Uao3CQMBCkg==
From: "Mario Limonciello (AMD)" <superm1@kernel.org>
To: mario.limonciello@amd.com,
	Florent DELAHAYE <kernelorg@undead.fr>,
	Michel-Ekimia <contact@ekimia.fr>,
	Konrad J Hambrick <kjhambrick@gmail.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	=?utf-8?q?Benoit_Gr=C3=A9goire?= <benoitg@coeus.ca>,
	mumblingdrunkard <mumblingdrunkard@protonmail.com>,
	Matt Hansen <2lprbe78@duck.com>,
	Tilman Vaeth <tilman-vaeth@web.de>,
	Christian Homberg <Christianhomberg@gmail.com>,
	mccricardo <mcc.ricardo@gmail.com>,
	bnewell <bnewell@fullaware.com>,
	=?utf-8?q?Bernhard_=C3=9Cbelacker?= <bernhardu@mailbox.org>,
	Ton Gur <kvantorrr@mail.ru>,
	Alessandro <sandro.it@gmail.com>,
	Pedro Rodrigues <pedro.pfxr@gmail.com>,
	Amaury TC <amaurytc@gmail.com>,
	crysman <crysman@seznam.cz>,
	Moataz <Moataz.zakaria@gmail.com>,
	wilk <j.cubizolles@free.fr>,
	=?utf-8?q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bradley Morgan <brads@mainlining.org>,
	Nikolas Joshua Britton <nbritton@exabit.io>,
	Doug Calobrisi <doug@calobrisi.com>,
	Helge Deller <deller@gmx.de>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Alexey Fomenko <alexey.fomenko@intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Maciej Grochowski <Maciej.Grochowski@sony.com>
Cc: "Mario Limonciello (AMD)" <superm1@kernel.org>,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: [RFT] Change E820 memory map handling
Date: Tue, 10 Nov 2026 12:50:54 -0600
Message-ID: <20261110-superm1-genoa-mess-v1-0-bdcb3a6f2463@kernel.org>
X-Mailer: git-send-email 2.53.0
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
X-Change-ID: 20261110-superm1-genoa-mess-2195512e39e7
X-Mailer: b4 0.16.0
Content-Transfer-Encoding: 8bit

Commit 07eab0901ede ("efi/x86: Remove EfiMemoryMappedIO from E820 map")
removes every EFI MMIO descriptor of at least 256KB from E820.  This
makes host bridge space covered by those descriptors available for PCI
BAR allocation and avoids maintaining quirks for every affected system.

This helped a number of systems, but caused a regression on AMD Genoa
which has a hole that is intentionally in this list and shouldn't be
reassigned.

Ilpo has produced a patch series[1] that changes the policy for reservations
that may actually help this issue.  To validate whether it works we need
to test removing the E820 reservation, which has a risk at causing problems
with systems.

On this RFT I've CCed everyone that I could find a public address for that
commented on the original issue that lead to commit 07eab0901ede ("efi/x86:
Remove EfiMemoryMappedIO from E820 map").

I would like to ask that this branch be tested.

https://git.kernel.org/pub/scm/linux/kernel/git/superm1/linux.git/log/?h=superm1/genoa-mess

Here is the flow I would like to see:
 1. Test 7.4-rc2 (vanilla - no changes please)
 2. Test this branch (superm1/genoa-mess)
 3. If this branch fails, please revert this commit from the branch and test again.
    commit 35c9c60ea8c1c ("Revert "x86/PCI: Add E820 quirks for Clevo NL4XLU and Lenovo Yoga C940"")

In all cases please check whether your original issue exists and comment if it does.

I would like to know BOTH positive and negative testing with this series so we can have an idea
if this approach is viable.

Link: https://lore.kernel.org/linux-pci/20261106134341.39493-1-ilpo.jarvinen@linux.intel.com/ [1]
Cc: Florent DELAHAYE <kernelorg@undead.fr> # Clevo NL4XLU
Cc: Michel-Ekimia <contact@ekimia.fr> # Clevo NL51CU2 (not currently quirked)
Cc: Konrad J Hambrick <kjhambrick@gmail.com> # Clevo X170KM-G
Cc: Werner Sembach <wse@tuxedocomputers.com> # Clevo X170KM-G
Cc: Benoit Grégoire <benoitg@coeus.ca> # Lenovo Yoga C940-14IIL
Cc: mumblingdrunkard <mumblingdrunkard@protonmail.com> # Lenovo Yoga C940-14IIL
Cc: Matt Hansen <2lprbe78@duck.com> # Lenovo IdeaPad 3 15IIL05
Cc: Tilman Vaeth <tilman-vaeth@web.de> # Lenovo IdeaPad 5 14IIL05
Cc: Christian Homberg <Christianhomberg@gmail.com> # Lenovo IdeaPad 5 14IIL05 (81YH)
Cc: mccricardo <mcc.ricardo@gmail.com> # Lenovo IdeaPad 5 14IIL05
Cc: bnewell <bnewell@fullaware.com> # Lenovo IdeaPad Slim 7 14IIL05 (82A4)
Cc: Bernhard Übelacker <bernhardu@mailbox.org> # Lenovo V15-IIL (82C500JUGE)
Cc: Ton Gur <kvantorrr@mail.ru> # Lenovo IdeaPad 3 15IIL05
Cc: Alessandro <sandro.it@gmail.com> # Lenovo IdeaPad 3 (exact model not posted)
Cc: Pedro Rodrigues <pedro.pfxr@gmail.com> # Lenovo IdeaPad (exact model not posted)
Cc: Amaury TC <amaurytc@gmail.com> # Lenovo BS145-15IIL (82HB)
Cc: crysman <crysman@seznam.cz> # Acer Spin 5 SP513-54N
Cc: Moataz <Moataz.zakaria@gmail.com> # Acer Spin 5 SP513-54N
Cc: wilk <j.cubizolles@free.fr> # Acer Spin 5 SP513-54N

These are the patches to be tested by checking that branch.
---
Ilpo Järvinen (14):
      resource: Mark free space assigned
      parisc/PCI: Clean up resource debug print & use dynamic debug
      PCI: Don't size or assign disabled BARs
      PCI: Use __ffs64() for resource_size_t typed align
      PCI: Prevent zero align from reaching __ffs64()
      linux/log2.h: Add 64-bit roundup/down_pow_of_two_u64() variants
      PCI: Derive aligns[] array size in a define
      PCI: Honor alignment overrides
      PCI: Place resources to either edge of the window
      PCI: Separate align/raw size calculation from pbus_size_mem()
      PCI: Calculate bridge window with optional sizes from scratch
      PCI: Move size/align calculation fully into __pbus_size_mem()
      PCI: Fix composite resource sizing
      PCI: Add debug printing to window sizing

Mario Limonciello (3):
      x86/PCI: Add E820 quirks for Clevo NL4XLU and Lenovo Yoga C940
      Revert "efi/x86: Remove EfiMemoryMappedIO from E820 map"
      Revert "x86/PCI: Add E820 quirks for Clevo NL4XLU and Lenovo Yoga C940"

 arch/alpha/kernel/pci.c          |   3 +-
 arch/arm/kernel/bios32.c         |   5 +-
 arch/m68k/kernel/pcibios.c       |   4 +-
 arch/mips/pci/pci-generic.c      |   5 +-
 arch/mips/pci/pci-legacy.c       |   5 +-
 arch/parisc/kernel/pci.c         |  20 +--
 arch/powerpc/kernel/pci-common.c |   5 +-
 arch/sh/drivers/pci/pci.c        |   5 +-
 arch/x86/pci/i386.c              |   5 +-
 arch/x86/platform/efi/efi.c      |  45 -------
 arch/xtensa/kernel/pci.c         |   5 +-
 drivers/char/agp/intel-gtt.c     |   5 +-
 drivers/gpu/drm/i915/i915_gmch.c |   5 +-
 drivers/pci/pci.c                |   4 +-
 drivers/pci/pci.h                |   6 +
 drivers/pci/setup-bus.c          | 263 +++++++++++++++++++++++++--------------
 drivers/pci/setup-res.c          | 246 ++++++++++++++++++++++++++++++++----
 include/linux/log2.h             |  52 ++++++++
 include/linux/pci.h              |  15 ++-
 kernel/resource.c                |   3 +-
 20 files changed, 510 insertions(+), 196 deletions(-)
---
base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
change-id: 20261110-superm1-genoa-mess-2195512e39e7

