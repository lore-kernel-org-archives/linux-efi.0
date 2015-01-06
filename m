From: Leif Lindholm <leif.lindholm@linaro.org>
Subject: Re: [PATCH v4 5/8] arm64/efi: set EFI_ALLOC_ALIGN to 64 KB
Date: Tue, 6 Jan 2015 16:37:00 +0000
Message-ID: <20150106163700.GD3827@bivouac.eciton.net>
References: <1419245944-2424-1-git-send-email-ard.biesheuvel@linaro.org>
 <1419245944-2424-6-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1419245944-2424-6-git-send-email-ard.biesheuvel@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: mark.rutland@arm.com, linux-efi@vger.kernel.org, geoff.levand@linaro.org, catalin.marinas@arm.com, will.deacon@arm.com, roy.franz@linaro.org, matt.fleming@intel.com, bp@alien8.de, msalter@redhat.com, dyoung@redhat.com, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

On Mon, Dec 22, 2014 at 10:59:01AM +0000, Ard Biesheuvel wrote:
> Set EFI_ALLOC_ALIGN to 64 KB so that all allocations done by the stub
> are naturally compatible with a 64 KB granule kernel.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm64/include/asm/efi.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
> index a34fd3b12e2b..71291253114f 100644
> --- a/arch/arm64/include/asm/efi.h
> +++ b/arch/arm64/include/asm/efi.h
> @@ -44,4 +44,6 @@ extern void efi_idmap_init(void);
>  
>  #define efi_call_early(f, ...) sys_table_arg->boottime->f(__VA_ARGS__)
>  
> +#define EFI_ALLOC_ALIGN		SZ_64K
> +
>  #endif /* _ASM_EFI_H */
> -- 
> 1.8.3.2

Acked-by: Leif Lindholm <leif.lindholm@linaro.org>
