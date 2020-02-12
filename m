Return-Path: <SRS0=/7jm=4A=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11B10C2BA83
	for <linux-efi@archiver.kernel.org>; Wed, 12 Feb 2020 16:01:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA63520873
	for <linux-efi@archiver.kernel.org>; Wed, 12 Feb 2020 16:01:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e5py13qa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbgBLQBZ (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 12 Feb 2020 11:01:25 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38766 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727007AbgBLQBZ (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Wed, 12 Feb 2020 11:01:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581523284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HnKDCKwyuda4gW5Ivrg+jIsW4pfOis6x+0ZhUg+C7PU=;
        b=e5py13qafc6hLEQYCtMztywYXdF2jHL6DqC4nCKggYOEhzDn4/J8Bz9fAiEHhNNMvLEfJo
        Jmdx/xIby1zLzH8T37st5k5NqQQESrYmBXbZ5qj+37trIGD2UepRP04cvHCPa8WThyh1JP
        cZUJ0TEydrIdTbWxHqb0xhF/E1fBkB4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-c5nkZBysMaus_cy780aHZQ-1; Wed, 12 Feb 2020 11:01:20 -0500
X-MC-Unique: c5nkZBysMaus_cy780aHZQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F23CDBA3;
        Wed, 12 Feb 2020 16:01:19 +0000 (UTC)
Received: from redhat.com (dhcp-10-20-1-15.bss.redhat.com [10.20.1.15])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C8E195C1B0;
        Wed, 12 Feb 2020 16:01:17 +0000 (UTC)
Date:   Wed, 12 Feb 2020 11:01:16 -0500
From:   Peter Jones <pjones@redhat.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        lersek@redhat.com, leif@nuviainc.com, mjg59@google.com,
        agraf@csgraf.de, ilias.apalodimas@linaro.org, xypron.glpk@gmx.de,
        daniel.kiper@oracle.com
Subject: Re: [PATCH 2/2] efi/libstub: take noinitrd cmdline argument into
 account for devpath initrd
Message-ID: <20200212160116.3xypcgmtafj7fm47@redhat.com>
References: <20200206140352.6300-1-ardb@kernel.org>
 <20200206140352.6300-3-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200206140352.6300-3-ardb@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Thu, Feb 06, 2020 at 02:03:52PM +0000, Ard Biesheuvel wrote:
> One of the advantages of using what basically amounts to a callback
> interface into the bootloader for loading the initrd is that it provides
> a natural place for the bootloader or firmware to measure the initrd
> contents while they are being passed to the kernel.
> 
> Unfortunately, this is not a guarantee that the initrd will in fact be
> loaded and its /init invoked by the kernel, since the command line may
> contain the 'noinitrd' option, in which case the initrd is ignored, but
> this will not be reflected in the PCR that covers the initrd measurement.
> 
> This could be addressed by measuring the command line as well, and
> including that PCR in the attestation policy, but this locks down the
> command line completely, which may be too restrictive.

In practice I think we need to be measuring the command line anyway.  In
current existing deployments, we measure kernel and initramfs into PCR9,
and measure the kernel command line into PCR8 (both are reserved in the
TIS for OS use).  This allows users farther down the stack to choose
whether which things they seal against, based on their requirements.

> So let's take the noinitrd argument into account in the stub, too. This
> forces the PCR that covers the initrd to assume a different value when
> noinitrd is passed, allowing an attestation policy to disregard the
> command line if there is no need to take its measurement into account
> for other reasons.

I think we also need to log a capping EV_SEPARATOR event with an log entry
that says it's for noinitrd into PCR9, in order to prevent any
scenarios where an attacker prevents the normal initramfs from loading,
and then replays the events from a prior log in order to unseal secrets.

-- 
  Peter

