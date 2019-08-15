Return-Path: <SRS0=k4Sw=WL=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15430C31E40
	for <linux-efi@archiver.kernel.org>; Thu, 15 Aug 2019 11:23:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5B0F2064A
	for <linux-efi@archiver.kernel.org>; Thu, 15 Aug 2019 11:23:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbfHOLXt (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 15 Aug 2019 07:23:49 -0400
Received: from foss.arm.com ([217.140.110.172]:42550 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbfHOLXt (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Thu, 15 Aug 2019 07:23:49 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CD9FB28;
        Thu, 15 Aug 2019 04:23:48 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 27F313F694;
        Thu, 15 Aug 2019 04:23:48 -0700 (PDT)
Date:   Thu, 15 Aug 2019 12:23:46 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     skodde <skodde@gmail.com>, linux-efi <linux-efi@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: arm64/efistub boot error with CONFIG_GCC_PLUGIN_STACKLEAK
Message-ID: <20190815112345.GB22153@lakrids.cambridge.arm.com>
References: <CAJrUJt_HV+8MCGxv4=bq97JFiKqPtgN4ntfei0TmxGhDT-bCQg@mail.gmail.com>
 <20190815110308.GA22153@lakrids.cambridge.arm.com>
 <CAKv+Gu-OoFZRy_fv1z3GmTH3rp=TKviO7rEeFXwqqiWzbgJf3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-OoFZRy_fv1z3GmTH3rp=TKviO7rEeFXwqqiWzbgJf3A@mail.gmail.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Thu, Aug 15, 2019 at 02:21:26PM +0300, Ard Biesheuvel wrote:
> On Thu, 15 Aug 2019 at 14:03, Mark Rutland <mark.rutland@arm.com> wrote:
> > On Thu, Aug 15, 2019 at 05:56:27AM -0400, skodde wrote:
> > > Hi,
> > >
> > > I've enabled CONFIG_GCC_PLUGIN_STACKLEAK on 5.2.8 for an arm64
> > > macchiatobin board and I get the following error when loading the
> > > kernel (using grub-efi on top of edk ii):
> > >
> > > EFI stub: Booting Linux Kernel...
> > > EFI stub: ERROR: efi_get_random_bytes() failed
> > > EFI stub: ERROR: Failed to relocate kernel
> > >
> > > The kernel boots fine with that option disabled, but strangely
> > > presents the same error when disabling only CONFIG_RANDOMIZE_BASE.
> >
> > That shouldn't be possible, given the IS_ENABLED(CONFIG_RANDOMIZE_BASE)
> > guard around the efi_get_random_bytes() call, so something sounds wrong.
> >
> > Are you certain that you're running the same kernel Image that you
> > rebuilt?
> >
> > Ard, do you reckon it would be worth adding the UTS_RELEASE and
> > UTS_VERSION to the " Booting Linux Kernel..." string? It would make
> > debugging that potential issue easier.
> 
> Use of the UTS_xxx macros already triggers an annoying number of
> object rebuilds every time you change anything entirely unrelated in
> your kernel sources, so I'd prefer to avoid this tbh.

Fair enough; saves me writing a patch! :)

Mark.
