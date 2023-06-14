Return-Path: <linux-efi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 406B2EB64DB
	for <linux-efi@archiver.kernel.org>; Wed, 14 Jun 2023 07:14:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242198AbjFNHO0 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243149AbjFNHOP (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Wed, 14 Jun 2023 03:14:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B619C19B7;
        Wed, 14 Jun 2023 00:14:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47C8563832;
        Wed, 14 Jun 2023 07:14:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512A4C433C0;
        Wed, 14 Jun 2023 07:14:12 +0000 (UTC)
Date:   Wed, 14 Jun 2023 08:14:09 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     linux-doc@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>, linux-efi@vger.kernel.org
Subject: Re: [PATCH 3/5] arm64: Fix dangling references to Documentation/arm64
Message-ID: <ZIlowXPqMcghhm4o@arm.com>
References: <20230613094606.334687-1-corbet@lwn.net>
 <20230613094606.334687-4-corbet@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613094606.334687-4-corbet@lwn.net>
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Tue, Jun 13, 2023 at 03:46:04AM -0600, Jonathan Corbet wrote:
> The arm64 documentation has moved under Documentation/arch/; fix up
> references in the arm64 subtree to match.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: linux-efi@vger.kernel.org
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
