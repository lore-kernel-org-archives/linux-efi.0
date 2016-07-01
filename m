From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 1/2] efi: arm64: abort boot on pending SError
Date: Fri, 1 Jul 2016 17:31:33 +0200
Message-ID: <CAKv+Gu9Pk6xbUUMisAMhd4rpoYHA+wjzrZGkyEUXPdx_TaniVQ@mail.gmail.com>
References: <1467385291-9880-1-git-send-email-ard.biesheuvel@linaro.org>
 <20160701152252.GA17071@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20160701152252.GA17071@leverpostej>
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
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Catalin Marinas <catalin.marinas@arm.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Leif Lindholm <leif.lindholm@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On 1 July 2016 at 17:22, Mark Rutland <mark.rutland@arm.com> wrote:
> On Fri, Jul 01, 2016 at 05:01:30PM +0200, Ard Biesheuvel wrote:
>> It is the firmware's job to clear any pending SErrors before entering
>> the kernel. On UEFI, we can fail gracefully rather than panic during
>> early boot, so check for this condition in the stub.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> An SError could be triggered either asynchronously by FW, or as a result
> of our actions at any point after this, e.g. due to the filesystem
> accesses made to load an initrd.
>
> So in practice, is checking here useful? Have we seen FW with masked but
> pending SError at the point we enter the stub rather than that SError
> being triggered later,?
>

Yes. EDK2 keeps SError masked throughout its execution by default, and
so any condition that triggered an SError up till this point is likely
to still be pending, and blow up the kernel as soon as it unmasks it.

> I'm also not sure what this means for CPER, which may use SError to
> signal to the OS. It's possible that the UEFI implementation polls
> ISR_EL1 itself, and handles SError appropriately internally, or that the
> OS can later deal with the SError based on CPER and friends.
>

Currently, the kernel panics on an SError, and so what the kernel
should do once we start dealing with them in a more sophisticated way
is hypothetical at the moment. Once that code arrives, it may revert
this change, but for now, being dropped back into the UEFI shell does
sound more appealing than panic early imo.

>> ---
>>  drivers/firmware/efi/libstub/arm64-stub.c | 9 ++++++++-
>>  1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
>> index eae693eb3e91..c7e7396de876 100644
>> --- a/drivers/firmware/efi/libstub/arm64-stub.c
>> +++ b/drivers/firmware/efi/libstub/arm64-stub.c
>> @@ -20,7 +20,14 @@ extern bool __nokaslr;
>>
>>  efi_status_t check_platform_features(efi_system_table_t *sys_table_arg)
>>  {
>> -     u64 tg;
>> +     u64 tg, isr;
>> +
>> +     /* check for a pending SError */
>> +     asm ("mrs %0, isr_el1" : "=r"(isr));
>
> I think you can use read_sysreg(isr_el1) here, given that the
> read_sysreg helper is a macro function, and we already include sysreg.h
> here.
>

OK

>> +     if (isr & BIT(8)) {
>
> Perhaps add:
>
> #define ISR_EL1_A_BIT   BIT(8)
>
> to sysreg.h?
>

OK

>> +             pr_efi_err(sys_table_arg, "Pending SError detected -- aborting\n");
>> +             return EFI_LOAD_ERROR;
>> +     }
>
> Otherwise, code-wise this looks fine, but as above I'm not sure if this
> is the right thiing to do. :/
>

Yes, let's clear that up first.

-- 
Ard,
