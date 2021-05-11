Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C79DC433B4
	for <linux-efi@archiver.kernel.org>; Tue, 11 May 2021 20:55:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A8B46162B
	for <linux-efi@archiver.kernel.org>; Tue, 11 May 2021 20:55:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhEKU4O (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 11 May 2021 16:56:14 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:39515 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229848AbhEKU4N (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Tue, 11 May 2021 16:56:13 -0400
Received: from [192.168.0.7] (ip5f5aeee8.dynamic.kabel-deutschland.de [95.90.238.232])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 1F2BD61E646CA;
        Tue, 11 May 2021 22:55:05 +0200 (CEST)
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Subject: efivarfs fails with `No such device` when EFI runtime is missing
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-efi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Message-ID: <b075e45e-365a-dafb-503c-615c41168b0d@molgen.mpg.de>
Date:   Tue, 11 May 2021 22:55:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Dear Linux folks,


I migrated a 32-bit GNU/Linux installation from BIOS to EFI. Trying to 
edit the entries in UEFI’s Boot Manager with `efibootmgr`, I got the error:

     EFI variables are not supported on this system

`sudo modprobe efivarfs` fails with

     No such device

After several tries, I found

     [    0.000000] efi: No EFI runtime due to 32/64-bit mismatch with 
kernel

logged by Linux, and then I found the Stack Overflow thread *How could 
32bit kernel read efivars from 64bit UEFI?* [1].

I would have thought, setting EFI variables is just directly writing to 
some storage. But probably not.

Could the error message for the efivarfs load failure be improved, that 
*device* means the runtime service (if I am not mistaken)?


Kind regards,

Paul


[1]: 
https://stackoverflow.com/questions/46610442/how-could-32bit-kernel-read-efivars-from-64bit-uefi
