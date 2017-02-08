From: Timur Tabi <timur@codeaurora.org>
Subject: Re: [PATCH v3 06/10] arm64: efi: add EFI stub
Date: Wed, 8 Feb 2017 10:28:11 -0600
Message-ID: <CAOZdJXWU1dmFfCc88RMp3SvouU7roDiJsA=3aHzwijwhMH7naA@mail.gmail.com>
References: <1396637113-22790-1-git-send-email-leif.lindholm@linaro.org>
 <1396637113-22790-7-git-send-email-leif.lindholm@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1396637113-22790-7-git-send-email-leif.lindholm@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: linux-efi@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, lkml <linux-kernel@vger.kernel.org>, Matt Fleming <matt.fleming@intel.com>, Mark Salter <msalter@redhat.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Apr 4, 2014 at 1:45 PM, Leif Lindholm <leif.lindholm@linaro.org> wrote:
>
> +/*
> + * EFI entry point for the arm/arm64 EFI stubs.  This is the entrypoint
> + * that is described in the PE/COFF header.  Most of the code is the same
> + * for both archictectures, with the arch-specific code provided in the
> + * handle_kernel_image() function.
> + */
> +unsigned long __init efi_entry(void *handle, efi_system_table_t *sys_table,
> +                              unsigned long *image_addr)
> +{

...

> +
> +       status = handle_cmdline_files(sys_table, image, cmdline_ptr,
> +                                     "initrd=", dram_base + SZ_512M,
> +                                     (unsigned long *)&initrd_addr,
> +                                     (unsigned long *)&initrd_size);

So I know this patch is almost three years old, but why is there a
512M limit on the initrd size?

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
