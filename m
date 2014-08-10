From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Loading initrd above 4G causes freeze on boot
Date: Sat, 9 Aug 2014 22:55:03 -0700
Message-ID: <CAE9FiQVDURMvgVd55-onMDejCZT+OZ2vrr92wx8FJMKRNSX_GA@mail.gmail.com>
References: <53E62EEF.9040801@gmail.com>
	<CAE9FiQVXkojPnTr4EQE7h2YhWqa5VBYRSCadB0B1qDL+eGY8jg@mail.gmail.com>
	<20140809192302.GJ15082@console-pimps.org>
	<CAPWNY8X+pRf4GuYAzKj-co0fkLMY0KNw+wB4KA8eaJ0QbE4MnA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=20cf3036405b673236050040140d
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPWNY8X+pRf4GuYAzKj-co0fkLMY0KNw+wB4KA8eaJ0QbE4MnA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

--20cf3036405b673236050040140d
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 9, 2014 at 3:45 PM, Mantas Mikul=C4=97nas <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> w=
rote:
> On Sat, Aug 9, 2014 at 10:23 PM, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wr=
ote:
> [However... Whether it's five chunks, four (after making the initrd
> smaller), or just one (with your efi=3Dnochunk), I noticed that it
> *always* hangs during the *last* read, and the allocated memory always
> ends at roughly the same address (0x137fffXXX). I wonder if it's
> selecting a memory location already in use, or something like that...]
>
> (The laptop is Asus K52JT, AMI firmware v206, no updates available.)

wonder if  efi_file_read return with wrong chunksize.

Can you try attached patch ?

Thanks

Yinghai

--20cf3036405b673236050040140d
Content-Type: text/x-patch; charset=US-ASCII; name="efi_file_read_debug.patch"
Content-Disposition: attachment; filename="efi_file_read_debug.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hynx35dq0

LS0tCiBkcml2ZXJzL2Zpcm13YXJlL2VmaS9saWJzdHViL2VmaS1zdHViLWhlbHBlci5jIHwgICAg
MyArKy0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCklu
ZGV4OiBsaW51eC0yLjYvZHJpdmVycy9maXJtd2FyZS9lZmkvbGlic3R1Yi9lZmktc3R1Yi1oZWxw
ZXIuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9kcml2ZXJzL2Zpcm13YXJlL2VmaS9s
aWJzdHViL2VmaS1zdHViLWhlbHBlci5jCisrKyBsaW51eC0yLjYvZHJpdmVycy9maXJtd2FyZS9l
ZmkvbGlic3R1Yi9lZmktc3R1Yi1oZWxwZXIuYwpAQCAtNDMxLDcgKzQzMSw4IEBAIGVmaV9zdGF0
dXNfdCBoYW5kbGVfY21kbGluZV9maWxlcyhlZmlfc3kKIAkJCQlzdGF0dXMgPSBlZmlfZmlsZV9y
ZWFkKGZpbGVzW2pdLmhhbmRsZSwKIAkJCQkJCSAgICAgICAmY2h1bmtzaXplLAogCQkJCQkJICAg
ICAgICh2b2lkICopYWRkcik7Ci0JCQkJaWYgKHN0YXR1cyAhPSBFRklfU1VDQ0VTUykgeworCQkJ
CWlmIChzdGF0dXMgIT0gRUZJX1NVQ0NFU1MgfHwKKwkJCQkgICAgY2h1bmtzaXplID4gc2l6ZSB8
fCAhY2h1bmtzaXplKSB7CiAJCQkJCXByX2VmaV9lcnIoc3lzX3RhYmxlX2FyZywgIkZhaWxlZCB0
byByZWFkIGZpbGVcbiIpOwogCQkJCQlnb3RvIGZyZWVfZmlsZV90b3RhbDsKIAkJCQl9Cg==
--20cf3036405b673236050040140d--
