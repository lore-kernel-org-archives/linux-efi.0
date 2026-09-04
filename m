Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83ADD3C343A
	for <linux-efi@vger.kernel.org>; Fri,  4 Sep 2026 16:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788538369; cv=none; b=hEDujJBt1NVt+bii04EOifeBdHUk38/xdyIOh8RRS7Ft9TtgrZlsTmgEh35I74bufG49fi+0sIB0hUqdmDfwDg0OTf/z5V+bgmzKZvCS1/W9IyaD6trLBpP1OUxhPJKiAD0AvH/Y0q1TGVSzoBuuewnlvpIYBPskARU2P1Hs33A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788538369; c=relaxed/simple;
	bh=pclvjhkWdx2l5y8SigKnZlyVMnkDbtgIYrs9zx/k0As=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=DkC6ygzgQZa2tjrEsxaHJuw9x/YlePnafOjFGQQQuWrTvoAUUKst0qwaxfQZGQOqk0yCB/tAxFNhW0v663LWvVodVICRXEsBcFtc4Le9C8bZTJ3KgCxf9VnQ8Rz130lLWk0EFa39HoR7aB8mU8cmP1AcNsjVyegWQSX8yxrsfY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M1X7UpMK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M1X7UpMK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8C51F00A3D
	for <linux-efi@vger.kernel.org>; Fri,  4 Sep 2026 16:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788538367;
	bh=Tx4FSL0xIECpStHwWMeG7pCiramumKr1DxDWcpd+ZD4=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=M1X7UpMKu+WZccXjj9Ox5fDHVG3x89pTTI5FbovHeJ97kNV3SvurUvOwS9e+yY8Qv
	 ezVAfT752FKBu1dMeDdj75hQNE+VhOD7vQb1VLozz/qZhoH+ub6StZKf0eeT9y0mIJ
	 LBtPImX36OVbiEySCYazWTDOCKW9VpdwmPCxM0T0JM4mKCm6pmBKwIOq6O7/PfcX/y
	 AH98wdOi2WrOpOV4M7OZ3d0lVnsf6lSTQcvoOSoGRJ+IlnqfUz9bw8U8KuSL1Kvpnf
	 ZIo5aR2VDbpAxoYTTtOnTLIxLG6amci9XdZfWQMPiKqWgUznNllyy8uvw3FouURjBN
	 KG9KdvamnW1Ug==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 8EAD0198003A;
	Fri,  4 Sep 2026 12:12:45 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 04 Sep 2026 12:12:45 -0400
X-ME-Sender: <xms:_O2aahRxh26uF1bMKRXOmqdfD0zkjbDLxfcdjYno6g921YSerHw1Rw>
    <xme:_O2aalnxQTHJ4NNCSXB0VPyoP7l2waVpwgvQunc1wr4Pb9eszJmPSKAfSgBmCEyul
    ZBthS79LwZOS6s5Vfuz5XSVp1B57JjSoF1--PypY6dXeD76GKPKmko>
X-ME-Proxy-Cause: dmFkZTGqZnL+EXqDbtRnAFkqMd9o0zr3eGA1q6dfym1uyUF67npM/rh9NVye5yo+tlnLH+
    a2A2Xry8vfw/tAHBeOl2KjF7rouvat78Bsc1llX6G3Tl6iKdttmSwVCc0BLJqg8bmEenJq
    b3hztACw0jZWBzoWkJzmdljDW8+lXWEfavdnM/hxk1DnuZImRSRglEwhfwFTpdzB+Hf4ZA
    sK7oLpF18UaVSCIXZMrYPp6wN6YQwZYWqPH28iNaANXaFWibigkmrojjjLmI5EZQBfQSCx
    p8GSZ14R574opVfqwxIPlNKBQ7IefbwdEUm4YS0evVU7B3dyY0mh9qymFtuH5bwu3zj9Pr
    pBzusP9KJkTu6a+JViLN3LtQ9nWEhrNI2gJ4qwXsEZ2eLoWSsoTN7mG0cQs+42eJRY8FE8
    RUonpM4UEpPSDjs0uouQoKpU8972Veo7ayaXCrDS7QupzorqsZAc5dn+KQi7rQRchVarRG
    J4LJveEMb2UN9F0c3O5C7KsZpawmKPg+bHLOBmfG6N4mXxQDoGwo6E7PyDb21Acx02S41O
    3jKWf0I1Kzdw16ATcSi6nVJGhKreucfRjU8qrM33gGWLikn+SlCDvapjtJDV0WPUSDZnpR
    wB6gLK/7YCV13MW8MbcQF07y8hS2thLvZHS9/h/TNUGh9VRxJk3jqxa9PwVQ
X-ME-Proxy: <xmx:_e2aao66_7-kiH6GRwBWnqSiFg03Ki0Ot-hMVibQ_cWaJCF3JLVTig>
    <xmx:_e2aalVQ_O7l3qGKgye8rDrFx2sPFO8XxOUNayIOfQ-sa0XSTYzE_Q>
    <xmx:_e2aaq-l4b0jzeaSb1pVJZ9SJyzBfPsSifHQ2GorEVezdi24Y0WXQg>
    <xmx:_e2aahmsby4xdd9qfZfJpjMMUo1B0xPAkf9VudBqyJk6pPyHfY01jQ>
    <xmx:_e2aaoVPSRJKHiLdhBGVv_8C3-sIUwVqKP48Kv6fXcG5PAd4zATR1iiP>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 26FD3F8007A; Fri,  4 Sep 2026 12:12:44 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 04 Sep 2026 18:12:23 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Vincent Mailhol" <mailhol@kernel.org>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Message-Id: <b3982808-5ae5-48b8-a677-9f284a764685@app.fastmail.com>
In-Reply-To: <20260903-efi_stub_bli-v2-1-dbf7ba915117@kernel.org>
References: <20260903-efi_stub_bli-v2-1-dbf7ba915117@kernel.org>
Subject: Re: [PATCH v2] efi/libstub: populate LoaderDevicePartUUID
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello Vincent,

On Thu, 3 Sep 2026, at 23:19, Vincent Mailhol wrote:
> The Boot Loader Interface [1] defines LoaderDevicePartUUID. That EFI
> variable records the GPT partition UUID of the partition containing the
> boot loader.
>
> This is used, for example, by systemd-gpt-auto-generator [2] to identi=
fy
> the disk the boot loader was launched from and automatically detect and
> mount partitions on it.
>
> GRUB [3] and systemd-boot [4] populate it, but when the kernel is
> started directly by EFI firmware, there is no conventional external bo=
ot
> loader to provide the variable. In that case, because the EFI stub
> performs the boot loader role, it should provide the variable itself.
>

Fair enough.

But shouldn't it set LoaderInfo as well then?

> Parse the loaded image device path, extract the GUID signature from its
> GPT HD() node and publish it under the Linux loader entry vendor GUID =
as
> the volatile LoaderDevicePartUUID EFI variable. Do not overwrite an
> existing variable, so a value supplied by an earlier boot stage keeps
> precedence.
>
> Install the efi_bli_set_variables() hook in both the generic efi-stub.c
> path and the x86-specific x86-stub.c path.
>
> Add CONFIG_EFI_STUB_BLI to make this new feature configurable.
>

I don't think this is needed tbh. Better to enable this unconditionally
so we can rely on this being present in the longer term.

> For an x86_64 build using gcc 15.3.0, bloat-o-meter reports the
> following difference between builds without and with CONFIG_EFI_STUB_B=
LI:
>
>   add/remove: 5/0 grow/shrink: 1/0 up/down: 639/0 (639)
>   Function                                     old     new   delta
>   efi_bli_set_variables                          -     563    +563
>   loader_entry_guid                              -      16     +16
>   hex                                            -      16     +16
>   guid_index                                     -      16     +16
>   device_path_guid                               -      16     +16
>   efi_stub_entry                              4180    4192     +12
>   Total: Before=3D29223, After=3D29862, chg +2.19%
>
> [1] The Boot Loader Interface
> Link: https://systemd.io/BOOT_LOADER_INTERFACE/
>
> [2] systemd-gpt-auto-generator
> Link:=20
> https://www.freedesktop.org/software/systemd/man/latest/systemd-gpt-au=
to-generator.html
>
> [3] GRUB -- =C2=A716.2 bli
> Link:=20
> https://www.gnu.org/software/grub/manual/grub/html_node/bli_005fmodule=
.html
>
> [4] systemd -- systemd-boot UEFI Boot Manager
> Link: https://github.com/systemd/systemd/blob/main/docs/BOOT.md?plain=3D=
1#L111
>
> Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
> ---
> Changes in v2:
>
>   - Add CONFIG_EFI_STUB_BLI to make the BLI feature optional.
>
>   - Use static storage for GUID initializers. This reduces the size by
>     about 10% compared to v1.
>
>   - Remove the redundant NULL check on image.
>
>   - Move the nibble-to-ASCII-hex conversion out of efi_bli_guid_to_str=
()
>     into the new efi_bli_nibble_to_hex().
>
>   - Rename variables to be closer to the EFI specification.
>
> Link to v1:=20
> https://lore.kernel.org/r/20260725-efi_stub_bli-v1-1-966e4748077f@kern=
el.org
> ---
>  drivers/firmware/efi/Kconfig            |  15 +++++
>  drivers/firmware/efi/libstub/Makefile   |   2 +
>  drivers/firmware/efi/libstub/bli.c      | 114=20
> ++++++++++++++++++++++++++++++++
>  drivers/firmware/efi/libstub/efi-stub.c |   1 +
>  drivers/firmware/efi/libstub/efistub.h  |   6 ++
>  drivers/firmware/efi/libstub/x86-stub.c |   1 +
>  6 files changed, 139 insertions(+)
>
> diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconf=
ig
> index 29e0729299f5..eff7c6164096 100644
> --- a/drivers/firmware/efi/Kconfig
> +++ b/drivers/firmware/efi/Kconfig
> @@ -100,6 +100,21 @@ config EFI_ARMSTUB_DTB_LOADER
>  	  functionality for bootloaders that do not have such support
>  	  this option is necessary.
>=20
> +config EFI_STUB_BLI
> +	bool "EFI stub Boot Loader Interface support"
> +	depends on EFI_STUB
> +	default y
> +	help
> +	  The Boot Loader Interface defines EFI variables that expose
> +	  information about the boot loader to the running OS.
> +
> +	  Enable this option to let the EFI stub populate the volatile
> +	  LoaderDevicePartUUID EFI variable when it is missing. This allows
> +	  user space services such as systemd-gpt-auto-generator to discover
> +	  partitions on the disk from which the kernel was loaded.
> +
> +	  If unsure, say Y.
> +
>  config EFI_BOOTLOADER_CONTROL
>  	tristate "EFI Bootloader Control"
>  	select UCS2_STRING
> diff --git a/drivers/firmware/efi/libstub/Makefile=20
> b/drivers/firmware/efi/libstub/Makefile
> index 77a2b2d74f3f..000a73a4bc52 100644
> --- a/drivers/firmware/efi/libstub/Makefile
> +++ b/drivers/firmware/efi/libstub/Makefile
> @@ -75,6 +75,8 @@ libfdt-deps			:=3D fdt_rw.c fdt_ro.c fdt_wip.c fdt.c=
 \
>  lib-$(CONFIG_EFI_PARAMS_FROM_FDT) +=3D fdt.o \
>  				     $(patsubst %.c,lib-%.o,$(libfdt-deps))
>=20
> +lib-$(CONFIG_EFI_STUB_BLI)	+=3D bli.o
> +
>  $(obj)/lib-%.o: $(srctree)/lib/%.c FORCE
>  	$(call if_changed_rule,cc_o_c)
>=20
> diff --git a/drivers/firmware/efi/libstub/bli.c=20
> b/drivers/firmware/efi/libstub/bli.c
> new file mode 100644
> index 000000000000..d54eb42729a7
> --- /dev/null
> +++ b/drivers/firmware/efi/libstub/bli.c
> @@ -0,0 +1,114 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/efi.h>
> +#include <linux/errno.h>
> +#include <linux/unaligned.h>
> +
> +#include "efistub.h"
> +
> +struct efi_hd_dev_path {
> +	struct efi_generic_dev_path header;
> +	u32 partition_number;
> +	u64 partition_start;
> +	u64 partition_size;
> +	efi_guid_t signature;
> +	u8 partition_format;
> +	u8 signature_type;
> +} __packed;
> +

Please add this to linux/efi.h and add it to the union
in struct efi_dev_path as well.

> +#define EFI_HD_PARTITION_FORMAT_GPT	2
> +#define EFI_HD_SIGNATURE_TYPE_GUID	2
> +

These too

> +static efi_char16_t efi_bli_nibble_to_hex(u8 nibble)
> +{
> +	static const char hex[16] __nonstring =3D "0123456789abcdef";
> +
> +	return hex[nibble];
> +}
> +
> +static void efi_bli_guid_to_str(const efi_guid_t *guid, efi_char16_t=20
> *out)
> +{
> +	static const u8 guid_index[UUID_SIZE] =3D {
> +		3, 2, 1, 0, 5, 4, 7, 6, 8, 9, 10, 11, 12, 13, 14, 15,
> +	};
> +
> +	for (int i =3D 0; i < ARRAY_SIZE(guid_index); i++) {
> +		u8 byte =3D guid->b[guid_index[i]];
> +
> +		*out++ =3D efi_bli_nibble_to_hex(byte >> 4);
> +		*out++ =3D efi_bli_nibble_to_hex(byte & 0xf);
> +
> +		switch (i) {
> +		case 3:
> +		case 5:
> +		case 7:
> +		case 9:
> +			*out++ =3D L'-';
> +		}
> +	}
> +
> +	*out =3D L'\0';
> +}
> +

I'm reluctant to add this kind of code as a special one-off, so I got a
bit carried away and took this code and put it in the stub's printf
layer.

Could you please check whether the first two patches at [0] are
sufficient for efi_bli_guid_to_str() to be replaced by a simple
efi_snprintf("%pUl", ...) call here?


--=20
Ard.


[0] https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?=
h=3Defi-libstub-native-utf16

