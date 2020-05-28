Return-Path: <SRS0=CLSZ=7K=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D53EDC433E0
	for <linux-efi@archiver.kernel.org>; Thu, 28 May 2020 19:49:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFCEA207D3
	for <linux-efi@archiver.kernel.org>; Thu, 28 May 2020 19:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406798AbgE1TtK (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 28 May 2020 15:49:10 -0400
Received: from mga18.intel.com ([134.134.136.126]:16406 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406780AbgE1TtH (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Thu, 28 May 2020 15:49:07 -0400
IronPort-SDR: 31i6abwS5LknnhKrxyI2bMc3KGFItnMNMYHtzfEH6fmYjBiFYLt8wOfHB8DvM9JCuGzeSiYOdk
 JlLJD+D2K8JA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 12:49:06 -0700
IronPort-SDR: 7SZ4gi5DMir9fY+XLPCMDiSi0tSM+jWx6oq/jVf6s4XrNSfpLVNO+cUktyUDUmk2cNmhI7G1xq
 CWiCXtMpui0w==
X-IronPort-AV: E=Sophos;i="5.73,446,1583222400"; 
   d="scan'208";a="469254368"
Received: from agluck-desk2.sc.intel.com ([10.3.52.68])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 12:49:05 -0700
From:   Tony Luck <tony.luck@intel.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Tony Luck <tony.luck@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Jeremy Kerr <jk@ozlabs.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Couple of efivarfs fixes
Date:   Thu, 28 May 2020 12:49:03 -0700
Message-Id: <20200528194905.690-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

1) Some apps want to monitor changes in EFI variables, but reading the
   file and comparing is inefficient.  Just have Linnux update the
   modification time when a file is written

2) A rate limited read can return -EINTR ... very suprising to apps.

Tony Luck (2):
  efivarfs: Update inode modification time for successful writes
  efivarfs: Don't return -EINTR when rate-limiting reads

 fs/efivarfs/file.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

-- 
2.21.1

