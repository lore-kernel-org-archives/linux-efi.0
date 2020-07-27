Return-Path: <SRS0=3TSP=BG=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D1ECC433E3
	for <linux-efi@archiver.kernel.org>; Mon, 27 Jul 2020 10:49:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1F30206E7
	for <linux-efi@archiver.kernel.org>; Mon, 27 Jul 2020 10:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595846958;
	bh=zNfqzDInDnSp+fKCzpx3F6lQ3q4TBw0M7Av0QoXkGpo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:List-ID:From;
	b=r4dTNbgZGUlgpVyrDnnfq/LkO08gMR6GKgNxtgGYg5CeZOvXxGi8z1Fr8TKhGrlQz
	 y0X6IfW8fx9d9jrgExFBXfnuxjBBhbBwkMwZbmKDjUF2yJUFHZVaNp5vBbCPpkqo/y
	 w11ngha0jAtAMCNA1k/6bZ1kK0X8IckxfZYnZDeA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgG0KtO (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 27 Jul 2020 06:49:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbgG0KtO (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Mon, 27 Jul 2020 06:49:14 -0400
Received: from localhost.localdomain (pool-96-246-152-186.nycmny.fios.verizon.net [96.246.152.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7ED78206E7;
        Mon, 27 Jul 2020 10:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595846953;
        bh=zNfqzDInDnSp+fKCzpx3F6lQ3q4TBw0M7Av0QoXkGpo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lhClkxotlesTUV1UDov1RrY64xr/ppyKNwCO0sGj548usN3ExBpqNf1v73lO6qY2x
         gXrALj4a7FB2QB75LMyX17RGfKrjHGwIko0vBdXAOFq7H637gLacrQYgI1EPBcNl4F
         WQ3zl8FW26O60MLGh4f1gZbN6TKyE1zhYxL/dUMo=
Message-ID: <1595846951.4841.61.camel@kernel.org>
Subject: Re: [PATCH v3 11/19] LSM: Introduce kernel_post_load_data() hook
From:   Mimi Zohar <zohar@kernel.org>
To:     Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Scott Branden <scott.branden@broadcom.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Jessica Yu <jeyu@kernel.org>, SeongJae Park <sjpark@amazon.de>,
        KP Singh <kpsingh@chromium.org>, linux-efi@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 27 Jul 2020 06:49:11 -0400
In-Reply-To: <20200724213640.389191-12-keescook@chromium.org>
References: <20200724213640.389191-1-keescook@chromium.org>
         <20200724213640.389191-12-keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Fri, 2020-07-24 at 14:36 -0700, Kees Cook wrote:
> There are a few places in the kernel where LSMs would like to have
> visibility into the contents of a kernel buffer that has been loaded or
> read. While security_kernel_post_read_file() (which includes the
> buffer) exists as a pairing for security_kernel_read_file(), no such
> hook exists to pair with security_kernel_load_data().
> 
> Earlier proposals for just using security_kernel_post_read_file() with a
> NULL file argument were rejected (i.e. "file" should always be valid for
> the security_..._file hooks, but it appears at least one case was
> left in the kernel during earlier refactoring. (This will be fixed in
> a subsequent patch.)
> 
> Since not all cases of security_kernel_load_data() can have a single
> contiguous buffer made available to the LSM hook (e.g. kexec image
> segments are separately loaded), there needs to be a way for the LSM to
> reason about its expectations of the hook coverage. In order to handle
> this, add a "contents" argument to the "kernel_load_data" hook that
> indicates if the newly added "kernel_post_load_data" hook will be called
> with the full contents once loaded. That way, LSMs requiring full contents
> can choose to unilaterally reject "kernel_load_data" with contents=false
> (which is effectively the existing hook coverage), but when contents=true
> they can allow it and later evaluate the "kernel_post_load_data" hook
> once the buffer is loaded.
> 
> With this change, LSMs can gain coverage over non-file-backed data loads
> (e.g. init_module(2) and firmware userspace helper), which will happen
> in subsequent patches.
> 
> Additionally prepare IMA to start processing these cases.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

At least from an IMA perspective, the original
security_kernel_load_data() hook was defined in order to prevent
certain syscalls - init_module, kexec_load - and loading firmware via
sysfs.  The resulting error messages were generic.
  
Unlike security_kernel_load_data(), security_kernel_post_load_data()
is meant to be used, but without a file desciptor specific
information, like the filename associated with the buffer, is missing.
 Having the filename isn't actually necessary for verifying the
appended signature, but it is needed for auditing signature
verification failures and including in the IMA measurement list.

Mimi
