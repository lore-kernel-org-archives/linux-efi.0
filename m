Return-Path: <SRS0=5ZN8=SU=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1691C10F0E
	for <linux-efi@archiver.kernel.org>; Thu, 18 Apr 2019 03:44:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F536214DA
	for <linux-efi@archiver.kernel.org>; Thu, 18 Apr 2019 03:44:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733067AbfDRDoc (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 17 Apr 2019 23:44:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46196 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732737AbfDRDob (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Wed, 17 Apr 2019 23:44:31 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A386730BA36B;
        Thu, 18 Apr 2019 03:44:31 +0000 (UTC)
Received: from dhcp-128-65.nay.redhat.com (ovpn-12-74.pek2.redhat.com [10.72.12.74])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F640600C2;
        Thu, 18 Apr 2019 03:44:29 +0000 (UTC)
Date:   Thu, 18 Apr 2019 11:44:25 +0800
From:   Dave Young <dyoung@redhat.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-efi@vger.kernel.org, Matthew Garrett <mjg59@google.com>,
        "Lee, Chun-Yi" <jlee@suse.com>
Subject: kexec reboot reset with efi_delete_dummy_variable
Message-ID: <20190418034425.GA14950@dhcp-128-65.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Thu, 18 Apr 2019 03:44:31 +0000 (UTC)
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Hi,

While testing kexec reboot, I sometimes get a reset.  Commenting out the
dummy cleanup in kexec_enter_virtual_mode() make kexec reboot works
again.

Checking the git log, the cleanup was added in below commit: 
commit f8b8404337de4e2466e2e1139ea68b1f8295974f
Author: Matthew Garrett <matthew.garrett@nebula.com>
Date:   Sat Jun 1 16:06:20 2013 -0400

    Modify UEFI anti-bricking code

[snip]

In below function, it tries to set a dummy variable, and later delete it
in case success.
arch/x86/platform/efi/quirks.c: -> efi_query_variable_store()

So why we still need delete/cleanup the dummy var after entering virt
mode?  Am I missing something?

Thanks
Dave
