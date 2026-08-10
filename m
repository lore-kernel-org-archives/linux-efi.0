Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7512F6918
	for <linux-efi@vger.kernel.org>; Mon, 10 Aug 2026 14:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786372552; cv=none; b=ZqCvphjCC8no2InKTMx28Nkn5KATN0C+sJd+wOsjAFaBAuk8ZfziBKi3TWSzMg4i0xo8R7ue5E0Iwoj0zdL7bjtAbF21M9T8ud47wBpRbHU+7ver9fhlPapN5Qnv1OLdqCwC+Ea07kB189VDxQtiDuydMxSJylV5owA2eMma9a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786372552; c=relaxed/simple;
	bh=ROdmKiaV9iGKDp79NOZRVZIrvApp0XCjbQbUx4mjZ0Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WJch2Z+gagT8+r83yfq+wZCCqDoWqEVivGkQscbqNoe7UOy88yX+xc/hICNwvfSdCnJQsCh5nVNIeHoEbDuDdZ+tzxqVOkczkmUFZXRODBiaL7/9pGqrCocWTyxJA6DZMc5KMPc0MgrA6WW8TlZ7JCQUmYy+4wQrjSjozlrSuJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mokf2unt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mokf2unt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C2A1F00A3A
	for <linux-efi@vger.kernel.org>; Mon, 10 Aug 2026 14:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786372550;
	bh=5rrAvPgRrohANHyT7hdY7z+O8aQ4K1pdWWyNquNpNJ8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=mokf2untmLnI3fXVkZl9R1TO+I3D6j3AGjfvZwlTjVihK2ebOho2oQYup6uW9rOtJ
	 ImXvrtxVu0Xd4nsZKmwB6BqLwDEpy7Rl/+PPEzC4UFFM+NUR0ljJB9JsFTVCvsSZKf
	 cVNj8v6IBepszhYaAdBd7rrMrYOUeqJOZdB4pBHj5VPk2FaMAsepKXFAPYgBQKtTv1
	 kvMMNBdFm54k5NusUJR9CltM7nilqfNZ0Y6bjhbdu0ttPM5ZAo5TMeSqd+qZyTPRjM
	 Yjw9y/j2HOh6NyXhEDTPUV3kda3hc3Z63LKyCZRgDia2v6J6v/nAMSC8FBzsMaagHq
	 cW4vCyK8OiTPw==
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-69fab5a852cso2498797a12.0
        for <linux-efi@vger.kernel.org>; Mon, 10 Aug 2026 07:35:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RowiLhdNmRvVKRZdoW5PXJQMr6at84WYhSRE+bb0jnNOBQz/wAR68T9sx7K0Dl2eS99QxsktTvcSUY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyub8eCa5rt/Wta9kJVnFI0qBLMg8WL3Vf6JwycBLlRTLaluOw9
	KRtuuCEYNB58QgmbQqZBoFgHHkEdEictt4TKMhqIV9Rjn3gCTglyRCfNsZ3KNAgJKtlhcM7uMvD
	Ae6kPHAWzBO1jg53CyAjcAU/exajXf7s=
X-Received: by 2002:a05:6402:190b:b0:697:e953:d14d with SMTP id
 4fb4d7f45d1cf-6a1b4b9a7c9mr14019689a12.17.1786372549348; Mon, 10 Aug 2026
 07:35:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260807103714.33074-1-dongtai.guo@linux.dev> <20260807103714.33074-2-dongtai.guo@linux.dev>
 <CAAhV-H4xxPXVRNXP42CBtMdVXbBZ4E6A997jZmw7HpEUSFAj9g@mail.gmail.com> <96bd0e57-b517-4008-905f-9860661afaf2@app.fastmail.com>
In-Reply-To: <96bd0e57-b517-4008-905f-9860661afaf2@app.fastmail.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 10 Aug 2026 22:35:37 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6UufWevaCds851xSxEMLeLcq+8wpoWq8OyeXib25GEUQ@mail.gmail.com>
X-Gm-Features: AUfX_mx7myO5n6AdZGyKWT1euUf6zZnDQmB3Nd8fohz-ozaccG8I_T8jUbfMATo
Message-ID: <CAAhV-H6UufWevaCds851xSxEMLeLcq+8wpoWq8OyeXib25GEUQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] efi: add a KHO configuration table GUID
To: Ard Biesheuvel <ardb@kernel.org>
Cc: George Guo <dongtai.guo@linux.dev>, Mike Rapoport <rppt@kernel.org>, pasha.tatashin@soleen.com, 
	pratyush@kernel.org, shuah@kernel.org, guodongtai@kylinos.cn, 
	WANG Xuerui <kernel@xen0n.name>, graf@amazon.com, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-efi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 10, 2026 at 9:14=E2=80=AFPM Ard Biesheuvel <ardb@kernel.org> wr=
ote:
>
>
>
> On Sun, 9 Aug 2026, at 06:18, Huacai Chen wrote:
> > Hi, George,
> >
> > On Fri, Aug 7, 2026 at 6:38=E2=80=AFPM George Guo <dongtai.guo@linux.de=
v> wrote:
> >>
> >> From: George Guo <guodongtai@kylinos.cn>
> >>
> >> Kexec Handover (KHO) passes the address of its state FDT and of its
> >> scratch area from the current kernel to the next one.  On architecture=
s
> >> that boot with a device tree, the current kernel writes the
> >> linux,kho-fdt and linux,kho-scratch properties into /chosen, and the n=
ext
> >> kernel reads them back in early_init_dt_check_kho().
> >>
> >> Architectures that boot through EFI without a device tree have no such
> >> channel.  LoongArch is one of them: its efistub passes the EFI system
> >> table and the command line to the core kernel directly and never creat=
es
> >> an FDT.  x86 has the same problem and carries the state out of band
> >> instead, in a struct kho_data in the setup_data chain of its boot
> >> protocol.
> >>
> >> Add an out-of-band channel for EFI: a LINUX_EFI_KHO_TABLE_GUID
> >> configuration table entry, under a randomly generated GUID, pointing a=
t a
> >> struct linux_efi_kho_data.  The
> >> current kernel loads the structure and an extended configuration table=
 as
> >> kexec segments, then switches the EFI system table to the new table
> >> before jumping.  The next kernel finds the entry by GUID and calls
> >> kho_populate().
> >>
> >> The structure carries no version field.  An incompatible change to the
> >> layout must use a new GUID, which is the usual rule for EFI configurat=
ion
> >> tables.  The handover payload itself is versioned separately, by the
> >> compatible string of the KHO state FDT that kho_populate() checks.
> >>
> >> This patch adds the definitions only.  LoongArch is the first user; an=
y
> >> other EFI architecture without a boot FDT can use the same channel.
> >>
> >> Signed-off-by: George Guo <guodongtai@kylinos.cn>
> >> ---
> >>  include/linux/efi.h | 24 ++++++++++++++++++++++++
> >>  1 file changed, 24 insertions(+)
> >>
> >> diff --git a/include/linux/efi.h b/include/linux/efi.h
> >> index ccbc35479684..789ab9e4312a 100644
> >> --- a/include/linux/efi.h
> >> +++ b/include/linux/efi.h
> >> @@ -422,6 +422,7 @@ void efi_native_runtime_setup(void);
> >>  #define LINUX_EFI_COCO_SECRET_AREA_GUID                EFI_GUID(0xadf=
956ad, 0xe98c, 0x484c,  0xae, 0x11, 0xb5, 0x1c, 0x7d, 0x33, 0x64, 0x47)
> >>  #define LINUX_EFI_BOOT_MEMMAP_GUID             EFI_GUID(0x800f683f, 0=
xd08b, 0x423a,  0xa2, 0x93, 0x96, 0x5c, 0x3c, 0x6f, 0xe2, 0xb4)
> >>  #define LINUX_EFI_UNACCEPTED_MEM_TABLE_GUID    EFI_GUID(0xd5d1de3c, 0=
x105c, 0x44f9,  0x9e, 0xa9, 0xbc, 0xef, 0x98, 0x12, 0x00, 0x31)
> >> +#define LINUX_EFI_KHO_TABLE_GUID               EFI_GUID(0xc941b6c7, 0=
x7b3f, 0x4af6,  0x9e, 0x50, 0xfc, 0xb3, 0xa8, 0x86, 0x8a, 0x17)
> > I don't know whether it is allowed to define a new TABLE ID while
> > doesn't touch the UEFI SPEC.
> >
>
> That is fine in principle: the whole reason for using GUIDs as identifier=
s
> in UEFI is that everyone can invent their own, and the risk of conflicts =
is
> negligible.
>
> All LINUX_EFI_* GUIDs are Linux inventions, and are not mentioned in the
> UEFI spec at all.
OK, then I think the direction of this series is correct now, and I
hope there will be more archs share this GUID.

BTW, I think LINUX_EFI_KEXEC_HANDOVER_GUID may be a little better than
LINUX_EFI_KHO_TABLE_GUID.

Huacai
>
