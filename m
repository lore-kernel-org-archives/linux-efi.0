Return-Path: <SRS0=t25Z=WE=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26195C0650F
	for <linux-efi@archiver.kernel.org>; Thu,  8 Aug 2019 15:11:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03A18217F4
	for <linux-efi@archiver.kernel.org>; Thu,  8 Aug 2019 15:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732990AbfHHPLe (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 8 Aug 2019 11:11:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:1481 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732446AbfHHPLe (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Thu, 8 Aug 2019 11:11:34 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Aug 2019 08:11:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,361,1559545200"; 
   d="scan'208";a="374881945"
Received: from sandersb-mobl.ger.corp.intel.com (HELO localhost) ([10.249.33.239])
  by fmsmga006.fm.intel.com with ESMTP; 08 Aug 2019 08:11:30 -0700
Date:   Thu, 8 Aug 2019 18:11:29 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Peter Huewe <peterhuewe@gmx.de>, x86@kernel.org,
        linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org,
        Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH 5.3 regression fix] efi-stub: Fix get_efi_config_table on
 mixed-mode setups
Message-ID: <20190808151103.m2ccrk54x6emgm54@linux.intel.com>
References: <20190807215903.24990-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807215903.24990-1-hdegoede@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Wed, Aug 07, 2019 at 11:59:03PM +0200, Hans de Goede wrote:
> Fix get_efi_config_table using the wrong structs when booting a
> 64 bit kernel on 32 bit firmware.
> 
> Cc: Matthew Garrett <mjg59@google.com>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Fixes: 82d736ac56d7 ("Abstract out support for locating an EFI config table")
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Acked-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko
