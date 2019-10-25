Return-Path: <SRS0=7Bpd=YS=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0C56CA9EA0
	for <linux-efi@archiver.kernel.org>; Fri, 25 Oct 2019 15:58:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 776FE20663
	for <linux-efi@archiver.kernel.org>; Fri, 25 Oct 2019 15:58:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="kABBg7Hl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388136AbfJYP6h (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 25 Oct 2019 11:58:37 -0400
Received: from linux.microsoft.com ([13.77.154.182]:38066 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727498AbfJYP6g (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Fri, 25 Oct 2019 11:58:36 -0400
Received: from [10.137.112.108] (unknown [131.107.174.108])
        by linux.microsoft.com (Postfix) with ESMTPSA id 7E95520F3BFE;
        Fri, 25 Oct 2019 08:58:35 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7E95520F3BFE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1572019115;
        bh=mDtsbMP5W8btp+nJtJmQtm2nuJFrzi43DMY3lfGFnJc=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=kABBg7HlsBpqfTHU9o2+an0n4inUsxoZjaZzDmIGp8F8253XbcMvLk5ROEwdiW1Dn
         ChrAO8aE69Xb1E9/nvTlUCVews4YvFtS08oTVK8Mmhx70fjewuy4Mdfiibe6Xt2s0S
         XnAuwWItO77AHH67U+wY4k9dr/fDqdApVcaCEB2o=
Subject: Re: [PATCH v5 2/4] powerpc: expose secure variables to userspace via
 sysfs
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
References: <20191025004729.4452-1-nayna@linux.ibm.com>
 <20191025004729.4452-3-nayna@linux.ibm.com>
From:   Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
Message-ID: <33275df6-9ee8-989f-9857-20946fb64b25@linux.microsoft.com>
Date:   Fri, 25 Oct 2019 08:58:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191025004729.4452-3-nayna@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On 10/24/19 5:47 PM, Nayna Jain wrote:

> +static ssize_t size_show(struct kobject *kobj, struct kobj_attribute *attr,
> +			 char *buf)
> +{
> +	uint64_t dsize;
> +	int rc;
> +
> +	rc = secvar_ops->get(kobj->name, strlen(kobj->name) + 1, NULL, &dsize);
> +	if (rc) {
> +		pr_err("Error retrieving variable size %d\n", rc);
> +		return rc;
> +	}
> +
> +	rc = sprintf(buf, "%llu\n", dsize);
> +
> +	return rc;
> +}
nit: change it to "return sprintf(buf, "%llu\n", dsize);" instead.

> +
> +static ssize_t data_read(struct file *filep, struct kobject *kobj,
> +			 struct bin_attribute *attr, char *buf, loff_t off,
> +			 size_t count)
> +{
> +	uint64_t dsize;
> +	char *data;
> +	int rc;
> +
> +	rc = secvar_ops->get(kobj->name, strlen(kobj->name) + 1, NULL, &dsize);
> +	if (rc) {
> +		pr_err("Error getting variable size %d\n", rc);
> +		return rc;
> +	}
> +	pr_debug("dsize is %llu\n", dsize);
> +
> +	data = kzalloc(dsize, GFP_KERNEL);
Is there any MAX\MIN limit on dsize that can be returned by secvar_ops?
Is it ok to not validate the dsize
> +
> +static ssize_t update_write(struct file *filep, struct kobject *kobj,
> +			    struct bin_attribute *attr, char *buf, loff_t off,
> +			    size_t count)
> +{
> +	int rc;
> +
> +	pr_debug("count is %ld\n", count);
> +	rc = secvar_ops->set(kobj->name, strlen(kobj->name)+1, buf, count);
> +	if (rc) {
> +		pr_err("Error setting the variable %s\n", kobj->name);
> +		return rc;
> +	}
> +
> +	return count;
> +}
Return value from this function can be a count (of bytes in buf?) or 
error code. Could cause confusion.
> +
> +static int secvar_sysfs_load(void)
> +{
> +	char *name;
> +	uint64_t namesize = 0;
> +	struct kobject *kobj;
> +	int rc;
> +
> +	name = kzalloc(NAME_MAX_SIZE, GFP_KERNEL);
> +	if (!name)
> +		return -ENOMEM;
> +
> +	do {
> +		rc = secvar_ops->get_next(name, &namesize, NAME_MAX_SIZE);
> +		if (rc) {
> +			if (rc != -ENOENT)
> +				pr_err("error getting secvar from firmware %d\n",
> +					rc);
> +			break;
> +		}
> +
> +		kobj = kzalloc(sizeof(*kobj), GFP_KERNEL);
> +		if (!kobj)
> +			return -ENOMEM;

Memory allocated for "name" is leaked in this case.

> +
> +		kobject_init(kobj, &secvar_ktype);
> +
> +		rc = kobject_add(kobj, &secvar_kset->kobj, "%s", name);
> +		if (rc) {
> +			pr_warn("kobject_add error %d for attribute: %s\n", rc,
> +				name);
> +			kobject_put(kobj);
> +			kobj = NULL;
> +		}
> +
> +		if (kobj)
> +			kobject_uevent(kobj, KOBJ_ADD);
> +
> +	} while (!rc);
> +
> +	kfree(name);
> +	return rc;
> +}
