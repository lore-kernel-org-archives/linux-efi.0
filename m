Return-Path: <SRS0=R7qd=CY=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6175C433E2
	for <linux-efi@archiver.kernel.org>; Tue, 15 Sep 2020 22:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A158720872
	for <linux-efi@archiver.kernel.org>; Tue, 15 Sep 2020 22:18:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="WOwquMcU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbgIOWSM (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 15 Sep 2020 18:18:12 -0400
Received: from mail.skyhub.de ([5.9.137.197]:35804 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727722AbgIOQdW (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Tue, 15 Sep 2020 12:33:22 -0400
Received: from zn.tnic (p200300ec2f0e42006096e946d741c4e4.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:4200:6096:e946:d741:c4e4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7EFAC1EC0328;
        Tue, 15 Sep 2020 18:33:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1600187598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=ZWwBzofbLwaO1lqUGe+0uSmnKjSrhBMl5LKNuGBjotY=;
        b=WOwquMcUbe2yULVzAwTw4t0gqRs3C/n65jZqTEGlEt3lWGoWQjEpgrEGKOHANYtlGitY2Q
        uIEqQxxaWIIMWBFVsBepzL1mqEJueMCtafqZjhy0etuDR+dO110j5sEfGtoKu5ltzQ0Iv+
        UoQAgaZEi2b8SVyjillCNHouaQQ95og=
Date:   Tue, 15 Sep 2020 18:33:12 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Alex Kluver <alex.kluver@hpe.com>
Cc:     linux-edac@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, ardb@kernel.org, mchehab@kernel.org,
        russ.anderson@hpe.com, dimitri.sivanich@hpe.com,
        kluveralex@gmail.com
Subject: Re: [PATCH v2 1/2] edac,ghes,cper: Add Row Extension to Memory Error
 Record
Message-ID: <20200915163312.GO14436@zn.tnic>
References: <20200819143544.155096-1-alex.kluver@hpe.com>
 <20200819143544.155096-2-alex.kluver@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200819143544.155096-2-alex.kluver@hpe.com>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Wed, Aug 19, 2020 at 09:35:43AM -0500, Alex Kluver wrote:
> Memory errors could be printed with incorrect row values since the DIMM
> size has outgrown the 16 bit row field in the CPER structure. UEFI
> Specification Version 2.8 has increased the size of row by allowing it to
> use the first 2 bits from a previously reserved space within the structure.
> 
> When needed, add the extension bits to the row value printed.
> 
> Based on UEFI 2.8 Table 299. Memory Error Record
> 
> Reviewed-by: Kyle Meyer <kyle.meyer@hpe.com>
> Reviewed-by: Steve Wahl <steve.wahl@hpe.com>
> Tested-by: Russ Anderson <russ.anderson@hpe.com>
> Signed-off-by: Alex Kluver <alex.kluver@hpe.com>
> ---
> 
> v1 -> v2:
>    * Add static inline cper_get_mem_extension() to make it 
>     more readable, as suggested by Borislav Petkov.
> 
>    * Add second patch for bank field, bank group, and chip id.
> 
> ---
>  drivers/edac/ghes_edac.c    |  8 ++++++--
>  drivers/firmware/efi/cper.c |  9 +++++++--
>  include/linux/cper.h        | 16 ++++++++++++++--
>  3 files changed, 27 insertions(+), 6 deletions(-)

For the EDAC bits:

Acked-by: Borislav Petkov <bp@suse.de>

Also, I could take both through the EDAC tree, if people prefer.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
