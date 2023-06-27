Return-Path: <linux-efi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02496EB64D9
	for <linux-efi@archiver.kernel.org>; Tue, 27 Jun 2023 08:18:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjF0ISG (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 27 Jun 2023 04:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbjF0ISE (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Tue, 27 Jun 2023 04:18:04 -0400
X-Greylist: delayed 1010 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 27 Jun 2023 01:17:30 PDT
Received: from cavan.codon.org.uk (irc.codon.org.uk [IPv6:2a00:1098:84:22e::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0561BCE
        for <linux-efi@vger.kernel.org>; Tue, 27 Jun 2023 01:17:30 -0700 (PDT)
Received: by cavan.codon.org.uk (Postfix, from userid 1000)
        id 412B940A40; Tue, 27 Jun 2023 09:17:06 +0100 (BST)
Date:   Tue, 27 Jun 2023 09:17:06 +0100
From:   Matthew Garrett <mjg59@srcf.ucam.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-efi@vger.kernel.org, Daniel Kiper <dkiper@net-space.pl>,
        Glenn Washburn <development@efficientek.com>
Subject: Re: [PATCH] efi/libstub: Disable PCI DMA before grabbing the EFI
 memory map
Message-ID: <20230627081706.GA20814@srcf.ucam.org>
References: <20230627074132.1016795-1-ardb@kernel.org>
 <20230627080039.GA20512@srcf.ucam.org>
 <CAMj1kXF7g92VqnjWwbp0Y9hKXfMc2iZSmvtT2B6ZEHQ3c478bA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXF7g92VqnjWwbp0Y9hKXfMc2iZSmvtT2B6ZEHQ3c478bA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Tue, Jun 27, 2023 at 10:14:16AM +0200, Ard Biesheuvel wrote:

> Not quite. It should only fail the first time if the memory map
> changed since the last call to GetMemoryMap(), and normally, this will
> only happen if some kind of asynchronous event was triggered after
> GetMemoryMap() but before ExitBootServices(). (This is why calling
> ExitBootServices() at most twice should always suffice: the first call
> disables the timer interrupt, so the second time around, no events
> will fire in the mean time)

Can't driver shutdown code also end up altering it? I've certainly had 
extremely deterministic requirements to call it twice, which doesn't 
line up terribly well with it just being down to async events.
