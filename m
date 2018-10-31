From: Chao Fan <fanc.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v10 0/7] x86/boot/KASLR: Parse ACPI table and limit kaslr
 in immovable memory
Date: Wed, 31 Oct 2018 15:42:34 +0800
Message-ID: <20181031074234.GB6609@localhost.localdomain>
References: <20181022093720.21426-1-fanc.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181022093720.21426-1-fanc.fnst@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, bhe@redhat.com, msys.mizuma@gmail.com
Cc: indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

Hi all,

Sorry for disturbance.
No reply to this version for more than one week,
any comments?

Thanks,
Chao Fan

On Mon, Oct 22, 2018 at 05:37:13PM +0800, Chao Fan wrote:
>***Background:
>People reported that kaslr may randomly chooses some positions
>which are located in movable memory regions. This will break memory
>hotplug feature and make the movable memory chosen by KASLR can't be
>removed.
>
>***Solutions:
>There should be a method to limit kaslr to choosing immovable memory
>regions, so there are 2 solutions:
>1) Add a kernel parameter to specify the memory regions.
>2) Get the information of memory hot-remove, then kaslr will know the
>   right regions.
>In method 2, information about memory hot-remove is in ACPI
>tables, which will be parsed after start_kernel(), kaslr can't get
>the information.
>In method 1, users should know the regions address and specify in
>kernel parameter.
>
>In the earliest time, I tried to dig ACPI tabls to solve this problem.
>But I didn't splite the code in 'compressed/' and ACPI code, so the patch
>is hard to follow so refused by community.
>Somebody suggest to add a kernel parameter to specify the
>immovable memory so that limit kaslr in these regions. Then I make
>a new patchset. After several versions, Ingo gave a suggestion:
>https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1634024.html
>Follow Ingo's suggestion, imitate the ACPI code to parse the acpi
>tables, so that the kaslr can get necessary memory information in
>ACPI tables.
>I think ACPI code is an independent part, so imitate the codes
>and functions to 'compressed/' directory, so that kaslr won't
>influence the initialization of ACPI.
>
>PATCH 1/7 Introduce cmdline_find_option_arg() to detect if option=arg
>          in cmdline
>PATCH 2/7 Copy kstrtoull() to compressed period, used to convert memory
>          address from string to unsigned long long.
>PATCH 3/7 Add efi_get_rsdp_addr() to dig out RSDP from EFI table when
>          booting from EFI.
>PATCH 4/7 Add bios_get_rsdp_addr() to search RSDP in memory when EFI
>          table not found.
>PATCH 5/7 Add get_acpi_rsdp() to parse RSDP in cmdline from kexec
>PATCH 6/7 Dig out SRAT table from RSDP and walk SRAT table to store
>          the immovable memory regions.
>PATCH 7/7 Calculate the intersection between memory regions from e820/efi
>          memory table and immovable memory regions. Limit KASLR choose
>          these regions for randomization.
>
>v1->v2:
> -  Simplify some code.
>Follow Baoquan He's suggestion:
> - Reuse the head file of acpi code.
>
>v2->v3:
> - Test in more conditions, so remove the 'RFC' tag.
> - Change some comments.
>
>v3->v4:
>Follow Thomas Gleixner's suggetsion:
> - Put the whole efi related function into #define CONFIG_EFI and return
>   false in the other stub.
>
>v4->v5:
>Follow Dou Liyang's suggestion:
> - Add more comments about some functions based on kernel code.
> - Change some typo in comments.
> - Clean useless variable.
> - Add check for the boundary of array.
> - Add check for 'movable_node' parameter
>
>v5->v6:
>Follow Baoquan He's suggestion:
> - Change some log.
> - Add the check for acpi_rsdp
> - Change some code logical to make code clear
>
>v6->v7:
>Follow Rafael's suggestion:
> - Add more comments and patch log.
>Follow test robot's suggestion:
> - Add "static" tag for function
>
>v7-v8:
>Follow Kees Cook's suggestion:
> - Use mem_overlaps() to check memory region.
> - Use #ifdef in the definition of function.
>
>v8-v9:
>Follow Boris' suggetion:
> - Change code style.
> - Splite PATCH 1/3 to more path.
> - Introduce some new function
> - Use existing function to rework some code
>Follow Masayoshi's suggetion:
> - Make code more readable
>
>v9->v10:
>Follow Baoquan's suggestion:
> - Change some log
> - Merge last two patch together.
>
>Any comments will be welcome.
>
>Chao Fan (7):
>  x86/boot: Introduce cmdline_find_option_arg()to detect if option=arg
>    in cmdline
>  x86/boot: Copy kstrtoull() to compressed period
>  x86/boot: Add efi_get_rsdp_addr() to dig out RSDP from EFI table
>  x86/boot: Add bios_get_rsdp_addr() to search RSDP in memory
>  x86/boot: Add get_acpi_rsdp() to parse RSDP in cmdlien from kexec
>  x86/boot: Dig out SRAT table from RSDP and find immovable memory
>  x86/boot/KASLR: Limit kaslr to choosing the immovable memory
>
> arch/x86/boot/compressed/Makefile  |   4 +
> arch/x86/boot/compressed/acpitb.c  | 352 +++++++++++++++++++++++++++++
> arch/x86/boot/compressed/cmdline.c |  15 ++
> arch/x86/boot/compressed/kaslr.c   |  81 +++++--
> arch/x86/boot/compressed/misc.c    |  88 ++++++++
> arch/x86/boot/compressed/misc.h    |  20 ++
> 6 files changed, 545 insertions(+), 15 deletions(-)
> create mode 100644 arch/x86/boot/compressed/acpitb.c
>
>-- 
>2.17.2
>
