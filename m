From: Chao Fan <fanc.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v9 3/8] x86/boot: Add efi_get_rsdp_addr() to dig out RSDP
 from EFI table
Date: Thu, 18 Oct 2018 13:54:03 +0800
Message-ID: <20181018055403.GE12871@localhost.localdomain>
References: <20181017102012.872-1-fanc.fnst@cn.fujitsu.com>
 <20181017102012.872-4-fanc.fnst@cn.fujitsu.com>
 <20181018043539.GF1885@192.168.1.4>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181018043539.GF1885@192.168.1.4>
Sender: linux-kernel-owner@vger.kernel.org
To: Baoquan He <bhe@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, msys.mizuma@gmail.com, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On Thu, Oct 18, 2018 at 12:35:39PM +0800, Baoquan He wrote:
>On 10/17/18 at 06:20pm, Chao Fan wrote:
>> There is a bug that kaslr may randomly choose some positions
>> which are located in movable memory regions. This will break memory
>> hotplug feature and make the movable memory chosen by KASLR can't be
>> removed. So dig SRAT table from ACPI tables to get memory information.
>
>This patch is only adding a function efi_get_rsdp_addr() which will be
>used in later patch. Do we need to describe bug here?

Yes, it's the first mail of this serial, so I add more log.
>
>Can we focus on what is this function, and why it's written like that,
>and why it's here?

Sure.
I am just afraid lack of log.

Thanks,
Chao Fan

>> 
>> Imitate the ACPI code of parsing ACPI tables to dig and read ACPI
>> tables. Since some operations are not needed here, functions are
>> simplified. Functions will be used to dig only SRAT tables to get
>> information of memory, so that KASLR can the memory in immovable node.
>> 
>
>
