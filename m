From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -v4] x86: only load initrd above 4g on second try
Date: Thu, 4 Sep 2014 18:19:16 -0700
Message-ID: <CAE9FiQUDLoARj-Z3ipPTf2sZgGn71SxrxM+FqLE1Cyb-OEoP+A@mail.gmail.com>
References: <1409806207-3992-1-git-send-email-yinghai@kernel.org>
	<20140904100137.GK3001@console-pimps.org>
	<5408D299.5000300@zytor.com>
	<20140904212925.GL3001@console-pimps.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a11c3bf04f9218d0502474180
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140904212925.GL3001-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Anders Darander <anders-7UjN0b3lYz2SbKU13Z4Etw@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

--001a11c3bf04f9218d0502474180
Content-Type: text/plain; charset=UTF-8

On Thu, Sep 4, 2014 at 2:29 PM, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> On Thu, 04 Sep, at 01:59:05PM, H. Peter Anvin wrote:
>>
>> I am fine with this patch, but at the same time I do want to note that
>> there is an alternative to double-buffer the patch and/or (if that
>> applies to the buggy BIOS) round up the size of the target buffer.
>
> I'm not sure that rounding up the size of the target buffer will
> workaround this issue correctly.
>
> As far as I know, the only thing that Mantas tried was rounding up the
> size of the source file, by padding it.

Hi Mantas,

Can you try attached patch on top of linus tree?

Thanks

Yinghai

--001a11c3bf04f9218d0502474180
Content-Type: text/x-patch; charset=US-ASCII; name="round_up_chunksize.patch"
Content-Disposition: attachment; filename="round_up_chunksize.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hzou2nyd0

LS0tCiBkcml2ZXJzL2Zpcm13YXJlL2VmaS9saWJzdHViL2VmaS1zdHViLWhlbHBlci5jIHwgICAg
MiArLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpJbmRl
eDogbGludXgtMi42L2RyaXZlcnMvZmlybXdhcmUvZWZpL2xpYnN0dWIvZWZpLXN0dWItaGVscGVy
LmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvZHJpdmVycy9maXJtd2FyZS9lZmkvbGli
c3R1Yi9lZmktc3R1Yi1oZWxwZXIuYworKysgbGludXgtMi42L2RyaXZlcnMvZmlybXdhcmUvZWZp
L2xpYnN0dWIvZWZpLXN0dWItaGVscGVyLmMKQEAgLTQyNiw3ICs0MjYsNyBAQCBlZmlfc3RhdHVz
X3QgaGFuZGxlX2NtZGxpbmVfZmlsZXMoZWZpX3N5CiAJCQkJaWYgKHNpemUgPiBFRklfUkVBRF9D
SFVOS19TSVpFKQogCQkJCQljaHVua3NpemUgPSBFRklfUkVBRF9DSFVOS19TSVpFOwogCQkJCWVs
c2UKLQkJCQkJY2h1bmtzaXplID0gc2l6ZTsKKwkJCQkJY2h1bmtzaXplID0gcm91bmRfdXAoc2l6
ZSwgRUZJX1BBR0VfU0laRSk7CiAKIAkJCQlzdGF0dXMgPSBlZmlfZmlsZV9yZWFkKGZpbGVzW2pd
LmhhbmRsZSwKIAkJCQkJCSAgICAgICAmY2h1bmtzaXplLAo=
--001a11c3bf04f9218d0502474180--
