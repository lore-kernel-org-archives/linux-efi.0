Return-Path: <SRS0=8o4L=DQ=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93311C433DF
	for <linux-efi@archiver.kernel.org>; Fri,  9 Oct 2020 08:52:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44F7622272
	for <linux-efi@archiver.kernel.org>; Fri,  9 Oct 2020 08:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602233564;
	bh=H3WiVJE5WQKDRYHWZbDCcJWkEJpGCbuiUdxQrcSx6k8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=qy5kPPXAXufKZpZAOoXQyTdorUjZZywVQlHgJDdMFUBYoLNabnQt1d4KD+/HiBpyi
	 zYbRojTwRJB3CdkUdi24oXd8FCuRAXiggGEj1XsyJ6NAHriaivv4gYRB/FeyXcPymQ
	 /10HMWB1l7vQTJf+voFXS5K+zSOwe301z3jdW3Jo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732496AbgJIIwo (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 9 Oct 2020 04:52:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:52574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732492AbgJIIwn (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Fri, 9 Oct 2020 04:52:43 -0400
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDA9E20679;
        Fri,  9 Oct 2020 08:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602233562;
        bh=H3WiVJE5WQKDRYHWZbDCcJWkEJpGCbuiUdxQrcSx6k8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HLPFjHps7DHNz+IWr+LcJ7uETqmPdoHoajSP0cgLFHHNZ8E5+Tt6Ry48vG2oUOd/w
         bC7vK8VFuTy2t28MNvun1+kp5yqG0SoXsgdZoOsALjpGmwTnq1iv/bXUK0xEM5CWHw
         TxhSXKkqxtnlpW3G+iEhApzxYh3w1jvHLJYto9pU=
Received: by mail-ot1-f42.google.com with SMTP id i12so8342959ota.5;
        Fri, 09 Oct 2020 01:52:42 -0700 (PDT)
X-Gm-Message-State: AOAM530l52EbkOlaI4D96bJOcR+nqIv9UwhL5L6jhUiMhaXmzezO9vy/
        WmGWBTf6Vqu6S575zSq5PEwi1EJdSR/4eooVMkU=
X-Google-Smtp-Source: ABdhPJzalA/1udM9xq+ZruR1a1pxpXvkGkOzsQE4Bxi8jOd207MtzuSDUNCAwGBqeJBC/SzKd74s/ayvSlH6zugtTCo=
X-Received: by 2002:a9d:6193:: with SMTP id g19mr7715959otk.108.1602233562109;
 Fri, 09 Oct 2020 01:52:42 -0700 (PDT)
MIME-Version: 1.0
References: <20201009085106.125079-1-nixiaoming@huawei.com>
In-Reply-To: <20201009085106.125079-1-nixiaoming@huawei.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 9 Oct 2020 10:52:31 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFfN-dFAu+veu_0j2KAqWisZ8hy-1f3S4Y88tHC7bxxHA@mail.gmail.com>
Message-ID: <CAMj1kXFfN-dFAu+veu_0j2KAqWisZ8hy-1f3S4Y88tHC7bxxHA@mail.gmail.com>
Subject: Re: [PATCH] efi:mokvar-table: fix build error
To:     Xiaoming Ni <nixiaoming@huawei.com>
Cc:     linux-efi <linux-efi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        wangle6@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Fri, 9 Oct 2020 at 10:51, Xiaoming Ni <nixiaoming@huawei.com> wrote:
>
> drivers/firmware/efi/mokvar-table.c:139:5: error: implicit declaration of
>  function 'early_memunmap'; did you mean 'devm_memunmap'?
>  [-Werror=implicit-function-declaration]
> drivers/firmware/efi/mokvar-table.c:148:9: error: implicit declaration of
>  function 'early_memremap'; did you mean 'devm_memremap'?
>  [-Werror=implicit-function-declaration]
>
> add #include <asm/early_ioremap.h> to fix this build error
>
> Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>

Thank you Xiaoming. We already have a fix queued up for this issue.

> ---
>  drivers/firmware/efi/mokvar-table.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/firmware/efi/mokvar-table.c b/drivers/firmware/efi/mokvar-table.c
> index 72a9e1736fef..c23d3686f1c7 100644
> --- a/drivers/firmware/efi/mokvar-table.c
> +++ b/drivers/firmware/efi/mokvar-table.c
> @@ -39,6 +39,7 @@
>  #include <linux/kobject.h>
>  #include <linux/list.h>
>  #include <linux/slab.h>
> +#include <asm/early_ioremap.h>
>
>  /*
>   * The LINUX_EFI_MOK_VARIABLE_TABLE_GUID config table is a packed
> --
> 2.27.0
>
