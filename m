From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2] arm64/efi: don't pad between EFI_MEMORY_RUNTIME regions
Date: Thu, 10 Sep 2015 16:51:05 +0200
Message-ID: <CAKv+Gu-U0zcQpqXeb4BoRL+BcJvJ0dxRx6gZb77eJc520Spd2w@mail.gmail.com>
References: <1441371986-4554-1-git-send-email-ard.biesheuvel@linaro.org>
 <1441782414-16284-1-git-send-email-ard.biesheuvel@linaro.org>
 <20150910132211.GF29293@leverpostej>
 <CAKv+Gu91fT=bQ1C3AETDCeKzgJ0fpwm1+gdKF02F7t8VzqVYFA@mail.gmail.com>
 <20150910140419.GH29293@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20150910140419.GH29293@leverpostej>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <Will.Deacon@arm.com>, "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>, "matt.fleming@intel.com" <matt.fleming@intel.com>, "msalter@redhat.com" <msalter@redhat.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On 10 September 2015 at 16:04, Mark Rutland <mark.rutland@arm.com> wrote:
>> >> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
>> >> index e8ca6eaedd02..13671a9cf016 100644
>> >> --- a/arch/arm64/kernel/efi.c
>> >> +++ b/arch/arm64/kernel/efi.c
>> >> @@ -258,7 +258,8 @@ static bool __init efi_virtmap_init(void)
>> >>                */
>> >>               if (!is_normal_ram(md))
>> >>                       prot = __pgprot(PROT_DEVICE_nGnRE);
>> >> -             else if (md->type == EFI_RUNTIME_SERVICES_CODE)
>> >> +             else if (md->type == EFI_RUNTIME_SERVICES_CODE ||
>> >> +                      !PAGE_ALIGNED(md->phys_addr))
>> >>                       prot = PAGE_KERNEL_EXEC;
>> >
>> > This looks coarser than necessary. For memory organised like:
>> >
>> > 0x00000000 - 0x0000F000 (60KiB) : EFI_RUNTIME_SERVICES_CODE
>> > 0x0000F000 - 0x00020000 (68KiB) : EFI_RUNTIME_SERVICES_DATA
>> >
>> > We should be able to make the last 64K non-executable, but with this all
>> > 128K is executable, unless I've missed something?
>> >
>>
>> In theory, yes. But considering that
>>
>> a) this only affects 64 KB pages kernels, and
>> b) this patch is intended for -stable
>>
>> I chose to keep it simple and ignore this, and just relax the
>> permissions for any region that is not aligned to 64 KB.
>>
>> Since these regions are only mapped during Runtime Services calls, the
>> window for abuse is not that large.
>
> Ok, that does sound reasonable.
>
>> > Maybe we could do a two-step pass, first mapping the data as
>> > not-executable, then mapping any code pages executable (overriding any
>> > overlapping portions, but only for the overlapping parts).
>> >
>>
>> Let me have a go at that.
>
> Cheers!
>

OK so what we could do is the following:

------------8<--------------
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index e8ca6eaedd02..39fa2a70a7f1 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -233,6 +233,7 @@ void __init efi_init(void)
 static bool __init efi_virtmap_init(void)
 {
        efi_memory_desc_t *md;
+       u64 prev_end = 0;

        for_each_efi_memory_desc(&memmap, md) {
                u64 paddr, npages, size;
@@ -256,13 +257,26 @@ static bool __init efi_virtmap_init(void)
                 * executable, everything else can be mapped with the XN bits
                 * set.
                 */
-               if (!is_normal_ram(md))
+               if (!is_normal_ram(md)) {
                        prot = __pgprot(PROT_DEVICE_nGnRE);
-               else if (md->type == EFI_RUNTIME_SERVICES_CODE)
+               } else if (md->type == EFI_RUNTIME_SERVICES_CODE) {
                        prot = PAGE_KERNEL_EXEC;
-               else
+               } else {
+                       /*
+                        * If we are running with >4 KB pages and the current
+                        * region shares a page frame with the preceding one,
+                        * we should not map the leading page again since doing
+                        * so may take its executable permissions away.
+                        */
+                       if (PAGE_SIZE > EFI_PAGE_SIZE && paddr < prev_end) {
+                               paddr += PAGE_SIZE;
+                               size -= PAGE_SIZE;
+                               if (!size)
+                                       continue;
+                       }
                        prot = PAGE_KERNEL;
-
+               }
+               prev_end = paddr + size;
                create_pgd_mapping(&efi_mm, paddr, md->virt_addr, size, prot);
        }
        return true;
------------8<--------------

This will ensure that only the pages that are shared between 2 or more
regions may have their permissions upgraded, but only if any of these
regions requires it.

I prefer the much simpler previous version, though, and I think it is
more suitable for -stable. I can always follow up with an improvement
like this for v4.3-late.

>> >>               else
>> >>                       prot = PAGE_KERNEL;
>> >> diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
>> >> index e29560e6b40b..cb4e9c4de952 100644
>> >> --- a/drivers/firmware/efi/libstub/arm-stub.c
>> >> +++ b/drivers/firmware/efi/libstub/arm-stub.c
>> >> @@ -13,6 +13,7 @@
>> >>   */
>> >>
>> >>  #include <linux/efi.h>
>> >> +#include <linux/sort.h>
>> >
>> > Sort isn't an inline in this header. I thought it wasn't safe to call
>> > arbitary kernel functions from the stub?
>> >
>>
>> We call string functions, cache maintenance functions, libfdt
>> functions etc etc so it seems not everyone got the memo :-)
>>
>> I agree that treating vmlinux both as a static library and as a
>> payload from the stub's pov is a bit sloppy, and I do remember
>> discussing this, but for the life of me, I can't remember the exact
>> issue, other than the use of adrp/add and adrp/ldr pairs, which we
>> fixed by setting the PE/COFF section alignment to 4 KB.
>
> I only had a vague recollection that there was a problem, which I
> thought was more to do with potential use of absolute kernel virtual
> addresses, which would be incorrect in the context of an EFI
> application.
>

That was it, of course. Unlike the x86 stub, which is built with -fPIC
(as is the ARM decompressor, btw), the arm64 kernel is position
dependent. Fortunately, the small code model is mostly position
independent by default, but it would be good if we could spot any
problems at build time.

> Digging a bit, the stub code itself is safe due to commit
> f4f75ad5741fe033 ("efi: efistub: Convert into static library"), but that

libstub is linked into vmlinux so that does not make a different at all

> isn't necessarily true of anything it calls (libfdt uses callbacks in
> several places). I think the cache functions we call are all raw asm
> which is position-oblivious.
>

I remember looking into this when doing the BE port.

> We do seem to be ok so far, however. Maybe we just need to keep an eye
> out.
>

I'd much rather restrict the code that goes into the stub somehow than
deal with any absolute references. Perhaps we could reuse some of the
section mismatch code in some way to tag certain code as stub-safe and
do a verification pass on the binary.
