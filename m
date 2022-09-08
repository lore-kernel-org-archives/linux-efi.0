Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B2EAECAAD5
	for <linux-efi@archiver.kernel.org>; Thu,  8 Sep 2022 08:42:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiIHImV (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 8 Sep 2022 04:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbiIHImV (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Thu, 8 Sep 2022 04:42:21 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD20A3D5D
        for <linux-efi@vger.kernel.org>; Thu,  8 Sep 2022 01:42:19 -0700 (PDT)
Received: from mail.ispras.ru (unknown [83.149.199.84])
        by mail.ispras.ru (Postfix) with ESMTPSA id 4717140737B6;
        Thu,  8 Sep 2022 08:42:13 +0000 (UTC)
MIME-Version: 1.0
Date:   Thu, 08 Sep 2022 11:42:13 +0300
From:   Evgeniy Baskov <baskov@ispras.ru>
To:     chen zhang <chenzhang@kylinos.cn>
Cc:     ardb@kernel.org, ilias.apalodimas@linaro.org,
        chenzhang_0901@163.com, linux-efi@vger.kernel.org
Subject: Re: [PATCH] efi/x86: libstub: remove unused variables
In-Reply-To: <20220907023255.35237-1-chenzhang@kylinos.cn>
References: <20220907023255.35237-1-chenzhang@kylinos.cn>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <ba9c545066d80740df279a34c4fa795a@ispras.ru>
X-Sender: baskov@ispras.ru
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On 2022-09-07 05:32, chen zhang wrote:
> The variable "has_system_memory" is unused in
> function ‘adjust_memory_range_protection’, remove it.
> 

Thanks for pointing out.
Will change that in v2.

Thanks,
Evgeniy Baskov
