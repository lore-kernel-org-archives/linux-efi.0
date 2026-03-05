Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F4F37D123;
	Thu,  5 Mar 2026 10:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772706374; cv=none; b=ZiUqeWAWb5PwkmIx8IJGtA3NR3QvUm2L565rWtI3yXJO8pENd0dnBarElWCsoYdfQEbtZ0LgxsbWoHYr6DA5eYp8kENKEjtE8I/glcfYC6j9041E1mDOVwqNKtpw17IWUsoWvCYQpnNcUSRuwuElaZY1d3D/4G6MOOoZEOC4YyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772706374; c=relaxed/simple;
	bh=yN3P+dfcabxAsputqX2/k7Zr9ICjFZ2rKGQwcJ77ONY=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=USJ3H0UivSsW5wDpLJy1g8vDI7I4/lIvobauXeFSCdxwiT5FGeGYlNphFWpnfibZhaRlF3dNgnpOedyMgc9NpA1ZIbbnUVuASFNbey3nf+kzc79gDL8XdLQGiIy8EBMZlgBKDUPLvF5BT+fCC8OEoIteysxpSIjWypg96wJnmFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FJavDVBx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FJavDVBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CCBDC116C6;
	Thu,  5 Mar 2026 10:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772706371;
	bh=yN3P+dfcabxAsputqX2/k7Zr9ICjFZ2rKGQwcJ77ONY=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date:From;
	b=FJavDVBxKwwmbEjYfckKeUlfCtzMeXpgCqvyUVluMmj92x2uHE5fETjD/KdfhaGmp
	 W69DhQVjX5f2Bggj687uC072S8pKdkl3r/K6fopCoZrrggIIHKq3IbBQJ0QzlZEM6i
	 d01z8oNDXHqv0upfXsyrDrSO7Awi8f8Mlk0kk130h9/4SGOrW8Y3c+7jlDXl+pVIZd
	 FxSD53/g5n9tZ/N+BaDWwwgNi/X/RhTMQ4Dh1YEyXCNDNiRLogolhRakJO+fZHVXNo
	 nZt8YOThjrFK9zPioKTSC0vKnSb34kxK+cW0/V7t8/lmbA2N1l+7otpwsfJAa1YMQK
	 X6BJSOlBpVPQA==
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 2/2] kbuild: Use '-fms-anonymous-structs' if it is
 available
From: Nicolas Schier <nsc@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nsc@kernel.org>, 
 Linus Torvalds <torvalds@linux-foundation.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 Kees Cook <kees@kernel.org>, linux-kbuild@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 loongarch@lists.linux.dev, linux-parisc@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
 linux-efi@vger.kernel.org, llvm@lists.linux.dev
In-Reply-To: <20260223-fms-anonymous-structs-v1-2-8ee406d3c36c@kernel.org>
References: <20260223-fms-anonymous-structs-v1-0-8ee406d3c36c@kernel.org>
 <20260223-fms-anonymous-structs-v1-2-8ee406d3c36c@kernel.org>
Date: Thu, 05 Mar 2026 11:25:55 +0100
Message-Id: <177270635550.104478.3620211579416140490@derry.ads.avm.de>
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=715; i=nsc@kernel.org;
 s=20250924; h=from:subject:message-id;
 bh=yN3P+dfcabxAsputqX2/k7Zr9ICjFZ2rKGQwcJ77ONY=;
 b=owEBbQKS/ZANAwAKAQdSCnAWJhJpAcsmYgBpqVo1djCIKUbWSXBEArtpABeIBK+n1YrI8VPfM
 6rRmf720ZWJAjMEAAEKAB0WIQSHQTenhzckp4G+wsYHUgpwFiYSaQUCaalaNQAKCRAHUgpwFiYS
 acK1D/92cHSfhwuIxsSSGbf7AoMStLJHAyJ9ekSE905rEEJRKebqeuxxJKFxr9E/3hV9eT4T1Mf
 Zy0/lwNJvAl0P+2Npsjg3RW/VvZGx3HkeTGOIFKFa7cu/sJAK7CDAG1uksbjMoYrxkL0EQbWWvx
 o5AnNIPZiGrG4LbGLZXw9+m2OZ8nvR0fwwDn/wCe1qlz3uv/Lt5jZZCSRzYvYdOqX98An9l0IxY
 ghkLt9IwT8q2W+6Gt1lCl16CbGnQQCv+gZ5zaJ4rRAcMxVMzd4hnsOCnHXQReJPpdJD632TdLDK
 C0Eq7DwWxusmyDJ7DJdBFs/GyOo5KFuhwPDHGyIJ73OMBlatww/k4TIz6yxvX8iQc4iozm5XGv4
 oIpH0FK9SPTd9aI2pdYFI2B9K88SC904VWodBYOGEqYlReL+u4hQGXbf04M5wP3M0vimqB+im2m
 fOzd8uqOhnQHW7ZQ6E2Uiq+5wwj/ONcO8OhJVYsGYKNxpjpYsf3S/c/ZHL3aopsAuZX6IQR0Rrm
 euDSGTLgYKvNl7pLI/Z+S3kMM+PVUoqeftWN9VrNHhXqAcmteIHQOHXE1R3YekPTKhjZ02E2dO/
 +2jvsUWph7hAsv7v5WBQPblz5x7EBO406DhrYA+ycdR0eWd0gDBYPr2QkniMoO4M6rdqvkgfCKl
 Px5LzhExqCJxAow==
X-Developer-Key: i=nsc@kernel.org; a=openpgp;
 fpr=18ED52DBE34F860EE9FBC82B7D97093255A0CE7F

On Mon, 23 Feb 2026 12:10:29 -0700, Nathan Chancellor <nathan@kernel.org> wrote:
> Clang recently added '-fms-anonymous-structs' [1] to specifically enable
> the Microsoft tagged anonymous structure / union extension, for which
> the kernel added '-fms-extensions' in commit c4781dc3d1cf ("Kbuild:
> enable -fms-extensions"). Switch to this more narrow option if it is
> available, which would have helped avoid the issue addressed by
> commit a6773e6932cb ("jfs: Rename _inline to avoid conflict with clang's
> '-fms-extensions'"). GCC has talked about adding a similar flag [2] as
> well but potentially naming it differently.
> 
> [...]

Reviewed-by: Nicolas Schier <nsc@kernel.org>

-- 
Nicolas

