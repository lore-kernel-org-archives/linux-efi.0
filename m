From: Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH] lib: Always NUL terminate ucs2_as_utf8
Date: Thu, 21 Apr 2016 11:13:44 -0400
Message-ID: <20160421151343.GA3763@redhat.com>
References: <1461141427-16361-1-git-send-email-chris@chris-wilson.co.uk>
 <5717834C.6070802@redhat.com>
 <20160421121827.GE2829@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20160421121827.GE2829@codeblueprint.co.uk>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: linux-efi@vger.kernel.org, Jason Andryuk <jandryuk@gmail.com>, intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@coreos.com>, Laszlo Ersek <lersek@redhat.com>
List-Id: linux-efi@vger.kernel.org

T24gVGh1LCBBcHIgMjEsIDIwMTYgYXQgMDE6MTg6MjdQTSArMDEwMCwgTWF0dCBGbGVtaW5nIHdy
b3RlOgo+ICggR29vZCBMb3JkLCBJIGhhdGUgZG9pbmcgc3RyaW5nIG1hbmlwdWxhdGlvbiBpbiBD
ICkKCih5ZXApCgo+IAo+IE9uIFdlZCwgMjAgQXByLCBhdCAwMzoyNTozMlBNLCBMYXN6bG8gRXJz
ZWsgd3JvdGU6Cj4gPiAKPiA+IFNvLCAibGVuIiBkb2VzIG5vdCBpbmNsdWRlIHRoZSByb29tIGZv
ciB0aGUgdGVybWluYXRpbmcgTlVMLWJ5dGUgaGVyZS4KPiA+IFdoZW4gImxlbiIgaXMgcGFzc2Vk
IHRvIHVjczJfYXNfdXRmOCgpLCB3aXRoIHRoZSBwcm9wb3NlZCBwYXRjaCBhcHBsaWVkLAo+ID4g
YSBOVUwgYnl0ZSB3aWxsIGJlIHByb2R1Y2VkIGluICJuYW1lIiwgYnV0IGl0IHdpbGwgYmUgYXQg
dGhlIHByaWNlIG9mIGEKPiA+IGdlbnVpbmUgY2hhcmFjdGVyIGZyb20gdGhlIGlucHV0IHZhcmlh
YmxlIG5hbWUuCj4gCj4gUmlnaHQsIGFuZCB0aGlzIGlzIGEgcHJvYmxlbSBiZWNhdXNlIHdlJ3Jl
IHRyeWluZyB0byBrZWVwIHRoZSBuYW1lcwo+IGNvbnNpc3RlbnQgYmV0d2VlbiBlZml2YXJmcyBh
bmQgdGhlIEVGSSB2YXJpYWJsZSBkYXRhLiBGb3JjZQo+IE5VTC10ZXJtaW5hdGluZyB0aGUgc3Ry
aW5nIGlzIHdyb25nLCBiZWNhdXNlIGlmIHlvdSBoYXZlIG5vIHJvb20gZm9yCj4gdGhlIE5VTCB0
aGUgY2FsbGVyIHNob3VsZCBjaGVjayBmb3IgdGhhdC4gU2FkbHkgbm9uZSBkby4KPiAKPiBPbiB0
aGUgZmxpcC1zaWRlLCBwYXNzaW5nIGFyb3VuZCBub24tTlVMIHRlcm1pbmF0ZWQgc3RyaW5ncyBp
cyBqdXN0Cj4gYmVnZ2luZyBmb3IgdGhlc2Uga2luZHMgb2YgaXNzdWVzIHRvIGNvbWUgdXAuCj4g
Cj4gVGhlIGZhY3QgaXMgdGhhdCB0aGUgY2FsbGVycyBvZiB1Y3MyX2FzX3V0ZjgoKSBhcmUgcGFz
c2luZyBpdCB0aGUKPiB3cm9uZyAnbGVuJyBhcmd1bWVudC4gV2Ugd2FudCBhIE5VTC10ZXJtaW5h
dGVkIHV0Zjggc3RyaW5nIGFuZCB3ZSdyZQo+IHBhc3NpbmcgYSBOVUwtdGVybWluYXRlZCB1Y3My
IHN0cmluZy4gV2Ugc2hvdWxkIHRlbGwgdWNzMl9hc191dGY4KCkgaXQKPiBoYXMgZW5vdWdoIHJv
b20gdG8gY29weSB0aGUgTlVMLgo+IAo+IFdvdWxkbid0IHRoaXMgd29yayAobWludXMgdGhlIHJl
dHVybiB2YWx1ZSBjaGVja2luZyk/CgpJIGFncmVlIHdpdGggeW91ciBhbmFseXNpcywgYW5kIHlv
dXIgcGF0Y2ggbG9va3MgcGxhdXNpYmxlLgoKLS0gCiAgUGV0ZXIKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KSW50ZWwtZ2Z4IG1haWxpbmcgbGlzdApJbnRl
bC1nZnhAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3Jn
L21haWxtYW4vbGlzdGluZm8vaW50ZWwtZ2Z4Cg==
