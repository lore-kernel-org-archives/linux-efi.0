Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E838310645
	for <linux-efi@vger.kernel.org>; Sun, 23 Aug 2026 16:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787502730; cv=none; b=dniIz8chhPCCHU9bck4dQ4f7IbyjTBD/BeOoKB7/gzgravRdv7uDoFcS/l1PNu8pmuFuixfrJq433gM6V0yMSTUE4lf0MwEK4eLjxdk93QZ6nBkArAGcVtJIF/Bg8xGfZpSeCmT9Cw0ykKNop8yJFbyh1w6rylVSbM9ahe3GV0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787502730; c=relaxed/simple;
	bh=B/Ieieq8CD9G2zY/M/dqK2jCYjVJ7IvykzUo87HXRR8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Z51RXno+Vzzj/QO+gbe+BgH1bgTd89YVlMydmZKRebAFey/kC/y4fGjSvc0SMGB15sWecXD6F1QFuPG1h3W0ueGvvyXBgVsjE0HpXzt/09PZ0jJLULLoOvZxIcb9LeI3G7F63sRB3aTrq1ufyTcXVRmfpui+FZYt+XAYz6bzL5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B8AV7Qta; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B8AV7Qta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F47C1F00A3A;
	Sun, 23 Aug 2026 16:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787502720;
	bh=maz/QYPN2XpLEhmzSbExHt6l98pnnCeaeSiAh+BfqDQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=B8AV7QtarKSZEbzpw+BXEwtAqqGjXHsr5GMttcSshQwhGEu0aaIBW4BuzS82hQB2w
	 EUBJP/XaZGQ7TV6+bYsqDd4M0VkJJjl6z5GDn49gjd4L6MVuzqaTko6ybNA9syI929
	 8CfMWZB0kO2aMfi+Yv+SPFFE6TAiuRhP76LQHttQkHeIGDtb7/BoDFLj+fRFj/yW6Q
	 iZf4wJn6dVYpyw6EiZ/v5sKVejgXgc4Gwx+PiI8vfAz1ZDWTWmVxRRT9tHQl+8P6TT
	 cB21C+pr8iqXJFEF0UpvKLvUNx00ApvGPu+2J0L8nw5ZgNyOXSpQbTdZc3anje8cem
	 lc0HXswGXpdRA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 939D7380AA77;
	Sun, 23 Aug 2026 16:31:09 +0000 (UTC)
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
Message-Id: <178750266823.2080322.3202354857574288411.pr-tracker-bot@kernel.org>
Date: Sun, 23 Aug 2026 16:31:08 +0000
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
