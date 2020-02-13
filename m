Return-Path: <SRS0=5I3D=4B=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F168BC2BA83
	for <linux-efi@archiver.kernel.org>; Thu, 13 Feb 2020 17:13:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFB7F206DB
	for <linux-efi@archiver.kernel.org>; Thu, 13 Feb 2020 17:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581613993;
	bh=l56qEB9k44eSpvcs/9db1OGeL5hy9h6oE3gaJUII1rg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=mSuaOHrDuxLSjHmK7s7Z1cyEnVPjidfp6MJat6BGsmUPPk57Bir+LKmwh4nCEC5y0
	 4B6/vEV0fIIyWWXSdvrMoQT1ZOsqR4TXuJleYKkvblhi7jrLP2Jui8ZPf+CKNQhi4M
	 dBRXiLNI8cxcxd416K97SjgyKpZUaEIaBjyURLe0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgBMRNN (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 13 Feb 2020 12:13:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:33174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727658AbgBMRNN (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Thu, 13 Feb 2020 12:13:13 -0500
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2D4D24670
        for <linux-efi@vger.kernel.org>; Thu, 13 Feb 2020 17:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581613993;
        bh=l56qEB9k44eSpvcs/9db1OGeL5hy9h6oE3gaJUII1rg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=PGJl0ZsOHuUXBA+DysErbQ8+43epyDksEZdXWC3xdLBYB67KYpuknKqxPNuw0/Q/+
         3bvVU8W+dp2xMpK7FOIvUzfcvYN0vPDNQXBcugYiII90YZMfmovxH4y/BS6JrxFHyI
         rffZ8wWqskztlbg7HA3bphJ44g1ADaEAiyZFUjeA=
Received: by mail-wr1-f47.google.com with SMTP id u6so7679482wrt.0
        for <linux-efi@vger.kernel.org>; Thu, 13 Feb 2020 09:13:12 -0800 (PST)
X-Gm-Message-State: APjAAAWiSVgDcFZCbgxrG4G4BMluVPA5k98WmCJg1KZUyJVtpXbWPm3n
        1Zk736vklnC0PV8CX+qZyH/VhVotBLLBio7AN2OIsw==
X-Google-Smtp-Source: APXvYqwfGp+HHdQIFAu23pxn/wIxIFeKFu5EuoFB2R6CPKb8dbBhH47KafSTgYtv8BXGr/P3P1dm1egDcwSvkEKvWZ8=
X-Received: by 2002:a5d:65cf:: with SMTP id e15mr22245562wrw.126.1581613991021;
 Thu, 13 Feb 2020 09:13:11 -0800 (PST)
MIME-Version: 1.0
References: <20200213145928.7047-1-ardb@kernel.org> <20200213145928.7047-3-ardb@kernel.org>
 <20200213165902.GA1400002@rani.riverdale.lan>
In-Reply-To: <20200213165902.GA1400002@rani.riverdale.lan>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 13 Feb 2020 17:13:00 +0000
X-Gmail-Original-Message-ID: <CAKv+Gu-w74DH8jG6GiL+Ydn-qdG7CW17AtZiHCoU+RpT-Teasw@mail.gmail.com>
Message-ID: <CAKv+Gu-w74DH8jG6GiL+Ydn-qdG7CW17AtZiHCoU+RpT-Teasw@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] efi/x86: add true mixed mode entry point into
 .compat section
To:     Arvind Sankar <nivedita@alum.mit.edu>
Cc:     linux-efi <linux-efi@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Laszlo Ersek <lersek@redhat.com>,
        Leif Lindholm <leif@nuviainc.com>,
        Peter Jones <pjones@redhat.com>,
        Matthew Garrett <mjg59@google.com>,
        Alexander Graf <agraf@csgraf.de>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Michael Brown <mbrown@fensystems.co.uk>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Thu, 13 Feb 2020 at 17:59, Arvind Sankar <nivedita@alum.mit.edu> wrote:
>
> On Thu, Feb 13, 2020 at 03:59:27PM +0100, Ard Biesheuvel wrote:
> > Currently, mixed mode is closely tied to the EFI handover protocol
> > and relies on intimate knowledge of the bootparams structure, setup
> > header etc, all of which are rather byzantine and entirely specific
> > to x86.
> >
> > Even though no other EFI supported architectures are currently known
> > that could support something like mixed mode, it makes sense to
> > abstract a bit from this, and make it part of a generic Linux on EFI
> > boot protocol.
> >
> > To that end, add a .compat section to the mixed mode binary, and populate
> > it with the PE machine type and entry point address, allowing firmware
> > implementations to match it to their native machine type, and invoke
> > non-native binaries using a secondary entry point.
>
> This patch refers to efi32_pe_entry which is only defined in the next
> one.

Indeed. So the .compat section will be emitted with a bogus entry
point when applying this patch but not the next one, so perhaps I
should simply reorder them .
