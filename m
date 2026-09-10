Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E175E59B661;
	Thu, 10 Sep 2026 19:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789066836; cv=none; b=Z6dINhMINVZpiX7PkWHiLCHhiRDciw55hG7/t0eTZLAiQhhy1zivyl2rvD/ZLsLdkYRwBl36yMM1GhfdoGP06wWfdVJ1sXbI6QQEILe6IcRo/U4qENzfjX808AGNUdHvIh3b4sFjr1fay4VyVaQk4/jpHHcRxRsXAaox/xJ6dBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789066836; c=relaxed/simple;
	bh=Jy4DXAG0SPTzwfacTiq4mR+y0f3/zcZiNxvzDjsPQNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f6y0v0wDiIb0sg25kWxnISxEdjwSzto/dOVCb8f4oxphMneomP6OuX4l3pt/pfwWevx2WU4kgYcD5xrobMzF4Ldj34evPDU4kQGXAJ6FZy27TFpXAEexzIpb33W+vxcE+t4PqaTDr14FCju9BsuTcdKcWaj6p+aRR2ZcU6/BVKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uo6MJqki; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uo6MJqki"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 156B11F0089D;
	Thu, 10 Sep 2026 19:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789066834;
	bh=adpUAXMLWlwls3uA0tHpuBpUMbpToZc2bhx+dPqey8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uo6MJqkiza5YQp8bmOAnZZ7Clc3G4MCqQgdKfnCBsPBugXp/06M0nPAXCsmC8NpwI
	 sXIcCQcWDcUKPDlMwiuyrKxmuiuj/of1ACyYxanR5qSG8LOCML5FtrJ7/T429DaAEq
	 GG8p/bKvaUOzzKlZEPxAneoX1o5Lz0hX6QrC4vPGMGXR55tnZVsvE81ITy6gcMjJ6w
	 TmQiePj48cDDpnvMR3NrRqPFm7ZLv+5rKuhm0n1HGvXyj7T7UNuJOoVs00l/jQxE1w
	 /8HTbwN9Hd38NoU2MTSbv3XawJfpUUhnYe9+RygWi0HdpC0JEr7CWkIpFzGtKzdaYQ
	 vCh3f4bpTQdnA==
From: Nicolas Schier <nsc@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Alexey Gladkov <legion@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	=?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Nicolas Schier <nsc@kernel.org>,
	linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 02/23] scripts/mksysmap: fix escape of '$' in the __pi_ pattern
Date: Thu, 10 Sep 2026 21:00:16 +0200
Message-ID: <178906667522.724141.8105989008359153155.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260908-build-speedup-v1-2-5dc1ac01672d@kernel.org>
References: <20260908-build-speedup-v1-2-5dc1ac01672d@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 08 Sep 2026 21:55:02 +0100, Lorenzo Stoakes (ARM) wrote:
> Commit b18b047002b7 ("kbuild: change scripts/mksysmap into sed script")
> converted scripts/mksysmap from a shell script to a sed script.
> 
> However an error was made - escaping of '$' required \\ escaping in shell
> but only \ in a sed script.
> 
> This was mostly corrected in commit 7a6c355b55c0 ("scripts/mksysmap: Fix
> escape chars '$'"), but this fix missed arm64 PIE namespace local symbols
> like __pi_$x and __pi_$d which appear in System.mapand /proc/kallsyms:
> 
> [...]

Applied to kbuild/linux.git (kbuild-fixes-unstable), thanks!

[02/23] scripts/mksysmap: fix escape of '$' in the __pi_ pattern
        https://git.kernel.org/kbuild/c/b99d1f50

Please look out for regression or issue reports or other follow up
comments, as they may result in the patch/series getting dropped,
reverted or modified (e.g. trailers).

The patch is applied to the kbuild-fixes-unstable branch and accepted
pending wider testing in linux-next and any post-commit review; it will
generally be moved to the kbuild-fixes branch within about a week if no
issues are found.

Best regards,
-- 
Nicolas

