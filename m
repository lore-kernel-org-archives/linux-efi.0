Return-Path: <SRS0=PRj/=6N=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C373AC83000
	for <linux-efi@archiver.kernel.org>; Wed, 29 Apr 2020 18:57:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2A65208E0
	for <linux-efi@archiver.kernel.org>; Wed, 29 Apr 2020 18:57:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgD2S5E (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 29 Apr 2020 14:57:04 -0400
Received: from smtprelay0019.hostedemail.com ([216.40.44.19]:33148 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726423AbgD2S5E (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Wed, 29 Apr 2020 14:57:04 -0400
X-Greylist: delayed 553 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Apr 2020 14:57:03 EDT
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 4E9CB18224D66;
        Wed, 29 Apr 2020 18:57:03 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: table47_5a912d5982623
X-Filterd-Recvd-Size: 1444
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf05.hostedemail.com (Postfix) with ESMTPA;
        Wed, 29 Apr 2020 18:57:02 +0000 (UTC)
Message-ID: <3fa8fba37f9339adc993cdb7afc77ed0e063967d.camel@perches.com>
Subject: Re: [PATCH 03/10] efi/x86: Use pr_efi_err for error messages
From:   Joe Perches <joe@perches.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        linux-efi <linux-efi@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Wed, 29 Apr 2020 11:57:01 -0700
In-Reply-To: <CAMj1kXGn70BmapKe=6sA17gMCcWRLCebQJFnyObwRbAefOcEng@mail.gmail.com>
References: <20200429174120.1497212-1-nivedita@alum.mit.edu>
         <20200429174120.1497212-5-nivedita@alum.mit.edu>
         <f74fe4ad56c0471f863ce550869391c8811f9893.camel@perches.com>
         <CAMj1kXGn70BmapKe=6sA17gMCcWRLCebQJFnyObwRbAefOcEng@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Wed, 2020-04-29 at 20:49 +0200, Ard Biesheuvel wrote:
> On Wed, 29 Apr 2020 at 20:47, Joe Perches <joe@perches.com> wrote:
> > Looking at code for efi_printk -> efi_char16_printk,
> > it's somewhat difficult to see where the "output_string"
> > function pointer is set.  Any clue?
> It is set by the firmware.

Sure, where in the code though?


