Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0772C433E0
	for <linux-efi@archiver.kernel.org>; Sun, 14 Mar 2021 20:02:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B83664EB2
	for <linux-efi@archiver.kernel.org>; Sun, 14 Mar 2021 20:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234000AbhCNUB6 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Sun, 14 Mar 2021 16:01:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:56778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233641AbhCNUBo (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Sun, 14 Mar 2021 16:01:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1651B64E04;
        Sun, 14 Mar 2021 20:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615752104;
        bh=7RgLVp3TJRcttE4XvweHuRrkUxlfWlq7p6zf4bpav9Y=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Ermggu1uCQCMS6zLoEN3pWgXzzUsubWJzVJHi9jZ1TPVmf6bAiKULSLbGu9DLhcta
         iFm7pCu2pLG/1cRzuAkugKGXdDpGog71JptzKEUcpVjTVdQMYpDH9tjIOd3Gy88sB6
         HBbA2d2WgcpPZJPbwsv7MOeq1RMmcG5qJUmprE7eWhtpttV3GwhGeU1hh/zlYBA09/
         TE8pcZzEweXbWrXJ61t3QGPS/ElXpAhyrrdEKw3x7XNVatQz6zF2LNscnqlzV0geYB
         XgXPRchcJeY6yXnwHNH48oJb+0N8FlSRIxSJq8q5HsmqxlbJkXa9uY3UdUeqRYT3zW
         1ReysS8f1XvFA==
Subject: Re: [GIT PULL] efi/urgent for v5.12-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210314122134.GB27191@zn.tnic>
References: <20210314122134.GB27191@zn.tnic>
X-PR-Tracked-List-Id: <linux-efi.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210314122134.GB27191@zn.tnic>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git tags/efi-urgent-for-v5.12-rc2
X-PR-Tracked-Commit-Id: 9e9888a0fe97b9501a40f717225d2bef7100a2c1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 836d7f0572ca42ac85d649235680479740743ac6
Message-Id: <161575210405.6248.17127209945773392329.pr-tracker-bot@kernel.org>
Date:   Sun, 14 Mar 2021 20:01:44 +0000
To:     Borislav Petkov <bp@suse.de>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-efi <linux-efi@vger.kernel.org>, x86-ml <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

The pull request you sent on Sun, 14 Mar 2021 13:21:47 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git tags/efi-urgent-for-v5.12-rc2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/836d7f0572ca42ac85d649235680479740743ac6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
