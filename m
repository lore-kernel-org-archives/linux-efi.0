Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4089B3D5671
	for <linux-efi@vger.kernel.org>; Tue,  9 Jun 2026 06:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780988009; cv=none; b=XwA3sr6NBhz1uIChDhFck+5Bdqf1gEs0eBuFgCnYh+hRWK/c09tbbsNMGoFvuSM3XARD6bIBHIpgl9QkUyjinEpuQk3cOqhb+/8phtoTgp2at0QBbd02rOARy8EychN7xqTGlUYmfSkeCpuLpXPWEuikJBSzFJ6XfLPF9JH7FL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780988009; c=relaxed/simple;
	bh=USxDlh+cTOmctRbVLXUwHBHqPmHhLde8bvmv+bZmeZo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZYYT5tnLELlHhWTAItH9x0yf2h+8/FBCGKGfwYPQbXrpl0H0aH9oV6cD810JA2tJGg/cTOxU9yBTFPMX4VguA5KPQGwuIlVBCAVm5ybdcXwo6XqqW33LE2jDB3nesz0a6tQy+MxZQDLqqqL+HhiqJw1i5aBCZ1eZBVxI5QWcCEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.217.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-6c36543e834so1515685137.1
        for <linux-efi@vger.kernel.org>; Mon, 08 Jun 2026 23:53:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780988006; x=1781592806;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cfrTmKBa/6XQOKTJVCGFPY/9uy59Ow4t/P5iBf4xoKk=;
        b=UHvOfoP33sFjB+G/VJE6WZcSEjXsPuPdGS4wEYswq/LvJRjvCHIbVyJfj+k048az7K
         MtgVxb8NNKGLQhP+GlI2BwGvnZqQEgQjyXM20CVW15dbCeuEXwkw9eGqTZ6WWKKhibZn
         L5Vyh0gVUQ7q25D2hD9dl3Z3jDNfdfcrUV/yvaV6C3rf0vbzOG5iF3YE7IEzkEP9qYDo
         bmRn76vjVAKDifGgoaNmJKisgh4qSesnmSJYl0K2L7/vwN8irMvGxvqHrdDPaqczMpmq
         FqmNRBnXX4D6d+ckZSBH4411f9sYARHPkTmgw856Kd/GIqtYJiFFpNRIu02s5/KNIW9+
         /WVQ==
X-Forwarded-Encrypted: i=1; AFNElJ+PCY+AKvkfUbrVPhUxjarEqizoxqx9RJWy7trWSMA+oC6c4PXRDp7MG30PcveUrxSahvo3apMbYu0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5LPzUuPGO01HkL43lre7Ddc3dJk1SsNgyIJedRHY6RZXwS44i
	a45VpOzqPkFm6BBrFK4Z7tfR8seTJVPECa/7yjibfBdmr1u5kbwBl1mufbrJ/jzn
X-Gm-Gg: Acq92OHFKb/wVXvMavRuOM9xtrhiQWOYSGE8yP91JuIoYka74CWyxZHMdXg9q2k5aWh
	hkeekPVmIhLbH9npZwat/GbdFYSu0CmwMHu5mbL6kjXfGavPofPuK8QNdyoSJbXHn+cTp2I5zjx
	gJfdkXI0Nv5V6tDjgaRSs3YtheDFO2NAdsp1yGNysWVl9okv6mkB7opdeFmwtbA9x5VqCmYnnR4
	/ItcVPvRAxNHchGK3iSbE/5vsLxWO9iOPZWc2Ak0cCB/QSrTiUuS7UawjEuOMKbfCnHlpc0V917
	EaOZIr/TBHBErOy9srBQrEsHfdH7EgmueAMKsFlUi731/FmoEVtWIt4Ulc17idbPZclzG5+CFQv
	A4UFtZGq833hLSnhKlKXUonD7eqlXaAeFbSaYZRNxllFReNXA/8aHFmo8bgANfA7YPQ+z32s4/b
	icyfNkXQw68uXOZ7QsZlJuz9fVArKhsQqTumzu+zOD0kqSn2Ak6BwU66kDv6ox41VYy2RkoWas2
	WADK5cLew==
X-Received: by 2002:a05:6102:374c:b0:631:ab8b:c34e with SMTP id ada2fe7eead31-6fefa70457dmr9232095137.11.1780988005845;
        Mon, 08 Jun 2026 23:53:25 -0700 (PDT)
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com. [209.85.217.53])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-96413f91f2esm15094283241.4.2026.06.08.23.53.23
        for <linux-efi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2026 23:53:23 -0700 (PDT)
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-6cfd2b2e7b1so1757082137.2
        for <linux-efi@vger.kernel.org>; Mon, 08 Jun 2026 23:53:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/6RvZzZs6546pTceFzkxzeeiMGhHkrpP2oeVBALHfveBT1t1aPcZjmfK7KqFpnK7QPv85jOn6aXhs=@vger.kernel.org
X-Received: by 2002:a05:6102:94c:b0:6cb:d562:b96a with SMTP id
 ada2fe7eead31-6ff02387516mr9986946137.14.1780988002958; Mon, 08 Jun 2026
 23:53:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260609-acpi_spcr-v2-0-3cd9a3bda727@posteo.de> <20260609-acpi_spcr-v2-1-3cd9a3bda727@posteo.de>
In-Reply-To: <20260609-acpi_spcr-v2-1-3cd9a3bda727@posteo.de>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 9 Jun 2026 08:53:11 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXH0mR9Sr+ze2_m94uc46_7gubApzWOkf+vUO+w=DmNoQ@mail.gmail.com>
X-Gm-Features: AVVi8Cemo9bnqwwW5sau-L6wcH5-zrPfob50Y8WSYUrCMRB7OtaTQ6EIMHl5BFg
Message-ID: <CAMuHMdXH0mR9Sr+ze2_m94uc46_7gubApzWOkf+vUO+w=DmNoQ@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 1/2] serial: earlycon: add uart_clk_freq parameter
To: Markus Probst <markus.probst@posteo.de>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jirislaby@kernel.org>, 
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
	linux-efi@vger.kernel.org, linux-serial@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Markus,

On Tue, 9 Jun 2026 at 00:40, Markus Probst <markus.probst@posteo.de> wrote:
> Add `uart_clk_freq` parameter to `setup_earlycon`. This allows the
> options string to be reused with `add_preferred_console`, while still
> allowing to set the uart clock frequency. This will be used in the
> following commit ("ACPI: SPCR: Support UART clock frequency field").
>
> No logical change intended.
>
> Signed-off-by: Markus Probst <markus.probst@posteo.de>

> --- a/drivers/tty/serial/earlycon.c
> +++ b/drivers/tty/serial/earlycon.c
> @@ -135,11 +135,14 @@ static int __init parse_options(struct earlycon_device *device, char *options)
>         return 0;
>  }
>
> -static int __init register_earlycon(char *buf, const struct earlycon_id *match)
> +static int __init register_earlycon(char *buf, unsigned int uart_clk_freq,
> +                                   const struct earlycon_id *match)
>  {
>         int err;
>         struct uart_port *port = &early_console_dev.port;
>
> +       port->uartclk = uart_clk_freq;

Who is actually consuming this value?
Earlycon typically works with the serial console, as configured before
Linux boot by the firmware.
The Microsoft doc referenced in patch 2 seem to agree with that:

   "On a system where the BIOS or system firmware uses the serial
    port for console input/output, this table should be used to convey
    information about the settings, to ensure a seamless transition
    between the firmware console output and Windows EMS output."

> +
>         /* On parsing error, pass the options buf to the setup function */
>         if (buf && !parse_options(&early_console_dev, buf))
>                 buf = NULL;

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
