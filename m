Return-Path: <SRS0=Yxzj=U4=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C346BC4321A
	for <linux-efi@archiver.kernel.org>; Sat, 29 Jun 2019 11:45:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CE4821738
	for <linux-efi@archiver.kernel.org>; Sat, 29 Jun 2019 11:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561808706;
	bh=WhH3syw+6GV0de9bgChvhW9Fh1oXAWMn37HedkAWaQY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=nG2GSX8FtZnAV48xZm4APL8nxeOXCoSsoyE3xs4LYII7G1ExeUMl+owJhAyg6d5Id
	 lR3gR9Y+5YLQyEF49d6APEqgBwG/jIocniwGr2vP7UEHyUn7sM2qbbhCcwp6che5f/
	 4OJvZKaD1JZFqaTro6n8MHnozwfPNyJ0ZiJq7y4E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbfF2LpG (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Sat, 29 Jun 2019 07:45:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726874AbfF2LpF (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Sat, 29 Jun 2019 07:45:05 -0400
Subject: Re: [GIT PULL] EFI fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561808705;
        bh=WhH3syw+6GV0de9bgChvhW9Fh1oXAWMn37HedkAWaQY=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=QyG54Kd0Pa16mpxjvYF6OKhlO4Sdzw5qUjTLA7iHDkCVuuVKSVLFlzCo0VEMHqrcO
         b736MQilXG1GguIYBneMQUgakIG8SRrcc7cvVNjRAG/XDaIyd4X+pYc6yzlvprM+JO
         2quU57P0dJU/hV22sThOoiN84QNu//0Z/tFJ5Ysc=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190629082354.GA128031@gmail.com>
References: <20190629082354.GA128031@gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190629082354.GA128031@gmail.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
 efi-urgent-for-linus
X-PR-Tracked-Commit-Id: 48c7d73b2362ce61503551ad70052617b3e8857d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a7211bc9f3d50d77efe77c332b269458a94fcfd2
Message-Id: <156180870500.30344.16122232121586033322.pr-tracker-bot@kernel.org>
Date:   Sat, 29 Jun 2019 11:45:05 +0000
To:     Ingo Molnar <mingo@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-efi@vger.kernel.org
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

The pull request you sent on Sat, 29 Jun 2019 10:23:54 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git efi-urgent-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a7211bc9f3d50d77efe77c332b269458a94fcfd2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
