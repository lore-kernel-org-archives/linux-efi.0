From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] x86: fix unused efi_get_time function
Date: Thu, 23 Jun 2016 14:32:05 +0100
Message-ID: <20160623133205.GH8415@codeblueprint.co.uk>
References: <20160617145152.3569706-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
Content-Disposition: inline
In-Reply-To: <20160617145152.3569706-1-arnd@arndb.de>
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
Cc: linux-efi@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, y2038@lists.linaro.org, x86@kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-efi@vger.kernel.org

T24gRnJpLCAxNyBKdW4sIGF0IDA0OjUxOjI5UE0sIEFybmQgQmVyZ21hbm4gd3JvdGU6Cj4gTm90
aGluZyBjYWxscyB0aGUgZWZpX2dldF90aW1lIGZ1bmN0aW9uIG9uIHg4NiwgYnV0IGl0IGRvZXMg
c3VmZmVyCj4gZnJvbSB0aGUgMzItYml0IHRpbWVfdCBvdmVyZmxvdyBpbiAyMDM4Lgo+IAo+IFRv
IGF2b2lkIHRoYXQgaWYgYW55b25lIHN0YXJ0cyBjYWxsaW5nIGl0LCB0aGlzIGNoYW5nZXMgdGhl
IGZ1bmN0aW9uCj4gdG8gdXNlIHRpbWVzcGVjNjQgYW5kIG1rdGltZTY0IGluc3RlYWQuCj4gCj4g
U2lnbmVkLW9mZi1ieTogQXJuZCBCZXJnbWFubiA8YXJuZEBhcm5kYi5kZT4KPiAtLS0KPiBUaGUg
b2J2aW91cyBhbHRlcm5hdGl2ZSB3b3VsZCBiZSB0byByZW1vdmUgdGhlIGZ1bmN0aW9uLCBJJ2xs
IHNlbmQKPiB0aGF0IHBhdGNoIGFzIHdlbGwsIHNvIHlvdSBjYW4gcGljayBvbmUgb3IgdGhlIG90
aGVyLgo+IAo+ICBhcmNoL3g4Ni9wbGF0Zm9ybS9lZmkvZWZpLmMgfCA2ICsrKy0tLQo+ICBpbmNs
dWRlL2xpbnV4L2VmaS5oICAgICAgICAgfCAyICstCj4gIDIgZmlsZXMgY2hhbmdlZCwgNCBpbnNl
cnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQogCkxvb2tzIGdvb2QsIHRoYW5rcyBBcm5kIQpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpZMjAzOCBtYWlsaW5n
IGxpc3QKWTIwMzhAbGlzdHMubGluYXJvLm9yZwpodHRwczovL2xpc3RzLmxpbmFyby5vcmcvbWFp
bG1hbi9saXN0aW5mby95MjAzOAo=
