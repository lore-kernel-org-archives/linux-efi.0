Return-Path: <linux-efi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F152CDB482
	for <linux-efi@archiver.kernel.org>; Wed, 18 Oct 2023 01:24:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344182AbjJRBYp (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 17 Oct 2023 21:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjJRBYo (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Tue, 17 Oct 2023 21:24:44 -0400
X-Greylist: delayed 351 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 17 Oct 2023 18:24:42 PDT
Received: from w4.tutanota.de (w4.tutanota.de [81.3.6.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BF290;
        Tue, 17 Oct 2023 18:24:42 -0700 (PDT)
Received: from tutadb.w10.tutanota.de (unknown [192.168.1.10])
        by w4.tutanota.de (Postfix) with ESMTP id C634810602E9;
        Wed, 18 Oct 2023 01:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1697591929;
        s=s1; d=bens.haus;
        h=From:From:To:To:Subject:Subject:Content-Description:Content-ID:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Cc:Cc:Date:Date:In-Reply-To:MIME-Version:MIME-Version:Message-ID:Message-ID:Reply-To:References:Sender;
        bh=NV9Ui7WPiv06N20hCTJ4MNdUogbGN6WVmx0Xbz99u0w=;
        b=TbfW2WQ2eAxSCG0f9iYFRbx4QjW/VG9gIBmAi5NGtKrrbSl+PUN8x/3T0TUNMLMI
        KGNceXxNHwOv96tX8Qw913dnwHfdBZbtglgRA5FSMl+13+2hgTrgbqoAPEpaMXzys/y
        EnobUwV89ATcIHD+ITF+lmP99NrSf2p9UVtOli5/X130WXwqTRah0NBw7Dc7ZtjlxWq
        g4ItZtjtTY4+fxY/0GzLkYrnslIn9moAra3EUHpYiUjNjjg3QIGg2uvpWLXOG6uTlRA
        e+Vu6BF9tEdRsFJJnfu7EWbZqHqY0C8BSWrFlnba1oRUeVdfO6uShxlA2ojBgaJn5Zm
        zqS2/MqNgw==
Date:   Wed, 18 Oct 2023 03:18:49 +0200 (CEST)
From:   Ben Schneider <ben@bens.haus>
To:     Ardb <ardb@kernel.org>
Cc:     Regressions <regressions@lists.linux.dev>,
        Linux Efi <linux-efi@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Message-ID: <Nh-DzlX--3-9@bens.haus>
Subject: [REGRESSION] boot fails for EFI boot stub loaded by u-boot
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Hi Ard,

I have an ESPRESSObin Ultra (aarch64) that uses U-Boot as its bootloader. I=
t shipped from the manufacturer with with v5.10, and I've been trying to up=
grade. U-Boot supports booting Image directly via EFI (https://u-boot.readt=
hedocs.io/en/latest/usage/cmd/bootefi.html), and I have been using it that =
way to successfully boot the system up to and including v6.0.19. However, v=
6.1 and v6.5 kernels fail to boot.

When booting successfully, the following messages are displayed:

EFI stub: Booting Linux Kernel...EFI stub: ERROR: FIRMWARE BUG: efi_loaded_=
image_t::image_base has bogus value
EFI stub: ERROR: FIRMWARE BUG: kernel image not aligned on 64k boundary
EFI stub: Using DTB from configuration table
EFI stub: ERROR: Failed to install memreserve config table!
EFI stub: Exiting boot services...
[=C2=A0=C2=A0=C2=A0 0.000000] Booting Linux on physical CPU 0x0000000000 [0=
x410fd034]

I suspect many of the above error messages are simply attributable to using=
 U-Boot to load an EFI stub and can be safely ignored given that the system=
 boots and runs fine.

When boot fails (v6.5), the following messages are displayed:

EFI stub: Booting Linux Kernel...
EFI stub: ERROR: FIRMWARE BUG: efi_loaded_image_t::image_base has bogus val=
ue
EFI stub: ERROR: FIRMWARE BUG: kernel image not aligned on 64k boundary
EFI stub: ERROR: Failed to install memreserve config table!
EFI stub: Using DTB from configuration table
EFI stub: Exiting boot services...
EFI stub: ERROR: Unable to construct new device tree.
EFI stub: ERROR: Failed to update FDT and exit boot services

In case it's relevant, the device tree for this device is arch/arm64/boot/m=
arvell/armada-3720-espressobin-ultra.dts

Hopefully I've reported this in the correct place or that the information p=
rovided is sufficient to get it where it needs to be. Let me know if there =
is additional information I can provide. I am also able to use the device t=
o test.

Sincerely,

Ben Schneider

#regzbot introduced v6.0..v6.1
