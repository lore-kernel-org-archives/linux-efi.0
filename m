Return-Path: <SRS0=rgVR=EK=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51723C55179
	for <linux-efi@archiver.kernel.org>; Wed,  4 Nov 2020 02:31:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AED42225B
	for <linux-efi@archiver.kernel.org>; Wed,  4 Nov 2020 02:31:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730576AbgKDCbB (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 3 Nov 2020 21:31:01 -0500
Received: from l2mail1.panix.com ([166.84.1.75]:59879 "EHLO l2mail1.panix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730663AbgKDCa5 (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Tue, 3 Nov 2020 21:30:57 -0500
X-Greylist: delayed 1129 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Nov 2020 21:30:55 EST
Received: from mailbackend.panix.com (mailbackend.panix.com [166.84.1.89])
        by l2mail1.panix.com (Postfix) with ESMTPS id 4CQqsg1724zDQw;
        Tue,  3 Nov 2020 21:12:07 -0500 (EST)
Received: from xps-7390 (cpe-23-242-39-94.socal.res.rr.com [23.242.39.94])
        by mailbackend.panix.com (Postfix) with ESMTPSA id 4CQqsc1WXfz1dBF;
        Tue,  3 Nov 2020 21:12:04 -0500 (EST)
Date:   Tue, 3 Nov 2020 18:12:02 -0800 (PST)
From:   "Kenneth R. Crudup" <kenny@panix.com>
Reply-To: "Kenneth R. Crudup" <kenny@panix.com>
To:     Tyler Hicks <tyhicks@linux.microsoft.com>
cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org,
        =?ISO-8859-15?Q?Thi=E9baud_Weksteen?= <tweek@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] tpm: efi: Don't create binary_bios_measurements file
 for an empty log
In-Reply-To: <20201028173958.GA4624@sequoia>
Message-ID: <f4e72061-35e-cc4a-c8b7-cfbf5ef42e4@panix.com>
References: <E1FDCCCB-CA51-4AEE-AC83-9CDE995EAE52@canonical.com> <20201028154102.9595-1-tyhicks@linux.microsoft.com> <20201028163002.GA5150@sequoia> <20201028173958.GA4624@sequoia>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org


On Wed, 28 Oct 2020, Tyler Hicks wrote:

> Hi Kai, Kenneth, and Mimi - could one or two of you please follow these
> steps:
...

OK, I built a kernel with the two patches applied, and with and without commit
7f3d176f5f7e, and when I run "sudo fwupdtpmevlog" (which normally causes a
panic() when 7f3d176f5f7e is in place) and the results are:

- With 7f3d176f5f7e reverted, no WARNs of any kind
- With 7f3d176f5f7e in place, same, I just get "UEFI TPM log area empty"

	-Kenny

-- 
Kenneth R. Crudup  Sr. SW Engineer, Scott County Consulting, Orange County CA
