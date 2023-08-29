Return-Path: <linux-efi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86773C71153
	for <linux-efi@archiver.kernel.org>; Tue, 29 Aug 2023 00:24:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234592AbjH2AX4 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 28 Aug 2023 20:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234666AbjH2AXp (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Mon, 28 Aug 2023 20:23:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5CE107
        for <linux-efi@vger.kernel.org>; Mon, 28 Aug 2023 17:23:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE3BA62FF0
        for <linux-efi@vger.kernel.org>; Tue, 29 Aug 2023 00:23:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1D5D1C433C7;
        Tue, 29 Aug 2023 00:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693268622;
        bh=YEQC4t73Sm+p7mB2sTyJIf4N5lCrV9CioaSKMvPNyWI=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=W/23mJipZW4yJPApNhLtCh3l/Y1Hl6qfX7fcEizKLZo5k239ehjuMIpkugry4CDo/
         w18b8v/x8lzVwJo31qGb7l3DWDs9KbPo5rvnaCghLkFD8GkJMg5r/DECNraZrSSz+k
         hkPFTYBmCBs2JWmESJ6vPSDdnQZiEcxDysKmykCNE4RkcSS9o3XFm+cbIyBIMmWTYx
         zZm5kz6WK0523wYCxGckgkQIXC3lfQ4jMWREwahT0HjdiS8eutsA8C56ulMxffTbev
         QLFm3pWECx/NpXOMsKdYVoDwVCeqWQzVBPbNEeboBwXrrWzl8r9dL5sy84CchVKgsU
         nzDPbmusttLHg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 03E0AC3274C;
        Tue, 29 Aug 2023 00:23:42 +0000 (UTC)
Subject: Re: [GIT PULL] EFI updates for v6.6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230828111229.107143-1-ardb@kernel.org>
References: <20230828111229.107143-1-ardb@kernel.org>
X-PR-Tracked-List-Id: <linux-efi.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230828111229.107143-1-ardb@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-next-for-v6.6
X-PR-Tracked-Commit-Id: b691118f2c44d16b84fc65b8147b33620eb18cac
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d7dd9b449fac8616bafe9afb9c20948797d6a0ad
Message-Id: <169326862200.9848.9553024853412735911.pr-tracker-bot@kernel.org>
Date:   Tue, 29 Aug 2023 00:23:42 +0000
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     torvalds@linux-foundation.org, linux-efi@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

The pull request you sent on Mon, 28 Aug 2023 13:12:29 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-next-for-v6.6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d7dd9b449fac8616bafe9afb9c20948797d6a0ad

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
