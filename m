Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792909144;
	b=Wtm17I9FQiU0fl8iLm3U0YQ97LmkRncnEcITbUphaFpyM2Jhh+ixRvVDAdRQrCXh8+gW
	 KFTBJreeq8DRYGLkfsxbV5QRGclAY3gbcN/1nSPMx4Mw16Bc249j4vV0p/lQ8F00CZAKe
	 m8yh0UJUnZLnsi15Lgj9Dks6uDU0d5Z3Jna2DvUwJpieCxS37uAjbMH126/GG3g6yF0Nx
	 xst967IafxRvUzMcCJU+qpq1NzMt59bRtIZGN60QB2AuQ5fm535rckxvVfUjQpwccZx6e
	 8YexQk2HZOIx74gey4s+kUQ7qT4qp+Vva23jM31jpuleN3XWJ4U1dcGRgeuN8oDgqMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792909144;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=ay5E9oYsi/kiuCBja2EoGA9SavrXuvtoNU4xHbdrZ+k=;
	b=cc3AlHaa5uIigUjxVRQFvF/jKlTKGDJuRP6/168W6f8uJDDC07GwYtojYWojTP1DFKYm
	 C+7eviQykUVRWpiWRYmRvdI8iiT51uZHZUkM4LA801iuE7CUtnGB7GZ/ObL85MimpDNol
	 1XGT43n9Ge7/Gz/ZGq1/uIVZtLz+UP0+3Q7kEoKYt/HFbbVYG51EDYhH8AC5OSSk+jtAh
	 Or3hjh+Q6D0IYVNgS0LqGWUsdNoP/BPw66+CfZ3g8XgB8j3eH5NAx1d4MsVlCRFDoQC0Y
	 RnvnwoWongx5BzafwZDCPxLvauDDlFgJQ1cCTI9Rzf6ehhWFKHyIOpAMo8Q8tMuessw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="FUkrm/Vf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3338C606A328
	for <linux-efi@vger.kernel.org>; Sun, 25 Oct 2026 06:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FUkrm/Vf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF9A1F01825;
	Sun, 25 Oct 2026 06:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792909144;
	bh=ay5E9oYsi/kiuCBja2EoGA9SavrXuvtoNU4xHbdrZ+k=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=FUkrm/VfjK0RhJJ1irih+ghmnt5zWHk0IWNGFQ8ZyabHVBZJetLaZ6L/n+K9BAGKi
	 6ABEo9S5I1vpWeVZL/e+nWV8CTW9ji0dBy8Pygani7QP/8uvuVZBe+ZXzzgklANMF2
	 lvwsMC1Ze1Xv9AuWWGzLEPwToO3DazbUOMkRc7/9vWQekh7Qu8yrcbQr5G1LRNLiCK
	 +HFXxOznWBfXR5qcpUb6ivs5bYgAapogcrOSWEIPEVosxD8Uw9oXSK9yu8zP/mb8y/
	 i1nLsdcb2UWtwObaC0hxGW3Os8n1ftXuKzGljHg19Pdf+rDJQ3oW/UgTHVmt4glgv1
	 ZlSWZBjLtgUOw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 07432392ED67;
	Sun, 25 Oct 2026 06:19:04 +0000 (UTC)
Subject: Re: [GIT PULL] EFI updates for v7.4
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261021173109.2402130-2-ardb+git@google.com>
References: <20261021173109.2402130-2-ardb+git@google.com>
X-PR-Tracked-List-Id: <linux-efi.vger.kernel.org>
X-PR-Tracked-Message-Id: <20261021173109.2402130-2-ardb+git@google.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-next-for-v7.4
X-PR-Tracked-Commit-Id: 2c493ac8c347167eec9e4e985d2b58d5fa6fd420
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 89d2d7bf0698b7fdfc914bfd219e739e9308d332
Message-Id: <179290914276.2017309.16998498662338251915.pr-tracker-bot@kernel.org>
Date: Sun, 25 Oct 2026 06:19:02 +0000
To: Ard Biesheuvel <ardb+git@google.com>
Cc: torvalds@linux-foundation.org, linux-efi@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list

The pull request you sent on Wed, 21 Oct 2026 19:31:10 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-next-for-v7.4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/89d2d7bf0698b7fdfc914bfd219e739e9308d332

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
