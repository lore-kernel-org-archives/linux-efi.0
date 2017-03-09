From: Andrew Cooper <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v5 2/3] x86: Remap GDT tables in the Fixmap
 section
Date: Thu, 9 Mar 2017 21:43:05 +0000
Message-ID: <17ffcc5b-1c9a-51b6-272a-5eaecf1bc0c4@citrix.com>
References: <20170306220348.79702-1-thgarnie@google.com>
 <20170306220348.79702-2-thgarnie@google.com>
 <CALCETrVXHc-EAhBtdhL9FXSW1G2VbohRY4UJuOtpRG1K0Q-Ogg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <xen-devel-bounces@lists.xen.org>
In-Reply-To: <CALCETrVXHc-EAhBtdhL9FXSW1G2VbohRY4UJuOtpRG1K0Q-Ogg@mail.gmail.com>
List-Unsubscribe: <https://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <https://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xen.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xen.org>
To: Andy Lutomirski <luto@amacapital.net>, Thomas Garnier <thgarnie@google.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>, Stanislaw Gruszka <sgruszka@redhat.com>, kvm list <kvm@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Frederic Weisbecker <fweisbec@gmail.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Chris Wilson <chris@chris-wilson.co.uk>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Dave Hansen <dave.hansen@intel.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Alexander Potapenko <glider@google.com>, Pavel Machek <pavel@ucw.cz>, "H . Peter Anvin" <hpa@zytor.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Jiri Olsa <jolsa@redhat.com>, zijun_hu <zijun_hu@htc.com>, Prarit Bhargava <prarit@redhat.com>, Andi Kleen <ak@linux.intel.com>, Len Brown <len.brown@intel.com>, Jonathan Corbet <corbe>
List-Id: linux-efi@vger.kernel.org

T24gMDkvMDMvMjAxNyAyMTozMiwgQW5keSBMdXRvbWlyc2tpIHdyb3RlOgo+IE9uIE1vbiwgTWFy
IDYsIDIwMTcgYXQgMjowMyBQTSwgVGhvbWFzIEdhcm5pZXIgPHRoZ2FybmllQGdvb2dsZS5jb20+
IHdyb3RlOgo+Cj4+IC0tLSBhL2FyY2gveDg2L3hlbi9lbmxpZ2h0ZW4uYwo+PiArKysgYi9hcmNo
L3g4Ni94ZW4vZW5saWdodGVuLmMKPj4gQEAgLTcxMCw3ICs3MTAsNyBAQCBzdGF0aWMgdm9pZCBs
b2FkX1RMU19kZXNjcmlwdG9yKHN0cnVjdCB0aHJlYWRfc3RydWN0ICp0LAo+Pgo+PiAgICAgICAg
ICpzaGFkb3cgPSB0LT50bHNfYXJyYXlbaV07Cj4+Cj4+IC0gICAgICAgZ2R0ID0gZ2V0X2NwdV9n
ZHRfdGFibGUoY3B1KTsKPj4gKyAgICAgICBnZHQgPSBnZXRfY3B1X2dkdF9ydyhjcHUpOwo+PiAg
ICAgICAgIG1hZGRyID0gYXJiaXRyYXJ5X3ZpcnRfdG9fbWFjaGluZSgmZ2R0W0dEVF9FTlRSWV9U
TFNfTUlOK2ldKTsKPj4gICAgICAgICBtYyA9IF9feGVuX21jX2VudHJ5KDApOwo+IEJvcmlzLCBp
cyB0aGlzIHJpZ2h0PyAgSSBkb24ndCBzZWUgd2h5IGl0IHdvdWxkbid0IGJlLCBidXQgWGVuIGlz
IHNwZWNpYWwuCgpVbmRlciBYZW4gUFYsIHRoZSBHRFQgaXMgYWxyZWFkeSByZWFkLW9ubHkgYXQg
dGhpcyBwb2ludC4gIChJdCBpcyBub3QKc2FmZSB0byBsZXQgdGhlIGd1ZXN0IGhhdmUgd3JpdGVh
YmxlIGFjY2VzcyB0byBzeXN0ZW0gdGFibGVzLCBzbyB0aGUKZ3Vlc3QgbXVzdCByZWxpbnF1aXNo
IHdyaXRlIGFjY2VzcyB0byB0aGUgZnJhbWVzIHdpc2hpbmcgdG8gYmUgdXNlZCBhcwpMRFRzIG9y
IEdEVHMuKQoKVGhlIGh5cGVyY2FsbCBhY3RzIG9uIHRoZSBmcmFtZSwgbm90IGEgdmlydHVhbCBh
ZGRyZXNzLCBzbyBlaXRoZXIgYWxpYXMKc2hvdWxkIGJlIGZpbmUgaGVyZS4KClVuZGVyIHRoaXMg
bmV3IHNjaGVtZSwgdGhlcmUgd2lsbCBiZSB0d28gcmVhZC1vbmx5IGFsaWFzZXMuICBJIGd1ZXNz
CnRoaXMgaXMgZWFzaWVyIHRvIG1haW50YWluIHRoZSBzcGxpdCBjb25zaXN0ZW50bHkgYWNyb3Nz
IExpbnV4LCB0aGFuIHRvCnNwZWNpYWwgY2FzZSBYZW4gUFYgYmVjYXVzZSBpdCBkb2Vzbid0IG5l
ZWQgdGhlIHNlY29uZCBhbGlhcy4KCn5BbmRyZXcKCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fClhlbi1kZXZlbCBtYWlsaW5nIGxpc3QKWGVuLWRldmVsQGxp
c3RzLnhlbi5vcmcKaHR0cHM6Ly9saXN0cy54ZW4ub3JnL3hlbi1kZXZlbAo=
