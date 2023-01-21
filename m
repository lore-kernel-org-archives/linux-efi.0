Return-Path: <linux-efi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 582A7C004D4
	for <linux-efi@archiver.kernel.org>; Sat, 21 Jan 2023 13:20:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjAUNU1 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Sat, 21 Jan 2023 08:20:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjAUNU0 (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Sat, 21 Jan 2023 08:20:26 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B5C23648
        for <linux-efi@vger.kernel.org>; Sat, 21 Jan 2023 05:20:25 -0800 (PST)
Received: from [2a02:8108:963f:de38:4bc7:2566:28bd:b73c]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pJDnC-0003vx-GU; Sat, 21 Jan 2023 14:20:23 +0100
Message-ID: <0eabbe98-db6e-b5db-ca5b-3f212bf2f734@leemhuis.info>
Date:   Sat, 21 Jan 2023 14:20:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Is there a known boot failure with 6.2-rc and the Intel SDV EFI
 systems?
Content-Language: en-US, de-DE
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-efi@vger.kernel.org,
        Linux kernel regressions list <regressions@lists.linux.dev>
References: <f2503170d12dc567c00998d4e72ba806f7677730.camel@HansenPartnership.com>
From:   "Linux kernel regression tracking (#adding)" 
        <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <f2503170d12dc567c00998d4e72ba806f7677730.camel@HansenPartnership.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1674307225;d3cbbc87;
X-HE-SMSGID: 1pJDnC-0003vx-GU
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

[TLDR: I'm adding this report to the list of tracked Linux kernel
regressions; the text you find below is based on a few templates
paragraphs you might have encountered already in similar form.
See link in footer if these mails annoy you.]

[CCing the regression list, as it should be in the loop for regressions:
https://docs.kernel.org/admin-guide/reporting-regressions.html]

On 20.01.23 00:13, James Bottomley wrote:
> I've got a Rainbow Bridge SDV I mostly use for TPM work, and I haven't
> updated it in a while.  Today I found that the recent 6.2-rc4 kernel
> won't boot and won't emit any kernel messages signalling a failure
> somewhere in the handoff code.  I did put some EFI boot stub prints in
> and verified it gets all the way to exit_boot_services before the
> problem, so it smells like it fails initializing the EFI console for
> runtime.  I've also verified that v6.1 release works just fine, so it
> looks like something that went into EFI in the recent merge window. 
> I'm starting to bisect now, but thought I'd ask in case anyone else has
> already debugged this.

Thanks for the report. To be sure the issue doesn't fall through the
cracks unnoticed, I'm adding it to regzbot, the Linux kernel regression
tracking bot:

#regzbot ^introduced v6.1..v6.2-rc4
#regzbot title boot failure with 6.2 on Intel SDV EFI systems
#regzbot ignore-activity

This isn't a regression? This issue or a fix for it are already
discussed somewhere else? It was fixed already? You want to clarify when
the regression started to happen? Or point out I got the title or
something else totally wrong? Then just reply and tell me -- ideally
while also telling regzbot about it, as explained by the page listed in
the footer of this mail.

Developers: When fixing the issue, remember to add 'Link:' tags pointing
to the report (the parent of this mail). See page linked in footer for
details.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
That page also explains what to do if mails like this annoy you.
