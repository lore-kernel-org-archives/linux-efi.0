Return-Path: <SRS0=4MSR=5F=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 293DAC4332D
	for <linux-efi@archiver.kernel.org>; Fri, 20 Mar 2020 19:25:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F21A92070A
	for <linux-efi@archiver.kernel.org>; Fri, 20 Mar 2020 19:25:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgCTTZ3 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 20 Mar 2020 15:25:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:11708 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726738AbgCTTZ3 (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Fri, 20 Mar 2020 15:25:29 -0400
IronPort-SDR: YBPDPdYwVKO7yF/oyyg7P1epCP2MtVI6kvtDmCk1IoiZSZRamM4fwjfslXYyC7UlkIA7K2nef9
 kH4kN9OlITBQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 12:25:28 -0700
IronPort-SDR: NZXMP46VphHgAClkm6jUIN4i9FLSdP3BvP2LRdBWzZtkb0WYigf4i+SbGrTexQrIydwmZeQJ29
 BYez0E2zyECw==
X-IronPort-AV: E=Sophos;i="5.72,285,1580803200"; 
   d="scan'208";a="280521575"
Received: from agluck-desk2.sc.intel.com (HELO agluck-desk2.amr.corp.intel.com) ([10.3.52.68])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 12:25:28 -0700
Date:   Fri, 20 Mar 2020 12:25:27 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        "Gao, Liming" <liming.gao@intel.com>,
        linux-efi <linux-efi@vger.kernel.org>
Subject: Re: [PATCH v6 0/2] Add capsule-pstore backend support
Message-ID: <20200320192527.GA31764@agluck-desk2.amr.corp.intel.com>
References: <20200312011312.70653-1-qiuxu.zhuo@intel.com>
 <CAKv+Gu9BvqZavV6XjfuacXXpabNCXLYEw-f=81fwX8hdL6Fn-A@mail.gmail.com>
 <d0a09900ca0341029980d351bbe2aecc@intel.com>
 <CAKv+Gu82OFMJk-jQKdvA0_Sgp_CCmvC1a63QYrY+Cc4Qjx3+Yw@mail.gmail.com>
 <abd0a0d1095f4bc4a8fc2be420a2478a@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abd0a0d1095f4bc4a8fc2be420a2478a@intel.com>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Thu, Mar 19, 2020 at 01:53:38AM -0700, Zhuo, Qiuxu wrote:
> > From: linux-efi-owner@vger.kernel.org <linux-efi-owner@vger.kernel.org> On> Behalf Of Ard Biesheuvel
> > ...
> > > The following commit on the tip tree removes the variables 'config_table' from the efi structure.
> > >
> > >     9cd437ac0ef4 ("efi/x86: Make fw_vendor, config_table and runtime sysfs nodes x86 specific")
> > >
> > > But the external driver "capsule-pstore.ko" needs to access  'config_table' and 'nr_tables' to go through the configuration table to extract  crash capsules.
> > >
> > > Adding 'config_table' and 'nr_tables' back to the efi structure looks like not a good way.
> > > Do you have any  suggestion on how to export 'config_table' and 'nr_tables' variables for the external driver "capsule-pstore.ko"?
> > >
> > 
> > I will get back to you on monday about this. In any case, this will have to wait until v5.8
> 
> OK. Thanks!

Would it be acceptable to take the first half of Qiuxu's
function efi_capsule_table_get() and move it into the
generic efi code naming it something like: "efi_get_table_by_guid()"?
Then EXPORT_GPL that function?

-Tony
