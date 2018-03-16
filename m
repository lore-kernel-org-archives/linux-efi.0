From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 1/1] efi/libstub: tpm: zero initialize pointer variables
 for mixed mode
Date: Fri, 16 Mar 2018 15:02:50 +0200
Message-ID: <20180316130250.GD5035@linux.intel.com>
References: <20180313140922.17266-1-ard.biesheuvel@linaro.org>
 <20180313140922.17266-2-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180313140922.17266-2-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, hdegoede@redhat.com, tweek@google.com, javierm@redhat.com, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Tue, Mar 13, 2018 at 02:09:21PM +0000, Ard Biesheuvel wrote:
> As reported by Jeremy, running the new TPM libstub code in mixed mode
> (i.e., 64-bit kernel on 32-bit UEFI) results in hangs when invoking
> the TCG2 protocol, or when accessing the log_tbl pool allocation.
> 
> The reason turns out to be that in both cases, the 64-bit pointer
> variables are not fully initialized by the 32-bit EFI code, and so
> we should take care to zero initialize these variables beforehand,
> or we'll end up dereferencing bogus pointers.
> 
> Reported-by: Jeremy Cline <jeremy@jcline.org>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko
