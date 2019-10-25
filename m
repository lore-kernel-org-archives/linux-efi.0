Return-Path: <SRS0=7Bpd=YS=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBF5DCA9EA0
	for <linux-efi@archiver.kernel.org>; Fri, 25 Oct 2019 16:02:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A340621D81
	for <linux-efi@archiver.kernel.org>; Fri, 25 Oct 2019 16:02:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="ZG+7BShM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393532AbfJYQCt (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 25 Oct 2019 12:02:49 -0400
Received: from linux.microsoft.com ([13.77.154.182]:39564 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730061AbfJYQCt (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Fri, 25 Oct 2019 12:02:49 -0400
Received: from [10.137.112.108] (unknown [131.107.174.108])
        by linux.microsoft.com (Postfix) with ESMTPSA id 167462010AC4;
        Fri, 25 Oct 2019 09:02:48 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 167462010AC4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1572019368;
        bh=OgpaEOi3NtTvH8dAdXEaqJn/1OjtmfuxmiFQB2mjN+g=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ZG+7BShM7Zs+mQe8xyrHK3yGYcucqlMeIramEfEZ1sTdU9sg8hPD0fYRb6sPTmWOE
         mfuzyQAWb2eGe7bxnNeeHBCOX5WDqTnqNjsV8KOUmQJyoHqYr5+3BSb7PCe/79h6cs
         un5CwwbPOuujsxZ9OErVRUI0EgJ/VAIxSVOFu1K4=
Subject: Re: [PATCH v5 4/4] powerpc: load firmware trusted keys/hashes into
 kernel keyring
To:     Nayna Jain <nayna@linux.ibm.com>, linuxppc-dev@ozlabs.org,
        linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Jeremy Kerr <jk@ozlabs.org>,
        Matthew Garret <matthew.garret@nebula.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Claudio Carvalho <cclaudio@linux.ibm.com>,
        George Wilson <gcwilson@linux.ibm.com>,
        Elaine Palmer <erpalmer@us.ibm.com>,
        Eric Ricther <erichte@linux.ibm.com>,
        Oliver O'Halloran <oohall@gmail.com>
References: <20191025005839.4498-1-nayna@linux.ibm.com>
From:   Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
Message-ID: <5be98aad-66b9-2549-2772-ef30aa1275b4@linux.microsoft.com>
Date:   Fri, 25 Oct 2019 09:02:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191025005839.4498-1-nayna@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On 10/24/19 5:58 PM, Nayna Jain wrote:

> +
> +/*
> + * Get a certificate list blob from the named secure variable.
> + */
> +static __init void *get_cert_list(u8 *key, unsigned long keylen, uint64_t *size)
> +{
> +	int rc;
> +	void *db;
> +
> +	rc = secvar_ops->get(key, keylen, NULL, size);
> +	if (rc) {
> +		pr_err("Couldn't get size: %d\n", rc);
> +		return NULL;
> +	}
> +
> +	db = kmalloc(*size, GFP_KERNEL);

Is there a MIN\MAX limit on size that should be validated here before 
memory allocation?

> +	if (!db)
> +		return NULL;
> +
> +	rc = secvar_ops->get(key, keylen, db, size);
> +	if (rc) {
> +		kfree(db);
> +		pr_err("Error reading db var: %d\n", rc);
> +		return NULL;
nit: set db to NULL and return from the end of the function.

> +	}
> +
> +	return db;
> +}

