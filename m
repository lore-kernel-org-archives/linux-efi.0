Return-Path: <SRS0=O+gb=TX=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DF95C282DD
	for <linux-efi@archiver.kernel.org>; Thu, 23 May 2019 12:15:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B8AF20879
	for <linux-efi@archiver.kernel.org>; Thu, 23 May 2019 12:15:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729361AbfEWMO4 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 23 May 2019 08:14:56 -0400
Received: from mga03.intel.com ([134.134.136.65]:51663 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728309AbfEWMO4 (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Thu, 23 May 2019 08:14:56 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 May 2019 05:14:55 -0700
X-ExtLoop1: 1
Received: from jbroders-mobl.ger.corp.intel.com (HELO localhost) ([10.252.44.6])
  by orsmga003.jf.intel.com with ESMTP; 23 May 2019 05:14:51 -0700
Date:   Thu, 23 May 2019 15:14:49 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Matthew Garrett <matthewgarrett@google.com>
Cc:     linux-integrity@vger.kernel.org, peterhuewe@gmx.de, jgg@ziepe.ca,
        roberto.sassu@huawei.com, linux-efi@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, tweek@google.com, bsz@semihalf.com
Subject: Re: [PATCH V7 0/4] Add support for crypto agile logs
Message-ID: <20190523121449.GA9997@linux.intel.com>
References: <20190520205501.177637-1-matthewgarrett@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520205501.177637-1-matthewgarrett@google.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Mon, May 20, 2019 at 01:54:57PM -0700, Matthew Garrett wrote:
> Identical to previous version except without the KSAN workaround - Ard
> has a better solution for that.


Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Tested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko
