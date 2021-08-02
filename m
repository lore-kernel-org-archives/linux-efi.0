Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3888BC4338F
	for <linux-efi@archiver.kernel.org>; Mon,  2 Aug 2021 11:28:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 185E560F36
	for <linux-efi@archiver.kernel.org>; Mon,  2 Aug 2021 11:28:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233255AbhHBL2b (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 2 Aug 2021 07:28:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:59809 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233382AbhHBL2b (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Mon, 2 Aug 2021 07:28:31 -0400
Received: from ip6-localhost (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 172BQDik029450;
        Mon, 2 Aug 2021 06:26:14 -0500
Message-ID: <b3041039f08ffd524eef37d35950b30c5e11255e.camel@kernel.crashing.org>
Subject: Re: [PATCH v3 0/4] efi/arm64: work around Image placement issues
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     Ard Biesheuvel <ardb@kernel.org>, linux-efi@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org
Date:   Mon, 02 Aug 2021 21:26:13 +1000
In-Reply-To: <20210726145156.12006-1-ardb@kernel.org>
References: <20210726145156.12006-1-ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Mon, 2021-07-26 at 16:51 +0200, Ard Biesheuvel wrote:
> Ben reported that distro GRUB may fail to boot in some circumstances,
> and tracked it down to an issue in the way distro GRUB allocates space
> for the image. Due to an oversight (addressed in patch #2), this
> condition is rarely triggered, but let's work around it in any case (#1)
> 
> Remaining patches add further warnings for conditions that are unlikely
> to occur, but should not be ignored.
> 
> Build tested only.
> 
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>

All 4 patches:

Tested-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

I checked that it catches all of the errors, including reverting my fix
for randomalloc.c and verifying that it caught (and successfully worked
around) the original boot  crash.

Cheers,
Ben.

