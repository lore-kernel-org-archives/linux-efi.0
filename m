Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4BF3451C6
	for <linux-efi@vger.kernel.org>; Fri, 27 Mar 2026 16:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774627983; cv=none; b=MkbECnH4KFngAMUVqoyVCDJTMMKwrnnR1AzwZcQjz0Av3f1g9n/B6lVQyhwYTXKPMl3mmQxHaKU3XA4QIjD79W0XDfD3jvSVEr6tAGSR6fHUK2l7cr81WLTIvkwNg3nvjY8T9mogc+dRtYP4z6422EEhxjTCK3dlD0e8n6+nQhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774627983; c=relaxed/simple;
	bh=F+fSUpDBsyzemLtzrnL9HOkQtCS5/BToHgLJCbpp/x8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pnmLqf7EftJzfWZf8WEbkX2IEOE4tEOrPbRcWyoAMgdjJvb+qM5NJ8oINz2TsImDcVNepbalcyfvmzKbRECIpFYWrUxuAE/rOuHMhcEVbM6Nhep+l/ZbNeBINGMWE1id9Sl2jckSkWjQObyWKgYUUXqWrFNGgoki5YuyhXnolUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iTHHfWy2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iTHHfWy2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96202C19423;
	Fri, 27 Mar 2026 16:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774627982;
	bh=F+fSUpDBsyzemLtzrnL9HOkQtCS5/BToHgLJCbpp/x8=;
	h=From:To:Cc:Subject:Date:From;
	b=iTHHfWy2m4amuZRL3lyLEqflytr8eVbk69kY4FTycvmNUoZ1+7h/GZha+11kWXgkx
	 t73tgo/BKhdGyCwdz0HIaMVeTzXi8XiRDQcvZXhssGMeRB8OVXwfQ82S74m0kV3NfF
	 9+FECnw84DTOzklwKsLREnwDvJg9isdPzk7WoBOxqHQ1fVMeca6rR6w905v/jfAFTl
	 IsglVEgn4SpcsmjrCwgNxmpiGSaMILhCIaAmG9XesRRY7KKSzspctvAnJ7GXws+2QW
	 G36cYkdDr2TeTNXN3ct6QXXXcKpydT+bqJZMc/xVg35RKTW0hwUkrJGSAx6hkMTleE
	 kCWWD6NfrXQ6Q==
From: Ard Biesheuvel <ardb@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-efi@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [GIT PULL] EFI fix for v7.0 #3
Date: Fri, 27 Mar 2026 17:12:46 +0100
Message-ID: <20260327161245.18474-2-ardb@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1067; i=ardb@kernel.org; h=from:subject; bh=F+fSUpDBsyzemLtzrnL9HOkQtCS5/BToHgLJCbpp/x8=; b=owGbwMvMwCn83sBh/rljoYmMp9WSGDKPrak9ddHpksnKEJnEPzfkQ7uX7S6c0Fz9+LYJF2MMt wJDOktIx1QWBmFOBlkxRZadyjndr11E3+krVObAzGFlAhnCwMUpABNZuJaxYeui9VFy5dsDLp0P ZL8XtcZi6UwBxoNRew3LT3d83V4w8/q0ad+2e3gpb9wZZnvS4sW7a4wNm0xYYzb3cO+qWdqneyz lsqXmHu+dTIIFjHan61Y8n3C6oOJqjcfWk6++r71cd+TndNGDAA==
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit

Hi Linus,

Please pull a fix for the previous EFI fix that landed in v7.0-rc3 and was
tagged for -stable.


The following changes since commit a4b0bf6a40f3c107c67a24fbc614510ef5719980:

  x86/efi: defer freeing of boot services memory (2026-02-25 12:02:48 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-fixes-for-v7.0-3

for you to fetch changes up to 217c0a5c177a3d4f7c8497950cbf5c36756e8bbb:

  x86/efi: efi_unmap_boot_services: fix calculation of ranges_to_free size (2026-03-20 15:31:10 +0100)

----------------------------------------------------------------
EFI fix for v7.0 #3

Fix a potential buffer overrun issue introduced by the preceding fix for
EFI boot services region reservations on x86

----------------------------------------------------------------
Mike Rapoport (Microsoft) (1):
      x86/efi: efi_unmap_boot_services: fix calculation of ranges_to_free size

 arch/x86/platform/efi/quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
