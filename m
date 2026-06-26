Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27AE3E4C64;
	Fri, 26 Jun 2026 08:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782462088; cv=none; b=M3Os6cLbgifmgBWvY/iWGreeu/182hyVADel/7FlNy7ThuVPywALlYkiAOA/7QE6AsYzgptyeboIK4NgO23b9ho1oRqMqwg7luMLekiDpBgJkDTw8dbz+ZtUxYbYLq80ynjIpKuShVcGDsNzgThl58otQLNbhVMGzF4fTcCHVMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782462088; c=relaxed/simple;
	bh=ZUCFF9Bxcc3F5VEHNQrr85JFAo24F6/QOC0vcvR/RPw=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=HH3mMXXDaPqRFYP4QJ03f5MtNz4jhNERJpxK7rcqDvEgj6vgJAk0+rhMgVJCZKpNsaj/lz6CGJGjdCKHpfo/5A+ajGy/kIENCinnMqpsasCSpiZBr57KhnSCb+8tiEv4Lx5f54B0c3zxqpYbUi5fva+gSJn2iHwnjeqRO4IZg1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eoEGwJ1e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eoEGwJ1e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75751F000E9;
	Fri, 26 Jun 2026 08:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782462075;
	bh=Q2yg6hQ/U5ooIXv4yyQf4Yi76qiwrYkAT5ywoTwEX24=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=eoEGwJ1ecsRSn7WywfpxkZWxT6gIxVIXdMSZwAEI2V1E39AubUWaB2a0uCavsVO/W
	 SKbYzH+XwlQtzMpWB1Tno5JBmSEusBPUDJvMeA38EXP5i35ed7l2XkrqSEHhyF8GoX
	 lPLofBSnMcWecZCRQ2d2m7SgFmx3JVGkN37+USNsLQfqpR1cRLbOzwFLZyAYHrFcus
	 bVB1zdnFi9d/fM6BbFkZaWCJ7MUFlRm8/MJsNrXSfvrm4WXvqlDNnVxy6dbCUspSD8
	 /qyzNnLegZwVjaof5ZVoHs6reVqEf1LfS5nsF3JF4xLfVGf64jz90MtI7syirVBUBS
	 st63LXRVjMvWw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id E558039389E8;
	Fri, 26 Jun 2026 08:21:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v11 0/8] lib and lib/cmdline enhancements
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <178246206276.3816447.15355853721771645153.git-patchwork-notify@kernel.org>
Date: Fri, 26 Jun 2026 08:21:02 +0000
References: <20260519172259.908980-1-dmantipov@yandex.ru>
In-Reply-To: <20260519172259.908980-1-dmantipov@yandex.ru>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: linux-riscv@lists.infradead.org, akpm@linux-foundation.org,
 andriy.shevchenko@intel.com, thecharlesjenkins@gmail.com, pjw@kernel.org,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, ardb@kernel.org,
 linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This series was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Tue, 19 May 2026 20:22:51 +0300 you wrote:
> This series is a merge of the recently posted [1] and [2]. The first
> one is intended to adjust '_parse_integer_limit()' and 'memparse()' to
> not ignore overflows, extend string to 64-bit integer conversion tests,
> add KUnit-based test for 'memparse()' and fix kernel-doc glitches found
> in lib/cmdline.c. The second one was originated from RISCV-specific
> build fixes needed to integrate the former and now aims to provide
> platform-specific double-word shifts and corresponding KUnit test.
> 
> [...]

Here is the summary with links:
  - [v11,1/8] lib: fix _parse_integer_limit() to handle overflow
    https://git.kernel.org/riscv/c/6e30111dbb40
  - [v11,2/8] lib: fix memparse() to handle overflow
    https://git.kernel.org/riscv/c/9a4580db6e9f
  - [v11,3/8] lib: add more string to 64-bit integer conversion overflow tests
    https://git.kernel.org/riscv/c/ab90fc100724
  - [v11,4/8] lib/cmdline_kunit: add test case for memparse()
    (no matching commit)
  - [v11,5/8] lib/cmdline: adjust a few comments to fix kernel-doc -Wreturn warnings
    https://git.kernel.org/riscv/c/117d2bfa0ab1
  - [v11,6/8] riscv: add platform-specific double word shifts for riscv32
    https://git.kernel.org/riscv/c/a354b8de9ad6
  - [v11,7/8] lib: kunit: add tests for __ashldi3(), __ashrdi3(), and __lshrdi3()
    https://git.kernel.org/riscv/c/6bba2ae43e8f
  - [v11,8/8] riscv: fix building compressed EFI image
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


