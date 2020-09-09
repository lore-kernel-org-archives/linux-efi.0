Return-Path: <SRS0=meAZ=CS=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB2B8C43461
	for <linux-efi@archiver.kernel.org>; Wed,  9 Sep 2020 19:01:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AABA218AC
	for <linux-efi@archiver.kernel.org>; Wed,  9 Sep 2020 19:01:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uyR5CB4V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgIITBt (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 9 Sep 2020 15:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbgIITBo (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Wed, 9 Sep 2020 15:01:44 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E54C061573
        for <linux-efi@vger.kernel.org>; Wed,  9 Sep 2020 12:01:44 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id q5so3532564qkc.2
        for <linux-efi@vger.kernel.org>; Wed, 09 Sep 2020 12:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NiGQxnp6N0Dal7ah98TgS7PY3ur8gDhTDux8zigTqTE=;
        b=uyR5CB4V8T7MA65u/V7dw7USaZ4NCQdJtQcUzlAIZQrk959gk59aGkQFPFu4vYgt9I
         wJFTrIL46wjdmtVjKSvBvHRe+dCowFKYj0CCC2pfPt0A8KgGpPIdT8mRDdCmCyGdlcGE
         1amqaA1K/2LaPE4/As2nmGqQA+CPKR73DRdBfrco107aoteB8lNNGZuR0LO6GI12IUTA
         SDOQRERNVVtzdPVXovnrvQCWtREIed5E67dj8WwZV8SAeEIXalwMAuF47l0zJegmmX8g
         891zjBuNL8x723tvhDNlFMHJuTuWZUbd5LG5kP/N/eHeaKtldgIpALmd+Kr3ftTocyIR
         0Mjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=NiGQxnp6N0Dal7ah98TgS7PY3ur8gDhTDux8zigTqTE=;
        b=UL1oqC2qhh3lEXwG6YUBlYjMnBcI9Pjb1iy5vRlPX9UOAh0oL9sEFUGc0ezKcJiyNh
         nIrVs6BsBo62hIUkB1CyML9KkTfW11XiEJeB0j06IdDaxxy/ljhSuOQ+Lx8QEz/sdj12
         O/VIl+b2C14fCm5JC0LznnB9BG2T1Sk/dwri7i+FbH9i/PUYM7qGQzLIJgPiXD1obD9s
         ZSav/PfkYsFHF6QY5hLlUihZ81cQtTSD2Xc2ixGyL0FtzDkroUBGLLvFKmkD5c6GUcNH
         tuFca3krDmOPFI8U0DE5DIOk+CiIYtbky5fOGTNHerD4cDDm11xcb//YB6Z6SAXJLqS4
         nh3w==
X-Gm-Message-State: AOAM531ZwmwDBZQhnwxPmr8EUHNQE/qZtPfTc505n0OivWHO02PB2Byx
        FZ9/k0YcjUV7nwiwDJbHlf0=
X-Google-Smtp-Source: ABdhPJw6pxv6I3/cNcepS8OBiqFxwT9OQSph4Cy+lrA7252B69B5ThXG/LZb7SuzAeZaVl+6V9PH+A==
X-Received: by 2002:a37:d91:: with SMTP id 139mr4552973qkn.455.1599678103904;
        Wed, 09 Sep 2020 12:01:43 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id m36sm4043254qtd.10.2020.09.09.12.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 12:01:43 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Wed, 9 Sep 2020 15:01:42 -0400
To:     Tian Tao <tiantao6@hisilicon.com>
Cc:     ardb@kernel.org, nivedita@alum.mit.edu, linux-efi@vger.kernel.org,
        linuxarm@huawei.com
Subject: Re: [PATCH] efi/printf: remove unneeded semicolon
Message-ID: <20200909190142.GB474185@rani.riverdale.lan>
References: <1599633872-36784-1-git-send-email-tiantao6@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1599633872-36784-1-git-send-email-tiantao6@hisilicon.com>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Wed, Sep 09, 2020 at 02:44:32PM +0800, Tian Tao wrote:
> Fix the warning below.
> efi/libstub/vsprintf.c:135:2-3: Unneeded semicolon
> 
> Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
> ---
>  drivers/firmware/efi/libstub/vsprintf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/firmware/efi/libstub/vsprintf.c b/drivers/firmware/efi/libstub/vsprintf.c
> index e65ef49..1088e28 100644
> --- a/drivers/firmware/efi/libstub/vsprintf.c
> +++ b/drivers/firmware/efi/libstub/vsprintf.c
> @@ -135,7 +135,7 @@ char *number(char *end, unsigned long long num, int base, char locase)
>  		break;
>  	default:
>  		unreachable();
> -	};
> +	}
>  
>  	return end;
>  }
> -- 
> 2.7.4
> 

Acked-by: Arvind Sankar <nivedita@alum.mit.edu>
