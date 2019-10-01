Return-Path: <SRS0=4Nwv=X2=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C6A8C352AA
	for <linux-efi@archiver.kernel.org>; Tue,  1 Oct 2019 22:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2E022190F
	for <linux-efi@archiver.kernel.org>; Tue,  1 Oct 2019 22:42:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725843AbfJAWmD convert rfc822-to-8bit (ORCPT
        <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 1 Oct 2019 18:42:03 -0400
Received: from www17.your-server.de ([213.133.104.17]:43456 "EHLO
        www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728043AbfJAWmD (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Tue, 1 Oct 2019 18:42:03 -0400
X-Greylist: delayed 1787 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Oct 2019 18:42:02 EDT
Received: from sslproxy01.your-server.de ([88.198.220.130])
        by www17.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <thomas@m3y3r.de>)
        id 1iFQNR-0004im-Mv
        for linux-efi@vger.kernel.org; Wed, 02 Oct 2019 00:12:13 +0200
Received: from [2a02:908:4c22:ec00:94c:bc63:8eb6:4404]
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <thomas@m3y3r.de>)
        id 1iFQNR-00028Y-85
        for linux-efi@vger.kernel.org; Wed, 02 Oct 2019 00:12:13 +0200
Date:   Wed, 02 Oct 2019 00:11:57 +0200
User-Agent: K-9 Mail for Android
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: 5.3.1: x86: efi stub seems to fail to load initrd file
To:     linux-efi@vger.kernel.org
From:   Thomas Meyer <thomas@m3y3r.de>
Message-ID: <D6FD0BFD-0934-4D9B-986C-89ED5CF13FE5@m3y3r.de>
X-Authenticated-Sender: thomas@m3y3r.de
X-Virus-Scanned: Clear (ClamAV 0.101.4/25589/Tue Oct  1 10:30:33 2019)
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Hi,

I've got this old x86 MacBookPro1,1 and I wanted to switch to systemd-boot.

systemd-boot works fine but the Linux efistub somehow fails to load the initrd, sadly the monitor seems to be switched off/no backlight after systemd-boot menu selection and Linux kernel starting efifb.

Any ideas what could be the culprit?
I tried to boot with efi=nochunk but same result.

I tried to understand what systemd boot does for file loading and what libefistub does, it looks very similar.

So any ideas and hints are welcome what is maybe wrong in my setup.

When I embedded the initramfs in the kernel, boot of Linux and system works correctly.

Ps: all efi_printk seems to be lost in the kernel. Is there a way to transfer this into the kernel somehow?

With kind regards
Thomas
