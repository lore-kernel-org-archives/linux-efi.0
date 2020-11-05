Return-Path: <SRS0=3LIX=EL=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30226C00A89
	for <linux-efi@archiver.kernel.org>; Thu,  5 Nov 2020 09:42:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CABBE2083B
	for <linux-efi@archiver.kernel.org>; Thu,  5 Nov 2020 09:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604569354;
	bh=rXSI1BfmjG8vLqTpJNbDhN9/kV2FABpxj9zjELdDyKk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=cysK2fJyKJNzk8RdN5c85b3orJXHKsXvsxnRuVCimmVqNFFUmaclj48PEEZtsNXRK
	 yiT4IolugYVu+eP0fFwg7LuDdLKLOhmdUmPVFBXS4YOObCdi3WlTFlnpq0wfSvd5bE
	 QiZO6o874R46Q9nIcAZ0zx5EIH3NC/Ppay2NTk78=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgKEJme (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 5 Nov 2020 04:42:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:33396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725308AbgKEJmd (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Thu, 5 Nov 2020 04:42:33 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 584552080D;
        Thu,  5 Nov 2020 09:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604569351;
        bh=rXSI1BfmjG8vLqTpJNbDhN9/kV2FABpxj9zjELdDyKk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ydsz10KeDnFwmSbiBSVmRTIRAKtvEZWCVMohOdND4AQH02rTm/8XrGunQoUx6Qvs6
         7DomND3bOFLNeWVGkIcg+A8W+VxSkBzop0RE1wq/yfEtXaRv+HlIis9OUfp8LyJgFm
         x/8Eo5QLx7nVA2jhSohdMNlPKmgLjgHDTbgajfLU=
Date:   Thu, 5 Nov 2020 10:43:18 +0100
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
Subject: Re: [PATCH v1 16/18] efi: Update implementation of add_links() to
 create fwnode links
Message-ID: <20201105094318.GF3439341@kroah.com>
References: <20201104232356.4038506-1-saravanak@google.com>
 <20201104232356.4038506-17-saravanak@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104232356.4038506-17-saravanak@google.com>
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Wed, Nov 04, 2020 at 03:23:53PM -0800, Saravana Kannan wrote:
> The semantics of add_links() has changed from creating device link
> between devices to creating fwnode links between fwnodes. So, update the
> implementation of add_links() to match the new semantics.
> 
> Signed-off-by: Saravana Kannan <saravanak@google.com>
> ---
>  drivers/firmware/efi/efi-init.c | 23 ++---------------------
>  1 file changed, 2 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/firmware/efi/efi-init.c b/drivers/firmware/efi/efi-init.c
> index b148f1459fb3..c0c3d4c3837a 100644
> --- a/drivers/firmware/efi/efi-init.c
> +++ b/drivers/firmware/efi/efi-init.c
> @@ -316,11 +316,10 @@ static struct device_node *find_pci_overlap_node(void)
>   * resource reservation conflict on the memory window that the efifb
>   * framebuffer steals from the PCIe host bridge.
>   */
> -static int efifb_add_links(const struct fwnode_handle *fwnode,
> +static int efifb_add_links(struct fwnode_handle *fwnode,
>  			   struct device *dev)

So you are fixing the build warning you added a few patches ago here?
Please fix up the function signatures when you made that change, not
here later on.

thanks,

greg k-h
