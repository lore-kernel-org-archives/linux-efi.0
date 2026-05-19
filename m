Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97EC5348C65
	for <linux-efi@vger.kernel.org>; Tue, 19 May 2026 14:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779199959; cv=none; b=ZZg9QcI7yYHPs49lCTdihRZqiycbk9fbEPZriDq4NkyjXzv7o4GYI6kHG+nDPO9tg/bZNCvEyv3grxuCrk6aWlDDd7yagQ9FhXQrl4b9AMBXe3mFKX77CV1eoYqPM1GqxqQqnpfkpDy6iG4/kmdoKs4wKuNZe+LeBWMwhq/Dzn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779199959; c=relaxed/simple;
	bh=ys3VfdCIMI6SZCYAZr0JIhK48BGkSl8ZbpOceUW+Mcw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DLIORKL60uTmRmn1nbF6x8XVyR6hmCmLikXd8SgQZEVSvRfp/HA7cgviEJlZmlmqDYyUGwlRSo2DlEoRp01kgKMvPcQI40qlMpz+HFl3ic1yqsI4ZzkF6Da0oFSfi9EBcBcVz8jWDiZY9eH20GlnsGakG6pZZ2JBJgPu49Mjs1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jWDabLoq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jWDabLoq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51613C4AF0B
	for <linux-efi@vger.kernel.org>; Tue, 19 May 2026 14:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779199959;
	bh=ys3VfdCIMI6SZCYAZr0JIhK48BGkSl8ZbpOceUW+Mcw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jWDabLoqiUUCbfzIrE1BRaqFOy/1gPCq2eG8ps/fFm3Xrvgxq4OqAqCHx657LbLDT
	 8IijuYxhsszuuABHXTiFHOcUmzfGDbNaN8kFpknFRQ5xGvEjS8eeD7q0/92Q4eA0SL
	 mMBFzQCw0HgGqtlAaT3r/YOVbZEaBFoN5qNwUeh4//4gPJ6mK7xob1lvfqqUbbWDZL
	 OBcse7J/IMrfIrEUKGwil+vI7HT8787im5O7nZUrG1gujjJJxqNhq1H1L9HvOjhR+C
	 kbi1soamtzG+nKZtH8uX1LfrbYwU3DigLSA3H+UOy7fjGE0k4XWDeSMICsVW+qf0sn
	 rlXh0CQg5OW3A==
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5a40d02b58bso2672532e87.3
        for <linux-efi@vger.kernel.org>; Tue, 19 May 2026 07:12:39 -0700 (PDT)
X-Gm-Message-State: AOJu0YzVm/+9OmW/zFltx/OCggUr7SvG7NIL880WCJ1zlHdvR5i4L7HF
	/htmu5vFrGvaUKC4eM5S+0466LKfIr2pCfuGxkxCW0q6OQlQtzXddGpiqSSCkuUQlvSCpFayccc
	5F3hAepoLgdXemaDovJX8VYgJqkA4haQ=
X-Received: by 2002:a05:6512:3e0f:b0:5a8:891f:b3c8 with SMTP id
 2adb3069b0e04-5aa0e7741c2mr5697397e87.39.1779199957668; Tue, 19 May 2026
 07:12:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260519082316.1959158-2-ardb+git@google.com>
In-Reply-To: <20260519082316.1959158-2-ardb+git@google.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Tue, 19 May 2026 16:12:25 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0h5NvLK3Fs9Fw+GoKCs82SXP1_oRggiG_aH3wiuMkdnJA@mail.gmail.com>
X-Gm-Features: AVHnY4J1z7TCHiU8JsNJXAu7oLMdpyCdSwenLYcwTsf0Ue3WoyKdwh1etIzPlPg
Message-ID: <CAJZ5v0h5NvLK3Fs9Fw+GoKCs82SXP1_oRggiG_aH3wiuMkdnJA@mail.gmail.com>
Subject: Re: [PATCH] efi: Allocate runtime workqueue before ACPI init
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 19, 2026 at 10:23=E2=80=AFAM Ard Biesheuvel <ardb+git@google.co=
m> wrote:
>
> From: Ard Biesheuvel <ardb@kernel.org>
>
> Since commit
>
>   5894cf571e14 ("acpi/prmt: Use EFI runtime sandbox to invoke PRM handler=
s")
>
> ACPI PRM calls are delegated to a workqueue which runs in a kernel
> thread, making it easier to detect and mitigate faulting memory accesses
> performed by the firmware.
>
> Rafael reports that such PRM accesses may occur before efisubsys_init()
> executes, which is where the workqueue is allocated, leading to NULL
> pointer dereferences. Since acpi_init() [which triggers the early PRM
> accesses] executes as a subsys_initcall() as well, and has its own
> dependencies that may be sensitive to initcall ordering, deferring
> acpi_init() is not an option.
>
> So instead, split off the workqueue allocation into its own postcore
> initcall, as this is the only missing piece to allow EFI runtime calls
> to be made. This ensures that EFI runtime call (including PRM calls) are
> accessible to all code running at subsys_initcall() level.
>
> Fixes: 5894cf571e14 ("acpi/prmt: Use EFI runtime sandbox to invoke PRM ha=
ndlers")
> Reported-by: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

This should work AFAICS, so

Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>

> ---
>  drivers/firmware/efi/efi.c | 28 ++++++++++++++++------------
>  1 file changed, 16 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index d04be38f1750..318d1cc9a066 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -402,21 +402,11 @@ static void __init efi_debugfs_init(void)
>  static inline void efi_debugfs_init(void) {}
>  #endif
>
> -/*
> - * We register the efi subsystem with the firmware subsystem and the
> - * efivars subsystem with the efi subsystem, if the system was booted wi=
th
> - * EFI.
> - */
> -static int __init efisubsys_init(void)
> +static int __init efipostcore_init(void)
>  {
> -       int error;
> -
>         if (!efi_enabled(EFI_RUNTIME_SERVICES))
>                 efi.runtime_supported_mask =3D 0;
>
> -       if (!efi_enabled(EFI_BOOT))
> -               return 0;
> -
>         if (efi.runtime_supported_mask) {
>                 /*
>                  * Since we process only one efi_runtime_service() at a t=
ime, an
> @@ -428,9 +418,23 @@ static int __init efisubsys_init(void)
>                         pr_err("Creating efi_rts_wq failed, EFI runtime s=
ervices disabled.\n");
>                         clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
>                         efi.runtime_supported_mask =3D 0;
> -                       return 0;
>                 }
>         }
> +       return 0;
> +}
> +postcore_initcall(efipostcore_init);
> +
> +/*
> + * We register the efi subsystem with the firmware subsystem and the
> + * efivars subsystem with the efi subsystem, if the system was booted wi=
th
> + * EFI.
> + */
> +static int __init efisubsys_init(void)
> +{
> +       int error;
> +
> +       if (!efi_enabled(EFI_BOOT))
> +               return 0;
>
>         if (efi_rt_services_supported(EFI_RT_SUPPORTED_TIME_SERVICES))
>                 platform_device_register_simple("rtc-efi", 0, NULL, 0);
> --
