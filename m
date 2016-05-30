From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2] arm64:efi fix the format of debug message from efi
Date: Mon, 30 May 2016 22:53:21 +0100
Message-ID: <20160530215321.GI2984@codeblueprint.co.uk>
References: <1464341244-14152-1-git-send-email-dennis.chen@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1464341244-14152-1-git-send-email-dennis.chen-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Chen <dennis.chen-5wv7dgnIgG8@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, steve.capper-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.orgnd-5wv7dgnIgG8@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 27 May, at 05:27:24PM, Dennis Chen wrote:
> When enable debug of efi and memblock with 'efi=debug memblock=debug' appended
> to the kernel command line, the debug message output for earyly_con looks like:
> 
> [    0.000000] efi:   0x0000e1050000-0x0000e105ffff [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   |  |  |  |UC]
> [    0.000000] efi:   0x0000e1300000-0x0000e1300fff [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   |  |  |  |UC]
> [    0.000000] efi:   0x0000e8200000-0x0000e827ffff [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   |  |  |  |UC]
> [    0.000000] efi:   0x008000000000-0x008001e7ffff [Runtime Data       |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] memblock_add: [0x00008000000000-0x00008001e7ffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
> [    0.000000] *
> ...
> 
> This patch is trying to fix the above output messed up by memblock_add(), so we can get below debug mesg looks
> more formally after applied:
> 
> [    0.000000] efi:   0x0000e1050000-0x0000e105ffff [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   |  |  |  |UC]
> [    0.000000] efi:   0x0000e1300000-0x0000e1300fff [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   |  |  |  |UC]
> [    0.000000] efi:   0x0000e8200000-0x0000e827ffff [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   |  |  |  |UC]
> [    0.000000] efi:   0x008000000000-0x008001e7ffff [Runtime Data       |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC]*
> [    0.000000] memblock_add: [0x00008000000000-0x00008001e7ffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
> ...
> 
> Signed-off-by: Dennis Chen <dennis.chen-5wv7dgnIgG8@public.gmane.org>
> Acked-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
> Cc: Steve Capper <steve.capper-5wv7dgnIgG8@public.gmane.org>
> Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
> Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> 
> Since v1[1]:
>  According to the suggestion from Mark Rutland, v2 folds the pr_cont("\n") into pr_info.
>  [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2016-May/431233.html
> ---
>  drivers/firmware/efi/arm-init.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)

Thanks, applied.
