Return-Path: <SRS0=G8aV=ST=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EAE9C282DA
	for <linux-efi@archiver.kernel.org>; Wed, 17 Apr 2019 15:16:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1721021773
	for <linux-efi@archiver.kernel.org>; Wed, 17 Apr 2019 15:16:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="Ny7U4nnY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730463AbfDQPQa (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 17 Apr 2019 11:16:30 -0400
Received: from terminus.zytor.com ([198.137.202.136]:53053 "EHLO
        mail.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729940AbfDQPQa (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Wed, 17 Apr 2019 11:16:30 -0400
Received: from [IPv6:2601:646:8680:2bb1:44b5:416e:6c3:6b62] ([IPv6:2601:646:8680:2bb1:44b5:416e:6c3:6b62])
        (authenticated bits=0)
        by mail.zytor.com (8.15.2/8.15.2) with ESMTPSA id x3HFG3Te3954512
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Wed, 17 Apr 2019 08:16:06 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com x3HFG3Te3954512
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2019041743; t=1555514167;
        bh=+XtVu+cuYYqMVuESz6fvwq8kAr8YsIY/IcDBD8jljvw=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=Ny7U4nnYRxxKf+l1ftuCBnQTIfsc6PdWAvz/ePKIsLvex1LasMUKPOuDd9+4zUJkT
         vsezgiJ5F+wih9z0bLHtFtgbZCMONdZA514Mhx7PBRW8Hlg6oPh61ybBLLNmRU+EHy
         WyzCBCY/3ToqM12u1zD5Jpqv7QAFTjIFuK/XWWRuQlhtOr0QiN7p3iePuIo85lgidW
         nAqtvVTS41dbTTA+HgeBvwLrITd7ZRN5MxxtUzJswlQ92UpfLqD+PaKH09LWIxPoC/
         jZExddLQsRvXqurTwf2V5JdFBMTUDdoLD3wOllTRuPE34bTUshKhyvMDoBrnjZWoyd
         Dzi9Md/WVAwEg==
Date:   Wed, 17 Apr 2019 08:15:55 -0700
User-Agent: K-9 Mail for Android
In-Reply-To: <CAD8Lp45BLaoXF=RNcncqcTtNvaGHP72+a1CxcjoeBXDiw9TKbA@mail.gmail.com>
References: <20190412080152.3718-1-jian-hong@endlessm.com> <tip-0082517fa4bce073e7cf542633439f26538a14cc@git.kernel.org> <20190416082042.GA69717@gmail.com> <CAD8Lp44pQRYdw4cbfMt3uOSO23dzy_mWTt5T-Zjft08WWu_yUA@mail.gmail.com> <20190417061650.GA31060@gmail.com> <CAD8Lp45BLaoXF=RNcncqcTtNvaGHP72+a1CxcjoeBXDiw9TKbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: Re: EFI reboot vs. ACPI reboot (was: Re: [tip:x86/urgent] x86/reboot, efi: Use EFI reboot for Acer TravelMate X514-51T)
To:     Daniel Drake <drake@endlessm.com>, Ingo Molnar <mingo@kernel.org>
CC:     Peter Zijlstra <peterz@infradead.org>,
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
From:   hpa@zytor.com
Message-ID: <17516564-37AC-4F77-9C0D-0DD71F8045EA@zytor.com>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
Message-ID: <20190417151555.HIy0vrhI-XT8MPbv66tzhblumKcnHR1-WWXnIwdrBC8@z>

On April 17, 2019 5:38:41 AM PDT, Daniel Drake <drake@endlessm=2Ecom> wrote=
:
>On Wed, Apr 17, 2019 at 2:16 PM Ingo Molnar <mingo@kernel=2Eorg> wrote:
>> Ok, so acpi_gbl_reduced_hardware is set when the =2E=2E=2E 'reduced
>hardware'
>> bit is set:
>>
>>         acpi_gbl_reduced_hardware =3D FALSE;
>>         if (acpi_gbl_FADT=2Eflags & ACPI_FADT_HW_REDUCED) {
>>                 acpi_gbl_reduced_hardware =3D TRUE;
>>         }
>>
>>
>> which is described as:
>>
>>  #define ACPI_FADT_HW_REDUCED        (1<<20)     /* 20: [V5] ACPI
>hardware is not implemented (ACPI 5=2E0) */
>>
>> That seems counter-intuitive to me: if no full ACPI hardware is
>> implemented then we should assume reduced ACPI functionality, i=2Ee=2E =
if
>the
>> EFI runtime is otherwise available we should default to it=2E
>
>It's a bit confusing, but my loose understanding is that previous
>versions of the ACPI spec required system implementors to implement
>the whole thing; but that's increasingly impractical today, e=2Eg=2E with
>ARM systems coming along, which do not gel well with some of the
>historical x86-rooted design aspects that spilled over into ACPI=2E The
>V5 spec introduces reduced mode as an opt-in new feature, but for
>compatibility with pre-V5 implementations it needs to consider "full
>hardware" mode as the default=2E
>
>> Feel free to send a patch that makes EFI reboot the default one under
>> these circumstances,
>
>Just to check, you mean: EFI reboot (and shutdown) become the default
>methods when the machine is booted in EFI mode, and EFI stuff has not
>been disabled with a kernel parameter?
>Even when running in full hardware ACPI mode=2E
>
>Thanks
>Daniel

This, I believe, is known to not work=2E
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
