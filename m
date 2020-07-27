Return-Path: <SRS0=3TSP=BG=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF739C433E3
	for <linux-efi@archiver.kernel.org>; Mon, 27 Jul 2020 13:35:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FD742075A
	for <linux-efi@archiver.kernel.org>; Mon, 27 Jul 2020 13:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595856903;
	bh=lsb8DwuA8VH82LyNkysVJs9u8cUS6ID7TdHH9rnuG9E=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:List-ID:From;
	b=eosI9NdT8OiJh4ckg7nRlxZtgy7x/FHrPOT8EtaFfkHiwKtd9ne42f/TVo7zX2toW
	 Ir5bfUWMaP1QGeuTUlRNtQlRvYl6S7tnBPD5oJA+tmoCn52KaDiPV5aZ+GVV7Tq2kC
	 ZPpxaMnHBY5B7oK62gnmOXCzpJFUMLWQt9CKqFug=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgG0NfD (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 27 Jul 2020 09:35:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbgG0NfD (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Mon, 27 Jul 2020 09:35:03 -0400
Received: from localhost.localdomain (pool-96-246-152-186.nycmny.fios.verizon.net [96.246.152.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C2A62083B;
        Mon, 27 Jul 2020 13:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595856902;
        bh=lsb8DwuA8VH82LyNkysVJs9u8cUS6ID7TdHH9rnuG9E=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UcMWrZGHef3xmGLz2KuVpjsTc4DIyfyoqvrtijkOjBGNC5pfY8sc+CNGTT4ppkVzm
         MuHrVj5LSOyuoI/u/aR8bJpLPmTQFiNAi1Zjjjq1/mHJJ0n6l9NoUF1sondP0D6+nF
         76pshYuPvhHtjLWejlPFBh082rkCH/MoxpsRrNl8=
Message-ID: <1595856900.4841.88.camel@kernel.org>
Subject: Re: [PATCH v3 04/19] fs/kernel_read_file: Remove
 FIRMWARE_PREALLOC_BUFFER enum
From:   Mimi Zohar <zohar@kernel.org>
To:     Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Scott Branden <scott.branden@broadcom.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Jessica Yu <jeyu@kernel.org>, SeongJae Park <sjpark@amazon.de>,
        KP Singh <kpsingh@chromium.org>, linux-efi@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 27 Jul 2020 09:35:00 -0400
In-Reply-To: <20200724213640.389191-5-keescook@chromium.org>
References: <20200724213640.389191-1-keescook@chromium.org>
         <20200724213640.389191-5-keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Fri, 2020-07-24 at 14:36 -0700, Kees Cook wrote:
> FIRMWARE_PREALLOC_BUFFER is a "how", not a "what", and confuses the LSMs
> that are interested in filtering between types of things. The "how"
> should be an internal detail made uninteresting to the LSMs.
> 
> Fixes: a098ecd2fa7d ("firmware: support loading into a pre-allocated buffer")
> Fixes: fd90bc559bfb ("ima: based on policy verify firmware signatures (pre-allocated buffer)")
> Fixes: 4f0496d8ffa3 ("ima: based on policy warn about loading firmware (pre-allocated buffer)")
> Cc: stable@vger.kernel.org
> Acked-by: Scott Branden <scott.branden@broadcom.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Thank you for updating the pre-allocated buffer comment.

Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
