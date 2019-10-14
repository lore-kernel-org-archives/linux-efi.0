Return-Path: <SRS0=BGxp=YH=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB34DC4CECE
	for <linux-efi@archiver.kernel.org>; Mon, 14 Oct 2019 20:21:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D034A217F9
	for <linux-efi@archiver.kernel.org>; Mon, 14 Oct 2019 20:21:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732403AbfJNUVR (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 14 Oct 2019 16:21:17 -0400
Received: from mga06.intel.com ([134.134.136.31]:21129 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730516AbfJNUVR (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Mon, 14 Oct 2019 16:21:17 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Oct 2019 13:21:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,296,1566889200"; 
   d="scan'208";a="195087566"
Received: from kridax-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.7.178])
  by fmsmga007.fm.intel.com with ESMTP; 14 Oct 2019 13:21:12 -0700
Date:   Mon, 14 Oct 2019 23:21:11 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Kairui Song <kasong@redhat.com>, linux-kernel@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Matthew Garrett <matthewgarrett@google.com>,
        Baoquan He <bhe@redhat.com>, Dave Young <dyoung@redhat.com>,
        x86@kernel.org, linux-efi@vger.kernel.org,
        linux-integrity@vger.kernel.org
Subject: Re: [PATCH v3] x86, efi: never relocate kernel below lowest
 acceptable address
Message-ID: <20191014202111.GP15552@linux.intel.com>
References: <20191012034421.25027-1-kasong@redhat.com>
 <20191014101419.GA4715@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014101419.GA4715@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Mon, Oct 14, 2019 at 12:14:19PM +0200, Borislav Petkov wrote:
> Your spelling of "EFI" is like a random number generator in this
> paragraph: "Efi", "efi" and "EFI". Can you please be more careful when
> writing your commit messages? They're not some random text you hurriedly
> jot down before sending the patch but a most important description of
> why a change is being done.

Was there a section in the patch submission documentation to point out
when people send patches with all the possible twists for an acronym?

This is giving me constantly gray hairs with TPM patches.

/Jarkko
