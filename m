Return-Path: <SRS0=G8aV=ST=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AA80C282DA
	for <linux-efi@archiver.kernel.org>; Wed, 17 Apr 2019 18:23:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDC2020674
	for <linux-efi@archiver.kernel.org>; Wed, 17 Apr 2019 18:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555525427;
	bh=pXTvCfPBdoIeE8zuaKezd4hDBUYum4AWnKkD8VDICGg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=rK3iiG3kw+NbRcDKaNTyoP2Dqa/ebcVOQlmDlU3pys6h7FEOr2Ez4hCjWCraBXsk/
	 AzVfHw43btBZ/trAnyyPUYBa6DPgPf5GkrB54bGRg2Rpn6KVEaEWL80nZzapmfV6W0
	 Ei8o1Y8FR2bFKyd1RQvwe/t1OwHW9nHvRIacZZQk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730308AbfDQSXr (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 17 Apr 2019 14:23:47 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:34100 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728373AbfDQSXr (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Wed, 17 Apr 2019 14:23:47 -0400
Received: by mail-wr1-f53.google.com with SMTP id w16so3249672wrl.1;
        Wed, 17 Apr 2019 11:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1POMudkOg7ZMnCSs+YnvPunwdXlUfWUqcoeFnoOiFR4=;
        b=P8L+gqS1jjv6UZdPpAUWU48A+vC9wN8UGx25cMYdiio1+TRuRdwC+M8Vl/jEZnYKY3
         emi6v/y7+tOCEOUc13PhoipVcyR5MgTus4xhCd1x06m/khdKHPXwpD2KzlgDuIq7mgqb
         6MrgLAqpoYwxaJMpWhykh8ZMlK4ir3F7c3QRIDyfL0ddXtWKwuTg0bbxvUTf2LmPE/Wg
         OATd8B57YgymaWiwLaezOYwhZIPrLG1ZmRWlV77QFwphT6KR0RH9uRG62udVP/4zTHw3
         9Xdz5Lt25g5DY6O74wrAoiUXnRT1aSbgXp7U9Ruw0yn0s3UvfmG3kj6RXeoNRUS8gt4r
         kojg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=1POMudkOg7ZMnCSs+YnvPunwdXlUfWUqcoeFnoOiFR4=;
        b=uoGOnJD3/2dOTWlt35vIOvg3F0U9/P4afb4JaMPN47eAFoiPD73hcnH8xISlegX0E4
         CkvyF0OqMRnUKRwccXzw9HkvWtky98hiIxV/6/nkU319m8tTlGJbnsVIG9Dwe+CETdxV
         oAJ+P8eUpDOen0kg/ymBI0G1bS5++/kTaWlxN2mgjhGwnmbOMLhStiAH5sTd8vjRW1Yw
         u7YvYsP+aq6i0RnDks2zaaacwsGWFJYF8Fnhni+5mIJf2dveS5u661DzlQ+RYDuHpErg
         KheHUHjjF1mqEIHn5uDR0c7JbSPrW/SCCZxKJIly7wUe2pf4JrW/I0QKF0g+mgGD1Fgt
         +zlQ==
X-Gm-Message-State: APjAAAUEMJ4uwDMsrtU8CxuZLKT4ggnefNVFV61U2ccaZ0kb5d7PrJAp
        O4hX5OmQ1sOiZV2QHz0tYHQ=
X-Google-Smtp-Source: APXvYqwxbqNW/plFqmrGhB2G5xMzZ+dlX6W7BKgxwDFj050DWrNZFKxiqjk0N4Ko/qCBcyzwXJe0ig==
X-Received: by 2002:adf:ef0c:: with SMTP id e12mr56645812wro.170.1555525425169;
        Wed, 17 Apr 2019 11:23:45 -0700 (PDT)
Received: from gmail.com (2E8B0CD5.catv.pool.telekom.hu. [46.139.12.213])
        by smtp.gmail.com with ESMTPSA id o10sm88391387wru.54.2019.04.17.11.23.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 Apr 2019 11:23:44 -0700 (PDT)
Date:   Wed, 17 Apr 2019 20:23:41 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
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
Message-ID: <20190417182341.GA5140@gmail.com>
References: <20190412080152.3718-1-jian-hong@endlessm.com>
 <tip-0082517fa4bce073e7cf542633439f26538a14cc@git.kernel.org>
 <20190416082042.GA69717@gmail.com>
 <CAD8Lp44pQRYdw4cbfMt3uOSO23dzy_mWTt5T-Zjft08WWu_yUA@mail.gmail.com>
 <20190417061650.GA31060@gmail.com>
 <CAD8Lp45BLaoXF=RNcncqcTtNvaGHP72+a1CxcjoeBXDiw9TKbA@mail.gmail.com>
 <17516564-37AC-4F77-9C0D-0DD71F8045EA@zytor.com>
 <CAKv+Gu_jqoKiqq4ozcPwSxLmpuaWsFKy_xyYGhECLz+KLHOjOw@mail.gmail.com>
 <FFF73D592F13FD46B8700F0A279B802F48AFEFF2@ORSMSX114.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
In-Reply-To: <FFF73D592F13FD46B8700F0A279B802F48AFEFF2@ORSMSX114.amr.corp.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
Message-ID: <20190417182341.ntubu4HKMSAiKoICkGGxA3dIFmweuQvLvimwzQyqzU4@z>


* Prakhya, Sai Praneeth <sai.praneeth.prakhya@intel.com> wrote:

> I will ask around internally to check if it is a good idea to make EFI 
> reboot the default method when the machine is booted in EFI mode.

Or whether there's some robust signature that indicates "modern EFI 
system where EFI reboot is the primary method"?

Major EFI version or ACPI version or such?

Thanks,

	Ingo
