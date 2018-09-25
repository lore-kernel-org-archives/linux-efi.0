From: Chao Fan <fanc.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v7 1/3] x86/boot: Add acpitb.c to parse acpi tables
Date: Tue, 25 Sep 2018 09:12:46 +0800
Message-ID: <20180925011246.GB12561@localhost.localdomain>
References: <20180913104629.5179-1-fanc.fnst@cn.fujitsu.com>
 <20180913104629.5179-2-fanc.fnst@cn.fujitsu.com>
 <CAGXu5j+LxEpoKAkEo8GQa-f729_Ebavgtnv+DA9bxf9XEz2QPQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5j+LxEpoKAkEo8GQa-f729_Ebavgtnv+DA9bxf9XEz2QPQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: linux-efi <linux-efi@vger.kernel.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Baoquan He <bhe@redhat.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On Sat, Sep 22, 2018 at 08:45:12AM -0700, Kees Cook wrote:
>On Thu, Sep 13, 2018 at 3:46 AM, Chao Fan <fanc.fnst@cn.fujitsu.com> wrote:
>> There is a bug that kaslr may randomly chooses some positions
>> which are located in movable memory regions. This will break memory
>> hotplug feature and make the movable memory chosen by KASLR can't be
>> removed. So dig SRAT table from ACPI tables to get memory information.
>>
>> Imitate the ACPI code of parsing ACPI tables to dig and read ACPI
>> tables. Since some operations are not needed here, functions are
>> simplified. Functions will be used to dig only SRAT tables to get
>> information of memory, so that KASLR can the memory in immovable node.
>>
>> And also, these functions won't influence the initialization of
>> ACPI after start_kernel().
>>
>> Since use physical address directely, so acpi_os_map_memory()
>> and acpi_os_unmap_memory() are not needed.
>>
>> Signed-off-by: Chao Fan <fanc.fnst@cn.fujitsu.com>
>> ---
>>  arch/x86/boot/compressed/Makefile |   4 +
>>  arch/x86/boot/compressed/acpitb.c | 401 ++++++++++++++++++++++++++++++
>
>Does this logic live anywhere else in the kernel already? (i.e. could
>other code be reused?)

Live in uncompressec period, but not completely same.
The map between physical address and virtual address is not needed here.
So I thins it's hard to reuse, that's why I made this new file.

Thanks,
Chao Fan

>
>-Kees
>
>-- 
>Kees Cook
>Pixel Security
>
>
