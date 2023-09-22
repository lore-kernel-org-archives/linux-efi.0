Return-Path: <linux-efi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F3E8CD4846
	for <linux-efi@archiver.kernel.org>; Fri, 22 Sep 2023 16:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbjIVQna (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 22 Sep 2023 12:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232832AbjIVQnX (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Fri, 22 Sep 2023 12:43:23 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8AC919A
        for <linux-efi@vger.kernel.org>; Fri, 22 Sep 2023 09:43:17 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 83A1FC433CA;
        Fri, 22 Sep 2023 16:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695400997;
        bh=44XnfCKrNLiu6R5FlAQEciGMs6CervT02v5A9UhlLp0=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ePVnw4aaMFB5JBCrBl+JL+fWPQf30LlF80mWvKxT93p8R4dVGYlYn+1c952qm8CyQ
         lhS4TqFO1Y0tp01xFCVxk2z3IjkC0aHJX3SwYVOFs0+84dqF4gVZT0sbgzV7UDooIx
         RNY3d3UMUavfiwpm7IddGxgRV8bZ6V4xTlXw5X099WIkBOKsv2G9Pj2KjxG6BdGC9o
         ZM2uCaJ2ZOpVRdk8K85cFelynkqo66cncoCbf/YOZ81sK1jSWXxXPamr8Iu/wM+mMs
         ueB6EvVScUifLquL0pLcQKiRhSb5MDxkeYEccWDrF7Lq63cejmMMFgNbbR6AIxeIFF
         GZVhPoMMhilUw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6CDC1C04DD9;
        Fri, 22 Sep 2023 16:43:17 +0000 (UTC)
Subject: Re: [GIT PULL] EFI fixes for v6.6 (#2)
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230922094027.204834-1-ardb@kernel.org>
References: <20230922094027.204834-1-ardb@kernel.org>
X-PR-Tracked-List-Id: <linux-efi.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230922094027.204834-1-ardb@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-fixes-for-v6.6-2
X-PR-Tracked-Commit-Id: 8dbe33956d96c9d066ef15ca933ede30748198b2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: dc912ba91b7e2fa74650a0fc22cccf0e0d50f371
Message-Id: <169540099744.17578.161467369158201850.pr-tracker-bot@kernel.org>
Date:   Fri, 22 Sep 2023 16:43:17 +0000
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     torvalds@linux-foundation.org, linux-efi@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

The pull request you sent on Fri, 22 Sep 2023 09:40:27 +0000:

> git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-fixes-for-v6.6-2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/dc912ba91b7e2fa74650a0fc22cccf0e0d50f371

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
