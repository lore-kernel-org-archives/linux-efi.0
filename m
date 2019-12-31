Return-Path: <SRS0=+Anq=2V=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03858C2D0C2
	for <linux-efi@archiver.kernel.org>; Tue, 31 Dec 2019 18:50:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB411206D9
	for <linux-efi@archiver.kernel.org>; Tue, 31 Dec 2019 18:50:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbfLaSuy (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 31 Dec 2019 13:50:54 -0500
Received: from mga05.intel.com ([192.55.52.43]:6014 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727071AbfLaSuy (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Tue, 31 Dec 2019 13:50:54 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Dec 2019 10:50:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,380,1571727600"; 
   d="scan'208";a="420724156"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 31 Dec 2019 10:50:53 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1imMbU-0009QM-Ip; Wed, 01 Jan 2020 02:50:52 +0800
Date:   Wed, 1 Jan 2020 02:50:45 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     kbuild-all@lists.01.org, linux-efi@vger.kernel.org
Subject: [efi:next 5/13] arch/x86/platform/efi/efi_64.c:77:7: sparse: sparse:
 symbol 'efi_old_memmap_phys_prolog' was not declared. Should it be static?
Message-ID: <202001010259.nnaop2UM%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git next
head:   3cf7227ba765babbcee59c572cd54bda019af183
commit: 68f6b351cf93faf6977a623ef5b2913a8064d67f [5/13] efi/x86: split off some old memmap handling into separate routines
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-129-g341daf20-dirty
        git checkout 68f6b351cf93faf6977a623ef5b2913a8064d67f
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> arch/x86/platform/efi/efi_64.c:77:7: sparse: sparse: symbol 'efi_old_memmap_phys_prolog' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
