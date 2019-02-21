From: Zhangshaokun <zhangshaokun@hisilicon.com>
Subject: Re: linux-next: Tree for Feb 20
Date: Thu, 21 Feb 2019 08:43:22 +0800
Message-ID: <aaac08b0-6366-7b63-d6a7-eea6630ce169@hisilicon.com>
References: <20190220184341.73bd2084@canb.auug.org.au>
 <1114b964-8ff8-5632-64d4-e94a9160b998@hisilicon.com>
 <20190220095252.GA9089@linux.intel.com>
 <20190220095806.GB9089@linux.intel.com>
 <CAKv+Gu8G5eWeAdCB28xa=16ANFd2he9WPSztgXYwYRkhPfpEyA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu8G5eWeAdCB28xa=16ANFd2he9WPSztgXYwYRkhPfpEyA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Linux Next Mailing List <linux-next@vger.kernel.org>, Roberto Sassu <roberto.sassu@huawei.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>, linux-integrity <linux-integrity@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

Hi Ard,

On 2019/2/20 18:05, Ard Biesheuvel wrote:
> On Wed, 20 Feb 2019 at 10:58, Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
>>
>> On Wed, Feb 20, 2019 at 11:52:52AM +0200, Jarkko Sakkinen wrote:
>>> On Wed, Feb 20, 2019 at 05:11:15PM +0800, Zhangshaokun wrote:
>>>> There is a compiler failure on arm64 platform, as follow:
>>>>
>>>>   AS      arch/arm64/kvm/hyp.o
>>>>   CC      kernel/trace/ring_buffer.o
>>>> In file included from security/integrity/ima/ima_fs.c:30:0:
>>>> security/integrity/ima/ima.h:176:7: error: redeclaration of enumerator ‘NONE’
>>>>   hook(NONE)   \
>>>>        ^
>>>> security/integrity/ima/ima.h:188:34: note: in definition of macro ‘__ima_hook_enumify’
>>>>  #define __ima_hook_enumify(ENUM) ENUM,
>>>>                                   ^
>>>> security/integrity/ima/ima.h:191:2: note: in expansion of macro ‘__ima_hooks’
>>>>   __ima_hooks(__ima_hook_enumify)
>>>>   ^
>>>> In file included from ./arch/arm64/include/asm/acpi.h:15:0,
>>>>                  from ./include/acpi/acpi_io.h:7,
>>>>                  from ./include/linux/acpi.h:47,
>>>>                  from ./include/linux/tpm.h:26,
>>>>                  from security/integrity/ima/ima.h:25,
>>>>                  from security/integrity/ima/ima_fs.c:30:
>>>> ./include/linux/efi.h:1716:2: note: previous definition of ‘NONE’ was here
>>>>   NONE,
>>>>   ^
>>>> scripts/Makefile.build:276: recipe for target 'security/integrity/ima/ima_fs.o' failed
>>>> make[3]: *** [security/integrity/ima/ima_fs.o] Error 1
>>>>
>>>> I dug it and it is the commit 901615cb916d ("tpm: move tpm_chip definition to include/linux/tpm.h")
>>>
>>> This results from a new include in tpm.h:
>>>
>>>   #include <linux/acpi.h>
>>>
>>> Must be fixed either in include/linux/efi.h or security/integrity/ima.h as
>>> those files have a name collision. Makes me wonder why neither has taken
>>> care of prefixing the constants properly.
>>
>> Preferably both subsystems should be fixed with proper 'EFI_' and 'IMA_'
>> prefixes. Defining a constant named as NONE in a non-generic subsystem
>> (e.g. not part of the core data structures of Linux) and especially
>> exporting it to include/linux is not too well considered act.
>>
> 
> Fixes for this have already been proposed, and should appear in -next shortly
> 
> The EFI one is here
> https://mail.google.com/mail/u/0/#label/linux-efi/FMfcgxwBVgrQRjglPkWRqRqVclGgVDnB
> 

Because of no privilege, the website is denied for me. Anyway, it's nice to have been fixed.

Thanks,
Shaokun

> Not sure about the IMA one, Mimi should be able to comment ...
> 
> .
> 
