Return-Path: <SRS0=IuE4=UI=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 114A3C28EBD
	for <linux-efi@archiver.kernel.org>; Sun,  9 Jun 2019 19:53:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE456206C3
	for <linux-efi@archiver.kernel.org>; Sun,  9 Jun 2019 19:53:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729314AbfFITxl (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Sun, 9 Jun 2019 15:53:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:43728 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726950AbfFITxl (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Sun, 9 Jun 2019 15:53:41 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jun 2019 12:53:40 -0700
X-ExtLoop1: 1
Received: from nbylina-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.34.102])
  by fmsmga004.fm.intel.com with ESMTP; 09 Jun 2019 12:53:38 -0700
Date:   Sun, 9 Jun 2019 22:53:37 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Matthew Garrett <matthewgarrett@google.com>
Cc:     linux-integrity@vger.kernel.org, peterhuewe@gmx.de, jgg@ziepe.ca,
        linux-efi@vger.kernel.org, ard.biesheuvel@linaro.org,
        Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH] efi: Fix TPM code build failure on ARM
Message-ID: <20190609195337.GA25074@linux.intel.com>
References: <20190605181140.35559-1-matthewgarrett@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605181140.35559-1-matthewgarrett@google.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Wed, Jun 05, 2019 at 11:11:40AM -0700, Matthew Garrett wrote:
> asm/early_ioremap.h needs to be #included before tpm_eventlog.h in order
> to ensure that early_memremap is available.
> 
> Signed-off-by: Matthew Garrett <mjg59@google.com>

Thanks, squashed to "tpm: Reserve the TPM final events table".

/Jarkko
