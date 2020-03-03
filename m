Return-Path: <SRS0=iIKs=4U=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1337DC3F2D1
	for <linux-efi@archiver.kernel.org>; Tue,  3 Mar 2020 20:55:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5D9520842
	for <linux-efi@archiver.kernel.org>; Tue,  3 Mar 2020 20:55:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732084AbgCCUyt (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 3 Mar 2020 15:54:49 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:34076 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731387AbgCCUys (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Tue, 3 Mar 2020 15:54:48 -0500
Received: by mail-qt1-f195.google.com with SMTP id 59so2799248qtb.1;
        Tue, 03 Mar 2020 12:54:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M8leJle+RWUzuAGtnKfypyt7f42XpUo4qzg+KJegl9Y=;
        b=OjU4ncjqn6WeTUDjpv0a627yTlL2zxH8FzdFxLtVsA8sfXrtrQZphi/hk2Um+mMjwp
         gxSMRo/MMkheGKEJXvEKL05yacshgB4hgVEhSvioUTSDOfiiMqLOju6N4T5QjUNAsc8n
         uFsvFOdafgBKI8+NPVWsQTXQGT8zIk7CPfw78oeixdMzcdM8bHVKAnkr/KLv5hHx2l6D
         kBUcD3lXM6w/ISfTLQkkdSZMMRzwbtnGlZmxC+tpWfMOEuc5fGKmsit4kLHqfXirVx8M
         NvKZhl6zLq0N0JGIWAh3YsbUj+yYUtUeQuQU/8urdXNKi2QlvIGcUOco4yumCX9SZxVi
         F5mw==
X-Gm-Message-State: ANhLgQ1IrydboRBkfcZlLhEeVqGV6rsYwwJAIg7PG6Si6ZZEzp3MUGh3
        35lK+h8NscWI0ogzV5FlPVU+YcYfVD8=
X-Google-Smtp-Source: ADFU+vsjCOghGZ5RC1+941u05BCVRAFiwexK0akEf9XfqkcF3gBne9L9RsEdjzsMaWyclOJbli5zvw==
X-Received: by 2002:ac8:16b3:: with SMTP id r48mr2486825qtj.31.1583268886268;
        Tue, 03 Mar 2020 12:54:46 -0800 (PST)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id v12sm11473041qti.84.2020.03.03.12.54.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 12:54:45 -0800 (PST)
From:   Arvind Sankar <nivedita@alum.mit.edu>
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Ard Biesheuvel <ardb@kernel.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Bugfix + small cleanup to populate_p[mug]d
Date:   Tue,  3 Mar 2020 15:54:41 -0500
Message-Id: <20200303205445.3965393-1-nivedita@alum.mit.edu>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

The first patch fixes a bug in populate_pud, which results in the
requested mapping not being completely installed if the CPU does not
support GB pages.

The next three are small cleanups.

Thanks.

Arvind Sankar (4):
  x86/mm/pat: Handle no-GBPAGES case correctly in populate_pud
  x86/mm/pat: Ensure that populate_pud only handles one PUD
  x86/mm/pat: Propagate all errors out of populate_pud
  x86/mm/pat: Make num_pages consistent in populate_{pte,pud,pgd}

 arch/x86/include/asm/pgtable_types.h |  2 +-
 arch/x86/mm/pat/set_memory.c         | 74 +++++++++++++++++-----------
 2 files changed, 45 insertions(+), 31 deletions(-)

-- 
2.24.1

