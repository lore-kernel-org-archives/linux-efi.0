Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7710A345EA8;
	Tue, 15 Sep 2026 03:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789441924; cv=none; b=TzAOWFjPz8e6VlLMvxMne9dM0f3eWY4Fle/Ze9wI0YL9WptmWt3Cqa/FzPwu7wWjxl0zlDPSQfCGQfaffU8lFmBPAf+XLihhewHlXq2hLu30FlPaNQk20rVZfTyP/bGNt7P7Dhft2By89Qi9eKlgIuBeESmXO21c702SuEz7+Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789441924; c=relaxed/simple;
	bh=zFk6inz3gu2VK4pI7MShkLtjTmVDUGC92+2jSu+I8/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l7ILGsACPajJk1cEH7Xq75SuBZAAq2Gn07A56tEr/rg6GCq3OEChYk9l8P6WV453m9hir3f6gnj7QGh2NWa9z3ODnjBY6QELPikd3TsNwmDGBecvUKn5OOiMoyGPm9lOvHo6gXB52VG8DXnLZk0rN4qNHygNgSTtZ8Skt8xh8NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=IikgsJXk; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="IikgsJXk"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 7DF8F40E022C;
	Tue, 15 Sep 2026 03:12:00 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 91Xuh9jBpzDu; Tue, 15 Sep 2026 03:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1789441910; bh=fimw+9TQFsnvGc481ItRnoNUaZUoEvOYkuk/MMLKSgI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IikgsJXkeflG+e4IAQwhdeTY961rtirdNeliHwPOwaHZ4ZuEVjp3ilic4t5QefCyQ
	 2wikPb2Umd/qmJBmcGhqCTTQhRLFLqe6i6ymfrIaH8SFQ6vkgo2JWYoPNLWn2U/TO8
	 G+JapMmk37bSd2RnKEaYKYZXBQLBtuhBVy4qzdWja7KV5bk0bNnNZsOv5Ecou2jWTG
	 PWh3tmA7vqU+qmZ3dld7ksOdIeLbUnfwPhulP9wwej++3QBNea3acxB2jx70MkO0Pi
	 69wTMXhAvvJqCsN0B5lfh09/rBVQjDgpTq6R/hF4wAUphGpfCDUtMMNcffZ5F3jhgC
	 gF9CG+xrnq6rBLMGGujmN4SpOMrjZfnfqGj5lZIbc4/Vba63NCOElHQhobKRDXII50
	 Vhgc7wpZrsM4Y/Z2t7p2V6E+ZwUpgVcgquo396wp2f3dIZs90oaQbdWbRABu6a+LFQ
	 znqOPf0QhFM4bHLLcnmdC7YFAg44583vMlarXqEYRgyjPSXZzlA5fiNQF0qCkJj2GR
	 fcE7bYFuBlfWa7f7WdBIdmkChCAhZZeieC6Gkke+eCSX9+GYE70NV9Zn9nzA7wNCl0
	 YViFDcQJ9XhUpvy6rwEqgEr4ZosvYZwAqqJiYKm83NflrE33tCAsBcs6T2uENdPjLq
	 bGhXkhnzFrbGnLvwfGJWdP5I=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::e])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id EAA4340E0173;
	Tue, 15 Sep 2026 03:11:44 +0000 (UTC)
Date: Mon, 14 Sep 2026 20:11:41 -0700
From: Borislav Petkov <bp@alien8.de>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: Re: [PATCH 1/3] x86/tdx: Share tdx_panic() with the EFI stub
Message-ID: <20260915031141.GEaqi3bW7TGjblHLg1@fat_crate.local>
References: <20260914183745.37538-5-ardb@kernel.org>
 <20260914183745.37538-6-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260914183745.37538-6-ardb@kernel.org>

On Mon, Sep 14, 2026 at 08:37:47PM +0200, Ard Biesheuvel wrote:
> Move the implementation of tdx_panic() into the source file that is
> shared with the decompressor and the EFI stub.
> 
> Use memcpy() and strnlen() instead of strtomem_pad(), as the latter does
> not exist in the early boot code.
> 
> Note that __tdx_hypercall() may call __tdx_hypercall_failed() if the
> hypercall returns with an error (while it should never return to begin
> with). __tdx_hypercall_failed() calls the decompressor's error()
> routine, which prints a message and then loops forever.
> 
> When called from the EFI stub, this error() call may attempt to use port
> I/O to the default serial port rather than the TDX hypercalls which the
> decompressor uses normally to print diagnostics to the console, but this
> is fine: given that this situation only occurs after a catastrophic
> error, and a subsequent spurious return from tdx_panic(), whether
> error() uses port I/O or not is rather moot at that point, as long as it
> never returns.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/x86/coco/tdx/tdx-shared.c    | 35 ++++++++++++++++++++
>  arch/x86/coco/tdx/tdx.c           | 35 --------------------
>  arch/x86/include/asm/shared/tdx.h |  1 +
>  3 files changed, 36 insertions(+), 35 deletions(-)

Nah, that doesn't work:

ld: arch/x86/boot/compressed/tdx-shared.o: in function `tdx_panic':
tdx-shared.c:(.text+0x2a3): undefined reference to `__fortify_panic'
ld: tdx-shared.c:(.text+0x2b2): undefined reference to `__fortify_panic'
ld: arch/x86/boot/compressed/vmlinux: hidden symbol `__SCK__WARN_trap' isn't defined
ld: final link failed: bad value
make[3]: *** [arch/x86/boot/compressed/Makefile:117: arch/x86/boot/compressed/vmlinux] Error 1
make[2]: *** [arch/x86/boot/Makefile:96: arch/x86/boot/compressed/vmlinux] Error 2
make[1]: *** [arch/x86/Makefile:304: bzImage] Error 2
make: *** [Makefile:248: __sub-make] Error 2

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
