From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] efi: Add newline to cper DIMM location messages
Date: Mon, 27 Jan 2014 14:09:55 -0800
Message-ID: <CA+55aFyHLGaDnTWQRSxtb1dhgoTauEY2x8ztOBWqjLNShh88Tg@mail.gmail.com>
References: <52e6a8d812916d47b@agluck-desk.sc.intel.com>
	<CA+55aFwRE6DNoigx0xN7ZTc8dbCqHZdTopfwYOVuK_0vhZe0rw@mail.gmail.com>
	<3908561D78D1C84285E8C5FCA982C28F31DBA1E0@ORSMSX106.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=089e0158a82abea76104f0faf7d6
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31DBA1E0-P5GAC/sN6hlZtRGVdHMbwrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Chen, Gong" <gong.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

--089e0158a82abea76104f0faf7d6
Content-Type: text/plain; charset=UTF-8

On Mon, Jan 27, 2014 at 11:48 AM, Luck, Tony <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> The thing is, unless the next printk is a continuation (PR_CONT), the
>> newline should be added at that point. And if it isn't, then that's a
>> bug. So I'm wondering how this issue got noticed - does it actually
>> cause user-visible issues, or was it just code reading?
>
> The next thing that happened was a debug printk() that didn't have
> any log level specified.
>
>         printk("CMCI on cpu%d\n", smp_processor_id());
>
> and no newline was added.

Ok, I think that's a bug. Only an explicit KERN_CONT prefix should
cause a line continuation.

The new msg code seems to be terminally confused about this, and for
example, seems to completely ignore the KERN_CONT flag, and instead
tests for just LOG_PREFIX (which is set for any prefix, not the
KERN_CONT 'c' prefix).

And then it turns LOG_CONT to be about the *current* printk missing a
newline. So the whole new msg code seems to  be really confused about
what the whole KERN_CONT thing was all about, and mixed it up with
whether the message ended in a newline or not, which is entirely
bogus.

Adding more people.  Looking at the code in vprintk_emit(), somebody
is really confused.

Anyway, attached is a *totally* untested patch. Comments?

                  Linus

--089e0158a82abea76104f0faf7d6
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hqyagir70

IGtlcm5lbC9wcmludGsvcHJpbnRrLmMgfCA0MyArKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKSwgMzEgZGVs
ZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEva2VybmVsL3ByaW50ay9wcmludGsuYyBiL2tlcm5lbC9w
cmludGsvcHJpbnRrLmMKaW5kZXggYjFkMjU1ZjA0MTM1Li5mYWU1YzhhYjYwN2QgMTAwNjQ0Ci0t
LSBhL2tlcm5lbC9wcmludGsvcHJpbnRrLmMKKysrIGIva2VybmVsL3ByaW50ay9wcmludGsuYwpA
QCAtMTU2MSw3ICsxNTYxLDkgQEAgYXNtbGlua2FnZSBpbnQgdnByaW50a19lbWl0KGludCBmYWNp
bGl0eSwgaW50IGxldmVsLAogCQkJCQlsZXZlbCA9IGtlcm5fbGV2ZWwgLSAnMCc7CiAJCQljYXNl
ICdkJzoJLyogS0VSTl9ERUZBVUxUICovCiAJCQkJbGZsYWdzIHw9IExPR19QUkVGSVg7CisJCQkJ
YnJlYWs7CiAJCQljYXNlICdjJzoJLyogS0VSTl9DT05UICovCisJCQkJbGZsYWdzIHw9IExPR19D
T05UOwogCQkJCWJyZWFrOwogCQkJfQogCQkJdGV4dF9sZW4gLT0gZW5kX29mX2hlYWRlciAtIHRl
eHQ7CkBAIC0xNTc1LDQwICsxNTc3LDE5IEBAIGFzbWxpbmthZ2UgaW50IHZwcmludGtfZW1pdChp
bnQgZmFjaWxpdHksIGludCBsZXZlbCwKIAlpZiAoZGljdCkKIAkJbGZsYWdzIHw9IExPR19QUkVG
SVh8TE9HX05FV0xJTkU7CiAKLQlpZiAoIShsZmxhZ3MgJiBMT0dfTkVXTElORSkpIHsKLQkJLyoK
LQkJICogRmx1c2ggdGhlIGNvbmZsaWN0aW5nIGJ1ZmZlci4gQW4gZWFybGllciBuZXdsaW5lIHdh
cyBtaXNzaW5nLAotCQkgKiBvciBhbm90aGVyIHRhc2sgYWxzbyBwcmludHMgY29udGludWF0aW9u
IGxpbmVzLgotCQkgKi8KLQkJaWYgKGNvbnQubGVuICYmIChsZmxhZ3MgJiBMT0dfUFJFRklYIHx8
IGNvbnQub3duZXIgIT0gY3VycmVudCkpCi0JCQljb250X2ZsdXNoKExPR19ORVdMSU5FKTsKLQot
CQkvKiBidWZmZXIgbGluZSBpZiBwb3NzaWJsZSwgb3RoZXJ3aXNlIHN0b3JlIGl0IHJpZ2h0IGF3
YXkgKi8KLQkJaWYgKCFjb250X2FkZChmYWNpbGl0eSwgbGV2ZWwsIHRleHQsIHRleHRfbGVuKSkK
LQkJCWxvZ19zdG9yZShmYWNpbGl0eSwgbGV2ZWwsIGxmbGFncyB8IExPR19DT05ULCAwLAotCQkJ
CSAgZGljdCwgZGljdGxlbiwgdGV4dCwgdGV4dF9sZW4pOwotCX0gZWxzZSB7Ci0JCWJvb2wgc3Rv
cmVkID0gZmFsc2U7Ci0KLQkJLyoKLQkJICogSWYgYW4gZWFybGllciBuZXdsaW5lIHdhcyBtaXNz
aW5nIGFuZCBpdCB3YXMgdGhlIHNhbWUgdGFzaywKLQkJICogZWl0aGVyIG1lcmdlIGl0IHdpdGgg
dGhlIGN1cnJlbnQgYnVmZmVyIGFuZCBmbHVzaCwgb3IgaWYKLQkJICogdGhlcmUgd2FzIGEgcmFj
ZSB3aXRoIGludGVycnVwdHMgKHByZWZpeCA9PSB0cnVlKSB0aGVuIGp1c3QKLQkJICogZmx1c2gg
aXQgb3V0IGFuZCBzdG9yZSB0aGlzIGxpbmUgc2VwYXJhdGVseS4KLQkJICogSWYgdGhlIHByZWNl
ZGluZyBwcmludGsgd2FzIGZyb20gYSBkaWZmZXJlbnQgdGFzayBhbmQgbWlzc2VkCi0JCSAqIGEg
bmV3bGluZSwgZmx1c2ggYW5kIGFwcGVuZCB0aGUgbmV3bGluZS4KLQkJICovCi0JCWlmIChjb250
LmxlbikgewotCQkJaWYgKGNvbnQub3duZXIgPT0gY3VycmVudCAmJiAhKGxmbGFncyAmIExPR19Q
UkVGSVgpKQotCQkJCXN0b3JlZCA9IGNvbnRfYWRkKGZhY2lsaXR5LCBsZXZlbCwgdGV4dCwKLQkJ
CQkJCSAgdGV4dF9sZW4pOworCWlmIChjb250LmxlbikgeworCQlpZiAoY29udC5vd25lciAhPSBj
dXJyZW50IHx8ICEobGZsYWdzICYgTE9HX0NPTlQpKSB7CiAJCQljb250X2ZsdXNoKExPR19ORVdM
SU5FKTsKKwkJCWxmbGFncyAmPSB+TE9HX0NPTlQ7CiAJCX0KLQotCQlpZiAoIXN0b3JlZCkKLQkJ
CWxvZ19zdG9yZShmYWNpbGl0eSwgbGV2ZWwsIGxmbGFncywgMCwKLQkJCQkgIGRpY3QsIGRpY3Rs
ZW4sIHRleHQsIHRleHRfbGVuKTsKIAl9CisKKwkvKgorCSAqIElmIExPR19DT05UIGlzIHNldCwg
dHJ5IHRvIGFkZCB0aGUgbmV3IG1lc3NhZ2UgdG8gYW55IG9sZCBvbmUuCisJICogSWYgdGhhdCBm
YWlscyAtIG9yIExPR19DT05UIHdhc21uJ3Qgc2V0IC0gY3JlYXRlIGEgbmV3IHJlY29yZC4KKwkg
Ki8KKwlpZiAoIShsZmxhZ3MgJiBMT0dfQ09OVCkgfHwgIWNvbnRfYWRkKGZhY2lsaXR5LCBsZXZl
bCwgdGV4dCwgdGV4dF9sZW4pKQorCQlsb2dfc3RvcmUoZmFjaWxpdHksIGxldmVsLCBsZmxhZ3Ms
IDAsIGRpY3QsIGRpY3RsZW4sIHRleHQsIHRleHRfbGVuKTsKIAlwcmludGVkX2xlbiArPSB0ZXh0
X2xlbjsKIAogCS8qCg==
--089e0158a82abea76104f0faf7d6--
