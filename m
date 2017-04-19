From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH v5 01/32] x86: Documentation for AMD Secure Memory
	Encryption (SME)
Date: Wed, 19 Apr 2017 11:02:24 +0200
Message-ID: <20170419090224.frmv2jhwfwoxvdie@pd.tnic>
References: <20170418211612.10190.82788.stgit@tlendack-t1.amdoffice.net>
	<20170418211625.10190.52568.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170418211625.10190.52568.stgit-qCXWGYdRb2BnqfbPTmsdiZQ+2ll4COg0XqFh9Ls21Oc@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, "Michael S. Tsirkin" <mst@r>
List-Id: linux-efi@vger.kernel.org

Always have a verb in the Subject to form a "do this" or "do that"
sentence to better explain what the patch does:

"Subject: [PATCH v5 01/32] x86: Add documentation for AMD Secure Memory Encryption (SME)"

On Tue, Apr 18, 2017 at 04:16:25PM -0500, Tom Lendacky wrote:
> Create a Documentation entry to describe the AMD Secure Memory
> Encryption (SME) feature and add documentation for the mem_encrypt=
> kernel parameter.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
> ---
>  Documentation/admin-guide/kernel-parameters.txt |   11 ++++
>  Documentation/x86/amd-memory-encryption.txt     |   60 +++++++++++++++++++++++
>  2 files changed, 71 insertions(+)
>  create mode 100644 Documentation/x86/amd-memory-encryption.txt
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 3dd6d5d..84c5787 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2165,6 +2165,17 @@
>  			memory contents and reserves bad memory
>  			regions that are detected.
>  
> +	mem_encrypt=	[X86-64] AMD Secure Memory Encryption (SME) control
> +			Valid arguments: on, off
> +			Default (depends on kernel configuration option):
> +			  on  (CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT=y)
> +			  off (CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT=n)
> +			mem_encrypt=on:		Activate SME
> +			mem_encrypt=off:	Do not activate SME
> +
> +			Refer to Documentation/x86/amd-memory-encryption.txt
> +			for details on when memory encryption can be activated.
> +
>  	mem_sleep_default=	[SUSPEND] Default system suspend mode:
>  			s2idle  - Suspend-To-Idle
>  			shallow - Power-On Suspend or equivalent (if supported)
> diff --git a/Documentation/x86/amd-memory-encryption.txt b/Documentation/x86/amd-memory-encryption.txt
> new file mode 100644
> index 0000000..0b72ff2
> --- /dev/null
> +++ b/Documentation/x86/amd-memory-encryption.txt
> @@ -0,0 +1,60 @@
> +Secure Memory Encryption (SME) is a feature found on AMD processors.
> +
> +SME provides the ability to mark individual pages of memory as encrypted using
> +the standard x86 page tables.  A page that is marked encrypted will be
> +automatically decrypted when read from DRAM and encrypted when written to
> +DRAM.  SME can therefore be used to protect the contents of DRAM from physical
> +attacks on the system.
> +
> +A page is encrypted when a page table entry has the encryption bit set (see
> +below on how to determine its position).  The encryption bit can be specified
> +in the cr3 register, allowing the PGD table to be encrypted. Each successive

I missed that the last time: do you mean here, "The encryption bit can
be specified in the %cr3 register allowing for the page table hierarchy
itself to be encrypted."?

> +level of page tables can also be encrypted.

Right, judging by the next sentence, it looks like it.

The rest looks and reads really nice to me, so feel free to add:

Reviewed-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>

after addressing those minor nitpicks on your next submission.

Thanks.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
