From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V2 2/2] x86/efi: Move efi_<reserve/free>_boot_services()
 to arch/x86
Date: Mon, 29 Oct 2018 18:14:35 +0100 (CET)
Message-ID: <alpine.DEB.2.21.1810291814200.5984@nanos.tec.linutronix.de>
References: <20181026213845.28166-1-sai.praneeth.prakhya@intel.com> <20181026213845.28166-3-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181026213845.28166-3-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@intel.com>, Bhupesh Sharma <bhsharma@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 26 Oct 2018, Sai Praneeth Prakhya wrote:

> efi_<reserve/free>_boot_services() are x86 specific quirks and as such
> should be in asm/efi.h, so move them from linux/efi.h. Also, call
> efi_free_boot_services() from __efi_enter_virtual_mode() as it is x86
> specific call and ideally shouldn't be part of init/main.c
> 
> Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>

Acked-by: Thomas Gleixner <tglx@linutronix.de>
