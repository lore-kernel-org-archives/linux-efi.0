Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97093328FD
	for <linux-efi@vger.kernel.org>; Sun, 23 Aug 2026 16:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787502723; cv=none; b=JVp6BLXm8I27SCQOxFRH5upzNaLEkQe3ZH5Xk9vUXyrN7lp0ZbiKPtv94dnpbXENcB09ZUgMvN4UM64gXGakNmDVArPw6o5rJDNNX+ZTE9c55yXuK1jdDe9RrzNPmnIJW6cL3bBkLsim6bdyrU95lKPV+K7b++YvqSabdk/C9Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787502723; c=relaxed/simple;
	bh=B/Ieieq8CD9G2zY/M/dqK2jCYjVJ7IvykzUo87HXRR8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=gWmvtGFZJB02RSDKghvIHuCULLF+LOgB2tCI7EEKNshWyWldUle6krOKXw8ViAiQ2P+dV0iTCHyKl3t5a1zTYohLVlYIJjrJBDv9qt9Sq/fzOalTBaxuHSC9oHB7uZFBQCiT1u9bok4bLETP7DPEMWfFgbo3as02Tfq4Nbu5+Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PeNL27ak; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PeNL27ak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C00BA1F000E9;
	Sun, 23 Aug 2026 16:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787502718;
	bh=maz/QYPN2XpLEhmzSbExHt6l98pnnCeaeSiAh+BfqDQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=PeNL27ak/7Deakjfmvi0PrZVxbb7uDSg0RzgjXuiTjD5tOt8AhY77ZvLINvsBTRed
	 C5sOsNQLwgvWrgE2lLxRg0EltZn19StP9oNrtN7GTRqZ8Zs7R35UO4Bc8jCNIPk85L
	 L/1+y/AOkXUyQ5UB+rbhsb7btS6qdj5CTbgehRFrZss23LVtbQXNeDzwE7naK0eqWi
	 p5pUGw6AjEXO9kVkWcSucP2AaquKgmgdpDkhEKZQPmyE58RbUPBnFolOvkMPYKFrgO
	 +/1BbAtC2SXM/lH/VSiPsxQB3fk8mDyNoFcCK0Z88DgOPUYM/AD7dZMeBLjex1u2oE
	 kIEsr0J3f/CVQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3A501380AA77;
	Sun, 23 Aug 2026 16:31:08 +0000 (UTC)
Subject: Re: [GIT PULL] EFI updates for v7.3
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260823134348.2868-2-ardb@kernel.org>
References: <20260823134348.2868-2-ardb@kernel.org>
X-PR-Tracked-List-Id: <linux-efi.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260823134348.2868-2-ardb@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-next-for-v7.3
X-PR-Tracked-Commit-Id: b2326338dc683e8c1067c0cbf7a47986c4190902
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 388b607d107c07aaade04c7f22f344cab6bdccd3
Message-Id: <178750266700.2078512.1245257131554044605.pr-tracker-bot@kernel.org>
Date: Sun, 23 Aug 2026 16:31:07 +0000
To: Ard Biesheuvel <ardb@kernel.org>
Cc: torvalds@linux-foundation.org, linux-efi@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 23 Aug 2026 15:43:49 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-next-for-v7.3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/388b607d107c07aaade04c7f22f344cab6bdccd3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
