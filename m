Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793571362;
	b=wBpL0o2qBEvZPND2iRs5ecw0ka+hhZozI1NFC5KMsomclDHgmC4vpEITK+VPq8Hl8GzV
	 /sHE0pHdd13sZZ5X/F8sFdHBjAiKgDHztZhGeHfNM2DTTREnYieaVMAQz2Fs9UaQTOp9d
	 HyNpfGiHb5+dFDLlhlOotGvDEcFJ3bLdFGr0Y8Jm8UhWCtbSrihRIUHdqMuwfQ9s4G3HG
	 2BytculgquSPL52/LR0pM+CchqKOZLtKSrZYwyY4SpprQ4blz94rxGLyXwLZpECQBWMBy
	 AkrI5qHeNk37qZ/Hg8fu4NazzaJnut0dCLiLhXa2UvCafHL3DfCtqSjUSjeUVWVmfuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793571362;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=/L1K5/K20Lylg3Y8uBVzdGE1hVGy8dUc9P/IZwg+EOY=;
	b=u2HCXs+16XpuuA3VXdArIAmTlnuUvxzOijtNOb5NV94OT6ehklPDFPQMjI6mGD7CLs9t
	 1ED8N2DY2ra0hk8iwcttxyDcHCGp9fw3TpHWtdj4f2YT4AIH+IrIyfeHW2x26qZa+vvHE
	 jUAW/PkoNZuVD4X5La2hkE1kVNYKAMXDkBrsx9Jgg/h9eVgxCaWvbSKIEdTyiNdtpyedT
	 GnCHLZS5sI6iAyKU8dYIzoc2B75ppxkDDpp0CMCgtly53cyzRgMsyY4sD59clnPsPkNvb
	 zP7h5IV2P3BXd0Px8lQdH4Q/DvAcSHRvEVoibf/hrgnBI0bvdBgv6H6ulrZMRAg8APw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aQ9aTFbN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3709B60A2628;
	Sun,  1 Nov 2026 22:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aQ9aTFbN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 178411F00A15;
	Sun,  1 Nov 2026 22:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793571362;
	bh=/L1K5/K20Lylg3Y8uBVzdGE1hVGy8dUc9P/IZwg+EOY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=aQ9aTFbN6x7ouscVsLZNxTXAO5E8ItcKZ9dPsJi9yvOWb/a0tVFSzFxK6HBHwvwkR
	 qnGRH5hE04iqB7Hbx0soOLs60ndhW9fPRu1docmwvHJCPZ1sGH3aXo+aMYOMYvfS/m
	 gLRk+lBuqCl595dJR/qDiLKaO5xzK3h4Qld2hh9aTq14S9IhqhLCn8gScipgdXhxZ4
	 yz+eYaG3uHp5cGLm2P5HKV4lVfGfqkmRrBkNdAW5mFqV2BM1XB5v27eb8KPzOhQwgY
	 8+dN6TuAxSwtlFieAsFFjpYJH+0D2okoO4dGm6PQ3yCoJG1GIK5OBjtH+j2NcShuR6
	 6ScWRzm3UZjKQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 031C838003B8;
	Sun,  1 Nov 2026 22:16:02 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 00/22] kbuild: significantly speed up kernel builds
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <179357136054.2624073.6980997342883603672.git-patchwork-notify@kernel.org>
Date: Sun, 01 Nov 2026 22:16:00 +0000
References: <20260923-build-speedup-v4-0-73128809a4a4@kernel.org>
In-Reply-To: <20260923-build-speedup-v4-0-73128809a4a4@kernel.org>
To: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: linux-riscv@lists.infradead.org, torvalds@linux-foundation.org,
 nathan@kernel.org, nsc@kernel.org, ndesaulniers@google.com, morbo@google.com,
 justinstitt@google.com, masahiroy@kernel.org, legion@kernel.org,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, pjw@kernel.org, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, alex@ghiti.fr, arnd@arndb.de, catalin.marinas@arm.com,
 will@kernel.org, mark.rutland@arm.com, ardb@kernel.org,
 ilias.apalodimas@linaro.org, jpoimboe@kernel.org, peterz@infradead.org,
 ojeda@kernel.org, boqun@kernel.org, gary@garyguo.net,
 bjorn3_gh@protonmail.com, lossin@kernel.org, a.hindborg@kernel.org,
 aliceryhl@google.com, tmgross@umich.edu, dakr@kernel.org,
 daniel.almeida@collabora.com, tamird@kernel.org, acourbot@nvidia.com,
 work@onurozkan.dev, corbet@lwn.net, rdunlap@infradead.org, kees@kernel.org,
 gustavoars@kernel.org, linux-kbuild@vger.kernel.org,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
 linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org,
 linux-doc@vger.kernel.org, axboe@kernel.dk, linux-hardening@vger.kernel.org,
 petr.pavlu@suse.com, n.schier@fritz.com, manuelebnerli@mailbox.org

Hello:

This series was applied to riscv/linux.git (fixes)
by Nathan Chancellor <nathan@kernel.org>:

On Wed, 23 Sep 2026 18:17:49 +0100 you wrote:
> A typical kernel build consists of a frustratingly large amount of time
> spent stuck in single-threaded bottlenecks.
> 
> It turns out that there's a lot we can do about this and doing so
> significantly impacts kernel build times.
> 
> This series makes allmodconfig builds up to 36% faster, incremental builds
> up to ~70% faster, and noop builds up to ~90% faster.
> 
> [...]

Here is the summary with links:
  - [v4,01/22] kbuild: do not allocate .modinfo in vmlinux
    https://git.kernel.org/riscv/c/5fe4dd596641
  - [v4,02/22] kallsyms: index symbols by token to speed up table compression
    https://git.kernel.org/riscv/c/6f014bf46faf
  - [v4,03/22] kallsyms: output binary data to speed output and kallsyms assembly
    https://git.kernel.org/riscv/c/83da9f3197e5
  - [v4,04/22] sorttable: parse nm output correctly
    https://git.kernel.org/riscv/c/4719513c0fa2
  - [v4,05/22] kbuild: do not sort nm output where the order is irrelevant
    https://git.kernel.org/riscv/c/c2970d8b52d1
  - [v4,06/22] kbuild: only emit vmlinux relocations when required
    https://git.kernel.org/riscv/c/8050568e0a46
  - [v4,07/22] elf-parse: add section flags, symbol binding and mapping helpers
    https://git.kernel.org/riscv/c/5005f8043c09
  - [v4,08/22] kallsyms: reimplement mksysmap in C
    https://git.kernel.org/riscv/c/531980b4b17e
  - [v4,09/22] kbuild: calculate list, composite object state per object
    (no matching commit)
  - [v4,10/22] kbuild: implement and use depcheck to check dependency timestamps
    (no matching commit)
  - [v4,11/22] kbuild: move the toolchain checks into scripts/Kconfig.toolchain
    https://git.kernel.org/riscv/c/f85147b291e3
  - [v4,12/22] kbuild: avoid re-running compiler and linker probes
    https://git.kernel.org/riscv/c/454e00cf8ee5
  - [v4,13/22] modpost: cache section relocation mismatch state
    (no matching commit)
  - [v4,14/22] modpost: emit module descriptors as assembly
    (no matching commit)
  - [v4,15/22] kbuild: batch module finalisation
    (no matching commit)
  - [v4,16/22] objtool: do not hash DWARF relocations
    (no matching commit)
  - [v4,17/22] objtool: cache relocations, do less work, eliminate relocation hash
    (no matching commit)
  - [v4,18/22] objtool: size the instruction hash to the text
    (no matching commit)
  - [v4,19/22] objtool: decode instructions and resolve branch targets in parallel
    (no matching commit)
  - [v4,20/22] rust: make exports.o depend on the headers generated for it
    (no matching commit)
  - [v4,21/22] kbuild: build rust crates in parallel with the rest of the build
    (no matching commit)
  - [v4,22/22] kbuild: compress the kernel with pigz if available
    https://git.kernel.org/riscv/c/48ebe1cbbeb5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


