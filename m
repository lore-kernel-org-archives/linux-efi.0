Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4853AFB19
	for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 19:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778700370; cv=none; b=as1gJ8Q61wtAlN8hVHTjvoa6+bmOY2eJF6xsYV7hu0uwz2YRl0kd+cV2/BMG7Ms0o/9crugwQgr+mMUhUiFRA0yaYdQAyVrnf0ymcJnmTIpsIkRNoDfRH6na5amXsWh2W5kbsJm2J54FOpmQFzAlpFEhhCLQZSplxXG6wHOxAdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778700370; c=relaxed/simple;
	bh=jkUkWktFpdEdF2Lcj4EAj+e+wcRxBaXPi67I/QnY5NQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BNYmMGnNz/zw5U2p6WNxGksNcTDR6slMFXUu5Hrx3AcVCSu5S5gAH3OnrRmQKgf6qrQjFEVWOihvkrcCMUing2ch6g3/OeOIpa4KVEIZ7nF0ORsXoxqIRAaViGgz47kw16iPSOn9Z3HgzAF+TmzZcYvjD7y6TIMiNiYk4SO56m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cYGlfSj2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cYGlfSj2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D37C2BCF5
	for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 19:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778700370;
	bh=jkUkWktFpdEdF2Lcj4EAj+e+wcRxBaXPi67I/QnY5NQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=cYGlfSj2/CHzKzyv9me2Zk/HspGP9sjtk4Engs8yoqb2zW9iTZpuRoru+aQDg8KcV
	 CEivNN1d8In9wMQitua9OBf7lWz7JGVU2BXwSMqwhsjDrgaw9VroxtmQhiVPWihWfx
	 IozQQUTd3LoCBCP9tlsnzBJWhc5SrgtBEEXIps7vxbey6TVUvgg6W3P+IunX3Lt6kL
	 5lsFlql/jIyJ5Mi8TcUHdEoBcdsJliEGZoacbbNpWwvqBquVFzVBija05KoWnslRv4
	 O3QXNx5fZDPvRLLqI9Tk+1kTQPbvK1d4jjK7Kkbz9sEpPCHoijuPNVMzLhU0VhCnqs
	 sPx4/a+0DCMDA==
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-38e8292423fso49439751fa.0
        for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 12:26:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8IzQRgOtfAhZkdMZScIAQfuICh1VW6Fn7oHpDyzGRb0tpcnRyMBW05ggc47YXCPJ+rXIerGX9V+zE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqXqwri5KppQFat2uBzOclezRkK0emUwpgAZ5c0IUemHoWFPAD
	6DFDqcOhccijW5/2beNpZvPbDBR2XYS1ogr8bCI6MWYMbzBrYu1feQzcC3uVSWY92IMio80c5Sz
	eDyHAUcQ3qUdtTe5nxxfTOtgWq6Z6m8U=
X-Received: by 2002:a05:6512:684:b0:5a3:cc81:eff3 with SMTP id
 2adb3069b0e04-5a8ef97ca57mr1632659e87.26.1778700368753; Wed, 13 May 2026
 12:26:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513084325.2176952-1-himanshu.chauhan@oss.qualcomm.com> <20260513084325.2176952-4-himanshu.chauhan@oss.qualcomm.com>
In-Reply-To: <20260513084325.2176952-4-himanshu.chauhan@oss.qualcomm.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Wed, 13 May 2026 21:25:56 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0g2kjfAvcTzp8898A8HdMymU1SQ-rHW_DFhZP49c9=s5Q@mail.gmail.com>
X-Gm-Features: AVHnY4I62r5FzdLCp8o0gBy8GA7EdJU8GhHm1Xiv_xt-CcqS2_Q5U7R1FjYttsM
Message-ID: <CAJZ5v0g2kjfAvcTzp8898A8HdMymU1SQ-rHW_DFhZP49c9=s5Q@mail.gmail.com>
Subject: Re: [PATCH v4 03/10] acpi: Introduce SSE in HEST notification types
To: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, 
	acpica-devel@lists.linux.dev, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	lenb@kernel.org, james.morse@arm.com, tony.luck@intel.com, ardb@kernel.org, 
	conor@kernel.org, cleger@rivosinc.com, robert.moore@intel.com, 
	sunilvl@oss.qualcomm.com, anup.patel@oss.qualcomm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 13, 2026 at 10:44=E2=80=AFAM Himanshu Chauhan
<himanshu.chauhan@oss.qualcomm.com> wrote:
>
> Introduce a new HEST notification type for RISC-V SSE events.
> The GHES entry's notification structure contains the notification
> to be used for a given error source. For error sources delivering
> events over SSE, it should contain the new SSE notification type.
>
> Signed-off-by: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
> Reviewed-by: Cl=C3=A9ment L=C3=A9ger <cleger@rivosinc.com>
> ---
>  include/acpi/actbl1.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
> index f72e00517eb3..2a8167979458 100644
> --- a/include/acpi/actbl1.h
> +++ b/include/acpi/actbl1.h

This is an ACPICA change, so it should go through the upstream ACPICA
project on GitHub.  See

Documentation/driver-api/acpi/linuxized-acpica.rst

for more information.

If there is already an upstream ACPICA commit making this change,
please add a Link: tag pointing to that commit to the $subject patch.

> @@ -1798,7 +1798,8 @@ enum acpi_hest_notify_types {
>         ACPI_HEST_NOTIFY_SEI =3D 9,       /* ACPI 6.1 */
>         ACPI_HEST_NOTIFY_GSIV =3D 10,     /* ACPI 6.1 */
>         ACPI_HEST_NOTIFY_SOFTWARE_DELEGATED =3D 11,       /* ACPI 6.2 */
> -       ACPI_HEST_NOTIFY_RESERVED =3D 12  /* 12 and greater are reserved =
*/
> +       ACPI_HEST_NOTIFY_SSE =3D 12, /* RISCV SSE */
> +       ACPI_HEST_NOTIFY_RESERVED =3D 13  /* 13 and greater are reserved =
*/
>  };
>
>  /* Values for config_write_enable bitfield above */
> --
> 2.43.0
>
>
