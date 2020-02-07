Return-Path: <SRS0=BlI3=33=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19F04C2BA83
	for <linux-efi@archiver.kernel.org>; Fri,  7 Feb 2020 20:26:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE30821741
	for <linux-efi@archiver.kernel.org>; Fri,  7 Feb 2020 20:26:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MA4LyJvQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgBGU0l (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 7 Feb 2020 15:26:41 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46230 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbgBGU0l (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Fri, 7 Feb 2020 15:26:41 -0500
Received: by mail-qk1-f194.google.com with SMTP id g195so341940qke.13
        for <linux-efi@vger.kernel.org>; Fri, 07 Feb 2020 12:26:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8B5XdD4gQOA8Ju/7w3y+6mJSGkGb+YcdBnNJRrP84fs=;
        b=MA4LyJvQ7qGX6s/9lTbI/MD/oJ/4otXAKurDYMOOzYQuOSG3esv6PrDb8GiEhi5O63
         XFUHbdf+DYtFs755c4zat11V3gPTzSgfwBiL23rP1qzK//35gkOL9GrQHF8APc06d2BW
         iCzngI6w/H2S7/SxR3RYcsvhWx7iFaCFecT8Jsf1laNSRVEG1C04dS3swohG8N5B5f5R
         EaRDdWgbP4rxzlCj4epFIQdB/mXpAMgU9Zm6nUzBYw0tW3d8KLxVbKJwceAxgs1B2Tpp
         ASfmtXYzraZ0YUbt0zyyqLIHXSMAdV2gRd6aLFBap3PNZwxKY4NZ5snmqFf1gaVbeS9e
         mnRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=8B5XdD4gQOA8Ju/7w3y+6mJSGkGb+YcdBnNJRrP84fs=;
        b=JfMMibYGCJyEmBn6Om0cXsE8UK2DHFnpbLdxZq5F2yQx2ySIvrQy9edNs0b8XcsOc1
         2eIGBJ8pNJNOFT0FwvhiRGItupFnRTe4a8tFKsYnS2x+rdPaTBvddL/IPNalqRaJhWvx
         HBwCoDcwQFt1VOBH916yq3FlPyIbUOOzEOZssdSwOO0hMdv+SZbhkKmKMTWpZFky5QAE
         sVkZC2bgH0ZQJW9Kv+jwirYABPpw1Bss3A1t0b0VJETid9/Aihb+81fKswOU98QpyqAk
         arApKSRec4s+PiiojCPuOIquQFJfD6+FeQ/zlo18NyDZdsghvYlIekyRKi5Wf4O/y8df
         RpGg==
X-Gm-Message-State: APjAAAV7rcCzqj8Qe4qdejqsZQOlvRTdCqe0+ICEHXPOgBNJBcN0O1t+
        QjkQWdRLwCeVZOAe1SIzDi0=
X-Google-Smtp-Source: APXvYqyJz1rMrV/EpC7xpknAAVWZfHwpV7tdIU7Ry76j8YGzrd/L20oMozoJ8L58djBxMoVOPNDbLA==
X-Received: by 2002:a05:620a:52b:: with SMTP id h11mr722547qkh.88.1581107200068;
        Fri, 07 Feb 2020 12:26:40 -0800 (PST)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id t15sm1743626qkg.49.2020.02.07.12.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 12:26:39 -0800 (PST)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Fri, 7 Feb 2020 15:26:37 -0500
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        Ard Biesheuvel <ardb@kernel.org>,
        linux-efi <linux-efi@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Laszlo Ersek <lersek@redhat.com>,
        Leif Lindholm <leif@nuviainc.com>,
        Peter Jones <pjones@redhat.com>,
        Matthew Garrett <mjg59@google.com>,
        Alexander Graf <agraf@csgraf.de>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Daniel Kiper <daniel.kiper@oracle.com>
Subject: Re: [PATCH 0/2] arch-agnostic initrd loading method for EFI systems
Message-ID: <20200207202637.GA3464906@rani.riverdale.lan>
References: <20200206140352.6300-1-ardb@kernel.org>
 <20200207184532.GA3276112@rani.riverdale.lan>
 <CAKv+Gu8Z3=cqbNxspLXAgM_8wEm+to2TWRjpaaC231MbwL2Ycw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8Z3=cqbNxspLXAgM_8wEm+to2TWRjpaaC231MbwL2Ycw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Fri, Feb 07, 2020 at 07:47:46PM +0000, Ard Biesheuvel wrote:
> On Fri, 7 Feb 2020 at 18:45, Arvind Sankar <nivedita@alum.mit.edu> wrote:
> >
> > On Thu, Feb 06, 2020 at 02:03:50PM +0000, Ard Biesheuvel wrote:
> > >   data structure. It also creates a time window where the initrd data sits
> > >   in memory, and can potentially be corrupted before the kernel is booted.
> > >
> >
> > I don't quite understand the time window aspect -- can you expand on
> > that? It seems like the same time window exists between when the kernel
> > is loaded and when it actually runs, no? Why is this more important for
> > initrd?
> 
> When using loadimage+startimage, the authentication and measurement of
> the kernel image occur during the call to loadimage(), even if the
> source of the load is memory itself, and startimage() is typically
> called right after.
> 
> The assumption is that it may help to make this time as short as
> possible for the initrd as well.

Ok, this is for when we can use LoadImage, that makes sense.
