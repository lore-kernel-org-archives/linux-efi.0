Return-Path: <SRS0=FYpD=EI=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DE00C00A89
	for <linux-efi@archiver.kernel.org>; Mon,  2 Nov 2020 22:38:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0C67222BA
	for <linux-efi@archiver.kernel.org>; Mon,  2 Nov 2020 22:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604356702;
	bh=MnRwNpTxYL2HWRVBDNlcJB605B7LEOgiTxYCjqWKkkE=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=gliTRFx3OExusv2dIcdTG0b4jLfFqyVwN7VRb4ngNISbSL0yxh0gGNebd0Ydo+vgt
	 XKoqKscLWwwQHzhGx7oRwid+sW6sbESvKg532SN0YH6MSvtxBAZvqznFtcep1EmugB
	 eEYUe56/7otGpBZSw5zgZafQi0/mVADVRH6hFi+w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbgKBWiW (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 2 Nov 2020 17:38:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:55154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbgKBWiW (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Mon, 2 Nov 2020 17:38:22 -0500
Received: from e123331-lin.nice.arm.com (lfbn-nic-1-188-42.w2-15.abo.wanadoo.fr [2.15.37.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92D0120786;
        Mon,  2 Nov 2020 22:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604356701;
        bh=MnRwNpTxYL2HWRVBDNlcJB605B7LEOgiTxYCjqWKkkE=;
        h=From:To:Cc:Subject:Date:From;
        b=NwH6zNp7aUEa8vIeWOgEpOMnO6D3UjVOWyZKzVGKiXvNtRGCIZTKfROoJyZCouK9/
         z35OFNR5CKDbnbSEuaCIUSNMsVfACajppzruOPr7/wG3HdrTPN3AqOctpY4iJe1odl
         l94IZ+5YK6B+oJIS3scy3FDQOdS1zr0hg4WDSfGU=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, zohar@linux.ibm.com,
        jmorris@namei.org, serge@hallyn.com, dmitry.kasatkin@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, clin@suse.com,
        x86@kernel.org, jlee@suse.com, linux-integrity@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v4 0/3] wire up IMA secure boot for arm64
Date:   Mon,  2 Nov 2020 23:37:57 +0100
Message-Id: <20201102223800.12181-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

This is a follow-up to Chester's series [0] to enable IMA to the secure
boot state of arm64 platforms, which is EFI based.

This v4 implements the changes I suggested to Chester, in particular:
- disregard MokSbState when factoring out secure boot mode discovery
- turn the x86 IMA arch code into shared code for all architectures.

This reduces the final patch to a one liner enabling a Kconfig option
for arm64 when EFI is enabled.

Build tested only.

[0] https://lore.kernel.org/linux-arm-kernel/20201030060840.1810-1-clin@suse.com/

Cc: zohar@linux.ibm.com
Cc: jmorris@namei.org
Cc: serge@hallyn.com
Cc: dmitry.kasatkin@gmail.com
Cc: catalin.marinas@arm.com
Cc: will@kernel.org
Cc: clin@suse.com
Cc: x86@kernel.org
Cc: jlee@suse.com
Cc: linux-integrity@vger.kernel.org,
Cc: linux-arm-kernel@lists.infradead.org
  
Chester Lin (3):
  efi: generalize efi_get_secureboot
  ima: generalize x86/EFI arch glue for other EFI architectures
  arm64/ima: add ima_arch support

 arch/arm64/Kconfig                            |  1 +
 arch/x86/boot/compressed/Makefile             |  2 +-
 arch/x86/include/asm/efi.h                    |  3 ++
 arch/x86/kernel/Makefile                      |  2 -
 drivers/firmware/efi/libstub/efistub.h        |  2 +
 drivers/firmware/efi/libstub/secureboot.c     | 41 +++++++----------
 include/linux/efi.h                           | 23 +++++++++-
 security/integrity/ima/Makefile               |  4 ++
 .../integrity/ima/ima_efi.c                   | 45 +++++--------------
 9 files changed, 60 insertions(+), 63 deletions(-)
 rename arch/x86/kernel/ima_arch.c => security/integrity/ima/ima_efi.c (60%)

-- 
2.17.1

