Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=157.90.84.7
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794941079;
	b=ZvYXY9gSEUWHLMg7ferkZ6ueyBalgOjRnmbHDQjQ1efZP4EWIoiWF/u44QDMkO0oi6TK
	 yItdhxpP/RcnOM2v7FJ4twjy8nUi/90KVSIXyfpj3cqXvAoUZzBicR986UkbG/QsHi02V
	 +4x89tNbH82xCrqVfewCPrTkFgbafUPUglUHOhmmJMiyhuEh9ErQR6jmOeBurvWyUkfQ+
	 JgLH9OJBSnr5Iw3LFbp8mqUzvcuVJ14uYbHCuwwMmrjYq8EbPEXSns/XpkqTsfuKH+lL7
	 8V8HFf8F8MCiFhdpuXuWRrfIm2u04X9Jh9HFr37UsxzEKZ9KmURpmZMZAUNijMI8wiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794941079;
	h=DMARC-Filter:Received:DKIM-Signature:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=0jfqNSE5RORxN5ztSGlpnPPnLjFKbnPWKsd97ROo7v0=;
	b=HkWkzyR3+AAagdfdBZBiLfzYyVRGhgocOSNC0GJmFVZwPzANUJSQrIqkNPhmsqN3ZaYh
	 beMJa+M9iFqpacsZhSoTtRyo9yqDeQDCwmLS2g/VnOYhDxsMKtEpkA0vWmQTKPN4zsoj9
	 D6KZ5KJWQqGG86QrDRh+TndB1MkkAU+cgDRaK86NWwvPryiIlqIGv8KGjkFqIbDjCsuGg
	 UROqaJi/Xm6qNCt4RViTAaQCdXB92yODJqI7rNZrh/ggYg4Yb0SLYm9UUAvFhlrtTAZNN
	 +MPHZJE05tvnsKDHP6UIxCycMsnfOQfV+qWm3zFjqpaV9oCIgaLaJEBRJL+J3imuZhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=tuxedocomputers.com;
	spf=pass smtp.mailfrom=tuxedocomputers.com;
	dkim=pass header.d=tuxedocomputers.com header.i=@tuxedocomputers.com header.a=rsa-sha256 header.s=default header.b=NAUiZ5bK;
	arc=none smtp.remote-ip=157.90.84.7
Received: from mail.tuxedocomputers.com (mail.tuxedocomputers.com [157.90.84.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD72606A330;
	Tue, 17 Nov 2026 18:44:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2BD72606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tuxedocomputers.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuxedocomputers.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=tuxedocomputers.com header.i=@tuxedocomputers.com header.a=rsa-sha256 header.s=default header.b=NAUiZ5bK
Received: from [10.10.12.8] (business-024-134-105-141.24.134.pools.vodafone-ip.de [24.134.105.141])
	(Authenticated sender: wse@tuxedocomputers.com)
	by mail.tuxedocomputers.com (Postfix) with ESMTPSA id B2CEE2FC0057;
	Tue, 17 Nov 2026 19:44:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tuxedocomputers.com;
	s=default; t=1794941075;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0jfqNSE5RORxN5ztSGlpnPPnLjFKbnPWKsd97ROo7v0=;
	b=NAUiZ5bK4QZ+3axZHETZI+uOyTJKGxPUnGjdDN/RMd1cBUO/XwlOsOmxCvEBgeQZUIdhRP
	Jc+GSZXRw+EsJFw/gp5MS1s3c9z/9u0OGlQhb8+sP6wxLE2K+auG+AC2QR0q2zEOEXVwC8
	HI4V3IQBP2uBdhp/Sotec0JLMk1Kk3Y=
Authentication-Results: mail.tuxedocomputers.com;
	auth=pass smtp.auth=wse@tuxedocomputers.com smtp.mailfrom=wse@tuxedocomputers.com
Message-ID: <c6e794c9-bb12-43b5-a289-1b191f9f5a41@tuxedocomputers.com>
Date: Tue, 17 Nov 2026 19:44:31 +0100
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFT] Change E820 memory map handling
To: "Mario Limonciello (AMD)" <superm1@kernel.org>,
 mario.limonciello@amd.com, Florent DELAHAYE <kernelorg@undead.fr>,
 Michel-Ekimia <contact@ekimia.fr>, Konrad J Hambrick <kjhambrick@gmail.com>,
 =?UTF-8?Q?Benoit_Gr=C3=A9goire?= <benoitg@coeus.ca>,
 mumblingdrunkard <mumblingdrunkard@protonmail.com>,
 Matt Hansen <2lprbe78@duck.com>, Tilman Vaeth <tilman-vaeth@web.de>,
 Christian Homberg <Christianhomberg@gmail.com>,
 mccricardo <mcc.ricardo@gmail.com>, bnewell <bnewell@fullaware.com>,
 =?UTF-8?Q?Bernhard_=C3=9Cbelacker?= <bernhardu@mailbox.org>,
 Ton Gur <kvantorrr@mail.ru>, Alessandro <sandro.it@gmail.com>,
 Pedro Rodrigues <pedro.pfxr@gmail.com>, Amaury TC <amaurytc@gmail.com>,
 crysman <crysman@seznam.cz>, Moataz <Moataz.zakaria@gmail.com>,
 wilk <j.cubizolles@free.fr>, =?UTF-8?Q?Ilpo_J=C3=A4rvinen?=
 <ilpo.jarvinen@linux.intel.com>, Bradley Morgan <brads@mainlining.org>,
 Nikolas Joshua Britton <nbritton@exabit.io>,
 Doug Calobrisi <doug@calobrisi.com>, Helge Deller <deller@gmx.de>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Alexey Fomenko <alexey.fomenko@intel.com>, Eric Auger
 <eric.auger@redhat.com>, Maciej Grochowski <Maciej.Grochowski@sony.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-efi@vger.kernel.org
References: <20261110-superm1-genoa-mess-v1-0-bdcb3a6f2463@kernel.org>
Content-Language: en-US
From: Werner Sembach <wse@tuxedocomputers.com>
In-Reply-To: <20261110-superm1-genoa-mess-v1-0-bdcb3a6f2463@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

Am 10.11.26 um 19:50 schrieb Mario Limonciello (AMD):
> Commit 07eab0901ede ("efi/x86: Remove EfiMemoryMappedIO from E820 map")
> removes every EFI MMIO descriptor of at least 256KB from E820.  This
> makes host bridge space covered by those descriptors available for PCI
> BAR allocation and avoids maintaining quirks for every affected system.
>
> This helped a number of systems, but caused a regression on AMD Genoa
> which has a hole that is intentionally in this list and shouldn't be
> reassigned.
>
> Ilpo has produced a patch series[1] that changes the policy for reservations
> that may actually help this issue.  To validate whether it works we need
> to test removing the E820 reservation, which has a risk at causing problems
> with systems.
>
> On this RFT I've CCed everyone that I could find a public address for that
> commented on the original issue that lead to commit 07eab0901ede ("efi/x86:
> Remove EfiMemoryMappedIO from E820 map").
>
> I would like to ask that this branch be tested.
>
> https://git.kernel.org/pub/scm/linux/kernel/git/superm1/linux.git/log/?h=superm1/genoa-mess
>
> Here is the flow I would like to see:
>   1. Test 7.4-rc2 (vanilla - no changes please)
>   2. Test this branch (superm1/genoa-mess)
>   3. If this branch fails, please revert this commit from the branch and test again.
>      commit 35c9c60ea8c1c ("Revert "x86/PCI: Add E820 quirks for Clevo NL4XLU and Lenovo Yoga C940"")
>
> In all cases please check whether your original issue exists and comment if it does.
>
> I would like to know BOTH positive and negative testing with this series so we can have an idea
> if this approach is viable.

I noticed that you only removed the quirk from 2 devices: 
https://git.kernel.org/pub/scm/linux/kernel/git/superm1/linux.git/commit/?h=superm1/genoa-mess&id=35c9c60ea8c1c05631837f4094a09c51f00bec4b

Do you only want these 2 devices tested or for example also the X170KM-G?

Best regards,

Werner

>
> Link: https://lore.kernel.org/linux-pci/20261106134341.39493-1-ilpo.jarvinen@linux.intel.com/ [1]
> Cc: Florent DELAHAYE <kernelorg@undead.fr> # Clevo NL4XLU
> Cc: Michel-Ekimia <contact@ekimia.fr> # Clevo NL51CU2 (not currently quirked)
> Cc: Konrad J Hambrick <kjhambrick@gmail.com> # Clevo X170KM-G
> Cc: Werner Sembach <wse@tuxedocomputers.com> # Clevo X170KM-G
> Cc: Benoit Grégoire <benoitg@coeus.ca> # Lenovo Yoga C940-14IIL
> Cc: mumblingdrunkard <mumblingdrunkard@protonmail.com> # Lenovo Yoga C940-14IIL
> Cc: Matt Hansen <2lprbe78@duck.com> # Lenovo IdeaPad 3 15IIL05
> Cc: Tilman Vaeth <tilman-vaeth@web.de> # Lenovo IdeaPad 5 14IIL05
> Cc: Christian Homberg <Christianhomberg@gmail.com> # Lenovo IdeaPad 5 14IIL05 (81YH)
> Cc: mccricardo <mcc.ricardo@gmail.com> # Lenovo IdeaPad 5 14IIL05
> Cc: bnewell <bnewell@fullaware.com> # Lenovo IdeaPad Slim 7 14IIL05 (82A4)
> Cc: Bernhard Übelacker <bernhardu@mailbox.org> # Lenovo V15-IIL (82C500JUGE)
> Cc: Ton Gur <kvantorrr@mail.ru> # Lenovo IdeaPad 3 15IIL05
> Cc: Alessandro <sandro.it@gmail.com> # Lenovo IdeaPad 3 (exact model not posted)
> Cc: Pedro Rodrigues <pedro.pfxr@gmail.com> # Lenovo IdeaPad (exact model not posted)
> Cc: Amaury TC <amaurytc@gmail.com> # Lenovo BS145-15IIL (82HB)
> Cc: crysman <crysman@seznam.cz> # Acer Spin 5 SP513-54N
> Cc: Moataz <Moataz.zakaria@gmail.com> # Acer Spin 5 SP513-54N
> Cc: wilk <j.cubizolles@free.fr> # Acer Spin 5 SP513-54N
>
> These are the patches to be tested by checking that branch.
> ---
> Ilpo Järvinen (14):
>        resource: Mark free space assigned
>        parisc/PCI: Clean up resource debug print & use dynamic debug
>        PCI: Don't size or assign disabled BARs
>        PCI: Use __ffs64() for resource_size_t typed align
>        PCI: Prevent zero align from reaching __ffs64()
>        linux/log2.h: Add 64-bit roundup/down_pow_of_two_u64() variants
>        PCI: Derive aligns[] array size in a define
>        PCI: Honor alignment overrides
>        PCI: Place resources to either edge of the window
>        PCI: Separate align/raw size calculation from pbus_size_mem()
>        PCI: Calculate bridge window with optional sizes from scratch
>        PCI: Move size/align calculation fully into __pbus_size_mem()
>        PCI: Fix composite resource sizing
>        PCI: Add debug printing to window sizing
>
> Mario Limonciello (3):
>        x86/PCI: Add E820 quirks for Clevo NL4XLU and Lenovo Yoga C940
>        Revert "efi/x86: Remove EfiMemoryMappedIO from E820 map"
>        Revert "x86/PCI: Add E820 quirks for Clevo NL4XLU and Lenovo Yoga C940"
>
>   arch/alpha/kernel/pci.c          |   3 +-
>   arch/arm/kernel/bios32.c         |   5 +-
>   arch/m68k/kernel/pcibios.c       |   4 +-
>   arch/mips/pci/pci-generic.c      |   5 +-
>   arch/mips/pci/pci-legacy.c       |   5 +-
>   arch/parisc/kernel/pci.c         |  20 +--
>   arch/powerpc/kernel/pci-common.c |   5 +-
>   arch/sh/drivers/pci/pci.c        |   5 +-
>   arch/x86/pci/i386.c              |   5 +-
>   arch/x86/platform/efi/efi.c      |  45 -------
>   arch/xtensa/kernel/pci.c         |   5 +-
>   drivers/char/agp/intel-gtt.c     |   5 +-
>   drivers/gpu/drm/i915/i915_gmch.c |   5 +-
>   drivers/pci/pci.c                |   4 +-
>   drivers/pci/pci.h                |   6 +
>   drivers/pci/setup-bus.c          | 263 +++++++++++++++++++++++++--------------
>   drivers/pci/setup-res.c          | 246 ++++++++++++++++++++++++++++++++----
>   include/linux/log2.h             |  52 ++++++++
>   include/linux/pci.h              |  15 ++-
>   kernel/resource.c                |   3 +-
>   20 files changed, 510 insertions(+), 196 deletions(-)
> ---
> base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
> change-id: 20261110-superm1-genoa-mess-2195512e39e7
>
