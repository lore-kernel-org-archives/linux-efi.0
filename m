Return-Path: <linux-efi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3644FC54EBD
	for <linux-efi@archiver.kernel.org>; Fri, 13 Jan 2023 16:43:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjAMQnB (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 13 Jan 2023 11:43:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbjAMQm1 (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Fri, 13 Jan 2023 11:42:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B4E05472B
        for <linux-efi@vger.kernel.org>; Fri, 13 Jan 2023 08:41:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECE01622A5
        for <linux-efi@vger.kernel.org>; Fri, 13 Jan 2023 16:41:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 610F1C433EF;
        Fri, 13 Jan 2023 16:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673628068;
        bh=RfhkiRwrHEFlqXssRahU6bzLskMPE/KItwHxg/opApY=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=nH8A4Lw83sQkHDje8z3c/kRnYZ7oKrU9DS/5Y/UhZ8MpfcPrOE7mS/AppaGndgL8Q
         See0Gz3LXTdziAYwb18xuHkS3LTL3geLDTH5CU8Hrfg6dzQOxMxno0bP0snuaCV8Ov
         vZBdF0BqrIixySfoQ0t8BCnLE6n8lr26IoF4164vK0mGByZ0eGhEkj6yUSV18hqR77
         puqvHBQ6G5//meHyNiDbBK5we+krhIhOJwEf+8ZjntvnUg94Bqu3u+bwJIIdi338g1
         TuGs2e2gYL91AI9ILiDk43Mc598KDfRy9UD3jivjcbbdxT5lKOgdgK/JgxigbcdBRS
         ZP5tTz3Jfp8gA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 41A52C395CA;
        Fri, 13 Jan 2023 16:41:08 +0000 (UTC)
Subject: Re: [GIT PULL] EFI fixes for v6.2 #1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230113163133.4083780-1-ardb@kernel.org>
References: <20230113163133.4083780-1-ardb@kernel.org>
X-PR-Tracked-List-Id: <linux-efi.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230113163133.4083780-1-ardb@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-fixes-for-v6.2-1
X-PR-Tracked-Commit-Id: d3f450533bbcb6dd4d7d59cadc9b61b7321e4ac1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0bf913e07b377cfc288cfe488ca30b7d67059d8a
Message-Id: <167362806826.11257.14722831252861288493.pr-tracker-bot@kernel.org>
Date:   Fri, 13 Jan 2023 16:41:08 +0000
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     torvalds@linux-foundation.org, linux-efi@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

The pull request you sent on Fri, 13 Jan 2023 17:31:33 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-fixes-for-v6.2-1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0bf913e07b377cfc288cfe488ca30b7d67059d8a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
