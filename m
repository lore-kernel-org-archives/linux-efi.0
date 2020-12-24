Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32FD0C43381
	for <linux-efi@archiver.kernel.org>; Thu, 24 Dec 2020 22:00:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F493233FB
	for <linux-efi@archiver.kernel.org>; Thu, 24 Dec 2020 22:00:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729080AbgLXWAC (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 24 Dec 2020 17:00:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:40294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729004AbgLXWAB (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Thu, 24 Dec 2020 17:00:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 3264722AAA;
        Thu, 24 Dec 2020 21:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608847161;
        bh=zFzvl8PM7F7o5T15x551T5BKp7NJsTB/1aVFacxanLU=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=fWOPMQhs1ZRvc8ko8Fsrs9Wgok0nC2q//aaNJWpZU0oYxqtWjH5lK7vaQT4M7GcLh
         fKGRzGpwclHAAPvcKiDAr9LGgElzEri+wvb9xnBkcfMdrBc0m+XaHht8Tq0d+oJ6on
         ODprplmj0uUJmIH6u408RTdAIDCp0TfoAKfOaDSUUSXklqS9wdqeur8oTawPRJ34Yn
         8YFMBxP0EFsQBpd5KvAVR8K4wccohUzR2EvVM94KTRbommtqJ/ug7srorQqGSANHBa
         xJt4GAwfcRGZciPx1M8XDaU4EA9muZER2cpi5N72mWoo1UggKixMVeNbh4tKNE9KDH
         5nHxZWzZVfTCA==
Subject: Re: [GIT PULL] efi/core for v5.11
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201224090406.GA6169@zn.tnic>
References: <20201224090406.GA6169@zn.tnic>
X-PR-Tracked-List-Id: <linux-efi.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201224090406.GA6169@zn.tnic>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git tags/efi_updates_for_v5.11
X-PR-Tracked-Commit-Id: 3dcb8b53cbd2cc5618863b19ef00f8ea82f27e83
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4a1106afeed26012de69f4837b8d7a8b83f28489
Message-Id: <160884716117.31605.3859632320802510053.pr-tracker-bot@kernel.org>
Date:   Thu, 24 Dec 2020 21:59:21 +0000
To:     Borislav Petkov <bp@suse.de>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-efi <linux-efi@vger.kernel.org>, x86-ml <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

The pull request you sent on Thu, 24 Dec 2020 10:04:06 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git tags/efi_updates_for_v5.11

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4a1106afeed26012de69f4837b8d7a8b83f28489

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
