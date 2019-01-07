From: lijiang <lijiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2 v8] resource: add the new I/O resource descriptor
 'IORES_DESC_RESERVED'
Date: Mon, 7 Jan 2019 13:10:26 +0800
Message-ID: <9e994396-4bf9-ed96-a8e7-c4ca2f69170d@redhat.com>
References: <20181129080956.20776-1-lijiang@redhat.com>
 <20181129080956.20776-2-lijiang@redhat.com>
 <20181130033703.GA23624@dhcp-128-65.nay.redhat.com>
 <bbf6352b-b060-4cb8-dfd2-99166b0149a7@redhat.com>
 <20181206201147.GG3986@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <20181206201147.GG3986-Jj63ApZU6fQ@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

5ZyoIDIwMTjlubQxMuaciDA35pelIDA0OjExLCBCb3Jpc2xhdiBQZXRrb3Yg5YaZ6YGTOgo+IE9u
IEZyaSwgTm92IDMwLCAyMDE4IGF0IDAzOjA0OjQ0UE0gKzA4MDAsIGxpamlhbmcgd3JvdGU6Cj4+
IEkgaGF2ZSBub3RpY2VkIHRoZSBjaGFuZ2VzIG9uIHg4NiwgYnV0IGZvciBJQTY0LCBpJ20gbm90
IHN1cmUgd2hldGhlciBpdCBzaG91bGQgZG8gdGhlIHNhbWUKPj4gdGhpbmcsIHNvIGtlZXAgaXQg
YXMgYmVmb3JlLgo+Pgo+PiBJZiBJQTY0IHBlb3BsZSB3b3VsZCBsaWtlIHRvIGdpdmUgYW55IGNv
bW1lbnQsIHRoYXQgd2lsbCBiZSBhcHByZWNpYXRlZC4KPiAKPiBJIHRoaW5rIHlvdSBzaG91bGQg
bm90IHRvdWNoIGlhNjQgYW5kIG5vdCBtYWtlIFRvbnkgdW5uZWNlc3NhcmlseSBwb3dlcgo+IHVw
IHRoZSBvbGQgcnVzdC4KPiAKCk9rLCBpIHdpbGwgZ2V0IHJpZCBvZiBwcmV2aW91cyBjaGFuZ2Vz
IHRvIElBNjQgaW4gbmV4dCBwb3N0LgoKVGhhbmtzLgoKPiA6LSkKPiAKCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmtleGVjIG1haWxpbmcgbGlzdAprZXhl
Y0BsaXN0cy5pbmZyYWRlYWQub3JnCmh0dHA6Ly9saXN0cy5pbmZyYWRlYWQub3JnL21haWxtYW4v
bGlzdGluZm8va2V4ZWMK
