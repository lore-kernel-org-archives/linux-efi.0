Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89AEEC4332F
	for <linux-efi@archiver.kernel.org>; Fri, 21 Oct 2022 12:53:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiJUMxO (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 21 Oct 2022 08:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJUMxN (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Fri, 21 Oct 2022 08:53:13 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6932639E3;
        Fri, 21 Oct 2022 05:53:12 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 839C91F8EC;
        Fri, 21 Oct 2022 12:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1666356791; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PaeaapZu+CYmFKMd1eSqMOdEZx3Myv30fMdOWLVFWsI=;
        b=eGtA2M8cI2KEOrhpWf50To+xVN6JHQTfB/rjINMCdfBn3ZJWYR0+ahaaW5qhaRopsHXkw/
        Q62rh/mqTLZhXa1A7yyLQoBkcSuEj1gx6NpP0u3/JlCYgpBmjPysX0axxnNn9XY0JJV75Q
        d3VguaiAg9FPKY2Jlj9588uyKoZ+NrA=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 5B2082C141;
        Fri, 21 Oct 2022 12:53:11 +0000 (UTC)
Date:   Fri, 21 Oct 2022 14:53:10 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     John Ogness <john.ogness@linutronix.de>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH printk v2 08/38] efi: earlycon: use console_is_enabled()
Message-ID: <Y1KWNmUQpsuryF+I@alley>
References: <20221019145600.1282823-1-john.ogness@linutronix.de>
 <20221019145600.1282823-9-john.ogness@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019145600.1282823-9-john.ogness@linutronix.de>
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Wed 2022-10-19 17:01:30, John Ogness wrote:
> Replace (console->flags & CON_ENABLED) usage with console_is_enabled().
> 
> Signed-off-by: John Ogness <john.ogness@linutronix.de>

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
