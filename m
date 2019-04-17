Return-Path: <SRS0=G8aV=ST=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F166C282DA
	for <linux-efi@archiver.kernel.org>; Wed, 17 Apr 2019 19:17:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECD632073F
	for <linux-efi@archiver.kernel.org>; Wed, 17 Apr 2019 19:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555528629;
	bh=eWg3sEGdj68IehFvQ/kNCLYZYMmdTc6MJDW/g0A5MUk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=OncPRq2NRfZNiVvN+tsY8cXzGj1pF+cC5LLJEKcyQUpfaYGmeb7GP/5oyJPjigabv
	 2bt+dbrqD9BSx59BOcBg21KLkAPnINE8ut/lt8RN5rrvum1yst1UtcXfTF9n4nS8SQ
	 e20MdL0pfhJ+1cb/t4IUOH676ht01uwDrE8FKcmM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730285AbfDQTRI (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 17 Apr 2019 15:17:08 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:33314 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729291AbfDQTRI (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Wed, 17 Apr 2019 15:17:08 -0400
Received: by mail-wr1-f53.google.com with SMTP id q1so33434023wrp.0;
        Wed, 17 Apr 2019 12:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WrFVWsTj4AUx36YQO+mAEFZaSupVKbjnPrtYOeZ0o0A=;
        b=ZJw61v+b2ERBBCTVtww3s0UTXbFHpoRXwPiC2G43gnHn20zCLa35UJSOasEHOUV75t
         xy0axIMTTOMZMVNOVS4XmLsg8sR6tf6/eT7Cr13txBjXT0uIm3vG2wsT9yOxvjOWBJ34
         6ukIuE52V9jXqUsqyRtTa7RjISnogjQrGGbN5jXTlXCrZ0MAmx2VTCjaoPGAA0Al+9TD
         niN1s5T1FCR3XoWk2DQ0PlUghkwSi9CVCJ/FK0JBf2t2qrj2+1IC/12q/9tG1Oeoeg/5
         wA2m+ShNJDPwddD1Ak0SE07JZV24ScMlNRBsvLE+R9GaIYfx3i4Cx2692NdJ0HHMUBJq
         55QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=WrFVWsTj4AUx36YQO+mAEFZaSupVKbjnPrtYOeZ0o0A=;
        b=LbaylLQkU9NGG60mU3RmNO+NsSIIdlggg/TQhVhaOEk70UeEJsFyDOvRxhkbJ7LsLN
         o/yeqBt7qnE+EIg9sQnWvs1McOzvb44VwWgRf6G4vvpTxHHBckHDgJ6y7ynJPUCiBYjI
         0XuqZzjM0hVSLGi++1gGRa+N9Q2rljG2X4lz3X5B115yK9oyY0ad59dzxE/U4Ez/IZs5
         HnGRr0jxog5lOmeMcdgI7O6INPuGmBc21xXdorlqWBFOVeEkjpJILe+7Ig8YHYbcMls3
         x+c96FlZOVdwTe+nLTqj6s1vDonzCDH8zf9mNQZDteZGv2e4j3DPuQx05yu9Nq2KVqsg
         GK6g==
X-Gm-Message-State: APjAAAVNT/dpz1NmZxs27MyQe9rVRHvvufSRCRirmNo0Tog83LqnRZph
        ePGEj0grCruuaKjyJuvReqs=
X-Google-Smtp-Source: APXvYqzCB9zmVa5+aG4G5EFpcgUq3chQ8d1cPzYDHfmLRPZKuKkIiLkZHgGzIg2hCKJf+BSXnybT9Q==
X-Received: by 2002:a5d:4d49:: with SMTP id a9mr58832578wru.227.1555528625919;
        Wed, 17 Apr 2019 12:17:05 -0700 (PDT)
Received: from gmail.com (2E8B0CD5.catv.pool.telekom.hu. [46.139.12.213])
        by smtp.gmail.com with ESMTPSA id y9sm95045206wrn.18.2019.04.17.12.17.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 Apr 2019 12:17:05 -0700 (PDT)
Date:   Wed, 17 Apr 2019 21:17:02 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Daniel Drake <drake@endlessm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jian-Hong Pan <jian-hong@endlessm.com>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        linux-efi <linux-efi@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "linux-tip-commits@vger.kernel.org" 
        <linux-tip-commits@vger.kernel.org>,
        Endless Linux Upstreaming Team <linux@endlessm.com>
Subject: Re: EFI reboot vs. ACPI reboot (was: Re: [tip:x86/urgent]
 x86/reboot, efi: Use EFI reboot for Acer TravelMate X514-51T)
Message-ID: <20190417191702.GA29062@gmail.com>
References: <tip-0082517fa4bce073e7cf542633439f26538a14cc@git.kernel.org>
 <20190416082042.GA69717@gmail.com>
 <CAD8Lp44pQRYdw4cbfMt3uOSO23dzy_mWTt5T-Zjft08WWu_yUA@mail.gmail.com>
 <20190417061650.GA31060@gmail.com>
 <CAD8Lp45BLaoXF=RNcncqcTtNvaGHP72+a1CxcjoeBXDiw9TKbA@mail.gmail.com>
 <17516564-37AC-4F77-9C0D-0DD71F8045EA@zytor.com>
 <CAKv+Gu_jqoKiqq4ozcPwSxLmpuaWsFKy_xyYGhECLz+KLHOjOw@mail.gmail.com>
 <FFF73D592F13FD46B8700F0A279B802F48AFEFF2@ORSMSX114.amr.corp.intel.com>
 <20190417182341.GA5140@gmail.com>
 <CAKv+Gu9NJH02obRtgtNf7O7Bd8Z0SdKjsBLppGd60f6ryq6OoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9NJH02obRtgtNf7O7Bd8Z0SdKjsBLppGd60f6ryq6OoA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
Message-ID: <20190417191702.d-d6ML-liI6t_ayVjOcry5jS_hm7HO3ZT_-ia7n-eC0@z>


* Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> On Wed, 17 Apr 2019 at 11:23, Ingo Molnar <mingo@kernel.org> wrote:
> >
> >
> > * Prakhya, Sai Praneeth <sai.praneeth.prakhya@intel.com> wrote:
> >
> > > I will ask around internally to check if it is a good idea to make EFI
> > > reboot the default method when the machine is booted in EFI mode.
> >
> > Or whether there's some robust signature that indicates "modern EFI
> > system where EFI reboot is the primary method"?
> >
> > Major EFI version or ACPI version or such?
> >
> 
> I am actually at Microsoft right now, and I managed to get
> clarification on how Windows deals with this: Windows will attempt to
> use ACPI reboot first, and will only attempt to use anything else if
> that fails. EFI reset is actually its least preferred option, and so
> it is highly likely that it is untested on most of the shipping x86
> hardware if any of the other methods work.
> 
> So let's not touch this.

Agreed and that's really useful information, thanks!

	Ingo
