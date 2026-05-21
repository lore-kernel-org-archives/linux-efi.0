Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C7A363C72
	for <linux-efi@vger.kernel.org>; Thu, 21 May 2026 16:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779380630; cv=none; b=OZvoAN1L90+q2sHMNqjA57waccBfDIdpyZKk//BGZgzvcxTITC+HOdDgaRlh3Rqe70tNVOndDLzkTTtCAfsw9uSUyFDurBQMlVWDqhkbsd9xSMvpcJ68oqqOXciaUVUvS1IX4tCGWQF8wuhTt07wpAI/YdTMN2affrQqwHhFV0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779380630; c=relaxed/simple;
	bh=r5JFkedtjyxUQEgATEmiQLXn9jzwsJeqLGJs9w+IaT4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=HoiA3kIfTy4fIxpo+yAI9ru/U6g4jLIAg52GegtlHoE0gGQnmYIBeczj70BjwF4w31349BSLQ5qS477N+r7/LQwGCPy/+zundccWC65tPATNJtAens4YLzICSq50os3XIvD+kkHgNFa9IAGTubZhiyHOLXU6lAYkpwu49MIuUdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nknccMsB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nknccMsB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49DE21F000E9;
	Thu, 21 May 2026 16:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779380629;
	bh=Rp+H2/uvSybvETtWkPA8eGplXAQPO1w3VblRHycNS/0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=nknccMsBk6cpI5r0dKq3AB8j+nGaPz/PG+LSDVvSw/Tl0mJveHDSXBlX9p3EjWXt4
	 5rT+v/fRTY5CJpd8djYt+oIzY0IMQt44aQ3rpD4lnOR76fVzL+d3xbRl+vySJKr9V5
	 9Y0kb/Zp2xVCeo6micT8g92wTDoVX+aI8LKMCugnV3NMOcO50jO7HyoOux9AnrM+lN
	 4pVemKrcYOcx1KVMSxWngrICxy5jKVYev5nIxFihHIC0Od5n3r5yUJvQ/R1yB4aV4E
	 glu121sBQy8BNqbsmIJFf3FFWJARu6ieLT6fbnzNK/8VGMS0sjzeBrhW8nC97+my/x
	 /GO4cM5W1I3Rg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 569EF3930E0B;
	Thu, 21 May 2026 16:24:00 +0000 (UTC)
Subject: Re: [GIT PULL] EFI fixes for v7.1 #2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260521133414.65900-1-ardb@kernel.org>
References: <20260521133414.65900-1-ardb@kernel.org>
X-PR-Tracked-List-Id: <linux-efi.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260521133414.65900-1-ardb@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-fixes-for-v7.1-2
X-PR-Tracked-Commit-Id: d8809f6931065cbbf3554647a50a65a471ab5983
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 758c807bb943138f887d42d986b645e12446ba9c
Message-Id: <177938063896.406099.6932572270978519744.pr-tracker-bot@kernel.org>
Date: Thu, 21 May 2026 16:23:58 +0000
To: Ard Biesheuvel <ardb@kernel.org>
Cc: torvalds@linux-foundation.org, linux-efi@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 21 May 2026 15:34:14 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-fixes-for-v7.1-2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/758c807bb943138f887d42d986b645e12446ba9c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
