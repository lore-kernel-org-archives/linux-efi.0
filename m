Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A425538CFFF
	for <linux-efi@vger.kernel.org>; Fri, 27 Mar 2026 23:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774654366; cv=none; b=mPcQcpwRgTKD43m1C594bc4PkmSg6KIpaZ3qjC63lo40Ep17RL+96Tpi1V0ntF2OX2xmnzB2nJn+l5HA0YKa2tErr12MP2V810WoaZHqNIoEv1kPM1xzH4fRR+0G6FwpI3qENYcnR4tGCmFp4D3KTn/TXcCmK91H/XtoIl1QLE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774654366; c=relaxed/simple;
	bh=EjnHi1GtdnZGcY8CJ1JGimtNA7REvLxDVaJYECM6OKM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=fkqg461aYceDQxpxplTzWxaW7E5gz8OhP7z7BokCGkwD77ktpoTOLH2S06HgjmxUBr47pCt68U2cNnuJYFgFx7s5kY/ncLeYssY3F+uxAlItUJg8o3pV0Fe0WMIF05S5NyFaf9pQZGhERZ7pRRiX+cmSMqZ6oEtyEPkVaGg8Dxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZMIE0Unm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZMIE0Unm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866A3C19423;
	Fri, 27 Mar 2026 23:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774654366;
	bh=EjnHi1GtdnZGcY8CJ1JGimtNA7REvLxDVaJYECM6OKM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ZMIE0UnmMzE7/DqQwYihGVwOIFEFSUHb8Z+JW5UpLUT+7jzuN97l0RzgSU6gpMIHT
	 6UECiIGqHKIhIwa48K25Rd+N8FfYkJKkv9JnD51NCmbVW3J8G9FSyAxfhhZ9aPRDGj
	 w7qohQBxb3P0yvh2ZprcONYqINK0DJ86ybZqeVtPCC+HBKoTfG88wNyfMzYj1P0ep8
	 xl5QR+9jPtbutSG+HViYg+tmbKnCqNfA63oV8gW/G4I+CnFed128+6MwiL0tMjvgyZ
	 4FsYRCOEz/EWq8oWDTp/52HWrN575N9hs0E0gC7TUE1WL/YEvFET2Eh1vnXJCRlGnH
	 JRY2Hwetos6Qw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7EE5439301F5;
	Fri, 27 Mar 2026 23:32:33 +0000 (UTC)
Subject: Re: [GIT PULL] EFI fix for v7.0 #3
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260327161245.18474-2-ardb@kernel.org>
References: <20260327161245.18474-2-ardb@kernel.org>
X-PR-Tracked-List-Id: <linux-efi.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260327161245.18474-2-ardb@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-fixes-for-v7.0-3
X-PR-Tracked-Commit-Id: 217c0a5c177a3d4f7c8497950cbf5c36756e8bbb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 56bea424158f6b99a452ab9410092d72b03f8545
Message-Id: <177465435248.4116696.14651905305213234852.pr-tracker-bot@kernel.org>
Date: Fri, 27 Mar 2026 23:32:32 +0000
To: Ard Biesheuvel <ardb@kernel.org>
Cc: torvalds@linux-foundation.org, linux-efi@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 27 Mar 2026 17:12:46 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-fixes-for-v7.0-3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/56bea424158f6b99a452ab9410092d72b03f8545

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
