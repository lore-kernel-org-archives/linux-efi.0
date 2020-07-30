Return-Path: <SRS0=BN9I=BJ=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 817FBC433E1
	for <linux-efi@archiver.kernel.org>; Thu, 30 Jul 2020 02:25:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AD2D20FC3
	for <linux-efi@archiver.kernel.org>; Thu, 30 Jul 2020 02:25:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbgG3CZe (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 29 Jul 2020 22:25:34 -0400
Received: from namei.org ([65.99.196.166]:56448 "EHLO namei.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726367AbgG3CZe (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Wed, 29 Jul 2020 22:25:34 -0400
Received: from localhost (localhost [127.0.0.1])
        by namei.org (8.14.4/8.14.4) with ESMTP id 06U2PR12004264;
        Thu, 30 Jul 2020 02:25:27 GMT
Date:   Thu, 30 Jul 2020 12:25:27 +1000 (AEST)
From:   James Morris <jmorris@namei.org>
To:     Kees Cook <keescook@chromium.org>
cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Scott Branden <scott.branden@broadcom.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Takashi Iwai <tiwai@suse.de>, Jessica Yu <jeyu@kernel.org>,
        SeongJae Park <sjpark@amazon.de>,
        KP Singh <kpsingh@chromium.org>, linux-efi@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 07/17] fs/kernel_read_file: Switch buffer size arg to
 size_t
In-Reply-To: <20200729175845.1745471-8-keescook@chromium.org>
Message-ID: <alpine.LRH.2.21.2007301225180.3625@namei.org>
References: <20200729175845.1745471-1-keescook@chromium.org> <20200729175845.1745471-8-keescook@chromium.org>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Wed, 29 Jul 2020, Kees Cook wrote:

> In preparation for further refactoring of kernel_read_file*(), rename
> the "max_size" argument to the more accurate "buf_size", and correct
> its type to size_t. Add kerndoc to explain the specifics of how the
> arguments will be used. Note that with buf_size now size_t, it can no
> longer be negative (and was never called with a negative value). Adjust
> callers to use it as a "maximum size" when *buf is NULL.
> 
> Acked-by: Scott Branden <scott.branden@broadcom.com>
> Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>


Reviewed-by: James Morris <jamorris@linux.microsoft.com>


-- 
James Morris
<jmorris@namei.org>

