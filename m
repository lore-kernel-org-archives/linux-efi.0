Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A65361670;
	Thu, 10 Sep 2026 19:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789066833; cv=none; b=gPLEmkigGFBZ3hnvfZ1HQ8g4Zm2DArjMTtYCOKTZ/HWZVTRR66bZQHnsoPsKamdwpe3vnV6p+eXhMQYjICdYFKc8FqB706LFnfIWNesu1C0Qn4wb/81nwsHA0ENMJAtOrH8Lx53kE59TdfLk3PnnQy1DRfBqZeKuiz3wegCGfUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789066833; c=relaxed/simple;
	bh=TqXpALvbDXvsA0sqSVnOHDQuA9LO48i8U28lTHA8Mb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BgEUOsfkh1t0NLprf+8G6NNHiO4aEtACRW/n09Jn0KDI6ZFYWAtR4YODybsOtzcmhva9ci2LDktUy1UME6+KMMeHf5Xq4NNAwvPVD36o9LfLQZU7MWbU71nMbIJ8X7YnL4kgSuBNURGwH8ULEY7P1dVh3BwvaDmsG5bNU57aqtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fpt2DW2D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fpt2DW2D"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C19AF1F008A7;
	Thu, 10 Sep 2026 19:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789066832;
	bh=qVLCzCol0ztHmPBF0fa8Jwjb86wBY4YsV5QLOxzKWYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fpt2DW2DYha1MqdROAQMJuWiFYGP2IXkY29JJawBo8RZ6Ij4EMIJzWGzzTj8Fz9if
	 fwvuecYFpKATLPy/E6JBQLSpVSg5fkTPerDXEl5QcC3WMZ1ExStoj3AKX2lAf3yBfy
	 ohO/V2c3DDBc7QRsB4WqARy0H46e1HQjPK9yvegAcLogsjQFUHTyjrCOze21/9RJcF
	 eoPJkrHBYKOtulGI2+dAKmgMwkVWoUWR1xs5RvxLdWYAvmSeC9oTy6tA5kmjNhu4aA
	 9IZ47udxuU4aDKE+9Q2nPRPOuTqaTza60/Br216MGndlCKBlzO1A9KjVvaklnLHWFb
	 rb81xbPcYsw1w==
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
Subject: Re: [PATCH 01/23] scripts/mksysmap: drop the MODULE_INFO() symbols from kallsyms
Date: Thu, 10 Sep 2026 21:00:15 +0200
Message-ID: <178906667516.724141.3737829890204628745.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260908-build-speedup-v1-1-5dc1ac01672d@kernel.org>
References: <20260908-build-speedup-v1-1-5dc1ac01672d@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 08 Sep 2026 21:55:01 +0100, Lorenzo Stoakes (ARM) wrote:
> Commit 3e86e4d74c04 ("kbuild: keep .modinfo section in vmlinux.unstripped")
> keeps .modinfo symbols out of System.map and kallsyms, which assumes unique
> IDs have a format like '__UNIQUE_ID_modinfo123'.
> 
> However, commit afb026b6d35c ("compiler: Tweak __UNIQUE_ID() naming"), sent
> in the same cycle, changes this to '__UNIQUE_ID_modinfo_123'.
> 
> [...]

Applied to kbuild/linux.git (kbuild-fixes-unstable), thanks!

[01/23] scripts/mksysmap: drop the MODULE_INFO() symbols from kallsyms
        https://git.kernel.org/kbuild/c/3e2276de

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

