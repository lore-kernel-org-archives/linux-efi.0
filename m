Return-Path: <SRS0=32gl=BE=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08596C433E8
	for <linux-efi@archiver.kernel.org>; Sat, 25 Jul 2020 10:05:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D43B8206D7
	for <linux-efi@archiver.kernel.org>; Sat, 25 Jul 2020 10:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595671558;
	bh=piz0ZupBq64aY9qnc+ju0YrGEn/kb2ANG58ej2+W9xk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Vh1pfOL0VgyHrAlLbB1Pn4b2hyZ5TIUwPcPx9gmbIq+TbravzPRJPeU3C2Zu9PE/N
	 QRVxTnU1zYtvXKBe+AMWhbejq49mPw24FTS6vMd/6cZIIOqCqNBl3MxI0R8VgoICuL
	 m7+CwKMUOEbeKE8rUCTh3sLga/hVd4QM9LFhgoCA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgGYKF4 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Sat, 25 Jul 2020 06:05:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726572AbgGYKFz (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Sat, 25 Jul 2020 06:05:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05165206F6;
        Sat, 25 Jul 2020 10:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595671555;
        bh=piz0ZupBq64aY9qnc+ju0YrGEn/kb2ANG58ej2+W9xk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GiL8gX/oav4lnQZI8TKhjzDInRyaFC/B98ohwZPqYhEIt5ze8dCkTkgyxBDpL5aR5
         11ho/zrxMuCUTpoqD9nxxVeVVOIjCirIc4jMYjxt8XYuY2onfGWZ4Wp46khTUugFZl
         OslWuJrMlpAjx0izyeBxebJi08Vv35ftTZqX1Lus=
Date:   Sat, 25 Jul 2020 12:05:55 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Scott Branden <scott.branden@broadcom.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Jessica Yu <jeyu@kernel.org>, SeongJae Park <sjpark@amazon.de>,
        KP Singh <kpsingh@chromium.org>, linux-efi@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/19] Introduce partial kernel_read_file() support
Message-ID: <20200725100555.GA1073708@kroah.com>
References: <20200724213640.389191-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724213640.389191-1-keescook@chromium.org>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Fri, Jul 24, 2020 at 02:36:21PM -0700, Kees Cook wrote:
> v3:
> - add reviews/acks
> - add "IMA: Add support for file reads without contents" patch
> - trim CC list, in case that's why vger ignored v2
> v2: [missing from lkml archives! (CC list too long?) repeating changes here]
> - fix issues in firmware test suite
> - add firmware partial read patches
> - various bug fixes/cleanups
> v1: https://lore.kernel.org/lkml/20200717174309.1164575-1-keescook@chromium.org/
> 
> Hi,
> 
> Here's my tree for adding partial read support in kernel_read_file(),
> which fixes a number of issues along the way. It's got Scott's firmware
> and IMA patches ported and everything tests cleanly for me (even with
> CONFIG_IMA_APPRAISE=y).
> 
> I think the intention is for this to go via Greg's tree since Scott's
> driver code will depend on it?

I've applied the first 3 now, as I think I need some acks/reviewed-by
from the subsystem owners of the other patches before I can take them.

thanks,

greg k-h
