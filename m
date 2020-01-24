Return-Path: <SRS0=2B5l=3N=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9C88C2D0CE
	for <linux-efi@archiver.kernel.org>; Fri, 24 Jan 2020 08:57:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82DFB2087E
	for <linux-efi@archiver.kernel.org>; Fri, 24 Jan 2020 08:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579856275;
	bh=weQibhHhjm/I54HF6xbEAHDUB4eSKIfjTJHuSAScdLA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Q1K9Lj7REzZvHkG1vXODqxBD70EDywLU5oLe4cWGsGOIvzHm/WD2Z/7OQzAo2xIJt
	 jt4D8chssb9XG2elBbW66myJxl9HlwytdNiRH+0uoslO36aFGaiG7RmwCg0OxCmR+Q
	 ylMvvgRiZXLuHjmPgQuw5/bMd+bBXrD58a6aCSs8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729603AbgAXI5z (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 24 Jan 2020 03:57:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:43384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbgAXI5z (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Fri, 24 Jan 2020 03:57:55 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6516920709;
        Fri, 24 Jan 2020 08:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579856274;
        bh=weQibhHhjm/I54HF6xbEAHDUB4eSKIfjTJHuSAScdLA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1kxkQ2mlfN+heyJk8Zq4viteonJq1htABzVFFxtGZYoofCDM5p/YmwSf7s9p//j1+
         pLjlJVycamMWseZI4uCPtUt4BaUZ8o2WZP/CR4FMMO8wFPI3QbVYpV1n9spKemoelz
         pVryZUdQZqbQsZPigrYsQfDDri9qjJm5snkzfjq0=
Date:   Fri, 24 Jan 2020 09:57:51 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Peter Jones <pjones@redhat.com>,
        Dave Olsthoorn <dave@bewaar.me>, x86@kernel.org,
        platform-driver-x86@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v12 03/10] firmware: Rename FW_OPT_NOFALLBACK to
 FW_OPT_NOFALLBACK_SYSFS
Message-ID: <20200124085751.GA2957916@kroah.com>
References: <20200115163554.101315-1-hdegoede@redhat.com>
 <20200115163554.101315-4-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200115163554.101315-4-hdegoede@redhat.com>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Wed, Jan 15, 2020 at 05:35:47PM +0100, Hans de Goede wrote:
> This is a preparation patch for adding a new platform fallback mechanism,
> which will have its own enable/disable FW_OPT_xxx option.
> 
> Note this also fixes a typo in one of the re-wordwrapped comments:
> enfoce -> enforce.
> 
> Acked-by: Luis Chamberlain <mcgrof@kernel.org>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

I've taken this in my tree for now in a quest to try to get others to
pay attention to this series...

thanks,

greg k-h
