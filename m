Return-Path: <SRS0=ZXfq=5O=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8A8DC43331
	for <linux-efi@archiver.kernel.org>; Sun, 29 Mar 2020 07:47:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8E7F2076A
	for <linux-efi@archiver.kernel.org>; Sun, 29 Mar 2020 07:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585468035;
	bh=tUZz/8kwazEFayPesO2OBRzJaSudo0imrzfy8nRRH5o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=QfB7ewXI90GrHLK6/NdNvY51UMNOe2B03enhy+5vK/fmjdnN8+GPqznAyKZEWujq2
	 A4unk7XjQ2bgBFSB2PSZ4s6hLRRTgsUJaA+wA71Xw5kJKVJVA/xVCRGtpyHBQJEipz
	 n5f9NzsZhnK6rGr1sZMHiZjAVzHsTeiLF2pK11ME=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgC2HrP (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Sun, 29 Mar 2020 03:47:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:52802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726342AbgC2HrP (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Sun, 29 Mar 2020 03:47:15 -0400
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC1AF20659
        for <linux-efi@vger.kernel.org>; Sun, 29 Mar 2020 07:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585468034;
        bh=tUZz/8kwazEFayPesO2OBRzJaSudo0imrzfy8nRRH5o=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=kJbAhfcAIhnPaubdTkKbeMD6Zksnc1geBToI6HVOenPCapjobGUy1t1ZJ+spwGQdQ
         up5B+k7nK0zps2i43DikOwbq5JBQzCbd/yPrX+Wc07p1JpSWBzlCPvxG1xsUAniCIF
         K9SIhLiMZzj0j41s7XJOJmpdeNnEE7VD3u3+x7dc=
Received: by mail-il1-f182.google.com with SMTP id x16so12791891ilp.12
        for <linux-efi@vger.kernel.org>; Sun, 29 Mar 2020 00:47:14 -0700 (PDT)
X-Gm-Message-State: ANhLgQ1MlET9Z+woGxyOXcDEOF3ZozQsGiduNHV9/v91T4z/rAGFKBAb
        AQAD+uRc+LoUsQYFPWAdTNXtXfwuf92dTVmwsYE=
X-Google-Smtp-Source: ADFU+vsfYforg4qh6b0rj22knwIybzmUgnWZUOhhOI/NggBrq5OoZFdg1qu9+6079eT+/joNZLEMc6phlxlH6qdA7FU=
X-Received: by 2002:a92:dcd1:: with SMTP id b17mr6479840ilr.80.1585468034175;
 Sun, 29 Mar 2020 00:47:14 -0700 (PDT)
MIME-Version: 1.0
References: <CAMj1kXFBB4RmokpM7nqm3jPQofDhfC89QuEurz6OwNPureVK8g@mail.gmail.com>
 <20200328160601.378299-1-nivedita@alum.mit.edu>
In-Reply-To: <20200328160601.378299-1-nivedita@alum.mit.edu>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sun, 29 Mar 2020 09:47:03 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHf11ZxfYk7Rc4xQd_EDQTwfU2w152=Ou8G4g9-JG7tCw@mail.gmail.com>
Message-ID: <CAMj1kXHf11ZxfYk7Rc4xQd_EDQTwfU2w152=Ou8G4g9-JG7tCw@mail.gmail.com>
Subject: Re: efi/gop: skip cur_mode in choose_mode_auto
To:     Arvind Sankar <nivedita@alum.mit.edu>
Cc:     linux-efi <linux-efi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Sat, 28 Mar 2020 at 17:06, Arvind Sankar <nivedita@alum.mit.edu> wrote:
>
> Ard, can you replace the previous version with v3? I skipped calling
> query_mode for cur_mode in choose_mode_res but forgot to do it for
> choose_mode_auto.
>

Done.
