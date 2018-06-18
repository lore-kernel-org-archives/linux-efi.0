From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] efi: cper: avoid using get_seconds()
Date: Mon, 18 Jun 2018 17:56:48 +0200
Message-ID: <CAKv+Gu9zYJk+ubcn8ngqsXPBbxWM-S5kUWAHfe_zKDm1=FWB4w@mail.gmail.com>
References: <20180618141811.3353245-1-arnd@arndb.de>
 <CAKv+Gu-r_+b_tCXeZeE6=EN3=1N98rheODOwV_4mpb9GMzdqrQ@mail.gmail.com>
 <CAK8P3a0dP+zvucn=_um1zRgBYQCskrhqa2KNSDtnpSu199baWw@mail.gmail.com>
 <CAKv+Gu9OD6s24Aq1bLBr-yq_tn6wPR0TAkddO+VTwM7jR76dOQ@mail.gmail.com>
 <CAK8P3a0xkPrDhoHaUzcN++b7TEh3v_a=VkP6VX9_FD56pG1A6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <CAK8P3a0xkPrDhoHaUzcN++b7TEh3v_a=VkP6VX9_FD56pG1A6w@mail.gmail.com>
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, y2038 Mailman List <y2038@lists.linaro.org>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, gengdongjiu <gengdongjiu@huawei.com>, Yazen Ghannam <yazen.ghannam@amd.com>, linux-efi <linux-efi@vger.kernel.org>, Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@kernel.org>
List-Id: linux-efi@vger.kernel.org

T24gMTggSnVuZSAyMDE4IGF0IDE3OjU0LCBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPiB3
cm90ZToKPiBPbiBNb24sIEp1biAxOCwgMjAxOCBhdCA1OjUwIFBNLCBBcmQgQmllc2hldXZlbAo+
IDxhcmQuYmllc2hldXZlbEBsaW5hcm8ub3JnPiB3cm90ZToKPj4gT24gMTggSnVuZSAyMDE4IGF0
IDE3OjQ5LCBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPiB3cm90ZToKPj4+IE9uIE1vbiwg
SnVuIDE4LCAyMDE4IGF0IDU6NDcgUE0sIEFyZCBCaWVzaGV1dmVsCj4+PiA8YXJkLmJpZXNoZXV2
ZWxAbGluYXJvLm9yZz4gd3JvdGU6Cj4+Pj4gT24gMTggSnVuZSAyMDE4IGF0IDE2OjE3LCBBcm5k
IEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPiB3cm90ZToKPj4+Cj4+Pj4+IC0gICAgICAgICAgICAg
ICBhdG9taWM2NF9zZXQoJnNlcSwgKCh1NjQpZ2V0X3NlY29uZHMoKSkgPDwgMzIpOwo+Pj4+PiAr
ICAgICAgIGlmICghYXRvbWljNjRfcmVhZCgmc2VxKSkgewo+Pj4+PiArICAgICAgICAgICAgICAg
dGltZTY0X3QgdGltZSA9IGt0aW1lX2dldF9yZWFsX3NlY29uZHMoKTsKPj4+Pj4gKwo+Pj4+PiAr
ICAgICAgICAgICAgICAgLyoKPj4+Pj4gKyAgICAgICAgICAgICAgICAqIFRoaXMgY29kZSBpcyB1
bmxpa2VseSB0byBzdGlsbCBiZSBuZWVkZWQgaW4geWVhciAyMTA2LAo+Pj4+PiArICAgICAgICAg
ICAgICAgICogYnV0IGp1c3QgaW4gY2FzZSwgbGV0J3MgdXNlIGEgZmV3IG1vcmUgYml0cyBmb3Ig
dGltZXN0YW1wcwo+Pj4+PiArICAgICAgICAgICAgICAgICogYWZ0ZXIgeTIwMzggdG8gYmUgc3Vy
ZSB0aGV5IGtlZXAgaW5jcmVhc2luZyBtb25vdG9uaWNhbGx5Cj4+Pj4+ICsgICAgICAgICAgICAg
ICAgKiBmb3IgdGhlIG5leHQgZmV3IGh1bmRyZWQgeWVhcnMuLi4KPj4+Pj4gKyAgICAgICAgICAg
ICAgICAqLwo+Pj4+PiArICAgICAgICAgICAgICAgaWYgKHRpbWUgPCAweDgwMDAwMDAwKQo+Pj4+
PiArICAgICAgICAgICAgICAgICAgICAgICBhdG9taWM2NF9zZXQoJnNlcSwgKGt0aW1lX2dldF9y
ZWFsX3NlY29uZHMoKSkgPDwgMzIpOwo+Pj4+PiArICAgICAgICAgICAgICAgZWxzZQo+Pj4+PiAr
ICAgICAgICAgICAgICAgICAgICAgICBhdG9taWM2NF9zZXQoJnNlcSwgMHg4MDAwMDAwMDAwMDAw
MDAwdWxsIHwKPj4+Pj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IGt0aW1lX2dldF9yZWFsX3NlY29uZHMoKSA8PCAyNCk7Cj4+Pj4+ICsgICAgICAgfQo+Pj4+Cj4+
Pj4gR2l2ZW4gdGhhdCB0aGVzZSB2YWx1ZXMgYXJlIG5ldmVyIGRlY29kZWQgYW5kIGludGVycHJl
dGVkIGFzCj4+Pj4gdGltZXN0YW1wcywgY2FuJ3Qgd2Ugc2ltcGx5IHN3aXRjaCB0byB0aGUgc2Vj
b25kIGZsYXZvdXIgaW1tZWRpYXRlbHk/Cj4+Pgo+Pj4gSSBjb25zaWRlcmVkIHRoYXQsIGJ1dCB0
aGUgZG93bnNpZGUgd291bGQgYmUgdGhhdCBhbGwgZnV0dXJlIGZpbGVuYW1lcyB3b3VsZAo+Pj4g
Y29tZSBiZWZvcmUgYWxsIHBhc3QgZmlsZSBuYW1lcy4KPj4KPj4gV29uJ3Qgd2UgaGF2ZSB0aGF0
IHNhbWUgcHJvYmxlbSBpbiAyMDM4Pwo+Cj4gTm8sIGl0IGdvZXMgZnJvbSAweDdmZmZmZmZmMDAw
MDAwMDAgdG8gMHg4MDAwMDAwMDAwMDAwMDAwLCBmb2xsb3dlZAo+IGJ5IDB4ODAwMDAwMDAwMTAw
MDAwMC4KPgoKQWgsIHJpZ2h0LiBJJ20gd2l0aCB5b3Ugbm93IDotKQoKSSdsbCBxdWV1ZSB0aGlz
IGluIHRoZSBlZmkgdHJlZS4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18KWTIwMzggbWFpbGluZyBsaXN0ClkyMDM4QGxpc3RzLmxpbmFyby5vcmcKaHR0cHM6
Ly9saXN0cy5saW5hcm8ub3JnL21haWxtYW4vbGlzdGluZm8veTIwMzgK
