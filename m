Return-Path: <SRS0=V+Gr=ZG=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E032C43141
	for <linux-efi@archiver.kernel.org>; Thu, 14 Nov 2019 09:08:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8DC720718
	for <linux-efi@archiver.kernel.org>; Thu, 14 Nov 2019 09:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbfKNJIM (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 14 Nov 2019 04:08:12 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:56133 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbfKNJIM (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Thu, 14 Nov 2019 04:08:12 -0500
Received: by ozlabs.org (Postfix, from userid 1034)
        id 47DFxy6dpQz9sSQ; Thu, 14 Nov 2019 20:08:06 +1100 (AEDT)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: e14555e3d0e9edfad0a6840c0152f71aba97e793
In-Reply-To: <1572492694-6520-6-git-send-email-zohar@linux.ibm.com>
To:     Mimi Zohar <zohar@linux.ibm.com>, linuxppc-dev@ozlabs.org,
        linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Ricther <erichte@linux.ibm.com>,
        Nayna Jain <nayna@linux.ibm.com>, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Jeremy Kerr <jk@ozlabs.org>,
        Oliver O'Halloran <oohall@gmail.com>
Subject: Re: [PATCH v10 5/9] ima: make process_buffer_measurement() generic
Message-Id: <47DFxy6dpQz9sSQ@ozlabs.org>
Date:   Thu, 14 Nov 2019 20:08:05 +1100 (AEDT)
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Thu, 2019-10-31 at 03:31:30 UTC, Mimi Zohar wrote:
> From: Nayna Jain <nayna@linux.ibm.com>
> 
> process_buffer_measurement() is limited to measuring the kexec boot
> command line. This patch makes process_buffer_measurement() more
> generic, allowing it to measure other types of buffer data (e.g.
> blacklisted binary hashes or key hashes).
> 
> process_buffer_measurement() may be called directly from an IMA
> hook or as an auxiliary measurement record. In both cases the buffer
> measurement is based on policy. This patch modifies the function to
> conditionally retrieve the policy defined PCR and template for the IMA
> hook case.
> 
> Signed-off-by: Nayna Jain <nayna@linux.ibm.com>
> [zohar@linux.ibm.com: added comment in process_buffer_measurement()]
> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>

Applied to powerpc next, thanks.

https://git.kernel.org/powerpc/c/e14555e3d0e9edfad0a6840c0152f71aba97e793

cheers
