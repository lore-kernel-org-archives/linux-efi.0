From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 5/5] efi: permit calling efi_mem_reserve_persistent from
 atomic context
Date: Tue, 27 Nov 2018 20:16:47 +0100
Message-ID: <CAKv+Gu8HFq0EnQv6PBVXqO5=WCBqA=ztwb+-otrpBz+J9SnHfA@mail.gmail.com>
References: <20181114175544.12860-1-ard.biesheuvel@linaro.org>
 <20181114175544.12860-6-ard.biesheuvel@linaro.org> <a8346212-70cb-0bbb-9e29-e21fa2ee5040@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a8346212-70cb-0bbb-9e29-e21fa2ee5040@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeremy Linton <jeremy.linton@arm.com>
Cc: linux-efi <linux-efi@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 27 Nov 2018 at 19:59, Jeremy Linton <jeremy.linton@arm.com> wrote:
>
> Hi Ard,
>
>
> On 11/14/2018 11:55 AM, Ard Biesheuvel wrote:
> > Currently, efi_mem_reserve_persistent() may not be called from atomic
> > context, since both the kmalloc() call and the memremap() call may
> > sleep.
> >
> > The kmalloc() call is easy enough to fix, but the memremap() call
> > needs to be moved into an init hook since we cannot control the
> > memory allocation behavior of memremap() at the call site.
>
> So, at first glance this looks correct until I noticed that
> its_cpu_init_lpis() is being called before the early_initcalls are run.
>
> This results in the WARN_ON triggering with the following backtrace:
>
> [    0.000000]  its_cpu_init_lpis+0x1d4/0x2e0
> [    0.000000]  its_cpu_init+0x78/0x1b4
> [    0.000000]  gic_init_bases+0x2c4/0x2e0
> [    0.000000]  gic_acpi_init+0x158/0x270
> [    0.000000]  acpi_match_madt+0x4c/0x84
> [    0.000000]  acpi_table_parse_entries_array+0x140/0x218
> [    0.000000]  acpi_table_parse_entries+0x70/0x98
> [    0.000000]  acpi_table_parse_madt+0x40/0x50
> [    0.000000]  __acpi_probe_device_table+0x88/0xe0
> [    0.000000]  irqchip_init+0x38/0x40
> [    0.000000]  init_IRQ+0xfc/0x130
> [    0.000000]  start_kernel+0x344/0x4cc
>
> due to the efi_memreserve_root not yet being set.
>

Yup

https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/commit/?h=efi/urgent&id=976b489120cdab2b1b3a41ffa14661db43d58190

That should fix it. Please let me know if it doesn't work for you
