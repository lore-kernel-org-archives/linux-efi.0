Return-Path: <SRS0=XvGZ=DG=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0D46C4727C
	for <linux-efi@archiver.kernel.org>; Tue, 29 Sep 2020 16:58:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47DC0208FE
	for <linux-efi@archiver.kernel.org>; Tue, 29 Sep 2020 16:58:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="ouTbW3nI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbgI2Q6w (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 29 Sep 2020 12:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728385AbgI2Q6v (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Tue, 29 Sep 2020 12:58:51 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36AEAC061755
        for <linux-efi@vger.kernel.org>; Tue, 29 Sep 2020 09:58:51 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0ead009e71cc6c0304d124.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:ad00:9e71:cc6c:304:d124])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 777351EC04DA;
        Tue, 29 Sep 2020 18:58:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1601398727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=/+joilbWVu+PqdpK3JadiPL3zdrmuS1I9gz1BFhWZXQ=;
        b=ouTbW3nILQHICItAHQ8WZH63KZm6osga3kL/LI4oy3X5eS9FLOvy0irz4JoJQzZypC1LwQ
        E1pR6VuSOXIAA7PQMEvPuK0em5SWsxNmksOsFw2nuiiO/cqvjAPAwyeUlE+bLdp5hJT6kN
        +gMF2mt497s2FrquDXpHICALlAumIDM=
Date:   Tue, 29 Sep 2020 18:58:40 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-efi@vger.kernel.org, Lenny Szubowicz <lszubowi@redhat.com>,
        Arvind Sankar <nivedita@alum.mit.edu>
Subject: Re: [PATCH] efi: mokvar-table: fix some issues in new code
Message-ID: <20200929165840.GI21110@zn.tnic>
References: <20200924160546.8967-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200924160546.8967-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Thu, Sep 24, 2020 at 06:05:46PM +0200, Ard Biesheuvel wrote:
> Fix a couple of issues in the new mokvar-table handling code, as
> pointed out by Arvind and Boris:
> - don't bother checking the end of the physical region against the start
>   address of the mokvar table,
> - ensure that we enter the loop with err = -EINVAL,
> - replace size_t with unsigned long to appease pedantic type equality
>   checks.
> 
> Cc: Lenny Szubowicz <lszubowi@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Arvind Sankar <nivedita@alum.mit.edu>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  drivers/firmware/efi/mokvar-table.c | 25 +++++++++++--------------
>  1 file changed, 11 insertions(+), 14 deletions(-)

i386 allmodconfig looks good.

Tested-by: Borislav Petkov <bp@suse.de>

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
