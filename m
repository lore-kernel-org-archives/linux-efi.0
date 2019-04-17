Return-Path: <SRS0=G8aV=ST=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5168C282DF
	for <linux-efi@archiver.kernel.org>; Wed, 17 Apr 2019 16:37:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A1752173C
	for <linux-efi@archiver.kernel.org>; Wed, 17 Apr 2019 16:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555519056;
	bh=Y99Ss9SBDWgmsbIcPdwHnvdkMrJ2zrSwVyk+WaOzDzk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=iZhDC8UHDfFkquDza83RK5lt4XDuT1ZplUzEaH3DFoiIlAFrJTyIYF2t+TwSbuMAq
	 XGrzZ8MSO3Kif7Mc9wZbEmcYQBkbmKEcFkSa68SHO5fjFqkst6cSrqwU44NLKQd/Cr
	 bs+2bIjbvxEH4ZPkShlqpuL6sVl8Z0VO5b3/J86U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732590AbfDQQhg (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 17 Apr 2019 12:37:36 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:39931 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729641AbfDQQhg (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Wed, 17 Apr 2019 12:37:36 -0400
Received: by mail-wm1-f54.google.com with SMTP id n25so4375258wmk.4;
        Wed, 17 Apr 2019 09:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SpiYuiEe/yu3VU9+DNKpLkeipOLQ5fUIio3TTan/W50=;
        b=OaqJjwFUy2JI1zPzZVksop3bSldyW3FX1lK/WNaEYgktryWrE+Mh68/AazYJIS7z2Y
         hvIPF8OOTt9a3BUjU1ZgniDFDeW7Z/AeqpKSPWQnC9F/cQeU3p6KvHYObvHYbVS4Nq8a
         YFSs5283QNgCWw1FY7rt4jTkQTISPmVZTnPMmXC1uvwJti9p2p0QdwXE5ghlhBL/DHBy
         ttQXDaFGL+lNRc/fCsALl48k68qAXona6h8m3DjsW+tQcws2M/3KHFgI9gmPP7hv15P/
         RipZhwy2OGtpuh+Uljd4aRveX7t5nMSrHbnfEFdlvHAKp0ki7feRj9Uu+HcEnHKtOuRX
         LllQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=SpiYuiEe/yu3VU9+DNKpLkeipOLQ5fUIio3TTan/W50=;
        b=gsZrjd9Pyf1evbPATJI5dfjvf1nW5Xx856UGm2abbH6v2dRYTPryOSZsVTWKneJiqG
         c64R2X7A/PE9GdGpydXf5TVGSNROMwrpqJ7IWe4caSg3HIXmtIXZCOjqqr45TacwGW4I
         AjfpdOrPJAIiuyO1Ar8CX06/mfjch5x+ZiuteC7FlPH2IUiAbxZb2m8+XB29gabJe+VS
         JFARyBxgjCjwDsEyZQFbxi97MBmA4QcxhIa+lvFKs0jELV0/UFG3NW1G//jfoVrzLlqs
         7h5yg2r7xS/coFW2zZ/Sw0SVbCoeMwCLZyfmmUxQNSYA8N67smB4u8w7HHDjBn3vDDYf
         PDeA==
X-Gm-Message-State: APjAAAWuoFDSHhuB3AOikkW2J5IRwk1zacEeZZLvxDSXiTsa6sRU+LE3
        QfhxIIGgWizcWxjXeJQWQCU=
X-Google-Smtp-Source: APXvYqwtV90fDE40jfdMVFsMo6wU4nwmSpnC54eHsVYwZxju0jd5hqhxTgC55zMBjdpeEZG5AxsIJQ==
X-Received: by 2002:a1c:f50a:: with SMTP id t10mr426705wmh.86.1555519053774;
        Wed, 17 Apr 2019 09:37:33 -0700 (PDT)
Received: from gmail.com (2E8B0CD5.catv.pool.telekom.hu. [46.139.12.213])
        by smtp.gmail.com with ESMTPSA id j11sm73752445wrw.85.2019.04.17.09.37.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 Apr 2019 09:37:32 -0700 (PDT)
Date:   Wed, 17 Apr 2019 18:37:29 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     hpa@zytor.com
Cc:     Daniel Drake <drake@endlessm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jian-Hong Pan <jian-hong@endlessm.com>,
        matt@codeblueprint.co.uk,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-efi@vger.kernel.org, Len Brown <len.brown@intel.com>,
        linux-tip-commits@vger.kernel.org,
        Endless Linux Upstreaming Team <linux@endlessm.com>
Subject: Re: EFI reboot vs. ACPI reboot (was: Re: [tip:x86/urgent]
 x86/reboot, efi: Use EFI reboot for Acer TravelMate X514-51T)
Message-ID: <20190417163729.GA53511@gmail.com>
References: <20190412080152.3718-1-jian-hong@endlessm.com>
 <tip-0082517fa4bce073e7cf542633439f26538a14cc@git.kernel.org>
 <20190416082042.GA69717@gmail.com>
 <CAD8Lp44pQRYdw4cbfMt3uOSO23dzy_mWTt5T-Zjft08WWu_yUA@mail.gmail.com>
 <20190417061650.GA31060@gmail.com>
 <CAD8Lp45BLaoXF=RNcncqcTtNvaGHP72+a1CxcjoeBXDiw9TKbA@mail.gmail.com>
 <17516564-37AC-4F77-9C0D-0DD71F8045EA@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
In-Reply-To: <17516564-37AC-4F77-9C0D-0DD71F8045EA@zytor.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
Message-ID: <20190417163729.3wc1RXAhIr-8UxECFes6TduD2iGl_azqhLis123lPog@z>


* hpa@zytor.com <hpa@zytor.com> wrote:

> > Just to check, you mean: EFI reboot (and shutdown) become the default
> > methods when the machine is booted in EFI mode, and EFI stuff has not
> > been disabled with a kernel parameter?
> > Even when running in full hardware ACPI mode.

No, I still think "early" EFI is historically better with ACPI reboot.

But can we find a firmware flag perhaps that will *not* result in EFI 
reboot being turned off?

> This, I believe, is known to not work.

Yeah, I bet so.

My problem is that the code appears to have the wrong assumptions:

 /*
  * For most modern platforms the preferred method of powering off is via
  * ACPI. However, there are some that are known to require the use of
  * EFI runtime services and for which ACPI does not work at all.
  *
  * Using EFI is a last resort, to be used only if no other option
  * exists.
  */
 bool efi_reboot_required(void)
 {
         if (!acpi_gbl_reduced_hardware)
                 return false;

         efi_reboot_quirk_mode = EFI_RESET_WARM;
         return true;
 }


At minimum the comment is stale: "modern" platforms, *especially* when 
the only bootup method is EFI, as in the ACER laptop case, I think the 
preferred reboot method is absolutely an EFI reboot - and it's probably 
what Windows uses too.

The question is, is acpi_gbl_reduced_hardware false on the Acer 
TravelMate X514-51T? I think it has to be, for the quirk to make sense - 
if it's true then efi_reboot_required() would set the reboot method to 
EFI.

I.e. we seem to have a new category of systems that are advertising 
themselves as 'full ACPI compliant', which are NOT old EFI systems, but 
modern EFI systems.

Is there some good way to detect these - such as ACPI version or 
something?

Thanks,

	Ingo
