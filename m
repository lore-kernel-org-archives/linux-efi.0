From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 15/17] efi/x86: Ignore unrealistically large option roms
Date: Mon, 14 May 2018 08:40:51 +0200
Message-ID: <20180514064051.GA16596@gmail.com>
References: <20180504060003.19618-1-ard.biesheuvel@linaro.org>
 <20180504060003.19618-16-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180504060003.19618-16-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Hans de Goede <hdegoede@redhat.com>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> +	/*
> +	 * Some firmwares contain EFI function pointers at the place where the
> +	 * romimage and romsize fields are supposed to be. Typically the EFI
> +	 * code is mapped at high addresses, translating to an unrealistically
> +	 * large romsize. The UEFI spec limits the size of option ROMs to 16
> +	 * MiB so we reject any roms over 16 MiB in size to catch this.
> +	 */

JFYI, I fixed this:

 s/Some firmwares contain
  /Some firmware images contain

and:

 s/roms
  /ROMs

(Looks good otherwise, no need to resend.)

Thanks,

	Ingo
