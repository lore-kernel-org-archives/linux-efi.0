Return-Path: <SRS0=rTkh=6O=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A837DC4724C
	for <linux-efi@archiver.kernel.org>; Thu, 30 Apr 2020 19:38:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91FCE20656
	for <linux-efi@archiver.kernel.org>; Thu, 30 Apr 2020 19:38:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgD3TiG (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 30 Apr 2020 15:38:06 -0400
Received: from smtprelay0066.hostedemail.com ([216.40.44.66]:60034 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726338AbgD3TiG (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Thu, 30 Apr 2020 15:38:06 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 1C09F181D330D;
        Thu, 30 Apr 2020 19:38:05 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: camp39_467245017161d
X-Filterd-Recvd-Size: 1907
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf15.hostedemail.com (Postfix) with ESMTPA;
        Thu, 30 Apr 2020 19:38:03 +0000 (UTC)
Message-ID: <d357dcfec5b5c175ea3430053735399ef6fa87a6.camel@perches.com>
Subject: Re: [PATCH 1/2] efi/libstub: efi_info/efi_err message neatening
From:   Joe Perches <joe@perches.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi <linux-efi@vger.kernel.org>, X86 ML <x86@kernel.org>
Date:   Thu, 30 Apr 2020 12:38:02 -0700
In-Reply-To: <CAMj1kXGMnTfYiU_vMDYG0uy7Na7wy=5DRHERTzZQeb4UBusn0g@mail.gmail.com>
References: <20200430182843.2510180-1-nivedita@alum.mit.edu>
         <091e3fc3bdbc5f480af7d3b3ac096d174a4480d0.1588273612.git.joe@perches.com>
         <CAMj1kXGMnTfYiU_vMDYG0uy7Na7wy=5DRHERTzZQeb4UBusn0g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Thu, 2020-04-30 at 21:29 +0200, Ard Biesheuvel wrote:
> On Thu, 30 Apr 2020 at 21:12, Joe Perches <joe@perches.com> wrote:
> > Use a standard style for these output logging messages.
> > 
> > Miscellanea:
> > 
> > o Use more common macro #defines with fmt, ##__VA_ARGS__
> > 0 Remove trailing messages periods and odd ' uses
> > o Remove embedded function names and use %s, __func__
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> > 
> > Perhaps these trivialities on top of this series?
> > 
> 
> The EFI printing routines don't actually support format strings.

Thanks.  Then nevermind on that bit.

> Removing trailing periods is not really necessary IMO, but i'll take a
> patch that fixes those weird quotes.

<shrug>  Your choice.

There are 60+ uses of efi_err, 12 with a trailing period.

cheers, Joe

