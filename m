Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7F58C43460
	for <linux-efi@archiver.kernel.org>; Mon, 12 Apr 2021 01:14:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B19CB6120C
	for <linux-efi@archiver.kernel.org>; Mon, 12 Apr 2021 01:14:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236249AbhDLBOS (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Sun, 11 Apr 2021 21:14:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38670 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236130AbhDLBOS (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Sun, 11 Apr 2021 21:14:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618190040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EpGUBNlUjaSXjVPlfPzmm9xzDu1TJ2gxcyEpgmYKrVw=;
        b=Z+qRvh4XKCMkh9Q8K/EdvEF8akp2tb5N9vsuwFGULQkUUeIBygHS1LHnEEFDmqztoG7cVq
        mykK2Ez0UQ+bfKSKFeldP7GWB06xJ1YvuTjnckcJ1RM5igAa/YG5u3qq2LhH6oOBjOyAN1
        39vF6ej/lQq/DYlpN2y83OTJIEn7xUo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-r-22rNMiPPKYO7hR3mRLgA-1; Sun, 11 Apr 2021 21:13:56 -0400
X-MC-Unique: r-22rNMiPPKYO7hR3mRLgA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D7407107ACC7;
        Mon, 12 Apr 2021 01:13:54 +0000 (UTC)
Received: from localhost (ovpn-13-33.pek2.redhat.com [10.72.13.33])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 00F3A13488;
        Mon, 12 Apr 2021 01:13:49 +0000 (UTC)
Date:   Mon, 12 Apr 2021 09:13:47 +0800
From:   Baoquan He <bhe@redhat.com>
To:     "H. Peter Anvin" <hpa@zytor.com>
Cc:     Lianbo Jiang <lijiang@redhat.com>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        x86@kernel.org, ardb@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dvhart@infradead.org,
        andy@infradead.org, kexec@lists.infradead.org, dyoung@redhat.com
Subject: Re: [PATCH] x86/efi: Do not release sub-1MB memory regions when the
 crashkernel option is specified
Message-ID: <20210412011347.GA4282@MiWiFi-R3L-srv>
References: <20210407140316.30210-1-lijiang@redhat.com>
 <D7D32C89-4F99-434A-B7AF-7BEBDA494172@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D7D32C89-4F99-434A-B7AF-7BEBDA494172@zytor.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On 04/09/21 at 07:59pm, H. Peter Anvin wrote:
> Why don't we do this unconditionally? At the very best we gain half a megabyte of memory (except the trampoline, which has to live there, but it is only a few kilobytes.)

This is a great suggestion, thanks. I think we can fix it in this way to
make code simpler. Then the specific caring of real mode in
efi_free_boot_services() can be removed too.

Thanks
Baoquan

