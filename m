From: Baoquan He <bhe@redhat.com>
Subject: Re: [PATCH v9 0/8] x86/boot/KASLR: Parse ACPI table and limit kaslr
 in immovable memory
Date: Thu, 18 Oct 2018 11:59:58 +0800
Message-ID: <20181018035958.GA1885@192.168.1.4>
References: <20181017102012.872-1-fanc.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181017102012.872-1-fanc.fnst@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chao Fan <fanc.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, msys.mizuma@gmail.com, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On 10/17/18 at 06:20pm, Chao Fan wrote:
> In the earliest time, I tried to dig ACPI tabls to solve this problem.
> But I didn't splite the code in 'compressed/' and ACPI code, so the patch
> is hard to follow so refused by community.
> Somebody suggest to add a kernel parameter to specify the
> immovable memory so that limit kaslr in these regions. Then I make
> a new patchset. After several versions, Ingo gave a suggestion:
> https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1634024.html
> Follow Ingo's suggestion, imitate the ACPI code to parse the acpi
> tables, so that the kaslr can get necessary memory information in
> ACPI tables.
> I think ACPI code is an independent part, so imitate the codes
> and functions to 'compressed/' directory, so that kaslr won't
> influence the initialization of ACPI.
> 
> PATCH 1/3 Add acpitb.c to provide functions to parse ACPI code.
> PATCH 2/3 If CONFIG_MEMORY_HOTREMOVE enabled, walk all nodes and
>           store the information of immovable memory regions.
> PATCH 3/3 According to the immovable memory regions, filter the
>           immovable regions which KASLR can choose.

Chao, seems you didn't update above accordingly.

> 
> v1->v2:
>  -  Simplify some code.
> Follow Baoquan He's suggestion:
>  - Reuse the head file of acpi code.
> 
> v2->v3:
>  - Test in more conditions, so remove the 'RFC' tag.
>  - Change some comments.
> 
> v3->v4:
> Follow Thomas Gleixner's suggetsion:
>  - Put the whole efi related function into #define CONFIG_EFI and return
>    false in the other stub.
>  - Simplify two functions in head file.
> 
> v4->v5:
> Follow Dou Liyang's suggestion:
>  - Add more comments about some functions based on kernel code.
>  - Change some typo in comments.
>  - Clean useless variable.
>  - Add check for the boundary of array.
>  - Add check for 'movable_node' parameter
> 
> v5->v6:
> Follow Baoquan He's suggestion:
>  - Change some log.
>  - Add the check for acpi_rsdp
>  - Change some code logical to make code clear
> 
> v6->v7:
> Follow Rafael's suggestion:
>  - Add more comments and patch log.
> Follow test robot's suggestion:
>  - Add "static" tag for function
> 
> v7-v8:
> Follow Kees Cook's suggestion:
>  - Use mem_overlaps() to check memory region.
>  - Use #ifdef in the definition of function.
> 
> v8-v9:
> Follow Boris' suggetion:
>  - Change code style.
>  - Splite PATCH 1/3 to more path.
>  - Introduce some new function
>  - Use existing function to rework some code
> Follow Masayoshi's suggetion:
>  - Make code more readable
> 
> Any comments will be welcome.
> 
> 
> Chao Fan (8):
>   x86/boot: Introduce cmdline_find_option_arg()to detect if option=arg
>     in cmdline
>   x86/boot: Copy kstrtoull() to compressed period
>   x86/boot: Add efi_get_rsdp_addr() to dig out RSDP from EFI table
>   x86/boot: Add bios_get_rsdp_addr() to search RSDP in memory
>   x86/boot: Add get_acpi_rsdp() to parse RSDP in cmdlien from kexec
>   x86/boot: Dig out SRAT table from RSDP and find immovable memory
>   x86/boot/KASLR: Walk srat tables to filter immovable memory
>   x86/boot/KASLR: Limit kaslr to choosing the immovable memory
> 
>  arch/x86/boot/compressed/Makefile  |   4 +
>  arch/x86/boot/compressed/acpitb.c  | 354 +++++++++++++++++++++++++++++
>  arch/x86/boot/compressed/cmdline.c |  15 ++
>  arch/x86/boot/compressed/kaslr.c   |  77 ++++++-
>  arch/x86/boot/compressed/misc.c    |  88 +++++++
>  arch/x86/boot/compressed/misc.h    |  15 ++
>  6 files changed, 542 insertions(+), 11 deletions(-)
>  create mode 100644 arch/x86/boot/compressed/acpitb.c
> 
> -- 
> 2.17.2
> 
> 
> 
