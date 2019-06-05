Return-Path: <SRS0=OHl2=UE=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CBD4C28CC5
	for <linux-efi@archiver.kernel.org>; Wed,  5 Jun 2019 14:33:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C9A920866
	for <linux-efi@archiver.kernel.org>; Wed,  5 Jun 2019 14:33:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728026AbfFEOd4 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 5 Jun 2019 10:33:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:6318 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727961AbfFEOdz (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Wed, 5 Jun 2019 10:33:55 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jun 2019 07:33:55 -0700
X-ExtLoop1: 1
Received: from araresx-wtg1.ger.corp.intel.com (HELO localhost) ([10.252.46.102])
  by orsmga002.jf.intel.com with ESMTP; 05 Jun 2019 07:33:50 -0700
Date:   Wed, 5 Jun 2019 17:33:44 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Chris Coulson <chris.coulson@canonical.com>
Cc:     linux-integrity@vger.kernel.org, linux-efi@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Matthew Garrett <mjg59@google.com>,
        Bartosz Szczepanek <bsz@semihalf.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] tpm: Don't dereference event after it's unmapped in
 __calc_tpm2_event_size
Message-ID: <20190605143344.GF11331@linux.intel.com>
References: <20190604230433.20936-1-chris.coulson@canonical.com>
 <20190604230433.20936-2-chris.coulson@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604230433.20936-2-chris.coulson@canonical.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Wed, Jun 05, 2019 at 12:04:33AM +0100, Chris Coulson wrote:
> The pointer to the event header is dereferenced on each loop iteration in
> order to obtain the digest count, but when called from
> tpm2_calc_event_log_size, the event header is unmapped on the first
> iteration of the loop. This results in an invalid access for on subsequent
> loop iterations for log entries that have more than one digest.
> 
> Signed-off-by: Chris Coulson <chris.coulson@canonical.com>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko
