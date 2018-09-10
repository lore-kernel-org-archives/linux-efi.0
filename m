From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] x86/efi: earlyprintk - Add 64bit efi fb address support
Date: Mon, 10 Sep 2018 09:20:28 +0200
Message-ID: <20180910072028.GA47768@gmail.com>
References: <1536423828-5693-1-git-send-email-aaron.ma@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1536423828-5693-1-git-send-email-aaron.ma@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aaron Ma <aaron.ma@canonical.com>
Cc: ard.biesheuvel@linaro.org, tglx@linutronix.de, x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org


* Aaron Ma <aaron.ma@canonical.com> wrote:

>  	if (efi_fb)
>  		return (efi_fb + start);

Just noticed this detail unrelated to your patch: return is not a function.

Thanks,

	Ingo
