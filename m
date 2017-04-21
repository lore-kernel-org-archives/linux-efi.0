From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH V15 03/11] cper: add timestamp print to CPER status
 printing
Date: Fri, 21 Apr 2017 19:26:03 +0200
Message-ID: <20170421172603.4574wonnm5tgvbcn@pd.tnic>
References: <1492556723-9189-1-git-send-email-tbaicar@codeaurora.org>
 <1492556723-9189-4-git-send-email-tbaicar@codeaurora.org>
 <20170421122150.76cce2cfrt767glv@pd.tnic>
 <35cc4ae0-e8fa-fd3a-5d7f-243ed2e82ea0@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Content-Disposition: inline
In-Reply-To: <35cc4ae0-e8fa-fd3a-5d7f-243ed2e82ea0@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "Baicar, Tyler" <tbaicar@codeaurora.org>
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, rafael@kernel.org, zjzhang@codeaurora.org, linux@armlinux.org.uk, gengdongjiu@huawei.com, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, labbott@redhat.com, lenb@kernel.org, harba@codeaurora.org, john.garry@huawei.com, marc.zyngier@arm.com, punit.agrawal@arm.com, rostedt@goodmis.org, nkaje@codeaurora.org, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, devel@acpica.org, tony.luck@intel.com, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.guo@linaro.org, joe@perches.com, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com
List-Id: linux-efi@vger.kernel.org

T24gRnJpLCBBcHIgMjEsIDIwMTcgYXQgMTA6MDQ6MzVBTSAtMDYwMCwgQmFpY2FyLCBUeWxlciB3
cm90ZToKPiBUaGlzIGlzIGJhc2ljYWxseSB3aGF0IEkgYWxyZWFkeSBoYWQgaW4gdjE0Li4ueW91
IGFza2VkIHRvIG1vdmUgaXQgaW50byBhCj4gZGlmZmVyZW50IGlmLXN0YXRlbWVudD8gaHR0cHM6
Ly9sa21sLm9yZy9sa21sLzIwMTcvNC8xMi8zOTcKCldlbGwsIGNsZWFybHkgSSd2ZSBiZWVuIHNt
b2tpbmcgc29tZSBuYXN0eSBwb3RlbnQgc2gqdC4gOi1cCgovbWUgZ29lcyBhbmQgbG9va3MgYXQg
dGhlIHNwZWM6CgoiQml0IDAg4oCTIFRpbWVzdGFtcCBpcyBwcmVjaXNlIGlmIHRoaXMgYml0IGlz
IHNldCBhbmQgY29ycmVsYXRlcyB0byB0aGUKdGltZSBvZiB0aGUgZXJyb3IgZXZlbnQuIgoKU28g
d2h5IGFyZSB3ZSBldmVuIHByaW50aW5nIHRoZSB0aW1lc3RhbXAgd2hlbiAhcHJlY2lzZT8KCklP
VywgSSB0aGluayB3ZSBzaG91bGQgZG86CgoJaWYgKCEodGltZXN0YW1wWzNdICYgMHgxKSkKCQlw
cmludGsoIiVzdGltZXN0YW1wIGltcHJlY2lzZVxuIiwgcGZ4KTsKCWVsc2UgewoJCXNlYyA9IC4u
CgkJbWluID0gLi4uCgoJCS4uLgoJfQoKYW5kIHByaW50IHRoZSBhY3R1YWwgdmFsdWVzIG9ubHkg
d2hlbiB0aGUgdGltZXN0YW1wIGlzIHByZWNpc2UuCk90aGVyd2lzZSBpdCBoYXMgKnNvbWUqIHZh
bHVlcyB3aGljaCBjb3VsZCBqdXN0IGFzIHdlbGwgYmUgY29tcGxldGVseQpyYW5kb20uIEFuZCBp
dCdzIG5vdCBsaWtlIHdlJ3JlIHJlcG9ydGluZyB0aGUgZXJyb3IgdG9tb3Jyb3cgLSBpdCBpcwpt
b3N0bHkgYSBjb3VwbGUgb2Ygc2Vjb25kcyBmcm9tIGxvZ2dpbmcgdG8gdGhlIGZ3IHB1c2hpbmcg
aXQgb3V0Li4uCgotLSAKUmVnYXJkcy9HcnVzcywKICAgIEJvcmlzLgoKR29vZCBtYWlsaW5nIHBy
YWN0aWNlcyBmb3IgNDAwOiBhdm9pZCB0b3AtcG9zdGluZyBhbmQgdHJpbSB0aGUgcmVwbHkuCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWls
aW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNv
bHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
