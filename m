Return-Path: <SRS0=pFGo=XU=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9500C432C2
	for <linux-efi@archiver.kernel.org>; Wed, 25 Sep 2019 10:39:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90A16214D9
	for <linux-efi@archiver.kernel.org>; Wed, 25 Sep 2019 10:39:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390099AbfIYKjK (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 25 Sep 2019 06:39:10 -0400
Received: from mga03.intel.com ([134.134.136.65]:60742 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389655AbfIYKjK (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Wed, 25 Sep 2019 06:39:10 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Sep 2019 03:39:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,547,1559545200"; 
   d="scan'208";a="364285173"
Received: from dariusvo-mobl.ger.corp.intel.com (HELO localhost) ([10.249.39.150])
  by orsmga005.jf.intel.com with ESMTP; 25 Sep 2019 03:38:57 -0700
Date:   Wed, 25 Sep 2019 13:38:54 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Jerry Snitselaar <jsnitsel@redhat.com>
Cc:     linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        Matthew Garrett <mjg59@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [RFC PATCH] tpm: only set efi_tpm_final_log_size after
 successful event log parsing
Message-ID: <20190925103854.GC6256@linux.intel.com>
References: <20190918191626.5741-1-jsnitsel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918191626.5741-1-jsnitsel@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Wed, Sep 18, 2019 at 12:16:26PM -0700, Jerry Snitselaar wrote:
> +	if (tbl_size < 0) {
> +		pr_err("Failed to parse event in TPM Final Event log\n");

FW_BUG?

> +		goto calc_out;
> +	}
> +
>  	memblock_reserve((unsigned long)final_tbl,
>  			 tbl_size + sizeof(*final_tbl));
> -	early_memunmap(final_tbl, sizeof(*final_tbl));
>  	efi_tpm_final_log_size = tbl_size;
>  
> +calc_out:
> +	early_memunmap(final_tbl, sizeof(*final_tbl));

out_calc

>  out:
>  	early_memunmap(log_tbl, sizeof(*log_tbl));
>  	return ret;
> -- 
> 2.23.0
> 

/Jarkko
