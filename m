Return-Path: <linux-efi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2140CEB64DD
	for <linux-efi@archiver.kernel.org>; Tue, 27 Jun 2023 08:00:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbjF0IAr (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 27 Jun 2023 04:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbjF0IAq (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Tue, 27 Jun 2023 04:00:46 -0400
Received: from cavan.codon.org.uk (cavan.codon.org.uk [176.126.240.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 251171716
        for <linux-efi@vger.kernel.org>; Tue, 27 Jun 2023 01:00:43 -0700 (PDT)
Received: by cavan.codon.org.uk (Postfix, from userid 1000)
        id 13EF940A40; Tue, 27 Jun 2023 09:00:39 +0100 (BST)
Date:   Tue, 27 Jun 2023 09:00:39 +0100
From:   Matthew Garrett <mjg59@srcf.ucam.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-efi@vger.kernel.org, Daniel Kiper <dkiper@net-space.pl>,
        Glenn Washburn <development@efficientek.com>
Subject: Re: [PATCH] efi/libstub: Disable PCI DMA before grabbing the EFI
 memory map
Message-ID: <20230627080039.GA20512@srcf.ucam.org>
References: <20230627074132.1016795-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230627074132.1016795-1-ardb@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Tue, Jun 27, 2023 at 09:41:32AM +0200, Ard Biesheuvel wrote:

> However, the stub will invoke DisconnectController() on all endpoints
> downstream of the PCI bridges it disables, and this may affect the
> layout of the EFI memory map, making it likely that ExitBootServices()
> will fail the first time around, and that the EFI memory map needs to be
> reloaded.

Isn't it always likely that ExitBootServices() will fail the first time 
around, but disable_early_pci_dma makes it more likely it'll have 
changed by enough that we need a bigger map? Other than that potential 
quibble over the changelog,

Acked-by: Matthew Garrett <mjg59@srcf.ucam.org>
