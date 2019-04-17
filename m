Return-Path: <SRS0=G8aV=ST=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A32E2C282DA
	for <linux-efi@archiver.kernel.org>; Wed, 17 Apr 2019 16:52:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D2EE217FA
	for <linux-efi@archiver.kernel.org>; Wed, 17 Apr 2019 16:52:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="jAuTWFNX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732591AbfDQQwR (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 17 Apr 2019 12:52:17 -0400
Received: from terminus.zytor.com ([198.137.202.136]:54473 "EHLO
        mail.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731745AbfDQQwQ (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Wed, 17 Apr 2019 12:52:16 -0400
Received: from [IPv6:2607:fb90:8673:1b5f:28a1:6df5:3434:e270] ([IPv6:2607:fb90:8673:1b5f:28a1:6df5:3434:e270])
        (authenticated bits=0)
        by mail.zytor.com (8.15.2/8.15.2) with ESMTPSA id x3HGpo153988963
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Wed, 17 Apr 2019 09:51:51 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com x3HGpo153988963
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2019041743; t=1555519912;
        bh=3FCbNtlpNkBp1GIaA1U+jCEm6STOsOg2M4zm/VQg17I=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=jAuTWFNXsXx5elHqDEu9dq3B8vUQKCD1frNZCzgFZW1+aUur2JX8Y+zoKdmjuldm9
         etnYCNvqcme2RfAdXyWSzjf2Rt7pgjfdDTX0kDi/0jFr4sXx5oSNAQhKxo1ecqI6Ke
         LVSwwAYKiYEEgi+GvicD4M7XfWUp6iX3Sd3Q1n9TucrcyotJWtELnwn8956hZbVf5x
         pODRx2XFyB1YpBB09xRVcJomEu0Ilcs/pLZEQVYDWh5ibLNDrv+4zKFRtkazjUsAzd
         IWv/n1c2Ig4FciJpbgOJN9A7YFD+na1An8wPQX2U7moNMvw5JqTqyTbkrHQNWu/ZOO
         qVf7tGUDQNwlQ==
Date:   Wed, 17 Apr 2019 09:51:47 -0700
User-Agent: K-9 Mail for Android
In-Reply-To: <20190417163729.GA53511@gmail.com>
References: <20190412080152.3718-1-jian-hong@endlessm.com> <tip-0082517fa4bce073e7cf542633439f26538a14cc@git.kernel.org> <20190416082042.GA69717@gmail.com> <CAD8Lp44pQRYdw4cbfMt3uOSO23dzy_mWTt5T-Zjft08WWu_yUA@mail.gmail.com> <20190417061650.GA31060@gmail.com> <CAD8Lp45BLaoXF=RNcncqcTtNvaGHP72+a1CxcjoeBXDiw9TKbA@mail.gmail.com> <17516564-37AC-4F77-9C0D-0DD71F8045EA@zytor.com> <20190417163729.GA53511@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: Re: EFI reboot vs. ACPI reboot (was: Re: [tip:x86/urgent] x86/reboot, efi: Use EFI reboot for Acer TravelMate X514-51T)
To:     Ingo Molnar <mingo@kernel.org>
CC:     Daniel Drake <drake@endlessm.com>,
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
From:   hpa@zytor.com
Message-ID: <1DE9F317-8B95-40F4-89AF-A3573B1C4881@zytor.com>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
Message-ID: <20190417165147.1YzQ6SWgQQRyTNjA_aX4G0ivCPn5K8AgWMnS0ZWi6hg@z>

On April 17, 2019 9:37:29 AM PDT, Ingo Molnar <mingo@kernel=2Eorg> wrote:
>
>* hpa@zytor=2Ecom <hpa@zytor=2Ecom> wrote:
>
>> > Just to check, you mean: EFI reboot (and shutdown) become the
>default
>> > methods when the machine is booted in EFI mode, and EFI stuff has
>not
>> > been disabled with a kernel parameter?
>> > Even when running in full hardware ACPI mode=2E
>
>No, I still think "early" EFI is historically better with ACPI reboot=2E
>
>But can we find a firmware flag perhaps that will *not* result in EFI=20
>reboot being turned off?
>
>> This, I believe, is known to not work=2E
>
>Yeah, I bet so=2E
>
>My problem is that the code appears to have the wrong assumptions:
>
> /*
>* For most modern platforms the preferred method of powering off is via
>  * ACPI=2E However, there are some that are known to require the use of
>  * EFI runtime services and for which ACPI does not work at all=2E
>  *
>  * Using EFI is a last resort, to be used only if no other option
>  * exists=2E
>  */
> bool efi_reboot_required(void)
> {
>         if (!acpi_gbl_reduced_hardware)
>                 return false;
>
>         efi_reboot_quirk_mode =3D EFI_RESET_WARM;
>         return true;
> }
>
>
>At minimum the comment is stale: "modern" platforms, *especially* when=20
>the only bootup method is EFI, as in the ACER laptop case, I think the=20
>preferred reboot method is absolutely an EFI reboot - and it's probably
>
>what Windows uses too=2E
>
>The question is, is acpi_gbl_reduced_hardware false on the Acer=20
>TravelMate X514-51T? I think it has to be, for the quirk to make sense
>-=20
>if it's true then efi_reboot_required() would set the reboot method to=20
>EFI=2E
>
>I=2Ee=2E we seem to have a new category of systems that are advertising=
=20
>themselves as 'full ACPI compliant', which are NOT old EFI systems, but
>
>modern EFI systems=2E
>
>Is there some good way to detect these - such as ACPI version or=20
>something?
>
>Thanks,
>
>	Ingo

That is exactly what the reduced hardware flag is supposed to indicate=2E =
As far as what Windows does, the are only two ways to find out: testing som=
ehow, or these days Microsoft might actually answer if we ask nicely=2E
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
