From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v3 06/10] arm64: efi: add EFI stub
Date: Wed, 8 Feb 2017 16:29:50 +0000
Message-ID: <E4BDBC23-A96A-4D84-B7EE-B7967D4E4DDD@linaro.org>
References: <1396637113-22790-1-git-send-email-leif.lindholm@linaro.org> <1396637113-22790-7-git-send-email-leif.lindholm@linaro.org> <CAOZdJXWU1dmFfCc88RMp3SvouU7roDiJsA=3aHzwijwhMH7naA@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOZdJXWU1dmFfCc88RMp3SvouU7roDiJsA=3aHzwijwhMH7naA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Timur Tabi <timur@codeaurora.org>
Cc: Leif Lindholm <leif.lindholm@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-efi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, Mark Salter <msalter@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, Matt Fleming <matt.fleming@intel.com>
List-Id: linux-efi@vger.kernel.org



> On 8 Feb 2017, at 16:28, Timur Tabi <timur@codeaurora.org> wrote:
>=20
>> On Fri, Apr 4, 2014 at 1:45 PM, Leif Lindholm <leif.lindholm@linaro.org> w=
rote:
>>=20
>> +/*
>> + * EFI entry point for the arm/arm64 EFI stubs.  This is the entrypoint
>> + * that is described in the PE/COFF header.  Most of the code is the sam=
e
>> + * for both archictectures, with the arch-specific code provided in the
>> + * handle_kernel_image() function.
>> + */
>> +unsigned long __init efi_entry(void *handle, efi_system_table_t *sys_tab=
le,
>> +                              unsigned long *image_addr)
>> +{
>=20
> ...
>=20
>> +
>> +       status =3D handle_cmdline_files(sys_table, image, cmdline_ptr,
>> +                                     "initrd=3D", dram_base + SZ_512M,
>> +                                     (unsigned long *)&initrd_addr,
>> +                                     (unsigned long *)&initrd_size);
>=20
> So I know this patch is almost three years old, but why is there a
> 512M limit on the initrd size?
>=20

How do you reckon this constitutes a limit?

> --=20
> Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,=

> a Linux Foundation Collaborative Project.
