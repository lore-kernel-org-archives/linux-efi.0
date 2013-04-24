From: Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v2] efi: Check EFI revision in setup_efi_vars
Date: Wed, 24 Apr 2013 16:20:04 +0100
Message-ID: <5177F824.3080506@intel.com>
References: <20130424143738.GB15272@hansolo.jdub.homelinux.org> <5177EFCE.80104@intel.com> <20130424145449.GC15272@hansolo.jdub.homelinux.org> <5177F2C3.5080907@intel.com> <1366815685.9976.0.camel@x230> <20130424151652.GD15272@hansolo.jdub.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130424151652.GD15272@hansolo.jdub.homelinux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Boyer <jwboyer@redhat.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 24/04/13 16:16, Josh Boyer wrote:
> We need to check the runtime sys_table for the EFI version the firmware
> specifies instead of just checking for a NULL QueryVariableInfo.  Older
> implementations of EFI don't have QueryVariableInfo but the runtime is
> a smaller structure, so the pointer to it may be pointing off into garbage.
> 
> This is apparently the case with several Apple firmwares that support EFI
> 1.10, and the current check causes them to no longer boot.  Fix based on
> a suggestion from Matthew Garrett.
> 
> Signed-off-by: Josh Boyer <jwboyer@redhat.com>
> ---
>  v2: Drop the unnecessary NULL check
> 
>  arch/x86/boot/compressed/eboot.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks, applied.
