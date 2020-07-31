Return-Path: <SRS0=v2TQ=BK=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3177BC433DF
	for <linux-efi@archiver.kernel.org>; Fri, 31 Jul 2020 23:09:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08D27206DA
	for <linux-efi@archiver.kernel.org>; Fri, 31 Jul 2020 23:09:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="fsdMY+h/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgGaXJi (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 31 Jul 2020 19:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727819AbgGaXIn (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Fri, 31 Jul 2020 19:08:43 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72573C0617A3
        for <linux-efi@vger.kernel.org>; Fri, 31 Jul 2020 16:08:41 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id k13so10284331plk.13
        for <linux-efi@vger.kernel.org>; Fri, 31 Jul 2020 16:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KU7M7UNmTUanucRcVkgs3oof+flMLCjuo6z/HYA95R0=;
        b=fsdMY+h/HCrYg4s8js10KsjHgwZ/i2Vg6ElsNO+/5Zg2zIx4wvLEGL4/ETWMpuY8J2
         o+9UZBPQ7ltcKYO+s4x4Ikr8sgtWBgda8uqQnEdYp395MQkyy9U4jdZbNXuXAWEcZT52
         2LAHpspS3nzF4NKUhFVimmKrwzLeIv271myqM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KU7M7UNmTUanucRcVkgs3oof+flMLCjuo6z/HYA95R0=;
        b=LHVLnW3UJcOhDM0z9thvBW8ZU9SA3cd7OcrjU59FforgtL4kgSNIExUfE4/7UAB05/
         CS9aRFle1Zqtlx/HNIS2TYri1vOB8G1HdCu4udvpEBUGSBD3uD8AmbdwXzX5r8A7Xv0a
         YJUtaH9q8J31tS8vC9S7jFavzifSlTL61zYVC35J9jjedN8SFxRnOGZtxW0m1PSJgN6s
         tFdtY+9gwfVd4oI4JZN0178QwpSMPg0HYkUxYSBz9XQMVESreL3zOh6v7w/Wb8UTd4cg
         FnEm3w9qtG7mPq9KYHhBvcn7TBaESfNIbN4xZpiALix/vMdJClDw0vd0NhfFWy+dBviK
         h3Sg==
X-Gm-Message-State: AOAM532zhY1YT3frXOUgR62BXg6q3A3F9nopl5WSGKraDqPI/Y/CSFiZ
        oEAqb70LTXolRNUIqZT62M2OsQ==
X-Google-Smtp-Source: ABdhPJzKgSd5o5SkMdibqlFZcnSauPEvdVFKBx4sb7CWulX3P8bH0S9YNVBj9d8bmnzdlj8aFKQVbQ==
X-Received: by 2002:a17:902:221:: with SMTP id 30mr5688593plc.222.1596236921012;
        Fri, 31 Jul 2020 16:08:41 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 17sm9984876pjl.30.2020.07.31.16.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2020 16:08:36 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>, Marco Elver <elver@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Peter Collingbourne <pcc@google.com>,
        James Morse <james.morse@arm.com>,
        Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, x86@kernel.org,
        clang-built-linux@googlegroups.com, linux-arch@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 10/36] vmlinux.lds.h: Avoid KASAN and KCSAN's unwanted sections
Date:   Fri, 31 Jul 2020 16:07:54 -0700
Message-Id: <20200731230820.1742553-11-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200731230820.1742553-1-keescook@chromium.org>
References: <20200731230820.1742553-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

KASAN (-fsanitize=kernel-address) and KCSAN (-fsanitize=thread)
produce unwanted[1] .eh_frame and .init_array.* sections. Add them to
COMMON_DISCARDS, except with CONFIG_CONSTRUCTORS, which wants to keep
.init_array.* sections.

[1] https://bugs.llvm.org/show_bug.cgi?id=46478

Tested-by: Marco Elver <elver@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/asm-generic/vmlinux.lds.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 22985cf02130..f236cf0fa779 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -930,7 +930,27 @@
 	EXIT_DATA
 #endif
 
+/*
+ * Clang's -fsanitize=kernel-address and -fsanitize=thread produce
+ * unwanted sections (.eh_frame and .init_array.*), but
+ * CONFIG_CONSTRUCTORS wants to keep any .init_array.* sections.
+ * https://bugs.llvm.org/show_bug.cgi?id=46478
+ */
+#if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KCSAN)
+# ifdef CONFIG_CONSTRUCTORS
+#  define SANITIZER_DISCARDS						\
+	*(.eh_frame)
+# else
+#  define SANITIZER_DISCARDS						\
+	*(.init_array) *(.init_array.*)					\
+	*(.eh_frame)
+# endif
+#else
+# define SANITIZER_DISCARDS
+#endif
+
 #define COMMON_DISCARDS							\
+	SANITIZER_DISCARDS						\
 	*(.discard)							\
 	*(.discard.*)							\
 	*(.modinfo)							\
-- 
2.25.1

