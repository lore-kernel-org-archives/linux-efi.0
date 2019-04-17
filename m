Return-Path: <SRS0=G8aV=ST=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E41D7C282DC
	for <linux-efi@archiver.kernel.org>; Wed, 17 Apr 2019 17:22:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCEA5206BA
	for <linux-efi@archiver.kernel.org>; Wed, 17 Apr 2019 17:22:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732746AbfDQRWY (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 17 Apr 2019 13:22:24 -0400
Received: from mga18.intel.com ([134.134.136.126]:24574 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729641AbfDQRWY (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Wed, 17 Apr 2019 13:22:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Apr 2019 10:22:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,362,1549958400"; 
   d="scan'208";a="338405920"
Received: from orsmsx110.amr.corp.intel.com ([10.22.240.8])
  by fmsmga006.fm.intel.com with ESMTP; 17 Apr 2019 10:22:22 -0700
Received: from orsmsx114.amr.corp.intel.com ([169.254.8.50]) by
 ORSMSX110.amr.corp.intel.com ([169.254.10.28]) with mapi id 14.03.0415.000;
 Wed, 17 Apr 2019 10:22:22 -0700
From:   "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "H. Peter Anvin" <hpa@zytor.com>
CC:     Daniel Drake <drake@endlessm.com>, Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jian-Hong Pan <jian-hong@endlessm.com>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        linux-efi <linux-efi@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "linux-tip-commits@vger.kernel.org" 
        <linux-tip-commits@vger.kernel.org>,
        Endless Linux Upstreaming Team <linux@endlessm.com>
Subject: RE: EFI reboot vs. ACPI reboot (was: Re: [tip:x86/urgent]
 x86/reboot, efi: Use EFI reboot for Acer TravelMate X514-51T)
Thread-Topic: EFI reboot vs. ACPI reboot (was: Re: [tip:x86/urgent]
 x86/reboot, efi: Use EFI reboot for Acer TravelMate X514-51T)
Thread-Index: AQHU9TSRArd186GgH0GGiik0q/taeaZAlBFg
Date:   Wed, 17 Apr 2019 17:22:21 +0000
Message-ID:
 <FFF73D592F13FD46B8700F0A279B802F48AFEFF2@ORSMSX114.amr.corp.intel.com>
References: <20190412080152.3718-1-jian-hong@endlessm.com>
 <tip-0082517fa4bce073e7cf542633439f26538a14cc@git.kernel.org>
 <20190416082042.GA69717@gmail.com>
 <CAD8Lp44pQRYdw4cbfMt3uOSO23dzy_mWTt5T-Zjft08WWu_yUA@mail.gmail.com>
 <20190417061650.GA31060@gmail.com>
 <CAD8Lp45BLaoXF=RNcncqcTtNvaGHP72+a1CxcjoeBXDiw9TKbA@mail.gmail.com>
 <17516564-37AC-4F77-9C0D-0DD71F8045EA@zytor.com>
 <CAKv+Gu_jqoKiqq4ozcPwSxLmpuaWsFKy_xyYGhECLz+KLHOjOw@mail.gmail.com>
In-Reply-To: <CAKv+Gu_jqoKiqq4ozcPwSxLmpuaWsFKy_xyYGhECLz+KLHOjOw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNDdhYzJiMWMtNmRmOC00YmQxLTk4YmQtOGQ2OWQwNDYyMjQ5IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiNm1Mbmw0UjhSWEl5MEJuODU4RXA1RmdmSEMrRGkrS0dwMVd5eXhnczljRDJBRGZoaTBWYjFTXC9pNHBvcFFBR1wvIn0=
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
Message-ID: <20190417172221.nXXoOrDg625WFUGffJhJvhjZpDm7XfFJEqz5I6uVza8@z>

PiA+ID4+IFRoYXQgc2VlbXMgY291bnRlci1pbnR1aXRpdmUgdG8gbWU6IGlmIG5vIGZ1bGwgQUNQ
SSBoYXJkd2FyZSBpcw0KPiA+ID4+IGltcGxlbWVudGVkIHRoZW4gd2Ugc2hvdWxkIGFzc3VtZSBy
ZWR1Y2VkIEFDUEkgZnVuY3Rpb25hbGl0eSwgaS5lLg0KPiA+ID4+IGlmDQo+ID4gPnRoZQ0KPiA+
ID4+IEVGSSBydW50aW1lIGlzIG90aGVyd2lzZSBhdmFpbGFibGUgd2Ugc2hvdWxkIGRlZmF1bHQg
dG8gaXQuDQo+ID4gPg0KPiA+ID5JdCdzIGEgYml0IGNvbmZ1c2luZywgYnV0IG15IGxvb3NlIHVu
ZGVyc3RhbmRpbmcgaXMgdGhhdCBwcmV2aW91cw0KPiA+ID52ZXJzaW9ucyBvZiB0aGUgQUNQSSBz
cGVjIHJlcXVpcmVkIHN5c3RlbSBpbXBsZW1lbnRvcnMgdG8gaW1wbGVtZW50DQo+ID4gPnRoZSB3
aG9sZSB0aGluZzsgYnV0IHRoYXQncyBpbmNyZWFzaW5nbHkgaW1wcmFjdGljYWwgdG9kYXksIGUu
Zy4gd2l0aA0KPiA+ID5BUk0gc3lzdGVtcyBjb21pbmcgYWxvbmcsIHdoaWNoIGRvIG5vdCBnZWwg
d2VsbCB3aXRoIHNvbWUgb2YgdGhlDQo+ID4gPmhpc3RvcmljYWwgeDg2LXJvb3RlZCBkZXNpZ24g
YXNwZWN0cyB0aGF0IHNwaWxsZWQgb3ZlciBpbnRvIEFDUEkuIFRoZQ0KPiA+ID5WNSBzcGVjIGlu
dHJvZHVjZXMgcmVkdWNlZCBtb2RlIGFzIGFuIG9wdC1pbiBuZXcgZmVhdHVyZSwgYnV0IGZvcg0K
PiA+ID5jb21wYXRpYmlsaXR5IHdpdGggcHJlLVY1IGltcGxlbWVudGF0aW9ucyBpdCBuZWVkcyB0
byBjb25zaWRlciAiZnVsbA0KPiA+ID5oYXJkd2FyZSIgbW9kZSBhcyB0aGUgZGVmYXVsdC4NCj4g
PiA+DQo+ID4gPj4gRmVlbCBmcmVlIHRvIHNlbmQgYSBwYXRjaCB0aGF0IG1ha2VzIEVGSSByZWJv
b3QgdGhlIGRlZmF1bHQgb25lDQo+ID4gPj4gdW5kZXIgdGhlc2UgY2lyY3Vtc3RhbmNlcywNCj4g
PiA+DQo+ID4gPkp1c3QgdG8gY2hlY2ssIHlvdSBtZWFuOiBFRkkgcmVib290IChhbmQgc2h1dGRv
d24pIGJlY29tZSB0aGUgZGVmYXVsdA0KPiA+ID5tZXRob2RzIHdoZW4gdGhlIG1hY2hpbmUgaXMg
Ym9vdGVkIGluIEVGSSBtb2RlLCBhbmQgRUZJIHN0dWZmIGhhcyBub3QNCj4gPiA+YmVlbiBkaXNh
YmxlZCB3aXRoIGEga2VybmVsIHBhcmFtZXRlcj8NCj4gPiA+RXZlbiB3aGVuIHJ1bm5pbmcgaW4g
ZnVsbCBoYXJkd2FyZSBBQ1BJIG1vZGUuDQo+ID4gPg0KPiA+ID5UaGFua3MNCj4gPiA+RGFuaWVs
DQo+ID4NCj4gPiBUaGlzLCBJIGJlbGlldmUsIGlzIGtub3duIHRvIG5vdCB3b3JrLg0KPiANCj4g
SXQgZGVmaW5pdGVseSB1c2VkIHRvIGJlIHRoZSBjYXNlIHRoYXQgRUZJIHJlYm9vdCB3YXMgdW5y
ZWxpYWJsZSwgYnV0IEkgZG9uJ3Qga25vdw0KPiB0aGUgZGV0YWlscy4NCg0KU29ycnkhIEFyZC4N
CkkgZG9uJ3QgaGF2ZSB0aGUgZW5vdWdoIGhpc3RvcmljYWwga25vd2xlZGdlIHRvIHN0YXRlIHRo
YXQgRUZJIHJlYm9vdCBpcyB1bnJlbGlhYmxlIA0Kb24gbW9zdCBvZiB0aGUgeDg2IHN5c3RlbXMg
YnV0IEkgZGlkIGNvbWUgYWNyb3NzIHR3byBzeXN0ZW1zIHRoYXQgaGFkIGJ1Z2d5IGltcGxlbWVu
dGF0aW9uIA0Kb2YgRUZJIHJlYm9vdCBhbmQgaGVuY2UgSSBoYXZlIGFkZGVkIGNvZGUgdG8gZGVh
bCB3aXRoIEVGSSBydW50aW1lIHNlcnZpY2VzIHRoYXQgY2F1c2UgcGFnZSBmYXVsdHMuDQoNCkkg
d2lsbCBhc2sgYXJvdW5kIGludGVybmFsbHkgdG8gY2hlY2sgaWYgaXQgaXMgYSBnb29kIGlkZWEg
dG8gbWFrZSBFRkkgcmVib290IHRoZSBkZWZhdWx0IG1ldGhvZCANCndoZW4gdGhlIG1hY2hpbmUg
aXMgYm9vdGVkIGluIEVGSSBtb2RlLg0KDQo+IEkgaGF2ZSBhZGRlZCBTYWkgdG8gY2MsIGhlIG1h
eSBiZSBhYmxlIHRvIHByb3ZpZGUgYSBiaXQgbW9yZSBjb250ZXh0DQo+IGhlcmUsIHNpbmNlIGhl
IGFkZGVkIHRoZSBjb2RlIHRvIGRlYWwgd2l0aCBwYWdlIGZhdWx0cyBkdXJpbmcgRUZJIHJ1bnRp
bWUgc2VydmljZQ0KPiBpbnZvY2F0aW9ucyAod2hpY2ggd2FzIGluc3BpcmVkIGJ5IGEgRUZJIHJl
Ym9vdCBpc3N1ZSBJSVJDKS4gVGhhdCBmZWF0dXJlIG1heQ0KPiBoYXZlIGltcHJvdmVkIHRoZSBz
aXR1YXRpb24sIGJ1dCBJIGFtIG5vdCBjb25maWRlbnQgYXQgYWxsIHRoYXQgaXQgZml4ZXMgYWxs
DQo+IHN5c3RlbXMuDQoNCkkgYmVsaWV2ZSwgdGhlIGNvZGUgSSBhZGRlZCBzaG91bGQgaW1wcm92
ZSB0aGUgc2l0dWF0aW9uIGJ1dCBJIGFtIGhlc2l0YW50IHRvIHNheSB0aGF0IGl0IGZpeGVzIA0K
KmFsbCogdGhlIHN5c3RlbXMgYmVjYXVzZSB0aGUgY29kZSBhZGRyZXNzZXMgb25seSBvbmUgdHlw
ZSBvZiBidWcgbmFtZWx5IEVGSSBSZWJvb3QgYWNjZXNzaW5nIA0KaWxsZWdhbCBtZW1vcnkgYW5k
IEkgaGF2ZSBubyBpZGVhIGFib3V0IG90aGVyIGJ1Z2d5IGltcGxlbWVudGF0aW9ucy4NCg0KUmVn
YXJkcywNClNhaQ0K
