Return-Path: <linux-efi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 440DBC678D5
	for <linux-efi@archiver.kernel.org>; Wed,  8 Mar 2023 23:12:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbjCHXMW (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 8 Mar 2023 18:12:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbjCHXML (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Wed, 8 Mar 2023 18:12:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9316A2CC;
        Wed,  8 Mar 2023 15:11:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D29B4619A2;
        Wed,  8 Mar 2023 23:11:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D167C433D2;
        Wed,  8 Mar 2023 23:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678317102;
        bh=cqQ5+hWq0iRpq6Sp7UAKGzE3+W2FLX+WGrkmDw46WWg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=m3yARitiSY+Q+bdvUk0dIzDmK5QsNJqpLbR3gtBUmTnhHSP4gsyAsY5Jn1M6JJ8Js
         923r+2MAJhVAlM3D9HzDxZ239KTrv0uSXZ9Zh7WEYJL+AuARrghvdaBxeClnuY9YsH
         rcmaE3lWW73C1wR4Oj+8zgtlA6StCvIbuhEGEegxptL7pRhQ0fedOOE4BTRAck/dUl
         MMrHfIzwzqhg0QzfHRr6OFYqw0Pw0UPOlSATKP1bIazezMt4O8eah1f1q97xjlJbaA
         2GQW8/Ot8sbnQdXNsKGgSaCPuHyrQf0J5Q/Zo4Qsk7wIwsuCpJzBm6+iYnEFRWj/uv
         983HZAMqjB1oA==
Date:   Wed, 8 Mar 2023 17:11:40 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH] cper-arm: Remove unnecessary aer.h include
Message-ID: <20230308231140.GA1057027@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307203356.882479-1-helgaas@kernel.org>
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Tue, Mar 07, 2023 at 02:33:56PM -0600, Bjorn Helgaas wrote:
> From: Bjorn Helgaas <bhelgaas@google.com>
> 
> <linux/aer.h> is unused, so remove it.
> 
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

Applied with Ard's ack to pci/aer for v6.4.

> ---
>  drivers/firmware/efi/cper-arm.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/firmware/efi/cper-arm.c b/drivers/firmware/efi/cper-arm.c
> index 36d3b8b9da47..fa9c1c3bf168 100644
> --- a/drivers/firmware/efi/cper-arm.c
> +++ b/drivers/firmware/efi/cper-arm.c
> @@ -12,7 +12,6 @@
>  #include <linux/dmi.h>
>  #include <linux/acpi.h>
>  #include <linux/pci.h>
> -#include <linux/aer.h>
>  #include <linux/printk.h>
>  #include <linux/bcd.h>
>  #include <acpi/ghes.h>
> -- 
> 2.25.1
> 
