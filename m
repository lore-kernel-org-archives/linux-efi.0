Return-Path: <SRS0=pOKh=4W=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F152DC3F2CD
	for <linux-efi@archiver.kernel.org>; Thu,  5 Mar 2020 14:56:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B414C20848
	for <linux-efi@archiver.kernel.org>; Thu,  5 Mar 2020 14:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583420190;
	bh=5fO0JuvSBZFq3MCg8Q+HsdlsL0Z4Fu5Tx39F6eTCQwE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=QJUb/V9sH2Rhr9YL7744CvaBMt97xs1r+bdnYIlmXx82beDHYAAtou7BrXzOuj/rW
	 Y2RESjKC37g70XbklgBtMb8PmrdmmDb9Z2N0LLl0DXbqzKsZVkcYIY8HGKAyB8bXt4
	 6ZorC54m2NBlu60whGDPvoSfPMiZjGCpz79J7tbQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgCEO4a (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 5 Mar 2020 09:56:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:44340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726004AbgCEO4a (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Thu, 5 Mar 2020 09:56:30 -0500
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5053320848
        for <linux-efi@vger.kernel.org>; Thu,  5 Mar 2020 14:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583420189;
        bh=5fO0JuvSBZFq3MCg8Q+HsdlsL0Z4Fu5Tx39F6eTCQwE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=TZZ3FG3CE+MokD3S8s5aJvFWJQ0Fpq0sk1KICkgvIBa84qpU07bgPD0kksUTDs7us
         JGf2VxC5s/lo7hMShMLsF8pn/FkmJcBzHFUiSfCnyI+g0QVPY/IwPFvSmMqZR90BCL
         O5pK3ww+REh/9Tksxp38btxQuDltptUZ3U7Xxs6c=
Received: by mail-wm1-f44.google.com with SMTP id a5so6675737wmb.0
        for <linux-efi@vger.kernel.org>; Thu, 05 Mar 2020 06:56:29 -0800 (PST)
X-Gm-Message-State: ANhLgQ3g6gVkY2B6ognAYe0OR80WQW0AZ/NTXjtlxdW8JLoWJV5ugZvI
        vEmveZd2hsOwKCpVJ1stV8235LbOnCVrrtg35oHGDw==
X-Google-Smtp-Source: ADFU+vuoYH3aMx97JSuIEvocQl0Zu5Y+lid1E5vLIpWqz0meBSvgsFQfz/T29iXj4zOnUheQkkMWkQ8hDCb16y+l9lE=
X-Received: by 2002:a05:600c:24b:: with SMTP id 11mr9872565wmj.1.1583420187771;
 Thu, 05 Mar 2020 06:56:27 -0800 (PST)
MIME-Version: 1.0
References: <20200305143642.820865-1-nivedita@alum.mit.edu>
In-Reply-To: <20200305143642.820865-1-nivedita@alum.mit.edu>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 5 Mar 2020 15:56:16 +0100
X-Gmail-Original-Message-ID: <CAKv+Gu-Ko26Th5dhbSk6NvoRdbkAz4PC9spEb4-c7+JxyJqunA@mail.gmail.com>
Message-ID: <CAKv+Gu-Ko26Th5dhbSk6NvoRdbkAz4PC9spEb4-c7+JxyJqunA@mail.gmail.com>
Subject: Re: [PATCH] efi/x86: Fix cast of image argument
To:     Arvind Sankar <nivedita@alum.mit.edu>
Cc:     linux-efi <linux-efi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Thu, 5 Mar 2020 at 15:36, Arvind Sankar <nivedita@alum.mit.edu> wrote:
>
> handle_protocol expects void **, not void *.
>
> Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>

Queued, thanks

> ---
>  drivers/firmware/efi/libstub/x86-stub.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/firmware/efi/libstub/x86-stub.c b/drivers/firmware/efi/libstub/x86-stub.c
> index fbc4354f534c..95b29d8bf8e4 100644
> --- a/drivers/firmware/efi/libstub/x86-stub.c
> +++ b/drivers/firmware/efi/libstub/x86-stub.c
> @@ -383,7 +383,7 @@ efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
>         if (sys_table->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
>                 efi_exit(handle, EFI_INVALID_PARAMETER);
>
> -       status = efi_bs_call(handle_protocol, handle, &proto, (void *)&image);
> +       status = efi_bs_call(handle_protocol, handle, &proto, (void **)&image);
>         if (status != EFI_SUCCESS) {
>                 efi_printk("Failed to get handle for LOADED_IMAGE_PROTOCOL\n");
>                 efi_exit(handle, status);
> --
> 2.24.1
>
