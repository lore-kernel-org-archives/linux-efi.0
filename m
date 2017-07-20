From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 4.12 26/84] x86/xen/efi: Initialize only the
 EFI struct members used by Xen
Date: Thu, 20 Jul 2017 10:39:10 +0200
Message-ID: <20170720083910.aygobq7t7g7laszt@gmail.com>
References: <20170719092322.362625377@linuxfoundation.org>
 <20170719092323.396710042@linuxfoundation.org>
 <20170719103747.GZ4448@olila.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <xen-devel-bounces@lists.xen.org>
Content-Disposition: inline
In-Reply-To: <20170719103747.GZ4448@olila.local.net-space.pl>
List-Unsubscribe: <https://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <https://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xen.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xen.org>
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: jgross@suse.com, linux-efi@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, matt@codeblueprint.co.uk, andrew.cooper3@citrix.com, xen-devel@lists.xenproject.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-efi@vger.kernel.org

CiogRGFuaWVsIEtpcGVyIDxkYW5pZWwua2lwZXJAb3JhY2xlLmNvbT4gd3JvdGU6Cgo+IEhleSBH
cmVnLAo+IAo+IE9uIFdlZCwgSnVsIDE5LCAyMDE3IGF0IDExOjQzOjMyQU0gKzAyMDAsIEdyZWcg
S3JvYWgtSGFydG1hbiB3cm90ZToKPiA+IDQuMTItc3RhYmxlIHJldmlldyBwYXRjaC4gIElmIGFu
eW9uZSBoYXMgYW55IG9iamVjdGlvbnMsIHBsZWFzZSBsZXQgbWUga25vdy4KPiAKPiBXaHkgZGlk
IHlvdSBza2lwIHRoaXMgcGF0Y2ggZm9yIDQuMTE/IElNTyBpdCBzaG91bGQgYmUgYXBwbGllZCB0
aGVyZSB0b28uCgpUaGUgdGhpbmcgaXMsIHRoaXMgcGF0Y2ggc2hvdWxkIHByb2JhbHkgbm90IGV2
ZW4gYmUgaW4gdjQuMTIsIGFzIGl0IHNob3VsZCBvbmx5IAptYWtlIGFueSBkaWZmZXJlbmNlIGlm
IHRoZXJlJ3MgYSBzZXBhcmF0ZSBfYnVnXyBpbiB0aGUga2VybmVsLgoKVGhpcyBwYXRjaCBtYWtl
cyB0aGluZ3MgbW9yZSByb2J1c3QgZ29pbmcgZm9yd2FyZCwgYnV0IEkgcXVlc3Rpb24gdGhhdCBp
dCBuZWVkcyB0byAKYmUgaW4gLXN0YWJsZS4KClRoYW5rcywKCglJbmdvCgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpYZW4tZGV2ZWwgbWFpbGluZyBsaXN0
Clhlbi1kZXZlbEBsaXN0cy54ZW4ub3JnCmh0dHBzOi8vbGlzdHMueGVuLm9yZy94ZW4tZGV2ZWwK
