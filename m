From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 08/29] efi: Allow drivers to reserve boot services forever
Date: Wed, 4 Jan 2017 10:40:35 -0800
Message-ID: <CAPcyv4idAA0C0DoY7ea4y691zMn8D4KV1Y_PEmMjUQYfwjVpYw@mail.gmail.com>
References: <20160909151851.27577-1-matt@codeblueprint.co.uk>
 <20160909151851.27577-9-matt@codeblueprint.co.uk> <CAA9_cmffnH0CH+3DaUW3ytVnRWbZCHa1VcAfWgwMCfbncN_QcA@mail.gmail.com>
 <87y3yq3eii.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87y3yq3eii.fsf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicolai Stange <nicstange@gmail.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Dave Young <dyoung@redhat.com>, Leif Lindholm <leif.lindholm@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Peter Jones <pjones@redhat.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>, poros@redhat.com
List-Id: linux-efi@vger.kernel.org

On Wed, Jan 4, 2017 at 9:45 AM, Nicolai Stange <nicstange@gmail.com> wrote:
> Dan Williams <dan.j.williams@intel.com> writes:
>
>> This commit appears to cause a boot regression between v4.8 and v4.9.
>>
>> BUG: unable to handle kernel paging request at ffff8830281bf1c8
>> IP: [<ffffffff81a21266>] __next_mem_range_rev+0x13a/0x1d6
>> PGD 3193067 PUD 3196067 PTE 80000030281bf060
>> Oops: 0000 1 SMP DEBUG_PAGEALLOC
>> Modules linked in:
>> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.9.0+ #2
>> task: ffffffff82011540 task.stack: ffffffff82000000
>> RIP: 0010:[<ffffffff81a21266>] [<ffffffff81a21266>]
>> __next_mem_range_rev+0x13a/0x1d6
>> RSP: 0000:ffffffff82003dd8 EFLAGS: 00010202
>> RAX: ffff8830281bf1e0 RBX: ffffffff82003e60 RCX: ffffffff82167490
>> RDX: 0000000000000000 RSI: 00000000ffffffff RDI: 0000001840000000
>> RBP: ffffffff82003e18 R08: ffffffff821674b0 R09: 000000000000008f
>> R10: 000000000000008f R11: ffffffff82011cf0 R12: 0000000000000004
>> R13: 0000003040000000 R14: 0000000000000000 R15: 0000000000000001
>> FS: 0000000000000000(0000) GS:ffff8817e0800000(0000) knlGS:0000000000000000
>> CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: ffff8830281bf1c8 CR3: 000000000200a000 CR4: 00000000007406f0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> PKRU: 00000000
>> Stack:
>> ffffea0000001700 ffffffff82003e50 0000000000000000
>> 00000000000010000000003040000000 ffffffff82003e58 0000000000000180
>> ffffffffffffffc0
>> ffffffff82003e98 ffffffff81a21395 ffffffff82003e58 0000000000000000
>> Call Trace:
>> [<ffffffff81a21395>] memblock_find_in_range_node+0x93/0x13a
>> [<ffffffff8221e3b1>] memblock_alloc_range_nid+0x1b/0x3e
>> [<ffffffff8221e5b9>] __memblock_alloc_base+0x15/0x17
>> [<ffffffff8221e5cd>] memblock_alloc_base+0x12/0x2e
>> [<ffffffff8221e5f4>] memblock_alloc+0xb/0xd
>> [<ffffffff82208e22>] efi_free_boot_services+0x46/0x180
>> [<ffffffff821e818b>] start_kernel+0x4a1/0x4cc
>> [<ffffffff821e7ad8>] ? set_init_arg+0x55/0x55
>> [<ffffffff821e7120>] ? early_idt_handler_array+0x120/0x120
>> [<ffffffff821e75d6>] x86_64_start_reservations+0x2a/0x2c
>> [<ffffffff821e7724>] x86_64_start_kernel+0x14c/0x16f
>> Code: 18 44 89 38 41 8d 44 24 ff 49 c1 e1 20 4c 09 c8 48 89 03 e9 a0
>> 00 00 00 4d 63 d1 4c 89 d0 48 c1 e0 05 49 03 40 18 45 85 c9 74 28 <48>
>> 8b 50 e8 48 03 50 e0 49 83 cb ff 4d 3b 10 73 03 4c 8b 18 49 ^M
>> RIP [<ffffffff81a21266>] __next_mem_range_rev+0x13a/0x1d6
>>
>> I also see that Petr may have run into it as well [1]? Petr is this
>> the same signature you are seeing? Can you post a boot log with
>> "efi=debug" on the kernel command line?
>>
>> It also fails on 4.10-rc2.  However, if I revert the following commits
>> it boots fine:
>>
>> 4bc9f92e64c8 x86/efi-bgrt: Use efi_mem_reserve() to avoid copying image data
>> 8e80632fb23f efi/esrt: Use efi_mem_reserve() and avoid a kmalloc()
>> 816e76129ed5 efi: Allow drivers to reserve boot services forever
>>
>> [1]: https://lkml.org/lkml/2016/12/21/197
>
>
> Looks very similiar to a problem I've seen with DEBUG_PAGEALLOC=y.
>
> Can you try whether this patch
>
>   http://lkml.kernel.org/r/20161222102340.2689-1-nicstange@gmail.com
>
> fixes it for you?
>
> It makes efi_free_boot_services() not to call into the memblock
> allocator -- it must not do that after mm_init().

Indeed it does. Thanks!
