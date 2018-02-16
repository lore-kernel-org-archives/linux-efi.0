From: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 0/2] efivars: reading variables can generate SMIs
Date: Fri, 16 Feb 2018 22:02:05 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F7B3795A3@ORSMSX110.amr.corp.intel.com>
References: <20180215182208.35003-1-joe.konno@linux.intel.com>
 <CAKv+Gu80pJ5tbGoJqBm8CCKrEZXdkE83c944383KbQ5jREUC0Q@mail.gmail.com>
 <1518814319.4419.10.camel@HansenPartnership.com>
 <3908561D78D1C84285E8C5FCA982C28F7B37942B@ORSMSX110.amr.corp.intel.com>
 <CALCETrXD4qCwgnDcwnybUXzVk7zyJtzHC2xzLfcZvzrXvAB8PQ@mail.gmail.com>
 <CACdnJutPvMPUTWWjS3oRadQAqn+HpRpY+fhO0pXBj6OsQkAAag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACdnJutPvMPUTWWjS3oRadQAqn+HpRpY+fhO0pXBj6OsQkAAag-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "joe.konno-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <joe.konno-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org" <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org" <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>, "ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

PiBJZiB0aGUgZGVmYXVsdCBpcyA2MDAgdGhlbiBpdCBtYWtlcyBzZW5zZSB0byBhbGxvdyBhIHBy
aXZpbGVnZWQgc2VydmljZSB0bw0KPiBzZWxlY3RpdmVseSBtYWtlIGNlcnRhaW4gdmFyaWFibGVz
IHdvcmxkIHJlYWRhYmxlIGF0IHJ1bnRpbWUuDQoNCkFzIHNvb24gYXMgeW91IG1ha2Ugb25lIHZh
cmlhYmxlIHdvcmxkIHJlYWRhYmxlIHlvdSBhcmUgdnVsbmVyYWJsZSB0bw0KYSBsb2NhbCB1c2Vy
IGxhdW5jaGluZyBhIERvUyBhdHRhY2sgYnkgcmVhZGluZyB0aGF0IHZhcmlhYmxlIG92ZXIgYW5k
IG92ZXINCmdlbmVyYXRpbmcgYSBmbG9vZCBvZiBTTUlzLg0KDQotVG9ueQ0K
