Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BDD1C43334
	for <linux-efi@archiver.kernel.org>; Tue, 21 Jun 2022 18:27:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243045AbiFUS1y (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 21 Jun 2022 14:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241434AbiFUS1v (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Tue, 21 Jun 2022 14:27:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5A227CE4
        for <linux-efi@vger.kernel.org>; Tue, 21 Jun 2022 11:27:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 635BFB81B07
        for <linux-efi@vger.kernel.org>; Tue, 21 Jun 2022 18:27:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2FE63C341C4;
        Tue, 21 Jun 2022 18:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655836068;
        bh=FBWheTK/W7CNujSETBJE3ezqISpSkL1JYhuPy5GE5bc=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=McviW07VC4it5jW9fke6v4+NJwqm5JmfK7BfyNE1zUmE53N/SjhEPwpdg677fjcGv
         lvgYYYLIsYZbWIRzqgOyZp5N4v9GMMSloOeRZGeNgtgI3+6Sd+V3z9q/+aHh4SJ63L
         AAgbNW0N6EkNuU6mKyS81BCpFOqj9RYi53ximUBG5l2kOVUJXXHR/KMExz6ETaTvlv
         AyR7Da++z8TYyU0Hw28XftRjGqNWjuvmS7llp2QBdQiCpVU1LVBodUsqXtPv3quKx2
         eN4yysFbb51Rq5sTlhDCSjXv0NydNGLJ6kKxfRkjjOfVQyuZ8gAzjFezDXJxMPnOUW
         7bmwuuscZhWCg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1394FE73856;
        Tue, 21 Jun 2022 18:27:48 +0000 (UTC)
Subject: Re: [GIT PULL] EFI fixes for v5.19 #1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220621161618.3787669-1-ardb@kernel.org>
References: <20220621161618.3787669-1-ardb@kernel.org>
X-PR-Tracked-List-Id: <linux-efi.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220621161618.3787669-1-ardb@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-urgent-for-v5.19-1
X-PR-Tracked-Commit-Id: aa6d1ed107eba26f49933216cffe797253914132
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ca1fdab7fd27eb069df1384b2850dcd0c2bebe8d
Message-Id: <165583606807.899.14245384258728980209.pr-tracker-bot@kernel.org>
Date:   Tue, 21 Jun 2022 18:27:48 +0000
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     torvalds@linux-foundation.org, linux-efi@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

The pull request you sent on Tue, 21 Jun 2022 18:16:18 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-urgent-for-v5.19-1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ca1fdab7fd27eb069df1384b2850dcd0c2bebe8d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
