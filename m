Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B900C433F5
	for <linux-efi@archiver.kernel.org>; Mon, 28 Feb 2022 20:53:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiB1Uy2 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 28 Feb 2022 15:54:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiB1Uy1 (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Mon, 28 Feb 2022 15:54:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F386253
        for <linux-efi@vger.kernel.org>; Mon, 28 Feb 2022 12:53:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07EB0B81651
        for <linux-efi@vger.kernel.org>; Mon, 28 Feb 2022 20:53:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9524BC340F1;
        Mon, 28 Feb 2022 20:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646081624;
        bh=bOEfYifKYat0mji1QMzZC8cBOLRpAsT4u0B9B3Bm/C0=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=VtotH6JTjXR6YPmerMFK4u2GE2Ua4EcwWHgFLdQrPExLt639BVji5Fbpb4HUNYMZh
         g//9Ix7S5utpWMdSmwBm8AzVPWX8csziJaYJWV8hSw+CojTPmUrfkqoCoflbwdc14Z
         ZFVouacPiHEWSBbqH2UmpJSG11yhxF5wMGlRK5L3Li+MBJjPrhpQmZbazIZcr/CB13
         XP8RNB1tQgJS6vhV6jy/jT/fJFN2XkjLOPwleQVDiJThr1f8cXzMmKve1sbUdLlzsB
         iTSiGd4kTLrv0fIQMZnoOdGR+uk+Hn6C2IcTckbIrXdPI1FkY/9JzCA8KIYqn3fBKa
         2ZKP7FvaOWKvA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 783EEE5D087;
        Mon, 28 Feb 2022 20:53:44 +0000 (UTC)
Subject: Re: [GIT PULL] More EFI fixes for v5.17
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220228091256.814321-1-ardb@kernel.org>
References: <20220228091256.814321-1-ardb@kernel.org>
X-PR-Tracked-List-Id: <linux-efi.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220228091256.814321-1-ardb@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-urgent-for-v5.17-2
X-PR-Tracked-Commit-Id: 258dd902022cb10c83671176688074879517fd21
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 201b5c016f1655ead2ecc7e7e270841782cbbd0b
Message-Id: <164608162448.1515.16287030423539565333.pr-tracker-bot@kernel.org>
Date:   Mon, 28 Feb 2022 20:53:44 +0000
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     torvalds@linux-foundation.org, linux-efi@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

The pull request you sent on Mon, 28 Feb 2022 10:12:56 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-urgent-for-v5.17-2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/201b5c016f1655ead2ecc7e7e270841782cbbd0b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
