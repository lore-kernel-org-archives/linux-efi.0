From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] efi: cper: avoid using get_seconds()
Date: Mon, 18 Jun 2018 17:54:06 +0200
Message-ID: <CAK8P3a0xkPrDhoHaUzcN++b7TEh3v_a=VkP6VX9_FD56pG1A6w@mail.gmail.com>
References: <20180618141811.3353245-1-arnd@arndb.de>
 <CAKv+Gu-r_+b_tCXeZeE6=EN3=1N98rheODOwV_4mpb9GMzdqrQ@mail.gmail.com>
 <CAK8P3a0dP+zvucn=_um1zRgBYQCskrhqa2KNSDtnpSu199baWw@mail.gmail.com>
 <CAKv+Gu9OD6s24Aq1bLBr-yq_tn6wPR0TAkddO+VTwM7jR76dOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <CAKv+Gu9OD6s24Aq1bLBr-yq_tn6wPR0TAkddO+VTwM7jR76dOQ@mail.gmail.com>
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, y2038 Mailman List <y2038@lists.linaro.org>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, gengdongjiu <gengdongjiu@huawei.com>, Yazen Ghannam <yazen.ghannam@amd.com>, linux-efi <linux-efi@vger.kernel.org>, Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@kernel.org>
List-Id: linux-efi@vger.kernel.org

T24gTW9uLCBKdW4gMTgsIDIwMTggYXQgNTo1MCBQTSwgQXJkIEJpZXNoZXV2ZWwKPGFyZC5iaWVz
aGV1dmVsQGxpbmFyby5vcmc+IHdyb3RlOgo+IE9uIDE4IEp1bmUgMjAxOCBhdCAxNzo0OSwgQXJu
ZCBCZXJnbWFubiA8YXJuZEBhcm5kYi5kZT4gd3JvdGU6Cj4+IE9uIE1vbiwgSnVuIDE4LCAyMDE4
IGF0IDU6NDcgUE0sIEFyZCBCaWVzaGV1dmVsCj4+IDxhcmQuYmllc2hldXZlbEBsaW5hcm8ub3Jn
PiB3cm90ZToKPj4+IE9uIDE4IEp1bmUgMjAxOCBhdCAxNjoxNywgQXJuZCBCZXJnbWFubiA8YXJu
ZEBhcm5kYi5kZT4gd3JvdGU6Cj4+Cj4+Pj4gLSAgICAgICAgICAgICAgIGF0b21pYzY0X3NldCgm
c2VxLCAoKHU2NClnZXRfc2Vjb25kcygpKSA8PCAzMik7Cj4+Pj4gKyAgICAgICBpZiAoIWF0b21p
YzY0X3JlYWQoJnNlcSkpIHsKPj4+PiArICAgICAgICAgICAgICAgdGltZTY0X3QgdGltZSA9IGt0
aW1lX2dldF9yZWFsX3NlY29uZHMoKTsKPj4+PiArCj4+Pj4gKyAgICAgICAgICAgICAgIC8qCj4+
Pj4gKyAgICAgICAgICAgICAgICAqIFRoaXMgY29kZSBpcyB1bmxpa2VseSB0byBzdGlsbCBiZSBu
ZWVkZWQgaW4geWVhciAyMTA2LAo+Pj4+ICsgICAgICAgICAgICAgICAgKiBidXQganVzdCBpbiBj
YXNlLCBsZXQncyB1c2UgYSBmZXcgbW9yZSBiaXRzIGZvciB0aW1lc3RhbXBzCj4+Pj4gKyAgICAg
ICAgICAgICAgICAqIGFmdGVyIHkyMDM4IHRvIGJlIHN1cmUgdGhleSBrZWVwIGluY3JlYXNpbmcg
bW9ub3RvbmljYWxseQo+Pj4+ICsgICAgICAgICAgICAgICAgKiBmb3IgdGhlIG5leHQgZmV3IGh1
bmRyZWQgeWVhcnMuLi4KPj4+PiArICAgICAgICAgICAgICAgICovCj4+Pj4gKyAgICAgICAgICAg
ICAgIGlmICh0aW1lIDwgMHg4MDAwMDAwMCkKPj4+PiArICAgICAgICAgICAgICAgICAgICAgICBh
dG9taWM2NF9zZXQoJnNlcSwgKGt0aW1lX2dldF9yZWFsX3NlY29uZHMoKSkgPDwgMzIpOwo+Pj4+
ICsgICAgICAgICAgICAgICBlbHNlCj4+Pj4gKyAgICAgICAgICAgICAgICAgICAgICAgYXRvbWlj
NjRfc2V0KCZzZXEsIDB4ODAwMDAwMDAwMDAwMDAwMHVsbCB8Cj4+Pj4gKyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIGt0aW1lX2dldF9yZWFsX3NlY29uZHMoKSA8PCAy
NCk7Cj4+Pj4gKyAgICAgICB9Cj4+Pgo+Pj4gR2l2ZW4gdGhhdCB0aGVzZSB2YWx1ZXMgYXJlIG5l
dmVyIGRlY29kZWQgYW5kIGludGVycHJldGVkIGFzCj4+PiB0aW1lc3RhbXBzLCBjYW4ndCB3ZSBz
aW1wbHkgc3dpdGNoIHRvIHRoZSBzZWNvbmQgZmxhdm91ciBpbW1lZGlhdGVseT8KPj4KPj4gSSBj
b25zaWRlcmVkIHRoYXQsIGJ1dCB0aGUgZG93bnNpZGUgd291bGQgYmUgdGhhdCBhbGwgZnV0dXJl
IGZpbGVuYW1lcyB3b3VsZAo+PiBjb21lIGJlZm9yZSBhbGwgcGFzdCBmaWxlIG5hbWVzLgo+Cj4g
V29uJ3Qgd2UgaGF2ZSB0aGF0IHNhbWUgcHJvYmxlbSBpbiAyMDM4PwoKTm8sIGl0IGdvZXMgZnJv
bSAweDdmZmZmZmZmMDAwMDAwMDAgdG8gMHg4MDAwMDAwMDAwMDAwMDAwLCBmb2xsb3dlZApieSAw
eDgwMDAwMDAwMDEwMDAwMDAuCgogICAgICAgQXJuZApfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwpZMjAzOCBtYWlsaW5nIGxpc3QKWTIwMzhAbGlzdHMubGlu
YXJvLm9yZwpodHRwczovL2xpc3RzLmxpbmFyby5vcmcvbWFpbG1hbi9saXN0aW5mby95MjAzOAo=
