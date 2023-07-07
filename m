Return-Path: <linux-efi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D51FC001DF
	for <linux-efi@archiver.kernel.org>; Fri,  7 Jul 2023 05:59:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjGGF7l (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 7 Jul 2023 01:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232334AbjGGF7f (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Fri, 7 Jul 2023 01:59:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB38F1FC9;
        Thu,  6 Jul 2023 22:59:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45E5961275;
        Fri,  7 Jul 2023 05:59:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C79FC433C7;
        Fri,  7 Jul 2023 05:59:32 +0000 (UTC)
Date:   Fri, 7 Jul 2023 06:59:30 +0100
From:   Greg KH <greg@kroah.com>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     javierm@redhat.com, suijingfeng@loongson.cn, arnd@arndb.de,
        linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
        linux-fbdev@vger.kernel.org, linux-staging@lists.linux.dev,
        dri-devel@lists.freedesktop.org,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Teddy Wang <teddy.wang@siliconmotion.com>
Subject: Re: [PATCH v2 4/4] staging/sm750fb: Do not include
 <linux/screen_info.h>
Message-ID: <2023070721-detector-unlatch-cae3@gregkh>
References: <20230706104852.27451-1-tzimmermann@suse.de>
 <20230706104852.27451-5-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230706104852.27451-5-tzimmermann@suse.de>
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Thu, Jul 06, 2023 at 12:42:17PM +0200, Thomas Zimmermann wrote:
> The sm750fb driver does not need anything from <linux/screen_info.h>.
> Remove the include statements.
> 
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
> Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
> Cc: Teddy Wang <teddy.wang@siliconmotion.com>
> ---
>  drivers/staging/sm750fb/sm750.c        | 1 -
>  drivers/staging/sm750fb/sm750_accel.c  | 1 -
>  drivers/staging/sm750fb/sm750_cursor.c | 1 -
>  drivers/staging/sm750fb/sm750_hw.c     | 1 -
>  4 files changed, 4 deletions(-)
> 

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
