Return-Path: <SRS0=Nv/U=35=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D6C0C35250
	for <linux-efi@archiver.kernel.org>; Sun,  9 Feb 2020 06:50:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E35E62072C
	for <linux-efi@archiver.kernel.org>; Sun,  9 Feb 2020 06:50:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgBIGuL (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Sun, 9 Feb 2020 01:50:11 -0500
Received: from bmailout2.hostsharing.net ([83.223.78.240]:35485 "EHLO
        bmailout2.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgBIGuL (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Sun, 9 Feb 2020 01:50:11 -0500
X-Greylist: delayed 658 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Feb 2020 01:50:10 EST
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id 035232800BB92;
        Sun,  9 Feb 2020 07:39:08 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 4977375F12; Sun,  9 Feb 2020 07:39:07 +0100 (CET)
Date:   Sun, 9 Feb 2020 07:39:07 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        lersek@redhat.com, leif@nuviainc.com, pjones@redhat.com,
        mjg59@google.com, agraf@csgraf.de, ilias.apalodimas@linaro.org,
        xypron.glpk@gmx.de, daniel.kiper@oracle.com
Subject: Re: [PATCH 1/2] efi/libstub: add support for loading the initrd from
 a device path
Message-ID: <20200209063907.fcwmwtiz2tjhjmol@wunner.de>
References: <20200206140352.6300-1-ardb@kernel.org>
 <20200206140352.6300-2-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200206140352.6300-2-ardb@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Thu, Feb 06, 2020 at 02:03:51PM +0000, Ard Biesheuvel wrote:
> --- a/drivers/firmware/efi/libstub/efistub.h
> +++ b/drivers/firmware/efi/libstub/efistub.h
> @@ -566,6 +566,14 @@ union efi_load_file_protocol {
>  	} mixed_mode;
>  };
>  
> +struct efi_vendor_dev_path {
> +	u8		type;
> +	u8		sub_type;
> +	u16		length;
> +	efi_guid_t	vendorguid;
> +	u8		vendordata[];
> +} __packed;

In commit 46cd4b75cd0e ("efi: Add device path parser") I introduced a
struct efi_dev_path with a union for the type-specific data.  Maybe
you can make use of it instead of introducing a new type?


> --- a/drivers/firmware/efi/libstub/efi-stub-helper.c
> +++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
> @@ -323,3 +323,68 @@ void efi_char16_printk(efi_char16_t *str)
>  	efi_call_proto(efi_table_attr(efi_system_table(), con_out),
>  		       output_string, str);
>  }
> +
> +static const struct {
> +	struct efi_vendor_dev_path	vendor;
> +	struct efi_generic_dev_path	end;
> +} __packed initrd_devpath = {

Nit:  Can we consistently stick to "dev_path" in lieu of "devpath"?

Thanks,

Lukas
