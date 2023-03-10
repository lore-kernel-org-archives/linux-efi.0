Return-Path: <linux-efi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84199C6FA99
	for <linux-efi@archiver.kernel.org>; Fri, 10 Mar 2023 12:50:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbjCJMue (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 10 Mar 2023 07:50:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCJMud (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Fri, 10 Mar 2023 07:50:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 856E0F6008
        for <linux-efi@vger.kernel.org>; Fri, 10 Mar 2023 04:50:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BC6761564
        for <linux-efi@vger.kernel.org>; Fri, 10 Mar 2023 12:50:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10BF2C433EF;
        Fri, 10 Mar 2023 12:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678452631;
        bh=cws60jdrbP6JEKchdJ3V3jCxLQZtztVV+SBGg08CbNA=;
        h=From:To:Cc:Subject:Date:From;
        b=WbfcS6imM12B0dlIAU0aJEu817vX10H7dzJklM3P2G6uIQ40g8Nj+01naiAdlXSmy
         R/szxZwlVplFG9R1VU5OaaBiimEx+ZgBgCIGXhCigb2SPzAIINmCpPmZtquwiK/9lg
         ede7daChkoxIWb8RfCDNuZi4kLP+KQVy13q6Fj0XgI8clsYezeU7ar8fUmTXguaPJ5
         N4xi6ZD7d1TChWcsJKYYcyBhslPleaUXjDFaijU+AM7nsSsgPfJtGfOgM08BJ0K9Ne
         78K0MIV/xroKJr9O8quNtI9IExJj95PqPxcaJDJ4J52QCmcy1xoSNHE8j+86fxcv8R
         JFAYUTJlyeGHw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Peter Jones <pjones@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 0/3] efi: arm64: Set NX compat flag where appropriate
Date:   Fri, 10 Mar 2023 13:50:23 +0100
Message-Id: <20230310125026.3390928-1-ardb@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1311; i=ardb@kernel.org; h=from:subject; bh=cws60jdrbP6JEKchdJ3V3jCxLQZtztVV+SBGg08CbNA=; b=owGbwMvMwCFmkMcZplerG8N4Wi2JIYVbvae/rta4Y3LS73/8akG3CxgsuVf/3ae0wSt3jfvPJ dZbb1zqKGVhEONgkBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABOZOIORocvTP12ucNGzOxv7 3/hUGuXsbFh5iHnup9oVKxc6sXfpVzP8lWG9EG3wsU5JP+Ni7mbeeSoP/bq2a316ptjisXX2b31 XDgA=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

PE/COFF images that can tolerate running under a strict W^X policy when
it comes to firmware provided allocations should indicate so, by setting
the associated bit in the PE/COFF header.

Today, this makes little difference, but going forward, restricted
policies regarding secure boot and measured boot (e.g., MS Secured-core)
may refuse to run such images altogether.

Given that the zboot and arm64 EFI stub implementations do not rely on
firmware provided mappings being writable and executable at the same
time, let's set this bit.

Note that a change landed in v6.3 where we no longer tolerate this
unless we remap the relocated kernel code read-only/executable
explicitly (patch #2)

Cc: Peter Jones <pjones@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: Kees Cook <keescook@chromium.org>

Ard Biesheuvel (3):
  efi/libstub: zboot: Mark zboot EFI application as NX compatible
  efi/libstub: arm64: Remap relocated image with strict permissions
  arm64: efi: Set NX compat flag in PE/COFF header

 arch/arm64/kernel/efi-header.S              | 2 +-
 drivers/firmware/efi/libstub/arm64-stub.c   | 1 +
 drivers/firmware/efi/libstub/zboot-header.S | 2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

-- 
2.39.2

