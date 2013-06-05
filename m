From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Modify UEFI anti-bricking code
Date: Wed, 5 Jun 2013 16:08:39 +0000
Message-ID: <1370448519.6315.36.camel@x230.lan>
References: <1370117180-1712-1-git-send-email-matthew.garrett@nebula.com>
	 <1370276021.30695.4.camel@linux-s257.site>
	 <1370277079.6315.14.camel@x230.lan>
	 <1370316933.30695.7.camel@linux-s257.site>
	 <CAL01qptzxe5L6Vq+nBZLq+bQNxbe_i_2OdKMNJGZQDfMihaHOw@mail.gmail.com>
	 <1370444007.6315.32.camel@x230.lan>
	 <20130605155904.GC30420@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130605155904.GC30420-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Content-Language: en-US
Content-ID: <2DCA9AAFD6F52F41AA2F8C296796801F-HX+pjaQZbrqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, "rja-sJ/iWh9BUns@public.gmane.org" <rja-sJ/iWh9BUns@public.gmane.org>, "mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org" <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "jkosina-AlSwsSmVLrQ@public.gmane.org" <jkosina-AlSwsSmVLrQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org" <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "oneukum-l3A5Bk7waGM@public.gmane.org" <oneukum-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

T24gV2VkLCAyMDEzLTA2LTA1IGF0IDE2OjU5ICswMTAwLCBNYXR0IEZsZW1pbmcgd3JvdGU6DQoN
Cj4gKwkvKiBjbGVhbiBEVU1NWSBvYmplY3QgKi8NCj4gKwllZmkuc2V0X3ZhcmlhYmxlKGVmaV9k
dW1teV9uYW1lLCAmRUZJX0RVTU1ZX0dVSUQsIDAsIDAsIE5VTEwpOw0KDQpIbS4gQWN0dWFsbHks
IGlzIHRoYXQgZ29pbmcgdG8gd29yaz8gRnJvbSB0aGUgc3BlYzoNCg0KSWYgYSBwcmVleGlzdGlu
ZyB2YXJpYWJsZSBpcyByZXdyaXR0ZW4gd2l0aCBkaWZmZXJlbnQgYXR0cmlidXRlcywNClNldFZh
cmlhYmxlKClzaGFsbCBub3QgbW9kaWZ5IHRoZSB2YXJpYWJsZSBhbmQgc2hhbGwgcmV0dXJuDQpF
RklfSU5WQUxJRF9QQVJBTUVURVIuIA0KDQpTbyBJIHRoaW5rIHdlIHByb2JhYmx5IG5lZWQgdG8g
Zml4IHRoZSBhdHRyaWJ1dGVzIHRvIE5WfFJUfEJTIGZvciBib3RoDQp0aGlzIGNhbGwgYW5kIHRo
ZSBvbmUgaW4gcXVlcnlfdmFyaWFibGVfc3RvcmUuIFdlIHNob3VsZCBwcm9iYWJseSBhbHNvDQpv
bmx5IGRvIHRoZSB3b3JrYXJvdW5kIGlmIHRoZSBOViBiaXQgaXMgc2V0IGluIHRoZSBvcmlnaW5h
bCBxdWVyeS4NCg0KLS0gDQpNYXR0aGV3IEdhcnJldHQgfCBtamc1OUBzcmNmLnVjYW0ub3JnDQo=
