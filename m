Return-Path: <SRS0=3LIX=EL=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4378C00A89
	for <linux-efi@archiver.kernel.org>; Thu,  5 Nov 2020 09:43:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89E9D2083B
	for <linux-efi@archiver.kernel.org>; Thu,  5 Nov 2020 09:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604569386;
	bh=Pw8x6wof7/hdOOYVanQAZZ6gdVYkVA+IEc86z5O8qrc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=i+wahsrhJe0hSknh9es0oLw+9VhVZnZAhfLJUw7REzTDRtBXjyg7dvgR03rW4CBH1
	 WWeIVLu7y9voQOOsNgkjkKMHGNZoB9iefxolkBYzq6QNHodR378XHsSNIy6Y6MRay5
	 Db5cn8uLUlM7Y3u4PQfIpfWLL5CYkDMi8I5+KCkc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbgKEJnG (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 5 Nov 2020 04:43:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:33572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725308AbgKEJnC (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Thu, 5 Nov 2020 04:43:02 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26DF52080D;
        Thu,  5 Nov 2020 09:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604569381;
        bh=Pw8x6wof7/hdOOYVanQAZZ6gdVYkVA+IEc86z5O8qrc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kpOlXevlFAmJCREcTFKRfD5uhjvLTSYj+Ves5DKdo86GMUD3CVRVuWr0+OSzjT6zk
         HsgdWXClSqMcLwNu71VPnjT6eQckO9YY5I6x7/Q9LYmHFyixMBjw3WicOqLDoHzH6P
         IjT7I/4ewgFB0wAtEIY+2k1FCdt4ggYIQEjta1+0=
Date:   Thu, 5 Nov 2020 10:43:50 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Saravana Kannan <saravanak@google.com>
Cc:     "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        kernel-team@android.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v1 17/18] driver core: Add helper functions to convert
 fwnode links to device links
Message-ID: <20201105094350.GG3439341@kroah.com>
References: <20201104232356.4038506-1-saravanak@google.com>
 <20201104232356.4038506-18-saravanak@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104232356.4038506-18-saravanak@google.com>
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Wed, Nov 04, 2020 at 03:23:54PM -0800, Saravana Kannan wrote:
> Add helper functions __fw_devlink_link_to_consumers() and
> __fw_devlink_link_to_suppliers() that convert fwnode links to device
> links.
> 
> __fw_devlink_link_to_consumers() is for creating:
> - Device links between a newly added device and all its consumer devices
>   that have been added to driver core.
> - Proxy SYNC_STATE_ONLY device links between the newly added device and
>   the parent devices of all its consumers that have not been added to
>   driver core yet.
> 
> __fw_devlink_link_to_suppliers() is for creating:
> - Device links between a newly added device and all its supplier devices
> - Proxy SYNC_STATE_ONLY device links between the newly added device and
>   all the supplier devices of its child device nodes.
> 
> Signed-off-by: Saravana Kannan <saravanak@google.com>

Did you just add build warnings with these static functions that no one
calls?

thanks,

greg k-h
