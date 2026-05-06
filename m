Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D725E3ECBCD
	for <linux-efi@vger.kernel.org>; Wed,  6 May 2026 14:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778078691; cv=none; b=SFtUgnpSpAKoavBCj33lBLU8FaSQfQzJmDxW5nqkCjr5nZnMBgDY2lFfwUU+36UTruWMh79rB2XBkUD8ydeFEM8P5mFs2RTnta+f7vxc/mkg7VLrpuXN1ECSwee90dosN7L6YafmfgGgVtXPnXvJFsJMVjEKRvM/t7j0xUGbfbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778078691; c=relaxed/simple;
	bh=xkK/EZmo9f/nHSM0GhposwZnj3+EwZDKlWn1ElWcFRQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=BCLAI3q/UcsrKd02x3hwYSvSBOHxvaY1J2ZHxwi1g9fywojFBi/tCeLE8wEZd+0MMRAT/CNQBAeFuJTvlWZs6dH0Y45mC0TlL1FYDJkUzGy6m6Cjb0qPOqfoVsPmAOPUEWrJrzUgTB1E3QNQFlLsn6C4EC63EF87KwJdvT8sdZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L2rmrDV+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L2rmrDV+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A629FC2BCB8;
	Wed,  6 May 2026 14:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778078691;
	bh=xkK/EZmo9f/nHSM0GhposwZnj3+EwZDKlWn1ElWcFRQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=L2rmrDV+y/2am9UICZ9ykEQw8J9TSPLUgiv1khLcd9xoGPojhrI7/mBeo4KU7H3iw
	 +ouBiT+06lmUxBXvMoHx9gAkDmKLcVbUto6grmc/EvgIy/Gk000TuHzOBXC7u+FcIn
	 hAzc+nq8YW3LYFCVQYvonCk+j9QB7v2RUG2IYqkzAof1sSg/MbThh15up10b9C9SZR
	 BPEhIIWgN8APpawrm+J8kGYby4MQkEvogymH/xBhjkPbeTA0tGjeHgz6nlqev51ngM
	 CSij8J3wmS5Dj55ZJUlRRE8WlLfVRheVtgcF4WXoDbBhS/UtUobrqlbaFLed3BsO08
	 TzKpvB0+Qyswg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B9E503930888;
	Wed,  6 May 2026 14:44:02 +0000 (UTC)
Subject: Re: [GIT PULL] EFI fixes for v7.1 #1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260506130427.1761-2-ardb@kernel.org>
References: <20260506130427.1761-2-ardb@kernel.org>
X-PR-Tracked-List-Id: <linux-efi.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260506130427.1761-2-ardb@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-fixes-for-v7.1-1
X-PR-Tracked-Commit-Id: 2c340aab5485ebe9e33c01437dd4815ef33c8df5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: adc1e5c6203cf13fe05a1ead08edcb3d3a3baae8
Message-Id: <177807864132.3029139.16314168368726127729.pr-tracker-bot@kernel.org>
Date: Wed, 06 May 2026 14:44:01 +0000
To: Ard Biesheuvel <ardb@kernel.org>
Cc: torvalds@linux-foundation.org, linux-efi@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

The pull request you sent on Wed,  6 May 2026 15:04:28 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-fixes-for-v7.1-1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/adc1e5c6203cf13fe05a1ead08edcb3d3a3baae8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
