Return-Path: <SRS0=ZyQ3=6A=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B55C5C2BB85
	for <linux-efi@archiver.kernel.org>; Thu, 16 Apr 2020 14:36:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8838A21D7E
	for <linux-efi@archiver.kernel.org>; Thu, 16 Apr 2020 14:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587047809;
	bh=PYTwFrTrtoxecR9b9yLkbn2rNqR1ub19DHPDT5x72ME=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=X4ZFCVvl2eOXrjFcL+Gor6yfIo9QSZKT5eovx3vPPU+gO8JxGz2hDwgxM1sq4IUZc
	 I2uDGT4yjCOuAmqKIAdoBQ1Sk/sdInl6mUf7aQhKCqaYnQMbRQeUTspkxdHeeW4CQe
	 sH0wIbU+rJ/Eaxe458o/JEH9G0zKFtUtB0YaAGpY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732727AbgDPOgs (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 16 Apr 2020 10:36:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:41422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732436AbgDPOgi (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Thu, 16 Apr 2020 10:36:38 -0400
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCC712220A;
        Thu, 16 Apr 2020 14:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587047798;
        bh=PYTwFrTrtoxecR9b9yLkbn2rNqR1ub19DHPDT5x72ME=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=CRJDhvzdFLmI1uoXUxDuFr2eV6PI9NP0xP+7Uszi9UdUwIotblemb2vQd/iYubdgJ
         nd6C26pFAwiDhMqxUuL+NTdehy+Bwz+t6f6OqYg777IjU0CBfVX1RtxQVRGpgCr/EE
         3jaVKuiYBkcBH7TGHTGHYbLSoyvwq26mdYu/eNzc=
Received: by mail-io1-f43.google.com with SMTP id f3so21298190ioj.1;
        Thu, 16 Apr 2020 07:36:37 -0700 (PDT)
X-Gm-Message-State: AGi0PuZED3M963PLCOlB/QDxOf3kzG+xG/pft5K4bfxGa6pnZ2AGLDQr
        PVlJsolS8fnG+y76pzGRoYq9eeeEqdkY5khhEks=
X-Google-Smtp-Source: APiQypJP93oCECQtutJ31AuOSoB19HwPbIbakrt9SmlbEm/P8Y1a2FMHgiNs5L9YeZ+2lg0fv9WrETeA4RdQ4WRIliY=
X-Received: by 2002:a02:6a1e:: with SMTP id l30mr29737450jac.98.1587047797309;
 Thu, 16 Apr 2020 07:36:37 -0700 (PDT)
MIME-Version: 1.0
References: <eb0d88d0-879e-c500-261e-69c76fb68a89@linux.intel.com>
In-Reply-To: <eb0d88d0-879e-c500-261e-69c76fb68a89@linux.intel.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 16 Apr 2020 16:36:25 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGGdwuP6X5jvbqmjsP2+bZ7CoJKZ5-WVoPYEjq9HTjuDA@mail.gmail.com>
Message-ID: <CAMj1kXGGdwuP6X5jvbqmjsP2+bZ7CoJKZ5-WVoPYEjq9HTjuDA@mail.gmail.com>
Subject: Re: Regression with commit 0a67361dcdaa
To:     Jarkko Nikula <jarkko.nikula@linux.intel.com>
Cc:     linux-efi <linux-efi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Thu, 16 Apr 2020 at 16:35, Jarkko Nikula
<jarkko.nikula@linux.intel.com> wrote:
>
> Hi
>
> v5.7-rc1 hangs in early boot on an Intel Atom based prototype hardware
> while v5.6 boots fine. I bisected the regression into 0a67361dcdaa
> ("efi/x86: Remove runtime table address from kexec EFI setup data").
>
> v5.7-rc1 caused a reboot loop on another Intel Core based prototype HW.
> Reboots also on top of 0a67361dcdaa but boots fine with that commit
> reverted.
>
> Our test system uses kexec to boot the test kernel. These two machines
> got regression with v5.7-rc1. We have also others that boot fine.
>

This should already be fixed in Linus's tree. Please report back
whether that solves your problem or not.
