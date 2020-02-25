Return-Path: <SRS0=6ZW1=4N=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E802C35E01
	for <linux-efi@archiver.kernel.org>; Tue, 25 Feb 2020 20:38:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43FB421744
	for <linux-efi@archiver.kernel.org>; Tue, 25 Feb 2020 20:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582663098;
	bh=wf1GEETTy9Tmvl1POa0eMSLJO+wb8S8fRzOb41R6aKg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=LzDkhQbdLsbN9uYRLV79r7NB9RfQ9d+5KhPY7Sjl9k2y2uFEHkB/nkgU/e0Ywcgvs
	 zGhRInsnymClLnm5NogMH0P7eYlPlyf2xMeMaNck43oilJ770gTEP7bEBQD73AA2vk
	 soCB5gMMGlfCwlliFTu/eoI+0cCqAxUrKTAr2QeE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731844AbgBYUiQ (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 25 Feb 2020 15:38:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:58014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731297AbgBYUiQ (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Tue, 25 Feb 2020 15:38:16 -0500
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95DCE222C2
        for <linux-efi@vger.kernel.org>; Tue, 25 Feb 2020 20:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582663095;
        bh=wf1GEETTy9Tmvl1POa0eMSLJO+wb8S8fRzOb41R6aKg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=eKlezWrH87KSpUfrujyoeykj1HZ9mgwPIxYhJSyltk+oDZ9s0gybnJ/Ph8dlwV8Zv
         UDyx+otbRGWUHTw19fQOVccBkHtAMrI8a5SXDRurnlc0VLpPb635H+cd6P7bSk8cZl
         7sJKPmYvSkj8c0LDkyUPNLbwX69/RMuuIclLmCKU=
Received: by mail-wm1-f41.google.com with SMTP id q9so612317wmj.5
        for <linux-efi@vger.kernel.org>; Tue, 25 Feb 2020 12:38:15 -0800 (PST)
X-Gm-Message-State: APjAAAUx/Q98fEYB3EwFxMR2WONaiH7LRVkzyL6CIQuAGo5rHkB9cFQy
        wYKrK1paYZpR2VGekgLA6TIPapPJ5i+ir3UsSZSChA==
X-Google-Smtp-Source: APXvYqy10vBwMnO+jqV4umszV3JOCCoVRLjxhIPBG9u7+mlkaTCsBI5YDYsWV5XccmkFKbKBB/RigDbG1FhF+0iEJ14=
X-Received: by 2002:a1c:bc46:: with SMTP id m67mr970737wmf.40.1582663094092;
 Tue, 25 Feb 2020 12:38:14 -0800 (PST)
MIME-Version: 1.0
References: <cover.1582662842.git.thomas.lendacky@amd.com>
In-Reply-To: <cover.1582662842.git.thomas.lendacky@amd.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 25 Feb 2020 21:38:03 +0100
X-Gmail-Original-Message-ID: <CAKv+Gu_sd26ZEj8O10O3jLdzzh7FasBq9Suw_5kG_9hwtdNqmg@mail.gmail.com>
Message-ID: <CAKv+Gu_sd26ZEj8O10O3jLdzzh7FasBq9Suw_5kG_9hwtdNqmg@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] SME EFI table updates/fixes
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        linux-efi <linux-efi@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Tue, 25 Feb 2020 at 21:34, Tom Lendacky <thomas.lendacky@amd.com> wrote:
>
> This patch series adds new EFI tables to the list of tables that are
> to be mapped unencrypted when SME is active
>
> - EFI TPM log and TPM final log tables
> - EFI RNG seed table
>
> ---
>
> Patches based on
>   git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git next
>
> and commit:
>   dc235d62fc60 ("efi: Bump the Linux EFI stub major version number to #1")
>
> Changes since v2:
> - Split the patch into TPM related and RNG related patches
> - Account for the moving of the RNG seed EFI table from struct efi
>   to a static variable
>
> Tom Lendacky (2):
>   x86/efi: Add TPM related EFI tables to unencrypted mapping checks
>   x86/efi: Add RNG seed EFI table to unencrypted mapping check
>

Thanks Tom. I'll queue these up.
