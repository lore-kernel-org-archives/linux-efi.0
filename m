Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3046C433E6
	for <linux-efi@archiver.kernel.org>; Wed, 27 Jan 2021 22:16:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C57464DCC
	for <linux-efi@archiver.kernel.org>; Wed, 27 Jan 2021 22:16:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235711AbhA0WQo (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 27 Jan 2021 17:16:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236407AbhA0WQk (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Wed, 27 Jan 2021 17:16:40 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5248FC061573
        for <linux-efi@vger.kernel.org>; Wed, 27 Jan 2021 14:16:00 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id 70so2685460qkh.4
        for <linux-efi@vger.kernel.org>; Wed, 27 Jan 2021 14:16:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=nMvW9sCogvCQk3Z+FvTaolhNqJWAlRopE1dL8mD/EfM=;
        b=XabaZr51cxeVUNojdcIqjRe6bUepIDvJQtPM0wT7pGFP6YgPydkBjs45hRKKl6wAx2
         f+R5m/9IWnpxCMiLjlprYlhVQFrC+5CKHwcjdip7Vkt/KLjJKkrkGbxg61UieoIiUILx
         gmM3zOCAsPd+PQT5AzJHRnwSu4+GByKO4ea1z7p+wb0qhgrhCkIVp+0b0YjKYhyEsb6c
         rFt6j2h6OqzGbC1f5rCGLaZOUom6GerytFMyK7S8VH2Arad07pUUgx8vWq2M+gOQdQt9
         EJdwH76rsjIvforkattkvFzUHWRNXC15PDQDmrNzW8KVDodG6IGo5LGXLIFyvoKTijgS
         JBuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=nMvW9sCogvCQk3Z+FvTaolhNqJWAlRopE1dL8mD/EfM=;
        b=Du2BeYHUoTPZakzVPJtcTXe86eXJT5TQoGw7EKZWdCOmZCNOvQgO6rX+LeUGmk609T
         EGiwTCMoR9cbfiC6valKWxkQfSEb4u/IS/aSvwMozZuIigEQMDs7BZtvhFuSeZkMva4L
         LapXxOaZpK1/moqPPyrDL3KFdU+3uVWS/V65PkNmyEPwS7Aw04s/FAs0p+42xdJPHzCF
         4BkP4MxOlwS/UoG36hG/7ZaoIgG/5rcaEe+KQ5cgurj7L2GMpHf2VY48HL0AgeE2KTgk
         Y73vZPhFfisk6eQzvs5/DBnPE75Iy6JLMKyhWim+fGWPSKKjQqGwKz2VDEqKsy0k2gNa
         zfcg==
X-Gm-Message-State: AOAM532lw1WTXMse6Ws2MeyeEBk+aVNEeXmxTNQf6rT7rkZGZGxovQK0
        nH+7uDCcCPJO/pE2MA2edfiXlyk7QqkDfSrzWKs=
X-Google-Smtp-Source: ABdhPJz7J2G6u1AIImLhrSDhwzedx39UPabhVKQcdZxwaHSdva5MN+PnhrmVByfJP0/dWGSG5HSuKEXBRBBQU2+tB84=
Sender: "ndesaulniers via sendgmr" 
        <ndesaulniers@ndesaulniers1.mtv.corp.google.com>
X-Received: from ndesaulniers1.mtv.corp.google.com ([2620:15c:211:202:f693:9fff:fef4:4d25])
 (user=ndesaulniers job=sendgmr) by 2002:a0c:fe0b:: with SMTP id
 x11mr12660475qvr.18.1611785759532; Wed, 27 Jan 2021 14:15:59 -0800 (PST)
Date:   Wed, 27 Jan 2021 14:15:57 -0800
In-Reply-To: <20210120173800.1660730-13-jthierry@redhat.com>
Message-Id: <20210127221557.1119744-1-ndesaulniers@google.com>
Mime-Version: 1.0
References: <20210120173800.1660730-13-jthierry@redhat.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: Re: [RFC PATCH 12/17] gcc-plugins: objtool: Add plugin to detect
 switch table on arm64
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     jthierry@redhat.com
Cc:     ardb@kernel.org, broonie@kernel.org, catalin.marinas@arm.com,
        jpoimboe@redhat.com, keescook@chromium.org,
        linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, masahiroy@kernel.org,
        michal.lkml@markovi.net, peterz@infradead.org,
        raphael.gault@arm.com, will@kernel.org,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

> From: Raphael Gault <raphael.gault@arm.com>
> 
> This plugins comes into play before the final 2 RTL passes of GCC and
> detects switch-tables that are to be outputed in the ELF and writes
> information in an ".discard.switch_table_info" section which will be
> used by objtool.
> 
> Signed-off-by: Raphael Gault <raphael.gault@arm.com>
> [J.T.: Change section name to store switch table information,
>        Make plugin Kconfig be selected rather than opt-in by user,
>        Add a relocation in the switch_table_info that points to
>        the jump operation itself]
> Signed-off-by: Julien Thierry <jthierry@redhat.com>

Rather than tightly couple this feature to a particular toolchain via
plugin, it might be nice to consider what features could be spec'ed out
for toolchains to implement (perhaps via a -f flag).

Distributions (like Android, CrOS) wont be able to use such a feature as
is.
