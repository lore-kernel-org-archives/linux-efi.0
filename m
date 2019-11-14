Return-Path: <SRS0=V+Gr=ZG=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8338AC43141
	for <linux-efi@archiver.kernel.org>; Thu, 14 Nov 2019 09:08:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B32920723
	for <linux-efi@archiver.kernel.org>; Thu, 14 Nov 2019 09:08:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbfKNJIR (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 14 Nov 2019 04:08:17 -0500
Received: from ozlabs.org ([203.11.71.1]:52085 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727205AbfKNJIR (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Thu, 14 Nov 2019 04:08:17 -0500
Received: by ozlabs.org (Postfix, from userid 1034)
        id 47DFy61bydz9sSL; Thu, 14 Nov 2019 20:08:13 +1100 (AEDT)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: d72ea4915c7e6fa5e7b9022a34df66e375bfe46c
In-Reply-To: <1572492694-6520-10-git-send-email-zohar@linux.ibm.com>
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
Subject: Re: [RFC PATCH v10 9/9] powerpc/ima: indicate kernel modules appended signatures are enforced
Message-Id: <47DFy61bydz9sSL@ozlabs.org>
Date:   Thu, 14 Nov 2019 20:08:13 +1100 (AEDT)
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Thu, 2019-10-31 at 03:31:34 UTC, Mimi Zohar wrote:
> The arch specific kernel module policy rule requires kernel modules to
> be signed, either as an IMA signature, stored as an xattr, or as an
> appended signature.  As a result, kernel modules appended signatures
> could be enforced without "sig_enforce" being set or reflected in
> /sys/module/module/parameters/sig_enforce.  This patch sets
> "sig_enforce".
> 
> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> Cc: Jessica Yu <jeyu@kernel.org>

Applied to powerpc next, thanks.

https://git.kernel.org/powerpc/c/d72ea4915c7e6fa5e7b9022a34df66e375bfe46c

cheers
