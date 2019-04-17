Return-Path: <SRS0=G8aV=ST=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 280F2C10F12
	for <linux-efi@archiver.kernel.org>; Wed, 17 Apr 2019 06:16:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC0BB20835
	for <linux-efi@archiver.kernel.org>; Wed, 17 Apr 2019 06:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555481819;
	bh=yv82CgGk+Vu7ZpN6qR+4YYLqQZ/fvLNiziXbiS8jqG4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=wrIwFAFnaPwhQNHk1e9xGOmlvnjFHWYGHA8+93zggRY9ws7rf2A6sNhYioaNfrg8v
	 GIJwcaoP2cXKTUBJj6ka0ZLHK1raRd7Tsx4Uslll5X48DQ/KvT4+q9HvLzMidwIezt
	 AVdYQ5CCFs9Nigof1fwV6rXiUk6Li61F4Qb61liA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729553AbfDQGQz (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 17 Apr 2019 02:16:55 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46524 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729446AbfDQGQz (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Wed, 17 Apr 2019 02:16:55 -0400
Received: by mail-wr1-f68.google.com with SMTP id t17so30196380wrw.13;
        Tue, 16 Apr 2019 23:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=icUxMHfklx8IQu1ksl9iV3STKTGGOGWanMU5EubAp9k=;
        b=IoGG4vUm+HvtvVZf+vOf46OfTlvQZgcxf7CG7zv/twp4FzQ/M2tRQGhZlVMfttj88Z
         m9EkjZoQQYxc9mUMeyZ4OwO1lxBV/IrMvCrYpSnXOpNXZ8EgYPa6Teg9Dih2xYPYpOyv
         XiscCgBit1zbtIBocthPmIUcIHe1Q8gdgJfcUDdmrRjSlj1u7TF1Kqr4+rjs6Psi6MCx
         ujl5YFmiHW1CdjK1UWUgUipELhNlvptr8gki/Tjfvo51+b5Lyav1SFtVYi4C1aDxvydy
         MAa5q5nWXPy7LCfhH1sCAORhk99cHxnjt22kp5rUJS8sgoW6JMra+Tl9g73rSFvfFXZU
         JB0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=icUxMHfklx8IQu1ksl9iV3STKTGGOGWanMU5EubAp9k=;
        b=sX/p7ftr4ad1oQ87rhwAoR4+odlTUGp0/rFnkw8R4NWNu1MnCR3Remop63ZuMeK4Rb
         4iJd3gWCp4fUBTCqputhOt1fCujhkRPjZJwFGb2C5vBTH2RK2rJXRdvitpogW76VE49x
         x9Cw9O6g3gPuN2dgrJeOfWl0b89cTHqgJvsK3E4zJ633JJAxIvbWcv4vmeeIU7J15yqn
         lNHpjB+4ihaIrnKkoHRlfjbxxL4Gpmt+VTjZptCigTLfVJekeUW5Q/VojN9UNO3r+vgz
         1tzq9F0P9SZ49oXt3T1NUxa3xg8kHANqpXUbXNOR6UBXrwMGyrkvG37KWqeoW7g8cY8t
         MnNw==
X-Gm-Message-State: APjAAAUDKhmPMrWwCKloVyIar1zmQFrC2GPWGv/AzQgfB9dItVNgtJG8
        UfNk5YrqKunPka4xSszDb7w=
X-Google-Smtp-Source: APXvYqxZ8d4V9ydHWZoDUPoVUczh473iRK/6u+II/JleXbQQrWfcSjDQ400kjenaZzZ4ctit+UuehQ==
X-Received: by 2002:adf:e547:: with SMTP id z7mr59016229wrm.295.1555481813338;
        Tue, 16 Apr 2019 23:16:53 -0700 (PDT)
Received: from gmail.com (2E8B0CD5.catv.pool.telekom.hu. [46.139.12.213])
        by smtp.gmail.com with ESMTPSA id u14sm49794926wrr.1.2019.04.16.23.16.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 16 Apr 2019 23:16:52 -0700 (PDT)
Date:   Wed, 17 Apr 2019 08:16:50 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     Daniel Drake <drake@endlessm.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jian-Hong Pan <jian-hong@endlessm.com>,
        matt@codeblueprint.co.uk,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>, hpa@zytor.com,
        linux-efi@vger.kernel.org, Len Brown <len.brown@intel.com>,
        linux-tip-commits@vger.kernel.org,
        Endless Linux Upstreaming Team <linux@endlessm.com>
Subject: Re: EFI reboot vs. ACPI reboot (was: Re: [tip:x86/urgent]
 x86/reboot, efi: Use EFI reboot for Acer TravelMate X514-51T)
Message-ID: <20190417061650.GA31060@gmail.com>
References: <20190412080152.3718-1-jian-hong@endlessm.com>
 <tip-0082517fa4bce073e7cf542633439f26538a14cc@git.kernel.org>
 <20190416082042.GA69717@gmail.com>
 <CAD8Lp44pQRYdw4cbfMt3uOSO23dzy_mWTt5T-Zjft08WWu_yUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
In-Reply-To: <CAD8Lp44pQRYdw4cbfMt3uOSO23dzy_mWTt5T-Zjft08WWu_yUA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
Message-ID: <20190417061650.p2u-XW5pEODtbBfJjl3Dzj3eG0gvLoxn6knMqedrrWM@z>


* Daniel Drake <drake@endlessm.com> wrote:

> On Tue, Apr 16, 2019 at 4:20 PM Ingo Molnar <mingo@kernel.org> wrote:
> > I wanted to get a second opinion from the EFI folks for this whole
> > concept. On x86 we default to ACPI reboot on modern systems, and we
> > default to EFI reboot on modern EFI systems, via the
> > efi_reboot_required() method which keys off on acpi_gbl_reduced_hardware
> > to create a barrier for older ACPI systems.
> 
> So if acpi_gbl_reduced_hardware is set, we are on a "modern EFI
> system", and EFI reboot is used.
> 
> > It appears that Acer TravelMate X514-51T systems get marked as
> > 'acpi_gbl_reduced_hardware' which enables ACPI-reboot, but they require
> > EFI-reboot.
> 
> We will double check, but in this case I believe the system is *not*
> marked as reduced hardware, which is why ACPI reboot is used.

Ok, so acpi_gbl_reduced_hardware is set when the ... 'reduced hardware' 
bit is set:

        acpi_gbl_reduced_hardware = FALSE;
        if (acpi_gbl_FADT.flags & ACPI_FADT_HW_REDUCED) {
                acpi_gbl_reduced_hardware = TRUE;
        }


which is described as:

 #define ACPI_FADT_HW_REDUCED        (1<<20)     /* 20: [V5] ACPI hardware is not implemented (ACPI 5.0) */

That seems counter-intuitive to me: if no full ACPI hardware is 
implemented then we should assume reduced ACPI functionality, i.e. if the 
EFI runtime is otherwise available we should default to it.

> > Should we perhaps re-think the boundary between EFI-reboot and
> > ACPI-reboot systems? I.e. if the EFI runtime is enabled, shouldn't we
> > just use the EFI reboot method?
> 
> I agree this is a good question.
> 
> We also previously hit a similar issue for shutdown on Acer laptops
> which is still unresolved.
> https://marc.info/?l=linux-acpi&m=148857214431346&w=2

Yeah.

Feel free to send a patch that makes EFI reboot the default one under 
these circumstances, we could put it into tip:x86/platform or so, and let 
it get tested for another kernel cycle. If it's problem-free we could 
push that upstream. (Famous last words.)

(This won't affect the ACER notebook quirk in tip:x86/urgent, which is 
the short-term solution and the -stable tag.)

Thanks,

	Ingo
