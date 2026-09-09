Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45FE4446EB;
	Wed,  9 Sep 2026 07:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788939186; cv=none; b=RJw9fRSESsRprRL0tTQ/pcySQP4UNvIiWyl6nQBwlwZNRflEaX6OLtJRJAqbUlRs8UTdeZPA+llVo3A+0IkV8OxxVZ/qn4UhmI5XJjgW3k+IPkiDphUh5CK/co24/yC1MtOBeTimczm40c00cL7xUpE/b48Avnqop5+jA9LSbyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788939186; c=relaxed/simple;
	bh=4dp9P7zMf1kmIOJvCczVvfd0hWwh3QK8j1GoJ2q/120=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=f7SFlu1uNUdNndbxGcI4O4+vBRhkFSNSrLCKmAjYgNzzWlDku2aHpyKPwiH25jWvu11hHWWemONS+yyU7pTpTWXGUg5PX3kQH7m2FxEzd4PKfampFpCn7NK3mlL3+N63U4WqaKOHJJr/TbRzhIwK2UFvX81y8F4GsNq3GGSLS6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dFyZDWfh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dFyZDWfh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACAB41F00A3D;
	Wed,  9 Sep 2026 07:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788939180;
	bh=J//cColF7UDPlCDzxIpKN6p09YxZE/F/nlsaZQOfie4=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=dFyZDWfh72agHfQ/oFBm00F+Pr+kHPgeIBLZOiDj4q6E9X+9R5mslQETq8bPWzEwQ
	 ztktB5ZB5TfPmAYBTepVekwjkPrGKsIXnKgwIPgi5LUf06p/zOoHPUXPqCt4LPdlvw
	 pyURfgMVNDpNCVMzNC/iE5uUKU02TEXszV9SVY/HBVZeZeZCMTTujlLNnQC5stSbaw
	 GNA4prvvntr3/TL5TysphPjhWdlDQiGM6UfoS4ykzDKzHylbP+lzfSwHqEDxpQwyUz
	 kID2EI3Rd+/+H3qEVVL9aqQHnB4rzcEYgi6QasgVnUt+QShWO5ui1M3vllXlmJSyVN
	 HEQlv+sh1L0Gw==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id F2D531980047;
	Wed,  9 Sep 2026 03:32:57 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Wed, 09 Sep 2026 03:32:57 -0400
X-ME-Sender: <xms:qAuhauiXM8AS2_zh2eaUg3jaISbLLs6RCfi4tntaip-5FGu7mgmL3g>
    <xme:qAuhap3x4EVKvKnb4Z6r84Ty8pD9M4tb6xOZyXctAVuy05ssq_DLtupqUl2Nf7zgN
    m6no_JRZ1Xkze-WGpG5AJ8Ten01MnO4JJQfOV-Pfw6OzqogB-hk4wQ>
X-ME-Proxy-Cause: dmFkZTEJSPnRXpm6fDYjmhwLX6fYdYgX6HfODcnetoBK+m9sozmkGDCNzVybDAL1VtABcQ
    DkgRPEZeRL5W321m1KSx6WccnGYiZ11mJyP/boB7hWCpT3Ivegui7oaQSnpPjbAYpkVMNS
    i2PRp84fAEa53+xoO4K31AQeYM5grfIaPIH6QInU9+P/3OpgJmHGVDkAp/YWZCpOKiMrtE
    vrOUPDneoedCxUJryraz8ApesYg0BuyPGgqd4jg93m6cTGW1p6MRUb4WSvRK35Bhtgds1D
    aXlQ2UHHcDqj8BNd2/f1ZsSy9Ak2jUoHO1n/X/mKle25dSrFlA4V1Hvy+o0WMO1x2D8OnS
    PQPQgGQHMyIkg4goYdyHNa4lYRuQm5hqjAGsDbEUYBv/z4V+vEJIgsj5NNDw11pwW37MOb
    jFxHihzoqhOkALiS85VsZHxoSr8NB/MZnRs2fj39OT9YJNv69w/2cIHdW3wxcw7JKOdbm5
    gLE3vYijkgABCHMScIbyU8yv5mK3SCXr9GSgBWtbcm5wLN8t29+DLFlyGA7Qc/gJEu6Qyb
    GIDma07urBu3h2wqTsN5PQChFYUtcNWlcJ5nRWUuSqrRSCJXpj+Z3SkYtgIZ8/lFql5jEy
    +N1er02RfSs0BMscz+P1Ei2I39ePUx8rHhprgy36ZLBrQ4OSHHnHZD8kYG4A
X-ME-Proxy: <xmx:qQuhakIyfnURocqJHdKKBm2yFM70TOpTl79QjiS8JYaVXDarF2ZhZg>
    <xmx:qQuhavn_UEeBh_VOBX0LidXp2KanP0diUbHJ7wXQ8XW47OwuSwmPvg>
    <xmx:qQuhaoPG7ZKOjBpilY51Jf1Ap-YxfUuK8xsC2EM8fdJIUDCcUVL1SQ>
    <xmx:qQuhal0eiOWiqluZPwlOAsZkqWC-K0q0Dwn6RaZOnAtEw8D2GcY_Uw>
    <xmx:qQuhankOC01s2ARFrdsEDHu6JoLe8ve9MtdgIWARohp_OXohjdZ-sFwC>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 974A1F8007E; Wed,  9 Sep 2026 03:32:56 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 09 Sep 2026 09:32:34 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Vincent Mailhol" <mailhol@kernel.org>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Message-Id: <e66a0ac8-7bb8-4f1a-b05c-7cb28b61814e@app.fastmail.com>
In-Reply-To: <2c7c1cfe-3ed7-468d-9056-8d7e77d15a5a@kernel.org>
References: <20260906-efi_stub_bli-v3-1-e7dc0d6b8fcd@kernel.org>
 <2c7c1cfe-3ed7-468d-9056-8d7e77d15a5a@kernel.org>
Subject: Re: [PATCH v3] efi/libstub: add initial Boot Loader Interface support
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



On Tue, 8 Sep 2026, at 20:48, Vincent Mailhol wrote:
> On 06/09/2026 at 23:52, Vincent Mailhol wrote:
>> The Boot Loader Interface (BLI) [1] defines EFI variables that expose
>> boot loader state to the running OS. LoaderInfo identifies the boot
>> loader, while LoaderDevicePartUUID records the GPT partition UUID of
>> the partition containing it.
>>=20
>> LoaderDevicePartUUID is used, for example, by systemd-gpt-auto-genera=
tor
>> [2] to identify the disk the boot loader was launched from and
>> automatically detect and mount partitions on it.
>>=20
>> GRUB [3] and systemd-boot [4] populate these variables, but when the
>> kernel is started directly by EFI firmware, there is no conventional
>> external boot loader to provide them. In that case, because the EFI s=
tub
>> performs the boot loader role, it should provide the variables itself.
>>=20
>> Use LoaderInfo as a sentinel: if it is already set by an earlier boot
>> stage or cannot be set, bail out. Otherwise, populate the other BLI
>> variables.
>>=20
>> Parse the loaded image device path, extract the GUID signature from i=
ts
>> GPT HD() node and publish it under the Linux loader entry vendor GUID=
 as
>> the volatile LoaderDevicePartUUID EFI variable.
>>=20
>> Install the efi_bli_set_variables() hook in both the generic efi-stub=
.c
>> path and the x86-specific x86-stub.c path.
>>=20
>> [1] The Boot Loader Interface
>> Link: https://systemd.io/BOOT_LOADER_INTERFACE/
>>=20
>> [2] systemd-gpt-auto-generator
>> Link: https://www.freedesktop.org/software/systemd/man/latest/systemd=
-gpt-auto-generator.html
>>=20
>> [3] GRUB -- =C2=A716.2 bli
>> Link: https://www.gnu.org/software/grub/manual/grub/html_node/bli_005=
fmodule.html
>>=20
>> [4] systemd -- systemd-boot UEFI Boot Manager
>> Link: https://github.com/systemd/systemd/blob/main/docs/BOOT.md?plain=
=3D1#L102
>>=20
>> Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
>> ---
>
> (...)
>
>> +static void efi_bli_populate_loader_part_uuid(efi_loaded_image_t *im=
age)
>> +{
>> +	static efi_guid_t device_path_guid =3D EFI_DEVICE_PATH_PROTOCOL_GUI=
D;
>> +	efi_char16_t partuuid[UUID_STRING_LEN + 1];
>> +	const struct efi_hd_dev_path *hd_node;
>> +	const struct efi_dev_path *path;
>> +
>> +	if (efi_bs_call(handle_protocol, efi_table_attr(image, device_handl=
e),
>> +			&device_path_guid, (void **)&path) !=3D EFI_SUCCESS)
>> +		return;
>> +
>> +	hd_node =3D efi_bli_find_hd_node(path);
>> +	if (!hd_node)
>> +		return;
>> +
>> +	if (efi_snprintf(partuuid, ARRAY_SIZE(partuuid), "%pUl",
>> +			 hd_node->signature.b) !=3D UUID_STRING_LEN)
>                          ^^^^^^^^^^^^^^^^^^^^
> I just realize that there is a small mistake here. Conceptually
> speaking, %pUl expects a pointer to a efi_guid_t. Of course, because of
> the function being variadic, no type enforcement is done and the
> compiler is happy with hd_node->signature.b which is an u8 array.
>
> But the clean approach is definitely:
>
> 	if (efi_snprintf(partuuid, ARRAY_SIZE(partuuid), "%pUl",
> 			 &hd_node->signature) !=3D UUID_STRING_LEN)
>
> @Ard, do you want me to send a v4, or can you just fix while applying?
>

I'll fix that up.


>> +		return;
>> +
>> +	set_efi_var(L"LoaderDevicePartUUID", &loader_entry_guid,
>> +		    EFI_VARIABLE_BOOTSERVICE_ACCESS | EFI_VARIABLE_RUNTIME_ACCESS,
>> +		    sizeof(partuuid), partuuid);
>> +}
>
> (...)
>
>
> Yours sincerely,
> Vincent Mailhol
