Return-Path: <SRS0=p/hc=SR=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB73CC282CE
	for <linux-efi@archiver.kernel.org>; Mon, 15 Apr 2019 08:53:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C30862087C
	for <linux-efi@archiver.kernel.org>; Mon, 15 Apr 2019 08:53:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfDOIx4 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 15 Apr 2019 04:53:56 -0400
Received: from mga12.intel.com ([192.55.52.136]:64593 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727112AbfDOIx4 (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Mon, 15 Apr 2019 04:53:56 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Apr 2019 01:53:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,353,1549958400"; 
   d="scan'208";a="291625514"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.189])
  by orsmga004.jf.intel.com with ESMTP; 15 Apr 2019 01:53:51 -0700
Date:   Mon, 15 Apr 2019 11:53:50 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Matthew Garrett <matthewgarrett@google.com>
Cc:     linux-integrity@vger.kernel.org, peterhuewe@gmx.de, jgg@ziepe.ca,
        roberto.sassu@huawei.com, linux-efi@vger.kernel.org,
        tweek@google.com, Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH] efi: Include tpm_eventlog.h after asm/efi.h to avoid
 memcpy breakage
Message-ID: <20190415085350.GA22659@linux.intel.com>
References: <20190403193238.145204-1-matthewgarrett@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190403193238.145204-1-matthewgarrett@google.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Wed, Apr 03, 2019 at 12:32:37PM -0700, Matthew Garrett wrote:
> 769a8089c1fd2 (x86, efi, kasan: #undef memset/memcpy/memmove per arch)
> disables the KASAN version of certain memory calls in the EFI boot stub.
> tpm_eventlog.h references memcpy, so must be included after asm/efi.h in
> order to allow 769a8089c1fd2 to take effect on its declarations.
> 
> Signed-off-by: Matthew Garrett <mjg59@google.com>

Applied.

/Jarkko
