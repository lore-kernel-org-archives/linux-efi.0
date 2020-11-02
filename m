Return-Path: <SRS0=FYpD=EI=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 004FBC00A89
	for <linux-efi@archiver.kernel.org>; Mon,  2 Nov 2020 20:24:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CB0522275
	for <linux-efi@archiver.kernel.org>; Mon,  2 Nov 2020 20:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604348688;
	bh=TRn2CIt7l1tkfcFXTZ6XVTtxTW3TL2KnPcL/wzyFQHk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=dDzCQ4UqWaUP9tO6sDpP1D9pYIY9KPWkHw21hUavwBih/9ccGZwsypOEW00kebT1H
	 zeU2SiLdR1Rek2x7t8FQhybNiLLCtDHFY4Ln1HLwFarQxIdDba91wC9X5XC8bY0LBq
	 iCmEHtCKeu1vhoGJdQtaD8fXtI4fTBwa5IKhkqVo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725805AbgKBUYs (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 2 Nov 2020 15:24:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:38752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725801AbgKBUYs (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Mon, 2 Nov 2020 15:24:48 -0500
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDE1A22280
        for <linux-efi@vger.kernel.org>; Mon,  2 Nov 2020 20:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604348687;
        bh=TRn2CIt7l1tkfcFXTZ6XVTtxTW3TL2KnPcL/wzyFQHk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=m3FG1T5x54RL+jJ+6DQAXyIYBDKLv6nKF5h0yAXRdz0vZgiSTXI867soGxxnxjfNo
         JRkaLNTSK6jt7BD8dOZdaYkquNF/Q9DH3/se2wA565FjEQvZAbAWulopV3hAJBsIdn
         hs5LwR4DWzGsuZiUG5HSBTWyXqlEweHJlsuJJnj8=
Received: by mail-ot1-f54.google.com with SMTP id y22so3365993oti.10
        for <linux-efi@vger.kernel.org>; Mon, 02 Nov 2020 12:24:46 -0800 (PST)
X-Gm-Message-State: AOAM530cHlq8S4tKJO6D/xZPJbT379B0emluxivIFvOiQhaF12r2XbgF
        POAIfGZMfS1kswlcrm6SBctmMlQDl9cnAvlyCho=
X-Google-Smtp-Source: ABdhPJyA2yG5kzTUXkKeOuj3LiBxEtjdjCS0X2JNak3v3QIvykakDb1o4F2J9FmIvQ8kNvLm/auLBLn1YrB7mHBeg9g=
X-Received: by 2002:a05:6830:4028:: with SMTP id i8mr12678839ots.90.1604348686044;
 Mon, 02 Nov 2020 12:24:46 -0800 (PST)
MIME-Version: 1.0
References: <20201102170634.20575-1-ardb@kernel.org> <CACdnJuvC3EjQb5ZfOBynNzMPOwUm3w5CnXDCYGd10w_AW+_efw@mail.gmail.com>
In-Reply-To: <CACdnJuvC3EjQb5ZfOBynNzMPOwUm3w5CnXDCYGd10w_AW+_efw@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 2 Nov 2020 21:24:34 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGXOb3Q9mwK7dGbhmTbN_82m7BBYW+0ATVmG59LK3N++A@mail.gmail.com>
Message-ID: <CAMj1kXGXOb3Q9mwK7dGbhmTbN_82m7BBYW+0ATVmG59LK3N++A@mail.gmail.com>
Subject: Re: [RFC PATCH 0/7] efi/libstub: measurement initrd data loaded by
 the EFI stub
To:     Matthew Garrett <mjg59@google.com>
Cc:     linux-efi <linux-efi@vger.kernel.org>,
        Peter Jones <pjones@redhat.com>,
        Leif Lindholm <leif@nuviainc.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Mon, 2 Nov 2020 at 20:39, Matthew Garrett <mjg59@google.com> wrote:
>
> On Mon, Nov 2, 2020 at 9:06 AM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> > This is posted as an RFC since it is mostly an invitation to discuss how
> > we can fit this into a longer term strategy for arch-agnostic secure and
> > measured boot that does not hinge on the Shim+GRUB tandem, or on deep
> > knowledge on the part of the bootloader regarding device trees, bootparams
> > structs, allocation and placement policies of various artifacts etc etc
>
> My initial concern was that we'd potentially do double measurement if
> a separate bootloader loaded the initrd and then called the EFI entry
> point, but it looks like you'll only measure if the stub loaded the
> initrd itself, in which case this seems fine.
>
> > Open questions:
> > - Should we do this?
>
> I think so. The initramfs is clearly part of our initial TCB.
>
> > - Are Linux systems in the field using PCR value prediction when updating the
> >   initrd? Does this approach interfere with that?
>
> I'm not aware of any distro that's tried to solve this problem. I do
> have an idea for how to (basically, build a generic initramfs and then
> allow the bootloader to override specific configuration files - grub
> has support for reading files and creating an additional cpio on the
> fly), but handwave.
>
> > - Which PCR and event type to use
>
> Grub is measuring the initramfs (and all binaries) into PCR 9 with EV_IPL.
>
> > - Is a separator event needed here, given that the initrd measurement is
> >   recorded even if no initrd was loaded by the stub?
>
> I think probably, but we should probably have a longer discussion
> around when we should be logging separators (grub doesn't generate any
> at the moment, and I don't think shim does either, and that's
> definitely suboptimal for the PCR 7 case). We should probably look at
> what Windows is doing here.

Does Shim use PCR 7 for the MOK key database? Are there any specific
requirements from MS on which PCRs Shim must touch?
