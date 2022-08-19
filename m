Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77870C32771
	for <linux-efi@archiver.kernel.org>; Fri, 19 Aug 2022 13:17:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348710AbiHSNRk (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 19 Aug 2022 09:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348250AbiHSNRj (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Fri, 19 Aug 2022 09:17:39 -0400
Received: from iam.tj (soggy.cloud [IPv6:2a01:7e00:e000:151::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38CA8EE4A2
        for <linux-efi@vger.kernel.org>; Fri, 19 Aug 2022 06:17:37 -0700 (PDT)
Received: from [IPV6:2a01:7e00:e001:ee80:145d:5eff:feb1:1df1] (unknown [IPv6:2a01:7e00:e001:ee80:145d:5eff:feb1:1df1])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by iam.tj (Postfix) with ESMTPSA id 6D703340AC;
        Fri, 19 Aug 2022 14:17:35 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=iam.tj; s=2019;
        t=1660915055; bh=zgNdj2VHM5NK+bgtoYXweWtcQctZhTl/gVTcXBVmcuk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=UjfBexRZkUvNZhRH+cOWTRxy7xFHj0/9IN1eI9cIfLGwL4NvKCBvxQCuWgsVDUtQh
         Kbub76z5qkW9UG/78H+MlnsNDhPWBXIPLNd+5IWAGhQrd/UmfRcJElO04VqFh6UmG7
         jjzWj7vZli7uhX3Av52YvxOjpN3eUl7zrU61ijCVHLvP7W3cqPe+0CwqgdydmaT8OH
         QqD3UvM1vH0lFIbeWXZGhWU9HX4fFEbCEeRlg/kBFIX9+Pqxsdtdid5PSzZ3lul4LG
         aqM6hJ/BC1Sn60w6Qoa8ZU8gxQyEJcyBxYZeRO8MpvgR04ZUHb2/NUqIa6/MPELYki
         uhNAK+ClwBY+A==
Message-ID: <3c058feb-93f1-1966-6c1e-f030a7b951a1@iam.tj>
Date:   Fri, 19 Aug 2022 14:17:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: [Bug 216375] EFI stub: ERROR: Exit boot services failed
Content-Language: en-GB
To:     Ard Biesheuvel <ardb@kernel.org>,
        Bugzilla <bugzilla-daemon@kernel.org>
Cc:     linux-efi@vger.kernel.org, Steev Klimaszewski <steev@kali.org>
References: <2e9741aa-562c-cd0d-7ee4-8281512bc2e0@iam.tj>
 <CAMj1kXH-uYwfxPrHv7YpKQ3iwS0aBEsj-OZ9aKpgr9SgyTdoWQ@mail.gmail.com>
From:   Tj <linux@iam.tj>
In-Reply-To: <CAMj1kXH-uYwfxPrHv7YpKQ3iwS0aBEsj-OZ9aKpgr9SgyTdoWQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On 19/08/2022 08:22, Ard Biesheuvel wrote:
> (cc Steve - not sure who else still works on this stuff these days)
>>
>> EFI stub: ERROR: Exit boot services failed
>>
> Looking at your adventures, it seems you are looking for something
> that the EFI stub in Linux is doing wrong, causing the
> ExitBootServices() call to fail.
> 
...
> One thing you could try is setting the TPL level to TPL_HIGH before
> calling exit_boot_services (or just disable interrupts). That way,
> your first call is more likely to succeed, as nothing that could
> change the memory map could run in the meantime.

Can you give me guidance on how to do that; a grep for TPL_* and 
{raise,restore}_tpl seems to indicate these are not currently implemented?

If so, presumably I need to do the same with those as I did with 
GetNextMonotonicCount() / get_next_monotonic_count ?
