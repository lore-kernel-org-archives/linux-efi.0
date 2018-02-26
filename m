From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 3/8] efi: Decode IA32/X64 Processor Error Info Structure
Date: Mon, 26 Feb 2018 16:04:33 +0000
Message-ID: <CAKv+Gu9zFXBtRMh8c5Jy-V=K+FTj2Z6n41QfO1PExjrWYs=8Hw@mail.gmail.com>
References: <20180223200333.6410-1-Yazen.Ghannam@amd.com> <20180223200333.6410-4-Yazen.Ghannam@amd.com>
 <CAKv+Gu_18==LT3eGPJh9Lveq_CWXwveBD4EYnTWvT7FbTtM_jg@mail.gmail.com> <DM5PR12MB191622BDE62D8C4F1031C015F8C10@DM5PR12MB1916.namprd12.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <DM5PR12MB191622BDE62D8C4F1031C015F8C10@DM5PR12MB1916.namprd12.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Ghannam, Yazen" <Yazen.Ghannam@amd.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>, the arch/x86 maintainers <x86@kernel.org>
List-Id: linux-efi@vger.kernel.org

On 26 February 2018 at 16:00, Ghannam, Yazen <Yazen.Ghannam@amd.com> wrote:
>> -----Original Message-----
>> From: Ard Biesheuvel [mailto:ard.biesheuvel@linaro.org]
>> Sent: Saturday, February 24, 2018 11:40 AM
>> To: Ghannam, Yazen <Yazen.Ghannam@amd.com>
>> Cc: linux-efi@vger.kernel.org; Linux Kernel Mailing List <linux-
>> kernel@vger.kernel.org>; Borislav Petkov <bp@suse.de>; the arch/x86
>> maintainers <x86@kernel.org>
>> Subject: Re: [PATCH 3/8] efi: Decode IA32/X64 Processor Error Info Structure
>>
> ...
>> >
>> > diff --git a/drivers/firmware/efi/cper-x86.c b/drivers/firmware/efi/cper-
>> x86.c
>> > index b50ee3cdf637..9d608f742c98 100644
>> > --- a/drivers/firmware/efi/cper-x86.c
>> > +++ b/drivers/firmware/efi/cper-x86.c
>> > @@ -4,15 +4,28 @@
>> >
>> >  #include <linux/cper.h>
>> >
>> > +#define INDENT_SP      " "
>> > +
>> >  /*
>> >   * We don't need a "CPER_IA" prefix since these are all locally defined.
>> >   * This will save us a lot of line space.
>> >   */
>> >  #define VALID_LAPIC_ID                 BIT_ULL(0)
>> >  #define VALID_CPUID_INFO               BIT_ULL(1)
>> > +#define VALID_PROC_ERR_INFO_NUM(bits)  ((bits & GENMASK_ULL(7, 2))
>> >> 2)
>> > +
>>
>> Parens around 'bits' please
>>
>
> Like this?
>
> #define VALID_PROC_ERR_INFO_NUM(bits)  (((bits) & GENMASK_ULL(7, 2)) >> 2)
>

Yes. Your code currently does not pass expressions into these, but it
is good form to use parens here to make them future proof

> I'll do the same for the others.
>

Cheers

>> > +#define INFO_VALID_CHECK_INFO          BIT_ULL(0)
>> > +#define INFO_VALID_TARGET_ID           BIT_ULL(1)
>> > +#define INFO_VALID_REQUESTOR_ID                BIT_ULL(2)
>> > +#define INFO_VALID_RESPONDER_ID                BIT_ULL(3)
>> > +#define INFO_VALID_IP                  BIT_ULL(4)
>> >
>> >  void cper_print_proc_ia(const char *pfx, const struct cper_sec_proc_ia
>> *proc)
>> >  {
>> > +       int i;
>> > +       struct cper_ia_err_info *err_info;
>> > +       char newpfx[64];
>> > +
>> >         printk("%sValidation Bits: 0x%016llx\n", pfx, proc->validation_bits);
>> >
>> >         if (proc->validation_bits & VALID_LAPIC_ID)
>> > @@ -23,4 +36,44 @@ void cper_print_proc_ia(const char *pfx, const struct
>> cper_sec_proc_ia *proc)
>> >                 print_hex_dump(pfx, "", DUMP_PREFIX_OFFSET, 16, 4, proc-
>> >cpuid,
>> >                                sizeof(proc->cpuid), 0);
>> >         }
>> > +
>> > +       snprintf(newpfx, sizeof(newpfx), "%s%s", pfx, INDENT_SP);
>> > +
>> > +       err_info = (struct cper_ia_err_info *)(proc + 1);
>> > +       for (i = 0; i < VALID_PROC_ERR_INFO_NUM(proc->validation_bits); i++)
>> {
>> > +               printk("%sError Information Structure %d:\n", pfx, i);
>> > +
>> > +               printk("%sError Structure Type: %pUl\n", newpfx,
>> > +                        &err_info->err_type);
>> > +
>>
>> The indentation is a bit awkward here. Could you please align followup
>> lines with the character following the ( on the first line?
>>
>
> Yes, will do.
>
>> > +               printk("%sValidation Bits: 0x%016llx\n",
>> > +                        newpfx, err_info->validation_bits);
>> > +
>> > +               if (err_info->validation_bits & INFO_VALID_CHECK_INFO) {
>> > +                       printk("%sCheck Information: 0x%016llx\n", newpfx,
>> > +                                err_info->check_info);
>> > +               }
>> > +
>> > +               if (err_info->validation_bits & INFO_VALID_TARGET_ID) {
>> > +                       printk("%sTarget Identifier: 0x%016llx\n",
>> > +                                newpfx, err_info->target_id);
>> > +               }
>> > +
>> > +               if (err_info->validation_bits & INFO_VALID_REQUESTOR_ID) {
>> > +                       printk("%sRequestor Identifier: 0x%016llx\n",
>> > +                                newpfx, err_info->requestor_id);
>> > +               }
>> > +
>> > +               if (err_info->validation_bits & INFO_VALID_RESPONDER_ID) {
>> > +                       printk("%sResponder Identifier: 0x%016llx\n",
>> > +                                newpfx, err_info->responder_id);
>> > +               }
>> > +
>> > +               if (err_info->validation_bits & INFO_VALID_IP) {
>> > +                       printk("%sInstruction Pointer: 0x%016llx\n",
>> > +                                newpfx, err_info->ip);
>> > +               }
>> > +
>> > +               err_info++;
>> > +       }
>> >  }
>> > --
>> > 2.14.1
>> >
