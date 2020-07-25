Return-Path: <SRS0=32gl=BE=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB4ACC433E0
	for <linux-efi@archiver.kernel.org>; Sat, 25 Jul 2020 22:30:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE6C720714
	for <linux-efi@archiver.kernel.org>; Sat, 25 Jul 2020 22:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595716205;
	bh=5eei+xGbwhPCgRFXPyLEluUSF8hdPtvhc71bTraY59s=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=0tt4N+ZOJHJrml7FaoEW+hE1X0lg+SVAti1+Fj+1saO1hGcd9Upouksmcuierxq+M
	 UxG+0CAj7QkcNSmw53sHB49KNxAHdrExN2SzgVDjCLdIXr10axC9hj8xua53P3J5ZN
	 rO1hGA5SUK+o0Pg+27Y+7DiACPxDz8crWk/bcPU8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgGYWaF (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Sat, 25 Jul 2020 18:30:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728029AbgGYWaE (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Sat, 25 Jul 2020 18:30:04 -0400
Subject: Re: [GIT PULL] EFI fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595716204;
        bh=5eei+xGbwhPCgRFXPyLEluUSF8hdPtvhc71bTraY59s=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=kMEYfnvczl/wZ6Te4igQs4l4weuNwqnpnXiGZk2z/pVblBXMjzrht7FyL5qQ7oFmi
         BEntS77jkCD/s10QqCTpfe4GLuyhFbPgr5338a6lak4ladgvebIXoMA5vDu/dfY24N
         qKLRHRUiWK3rekZo3zuyd40Q2VgQojLaEwt16F6k=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200725103259.GA823698@gmail.com>
References: <20200725103259.GA823698@gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200725103259.GA823698@gmail.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
 efi-urgent-2020-07-25
X-PR-Tracked-Commit-Id: 74f85551666fe40bd739e95b5ecb20f53f8ad4df
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 17baa442864254cb2aadf3a4d668c0f81d2f07c5
Message-Id: <159571620453.7388.11647176182336327209.pr-tracker-bot@kernel.org>
Date:   Sat, 25 Jul 2020 22:30:04 +0000
To:     Ingo Molnar <mingo@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        linux-efi@vger.kernel.org
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

The pull request you sent on Sat, 25 Jul 2020 12:32:59 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git efi-urgent-2020-07-25

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/17baa442864254cb2aadf3a4d668c0f81d2f07c5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
