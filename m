Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CA83D5668;
	Tue,  6 Oct 2026 20:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791319346; cv=none; b=ldnk0P6eAnD9Tz0i6Phl4UQ1D2CWLfAptXPNt/oFjyAr4uqZNDvl0l2w9q6ncnq7mOUdQusYSGaae5QZMvefByme4Jw07VYTcCKK4P1b5WjMvwyHk1AEeO4D4s4dVe6aGnCV/q6xPupI0Jv0FzREsqcVYzymjz9j5AWLkpjHTwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791319346; c=relaxed/simple;
	bh=UqtutRu8nk5u48wdvmeYoIosrSMwQ04XbnLmmxuBpvs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dTFw74zD96DNDzTiuCgdwZNZSrJTRQfk3jIWY2c9tKd7ck6tU3c/VI6+ZKqGBkXa2+1kjwBruA28XC4vj9oRG94JSUlHz7OIRaJ1ZXA7DZQih76Hc/F1t2OcbnGdjqk94mNaW10kOdNUX+bWS0Tr0v+aZR+kNETyOVUGk3UIul8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k7a7NZc/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k7a7NZc/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 258691F0089C;
	Tue,  6 Oct 2026 20:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791319345;
	bh=eZxPAoBL5n61MyLHxaqGXd+KVCJ9IahJnpYRV/MxUFk=;
	h=From:To:Cc:Subject:Date;
	b=k7a7NZc/ZsBuC9JcDqOEX1V0BstjjbisaGOGk7U4sAXYsnFdXnFZBHg30nElFZpgz
	 atHbKhOJzG0nGmWta9wKBlhLRR394CVDupM8nWmykabt4XY89zhF2oCh0uKQ/ViblB
	 l6ueupOut0RPN1IYJVJGf5oQiVAkx8MNTRL8gufK4LGMqhgN3zg8YcCMAZ0GFt3ZiQ
	 5YEqfdZc/ZqfaR4dujiJEZUYo14I9HGNwgiH4r3RVIKeoX4YUU6rfj2vS6oCKvomJm
	 yDqTr4Z5JQm6/1O02f2/cXHyroMfJ9gYDuDkTLHfSCeAoReXTaKdYBZ00FOwoIaJQW
	 1j2dUirA/Owww==
From: Kees Cook <kees@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-efi@vger.kernel.org,
	llvm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH v1 0/3] efi/libstub: Build the x86 stub from KBUILD_CFLAGS
Date: Tue,  6 Oct 2026 13:42:20 -0700
Message-ID: <20261006204210.i.137-kees@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=940; i=kees@kernel.org; h=from:subject:message-id; bh=UqtutRu8nk5u48wdvmeYoIosrSMwQ04XbnLmmxuBpvs=; b=owGbwMvMwCVmps19z/KJym7G02pJDFlHY/W+f9srEjjjx/UwjVLR6dqSVp0LG/Ji7wXeLDo0X UnncYtCRykLgxgXg6yYIkuQnXuci8fb9nD3uYowc1iZQIYwcHEKwETklRj+Wdd2P7p9MrL1lOw9 S1bP2j2rH/4oePHOxeYxx697hhVHzBj+aZ5wK9z2yOfk21utGyJb/SVvVJtxfwiY6Mlvv+FOoa4 TPwA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Hi!

The x86 EFI stub builds from its own short list of compiler flags instead
of KBUILD_CFLAGS, so options added kernel-wide reach it only when someone
remembers to add them there too (e.g. for -fms-extensions). Swap it
around to remove unwanted options instead, as we do for all the other
architectures.

This will let Clang's -fexperimental-late-parse-attributes reach the
stub build so that __counted_by() will get parsed without error[1].

Thanks!

-Kees

Link: https://lore.kernel.org/all/202610060642.7C4125F@keescook [1]

Kees Cook (3):
  efi/libstub: Declare the x86 stub's assembly entry points
  efi/libstub: Build the x86 stub from KBUILD_CFLAGS
  efi/libstub: Disable kernel stack erasing in the common flags

 drivers/firmware/efi/libstub/Makefile   | 41 +++++++++++++------------
 drivers/firmware/efi/libstub/x86-stub.h |  9 ++++++
 2 files changed, 30 insertions(+), 20 deletions(-)

-- 
2.55.0

