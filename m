Return-Path: <SRS0=rvgm=2E=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9EA8C43603
	for <linux-efi@archiver.kernel.org>; Sat, 14 Dec 2019 20:33:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76DBE214D8
	for <linux-efi@archiver.kernel.org>; Sat, 14 Dec 2019 20:33:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C9YiYLtr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbfLNUdA (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Sat, 14 Dec 2019 15:33:00 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46779 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbfLNUdA (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Sat, 14 Dec 2019 15:33:00 -0500
Received: by mail-qk1-f194.google.com with SMTP id r14so1693671qke.13;
        Sat, 14 Dec 2019 12:33:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZNiCKhGVuabttGDSYceTCobxezTEW7wv0FbaYh2+Hww=;
        b=C9YiYLtrIdpG+KuV3L1R/0yo5uKkwF0VlnODsRmx8dm4YumjDg0rESRKQtrsLsCNde
         7EhFaePJjSWMLzdBdBQJwE7EeAzX6O/FdO/WWM7gDv8zzW4mb9Y6xLsdnFmvvlbYjbbC
         oPAtOpLI3UhhEqurdADb/Qr94WJ7Kxar5qj79WZOZ8ShFYgsDtqeMF71HXksuMgIqIFd
         zKsraNIpfgucvw0yAmdaX33bd3LeJLNM5TDioKLuM/AYAvMcIzw+l+3xq5QsBrEBNcqL
         Cz8J6j1hmAfqCuJZDxEtkJ10qHZlA3aZMzIu8CEDkxA0fVuVUhRKwH1wM93y2dqW5gNk
         XEoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZNiCKhGVuabttGDSYceTCobxezTEW7wv0FbaYh2+Hww=;
        b=MP/cjpaxts9hLZ0AGm4e5wpJQ+DqGMSpVaxUDr6Hx9fOh6Uei/D8dNG1G3nlrfeYaQ
         R+CnzzFfQgP4kWriKthyjVO2duF4XFHmSw+IQm8OCbweaiDaFEfBP7Tkt1yHgy3zOsaw
         hAIXiqrXGq37ANQLPguSnG9kMlR/A8/e/sk0Ak3M8L7zJmxfE26o3IoZlr6o77hBaWg1
         usL2c7eP6QOp2KR5nGAdTqaS+r1bgkwN3UvylTmYnPUoafyu8uF0HdzecjqGt6HULnVD
         QFIx9Tk9ZZDKXfjmzx41IFiIr/u/ahbFXTwERUnbCZj4aqs/Y0pO2PNpMglht4MjHw4X
         9FyQ==
X-Gm-Message-State: APjAAAWEGkwrMmTC9eZgSR6TqqMjSP6vHqyb3rFPxHxrV1whpjPJqXnE
        a4p3sDWfdqjjJgzkwpuLxg4=
X-Google-Smtp-Source: APXvYqxhdQO5/rB3RxRjVO6KAyca49fQOo3kH2pCppJWqUCnKvoCHjouPLU8yR66pKA0FZA/LkJzHw==
X-Received: by 2002:a05:620a:62c:: with SMTP id 12mr20114844qkv.154.1576355579393;
        Sat, 14 Dec 2019 12:32:59 -0800 (PST)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id o19sm5005624qtb.43.2019.12.14.12.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2019 12:32:59 -0800 (PST)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Sat, 14 Dec 2019 15:32:57 -0500
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Matthew Garrett <matthewgarrett@google.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arvind Sankar <nivedita@alum.mit.edu>
Subject: Re: [PATCH 03/10] efi/libstub: use a helper to iterate over a EFI
 handle array
Message-ID: <20191214203257.GD140998@rani.riverdale.lan>
References: <20191214175735.22518-1-ardb@kernel.org>
 <20191214175735.22518-4-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191214175735.22518-4-ardb@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Sat, Dec 14, 2019 at 06:57:28PM +0100, Ard Biesheuvel wrote:
> Iterating over a EFI handle array is a bit finicky, since we have
> to take mixed mode into account, where handles are only 32-bit
> while the native efi_handle_t type is 64-bit.
> 
> So introduce a helper, and replace the various occurrences of
> this pattern.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  
> +#define for_each_efi_handle(handle, array, size, i)			\
> +	for (i = 1, handle = efi_is_64bit()				\
> +		? (efi_handle_t)(unsigned long)((u64 *)(array))[0]	\
> +		: (efi_handle_t)(unsigned long)((u32 *)(array))[0];	\
> +	    i++ <= (size) / (efi_is_64bit() ? sizeof(efi_handle_t)	\
> +					     : sizeof(u32));		\
> +	    handle = efi_is_64bit()					\
> +		? (efi_handle_t)(unsigned long)((u64 *)(array))[i]	\
> +		: (efi_handle_t)(unsigned long)((u32 *)(array))[i])
> +
>  /*
>   * The UEFI spec and EDK2 reference implementation both define EFI_GUID as
>   * struct { u32 a; u16; b; u16 c; u8 d[8]; }; and so the implied alignment
> -- 
> 2.17.1
> 

This would access one past the array, no? Eg if the array has one
handle, i is incremented to 2 the first time the condition is checked,
then the loop increment will access array[2] before the condition is
checked again. There seem to be at least a couple of other for_each
macros that might have similar issues.

How about the below instead?

#define for_each_efi_handle(handle, array, size, i)			\
	for (i = 0;							\
	    (i < (size) / (efi_is_64bit() ? sizeof(efi_handle_t)	\
					  : sizeof(u32))) &&		\
	    ((handle = efi_is_64bit()					\
		? ((efi_handle_t *)(array))[i]				\
		: (efi_handle_t)(unsigned long)((u32 *)(array))[i]), 1);\
	    i++)

