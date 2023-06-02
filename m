Return-Path: <linux-efi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98BFAC7EE2C
	for <linux-efi@archiver.kernel.org>; Fri,  2 Jun 2023 11:29:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235266AbjFBL3f (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 2 Jun 2023 07:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235242AbjFBL3e (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Fri, 2 Jun 2023 07:29:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1651E196
        for <linux-efi@vger.kernel.org>; Fri,  2 Jun 2023 04:29:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F84664F20
        for <linux-efi@vger.kernel.org>; Fri,  2 Jun 2023 11:29:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0D665C4339B;
        Fri,  2 Jun 2023 11:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685705373;
        bh=CwBwJz1D6c7nPrezI9RBq/bJPztBvQbst6B2ckebbw8=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Ysn2H7GydLWPhM+pif8pbTXJUaVKNEfgB1qbP5L3a+zQMkscPcTqvlRwwmHCHEV+0
         otGskMKAbK3RlqvISi/Sq/u81XXE0cRXYy9k2Q7HkxiOazyZPH7fSqM/amwbwvL6X3
         UjYQrawl2QqKqWuFWBeP7JR8yGIqWJUBWEp1qVQQAZxTP/axxuCLQKmbvaCkRxNo/l
         EbnGVDE0N6bbaib0GK/ekMMywUicFFjDaSC2q/bMcqaL39QrndeO+c+J4eGGim2lk/
         W4HQag/L9lKHk6UUxP1pfQVrsuYgcyDlxMdNnalWwggeJIHu6oPDPfWL+dTlB3OqKL
         PeYNr9nw5R/GA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DECEAC395E0;
        Fri,  2 Jun 2023 11:29:32 +0000 (UTC)
Subject: Re: [GIT PULL] EFI fixes for v6.4 #1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230601204715.3368380-1-ardb@kernel.org>
References: <20230601204715.3368380-1-ardb@kernel.org>
X-PR-Tracked-List-Id: <linux-efi.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230601204715.3368380-1-ardb@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-fixes-for-v6.4-1
X-PR-Tracked-Commit-Id: 36e4fc57fc1619f462e669e939209c45763bc8f5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 792fc9214036633f2c26fe551cd26d5d7abdecfb
Message-Id: <168570537290.30896.11480605852205677257.pr-tracker-bot@kernel.org>
Date:   Fri, 02 Jun 2023 11:29:32 +0000
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     torvalds@linux-foundation.org, linux-efi@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

The pull request you sent on Thu,  1 Jun 2023 22:47:15 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-fixes-for-v6.4-1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/792fc9214036633f2c26fe551cd26d5d7abdecfb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
