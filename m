Return-Path: <SRS0=jVGb=UB=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	T_DKIMWL_WL_HIGH autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AC7DC282DC
	for <linux-efi@archiver.kernel.org>; Sun,  2 Jun 2019 18:15:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23AB527947
	for <linux-efi@archiver.kernel.org>; Sun,  2 Jun 2019 18:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559499327;
	bh=Tsg1buavDITjPeuKSjvbHRnZKjj/mdn/fvQuXlST4o0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=Iz7+AxTNXA0V2LP0VJ+2nXe8a/jFzUcuvlVlz3tfVj8Ot0RB0wILhaS3LBpKC/ueC
	 3cF66dF1yr15ZzgJKy4JWtxiddkXdgXWUfEWWmT4TYZSWZoCKlXjAcL1qUP+QggOjj
	 Rg83JsnDIR16UJ5J8KrwEN7BMd0AFiSNWHpnLTqY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbfFBSPQ (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Sun, 2 Jun 2019 14:15:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726984AbfFBSPP (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Sun, 2 Jun 2019 14:15:15 -0400
Subject: Re: [GIT PULL] EFI fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559499315;
        bh=Tsg1buavDITjPeuKSjvbHRnZKjj/mdn/fvQuXlST4o0=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=MSff7EL6gC7vnkHN+1z2FjAVqSZT7Ab9tvk0I1sWETGVYf8R7cpjF+rzfFCRdarAz
         88FxilqFfKafZ/o0dP2KUj3wtpqsJ7kOzWDXbLsAhyrdeZq+YR/MHouGwvK1CU01OD
         lr9waLF2euE9z9ZyOL/VtZb5vTv1GMvizF9PLre8=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190602173519.GA29372@gmail.com>
References: <20190602173519.GA29372@gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190602173519.GA29372@gmail.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
 efi-urgent-for-linus
X-PR-Tracked-Commit-Id: 88447c5b93d98be847f428c39ba589779a59eb83
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: af0424522dbb235ee7f1eb84bce074004c9d8b51
Message-Id: <155949931513.4617.9038691216802497198.pr-tracker-bot@kernel.org>
Date:   Sun, 02 Jun 2019 18:15:15 +0000
To:     Ingo Molnar <mingo@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        James Morse <james.morse@arm.com>, linux-efi@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

The pull request you sent on Sun, 2 Jun 2019 19:35:19 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git efi-urgent-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/af0424522dbb235ee7f1eb84bce074004c9d8b51

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
