Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74F61C4361B
	for <linux-efi@archiver.kernel.org>; Thu, 17 Dec 2020 12:38:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2820C23715
	for <linux-efi@archiver.kernel.org>; Thu, 17 Dec 2020 12:38:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgLQMia (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 17 Dec 2020 07:38:30 -0500
Received: from www74.your-server.de ([213.133.104.74]:44820 "EHLO
        www74.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbgLQMi3 (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Thu, 17 Dec 2020 07:38:29 -0500
X-Greylist: delayed 1470 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Dec 2020 07:38:28 EST
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www74.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <klaus.kusche@computerix.info>)
        id 1kps9d-0006oV-7v; Thu, 17 Dec 2020 13:13:09 +0100
Received: from [95.91.111.52] (helo=[192.168.178.21])
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <klaus.kusche@computerix.info>)
        id 1kps9d-000QpR-0h; Thu, 17 Dec 2020 13:13:09 +0100
To:     nivedita@alum.mit.edu
Cc:     mario.limonciello@dell.com, jacobopantoja@gmail.com,
        ardb@kernel.org, pjones@redhat.com, linux-efi@vger.kernel.org
From:   Klaus Kusche <klaus.kusche@computerix.info>
Subject: Efistub patch breaks 5.10 for me
Message-ID: <242ea718-89f8-e74f-e48a-e6b0fa436ed1@computerix.info>
Date:   Thu, 17 Dec 2020 13:13:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: klaus.kusche@computerix.info
X-Virus-Scanned: Clear (ClamAV 0.102.4/26019/Wed Dec 16 15:36:02 2020)
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org


Hello,

tried to boot 5.10.1 (my first attempt to boot a 5.10.x).

Displays

EFI stub: WARNING: [Firmware Bug]: LoadOptions is an EFI_LOAD_OPTION descriptor
EFI stub: WARNING: [Firmware Bug]: Using OptionalData as a workaround

for one or two seconds on the notebook display.

Then, the notebook display becomes completely black
and the notebook does not boot and does not react to anything
(hard poweroff needed).

5.9.15 works fine.

Of course, this could be some other change 5.9 --> 5.10,
but I think Efistub is the first suspect.

Directly booting from UEFI to linux, no bootloader.

Dell Precision Mobile 7740,
dmidecode says BIOS version 1.7.0, 01/07/2020.

My kernel has *no* command line arguments at all
or at least, it should not have any
(fully static kernel with no modules or initrd,
all kernel parameters configured into the kernel).

In 5.9.15, dmesg displays only a \x01 for the command line.

Next step?
Is there sonething to try out?
Are there any patches I should reverse-apply?
Should I open a bug at buzilla.kernel.org?

Thanks for any help!

-- 
Prof. Dr. Klaus Kusche
Private address: Rosenberg 41, 07546 Gera, Germany
+49 365 20413058 klaus.kusche@computerix.info https://www.computerix.info
Office address: DHGE Gera, Weg der Freundschaft 4, 07546 Gera, Germany
+49 365 4341 306 klaus.kusche@dhge.de https://www.dhge.de
