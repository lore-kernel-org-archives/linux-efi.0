Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E72AC19F2B
	for <linux-efi@archiver.kernel.org>; Wed,  3 Aug 2022 22:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238952AbiHCW3n (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 3 Aug 2022 18:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238957AbiHCW3e (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Wed, 3 Aug 2022 18:29:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB6B5E308
        for <linux-efi@vger.kernel.org>; Wed,  3 Aug 2022 15:29:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC67261633
        for <linux-efi@vger.kernel.org>; Wed,  3 Aug 2022 22:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 599BEC433D6;
        Wed,  3 Aug 2022 22:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659565766;
        bh=qwtDIZ8TAS2LVTNyy4+vCbu3wCtRhQSpoGG7j50Tiq8=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ckEykkMnZti/i5KWAqoeozTx2eEPvPAYJ2BJEFioGp8XTwxtO+2OSOp5aouC6eJZZ
         /KEYLvjFMBzQMOxXmSSqOyQhA45tz94CYRd34nI9aWcJ6OKn56G/zRhDdgT5h4Jag/
         A9FzRvpznFL6Ur+ow3+ksHV8u/ETcnKtLAeqsjOtm3jnZKqPrsgV4dknLS+u7tNHQI
         Fex/YBN5n6gDRDfK/VPyl8TwPGRPgVgpU/B9NbxzbnrZz7PtcUvjEPMxS7hBm4THYy
         apHb9qry44hUoFaXXj6vVrJuBI9g34vyQimS0cZm4qGxrXsuCK7YSHgVMnbSX9EUqz
         AmxrMU1S+M5UQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4907AC43140;
        Wed,  3 Aug 2022 22:29:26 +0000 (UTC)
Subject: Re: [GIT PULL 2/2] EFI removal of efivars sysfs driver
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220801134117.1605678-3-ardb@kernel.org>
References: <20220801134117.1605678-1-ardb@kernel.org> <20220801134117.1605678-3-ardb@kernel.org>
X-PR-Tracked-List-Id: <linux-efi.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220801134117.1605678-3-ardb@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-efivars-removal-for-v5.20
X-PR-Tracked-Commit-Id: 2d82e6227ea189c0589e7383a36616ac2a2d248c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ab17c0cd376f240bb8ead6f03be2bb4748bbc61a
Message-Id: <165956576629.24057.9404704797376726916.pr-tracker-bot@kernel.org>
Date:   Wed, 03 Aug 2022 22:29:26 +0000
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     torvalds@linux-foundation.org, linux-efi@vger.kernel.org,
        keescook@chromium.org, Ard Biesheuvel <ardb@kernel.org>
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

The pull request you sent on Mon,  1 Aug 2022 15:41:17 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-efivars-removal-for-v5.20

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ab17c0cd376f240bb8ead6f03be2bb4748bbc61a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
