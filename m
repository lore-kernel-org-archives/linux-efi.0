Return-Path: <SRS0=EqbT=6S=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF45CC28CBC
	for <linux-efi@archiver.kernel.org>; Mon,  4 May 2020 00:38:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C361120661
	for <linux-efi@archiver.kernel.org>; Mon,  4 May 2020 00:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgEDAiz (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Sun, 3 May 2020 20:38:55 -0400
Received: from mail-qv1-f52.google.com ([209.85.219.52]:41142 "EHLO
        mail-qv1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbgEDAiz (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Sun, 3 May 2020 20:38:55 -0400
Received: by mail-qv1-f52.google.com with SMTP id h6so7578503qvz.8
        for <linux-efi@vger.kernel.org>; Sun, 03 May 2020 17:38:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HKMFY6yI2D4GutblGx9dzUPhUWuCr1EL0c2GEIwMSOc=;
        b=TM5fKeGeoTSnyVzYBJFxiDNX4R2S2n02I3FGmVUvB3d7BEYQlUR0hKtXPlPZfN9QUe
         Ct/04jOldqe8k/8ITpfNJwKOaNCPwZnL8bTMnZ/xnhoywkR0ZC+NeeFffF8eOw1f8FQv
         MztmJJJMt4rhy6mx/oJEHI/cfOpDQCTdCsnfzblX+jB+hTNPgaviqha+wj422qF9pRVL
         7hV2t6WECyKo5t/KgjzR3spvSQRxPWM+jps+YPqK2M/eGvlzDkErvXEY60ziJD215N/3
         bGbGiHGN3kPqmDI8MPfZUZT6k8sUgUJ0WbKmDl1r2sJCmriRFB65x5GDpBUhCjNo5vdt
         PtYQ==
X-Gm-Message-State: AGi0PuZzgefyo0LyDxXB6J3gmGafFMHdcAWhIglFqF1QHX0klWUc12rT
        4K8SV1gNNibVT1VJhR1D1w4QFRtWcBM=
X-Google-Smtp-Source: APiQypLJT68sFjBNUZHTIuKK66xL2pjFpI/KSLDpPNMidgryI9aPQ6AgFVdfmfY6Gd0LQ1rs1rCr5Q==
X-Received: by 2002:a05:6214:b88:: with SMTP id fe8mr14420128qvb.250.1588552734170;
        Sun, 03 May 2020 17:38:54 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id t14sm9401506qtj.71.2020.05.03.17.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2020 17:38:53 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-efi@vger.kernel.org, linux@roeck-us.net
Subject: [PATCH 0/1] efi/libstub: Fix mixed mode boot on efi/next
Date:   Sun,  3 May 2020 20:38:51 -0400
Message-Id: <20200504003852.1096018-1-nivedita@alum.mit.edu>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200503154507.82880-1-ardb@kernel.org>
References: <20200503154507.82880-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

How about this instead -- just get rid of the macros on x86 as well if
mixed mode isn't enabled, and condition the generic definition on
CONFIG_EFI_MIXED?

Arvind Sankar (1):
  efi/libstub: Fix mixed mode boot issue after macro refactor

 arch/x86/include/asm/efi.h             | 17 +++++++++++++----
 drivers/firmware/efi/libstub/efistub.h | 14 ++++----------
 2 files changed, 17 insertions(+), 14 deletions(-)

-- 
2.26.2

