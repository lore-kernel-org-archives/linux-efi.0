From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V6 2/2] x86/efi: Add efi page fault handler to recover
 from page faults caused by the firmware
Date: Wed, 12 Sep 2018 20:56:20 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1809122055190.1473@nanos.tec.linutronix.de>
References: <1536693322-8335-1-git-send-email-sai.praneeth.prakhya@intel.com> <1536693322-8335-3-git-send-email-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1536693322-8335-3-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, Al Stone <astone@redhat.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Bhupesh Sharma <bhsharma@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 11 Sep 2018, Sai Praneeth Prakhya wrote:
> diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
> index b18b2d864c2c..7455277a3b65 100644
> --- a/drivers/firmware/efi/runtime-wrappers.c
> +++ b/drivers/firmware/efi/runtime-wrappers.c
> @@ -61,6 +61,11 @@ struct efi_runtime_work efi_rts_work;
>  ({									\
>  	efi_rts_work.status = EFI_ABORTED;				\
>  									\
> +	if (!efi_enabled(EFI_RUNTIME_SERVICES)) {			\
> +		pr_info("Aborting! EFI Runtime Services disabled\n");	\

This probaby wants to be pr_info_ince().

Other than that:

      Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
