Return-Path: <SRS0=ZTBG=25=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCA2CC00523
	for <linux-efi@archiver.kernel.org>; Wed,  8 Jan 2020 07:45:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 808AB20705
	for <linux-efi@archiver.kernel.org>; Wed,  8 Jan 2020 07:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578469509;
	bh=aoeircKmZXOqyOp5WN2SNq2bqRTgk0NxS82Q9M0d+MA=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=2O2ZiQyHbE4YwBk0e/5cgRZwR156xzOFgTXcbTZRkMQUXjFk0u/A4FZDsfaMUjKOI
	 Nue2RCVhEnxt+y60lykInd7KDfZ/flkMqJNMV/XV+g5EDCyPQx2kwZg3jHJWTFbJ8v
	 sxmfKP9VvUMIdy8efenJdjBmoOQzwXHstFa9qJZ8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbgAHHpJ (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 8 Jan 2020 02:45:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:45418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726087AbgAHHpJ (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Wed, 8 Jan 2020 02:45:09 -0500
Received: from localhost.localdomain (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BE4B2053B;
        Wed,  8 Jan 2020 07:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578469508;
        bh=aoeircKmZXOqyOp5WN2SNq2bqRTgk0NxS82Q9M0d+MA=;
        h=From:To:Cc:Subject:Date:From;
        b=ZDSm2V9RgSfKXyklLr5NAyDcIBnz9wTgZQNrQfDOqE5ow2L61oaFx2Vy/hHPcfzja
         vwBdWleL//ajNGH/ig103XDs9qm2b2ML2vytYha0MbDVj0It+T7XIQ2V4pdcoMvrcI
         nHaP6y1OPdwlGObJz0Rvfgg4yrXQR1BoCUe5x7M4=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     luto@kernel.org, x86@kernel.org, nivedita@alum.mit.edu,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 0/2] efi/libstub/x86: two more tweaks for the EFI stub startup code
Date:   Wed,  8 Jan 2020 08:45:00 +0100
Message-Id: <20200108074502.10960-1-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Two final cleanups for the x86 startup code, one that helps the compiler
generate better code, by annotating a helper function with the 'const'
function attribute, and one that fixes the misalignment of the stack in
mixed mode.

There are no known issues regarding entering the 32-bit firmware from the
64-bit kernel with the stack misaligned, and the 32-bit kernel does so all
the time, but it is better to comply with the UEFI spec.

Ard Biesheuvel (2):
  efi/libstub/x86: use const attribute for efi_is_64bit()
  efi/libstub/x86: use mandatory 16-byte stack alignment in mixed mode

 arch/x86/boot/compressed/eboot.c        | 14 +++---
 arch/x86/boot/compressed/efi_thunk_64.S | 46 ++++++--------------
 arch/x86/boot/compressed/head_64.S      |  7 ++-
 arch/x86/include/asm/efi.h              |  2 +-
 4 files changed, 23 insertions(+), 46 deletions(-)

-- 
2.20.1

