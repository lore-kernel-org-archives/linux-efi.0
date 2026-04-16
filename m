Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9139A2750ED
	for <linux-efi@vger.kernel.org>; Thu, 16 Apr 2026 15:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776352833; cv=none; b=QiBrrnurngdC3euoXBo0fcYvsXDD4KoStcz2mV//pLKqaE5DP+MhHtArSG+LEp5IpsEY3jbDMdkmj6wwmqETJuKLsMWpa8n6WZ1PPD4BC24TfxcVMIphIpIngZ947iCwhgZlovE89jBUwZNOm4WE3Me+9jd9ckV9kkxT1m36SGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776352833; c=relaxed/simple;
	bh=iwOvuc1OSFjzr76TrhqcU5Cvv52hMfIyjZzTtBzw2T4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=IBdtKk6AGRKyoyOzY0K/cA7fTEnQUI1MO3OV72fCb8BoiQVGUxx4MuUafX8JwU0M+4ifAef5j/QRd8yTCVMwKVk1MqdGuWuTKOA0C+dbZ04xHRcVQIJBsYTpF2HmxGLYKgiwM6txhT1fVJYf8wnf5Zk2l7NbiQYi+BSb9s10J/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nzo2Qwdo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nzo2Qwdo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B94C2BCAF;
	Thu, 16 Apr 2026 15:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776352833;
	bh=iwOvuc1OSFjzr76TrhqcU5Cvv52hMfIyjZzTtBzw2T4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Nzo2Qwdo4msqESlx5ndZ08MnJ6AF76fc7naJQ6/dJVgCIWfvKyNTVNAmues9/44Ss
	 c2tYQ7mFYcLkp2hbcakMVBLLmhVz6Xw/NyG1+8D9wMUud9qIAiV1glTeBqRfxhrwVz
	 NZW2Trixao1ngM4NShgujiRIWO+mus55k4LlxeBGHjtsQNCZuOBa8uPo/htahsLAj3
	 wkRujOBKIuhNSh/tCniMnjSJPHSfUDqxNr+cUMgH0zMmSpdKBbYZyVzAGu5Mr9VcGu
	 kRQh4oTJECsLTb3GsBHEjeSjLu0twlLX12vmOuOAzpp/seix4CeCVINGwXJ9Kq/pxR
	 tY3vJjMMkGqLg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FD8E380AA63;
	Thu, 16 Apr 2026 15:20:03 +0000 (UTC)
Subject: Re: [GIT PULL] EFI updates for v7.0
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260416071005.421896-1-ardb@kernel.org>
References: <20260416071005.421896-1-ardb@kernel.org>
X-PR-Tracked-List-Id: <linux-efi.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260416071005.421896-1-ardb@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-next-for-v7.1
X-PR-Tracked-Commit-Id: 48a428215782321b56956974f23593e40ce84b7a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 948ef73f7ec39622ebd27bba4e94d78a983109f6
Message-Id: <177635280189.3274006.9598699933657347131.pr-tracker-bot@kernel.org>
Date: Thu, 16 Apr 2026 15:20:01 +0000
To: Ard Biesheuvel <ardb@kernel.org>
Cc: torvalds@linux-foundation.org, linux-efi@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 16 Apr 2026 09:10:02 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-next-for-v7.1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/948ef73f7ec39622ebd27bba4e94d78a983109f6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
