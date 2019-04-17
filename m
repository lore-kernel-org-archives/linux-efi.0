Return-Path: <SRS0=G8aV=ST=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31910C282DA
	for <linux-efi@archiver.kernel.org>; Wed, 17 Apr 2019 12:38:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0335D20835
	for <linux-efi@archiver.kernel.org>; Wed, 17 Apr 2019 12:38:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=endlessm-com.20150623.gappssmtp.com header.i=@endlessm-com.20150623.gappssmtp.com header.b="LXZP5yJf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbfDQMix (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 17 Apr 2019 08:38:53 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46990 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732190AbfDQMix (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Wed, 17 Apr 2019 08:38:53 -0400
Received: by mail-qt1-f194.google.com with SMTP id z17so27028073qts.13
        for <linux-efi@vger.kernel.org>; Wed, 17 Apr 2019 05:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PY2C+1xXL9se3lVqErpOfmzeBeNLhJ2ymdjjq7fQGb8=;
        b=LXZP5yJfwy67RgbWiPN+mNC8E0cvqwhSdBMX8G95PHS2zLVuhgTkRfZr7Nte4rYf38
         1iAEDS1PmoY8NJEyVYbTSw0Up4ia//v1B+snOz0jVQs19DdUGjQeuV0W4tY7uFiCgiB/
         E20+FVMvYP0PeWZxc6FcScB9gwRFHfOw3PpEffRfgPK0I6b5ZSqftTb+R/X1s7DX75fR
         Ico9e1335WFjRJN1QpzFkIPFKXKFDqPLREqOWNzxhA6BvFi3CZSPPbmFupH+AYJxLTcU
         bHGn81qzSskZSwMY8ylFccwC5ZUv5OMe/qyArSs88nTienmd0FZWy7RVjPzjS2EClc1o
         SOww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PY2C+1xXL9se3lVqErpOfmzeBeNLhJ2ymdjjq7fQGb8=;
        b=fTG1zBQwAgHMhE1ZIrEJc6Y5ZoA9WH+abd0qJ7M2Olw8OwX+mqTn1JfPZmOyQzALk9
         iPBIDx/ZH4WdcMSHZ2ZqEO2QzE8IILPTC2GVPEGQfc/R/qMY6dEWgPZ8x621ss2wR3Ay
         j/2+/kmx7LoGOI57TO7bjZ6pzRu8j9vA5RVrH4VFO2u6ubwOf/nuS5VyJ+gtfKWRxswR
         fzhGkNEVRGB9i8/n2YgKvq5/MDRQ2NbiNgVZEcG0v31vggbWPgC73IUwlDdCYOxs/ZV/
         +fGpiAmGIKzDCozLlnFW3vytve/RwJxfN5EbzjGhOs3Zyls/YyIWY5IaFZTZcaKm0HzU
         55Kw==
X-Gm-Message-State: APjAAAURfCwKDDCmCcZ+65lexx/iEJgWw6d0kVkg6VWYZgdFfn9I8GkD
        AfON0DOsbdrP9gaSZXrNfk3yUMDfKTeSaPhM4e5Myg==
X-Google-Smtp-Source: APXvYqwnBVp0C+GbcCeCb0OHBMwxtQ/yoMubKCAdnBg0VrWMJK9p88tGewd86RSNXsU8tHAtFfyQMIo5T4D4OsOpLfM=
X-Received: by 2002:aed:2208:: with SMTP id n8mr68337847qtc.168.1555504732238;
 Wed, 17 Apr 2019 05:38:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190412080152.3718-1-jian-hong@endlessm.com> <tip-0082517fa4bce073e7cf542633439f26538a14cc@git.kernel.org>
 <20190416082042.GA69717@gmail.com> <CAD8Lp44pQRYdw4cbfMt3uOSO23dzy_mWTt5T-Zjft08WWu_yUA@mail.gmail.com>
 <20190417061650.GA31060@gmail.com>
In-Reply-To: <20190417061650.GA31060@gmail.com>
From:   Daniel Drake <drake@endlessm.com>
Date:   Wed, 17 Apr 2019 20:38:41 +0800
Message-ID:
 <CAD8Lp45BLaoXF=RNcncqcTtNvaGHP72+a1CxcjoeBXDiw9TKbA@mail.gmail.com>
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
Message-ID: <20190417123841.vNWNogpDKzzI7rsAigOiyqp37G_QVeMubZJo8D2Vpso@z>

On Wed, Apr 17, 2019 at 2:16 PM Ingo Molnar <mingo@kernel.org> wrote:
> Ok, so acpi_gbl_reduced_hardware is set when the ... 'reduced hardware'
> bit is set:
>
>         acpi_gbl_reduced_hardware = FALSE;
>         if (acpi_gbl_FADT.flags & ACPI_FADT_HW_REDUCED) {
>                 acpi_gbl_reduced_hardware = TRUE;
>         }
>
>
> which is described as:
>
>  #define ACPI_FADT_HW_REDUCED        (1<<20)     /* 20: [V5] ACPI hardware is not implemented (ACPI 5.0) */
>
> That seems counter-intuitive to me: if no full ACPI hardware is
> implemented then we should assume reduced ACPI functionality, i.e. if the
> EFI runtime is otherwise available we should default to it.

It's a bit confusing, but my loose understanding is that previous
versions of the ACPI spec required system implementors to implement
the whole thing; but that's increasingly impractical today, e.g. with
ARM systems coming along, which do not gel well with some of the
historical x86-rooted design aspects that spilled over into ACPI. The
V5 spec introduces reduced mode as an opt-in new feature, but for
compatibility with pre-V5 implementations it needs to consider "full
hardware" mode as the default.

> Feel free to send a patch that makes EFI reboot the default one under
> these circumstances,

Just to check, you mean: EFI reboot (and shutdown) become the default
methods when the machine is booted in EFI mode, and EFI stuff has not
been disabled with a kernel parameter?
Even when running in full hardware ACPI mode.

Thanks
Daniel
