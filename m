Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F079E33D6C0
	for <linux-efi@vger.kernel.org>; Thu,  9 Apr 2026 20:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775768294; cv=none; b=ifY0wTQ+TnBAlFV36SMSzt6vzTxPSaIC6caZO6tYEKD/ln97tmYh5F2Pb+lYovp57LZYIpgfH0h8zjer+o5z8hD5rhBAMpukRKCoThnyXydbQ1DU13NSh4ar20ewFOPi6/c368cRVAdBHlMpDUxYDBVwoyy7hE6BtAxmqGlHAAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775768294; c=relaxed/simple;
	bh=f6gvcm0El8wZq0IYmhSP0mqYQcQnRpBbCcCZy+EGVvg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=gOh+KYwgacpoaRRf65z3wW6C1MP7jmCI/M3OZ1Uim4x7tkAgc/dvgsjTfBqsmKHbjbgngp3N0rv7lbAfwKyPikMPPNcAYJV0rk/CY61azubGowycGJJmQxOrPm5MblDQ9v3bh17JKHd3TUldK3O16etqGWbitlxzt9FJn00PnY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DO+i/h/y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DO+i/h/y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1331C4CEF7;
	Thu,  9 Apr 2026 20:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775768293;
	bh=f6gvcm0El8wZq0IYmhSP0mqYQcQnRpBbCcCZy+EGVvg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=DO+i/h/yENGaidA5mJfQklyZ5OobePJaQBVuxwNOV1C4Hmm1doOLnbTwIzwjqKmuo
	 Dysq0FauKeJ/cpAVRyGf6+L2SvdBHyLhaYf6gk9+wKVZaNuDKqIVPH32ZrNIW0ZptD
	 44SaWMV8xtIESr/5FHQGwL7RPIw8khmFWB5GVh6h28lbHZ+ukPtUtFfmzdixBMVjLr
	 UKl+mCiXMWJFTMK/UV7KOLohSOOgaWFIUdHTVs3pnpGaDw1xJ6AoNA4a0URmpG6Sye
	 TJnlY4i+98vtD6r4tBWQF4fd3f/BAFAPH8JUTd2P6by8sx95rf/Wktc0NRYGnWCpJM
	 HWgmQYZO+kjkQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 83CAA39308B7;
	Thu,  9 Apr 2026 20:57:50 +0000 (UTC)
Subject: Re: [GIT PULL] EFI fix for v7.0 #4
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260409152523.1035577-2-ardb+git@google.com>
References: <20260409152523.1035577-2-ardb+git@google.com>
X-PR-Tracked-List-Id: <linux-efi.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260409152523.1035577-2-ardb+git@google.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-fixes-for-v7.0-4
X-PR-Tracked-Commit-Id: 5241c2ca33bb181bf7abb7cb4bba1cc67d1b6278
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b42ed3bb884e6b399b46d19df3f5cf015a79c804
Message-Id: <177576826938.1737704.10869384883605474187.pr-tracker-bot@kernel.org>
Date: Thu, 09 Apr 2026 20:57:49 +0000
To: Ard Biesheuvel <ardb+git@google.com>
Cc: torvalds@linux-foundation.org, linux-efi@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

The pull request you sent on Thu,  9 Apr 2026 17:25:24 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-fixes-for-v7.0-4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b42ed3bb884e6b399b46d19df3f5cf015a79c804

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
