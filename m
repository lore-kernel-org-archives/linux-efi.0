Return-Path: <SRS0=BFuN=WW=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E622AC3A59F
	for <linux-efi@archiver.kernel.org>; Mon, 26 Aug 2019 14:01:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCB7C21852
	for <linux-efi@archiver.kernel.org>; Mon, 26 Aug 2019 14:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1566828099;
	bh=gPz4wzPC17jbgMO86fVkOAlhLpUk0FXF6vl4/58WHts=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=AkW1WuYSUoTXGah8bNxWu0shKDxUEMrz2FyCmbgvIqQKyTd8M8WYF7TtV3fK5kB4F
	 kFcbZFrIhWLkYxpnUe9x0Us0Ko+dkkgIt9wO0aVtOsGfiGojukwo2MLat7LTMNMUag
	 domVFHJNbRmNwwT2BUV343w9/Ynf/9LTmZjpHySA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbfHZOBf (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 26 Aug 2019 10:01:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:53342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728760AbfHZOBf (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Mon, 26 Aug 2019 10:01:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFDBB2173E;
        Mon, 26 Aug 2019 14:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566828094;
        bh=gPz4wzPC17jbgMO86fVkOAlhLpUk0FXF6vl4/58WHts=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tlMjEtZ/iEjWrikes+vLlInuU046SluV9TWPapUiXpJt/+bPV12BRKcf0Q4/FMFUB
         Q3eGS7vM/v7cSmwjsdkUHluJswE6k0jlwNahYu1SPgkS0vpB6w3XaQbk1izIuX453X
         FlTc/fr819cZx7DdefGzUll8THxgEnejTsIiBA0o=
Date:   Mon, 26 Aug 2019 16:01:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nayna Jain <nayna@linux.ibm.com>
Cc:     linuxppc-dev@ozlabs.org, linux-efi@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Jeremy Kerr <jk@ozlabs.org>,
        Matthew Garret <matthew.garret@nebula.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Claudio Carvalho <cclaudio@linux.ibm.com>,
        George Wilson <gcwilson@linux.ibm.com>,
        Elaine Palmer <erpalmer@us.ibm.com>,
        Eric Ricther <erichte@linux.ibm.com>,
        Oliver O'Halloran <oohall@gmail.com>
Subject: Re: [PATCH v3 2/4] powerpc: expose secure variables to userspace via
 sysfs
Message-ID: <20190826140131.GA15270@kroah.com>
References: <1566825818-9731-1-git-send-email-nayna@linux.ibm.com>
 <1566825818-9731-3-git-send-email-nayna@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566825818-9731-3-git-send-email-nayna@linux.ibm.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Mon, Aug 26, 2019 at 09:23:36AM -0400, Nayna Jain wrote:
> +static struct bin_attribute update_attr = {
> +	.attr = {.name = "update", .mode = 0200},
> +	.size = VARIABLE_MAX_SIZE,
> +	.write = update_write,
> +};

Ah, do we need a __BIN_ATTR_WO() macro for you?  That would make this
more obvious, right?

Other than that minor thing (not a complaint at all) looks much better
to me, nice work:

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
