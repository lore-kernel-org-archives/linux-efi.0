Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6B5FC433DB
	for <linux-efi@archiver.kernel.org>; Sun, 21 Feb 2021 05:08:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7C4E64ED6
	for <linux-efi@archiver.kernel.org>; Sun, 21 Feb 2021 05:08:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbhBUFIL (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Sun, 21 Feb 2021 00:08:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:44126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230017AbhBUFIB (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Sun, 21 Feb 2021 00:08:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D2B6E64F1C;
        Sun, 21 Feb 2021 05:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613883996;
        bh=tKRbqpf46wcCCqBElAfcx3fePuX6EX15JespR7zdbI0=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=U0znlbiowWj81nIzyXHp9ZMSXz3Ies2qVmMRyq7r4NlggPJ9jLVfuw36xqPI0UBHU
         7EyRrBSJnNqBCN5SINDG3RfpFsWMdcin56ClaYFRJDWaTceenR6/lUKtDtlG3rsz0e
         eTiaq4LEMFw/7NztpkY95cHJzNtBTC2wPD8gqV0nyII3RCwe3DmZ1ECFpc5Ugrslla
         vNQEJCMZE7IiUBJ48LuNfE9vDNYdFFwGjrTFotcIALug+jk1Y2EfWIg2MOcoerUm1C
         xQ7/aAsc23iIGkkTRtcdErQOGhn1LwQLztj9cU4KRwukzWLbCku4h/LefBC/EIsV3O
         cTuLKXptmZ1bw==
Subject: Re: [GIT PULL] EFI updates for v5.12
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210215124426.GG7265@zn.tnic>
References: <20210215124426.GG7265@zn.tnic>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210215124426.GG7265@zn.tnic>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git tags/efi-next-for-v5.12
X-PR-Tracked-Commit-Id: 1c761ee9da1ac6ba7e40d14457fac94c87eaff35
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 70cd33d34c6026cbc2efb172f8063fccb2ebeb9a
Message-Id: <161388399683.9594.4152557529454858643.pr-tracker-bot@kernel.org>
Date:   Sun, 21 Feb 2021 05:06:36 +0000
To:     Borislav Petkov <bp@suse.de>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        x86-ml <x86@kernel.org>, linux-efi <linux-efi@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

The pull request you sent on Mon, 15 Feb 2021 13:44:26 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git tags/efi-next-for-v5.12

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/70cd33d34c6026cbc2efb172f8063fccb2ebeb9a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
