Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CF03F86F0;
	Mon, 10 Aug 2026 16:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786378790; cv=none; b=WsqG+FawTWhh5GrnvinAIBEv4pFf0Fa6WnVTRz9UevAh5ur8GQGetv+0I5zAfn8goHd2XI8jyOjCCGxiqOsIqnXD77eOQ9T0WL3azhM/ctkwggYbwj58hH7IDCBWLWWdNrkYbXpvfaLi1QQiBJJkbFtlRZcCrnHH0AQD49qsFVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786378790; c=relaxed/simple;
	bh=vft1JYAzyPUorOjdBSDXGTPSmgvMONe4ZelyyhyPgSw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Nl7phdvacyVWEHolCLZEbtnfBI7A/dnYOKQjsf824FySH/LoMewBWp+x7xk+ByAhWR+l1hxDFQQRWdbg7lf+2diaJux8wzV3ZL7kn/2vaJxwiAqpnQvAmQ8d0I3jki8i2j4l/QbwY9M604/qq79yd/ZUY9/rRlO1cSkTgtp6Xyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KP3fMCtV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KP3fMCtV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4751F000E9;
	Mon, 10 Aug 2026 16:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786378788;
	bh=vWFF5rbpHjkJVsF6rYCEgkXwe2H85cOSrnKD6SoYu/s=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=KP3fMCtVOHkjkiegq2GgwH9YPInvhvDmEUuuGn4JZMsYwY2MwFps4JRByvplPOHCP
	 9RhXPvwpDboJLnctJuK21ybEl6SfcdfKJ0psbl62EImczU78jwlrH77d4FgHroailz
	 ICKmE6pAea+OP/q4KpsnmC5lP7KJhbY2/SrgOXM9wy5IVDrPQXf8SQ9l08PMgohBzu
	 35QXMP6ecEqvEcDHjr+Lc4GnKYNKCAIsGVCeKjCmjCzGDs8P01voF22M8uTk+uReLZ
	 4oAGMFyzVA+aGyjOmmBJ5NEa6/pPg5xL41w1l7UJ4zF4Tx39PZ0uvl1yWJr4dfs8/m
	 0cHEVsNm/N0gg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>,  George Guo <dongtai.guo@linux.dev>,
  Mike Rapoport <rppt@kernel.org>,  pasha.tatashin@soleen.com,
  pratyush@kernel.org,  shuah@kernel.org,  guodongtai@kylinos.cn,  WANG
 Xuerui <kernel@xen0n.name>,  graf@amazon.com,  loongarch@lists.linux.dev,
  linux-kernel@vger.kernel.org,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kselftest@vger.kernel.org,
  linux-efi@vger.kernel.org
Subject: Re: [PATCH v4 1/4] efi: add a KHO configuration table GUID
In-Reply-To: <CAAhV-H6UufWevaCds851xSxEMLeLcq+8wpoWq8OyeXib25GEUQ@mail.gmail.com>
	(Huacai Chen's message of "Mon, 10 Aug 2026 22:35:37 +0800")
References: <20260807103714.33074-1-dongtai.guo@linux.dev>
	<20260807103714.33074-2-dongtai.guo@linux.dev>
	<CAAhV-H4xxPXVRNXP42CBtMdVXbBZ4E6A997jZmw7HpEUSFAj9g@mail.gmail.com>
	<96bd0e57-b517-4008-905f-9860661afaf2@app.fastmail.com>
	<CAAhV-H6UufWevaCds851xSxEMLeLcq+8wpoWq8OyeXib25GEUQ@mail.gmail.com>
Date: Mon, 10 Aug 2026 18:19:44 +0200
Message-ID: <2vxzse4m54nz.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 10 2026, Huacai Chen wrote:

> On Mon, Aug 10, 2026 at 9:14=E2=80=AFPM Ard Biesheuvel <ardb@kernel.org> =
wrote:
>>
>>
>>
>> On Sun, 9 Aug 2026, at 06:18, Huacai Chen wrote:
>> > Hi, George,
>> >
>> > On Fri, Aug 7, 2026 at 6:38=E2=80=AFPM George Guo <dongtai.guo@linux.d=
ev> wrote:
>> >>
>> >> From: George Guo <guodongtai@kylinos.cn>
>> >>
>> >> Kexec Handover (KHO) passes the address of its state FDT and of its
>> >> scratch area from the current kernel to the next one.  On architectur=
es
>> >> that boot with a device tree, the current kernel writes the
>> >> linux,kho-fdt and linux,kho-scratch properties into /chosen, and the =
next
>> >> kernel reads them back in early_init_dt_check_kho().
>> >>
>> >> Architectures that boot through EFI without a device tree have no such
>> >> channel.  LoongArch is one of them: its efistub passes the EFI system
>> >> table and the command line to the core kernel directly and never crea=
tes
>> >> an FDT.  x86 has the same problem and carries the state out of band
>> >> instead, in a struct kho_data in the setup_data chain of its boot
>> >> protocol.
>> >>
>> >> Add an out-of-band channel for EFI: a LINUX_EFI_KHO_TABLE_GUID
>> >> configuration table entry, under a randomly generated GUID, pointing =
at a
>> >> struct linux_efi_kho_data.  The
>> >> current kernel loads the structure and an extended configuration tabl=
e as
>> >> kexec segments, then switches the EFI system table to the new table
>> >> before jumping.  The next kernel finds the entry by GUID and calls
>> >> kho_populate().
>> >>
>> >> The structure carries no version field.  An incompatible change to the
>> >> layout must use a new GUID, which is the usual rule for EFI configura=
tion
>> >> tables.  The handover payload itself is versioned separately, by the
>> >> compatible string of the KHO state FDT that kho_populate() checks.
>> >>
>> >> This patch adds the definitions only.  LoongArch is the first user; a=
ny
>> >> other EFI architecture without a boot FDT can use the same channel.
>> >>
>> >> Signed-off-by: George Guo <guodongtai@kylinos.cn>
>> >> ---
>> >>  include/linux/efi.h | 24 ++++++++++++++++++++++++
>> >>  1 file changed, 24 insertions(+)
>> >>
>> >> diff --git a/include/linux/efi.h b/include/linux/efi.h
>> >> index ccbc35479684..789ab9e4312a 100644
>> >> --- a/include/linux/efi.h
>> >> +++ b/include/linux/efi.h
>> >> @@ -422,6 +422,7 @@ void efi_native_runtime_setup(void);
>> >>  #define LINUX_EFI_COCO_SECRET_AREA_GUID                EFI_GUID(0xad=
f956ad, 0xe98c, 0x484c,  0xae, 0x11, 0xb5, 0x1c, 0x7d, 0x33, 0x64, 0x47)
>> >>  #define LINUX_EFI_BOOT_MEMMAP_GUID             EFI_GUID(0x800f683f, =
0xd08b, 0x423a,  0xa2, 0x93, 0x96, 0x5c, 0x3c, 0x6f, 0xe2, 0xb4)
>> >>  #define LINUX_EFI_UNACCEPTED_MEM_TABLE_GUID    EFI_GUID(0xd5d1de3c, =
0x105c, 0x44f9,  0x9e, 0xa9, 0xbc, 0xef, 0x98, 0x12, 0x00, 0x31)
>> >> +#define LINUX_EFI_KHO_TABLE_GUID               EFI_GUID(0xc941b6c7, =
0x7b3f, 0x4af6,  0x9e, 0x50, 0xfc, 0xb3, 0xa8, 0x86, 0x8a, 0x17)
>> > I don't know whether it is allowed to define a new TABLE ID while
>> > doesn't touch the UEFI SPEC.
>> >
>>
>> That is fine in principle: the whole reason for using GUIDs as identifie=
rs
>> in UEFI is that everyone can invent their own, and the risk of conflicts=
 is
>> negligible.
>>
>> All LINUX_EFI_* GUIDs are Linux inventions, and are not mentioned in the
>> UEFI spec at all.
> OK, then I think the direction of this series is correct now, and I
> hope there will be more archs share this GUID.

Agreed.

Perhaps we can move x86 over to use this as well? If I understand
correctly, pretty much all modern x86 systems have UEFI, so it would
make sense for KHO to directly use the generic UEFI bits for x86 as well
instead of having it via setup data.

>
> BTW, I think LINUX_EFI_KEXEC_HANDOVER_GUID may be a little better than
> LINUX_EFI_KHO_TABLE_GUID.

+1, that sounds better.

--=20
Regards,
Pratyush Yadav
