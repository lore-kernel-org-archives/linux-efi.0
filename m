From: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH] x86/efi: Preface all print statements with efi* tag
Date: Sun, 25 Oct 2015 19:39:55 +0900
Message-ID: <20151025103954.GC1562@x>
References: <1445768795-5472-1-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1445768795-5472-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>
List-Id: linux-efi@vger.kernel.org

On Sun, Oct 25, 2015 at 10:26:35AM +0000, Matt Fleming wrote:
> The pr_*() calls in the x86 EFI code may or may not include a
> subsystem tag, which makes it difficult to grep the kernel log for all
> relevant EFI messages and leads users to miss important information.
> 
> Recently, a bug reporter provided all the EFI print messages from the
> kernel log when trying to diagnose an issue but missed the following
> statement because it wasn't prefixed with anything indicating it was
> related to EFI,
> 
>   pr_err("Error ident-mapping new memmap (0x%lx)!\n", pa_memmap);
> 
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>

Good call.

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> ---
>  arch/x86/platform/efi/efi-bgrt.c | 3 +++
>  arch/x86/platform/efi/efi_64.c   | 2 ++
>  arch/x86/platform/efi/quirks.c   | 4 +++-
>  3 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/efi-bgrt.c
> index ea48449b2e63..9a52b5c4438f 100644
> --- a/arch/x86/platform/efi/efi-bgrt.c
> +++ b/arch/x86/platform/efi/efi-bgrt.c
> @@ -10,6 +10,9 @@
>   * it under the terms of the GNU General Public License version 2 as
>   * published by the Free Software Foundation.
>   */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/kernel.h>
>  #include <linux/init.h>
>  #include <linux/acpi.h>
> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index a0ac0f9c307f..d347e854a5e4 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -15,6 +15,8 @@
>   *
>   */
>  
> +#define pr_fmt(fmt) "efi: " fmt
> +
>  #include <linux/kernel.h>
>  #include <linux/init.h>
>  #include <linux/mm.h>
> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
> index 1c7380da65ff..6452070f3025 100644
> --- a/arch/x86/platform/efi/quirks.c
> +++ b/arch/x86/platform/efi/quirks.c
> @@ -1,3 +1,5 @@
> +#define pr_fmt(fmt) "efi: " fmt
> +
>  #include <linux/init.h>
>  #include <linux/kernel.h>
>  #include <linux/string.h>
> @@ -256,7 +258,7 @@ void __init efi_apply_memmap_quirks(void)
>  	 * services.
>  	 */
>  	if (!efi_runtime_supported()) {
> -		pr_info("efi: Setup done, disabling due to 32/64-bit mismatch\n");
> +		pr_info("Setup done, disabling due to 32/64-bit mismatch\n");
>  		efi_unmap_memmap();
>  	}
>  
> -- 
> 2.6.0
> 
