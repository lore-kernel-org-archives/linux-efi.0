From: "Baicar, Tyler" <tbaicar@codeaurora.org>
Subject: Re: [PATCH V15 03/11] cper: add timestamp print to CPER status
 printing
Date: Fri, 21 Apr 2017 12:08:43 -0600
Message-ID: <a20143dc-8daa-102b-d929-4d96f73353e3@codeaurora.org>
References: <1492556723-9189-1-git-send-email-tbaicar@codeaurora.org>
 <1492556723-9189-4-git-send-email-tbaicar@codeaurora.org>
 <20170421122150.76cce2cfrt767glv@pd.tnic>
 <35cc4ae0-e8fa-fd3a-5d7f-243ed2e82ea0@codeaurora.org>
 <20170421172603.4574wonnm5tgvbcn@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <20170421172603.4574wonnm5tgvbcn@pd.tnic>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Borislav Petkov <bp@alien8.de>
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, rafael@kernel.org, zjzhang@codeaurora.org, linux@armlinux.org.uk, gengdongjiu@huawei.com, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, labbott@redhat.com, lenb@kernel.org, harba@codeaurora.org, john.garry@huawei.com, marc.zyngier@arm.com, punit.agrawal@arm.com, rostedt@goodmis.org, nkaje@codeaurora.org, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, tony.luck@intel.com, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.guo@linaro.org, joe@perches.com, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com, shiju.jose@huawe
List-Id: linux-efi@vger.kernel.org

T24gNC8yMS8yMDE3IDExOjI2IEFNLCBCb3Jpc2xhdiBQZXRrb3Ygd3JvdGU6Cj4gT24gRnJpLCBB
cHIgMjEsIDIwMTcgYXQgMTA6MDQ6MzVBTSAtMDYwMCwgQmFpY2FyLCBUeWxlciB3cm90ZToKPj4g
VGhpcyBpcyBiYXNpY2FsbHkgd2hhdCBJIGFscmVhZHkgaGFkIGluIHYxNC4uLnlvdSBhc2tlZCB0
byBtb3ZlIGl0IGludG8gYQo+PiBkaWZmZXJlbnQgaWYtc3RhdGVtZW50PyBodHRwczovL2xrbWwu
b3JnL2xrbWwvMjAxNy80LzEyLzM5Nwo+IFdlbGwsIGNsZWFybHkgSSd2ZSBiZWVuIHNtb2tpbmcg
c29tZSBuYXN0eSBwb3RlbnQgc2gqdC4gOi1cCj4KPiAvbWUgZ29lcyBhbmQgbG9va3MgYXQgdGhl
IHNwZWM6Cj4KPiAiQml0IDAg4oCTIFRpbWVzdGFtcCBpcyBwcmVjaXNlIGlmIHRoaXMgYml0IGlz
IHNldCBhbmQgY29ycmVsYXRlcyB0byB0aGUKPiB0aW1lIG9mIHRoZSBlcnJvciBldmVudC4iCj4K
PiBTbyB3aHkgYXJlIHdlIGV2ZW4gcHJpbnRpbmcgdGhlIHRpbWVzdGFtcCB3aGVuICFwcmVjaXNl
Pwo+Cj4gSU9XLCBJIHRoaW5rIHdlIHNob3VsZCBkbzoKPgo+IAlpZiAoISh0aW1lc3RhbXBbM10g
JiAweDEpKQo+IAkJcHJpbnRrKCIlc3RpbWVzdGFtcCBpbXByZWNpc2VcbiIsIHBmeCk7Cj4gCWVs
c2Ugewo+IAkJc2VjID0gLi4KPiAJCW1pbiA9IC4uLgo+Cj4gCQkuLi4KPiAJfQo+Cj4gYW5kIHBy
aW50IHRoZSBhY3R1YWwgdmFsdWVzIG9ubHkgd2hlbiB0aGUgdGltZXN0YW1wIGlzIHByZWNpc2Uu
Cj4gT3RoZXJ3aXNlIGl0IGhhcyAqc29tZSogdmFsdWVzIHdoaWNoIGNvdWxkIGp1c3QgYXMgd2Vs
bCBiZSBjb21wbGV0ZWx5Cj4gcmFuZG9tLiBBbmQgaXQncyBub3QgbGlrZSB3ZSdyZSByZXBvcnRp
bmcgdGhlIGVycm9yIHRvbW9ycm93IC0gaXQgaXMKPiBtb3N0bHkgYSBjb3VwbGUgb2Ygc2Vjb25k
cyBmcm9tIGxvZ2dpbmcgdG8gdGhlIGZ3IHB1c2hpbmcgaXQgb3V0Li4uClRoZSB0aW1lc3RhbXAg
bWF5IHN0aWxsIGJlIHVzZWZ1bCB3aGVuIGl0IGlzIGltcHJlY2lzZS4gSW4gdGhlIHBvbGxpbmcg
CmNhc2UsIHlvdSBtYXkgb25seSBwb2xsIGV2ZXJ5IG1pbnV0ZSBvciBzbywgc28gdGhlIHRpbWUg
bWF5IGJlIHVzZWZ1bC4gCkFsc28sIEkgaW1hZ2luZSB0aGVyZSBjb3VsZCBiZSBpbnRlcnJ1cHQg
YmFzZWQgZXJyb3JzIGhhcHBlbmluZyBtdWNoIApmYXN0ZXIgdGhhbiB0aGUgRlcvT1MgaGFuZHNo
YWtlIGNhbiBoYXBwZW4uIE1heWJlIHdlIGNhbiBqdXN0IHVzZSB3aGF0IEkgCmhhZCBiZWZvcmUg
YnV0IGFsc28gc3BlY2lmeSBpbXByZWNpc2Ugc28gdGhhdCBpdCBpcyBjbGVhcjoKCiAgICAgICAg
IHByaW50aygiJXMlc3RzdGFtcDogJTAyZCUwMmQtJTAyZC0lMDJkICUwMmQ6JTAyZDolMDJkXG4i
LCBwZngsCiAgICAgICAgICAgICAodGltZXN0YW1wWzNdICYgMHgxID8gInByZWNpc2UgIiA6ICJp
bXByZWNpc2UgIiksCiAgICAgICAgICAgICAgY2VudHVyeSwgeWVhciwgbW9uLCBkYXksIGhvdXIs
IG1pbiwgc2VjKTsKClRoYW5rcywKVHlsZXIKCi0tIApRdWFsY29tbSBEYXRhY2VudGVyIFRlY2hu
b2xvZ2llcywgSW5jLiBhcyBhbiBhZmZpbGlhdGUgb2YgUXVhbGNvbW0gVGVjaG5vbG9naWVzLCBJ
bmMuClF1YWxjb21tIFRlY2hub2xvZ2llcywgSW5jLiBpcyBhIG1lbWJlciBvZiB0aGUgQ29kZSBB
dXJvcmEgRm9ydW0sCmEgTGludXggRm91bmRhdGlvbiBDb2xsYWJvcmF0aXZlIFByb2plY3QuCgpf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFp
bGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5j
b2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
