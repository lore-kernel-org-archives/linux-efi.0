From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v4] efi: arm64: Add vmlinux debug link to the Image binary
Date: Thu, 2 Feb 2017 18:36:47 +0000
Message-ID: <CAKv+Gu82NmBNavpVQ8z7xZ6++HPqAWNnn3dM=dKw0JaWLZocSw@mail.gmail.com>
References: <1486056799-4825-1-git-send-email-ard.biesheuvel@linaro.org>
 <20170202183000.GN13839@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20170202183000.GN13839@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Leif Lindholm <leif.lindholm@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On 2 February 2017 at 18:30, Will Deacon <will.deacon@arm.com> wrote:
> Hi Ard,
>
> On Thu, Feb 02, 2017 at 05:33:19PM +0000, Ard Biesheuvel wrote:
>> When building with debugging symbols, take the absolute path to the
>> vmlinux binary and add it to the special PE/COFF debug table entry.
>> This allows a debug EFI build to find the vmlinux binary, which is
>> very helpful in debugging, given that the offset where the Image is
>> first loaded by EFI is highly unpredictable.
>>
>> On implementations of UEFI that choose to implement it, this
>> information is exposed via the EFI debug support table, which is a UEFI
>> configuration table that is accessible both by the firmware at boot time
>> and by the OS at runtime, and lists all PE/COFF images loaded by the
>> system.
>>
>> The format of the NB10 Codeview entry is based on the definition used
>> by EDK2, which is our primary reference when it comes to the use of
>> PE/COFF in the context of UEFI firmware.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>> v4: add a separate DEBUG_EFI debug option so that this feature is disabled
>>     by default
>>     dropped 1/2 which has been queued already in the EFI tree
>>     use ASCII rather than an opaque constant for "NB10" signature
>>
>>  arch/arm64/Kconfig.debug   |  8 ++++
>>  arch/arm64/kernel/Makefile |  4 ++
>>  arch/arm64/kernel/head.S   | 47 +++++++++++++++++++-
>>  3 files changed, 58 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
>> index d1ebd46872fd..f7f38b1aab14 100644
>> --- a/arch/arm64/Kconfig.debug
>> +++ b/arch/arm64/Kconfig.debug
>> @@ -95,6 +95,14 @@ config DEBUG_ALIGN_RODATA
>>
>>         If in doubt, say N.
>>
>> +config DEBUG_EFI
>> +     depends on EFI && DEBUG_INFO
>> +     bool "UEFI debugging"
>> +     help
>> +       Enable this option to include EFI specific debugging features into
>> +       the kernel that are only useful when using a debug build of the
>> +       UEFI firmware
>> +
>
> I don't much like embedding the absolute host build path in the kernel
> image, but if that's what the tools expect then so be it.
>
>>  source "drivers/hwtracing/coresight/Kconfig"
>>
>>  endmenu
>> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
>> index 7d66bbaafc0c..2600c60337ac 100644
>> --- a/arch/arm64/kernel/Makefile
>> +++ b/arch/arm64/kernel/Makefile
>> @@ -55,3 +55,7 @@ obj-y                                       += $(arm64-obj-y) vdso/ probes/
>>  obj-m                                        += $(arm64-obj-m)
>>  head-y                                       := head.o
>>  extra-y                                      += $(head-y) vmlinux.lds
>> +
>> +ifeq ($(CONFIG_DEBUG_EFI),y)
>> +AFLAGS_head.o += -DVMLINUX_PATH="\"$(shell readlink -f $(objtree)/vmlinux)\""
>> +endif
>
> Can we use the Make realpath directive instead of calling out to the shell?
>

Yep. This works as expected:

diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 2600c60337ac..1606c6b2a280 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -57,5 +57,5 @@ head-y                                        := head.o
 extra-y                                        += $(head-y) vmlinux.lds

 ifeq ($(CONFIG_DEBUG_EFI),y)
-AFLAGS_head.o += -DVMLINUX_PATH="\"$(shell readlink -f $(objtree)/vmlinux)\""
+AFLAGS_head.o += -DVMLINUX_PATH="\"$(realpath $(objtree)/vmlinux)\""
 endif


> Do you want me to merge this via arm64?
>

Yes, please
