Return-Path: <SRS0=plmu=TG=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65EC2C04A6B
	for <linux-efi@archiver.kernel.org>; Mon,  6 May 2019 23:41:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31C4D2087F
	for <linux-efi@archiver.kernel.org>; Mon,  6 May 2019 23:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1557186107;
	bh=V4ixEGbonExk2RLE1nQcGlQFE1f0NK/exeq9Pp+mjAw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=VAeGRCHqEK2wKIGtUGy9nBgXyRizgmNBXGdz5/4K9Aqj/dpoEKV4JTJgMcZLtzsKi
	 ZVY1KzfyVpBebY8VSiEb7Ijgu5xXkxy2XtWcZhXkE9KSyEaX1QCLLKyiI7DPTTXjbB
	 Ad46XLmyekesLn5+9kBMug3s8Cma+7YNUb4fuETM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbfEFXkH (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 6 May 2019 19:40:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:51758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727070AbfEFXkH (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Mon, 6 May 2019 19:40:07 -0400
Subject: Re: [GIT PULL] EFI changes for v5.2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557186006;
        bh=V4ixEGbonExk2RLE1nQcGlQFE1f0NK/exeq9Pp+mjAw=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=E0ZtzNJkUHgLHznRrL2ZrTTlwJROiMl9pybANJJwNEDywkTKdLUfXD5jVy0R8/BoD
         CvoinwuST5A0oe0ALOWv1xIKJby3GsRVqQT1TQSV/KDB9IyXm/fHhoQ96+geZOQUXX
         1CoGzvEa8oQg0j5DomDCKJLjbFdjVIxdoUa54qcE=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190506081759.GA30024@gmail.com>
References: <20190506081759.GA30024@gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190506081759.GA30024@gmail.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git efi-core-for-linus
X-PR-Tracked-Commit-Id: 02562d0ca1084a688ac5c92e0e92947f62f13093
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d90dcc1f14555c62a32bc15c86c66d1d5444b5cb
Message-Id:
 <155718600656.9113.10517083269940973115.pr-tracker-bot@kernel.org>
Date:   Mon, 06 May 2019 23:40:06 +0000
To:     Ingo Molnar <mingo@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20190506234006.D29IgwKTvPCBPjd0oAgV0w0I1HyYg38HTlBbDTJRMJI@z>

The pull request you sent on Mon, 6 May 2019 10:17:59 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git efi-core-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d90dcc1f14555c62a32bc15c86c66d1d5444b5cb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
