From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Loading initrd above 4G causes freeze on boot
Date: Mon, 25 Aug 2014 11:22:34 -0700
Message-ID: <CAE9FiQWOp0pGSXhnaTe62zaFe7QodS6BSCKnC8qamjm3qTRRJA@mail.gmail.com>
References: <53E62EEF.9040801@gmail.com>
	<53F752A2.7080604@redhat.com>
	<CAPWNY8V4pfazk4Hw9qu07cAQZywC-GS7eyS+54fazXZaKMjMQw@mail.gmail.com>
	<CAPWNY8V=T=Y5uPX9J_qjdkTJRnctDs-PoTQP7LEX_cKQEn0_Zg@mail.gmail.com>
	<20140825105559.GQ29733@console-pimps.org>
	<CAPWNY8V8D74CNXGhDwp2gpPpeV2F=Qao32i-0Mhq=9zhvDXLLw@mail.gmail.com>
	<20140825125306.GS29733@console-pimps.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=20cf3011e1256897320501784593
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140825125306.GS29733-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Harald Hoyer <harald-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

--20cf3011e1256897320501784593
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 25, 2014 at 5:53 AM, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrot=
e:
> On Mon, 25 Aug, at 02:08:59PM, Mantas Mikul=C4=97nas wrote:

>> [    0.000000] RAMDISK: [mem 0xbe22e000-0xbe799fff]

that is pushed down under 4G.

>
> OK, we're out of options here. Yinghai, we're going to have to revert
> your patch, 4bf7111f5016 ("x86/efi: Support initrd loaded above 4G")
>
> We could conceivably add a boot parameter option to attempt loading
> inirds above 4G, but we can't turn the feature on by default because of
> all these buggy EFI implementations - things must work out of the box.
>
> But the boot parameter would be useful for those people that a) know
> their firmware isn't buggy and b) need to leave < 4G memory available
> for use by other things. Yinghai, can you provide some justification for
> your original commit? Do you have concrete use cases where loading
> initrds above 4G is critical? How important is it that we enable this
> functionality as opposed to reverting it?

The use case: install RHEL full will take more than 8G in the root disk.
then make initramfs image to include every file in the disk, then boot
kernel and initramfs as diskless boot.

To use this huge initramfs image, first one is kexec, second way is using
UEFI 64bit.

So the point is the initramfs is bigger than 4G.

Please check if you can apply attached one. That will keep under 2G at firs=
t,
then try any high address.

Thanks

Yinghai

--20cf3011e1256897320501784593
Content-Type: text/x-patch; charset=US-ASCII; name="efi_initrd_above_4g_second_try.patch"
Content-Disposition: attachment;
	filename="efi_initrd_above_4g_second_try.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hza4kfia0

LS0tCiBhcmNoL3g4Ni9ib290L2NvbXByZXNzZWQvZWJvb3QuYyB8ICAgMTYgKysrKysrKysrLS0t
LS0tLQogMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMoLSkKCklu
ZGV4OiBsaW51eC0yLjYvYXJjaC94ODYvYm9vdC9jb21wcmVzc2VkL2Vib290LmMKPT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PQotLS0gbGludXgtMi42Lm9yaWcvYXJjaC94ODYvYm9vdC9jb21wcmVzc2VkL2Vib290LmMKKysr
IGxpbnV4LTIuNi9hcmNoL3g4Ni9ib290L2NvbXByZXNzZWQvZWJvb3QuYwpAQCAtMTAzMiw3ICsx
MDMyLDYgQEAgc3RydWN0IGJvb3RfcGFyYW1zICptYWtlX2Jvb3RfcGFyYW1zKHN0cgogCWludCBp
OwogCXVuc2lnbmVkIGxvbmcgcmFtZGlza19hZGRyOwogCXVuc2lnbmVkIGxvbmcgcmFtZGlza19z
aXplOwotCXVuc2lnbmVkIGxvbmcgaW5pdHJkX2FkZHJfbWF4OwogCiAJZWZpX2Vhcmx5ID0gYzsK
IAlzeXNfdGFibGUgPSAoZWZpX3N5c3RlbV90YWJsZV90ICopKHVuc2lnbmVkIGxvbmcpZWZpX2Vh
cmx5LT50YWJsZTsKQEAgLTEwOTUsMTUgKzEwOTQsMTggQEAgc3RydWN0IGJvb3RfcGFyYW1zICpt
YWtlX2Jvb3RfcGFyYW1zKHN0cgogCiAJbWVtc2V0KHNkdCwgMCwgc2l6ZW9mKCpzZHQpKTsKIAot
CWlmIChoZHItPnhsb2FkZmxhZ3MgJiBYTEZfQ0FOX0JFX0xPQURFRF9BQk9WRV80RykKLQkJaW5p
dHJkX2FkZHJfbWF4ID0gLTFVTDsKLQllbHNlCi0JCWluaXRyZF9hZGRyX21heCA9IGhkci0+aW5p
dHJkX2FkZHJfbWF4OwotCiAJc3RhdHVzID0gaGFuZGxlX2NtZGxpbmVfZmlsZXMoc3lzX3RhYmxl
LCBpbWFnZSwKIAkJCQkgICAgICAoY2hhciAqKSh1bnNpZ25lZCBsb25nKWhkci0+Y21kX2xpbmVf
cHRyLAotCQkJCSAgICAgICJpbml0cmQ9IiwgaW5pdHJkX2FkZHJfbWF4LAorCQkJCSAgICAgICJp
bml0cmQ9IiwgaGRyLT5pbml0cmRfYWRkcl9tYXgsCisJCQkJICAgICAgJnJhbWRpc2tfYWRkciwg
JnJhbWRpc2tfc2l6ZSk7CisKKwlpZiAoc3RhdHVzICE9IEVGSV9TVUNDRVNTICYmCisJICAgIGhk
ci0+eGxvYWRmbGFncyAmIFhMRl9DQU5fQkVfTE9BREVEX0FCT1ZFXzRHKQorCQlzdGF0dXMgPSBo
YW5kbGVfY21kbGluZV9maWxlcyhzeXNfdGFibGUsIGltYWdlLAorCQkJCSAgICAgIChjaGFyICop
KHVuc2lnbmVkIGxvbmcpaGRyLT5jbWRfbGluZV9wdHIsCisJCQkJICAgICAgImluaXRyZD0iLCAt
MVVMLAogCQkJCSAgICAgICZyYW1kaXNrX2FkZHIsICZyYW1kaXNrX3NpemUpOworCiAJaWYgKHN0
YXR1cyAhPSBFRklfU1VDQ0VTUykKIAkJZ290byBmYWlsMjsKIAloZHItPnJhbWRpc2tfaW1hZ2Ug
PSByYW1kaXNrX2FkZHIgJiAweGZmZmZmZmZmOwo=
--20cf3011e1256897320501784593--
