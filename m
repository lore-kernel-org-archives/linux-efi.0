Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795772934;
	b=FK+Ve0XZZRKlfDSeAow52/Ss8HFygCLN31LwlCMSd3tcZT1ejFtw2MMZk00hpEXs20Ah
	 Cccj8JwkTPbJg2/PWS0d9YXzZlgjdfFKVuwNNdpuKz2LnM7Faq3Wl5YbMFHghx7d/8wM4
	 FAc3p30NtDTAnx/V6x0pX0tYvziHXaxQ8g8dqQpJfGg+3jTGcd7Q/5CVvbx2SiRDsMI8I
	 ikeIpc8ZnmP15dOCSP8Jlj7ebMTnqnKPB/njoL/n1ymSrfAMDIvHps4ccjJzk8QNoHDY+
	 pQJuCie250rKORrE8Qeb4a2+I+oIZDPQrK0yfJ0SZJy0vvGlZ+1Vq+cqQJIZ6liFLDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795772934;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=YWBXC3kvwSwyXqPeXzUEG7oFOiHipMUkqTWjh0MmG3s=;
	b=Ftq3TmsPoIYzp+lTT6azBCcxmCjReoRDcUHa+fUrH0dIeRmh+VPoig4PWa8DoAC74A0M
	 WJeuFgJsJuhugCqDIxtrhBBdeYq6JpVotydm7u68p40tdjVfCVwnmPGK+NhJMTO+E3WNg
	 4LvlYUOmnTqP4vEd1qHq+bOReu+Fz3qc0KHskV6ZDmtkEKmupWfW9O5XHNg8n+qeV8z7L
	 jlEVwv2NNdzcsHzTGJDMIgQjZL2mnEKs8DRRQZqaJHlZoMCcCaGJxLazypZHmxBT1VwNT
	 MfU/xX2zJtvhtvLSltKTrwhepuPs7V0Wmur0RAPLO6v+oFAd7ZJxE5doLFTuvJ2A9cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KeNDVrQz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261B1606A31E
	for <linux-efi@vger.kernel.org>; Fri, 27 Nov 2026 09:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KeNDVrQz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E3F1F008A0
	for <linux-efi@vger.kernel.org>; Fri, 27 Nov 2026 09:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795772933;
	bh=YWBXC3kvwSwyXqPeXzUEG7oFOiHipMUkqTWjh0MmG3s=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=KeNDVrQz42fhbBGO+TCcVaeHo6mt9s2nF9Y0DUSpGo0I4POjW977W49rcnJ/CTrtl
	 5Zrw5QmfN06hrBwCrumERsPN+IQjXxvAqCPmsY9HL0QRwD7fPVqJqjvwoBBHMK6y3x
	 TyJoaXQdlGaIj7zaFdVXLUqvKRSZ4FBczAi9a5l0TYOmhMUBlYwg/WaR9gTSO3megh
	 mLGPJrqDas06XOypAHk6VO4JsM9aGeZraKNKW7DBvJjB5OqmEBQ4OQ8nHpYHG/f06N
	 yREgmf6QfB+ZV/tlfY3D/zXQdsAwHHNB00ADe6lNumXd5FiUac1Gn8tlZb9jvLo7UQ
	 gTE5e9qCyt+4w==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 9ED921980047;
	Fri, 27 Nov 2026 04:48:51 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 27 Nov 2026 04:48:51 -0500
X-ME-Sender: <xms:AVIJa6GH1Rg_FKqA0ItvPimxQH6JZ_qWRCYYJBE3TKfTlHVtBpePVg>
    <xme:AVIJa2I5wOwzrV5UAZSCmzhYk_hhHA55pbtszC6NjHEcBFQAlR-F_SJzkgJmL41Jt
    -g-RwQzyKwz7qsXeAcVO535vDXuNzwskzA56EAKbwyz4n5bQoJ-MCY>
X-ME-Proxy-Cause: dmFkZTEzBD1GuaugRPsoD94k7LcY6sNPNBZ97D7IoxjY0FKuEOZHQangDJd6MuTTEVWR2g
    rvtDEKGJiKsTgrw2Nfvb+mBlxzQo4vtX7QK3snS7trYO+o8DvPjsWshEScyovsyEyXEHQH
    jQ42diYm8SVeelPnGKs9zcrnE8SdRUSiHbTdOwe87rgIIJyhgEb/edgaEg+S1qTeV9S0+h
    nBrhDhdzPuGvuEO37UAG+F6f5O8cO/gYkiyQX1v6pwdAg9iT+bOrxOPHeGdyjCc9k/vw/C
    YxBMBqb4D2SVd3JVmlWzN82LueCdstx3rFniBBZZZxpZtbvxt5wqbZz0Ewg1UTQ83K+cFv
    wz/C0n8r80dMMGzYdGL/LpC34oN9BPfCkWoByE19DaJMhJCilcB5SgmvQLd2/NqBNuJwia
    1Jcp+m28DBjWfWWpgfTrs5htggzyNxH05bLrSdlB+YLZin6h4m4+Sc2j7iJMkN5y8l/rgZ
    Y3GbO+a0MQ3/Xk814oBKvzKMp6duuV6rNN6s1SnUJTPiMO1S3hMt08hY8liyog9JyMl1Jx
    VaqyJbNBOxBrOj2FUJKCtlKXSr+J2XjnJxcj3n4j0tM22ggXB04dcjJYhY9SfMrcBv63+S
    jSlZ5I9+1XwiHPC0gkRTAEgO89gJbb+2uJDTEDRcQBoXk57CZ1vbOgYCHWAg
X-ME-Proxy: <xmx:A1IJawm7Xw8RGQKOQ6cY4tZwiNaUEzW8u7KZjFbbVMsmZftnOwuZjQ>
    <xmx:A1IJa6zXSFd0tvqP6ro5sKXj_BK9Im09jA8vv6KH6toJf0yDhpgkjA>
    <xmx:A1IJa9rSYKS5bU23hh1a8oyKge-AZ0QJxFTJEUhviuTa1P6-mmzuoA>
    <xmx:A1IJax6nb2Z6GCjAuURNSbkABqeSw2siEVvnnnC4lcxGbehydpwgwQ>
    <xmx:A1IJa8f3muyZjHRzNejJNitxh9xRdXbLIRsCuiOH-xG7ef01ItW0pHlM>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id B3D0CF80093; Fri, 27 Nov 2026 04:48:49 -0500 (EST)
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
Date: Fri, 27 Nov 2026 10:48:28 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Huacai Chen" <chenhuacai@kernel.org>,
 "Ard Biesheuvel" <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, loongarch@lists.linux.dev,
 "Dmitry Antipov" <dmantipov@yandex.ru>, "WANG Xuerui" <kernel@xen0n.name>
Message-Id: <1d7af4f1-240f-4809-9342-27dfd9b6fc77@app.fastmail.com>
In-Reply-To: <a4e1054d-dc7d-4d62-a539-562dae4b5ee9@app.fastmail.com>
References: <20261126155017.2401147-5-ardb+git@google.com>
 <20261126155017.2401147-8-ardb+git@google.com>
 <CAAhV-H5fd2K4WTPRSe7bdX3fgqxcC_MkOzwrxfMk1xnJdBW=Yg@mail.gmail.com>
 <b6479785-6d26-43f6-92db-627bc2bfe11f@app.fastmail.com>
 <a4e1054d-dc7d-4d62-a539-562dae4b5ee9@app.fastmail.com>
Subject: Re: [PATCH 3/3] efi/libstub: Provide library helpers only where needed
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



On Fri, 27 Nov 2026, at 10:11, Ard Biesheuvel wrote:
> On Fri, 27 Nov 2026, at 08:13, Ard Biesheuvel wrote:
>> On Fri, 27 Nov 2026, at 03:28, Huacai Chen wrote:
>>> Hi, Ard,
>>>
>>> Does this series wan to solve the same problem as below?
>>> https://lore.kernel.org/loongarch/97a95c9d-6736-4eee-ac9d-cbfb47d604=
92@app.fastmail.com/T/#t
>>>
>>
>> Yes.
>>
>>> On Thu, Nov 26, 2026 at 11:50=E2=80=AFPM Ard Biesheuvel <ardb+git@go=
ogle.com> wrote:
>>>>
>>>> From: Ard Biesheuvel <ardb@kernel.org>
>>>>
>>>> Now that dead stub code is being eliminated by the linker, the only
>>>> remaining user of the 64-bit left shift and clz/ctz helper routines=
 is
>>>> ZSTD compression, and only in some cases:
>>>>
>>>> - the 64-bit left shift is only needed on 32-bit architectures
>>>> - the clz/ctz helper is needed on all RISC-V and 32-bit reduced
>>>>   LoongArch
>>>>
>>>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>>>> ---
>>>>  drivers/firmware/efi/libstub/Makefile | 11 ++++++-----
>>>>  1 file changed, 6 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmwa=
re/efi/libstub/Makefile
>>>> index 20b5b77956d1..ba6d67e5cd78 100644
>>>> --- a/drivers/firmware/efi/libstub/Makefile
>>>> +++ b/drivers/firmware/efi/libstub/Makefile
>>>> @@ -98,14 +98,15 @@ CFLAGS_arm32-stub.o         :=3D -DTEXT_OFFSET=3D=
$(TEXT_OFFSET)
>>>>
>>>>  zboot-obj-y                    :=3D zboot-decompress-gzip.o
>>>>  CFLAGS_zboot-decompress-gzip.o +=3D -I$(srctree)/lib/zlib_inflate
>>>> -zboot-obj-$(CONFIG_KERNEL_ZSTD)        :=3D zboot-decompress-zstd.=
o lib-xxhash.o
>>>> +
>>>> +zstd-obj-$(CONFIG_32BIT)       :=3D lib-ashldi3.o
>>>> +zstd-obj-$(CONFIG_RISCV)       +=3D lib-clz_ctz.o
>>>> +zstd-obj-$(CONFIG_32BIT_REDUCED) +=3D lib-clz_ctz.o # loongarch
> ...
>>> And it seems the first patch can be folded with this one...
>>>
>>
>> This is an optimization, the first one is a build fix.
>
> Yes, it does seem that the first patch is superseded by this change, as
> the left-shift helper is only used in zstd.
>

Hmm the --gc-sections patch does not affect the vmlinux build so the fix
in patch #1 needs to stay. But I can drop the loongarch pieces from this
hunk, because its libstub.a already carries those objects.


