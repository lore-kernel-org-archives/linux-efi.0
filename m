Return-Path: <linux-efi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7655EC54E76
	for <linux-efi@archiver.kernel.org>; Tue, 17 Jan 2023 17:16:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234734AbjAQRQM (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 17 Jan 2023 12:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235151AbjAQRPf (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Tue, 17 Jan 2023 12:15:35 -0500
Received: from cavan.codon.org.uk (cavan.codon.org.uk [176.126.240.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B6C4B184
        for <linux-efi@vger.kernel.org>; Tue, 17 Jan 2023 09:14:58 -0800 (PST)
Received: by cavan.codon.org.uk (Postfix, from userid 1000)
        id 350A6424A2; Tue, 17 Jan 2023 17:14:57 +0000 (GMT)
Date:   Tue, 17 Jan 2023 17:14:57 +0000
From:   Matthew Garrett <mjg59@srcf.ucam.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-efi@vger.kernel.org, Jeremy Kerr <jk@ozlabs.org>
Subject: Re: [PATCH] efi: Remove Matthew Garrett as efivarfs maintainer
Message-ID: <20230117171457.GA11696@srcf.ucam.org>
References: <20230117170742.1461185-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117170742.1461185-1-ardb@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Tue, Jan 17, 2023 at 06:07:42PM +0100, Ard Biesheuvel wrote:
> Matthew Garrett is still listed as a efivarfs co-maintainer, but the
> email address bounces, and Matt is no longer involved in maintaining
> this code.
> 
> So let's remove Matt as a efivarfs co-maintainer from MAINTAINERS.
> Thanks for all the hard work!
> 
> Cc: Jeremy Kerr <jk@ozlabs.org>
> Cc: Matthew Garrett <mjg59@srcf.ucam.org>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

ACKed-by: Matthew Garrett <mjg59@srcf.ucam.org>
