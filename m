Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AA07C38145
	for <linux-efi@archiver.kernel.org>; Thu,  8 Sep 2022 08:49:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbiIHIts (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 8 Sep 2022 04:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbiIHIt2 (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Thu, 8 Sep 2022 04:49:28 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961C4FCA2A
        for <linux-efi@vger.kernel.org>; Thu,  8 Sep 2022 01:48:25 -0700 (PDT)
Received: from mail.ispras.ru (unknown [83.149.199.84])
        by mail.ispras.ru (Postfix) with ESMTPSA id 0B1BD40737B6;
        Thu,  8 Sep 2022 08:48:24 +0000 (UTC)
MIME-Version: 1.0
Date:   Thu, 08 Sep 2022 11:48:24 +0300
From:   Evgeniy Baskov <baskov@ispras.ru>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     chen zhang <chenzhang@kylinos.cn>, ilias.apalodimas@linaro.org,
        chenzhang_0901@163.com, linux-efi@vger.kernel.org
Subject: Re: [PATCH] efi/x86: libstub: remove unused variables
In-Reply-To: <CAMj1kXFJHht=9r054cCKCzAjnSCrbRi9pD--XLNc-xrpHQnFBA@mail.gmail.com>
References: <20220907023255.35237-1-chenzhang@kylinos.cn>
 <ba9c545066d80740df279a34c4fa795a@ispras.ru>
 <CAMj1kXFJHht=9r054cCKCzAjnSCrbRi9pD--XLNc-xrpHQnFBA@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <f0ca5dbabdd289fa14e0b0fe852b761c@ispras.ru>
X-Sender: baskov@ispras.ru
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On 2022-09-08 11:43, Ard Biesheuvel wrote:
> On Thu, 8 Sept 2022 at 10:42, Evgeniy Baskov <baskov@ispras.ru> wrote:
>> 
>> On 2022-09-07 05:32, chen zhang wrote:
>> > The variable "has_system_memory" is unused in
>> > function ‘adjust_memory_range_protection’, remove it.
>> >
>> 
>> Thanks for pointing out.
>> Will change that in v2.
>> 
> 
> v2 of what? Isn't this code already in mainline?

Oh, right.

There are just more patches pending that change
that function. I can do that via separate patch later
today, I guess.

Thanks,
Evgeniy Baskov
