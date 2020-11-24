Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9201C2D0E4
	for <linux-efi@archiver.kernel.org>; Tue, 24 Nov 2020 21:32:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 382EF20866
	for <linux-efi@archiver.kernel.org>; Tue, 24 Nov 2020 21:32:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=natalenko.name header.i=@natalenko.name header.b="YemTNNq4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732484AbgKXVcJ (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 24 Nov 2020 16:32:09 -0500
Received: from vulcan.natalenko.name ([104.207.131.136]:46980 "EHLO
        vulcan.natalenko.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732361AbgKXVcJ (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Tue, 24 Nov 2020 16:32:09 -0500
X-Greylist: delayed 458 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Nov 2020 16:32:08 EST
Received: from mail.natalenko.name (vulcan.natalenko.name [IPv6:fe80::5400:ff:fe0c:dfa0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 0FD6F8AAF01;
        Tue, 24 Nov 2020 22:24:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1606253068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ef6cqFP5rtCRJRsC0pbk1fWvr/gryXZqDbAGKXuGsf0=;
        b=YemTNNq45rDxGydtNUuLfNISH2jCVhRnhFHbWWaQkIHyBHC8z5H2mHBnJJgQgB3Yu8chNo
        QHt/ssDLKmNm+6NK2wW1maqb6n4VypVcLAjoQRoROic98FDJzj+inNcewLtxuhOXD22zTT
        4KnZC8NDVQfOTy9/M4k7aLYpgQAY+qc=
MIME-Version: 1.0
Date:   Tue, 24 Nov 2020 22:24:27 +0100
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     David Laight <David.Laight@aculab.com>,
        linux-efi <linux-efi@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        matthew.garrett@nebula.com, jk@ozlabs.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Oops (probably) unmounting /oldroot/firmware/efi/efivars.
In-Reply-To: <CAMj1kXHhetomAx4Kd5McnvZQev9j1d-C1Og7h+J7V009WTiwxA@mail.gmail.com>
References: <5f31cde519b941308412b3849197ee7c@AcuMS.aculab.com>
 <CAMj1kXHhetomAx4Kd5McnvZQev9j1d-C1Og7h+J7V009WTiwxA@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <c4c57a4b65d57bb7b2e87870a92558a5@natalenko.name>
X-Sender: oleksandr@natalenko.name
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Hi.

On 24.11.2020 15:23, Ard Biesheuvel wrote:
> Surely caused by
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/fs/efivarfs?id=fe5186cf12e30facfe261e9be6c7904a170bd822

This also soaked through the stable queue into v5.9.11, and now the same 
BUG is triggered in the latest stable kernel.

/cc Greg

-- 
   Oleksandr Natalenko (post-factum)
