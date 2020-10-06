Return-Path: <SRS0=LEh4=DN=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55869C47427
	for <linux-efi@archiver.kernel.org>; Tue,  6 Oct 2020 17:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06F0220789
	for <linux-efi@archiver.kernel.org>; Tue,  6 Oct 2020 17:48:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbgJFRsj (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 6 Oct 2020 13:48:39 -0400
Received: from namei.org ([65.99.196.166]:33334 "EHLO namei.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725925AbgJFRsj (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Tue, 6 Oct 2020 13:48:39 -0400
X-Greylist: delayed 1831 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Oct 2020 13:48:38 EDT
Received: from localhost (localhost [127.0.0.1])
        by namei.org (8.14.4/8.14.4) with ESMTP id 096HHqvb007464;
        Tue, 6 Oct 2020 17:17:52 GMT
Date:   Wed, 7 Oct 2020 04:17:52 +1100 (AEDT)
From:   James Morris <jmorris@namei.org>
To:     Kees Cook <keescook@chromium.org>
cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Scott Branden <scott.branden@broadcom.com>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Jessica Yu <jeyu@kernel.org>, SeongJae Park <sjpark@amazon.de>,
        KP Singh <kpsingh@chromium.org>, linux-efi@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 01/16] fs/kernel_read_file: Remove FIRMWARE_PREALLOC_BUFFER
 enum
In-Reply-To: <20201002173828.2099543-2-keescook@chromium.org>
Message-ID: <alpine.LRH.2.21.2010070417400.18879@namei.org>
References: <20201002173828.2099543-1-keescook@chromium.org> <20201002173828.2099543-2-keescook@chromium.org>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Fri, 2 Oct 2020, Kees Cook wrote:

> FIRMWARE_PREALLOC_BUFFER is a "how", not a "what", and confuses the LSMs
> that are interested in filtering between types of things. The "how"
> should be an internal detail made uninteresting to the LSMs.
> 
> Fixes: a098ecd2fa7d ("firmware: support loading into a pre-allocated buffer")
> Fixes: fd90bc559bfb ("ima: based on policy verify firmware signatures (pre-allocated buffer)")
> Fixes: 4f0496d8ffa3 ("ima: based on policy warn about loading firmware (pre-allocated buffer)")
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> Acked-by: Scott Branden <scott.branden@broadcom.com>
> Cc: stable@vger.kernel.org


Reviewed-by: James Morris <jamorris@linux.microsoft.com>


-- 
James Morris
<jmorris@namei.org>

