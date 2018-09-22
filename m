From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v7 2/3] x86/boot/KASLR: Walk srat tables to filter
 immovable memory
Date: Sat, 22 Sep 2018 08:46:22 -0700
Message-ID: <CAGXu5j+amHGGCxC9PVrCfV8qNchyAyxd225F1rW2o2t=NRogDg@mail.gmail.com>
References: <20180913104629.5179-1-fanc.fnst@cn.fujitsu.com> <20180913104629.5179-3-fanc.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180913104629.5179-3-fanc.fnst@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chao Fan <fanc.fnst@cn.fujitsu.com>
Cc: linux-efi <linux-efi@vger.kernel.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Baoquan He <bhe@redhat.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On Thu, Sep 13, 2018 at 3:46 AM, Chao Fan <fanc.fnst@cn.fujitsu.com> wrote:
> If CONFIG_MEMORY_HOTREMOVE enabled, walk through the acpi srat memory
> tables and store those immovable memory regions so that kaslr can get
> where to choose for randomization.
>
> Signed-off-by: Chao Fan <fanc.fnst@cn.fujitsu.com>
> ---
>  arch/x86/boot/compressed/kaslr.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
> index 9ed9709d9947..0c3567bc231c 100644
> --- a/arch/x86/boot/compressed/kaslr.c
> +++ b/arch/x86/boot/compressed/kaslr.c
> @@ -417,6 +417,11 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
>         /* Mark the memmap regions we need to avoid */
>         handle_mem_options();
>
> +#ifdef CONFIG_MEMORY_HOTREMOVE
> +       /* Mark the immovable regions we need to choose */
> +       get_immovable_mem();
> +#endif

Style nit-pick: I'd prefer the definition of get_immovable_mem() do
the ifdef so it doesn't appear here.

-Kees

> +
>  #ifdef CONFIG_X86_VERBOSE_BOOTUP
>         /* Make sure video RAM can be used. */
>         add_identity_map(0, PMD_SIZE);
> --
> 2.17.1
>
>
>



-- 
Kees Cook
Pixel Security
