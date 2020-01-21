Return-Path: <SRS0=WPTa=3K=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71BA7C2D0CE
	for <linux-efi@archiver.kernel.org>; Tue, 21 Jan 2020 16:31:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D95522525
	for <linux-efi@archiver.kernel.org>; Tue, 21 Jan 2020 16:31:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgAUQbO (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 21 Jan 2020 11:31:14 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:56736 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbgAUQbN (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Tue, 21 Jan 2020 11:31:13 -0500
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1itwQq-00024m-HU; Tue, 21 Jan 2020 09:31:12 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1itwQl-0001Fp-NK; Tue, 21 Jan 2020 09:31:12 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Jean Delvare <jdelvare@suse.de>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dave Young <dyoung@redhat.com>,
        linux-efi <linux-efi@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        kexec@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
References: <20161202195416.58953-1-andriy.shevchenko@linux.intel.com>
        <20161202195416.58953-3-andriy.shevchenko@linux.intel.com>
        <20161215122856.7d24b7a8@endymion>
        <20161216023213.GA4505@dhcp-128-65.nay.redhat.com>
        <1481890738.9552.70.camel@linux.intel.com>
        <20161216143330.69e9c8ee@endymion>
        <20161217105721.GB6922@dhcp-128-65.nay.redhat.com>
        <20200120121927.GJ32742@smile.fi.intel.com>
        <87a76i9ksr.fsf@x220.int.ebiederm.org>
        <20200120224204.4e5cc0df@endymion>
        <CAHp75Veb02m3tU9tzZe912ZmX5mdaYkZ90DD67FVERJS15VsXw@mail.gmail.com>
        <20200121100359.6125498c@endymion>
Date:   Tue, 21 Jan 2020 10:29:35 -0600
In-Reply-To: <20200121100359.6125498c@endymion> (Jean Delvare's message of
        "Tue, 21 Jan 2020 10:03:59 +0100")
Message-ID: <87zheg93io.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1itwQl-0001Fp-NK;;;mid=<87zheg93io.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19A1vHjXVSUHLJX23KSD0vshxuGi0OSXWU=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v1 2/2] firmware: dmi_scan: Pass dmi_entry_point to kexec'ed kernel
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Jean Delvare <jdelvare@suse.de> writes:

> On Mon, 20 Jan 2020 23:55:43 +0200, Andy Shevchenko wrote:
>> On Mon, Jan 20, 2020 at 11:44 PM Jean Delvare <jdelvare@suse.de> wrote:
>> >
>> > On Mon, 20 Jan 2020 10:04:04 -0600, Eric W. Biederman wrote:  
>> > > Second.  I looked at your test results and they don't directly make
>> > > sense.  dmidecode bypasses the kernel completely or it did last time
>> > > I looked so I don't know why you would be using that to test if
>> > > something in the kernel is working.  
>> >
>> > That must have been long ago. A recent version of dmidecode (>= 3.0)
>> > running on a recent kernel  
>> > (>= d7f96f97c4031fa4ffdb7801f9aae23e96170a6f, v4.2) will read the DMI  
>> > data from /sys/firmware/dmi/tables, so it is very much relying on the
>> > kernel doing the right thing. If not, it will still try to fallback to
>> > reading from /dev/mem directly on certain architectures. You can force
>> > that old method with --no-sysfs.
>> >
>> > Hope that helps,  
>> 
>> I don't understand how it possible can help for in-kernel code, like
>> DMI quirks in a drivers.
>
> OK, just ignore me then, probably I misunderstood the point made by
> Eric.

No.  I just haven't dived into this area of code in a long time.

It seems a little indirect to use dmidecode as the test to see if the
kernel has the pointer to the dmitables, but with the knowledge you
provided it seems like a perfectly valid test.

Eric

