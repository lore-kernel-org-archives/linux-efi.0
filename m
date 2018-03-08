From: "Luck, Tony" <tony.luck@intel.com>
Subject: RE: [PATCH V2 2/3] efi: Introduce efi_rts_workqueue and some
 infrastructure to invoke all efi_runtime_services()
Date: Thu, 8 Mar 2018 17:05:44 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F7B392450@ORSMSX110.amr.corp.intel.com>
References: <1520292190-5027-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1520292190-5027-3-git-send-email-sai.praneeth.prakhya@intel.com>
 <20180307121047.GG23662@pd.tnic>
 <FFF73D592F13FD46B8700F0A279B802F2E5818E4@ORSMSX114.amr.corp.intel.com>
 <20180308140830.GE21166@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180308140830.GE21166@pd.tnic>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>, "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Chun-Yi Lee <jlee@suse.com>, Will Deacon <will.deacon@arm.com>, "Hansen, Dave" <dave.hansen@intel.com>, Mark Rutland <mark.rutland@arm.com>, Bhupesh Sharma <bhsharma@redhat.com>, "Neri, Ricardo" <ricardo.neri@intel.com>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Zijlstra, Peter" <peter.zijlstra@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-efi@vger.kernel.org

PiAiSGVuY2UsIHBzdG9yZSBjYWxscyBlZmlfcnVudGltZV9zZXJ2aWNlcygpIHdpdGhvdXQgdXNp
bmcgZWZpX3J0c193cSIgLQ0KPiB0aGF0IGRvZXNuJ3Qgc291bmQgbGlrZSBvcHRpbWFsIGRlc2ln
biB0byBtZS4gSSB3b3VsZCB0cnkgdG8gc2hvdmUgdGhlbQ0KPiBhbGwgdGhyb3VnaCB0aGUgd29y
a3F1ZXVlIC0gbm90IGhhdmUgZXhjZXB0aW9ucy4NCg0KQnV0IHBzdG9yZSBpcyB0cnlpbmcgdG8g
c2F2ZSB0aGUgbGFzdCBnYXNwIGR5aW5nIHdvcmRzIGZyb20gYSBrZXJuZWwgdGhhdA0KaGFzIHBh
bmljZWQuIFRoZXJlIGlzbid0IGFueSBndWFyYW50ZWUgdGhhdCB3b3JrIHF1ZXVlIHdpbGwgcnVu
LiBJIHRoaW5rDQppdCBpcyByZWFzb25hYmxlIHRvIGhhdmUgc29tZSBzcGVjaWFsIGNhc2UgdG8g
bWFrZSBzdXJlIHRoYXQgd2UgZG8gc2F2ZQ0KdGhlIGluZm9ybWF0aW9uLiAgQnV0IHBlcmhhcHMg
dGhhdCBzcGVjaWFsIGNhc2Ugc2hvdWxkIGJlIHRvIGhhdmUgcHN0b3JlDQpjYWxsIGRpcmVjdGx5
IGludG8gdGhlIGd1dHMgb2YgdGhlIEVGSSBjb2RlIGFuZCBub3Qgd29ycnkgYWJvdXQgYWxsIHRo
ZXNlDQpmYW5jeSBzd2l0Y2hlcyBvZiAibW0iIGV0Yy4NCg0KVGhpcyBpcyB0cnVlIGZvciB0aGUg
bWFjaGluZSBjaGVjayBsb2dnaW5nIGNhc2UgdG9vLCBidXQgdGhlIG1pdGlnYXRpb24gaXMNCnRo
YXQgdGhlIGRldGFpbHMgb2YgdGhlIGVycm9yIHBlcnNpc3QgaW4gdGhlIG1hY2hpbmUgY2hlY2sg
YmFua3MgYWNyb3NzIHRoZQ0KcmVzZXQgLi4uIHNvIGFsbCBpcyBub3QgbG9zdCBpZiB0aGUgd29y
ayBxdWV1ZSBpc24ndCBydW4gaGVyZS4NCg0KLVRvbnkNCg==
