Return-Path: <SRS0=GtyG=5W=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 893B1C2BA19
	for <linux-efi@archiver.kernel.org>; Mon,  6 Apr 2020 13:20:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51B7323109
	for <linux-efi@archiver.kernel.org>; Mon,  6 Apr 2020 13:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586179243;
	bh=/diuoYfDNps0PKm2EIWXg6vofs6Y/sYAPX1d3JHK3e0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=RMQ2QPwaXqlsOW+QwSKFPudLAj7AudaaLvHaSljKjFMt8wic5RQepOJjYjJfQuF2B
	 RijAsoagHSs9/qWmXQpwMrIX6H8QFZV5DeE7k/J9nP2bD2hnumujFUynrV0V84S657
	 o8Nxd1P4qt9PbNxOU/ttDsL94YHPG3/atrwZDBK0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbgDFNUn (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 6 Apr 2020 09:20:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:57010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728018AbgDFNUm (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Mon, 6 Apr 2020 09:20:42 -0400
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D657F22525;
        Mon,  6 Apr 2020 13:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586179241;
        bh=/diuoYfDNps0PKm2EIWXg6vofs6Y/sYAPX1d3JHK3e0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=FArWIS8OLKRTDCnIfmIbvUX4FgyIkn7NrYdAag0/m9S/xVCiz1+7C3pnFQ6/FJpjW
         aWAQmUv2qS9idelP1leM1rj+/KNw+Yx+GgWfVX9H1UXRrMlSXcQ7rpe8XJ+F6nDhT9
         Kp8fF+mpqxCR6vlT6Ib1hAVZwGJWu1JfpSgBsImI=
Received: by mail-io1-f45.google.com with SMTP id b12so15646810ion.8;
        Mon, 06 Apr 2020 06:20:41 -0700 (PDT)
X-Gm-Message-State: AGi0PuZN+4UxCG0+nxvJtHWGC9kOwucu0pP0AeASLoG8iEYGHvVN9Sc1
        Z6ZTUr6cowuLKDK0yCr/onUAFp3B/rAwtu1bOnU=
X-Google-Smtp-Source: APiQypIVyAXMT7E/aAfDQd2edICxPmp90/maCJHv6uy3ageh6+PVBV4QYACU13jyI2fL+YFcO6LOQ2hjiItEfV93Pao=
X-Received: by 2002:a5d:8b83:: with SMTP id p3mr19192941iol.16.1586179241352;
 Mon, 06 Apr 2020 06:20:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200109150218.16544-1-nivedita@alum.mit.edu> <20200405154245.11972-1-me@prok.pw>
 <20200405231845.GA3095309@rani.riverdale.lan> <CAMj1kXHWhPmnaCS74n=1MYLfnsKqf+UAfmaLGQYx9jH3YsXvfg@mail.gmail.com>
 <a406bd0ab573e17c1004d3d91948938c209cf94d.camel@prok.pw>
In-Reply-To: <a406bd0ab573e17c1004d3d91948938c209cf94d.camel@prok.pw>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 6 Apr 2020 15:20:30 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHTQqYaK=vMs2O1Osy9NMi8dnn8ueBEPod6AaiZvQf0qQ@mail.gmail.com>
Message-ID: <CAMj1kXHTQqYaK=vMs2O1Osy9NMi8dnn8ueBEPod6AaiZvQf0qQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86/boot/compressed/64: Remove .bss/.pgtable from bzImage
To:     Sergey Shatunov <me@prok.pw>
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        Borislav Petkov <bp@alien8.de>, hpa@zytor.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mingo@redhat.com, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-efi <linux-efi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Mon, 6 Apr 2020 at 15:14, Sergey Shatunov <me@prok.pw> wrote:
>
> On Mon, 2020-04-06 at 10:44 +0200, Ard Biesheuvel wrote:
> > On Mon, 6 Apr 2020 at 01:18, Arvind Sankar <nivedita@alum.mit.edu>
> > wrote:
> > > On Sun, Apr 05, 2020 at 10:42:46PM +0700, Sergey Shatunov wrote:
> > > > This patch causes some strange things happens with my laptop.
> > > >
> > > > Cold boot crashed in some early initilization logic with message
> > > > 'Failed to execute /esp/.../linux.efi: Buffer Too Small'.
> > > > After couple reboots into firmware setup (bios) or hot reboot
> > > > from other working kernel (without that commit) helps it to boot.
> > > > During bisecting couple times I saw different message:
> > > > 'exit_efi() failed; efi_main() failed', but above tricks helps it
> > > > too.
> >
> > Could you please try adding 'efi=no_disable_early_pci_dma' to the
> > kernel command line? The lack of BSS zeroization may result in that
> > option to get inadvertently enabled, and it is known to break
> > exit_boot() on some systems.
>
> With 'efi=no_disable_early_pci_dma' it works again.
>

Thanks Sergey
