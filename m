Return-Path: <SRS0=V+Gr=ZG=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07F17C43141
	for <linux-efi@archiver.kernel.org>; Thu, 14 Nov 2019 09:09:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF09220715
	for <linux-efi@archiver.kernel.org>; Thu, 14 Nov 2019 09:09:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfKNJJN (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 14 Nov 2019 04:09:13 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:47061 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727180AbfKNJIP (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Thu, 14 Nov 2019 04:08:15 -0500
Received: by ozlabs.org (Postfix, from userid 1034)
        id 47DFy45qFBz9sST; Thu, 14 Nov 2019 20:08:12 +1100 (AEDT)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: dc87f18615db9dc74a75cfb4a57ed33b07a3903a
In-Reply-To: <1572492694-6520-9-git-send-email-zohar@linux.ibm.com>
To:     Mimi Zohar <zohar@linux.ibm.com>, linuxppc-dev@ozlabs.org,
        linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     Jessica Yu <jeyu@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Ricther <erichte@linux.ibm.com>,
        Nayna Jain <nayna@linux.ibm.com>, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Jeremy Kerr <jk@ozlabs.org>,
        Oliver O'Halloran <oohall@gmail.com>
Subject: Re: [PATCH v10 8/9] powerpc/ima: update ima arch policy to check for blacklist
Message-Id: <47DFy45qFBz9sST@ozlabs.org>
Date:   Thu, 14 Nov 2019 20:08:12 +1100 (AEDT)
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Thu, 2019-10-31 at 03:31:33 UTC, Mimi Zohar wrote:
> From: Nayna Jain <nayna@linux.ibm.com>
> 
> This patch updates the arch-specific policies for PowerNV system to make
> sure that the binary hash is not blacklisted.
> 
> Signed-off-by: Nayna Jain <nayna@linux.ibm.com>
> Cc: Jessica Yu <jeyu@kernel.org>
> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>

Applied to powerpc next, thanks.

https://git.kernel.org/powerpc/c/dc87f18615db9dc74a75cfb4a57ed33b07a3903a

cheers
