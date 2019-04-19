Return-Path: <SRS0=c2yf=SV=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4068C282DA
	for <linux-efi@archiver.kernel.org>; Fri, 19 Apr 2019 18:38:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC8FB20449
	for <linux-efi@archiver.kernel.org>; Fri, 19 Apr 2019 18:38:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbfDSSi6 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 19 Apr 2019 14:38:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33944 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725859AbfDSSi6 (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Fri, 19 Apr 2019 14:38:58 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 234FA81E19;
        Fri, 19 Apr 2019 06:49:17 +0000 (UTC)
Received: from dhcp-128-65.nay.redhat.com (ovpn-12-76.pek2.redhat.com [10.72.12.76])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DE0335D70A;
        Fri, 19 Apr 2019 06:49:14 +0000 (UTC)
Date:   Fri, 19 Apr 2019 14:49:10 +0800
From:   Dave Young <dyoung@redhat.com>
To:     Matthew Garrett <mjg59@google.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-efi <linux-efi@vger.kernel.org>,
        "Lee, Chun-Yi" <jlee@suse.com>
Subject: Re: kexec reboot reset with efi_delete_dummy_variable
Message-ID: <20190419064910.GA6515@dhcp-128-65.nay.redhat.com>
References: <20190418034425.GA14950@dhcp-128-65.nay.redhat.com>
 <CACdnJus8ecXzVBQyfPSraRTapbh3PD_2YmfLH-a+5k-bmX9muQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACdnJus8ecXzVBQyfPSraRTapbh3PD_2YmfLH-a+5k-bmX9muQ@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Fri, 19 Apr 2019 06:49:17 +0000 (UTC)
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On 04/18/19 at 12:32pm, Matthew Garrett wrote:
> On Wed, Apr 17, 2019 at 8:44 PM Dave Young <dyoung@redhat.com> wrote:
> > So why we still need delete/cleanup the dummy var after entering virt
> > mode?  Am I missing something?
> 
> I can't think of any reason why you'd need to do this on kexec, but
> it's vital to do so in the real enter_virtual_mode() path. It should
> be safe to remove it from kexec_enter_virtual_mode(), but on the other
> hand it shouldn't be crashing, so I'd recommend figuring out what else
> is broken first rather than just deleting it.

Appreciate if you can elaborate a bit, I still do not understand why it
is vital.

About the kexec case, system just reset,  the test os runs with ovmf in
a kvm guest, Secure Boot enabled.  Do you have idea how to debug it?

Thanks
Dave
