Return-Path: <SRS0=p/hc=SR=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 093C9C282CE
	for <linux-efi@archiver.kernel.org>; Mon, 15 Apr 2019 08:47:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6D4920833
	for <linux-efi@archiver.kernel.org>; Mon, 15 Apr 2019 08:47:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725794AbfDOIr3 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 15 Apr 2019 04:47:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:8557 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725779AbfDOIr3 (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Mon, 15 Apr 2019 04:47:29 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Apr 2019 01:47:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,353,1549958400"; 
   d="scan'208";a="337561688"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.189])
  by fmsmga006.fm.intel.com with ESMTP; 15 Apr 2019 01:47:25 -0700
Date:   Mon, 15 Apr 2019 11:47:23 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Matthew Garrett <matthewgarrett@google.com>
Cc:     linux-integrity@vger.kernel.org, peterhuewe@gmx.de, jgg@ziepe.ca,
        roberto.sassu@huawei.com, linux-efi@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, tweek@google.com
Subject: Re: [PATCH] TCG2 log support build fixes for non-x86_64
Message-ID: <20190415084723.GA20831@linux.intel.com>
References: <20190402215556.257406-1-matthewgarrett@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
In-Reply-To: <20190402215556.257406-1-matthewgarrett@google.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
Message-ID: <20190415084723.9dIa_RuO8z6Ccb4KQifBjyBKdhMXkYu-ASr3RcLBiek@z>

On Tue, Apr 02, 2019 at 02:55:54PM -0700, Matthew Garrett wrote:
> Couple of patches to fix ktest reported issues with the crypto-agile log
> format support.

Applied and squashed. Should be soon in linux-next.

/Jarkko
