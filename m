Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B310F81ACD
	for <linux-efi@vger.kernel.org>; Sat, 15 Aug 2026 12:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786798642; cv=pass; b=a8kVN2U4zqNVcd6toXc/l0Zgfk8l8sVSHDop8xI2Km3V153oyuh5Dwv4xreVCF5pJiZsd5CE+kKq+G9g+lXMV0SEWVLUvn1YncxcjNgf9/8gD1zKstk8JpLWvcQaRa62ROlLxa+FmIe3uJTtfApnf1xG0aRNikrpRmxxGTlN/fo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786798642; c=relaxed/simple;
	bh=sP6F2/uvrWLFbh29XDtUYXxtW6F0qI7CNC27ZF/fQkU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=nZBmbdCahoEka2Z/7935PwKkymPLBYAFeNFt+p8RsT63PUmYy39Ew0mwRqdBZpfM9NFAsyEYRaC8ybfUEqjHvjJChuhdHOyEqeIm5AYdIrlsReUIsloEGOOD/vShR+Mitiql9jzABd0JTJithzcqfmXyeJxkeJJdT6bGQe9FsyI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IzKh8RFp; arc=pass smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IzKh8RFp"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5b013084dc2so1442796e87.0
        for <linux-efi@vger.kernel.org>; Sat, 15 Aug 2026 05:57:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786798639; cv=none;
        d=google.com; s=arc-20260327;
        b=lIayga+1+zOTpT7Tis5J4Qi297PyKrkYvQ/QEUU7GFEnTgBafWmeEcfwo6kd1Srzqp
         6Qy2ZW+5QcbDSkHZt3Yymgfo0oJyr67nFAV23IedLRJfPqPe8rAlfBtZoeHteOPI23O4
         B0J6xF89qe5cK4j5EG4vTV+Co4xRXO4PqF7U6Kw8W0VkP5rpDZ8dm7JxhwAo+51SGpFT
         viE5c9FiNrhQxPxztrIAcf+WpP+AWxayBFRG4IBnCc3mPWdf1PLKHMEX5bT3idwl6Mys
         lXLsVmzjIX5K5u3g/yChzQ1mkgU78NlpE4HHnB0yOcd4auGFnmkzLX4U4dEKhGlfES8s
         oyGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=Y7HfCIGKUZw6VxvnNnghQLfKVuncFGEPj5RNGPs9KK4=;
        fh=94EFkkp172E/1i+Wpm9h/Ox8pQQX4ycSSRDgd/4xIuo=;
        b=BdC0GX/lG8URAe3q3aB5KI+AzF2zY6bYvY7jt8fxC5MFnPmVGgl3UIaXSnjbz+ie1X
         woA1/poCOuoprW3B5ZpxGkUJP4X0a3EGqMlgJcswZJspH/9WfggrloBqm3FfmtIutQ3e
         Hs6kV8WKjV7p6rbeDyaRpW/wv4E0FEo3ZuKQJ+Tardtf2sauNUBZDLoyC7+WY7TiurVl
         1q75S/ui+6igl7384k+YXFLAKmPwZ9F/Ww1Ctckv7g1ZrONuL+6KxfRmCnnMFju4UBEf
         s/6esngGpkYQ59opfe5zhcIJX2R8dVrwSDP/S0A3r42slh0lbh4kQ/e8MEEEcKv/9/0j
         hHPQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786798639; x=1787403439; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Y7HfCIGKUZw6VxvnNnghQLfKVuncFGEPj5RNGPs9KK4=;
        b=IzKh8RFpcvgfsXI3GkIIc1PPpF0gAB+4lz8tBQcC17lZJVSrFcZg9rUxoGaNYgrR9S
         i5gwc8no1iMEoFQ6O8Y2xgz+5UmVggTKa4jlAMDGJFMl2G1eoFLHfdCITIGfIaDx3nkH
         E8y5+Y/2VRfOQylQjiujLJe/BOQxvJw1NrAKdwuHPhTM6B5BlK0AHCr4w7OT2+3WH9mY
         mYADglIokP6GOR1ewfyNPGIKQgOvOywrJFcXggVWduStgCICssy3ejo7AbsaCRa6zP+U
         k6mnjS1E7ElWCrsj0wOr0NIFpN60LPpgFckCyksiI8OMB2qqF6chiRd83w6xV9o+2sG+
         OQTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786798639; x=1787403439;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y7HfCIGKUZw6VxvnNnghQLfKVuncFGEPj5RNGPs9KK4=;
        b=b+owAEF1e87KtH/uyrnV74iOpTr335qSyOvShu1PsJW0N+N7VLNxcyOtxsIrSBYeg5
         SMwr0vXwu7o0U0M5nHNLhFfTpHKKpGsaao5QFO3QPSYr1IIIanwFV13MQUlyJmAWHW9w
         DZkp+TPzJh490OegH8ggigNtdaNaPI4IuAcJUz/NaMUrMg3pAbqp3RATQdTaNXu3dDZT
         MjgpDQ5etXNm/7zUkmszsLX57BXbyAvczjMpmhHl/hdSvl8x5DqkYTHR0bIui99opGS0
         Nt1GcdnOVHmgb8DrFHTR+sHPZoGNgcZBPEHSTe7BrzgKggMSQglNXK7BVmHb8VvEQJQo
         8OYg==
X-Gm-Message-State: AOJu0YwL5TIV5vSJOFfBQ+kXSUJozUDYVLFG531wAMi37O2VWXmf0Qsj
	Ezqa8i9O3NOWDaI0YWP1HPY7/FTKdHYO8ooe3BK4uVWOOyX+Js5/+Ov5Fdvk64WbqvF6oBTXolN
	ANdJhPPVf3kmXaG9jyHzg2ggvJc/gHCNLANjr
X-Gm-Gg: AR+sD10siMlIkbb3R8PIKhwtxMxbLhxtWk7sJAFcDVx5DqQ+071c4yB7K5EJCklHvYr
	26OFOwTie50GOWIv6dGmEJklxzEYae5Sb2NMhRUAskYmSbz78bo7nywUU6gHZau+04t/5tVKyTI
	KRKO2yTnGKmPkoreYDcq+whbmREfky5FhCFMJt4GugeM8jsePlNxKN+UZ3ZIV6uWEANQ5llXgBE
	tE8tEEz4yn+G70Ud58d9wMFREyQ3YP0D6B6WtJDzUk95K1MVNsS+AefuKenO8n+5XbviFVcdMAm
	fiLpOiy96vtUoAVlYILrNo/Op9pyb3bdgSeAvMoitJq0IzdOVsBK+hFrzYobe4BhqGHX6olNQMo
	CjQA=
X-Received: by 2002:a05:6512:110a:b0:5b0:12e1:4846 with SMTP id
 2adb3069b0e04-5b459182852mr1731479e87.29.1786798638522; Sat, 15 Aug 2026
 05:57:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Brian Heise <bnheise@gmail.com>
Date: Sat, 15 Aug 2026 22:03:28 +0900
X-Gm-Features: AUfX_mxRHnm7wjtTc494fxDJBqBJ6PcbvHnWmHr35fMLvPaxG68pd1je8OiSNeg
Message-ID: <CAMSzGnHQMvZ9h27Fkcy-xVW8C6oH1DJMd4z+R4LkWeDJJUH+Cg@mail.gmail.com>
Subject: [PATCH] efi/x86: early EFI poweroff quirk for Clevo/MouseComputer V650AU
To: linux-efi@vger.kernel.org
Content-Type: multipart/mixed; boundary="0000000000002282d70659157a6f"

--0000000000002282d70659157a6f
Content-Type: multipart/alternative; boundary="0000000000002282d60659157a6d"

--0000000000002282d60659157a6d
Content-Type: text/plain; charset="UTF-8"

Hello,

On MouseComputer/Clevo V650AU (Insyde 1.07.12rRUN), systemctl poweroff
completes OS shutdown but the machine stays powered (LED on; long-press
needed). Reboot works.

ACPI S5 and late EFI_RESET_SHUTDOWN (sys-off after device_shutdown) both
fail. Early EFI_RESET_SHUTDOWN before device_shutdown fully cuts power
(validated with a probe module, then with this quirk).

This registers a DMI-gated reboot notifier (DMI_BOARD_NAME "V650AU") that
issues EFI_RESET_SHUTDOWN on SYS_POWER_OFF.

*AI use disclosure.*

I have no experience in kernel development.
I own a MouseComputer/Clevo V650AU (Insyde 1.07.12rRUN) and have
experienced this problem.
I solved the issue using an AI agent, but have verified that the solution
works on my own machine.

Best regards,
Brian N. Heise

--0000000000002282d60659157a6d
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello,<br><br>On MouseComputer/Clevo V650AU (Insyde 1.07.1=
2rRUN), systemctl poweroff<br>completes OS shutdown but the machine stays p=
owered (LED on; long-press<br>needed). Reboot works.<br><br>ACPI S5 and lat=
e EFI_RESET_SHUTDOWN (sys-off after device_shutdown) both<br>fail. Early EF=
I_RESET_SHUTDOWN before device_shutdown fully cuts power<br>(validated with=
 a probe module, then with this quirk).<br><br>This registers a DMI-gated r=
eboot notifier (DMI_BOARD_NAME &quot;V650AU&quot;) that<br>issues EFI_RESET=
_SHUTDOWN on SYS_POWER_OFF.<br><br><b>AI use=C2=A0disclosure.</b><br><br>I =
have no experience in kernel development.<br>I own a MouseComputer/Clevo V6=
50AU (Insyde 1.07.12rRUN) and have experienced this problem.<br>I solved th=
e issue using an AI agent, but have verified that the solution works on my =
own machine.<br><br>Best regards,<br>Brian N. Heise</div>

--0000000000002282d60659157a6d--
--0000000000002282d70659157a6f
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-efi-x86-early-EFI-poweroff-quirk-for-Clevo-MouseComp.patch"
Content-Disposition: attachment; 
	filename="0001-efi-x86-early-EFI-poweroff-quirk-for-Clevo-MouseComp.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_msudwjhh0>
X-Attachment-Id: f_msudwjhh0

RnJvbSBkN2Y1Y2VkOThlZDg1YjI0YjQ1OTI3ZjY1YjI5ZDJjZTU5YmY4MTBhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBCcmlhbiBIZWlzZSA8Ym5oZWlzZUBnbWFpbC5jb20+CkRhdGU6
IFNhdCwgMTUgQXVnIDIwMjYgMjE6NDM6NDUgKzA5MDAKU3ViamVjdDogW1BBVENIXSBlZmkveDg2
OiBlYXJseSBFRkkgcG93ZXJvZmYgcXVpcmsgZm9yIENsZXZvL01vdXNlQ29tcHV0ZXIKIFY2NTBB
VQoKQUNQSSBTNSBhbmQgbGF0ZSBFRkkgUmVzZXRTeXN0ZW0oU0hVVERPV04pIChhZnRlciBkZXZp
Y2Vfc2h1dGRvd24pCmxlYXZlIHRoaXMgSW5zeWRlIGZpcm13YXJlIHBvd2VyZWQgb24uIENhbGxp
bmcgRUZJX1JFU0VUX1NIVVRET1dOIGZyb20KYSByZWJvb3Qgbm90aWZpZXIsIGJlZm9yZSBkZXZp
Y2Vfc2h1dGRvd24sIGZ1bGx5IGN1dHMgcG93ZXIuIE1hdGNoIG9uCkRNSV9CT0FSRF9OQU1FIFY2
NTBBVSBzbyBNb3VzZUNvbXB1dGVyIGFuZCBvdGhlciBDbGV2byB3aGl0ZS1sYWJlbHMKYXJlIGNv
dmVyZWQuCgotLS0KIGFyY2gveDg2L3BsYXRmb3JtL2VmaS9xdWlya3MuYyB8IDQ1ICsrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCA0NSBpbnNlcnRpb25z
KCspCgpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvcGxhdGZvcm0vZWZpL3F1aXJrcy5jIGIvYXJjaC94
ODYvcGxhdGZvcm0vZWZpL3F1aXJrcy5jCmluZGV4IDkwYTA2NWZjYi4uNmM0MjI2ZDU2IDEwMDY0
NAotLS0gYS9hcmNoL3g4Ni9wbGF0Zm9ybS9lZmkvcXVpcmtzLmMKKysrIGIvYXJjaC94ODYvcGxh
dGZvcm0vZWZpL3F1aXJrcy5jCkBAIC0xMSw2ICsxMSw3IEBACiAjaW5jbHVkZSA8bGludXgvbWVt
YmxvY2suaD4KICNpbmNsdWRlIDxsaW51eC9hY3BpLmg+CiAjaW5jbHVkZSA8bGludXgvZG1pLmg+
CisjaW5jbHVkZSA8bGludXgvcmVib290Lmg+CiAKICNpbmNsdWRlIDxhc20vZTgyMC9hcGkuaD4K
ICNpbmNsdWRlIDxhc20vZWZpLmg+CkBAIC02NjAsNiArNjYxLDUwIEBAIGJvb2wgZWZpX3Bvd2Vy
b2ZmX3JlcXVpcmVkKHZvaWQpCiAJcmV0dXJuIGFjcGlfZ2JsX3JlZHVjZWRfaGFyZHdhcmUgfHwg
YWNwaV9ub19zNTsKIH0KIAorLyoKKyAqIE1vdXNlQ29tcHV0ZXIvQ2xldm8gVjY1MEFVIChJbnN5
ZGUpOiBBQ1BJIFM1IGFuZCBFRkkgUmVzZXRTeXN0ZW0gYWZ0ZXIKKyAqIGRldmljZV9zaHV0ZG93
bigpIGxlYXZlIHRoZSBzeXN0ZW0gcG93ZXJlZCBvbi4gRUZJX1JFU0VUX1NIVVRET1dOIHdvcmtz
CisgKiB3aGVuIGludm9rZWQgZnJvbSBhIHJlYm9vdCBub3RpZmllciwgd2hpY2ggcnVucyBiZWZv
cmUgZGV2aWNlX3NodXRkb3duKCkuCisgKi8KK3N0YXRpYyBjb25zdCBzdHJ1Y3QgZG1pX3N5c3Rl
bV9pZCBlZmlfZWFybHlfcG93ZXJvZmZfZG1pX3RhYmxlW10gX19pbml0Y29uc3QgPSB7CisJewor
CQkubWF0Y2hlcyA9IHsKKwkJCURNSV9NQVRDSChETUlfQk9BUkRfTkFNRSwgIlY2NTBBVSIpLAor
CQl9LAorCX0sCisJeyB9Cit9OworCitzdGF0aWMgaW50IGVmaV9lYXJseV9wb3dlcm9mZl9ub3Rp
Znkoc3RydWN0IG5vdGlmaWVyX2Jsb2NrICpuYiwKKwkJCQkgICAgdW5zaWduZWQgbG9uZyBtb2Rl
LCB2b2lkICp1bnVzZWQpCit7CisJaWYgKG1vZGUgIT0gU1lTX1BPV0VSX09GRikKKwkJcmV0dXJu
IE5PVElGWV9ET05FOworCisJaWYgKCFlZmlfcnRfc2VydmljZXNfc3VwcG9ydGVkKEVGSV9SVF9T
VVBQT1JURURfUkVTRVRfU1lTVEVNKSkKKwkJcmV0dXJuIE5PVElGWV9ET05FOworCisJcHJfaW5m
bygiVjY1MEFVOiBFRkkgUmVzZXRTeXN0ZW0oU0hVVERPV04pIGJlZm9yZSBkZXZpY2Ugc2h1dGRv
d25cbiIpOworCWVmaS5yZXNldF9zeXN0ZW0oRUZJX1JFU0VUX1NIVVRET1dOLCBFRklfU1VDQ0VT
UywgMCwgTlVMTCk7CisKKwlyZXR1cm4gTk9USUZZX0RPTkU7Cit9CisKK3N0YXRpYyBzdHJ1Y3Qg
bm90aWZpZXJfYmxvY2sgZWZpX2Vhcmx5X3Bvd2Vyb2ZmX25iID0geworCS5ub3RpZmllcl9jYWxs
ID0gZWZpX2Vhcmx5X3Bvd2Vyb2ZmX25vdGlmeSwKK307CisKK3N0YXRpYyBpbnQgX19pbml0IGVm
aV9lYXJseV9wb3dlcm9mZl9xdWlyayh2b2lkKQoreworCWlmICghZG1pX2NoZWNrX3N5c3RlbShl
ZmlfZWFybHlfcG93ZXJvZmZfZG1pX3RhYmxlKSkKKwkJcmV0dXJuIDA7CisKKwlyZWdpc3Rlcl9y
ZWJvb3Rfbm90aWZpZXIoJmVmaV9lYXJseV9wb3dlcm9mZl9uYik7CisJcHJfaW5mbygiVjY1MEFV
OiByZWdpc3RlcmVkIGVhcmx5IEVGSSBwb3dlci1vZmYgcXVpcmtcbiIpOworCXJldHVybiAwOwor
fQorbGF0ZV9pbml0Y2FsbChlZmlfZWFybHlfcG93ZXJvZmZfcXVpcmspOworCiAjaWZkZWYgQ09O
RklHX0VGSV9DQVBTVUxFX1FVSVJLX1FVQVJLX0NTSAogCiBzdGF0aWMgaW50IHFya19jYXBzdWxl
X3NldHVwX2luZm8oc3RydWN0IGNhcHN1bGVfaW5mbyAqY2FwX2luZm8sIHZvaWQgKipwa2J1ZmYs
Ci0tIAoyLjU1LjAKCg==
--0000000000002282d70659157a6f--
