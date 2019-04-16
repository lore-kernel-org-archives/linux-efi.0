Return-Path: <SRS0=bC01=SS=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80FBAC10F13
	for <linux-efi@archiver.kernel.org>; Tue, 16 Apr 2019 11:35:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5149F20821
	for <linux-efi@archiver.kernel.org>; Tue, 16 Apr 2019 11:35:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=endlessm-com.20150623.gappssmtp.com header.i=@endlessm-com.20150623.gappssmtp.com header.b="uAkPAF7d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729198AbfDPLfb (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 16 Apr 2019 07:35:31 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:34524 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728888AbfDPLfb (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Tue, 16 Apr 2019 07:35:31 -0400
Received: by mail-qt1-f195.google.com with SMTP id k2so22851797qtm.1
        for <linux-efi@vger.kernel.org>; Tue, 16 Apr 2019 04:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hSpo+70L4YJM4x7lQl+FUrrPu4xrwP39JfmZPu4VWYs=;
        b=uAkPAF7dOR9jOlKZHaZlfPEmIS/RgB3aBfFO5ISaEvVTkkpTDvtkqE2+IQYHm0wHm5
         /JBoItz2UeYc0L3twdTNDOrT5Dd554Zs4I2/01JHZitwI53wuFt+wPWE4zEiuA+3Qr5H
         rIds5Z/hzLd3dkP4kkNvvu2g0wxgF91M/KviRxEqjsDwiw/wRFOCpm7rYVanNETHs5Rb
         Pzb8ZoCM1QC9DbqOBucMusuhjLWbwGd9l4mQv4sjPgA9/6Zy2pkpG/VXW3srkREJE2lv
         GUVSsmJqW9TZJwvLVCVmuXOOWWE/sj2pMwDNwvOWY355/IBgBeAD8FJmLLp+Vdhb9Mi2
         RkqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hSpo+70L4YJM4x7lQl+FUrrPu4xrwP39JfmZPu4VWYs=;
        b=uBgbg90bI4OzoQZ1wqflAX8e39KBUai9cdNC6gtPlZcByygl1P7MOKutF+Y0VcXaZc
         5BbIevESTmg51uuh9ALh6vIoagfXAV4lWoRsdlG+qEIgcFyD/EtKYi8dAPDPSK4z6Ryb
         L5TU25bvkvH/jrGiMwSMlnOp9TqkucZfeOKkx9EsXlw2n3U2hZsmsR7BNEau5sEmXg1x
         7/atsYTtyYmu9cDwRVMxg4etuZY2IetCbcuXNJbLPLeOwpKy58s2kNnxM8oB9Bi9FcWr
         2w7dWSiUvbIZaxq2/xfwUqjcG9nVUyAZDTrjuVzjAofiOPQRBr7ybuY2+ediyX8cUd8q
         ZMGg==
X-Gm-Message-State: APjAAAVZQx++MrxixQxd2e0XWRz/0UI68XLi7F6MzGKuQF/lpi/sgTTC
        1ae0pI9GDlm+eEcB+NE98kM9itr/dSXNlmI33D4fLg==
X-Google-Smtp-Source: APXvYqzNI5yfa49bSXSBniO2uM3TwMAMktYM04Sc142dyQ9kAJmI7sym+gBLu3fMdqLnJJIPfXaYpyZLnqtpzhPApSA=
X-Received: by 2002:ac8:3789:: with SMTP id d9mr17158568qtc.34.1555414529821;
 Tue, 16 Apr 2019 04:35:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190412080152.3718-1-jian-hong@endlessm.com> <tip-0082517fa4bce073e7cf542633439f26538a14cc@git.kernel.org>
 <20190416082042.GA69717@gmail.com>
In-Reply-To: <20190416082042.GA69717@gmail.com>
From:   Daniel Drake <drake@endlessm.com>
Date:   Tue, 16 Apr 2019 19:35:18 +0800
Message-ID:
 <CAD8Lp44pQRYdw4cbfMt3uOSO23dzy_mWTt5T-Zjft08WWu_yUA@mail.gmail.com>
Subject: Re: EFI reboot vs. ACPI reboot (was: Re: [tip:x86/urgent] x86/reboot,
 efi: Use EFI reboot for Acer TravelMate X514-51T)
To:     Ingo Molnar <mingo@kernel.org>
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
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
Message-ID: <20190416113518.dt9pzLX3MHolspiVcIP75BZ-MYkKGRDVlQvvL7muZ2Y@z>

On Tue, Apr 16, 2019 at 4:20 PM Ingo Molnar <mingo@kernel.org> wrote:
> I wanted to get a second opinion from the EFI folks for this whole
> concept. On x86 we default to ACPI reboot on modern systems, and we
> default to EFI reboot on modern EFI systems, via the
> efi_reboot_required() method which keys off on acpi_gbl_reduced_hardware
> to create a barrier for older ACPI systems.

So if acpi_gbl_reduced_hardware is set, we are on a "modern EFI
system", and EFI reboot is used.

> It appears that Acer TravelMate X514-51T systems get marked as
> 'acpi_gbl_reduced_hardware' which enables ACPI-reboot, but they require
> EFI-reboot.

We will double check, but in this case I believe the system is *not*
marked as reduced hardware, which is why ACPI reboot is used.

> Should we perhaps re-think the boundary between EFI-reboot and
> ACPI-reboot systems? I.e. if the EFI runtime is enabled, shouldn't we
> just use the EFI reboot method?

I agree this is a good question.

We also previously hit a similar issue for shutdown on Acer laptops
which is still unresolved.
https://marc.info/?l=linux-acpi&m=148857214431346&w=2

Daniel
