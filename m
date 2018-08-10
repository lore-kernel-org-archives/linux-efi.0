From: Bhupesh Sharma <bhsharma@redhat.com>
Subject: Re: [PATCH V1 6/6] x86/efi: Introduce EFI_WARN_ON_ILLEGAL_ACCESSES
Date: Sat, 11 Aug 2018 00:00:41 +0530
Message-ID: <CACi5LpNESNVWFrfQLGi4-GehjO9GxV50sg7HUvxCHYS_z-yBGQ@mail.gmail.com>
References: <1533789077-16156-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1533789077-16156-7-git-send-email-sai.praneeth.prakhya@intel.com>
 <CACi5LpPcaiHEHV9cFm=C4UB23jmfie16VR4m3ZAkZ9bVis5Dqg@mail.gmail.com> <FFF73D592F13FD46B8700F0A279B802F47CDA91A@ORSMSX114.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <FFF73D592F13FD46B8700F0A279B802F47CDA91A@ORSMSX114.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "ricardo.ner@intel.com" <ricardo.ner@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Lee Chun-Yi <jlee@suse.com>, Al Stone <astone@redhat.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Aug 10, 2018 at 11:04 PM, Prakhya, Sai Praneeth
<sai.praneeth.prakhya@intel.com> wrote:
>> > +config EFI_WARN_ON_ILLEGAL_ACCESSES
>>
>> How about shortening the name to just 'EFI_WARN_ON_ILLEGAL_ACCESS'?
>>
>
> Makes sense.. I will shorten it.
>
>> > +       bool "Warn about illegal memory accesses by firmware"
>> > +       depends on EFI
>>
>> From a distribution p-o-v, I would suggest that we set this CONFIG option only if
>> we are in the EXPERT mode, as this need more thrashing with the behaviour we
>> see on old, buggy EFI firmwares available on very old x86 machines. So
>> something like:
>>            bool "Warn about illegal memory accesses by firmware" if EXPERT
>>
>
> Agreed. Although the feature is intended to warn about all these buggy firmware's
> instead of silently working around (as we are doing presently), it needs more testing.
> Hence, as you said, I think it's safe to have it as an EXPERT config option.
>
>> > +       help
>> > +         Enable this debug feature so that the kernel can detect illegal
>> > +         memory accesses by firmware and issue a warning. Also,
>> > +         1. If the illegally accessed region is EFI_BOOT_SERVICES_<CODE/DATA>,
>> > +            the kernel fixes it up by mapping the requested region.
>
> [....]
>
>> > diff --git a/init/main.c b/init/main.c index
>> > 3b4ada11ed52..dce0520861a1 100644
>> > --- a/init/main.c
>> > +++ b/init/main.c
>> > @@ -730,7 +730,8 @@ asmlinkage __visible void __init start_kernel(void)
>> >         arch_post_acpi_subsys_init();
>> >         sfi_init_late();
>> >
>> > -       if (efi_enabled(EFI_RUNTIME_SERVICES)) {
>> > +       if (efi_enabled(EFI_RUNTIME_SERVICES) &&
>> > +           !IS_ENABLED(CONFIG_EFI_WARN_ON_ILLEGAL_ACCESSES)) {
>>
>> Since this is an arch agnostic code leg, do we really want to introduce a generic
>> check for CONFIG_EFI_WARN_ON_ILLEGAL_ACCESSES
>> here, without checking for whether we are actually running this on a
>> x86 hardware, or alternatively we can consider moving
>> CONFIG_EFI_WARN_ON_ILLEGAL_ACCESSES out of 'arch/x86/Kconfig' to
>> 'arch/Kconfig' so that later it can be used on other archs like ARM64 as well.
>>
>> I think the later would be more useful..
>
> Thanks for bringing this up. I see your point. I will refrain from polluting architecture
> agnostic code. As we don't need efi_free_boot_services() at all, if EFI_WARN_ON_ILLEGAL_ACCESSES
> is enabled, probably making changes to include/linux/efi.h would be better, I guess..
>
> Moving this to arch/Kconfig could be too futuristic.. I guess.. because I am not sure
> if this problem exists on ARM machines, if so, probably Ard could suggest something here.

I think Ard can comment better but let me chime in with my limited
experience with Fedora arm64 implementations - we are already seeing
EFI firmware implementations which are broken/are orphaned (not well
supported anymore) on arm64 even though the hardware is still in-use.
With arm64 EFI firmware implementations still catching up with ARM
server SBBR specifications, we expect more x86 like broken EFI
implementations on arm64 as well. So, I don't see that as a distant
problem, in-fact this is something which has been on my Fedora to-do
list for arm64 for some time.

If there is a framework on x86 available, I can take a stab and
extrapolate it for arm64 as well.

Thanks,
Bhupesh
