Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D34BC433EF
	for <linux-efi@archiver.kernel.org>; Wed, 30 Mar 2022 07:11:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243699AbiC3HM5 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 30 Mar 2022 03:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243685AbiC3HMy (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Wed, 30 Mar 2022 03:12:54 -0400
Received: from cavan.codon.org.uk (irc.codon.org.uk [IPv6:2a00:1098:84:22e::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 568211017DF;
        Wed, 30 Mar 2022 00:11:05 -0700 (PDT)
Received: by cavan.codon.org.uk (Postfix, from userid 1000)
        id C132340A71; Wed, 30 Mar 2022 08:11:03 +0100 (BST)
Date:   Wed, 30 Mar 2022 08:11:03 +0100
From:   Matthew Garrett <mjg59@srcf.ucam.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Daniel Kiper <daniel.kiper@oracle.com>,
        Alec Brown <alec.r.brown@oracle.com>,
        Kanth Ghatraju <kanth.ghatraju@oracle.com>,
        Ross Philipson <ross.philipson@oracle.com>,
        "dpsmith@apertussolutions.com" <dpsmith@apertussolutions.com>,
        "piotr.krol@3mdeb.com" <piotr.krol@3mdeb.com>,
        "krystian.hebel@3mdeb.com" <krystian.hebel@3mdeb.com>,
        "persaur@gmail.com" <persaur@gmail.com>,
        "Yoder, Stuart" <stuart.yoder@arm.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "michal.zygowski@3mdeb.com" <michal.zygowski@3mdeb.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "lukasz@hawrylko.pl" <lukasz@hawrylko.pl>,
        linux-efi <linux-efi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        The development of GNU GRUB <grub-devel@gnu.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: Linux DRTM on UEFI platforms
Message-ID: <20220330071103.GA809@srcf.ucam.org>
References: <20220329174057.GA17778@srcf.ucam.org>
 <CAMj1kXE-7yPTBgQQKXRnQbdvLMv6D7=CowtQ38PdpPVa3SW-Ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXE-7yPTBgQQKXRnQbdvLMv6D7=CowtQ38PdpPVa3SW-Ag@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Wed, Mar 30, 2022 at 09:02:18AM +0200, Ard Biesheuvel wrote:

> Wouldn't it be better for the secure launch kernel to boot the EFI
> entrypoint directly? As it happens, I just completed a PoC last week
> for a minimal implementation of EFI (in Rust) that only carries the
> pieces that the EFI stub needs to boot Linux. It is currently just a
> proof of concept that only works on QEMU/arm64, but it should not be
> too hard to adapt it for x86 and for booting a kernel that has already
> been loaded to memory.

The EFI stub carries out a bunch of actions that have meaningful 
security impact, and that's material that should be measured. Having the 
secure launch kernel execute the stub without awareness of what it does 
means it would need to measure the code without measuring the state, 
while the goal of DRTM solutions is to measure state rather than the 
code.
