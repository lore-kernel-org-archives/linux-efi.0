Return-Path: <SRS0=RRme=7L=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B174FC433DF
	for <linux-efi@archiver.kernel.org>; Fri, 29 May 2020 17:00:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DF572077D
	for <linux-efi@archiver.kernel.org>; Fri, 29 May 2020 17:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590771647;
	bh=6Y/1Q0Q2wmCQFvKEA1F9i6YDgw/p9PU/aktrD1/wuVM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=Uus4zG5T/+8r0FseQqT8n2oCNIe/jl6EbjWD3YZqxmwVHpsLs4DVpojL6T+mJDN4G
	 fJrJqv1GcynfnqsRxS07LcfkvkkKqTgToia0HMSEcFFJ5vxH5m0fUJ1FXokYePZNDo
	 w99pZFTTuoTkCiKPzMybgao3O3Oiy4Z0mxd66kuE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgE2RAr (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 29 May 2020 13:00:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbgE2RAr (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Fri, 29 May 2020 13:00:47 -0400
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FCC720723;
        Fri, 29 May 2020 17:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590771646;
        bh=6Y/1Q0Q2wmCQFvKEA1F9i6YDgw/p9PU/aktrD1/wuVM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=y/DC8EP8psJSBvA33c5yoTvtz9IzrRUIH6v9nj3yh2lV7l7rJmS598npf2hj/HZO/
         cnItjYvNFdApUtLT9uE7lAWA32IPKtfpbaN7ckfj/xCAEhRREWDjiFIgSTvROjuDY9
         9DFTNeNoA7yWrYrGrv3Y4tsKnBESid4iRW/tcGPE=
Received: by mail-io1-f54.google.com with SMTP id d7so85296ioq.5;
        Fri, 29 May 2020 10:00:46 -0700 (PDT)
X-Gm-Message-State: AOAM533ryn7W/WlZbdO3Ko0hmQd1qlQjweF2sgGpYs5GXMjvbBthEPdU
        xRUnKx3COuuJjSIrPzItr8MD0BUb2DGqsxOW4DA=
X-Google-Smtp-Source: ABdhPJzSST4Jx5b19cJLXdd8sJD4gjF9HBIXebCUYPZM06ZLIBUWGJkjsBx/9lrpUtioddaXSAGPlOC0xCx62MJjSnY=
X-Received: by 2002:a5d:81d7:: with SMTP id t23mr7599076iol.142.1590771646041;
 Fri, 29 May 2020 10:00:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200528183804.4497-1-wu000273@umn.edu>
In-Reply-To: <20200528183804.4497-1-wu000273@umn.edu>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 29 May 2020 19:00:34 +0200
X-Gmail-Original-Message-ID: <CAMj1kXE7soPKnsRPjB5HfUZ4MhAVX_ejbidozyOFrj4AfROjPg@mail.gmail.com>
Message-ID: <CAMj1kXE7soPKnsRPjB5HfUZ4MhAVX_ejbidozyOFrj4AfROjPg@mail.gmail.com>
Subject: Re: [PATCH] efi/esrt: Fix reference count leak in esre_create_sysfs_entry.
To:     wu000273@umn.edu
Cc:     kjlu@umn.edu, Peter Jones <pjones@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        linux-efi <linux-efi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Thu, 28 May 2020 at 20:38, <wu000273@umn.edu> wrote:
>
> From: Qiushi Wu <wu000273@umn.edu>
>
> kobject_init_and_add() takes reference even when it fails.
> If this function returns an error, kobject_put() must be called to
> properly clean up the memory associated with the object. Previous
> commit "b8eb718348b8" fixed a similar problem.
>
> Fixes: 0bb549052d33 ("efi: Add esrt support")
> Signed-off-by: Qiushi Wu <wu000273@umn.edu>
> ---
>  drivers/firmware/efi/esrt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/firmware/efi/esrt.c b/drivers/firmware/efi/esrt.c
> index e3d692696583..d5915272141f 100644
> --- a/drivers/firmware/efi/esrt.c
> +++ b/drivers/firmware/efi/esrt.c
> @@ -181,7 +181,7 @@ static int esre_create_sysfs_entry(void *esre, int entry_num)
>                 rc = kobject_init_and_add(&entry->kobj, &esre1_ktype, NULL,
>                                           "entry%d", entry_num);
>                 if (rc) {
> -                       kfree(entry);

Why are you removing this kfree() call?

> +                       kobject_put(&entry->kobj);
>                         return rc;
>                 }
>         }
> --
> 2.17.1
>
