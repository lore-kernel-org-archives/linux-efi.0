Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1175C43217
	for <linux-efi@archiver.kernel.org>; Thu, 10 Nov 2022 14:29:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiKJO3H (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 10 Nov 2022 09:29:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbiKJO2y (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Thu, 10 Nov 2022 09:28:54 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3769911802;
        Thu, 10 Nov 2022 06:28:53 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id ECB5922B12;
        Thu, 10 Nov 2022 14:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1668090531; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H0GZSNavtvfiBTr63JLFzqLihqxh4Gfxr36RVbsC3rQ=;
        b=cTDYtzyhFg035ctkz0LdQthTVJou3yEs4PvANKV4oinyBa0AdulfjDN9tkbXrSZsqzPwz7
        LM7fmtQ8bMNrj3hwvXb5z7CTBP0ecMgGu7gzxrMwXKJ7PzAXWrDHhpIRn1SM5C/VbjF8GC
        ny1Lzd4Tp5cHl7rKXpIipEXQtT3tbLo=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 962DE2C141;
        Thu, 10 Nov 2022 14:28:51 +0000 (UTC)
Date:   Thu, 10 Nov 2022 15:28:51 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     John Ogness <john.ogness@linutronix.de>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH printk v3 25/40] efi: earlycon: use
 console_is_registered()
Message-ID: <Y20Ko0ezrpVpoxZR@alley>
References: <20221107141638.3790965-1-john.ogness@linutronix.de>
 <20221107141638.3790965-26-john.ogness@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107141638.3790965-26-john.ogness@linutronix.de>
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Mon 2022-11-07 15:22:23, John Ogness wrote:
> The CON_ENABLED status of a console is a runtime setting that does not
> involve the console driver. Drivers must not assume that if the console
> is disabled then proper hardware management is not needed. For the EFI
> earlycon case, it is about remapping/unmapping memory for the
> framebuffer.
> 
> Use console_is_registered() instead of checking CON_ENABLED.
> 
> Signed-off-by: John Ogness <john.ogness@linutronix.de>

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
