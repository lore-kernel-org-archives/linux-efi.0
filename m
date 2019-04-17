Return-Path: <SRS0=G8aV=ST=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54E02C282DA
	for <linux-efi@archiver.kernel.org>; Wed, 17 Apr 2019 17:57:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 309B120663
	for <linux-efi@archiver.kernel.org>; Wed, 17 Apr 2019 17:57:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732319AbfDQR5W convert rfc822-to-8bit (ORCPT
        <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 17 Apr 2019 13:57:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:40168 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726751AbfDQR5W (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Wed, 17 Apr 2019 13:57:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Apr 2019 10:57:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,362,1549958400"; 
   d="scan'208";a="162770592"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by fmsmga004.fm.intel.com with ESMTP; 17 Apr 2019 10:57:21 -0700
Received: from orsmsx112.amr.corp.intel.com (10.22.240.13) by
 ORSMSX108.amr.corp.intel.com (10.22.240.6) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Wed, 17 Apr 2019 10:57:21 -0700
Received: from orsmsx114.amr.corp.intel.com ([169.254.8.50]) by
 ORSMSX112.amr.corp.intel.com ([169.254.3.109]) with mapi id 14.03.0415.000;
 Wed, 17 Apr 2019 10:57:21 -0700
From:   "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
To:     Dave Young <dyoung@redhat.com>,
        Junichi Nomura <j-nomura@ce.jp.nec.com>
CC:     Borislav Petkov <bp@alien8.de>,
        Chao Fan <fanc.fnst@cn.fujitsu.com>,
        Baoquan He <bhe@redhat.com>, Kairui Song <kasong@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: RE: kexec crash on OVMF i386 + x86_64 kernel (Re: [PATCH v4]
 x86/boot: Use efi_setup_data for searching RSDP on kexec-ed kernel)
Thread-Topic: kexec crash on OVMF i386 + x86_64 kernel (Re: [PATCH v4]
 x86/boot: Use efi_setup_data for searching RSDP on kexec-ed kernel)
Thread-Index: AQHU9NyJk5MjJ378I0KIPA24f/91u6ZAo6ng
Date:   Wed, 17 Apr 2019 17:57:20 +0000
Message-ID:
 <FFF73D592F13FD46B8700F0A279B802F48AFF5CF@ORSMSX114.amr.corp.intel.com>
References: <20190412025416.GA11070@jeru.linux.bs1.fc.nec.co.jp>
 <20190412084956.GC19808@zn.tnic> <20190412133528.GD19808@zn.tnic>
 <cc2c1dbe-4fb3-fb7d-0540-c04734fc15cb@ce.jp.nec.com>
 <20190415090717.GA29317@zn.tnic> <20190415102525.GB29317@zn.tnic>
 <23309b73-d135-a207-564b-6003cee39184@ce.jp.nec.com>
 <4dbbbb4b-7af9-bd98-b567-890407a15cd1@ce.jp.nec.com>
 <20190416094554.GF27892@zn.tnic>
 <befd6560-f41a-b142-a839-aaab861dee5a@ce.jp.nec.com>
 <20190417051418.GC8411@dhcp-128-65.nay.redhat.com>
In-Reply-To: <20190417051418.GC8411@dhcp-128-65.nay.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiOTViZjA1NzEtNDVlOC00YWM1LTliZTYtNDQxYjE4YzhhODlmIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiY0RnXC94Zlg5RHZqS3RjYThncHIzODNXSW1DZHB4WlB4SmdRaUNMbmFCdFA2alI2SjhubWFRTGc1eVk4MDZRZGgifQ==
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
Message-ID: <20190417175720.mi2cPUVzHSsKSINEHw4ThKuIXExW5fuWHXEScpBOjq4@z>

> Added efi people.
> 
> I remember previously Sai did some efi32 tests for kexec, but I'm not sure if he
> tested EFI32 + 64bit kernel.
> 
> Kexec status is not certain because I'm not sure anyone tesed and reported
> issues for that.

No.. I didn't test kexec on EFI32 + 64bit kernel and I also haven't tested kexec'ing from 
kexec'd kernel.

Regards,
Sai
