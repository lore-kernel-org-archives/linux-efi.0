Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795784250;
	b=Zh7znoXYaXYieRZ/BHd0jALI9DCcndG4DX1Ty82G+QL8gjijtuRWDANI/LSHS6IGAFGK
	 JW7QzsrP5MHX4wVDskugHNIMRez2+8oJpiG9Kysw9Fp8L6j/fKhSxCYuQezRTTtxd+bzv
	 8MEH/bMcuIhGR2rY7EKF/HFTX9ggmTTEM7Xng93+1zrRBazkWa7Q8mtuzgnepRJhDI+B9
	 Yk9X6izfji82FpjD+M2bo5+Rw3/KXZxT+1D5Wz3RCT8SMBEXsPrLHBJCg6AB3jRZtgnPn
	 I/SSzovdjWMyXmuXJS0TDhWa91X1Nbp4QddCajn6DE9dUXZjcZqaMXVGwz1GfsnPS/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795784250;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=8pbqAWUo28prTe+MBHoVMlUYCLqcSTjnimmwlUz9h3Q=;
	b=j0mnmfmCTaZXW+JcunXuo5TCRSb/uVashqPSRInBW88Q8zr1+Lzpr5Aj69wyqhmr5p/r
	 AYKg5Ng/nD70JTMdAYivxejqdXZAIUuNms5aTxz32wwyQQEVRwXq6W1ogvAwR0v4DkS3t
	 gBS4av+MSD3gNB6SRlxiDqy81Y8YRSsxX9MZYPyDASswEAT4Uz2wdPl5sP3OIucXSFtNe
	 BPAEGrBjTVGijiH5JylTZzsqQxWo/ba1JC1nMKwRoJMQtxNz19fV2O0jP4DVQnOXhR5Ok
	 RkUmaGyYBVLKhKMRba9moWrf6YnCCEFBwltiCMvxTP1IcqUgh4DyVymjg5WWF/4BpUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IVe+0psC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA73606A31C
	for <linux-efi@vger.kernel.org>; Fri, 27 Nov 2026 12:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IVe+0psC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A281F0089A;
	Fri, 27 Nov 2026 12:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795784250;
	bh=8pbqAWUo28prTe+MBHoVMlUYCLqcSTjnimmwlUz9h3Q=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=IVe+0psC0Y7auSKmT6K5JQkFAZggp4uu6nHKJPGezMEtD8G5kydn53u1/gpL1ts6h
	 bKy6pNzZbfc9J++7KjlZaKQSpsJPdEaA92aHEkHZhb8uVS25znvx1ziKSnwZxKdMa+
	 bIox43It9cfC1nFWEpahfF3gIBiY1Gk6620uSg7Jy0Exn70hxtBIq7OeRbUt4TeqRM
	 BIk/fvqBtxMwNbgawpqBNv6yCowdOmyjdSUeNFqbiPayWFTevQtMiTqL8PMdAHjzmI
	 c9Zg85ew5/bn3VnqdoEV80K5hsDWN9zTZ/0wITFPpRGffl4gVLmI+lfx/GcviLbo8m
	 hhiN0r+ak5Rhw==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 899B81980093;
	Fri, 27 Nov 2026 07:57:27 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 27 Nov 2026 07:57:27 -0500
X-ME-Sender: <xms:NX4Ja0Tv5vsBpDO_v0uO8tCPCL26eveFAyq4zAG6_LrSYjI6_Vnj4g>
    <xme:NX4Ja8nLiSJ21vxjjQHZ6LJAf5edHieByEmsY19pwxlJWS7NkKFrNLtCxvgYwdiEA
    j_p4N84AgeZmliGJnP_9biqiteZxCUdAeeVHWEBkuupIyurlw1SDuE>
X-ME-Proxy-Cause: dmFkZTEyDcnf44wM4/DTGvH1z7F4d1usDZODzOKwLqdRRBqE8o49jnjmQ1wUpy1X0C0pqo
    p9kjMW31ZCVMthl+18khL9zHsOWoONdcFsSDf76kGzo4UZtC029KSdXlbXoufBkx1/1B48
    Pfdm2VvtAwc9cKiPhgJhe+INaph06GrJTZlDy6L4GO+tI9CTr2FBjNSu5Jk3elR7sWpbNv
    VkYyr+eYcxOQO4fpEz5dV+e13jK3ux3nbgTQ7IDVuTCjzEX7DWxwp5rOLDVlwFzkpqvyJk
    FjRKb4fmj3DI+8cb1hfxMjtCP2vgdrBVIhIlmfW7BdMQRCE/TCodqFiiFZkk1fhH0b2Gp0
    xvFqRb8q58VCt5Iapj6VW/+i1OgIrrRHjC5+T8hwllwI59mc6+m0og0xGr3sOKbVXLLJC3
    ittlbLAu+inv03xAvaHmjLOr8+VVlkeVtyVZQOKHZXLvRfjz1d77JxYrgnL88YhopPHS5m
    og0b3/gSrlI+yAaZVVKK92PlwutuNtvR1Kd2pHetdkZJgdkebdrfarB/jXV6KOxyjoUN9Q
    GlhuyIWnLht9KB5z9O8Y3ycPRut4nsVKZlA9cofivvQN7oId8QMtfYcnrgtPt3yAUk8/PZ
    IZk1J9U22n7UqyO0hWAOICl7gEtWwdSsQ9gEoXbES2mZE8AxuXxtt0g7naHQ
X-ME-Proxy: <xmx:N34Ja8RUb84MfrCeyhrCYFxcp2ZgdzD85rKZLjTBh03abjvvGwCQFw>
    <xmx:N34Ja0tOb5ceXZrU1ApkXkSg5syP-9wwKnSdgKUhS35HwAozJ4HRww>
    <xmx:N34Ja40u6L9amauVIkswh8SnNY-Mi1Ut8k1oDb0hS1713ZsOedcD4w>
    <xmx:N34Ja1WEeH68a1wWbqM80deokbYG2YdAHRzh09dQDV-Du6PRWIbLBg>
    <xmx:N34JazKS1L_r-tHuzlMyQrzmvIjB9pUXsVF5Y77wYL_zbD371cNImpyc>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 87777F80096; Fri, 27 Nov 2026 07:57:25 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Fri, 27 Nov 2026 13:57:04 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Huacai Chen" <chenhuacai@kernel.org>,
 "Ard Biesheuvel" <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, loongarch@lists.linux.dev,
 "Dmitry Antipov" <dmantipov@yandex.ru>, "WANG Xuerui" <kernel@xen0n.name>
Message-Id: <c259be8b-b5fa-426b-931f-c0d8776ed9a0@app.fastmail.com>
In-Reply-To: <1d7af4f1-240f-4809-9342-27dfd9b6fc77@app.fastmail.com>
References: <20261126155017.2401147-5-ardb+git@google.com>
 <20261126155017.2401147-8-ardb+git@google.com>
 <CAAhV-H5fd2K4WTPRSe7bdX3fgqxcC_MkOzwrxfMk1xnJdBW=Yg@mail.gmail.com>
 <b6479785-6d26-43f6-92db-627bc2bfe11f@app.fastmail.com>
 <a4e1054d-dc7d-4d62-a539-562dae4b5ee9@app.fastmail.com>
 <1d7af4f1-240f-4809-9342-27dfd9b6fc77@app.fastmail.com>
Subject: Re: [PATCH 3/3] efi/libstub: Provide library helpers only where needed
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


On Fri, 27 Nov 2026, at 10:48, Ard Biesheuvel wrote:
> On Fri, 27 Nov 2026, at 10:11, Ard Biesheuvel wrote:
>> On Fri, 27 Nov 2026, at 08:13, Ard Biesheuvel wrote:
>>> On Fri, 27 Nov 2026, at 03:28, Huacai Chen wrote:
>>>> Hi, Ard,
>>>>
>>>> Does this series wan to solve the same problem as below?
>>>> https://lore.kernel.org/loongarch/97a95c9d-6736-4eee-ac9d-cbfb47d60=
492@app.fastmail.com/T/#t
>>>>
>>>
>>> Yes.
>>>
>>>> On Thu, Nov 26, 2026 at 11:50=E2=80=AFPM Ard Biesheuvel <ardb+git@g=
oogle.com> wrote:
>>>>>
>>>>> From: Ard Biesheuvel <ardb@kernel.org>
>>>>>
>>>>> Now that dead stub code is being eliminated by the linker, the only
>>>>> remaining user of the 64-bit left shift and clz/ctz helper routine=
s is
>>>>> ZSTD compression, and only in some cases:
>>>>>
>>>>> - the 64-bit left shift is only needed on 32-bit architectures
>>>>> - the clz/ctz helper is needed on all RISC-V and 32-bit reduced
>>>>>   LoongArch
>>>>>
>>>>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>>>>> ---
>>>>>  drivers/firmware/efi/libstub/Makefile | 11 ++++++-----
>>>>>  1 file changed, 6 insertions(+), 5 deletions(-)
>>>>>
>>>>> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmw=
are/efi/libstub/Makefile
>>>>> index 20b5b77956d1..ba6d67e5cd78 100644
>>>>> --- a/drivers/firmware/efi/libstub/Makefile
>>>>> +++ b/drivers/firmware/efi/libstub/Makefile
>>>>> @@ -98,14 +98,15 @@ CFLAGS_arm32-stub.o         :=3D -DTEXT_OFFSET=
=3D$(TEXT_OFFSET)
>>>>>
>>>>>  zboot-obj-y                    :=3D zboot-decompress-gzip.o
>>>>>  CFLAGS_zboot-decompress-gzip.o +=3D -I$(srctree)/lib/zlib_inflate
>>>>> -zboot-obj-$(CONFIG_KERNEL_ZSTD)        :=3D zboot-decompress-zstd=
.o lib-xxhash.o
>>>>> +
>>>>> +zstd-obj-$(CONFIG_32BIT)       :=3D lib-ashldi3.o
>>>>> +zstd-obj-$(CONFIG_RISCV)       +=3D lib-clz_ctz.o
>>>>> +zstd-obj-$(CONFIG_32BIT_REDUCED) +=3D lib-clz_ctz.o # loongarch
>> ...
>>>> And it seems the first patch can be folded with this one...
>>>>
>>>
>>> This is an optimization, the first one is a build fix.
>>
>> Yes, it does seem that the first patch is superseded by this change, =
as
>> the left-shift helper is only used in zstd.
>>
>
> Hmm the --gc-sections patch does not affect the vmlinux build so the f=
ix
> in patch #1 needs to stay. But I can drop the loongarch pieces from th=
is
> hunk, because its libstub.a already carries those objects.

Finally, I'll keep patch #1 as a fix, and turn this into

zstd-riscv-obj-$(CONFIG_32BIT) :=3D lib-ashldi3.o
zstd-obj-$(CONFIG_32BIT)       :=3D lib-clz_ctz.o
zstd-obj-$(CONFIG_RISCV)       :=3D lib-clz_ctz.o $(zstd-riscv-obj-y)
zstd-obj-y                     +=3D lib-xxhash.o
zboot-obj-$(CONFIG_KERNEL_ZSTD) :=3D zboot-decompress-zstd.o $(zstd-obj-=
y)



